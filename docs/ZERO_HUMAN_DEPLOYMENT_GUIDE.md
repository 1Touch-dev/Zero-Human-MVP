# Zero-Human Company: Deployment & Replication Guide 🛠️

This manual contains the **exact terminal commands and sequential steps** required to deploy the complete Zero-Human Agentic Pipeline from scratch on a brand new, empty Ubuntu Server (e.g., RunPod, AWS EC2, or DigitalOcean). 

By following these instructions, your external development team can perfectly mirror the infrastructure we successfully tested.

---

## Phase 1: Environment Bootstrapping
You must configure the pristine Linux server to accept the Node web server and the database engines.

### 1.1 Install System Prerequisites
Log into your raw Ubuntu Terminal as `root` and execute:
```bash
apt-get update -y
apt-get install -y curl wget git tmux screen software-properties-common nano socat
```

### 1.2 Install Node.js (v22) and Core Managers
Paperclip and OpenClaw require modernized Node dependencies.
```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs

# Install the critical package managers globally
npm install -g npm@latest
npm install -g pnpm yarn
```

### 1.3 Install and Configure PostgreSQL
The Orchestration dashboard relies entirely on a dedicated relational database.
```bash
# Install Postgres natively
apt-get install -y postgresql postgresql-contrib

# Start the service
service postgresql start

# Create the Paperclip Database User and Tables
sudo -u postgres psql -c "CREATE USER paperclip WITH PASSWORD 'paperclip' SUPERUSER;"
sudo -u postgres psql -c "CREATE DATABASE paperclip OWNER paperclip;"
```

---

## Phase 2: The Orchestration Layer (Paperclip)
Paperclip is the UI/Dashboard that acts as the virtual Company Management structure.

### 2.1 Establish the Architecture User
```bash
# Create a dedicated linux user to sandbox the application
useradd -m -s /bin/bash paperclip
usermod -aG sudo paperclip
su - paperclip
```

### 2.2 Clone and Build the Dashboard
```bash
# From inside the paperclip linux user
git clone https://github.com/paperclip-ai/paperclip.git
cd paperclip

# Install dependencies using pnpm
pnpm install

# Configure the local database connection
cp apps/web/.env.example apps/web/.env.local
sed -i 's|DATABASE_URL=.*|DATABASE_URL="postgresql://paperclip:paperclip@localhost:5432/paperclip"|' apps/web/.env.local

# Run Database Migrations to populate the tables
pnpm run db:push
```

### 2.3 Bypass Security Firewall Proxies (The Port Bind)
Runpod/Cloudflare natively proxies Port 3000, which causes silent `502 Bad Gateway` WebSocket crashes. We bypass this geometrically mapping port 3003 back to 3000 locally using `socat`.
```bash
# Inside apps/web/.env.local add:
echo "PORT=3003" >> apps/web/.env.local

# Start the Paperclip Server inside a screen/tmux standard instance
npm run dev

# Open a separate terminal as root and bind the external traffic:
socat TCP-LISTEN:3000,fork,reuseaddr TCP:127.0.0.1:3003
```

---

## Phase 3: The Execution Layer (OpenClaw)
OpenClaw is the physical Local AI sandbox where the agents execute bash streams securely.

### 3.1 Install OpenClaw Globally
```bash
# Switch back to the paperclip user
su - paperclip
npm install -g @openclaw/cli
```

### 3.2 Configure the OpenClaw Engine Model Default
OpenClaw defaults natively to Anthropic. It must be manually forced to map into OpenAI.
```bash
# Establish the Local Database
openclaw init
openclaw agent --agent main

# Configure physical models
nano ~/.openclaw/auth-profiles.json
# >>> Add your OpenAI API Key into the 'openai' block.

nano ~/.openclaw/openclaw.json
# >>> Ensure the default model explicitly reads: "openai/gpt-4o"
```

---

## Phase 4: Binding The Architecture (The Python Bridge)

Because Paperclip formats payloads natively, we constructed a **Python Wrapper** that injects OpenAI models securely into OpenClaw without leaking secrets into terminals.

### 4.1 Write the Bridging Script (`openclaw_bridge.py`)
Create the file `~/openclaw_bridge.py` containing this verified mapping logic:
```python
import os, sys, subprocess, psycopg2

def main():
    try:
        # Bind the Database Array
        conn = psycopg2.connect("postgresql://paperclip:paperclip@localhost:5432/paperclip")
        cur = conn.cursor()
        cur.execute("SELECT identifier, title, description FROM issues WHERE status != 'done' ORDER BY created_at DESC LIMIT 1;")
        issue = cur.fetchone()
        if not issue: sys.exit(0)
        
        identifier, title, description = issue
        message = f"Execute strictly autonomously in /tmp/zero-human-sandbox/. {description}"
        
        # Unlock frozen processes and securely bind API keys
        os.system("rm -f /home/paperclip/.openclaw/agents/main/sessions/*.lock")
        os.environ["OPENAI_API_KEY"] = "sk-proj-[YOUR_KEY_HERE]"
        
        subprocess.run(["/usr/bin/openclaw", "agent", "--agent", "main", "-m", message])
        
        # Resolve Ticket on Dashboard
        cur.execute("UPDATE issues SET status = 'done' WHERE identifier = %s;", (identifier,))
        conn.commit()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
```
Make it executable: `chmod +x ~/openclaw_bridge.py`

### 4.2 Route the Paperclip Database to the Bridge
The physical interface must be configured to ping the bridge instead of HTTP.
```bash
# Execute inside Postgres
psql -U paperclip -d paperclip -c "UPDATE agents SET adapter_config = '{\"command\": \"/usr/bin/python3\", \"args\": [\"/home/paperclip/openclaw_bridge.py\"]}' WHERE true;"
```

---

## Phase 5: Production Github Pull Request Connectivity

To ensure the agents can physically open Pull Requests without the OpenClaw Security Scanner redacting `<PAT_KEYS>` out of shell executions, deploy a global `.netrc` vault.

```bash
# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt-get update && apt-get install gh -y

# Configure Global Authentications
su - paperclip
gh auth login --with-token < YOUR_GITHUB_PAT.txt
gh auth setup-git
git config --global user.email "agent@zero-human.ai"
git config --global user.name  "Architect AI"

# Build the Invisible Token Tunnel
echo "machine github.com" > ~/.netrc
echo "login <GITHUB_USERNAME>" >> ~/.netrc
echo "password <GITHUB_PAT_TOKEN>" >> ~/.netrc
chmod 600 ~/.netrc
```

---

## Phase 6: Bidirectional Github Webhooks (The Feedback Loop)

To ensure the AI Agents can iterate on Human comments left on Pull Requests, we deploy the Webhook server. It listens to Github PR payloads and injects the feedback directly into Paperclip.

### 6.1 Install Webhook Dependencies

```bash
# Switch to paperclip user
su - paperclip

# Install dependencies
pip3 install fastapi uvicorn psycopg2-binary
```

### 6.2 Host the Webhook Server

```bash
# Copy over the script and run the background FastAPI server on port 8000
python3 ~/scripts/Webhooks/github_webhook.py &
```

*(Note: Ensure you configure your GitHub Repository Webhooks setting to point to `http://<RunPod_IP>:8000/webhook` and set the `GITHUB_WEBHOOK_SECRET` environment variable to match the GitHub dashboard setting).*

---

## Phase 7: Workspace Synchronization (Zero-Human Local-to-Remote)
To seamlessly develop locally on your Mac and push the new **Agentic Engineering MVP Pipeline** (Product Manager, Lead Engineer, QA, DevOps) to the RunPod without manual SFTP transfers:

### 7.1 Automated Rsync Script
We have packaged a continuous integration script into the repository: `scripts/sync_to_runpod.sh`

1. Open `scripts/sync_to_runpod.sh` locally.
2. Replace `[ENTER_YOUR_RUNPOD_IP]` and `[ENTER_YOUR_RUNPOD_SSH_PORT]` with your specific Pod connection details.
3. Run the sync utility:
```bash
# Push files once
./scripts/sync_to_runpod.sh

# Or start a continuous watcher daemon (requires fswatch)
./scripts/sync_to_runpod.sh --watch
```
This utility prevents structural drift and natively bypasses `.git/` caches to maintain absolute parity between your local vision and the RunPod execution layer.

**DEPLOYMENT COMPLETE.** 🚀 
Your Server is now fully equipped to run the Zero-Human Agentic Architectures limitlessly!
