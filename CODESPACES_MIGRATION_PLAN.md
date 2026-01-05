# Comprehensive Implementation Plan: Migrating AI & MCP Workflow to GitHub Codespaces

## 1. Executive Summary
**Goal:** Migrate local development workflow to GitHub Codespaces to offload RAM usage, centralize AI tool execution, and enable seamless interaction between local agents and remote resources.
**Target Architecture:**
- **Client:** Low-spec laptop running VS Code (Frontend) + Local AI Agents (CLI).
- **Host:** GitHub Codespaces (Cloud VM) running VS Code Server, MCP Servers, Docker, and Language Runtimes.
- **Bridge:** SSH Tunneling via GitHub CLI (`gh`) for local agent connectivity.

---

## 2. Architecture Overview

```mermaid
graph TD
    subgraph "Local Machine (Laptop)"
        A[VS Code Client]
        B[Local AI Agents (Gemini CLI, etc.)]
        C[GitHub CLI (gh)]
    end

    subgraph "GitHub Codespace (Cloud)"
        D[VS Code Server]
        E[GitHub Copilot]
        F[MCP Gateway / Host]
        
        subgraph "MCP Servers"
            G[GitKraken MCP]
            H[Notion MCP]
            I[Browser/Playwright MCP]
            J[Docker MCP]
        end
        
        K[Project Source Code]
    end

    A <-->|HTTPS/WebSocket| D
    B <-->|SSH Tunnel| K
    C -->|Auth & Connection| D
    D <--> F
    F <--> G & H & I & J
    E <--> F
```

---

## 3. Implementation Steps

### Phase 1: Repository Preparation (The "Source of Truth")
We will create a dedicated configuration in your repository to define the environment.

1.  **Create `.devcontainer` Directory**:
    Create a folder named `.devcontainer` at the root of your project.

2.  **Create `devcontainer.json`**:
    This file tells GitHub how to build your cloud computer.

    ```json
    {
      "name": "AI-Powered Dev Environment",
      "image": "mcr.microsoft.com/devcontainers/universal:2",
      "features": {
        "ghcr.io/devcontainers/features/docker-in-docker:2": {},
        "ghcr.io/devcontainers/features/node:1": {},
        "ghcr.io/devcontainers/features/python:1": {},
        "ghcr.io/devcontainers/features/github-cli:1": {}
      },
      "customizations": {
        "vscode": {
          "extensions": [
            "GitHub.copilot",
            "GitHub.copilot-chat",
            "ms-azuretools.vscode-docker",
            "gitkraken.gitkraken-authentication"
          ],
          "settings": {
            "github.copilot.enable": {
              "*": true
            }
          }
        }
      },
      "postCreateCommand": "bash .devcontainer/setup-mcp.sh",
      "remoteUser": "codespace"
    }
    ```

### Phase 2: MCP Server Installation Script
Create a script `.devcontainer/setup-mcp.sh` to automatically install your tools when the Codespace starts.

```bash
#!/bin/bash
echo "Installing MCP Servers..."

# 1. Install Node.js based MCPs
npm install -g @modelcontextprotocol/server-gitkraken
npm install -g @modelcontextprotocol/server-notion
npm install -g @modelcontextprotocol/server-playwright

# 2. Install Python based MCPs (if any)
# pip install some-mcp-server

echo "MCP Servers Installed."
```

### Phase 3: Configuring MCP in Codespaces
You need to tell VS Code where to find these servers *inside* the cloud container.
Create or update `.vscode/mcp-config.json` (or the specific config file for your MCP extension):

```json
{
  "mcpServers": {
    "gitkraken": {
      "command": "gitkraken-mcp-server",
      "args": []
    },
    "notion": {
      "command": "notion-mcp-server",
      "env": {
        "NOTION_API_KEY": "${env:NOTION_API_KEY}"
      }
    }
  }
}
```
*Note: You will set the actual API keys in GitHub Codespaces "Secrets" settings, not in the file.*

### Phase 4: Connecting Local AI Agents
This enables your local "Gemini CLI" or other tools to talk to the cloud.

1.  **Install GitHub CLI (Local)**:
    Download and install `gh` on your laptop.
    Run: `gh auth login`

2.  **SSH Configuration**:
    Run this command on your laptop to generate an SSH config for your active Codespace:
    ```powershell
    gh codespace ssh --config > ~/.ssh/config_codespaces
    ```
    *Include this file in your main `~/.ssh/config`.*

3.  **Connecting a Local Agent**:
    If your local agent needs to run a command in the cloud:
    ```powershell
    ssh codespace_name "npm run build"
    ```
    If your local agent needs to edit a file:
    It can use SCP or simply mount the remote folder as a network drive using `sshfs`.

---

## 4. Migration Checklist

- [ ] **Backup**: Push all current local code to GitHub.
- [ ] **Secrets**: Go to GitHub Repo Settings -> Secrets and Variables -> Codespaces. Add:
    - `NOTION_API_KEY`
    - `OPENAI_API_KEY` (if needed)
    - `GITKRAKEN_ACCESS_TOKEN`
- [ ] **Launch**: Click "Code" -> "Create Codespace on main".
- [ ] **Verify**:
    - Open VS Code in the Codespace.
    - Check if Copilot is active.
    - Check if MCP servers are running (look at output logs).
- [ ] **Local Connect**: Test `gh codespace ssh` from your laptop terminal.

## 5. Maintenance & Troubleshooting

- **Rebuild Container**: If you add a new MCP tool to `setup-mcp.sh`, you must run "Rebuild Container" in Codespaces for it to take effect.
- **Port Forwarding**: If a tool starts a web server on port 3000, use the "Ports" tab in VS Code to forward it to your laptop so you can see it at `localhost:3000`.
- **Resource Monitoring**: Use the command `top` inside the Codespace terminal to check RAM usage of your agents.
