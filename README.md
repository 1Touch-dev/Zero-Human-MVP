# Zero-Human MVP Platform

This repository powers the automated **Zero-Human Paperclip MVP**, orchestrating the OpenClaw execution engine into a fully autonomous, 4-node Software Engineering department.

## 1. Agentic Architecture Hierarchy
Following the `Agentic_Engineering.pdf` specification, the Paperclip backend intercepts active tasks and triggers a highly secure Python proxy (`openclaw_bridge_cascade.py`) which delegates assignments seamlessly across four sequenced nodes:
1. **The Architect (Planner):** Ingests the initial Goal and structures the technical framework inside the sterile `/tmp/zero-human-sandbox/` directory.
2. **The Grunt (Developer):** Physically authors the source code files and executes local terminal validation scripts natively.
3. **The Pedant (QA Reviewer):** Scrutinizes the Grunt's output logic and runs rigorous code validation.
4. **The Scribe (Deployer):** Packages the code, authors documentation, handles `git commit`, and physically launches Pull Requests securely back to the production repository!

## 2. Multi-Tenant Automations (Phase 3 Backend)
The MVP utilizes dynamic Database Integrations to secure user access tokens statelessly! We do not globally hardcode `.netrc` passwords.

### Connecting Your GitHub Token to the RunPod
Because the token is securely queried from the PostgreSQL database during the Architect cascade, you must inject your Personal Access Token directly into the RunPod's database. To do this, simply copy and execute this exact SSH command from your local terminal (be sure to replace `YOUR_GITHUB_PAT`!):

```bash
ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_ed25519 -p 22168 root@194.68.245.210 << 'EOF'
su - paperclip -c "env PGPASSWORD=paperclip psql -h localhost -p 5433 -U paperclip -d paperclip -c \"INSERT INTO company_integrations (company_id, github_token) VALUES ('00000000-0000-0000-0000-000000000001', '<YOUR_GITHUB_PAT>') ON CONFLICT (company_id) DO UPDATE SET github_token = EXCLUDED.github_token;\""
EOF
```

- The pipeline natively intercepts this securely injected Token from the `company_integrations` table on-the-fly, pipes it into the Agentic Pipeline, and cleanly authenticates the GitHub API without permanently logging it in `.bashrc` files.

*(For debugging operations, you can also actively override the Database by forcefully pasting your Token string directly into `env["GITHUB_TOKEN"]` within `scripts/Python_Bridges/openclaw_bridge_cascade.py` and running `./scripts/sync_to_runpod.sh`).*

## 3. End-User Testing & Operations

### Dashboard UI Initiation
End-Users natively trigger the pipeline without touching terminals.
1. Navigate to the **Paperclip Web Dashboard**.
2. Click **New Issue** (or the **+** button).
3. Explicitly define the target goal indicating exactly which codebase repo it should touch (e.g. *"Clone https://github.com/.../sandbox.git. Build a new React Navigation Header. Open a Pull request."*).
4. **Assign the ticket to "The Architect"**. 
5. Sit back! The status will automatically cycle from `Todo` -> `In Progress` -> `Done` silently!

### Enforcing Strict Git Workflow Definitions
Because the pipeline's Bash execution container maintains physical `git push` access via the PAT token, **you must lock your repository** to enforce standardized DevOps.
- On Github, navigate to your target repository's **Settings -> Branches**.
- Secure the `main` branch by adding a protection rule requiring **"Require a pull request before merging"**.
- This physically bars the AI Agents from force-pushing untested code directly into production workflows, and structurally funnels them straight into automated `gh pr create` pull-request pipelines!

### Automated Headless Deployments
For automated QA testing without clicking the Dashboard, you can dynamically inject Goals directly into the server database via SSH:
```bash
ssh -p 22168 root@194.68.245.210 "su - paperclip -c 'env PGPASSWORD=paperclip psql -h localhost -p 5433 -U paperclip -d paperclip -c \"INSERT INTO issues ...\"'"
```

## 4. Live Synchronization (`sync_to_runpod.sh`)
This workspace is firmly linked to the deployed Pod framework. Whenever you structurally refine local files (like adjusting the internal agent prompts nested inside `openclaw_bridge_cascade.py` or building new `Database/` mappings):
```bash
./scripts/sync_to_runpod.sh
```
This utility parses your local changes, enforces Git ignores, and instantly mirrors the upgraded architecture to your cloud Execution Pod!
