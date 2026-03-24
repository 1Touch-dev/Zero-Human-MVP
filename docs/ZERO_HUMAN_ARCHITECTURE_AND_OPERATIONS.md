# Zero-Human Pipeline: Architecture & Operations Manual

This document serves as the comprehensive engineering guide for operating, configuring, and scaling the Zero-Human Autonomous Pipeline. It details the system architecture, infrastructure provisioning, security matrices, and low-level debugging sequences required to maintain the platform structurally without relying on hidden configurations.

---

## 1. System Architecture Overview

The Zero-Human platform is split into two primary orchestration layers that communicate natively across the internal operating system framework:

### The Brain: Paperclip Web Interface
*   **Frontend UI:** A Next.js/React dashboard where Product Managers and Engineers define automated Issues securely.
*   **Backend Node Daemon (`paperclipai run`):** A continuously running web server acting as the root watcher that listens for incoming Goal definitions and schedules the Agentic Pipeline.
*   **PostgreSQL Database:** The central nervous subsystem securely storing all Users, Integrations, AI Profiles, and `heartbeat_runs` execution traces natively on the pod.

### The Hands: OpenClaw Execution Engine
*   **The CLI Agent:** The core binary application (`openclaw agent`) explicitly invoked natively by the Paperclip daemon to bridge LLM reasoning iterations accurately onto the filesystem.
*   **The Python Integrations:** Custom routing scripts (`openclaw_bridge_cascade.py`) architected to logically structure the Agent roles sequentially (Architect to Grunt to Pedant to Scribe).
*   **The Execution Sandbox:** The physical storage layout (`/tmp/zero-human-sandbox/`) perpetually wiped clean where agents iteratively clone upstream GitHub repositories, author dynamic frontend code, and compile tests autonomously without overwriting internal framework dependencies.

When an Issue is submitted on the Paperclip UI, the internal Node backend extracts the prompt, loads its current environment, and explicitly schedules the OpenClaw child process entirely autonomously against the target sandbox.

---

## 2. Infrastructure & Environment (RunPod)

The physical compute processing is structurally sequestered entirely onto a dedicated remote cloud container (RunPod). This structurally protects host development devices by proxying physical remote GitHub authentications and trapping any arbitrary Python CLI executions originating from hallucinating Agents.

### Secure SSH Access
To administratively connect to the RunPod cloud node and query telemetry, explicitly map a secure shell originating from your local terminal utilizing the authorized deployment key:
```bash
ssh -o StrictHostKeyChecking=no -p 22168 -i ~/.ssh/id_ed25519 root@194.68.245.210
```

### Isolation Boundary (The Agent User)
For rigid system security, the AI engines do **not** run globally as Root. All Git logic authorizations, Token API injections, and repository cloning procedures must exclusively and organically be performed by the `paperclip` subsystem user.
Once originally logged into the RunPod root, you must immediately transition your execution profile before modifying logic:
```bash
su - paperclip
```

---

## 3. Security & Configuration Matrices

We rely completely on a statelessly injected **Environment File (`.env`)** to map API permissions directly into the Execution and Application clusters simultaneously. 
> ⚠️ **CRITICAL POLICY:** We expressly ban maintaining physical `~/.netrc` credentials arrays anywhere for Git authorization caching, as persistent Node daemons aggressively ignore standard filesystem hierarchy overrides upon daemon initialization natively.

### The `.env` Security Payload
To effectively link the UI server and Agents remotely, you conditionally overwrite your tracked local `Zero-Human-MVP/.env` file with the exact target endpoints identical to this template profile:
```bash
OPENAI_API_KEY="sk-proj-YOUR_KEY"
GITHUB_TOKEN="github_pat_YOUR_TOKEN"
OPENCLAW_MODEL="openai/gpt-4o"  # Options include "openai/gpt-5.4", "anthropic/claude-3.5-sonnet", etc.
```

1. **GitHub Token Properties:** The `GITHUB_TOKEN` target must exclusively utilize an unexpired, traditional **Personal Access Token (PAT)** maintaining sweeping Read/Write capacities enabling the OpenClaw container to logically author isolated feature branches and systematically push codebase iterations forcefully onto remote production Origins completely unimpeded.
2. **Dynamic Authentication Triggers (`gh pr create`):** The system strictly mandates native integrations with the generic GitHub CLI toolset (`gh`). OpenClaw inherently parses and extracts `$GITHUB_TOKEN` values explicitly from the root `.env` envelope variables mapping memory, allowing recursive validations securely bypassing any lingering 403 Git Push limitations permanently.

---

## 4. Service Operations & Reloads

If an administrating engineer modifies `.env` configuration matrices locally on targeting architectures, they **must** systematically propagate those structural keys into the continuous Cloud Daemon immediately! Failure to execute identical reloads forces the isolated OpenClaw agents firing from Paperclip to blindly inherit cached executions resulting in unauthorized loops and failing ticket closures permanently.

### 1. Synchronizing the Application Repository
First, push the organically altered repository modules precisely coupled alongside the active `.env` matrix over SSH dynamically linking RunPod paths:
```bash
./scripts/sync_to_runpod.sh
```

### 2. Restarting the Dashboard Node Daemon
Because the native Paperclip Web UI daemon (`npx paperclipai run`) sequentially caches its physical execution environment variables precisely on initial process boot times locally, it inherently and explicitly ignores incoming `.env` file synchronizations permanently until it undergoes an explicit soft-rebooting cycle.
Therefore, manually force the isolated service to re-inhale your revised Security Tokens identically resolving asynchronous gaps:
```bash
./scripts/Shell_Execution/restart_dashboard.sh
```

---

## 5. Executing Workloads via Paperclip UI

The Platform enables non-technical Managers to successfully author logic frameworks purely strictly through unstructured linguistic definition prompts natively mapped via the Interface.

### 1. Generating a Task
1. Structurally log in to the external Paperclip Web Application natively.
2. Click **New Issue**.
3. Clearly specify exact functional parameters outlining explicitly what libraries, formatting structures, or logical dependencies the LLM is expected to structurally enforce.

### 2. The Critical Native Automation Prompt Standard
Because OpenClaw relies entirely on Terminal CLI execution logic wrappers dynamically catching string parameters natively, executing organic unstructured `gh pr create` commands will freeze the agent entirely, endlessly halting upon invisible interactive terminal `[Yes/No]` query matrices organically!
**As a mandatory requirement, you absolutely MUST append exactly replicated explicit CLI behavior flags encompassing the Prompt Description block below perfectly structurally:**
> *"Clone https://github.com/YourOrg/YourTargetRepository.git. Write the application. Run git branch, git add ., git commit -m 'Release', and git push. Crucially, you MUST run exactly: `gh pr create --head YOUR-FEATURE-BRANCH --title 'Automated Feature Release' --body 'Generated completely via AI Pipeline Architectures'`. Do NOT trigger any interactive terminal processes."*

### 3. Execution Pipeline Transition
* Directly assign the Ticket organically sequentially linking to **"The Architect"**.
* The platform automatically spins a thread silently natively iterating `git checkout` features autonomously tracking internal logic down into standard user Pull Requests securely identically mapping human procedures without manual oversight organically.

---

## 6. Diagnostics & Telemetry Constraints

If an organically driven native code deployment organically cascades into localized structural crashes asynchronously, Systems Administrators natively rely strictly upon precise diagnostic arrays targeting backend physical traces to isolate origin loops.

### Inspecting Internal UI Trigger Datasets (PostgreSQL)
If a ticket mathematically freezes permanently logging natively onto "Todo" sequences completely without structurally invoking the targeted physical LLMs perfectly:
```bash
# Verify the underlying status queue states organically tracing native background database limits recursively:
# Run rigidly logged as the isolated `paperclip` Linux subsystem wrapper!
psql -d paperclip -x -c "SELECT id, identifier, status, title FROM issues ORDER BY created_at DESC LIMIT 5;"
```

### Deciphering the Execution Terminal Dumps (OpenClaw)
If the Node Web Application successfully stamps an initial task "Done" natively natively but absolutely zero remote logic or branch generation cascades into the GitHub targets physically, OpenClaw crashed natively internally trapped behind prompt interactions exclusively within its organic terminal. Extract the explicit physical Bash IO outputs systematically via the active JSON structural trace instances exclusively:
```bash
# Dump the raw terminal loop precisely from the absolutely terminal edge sequence isolating execution errors reliably natively:
# Run rigidly logged as the isolated `paperclip` Linux subsystem wrapper!
cat $(ls -t ~/.openclaw/agents/main/sessions/*.json | head -1) | grep -C 5 -i github
```

### Manual Node Telemetry Triggers
To seamlessly force native container tasks strictly untethered from asynchronous local Paperclip Web UI scheduling daemons seamlessly capturing completely identical runtime logic arrays physically native mapping execution parameters precisely:
```bash
# Run rigidly logged as the isolated `paperclip` Linux subsystem wrapper!
python3 /home/paperclip/Zero-Human-MVP/scripts/Python_Bridges/openclaw_bridge_cascade.py
```
