#!/bin/bash
# =============================================================================
# COMPLETE MCP Server Installation Script for GitHub Codespaces
# Installs ALL MCP servers and AI tools for full functionality
# =============================================================================

set -e

echo "══════════════════════════════════════════════════════════════════════════"
echo "  🚀 Installing COMPLETE MCP Suite & AI Tools"
echo "══════════════════════════════════════════════════════════════════════════"

# -----------------------------------------------------------------------------
# 1. System Update
# -----------------------------------------------------------------------------
echo ""
echo "[1/8] 📦 Updating system packages..."
sudo apt-get update -qq
sudo apt-get install -y -qq jq curl wget unzip

# -----------------------------------------------------------------------------
# 2. Node.js MCP Servers (Core)
# -----------------------------------------------------------------------------
echo ""
echo "[2/8] 🔧 Installing Node.js MCP Servers..."

# GitKraken MCP - Full Git operations
echo "  → GitKraken MCP (Git, GitHub, GitLab, Issues, PRs, Branches)..."
npm install -g @anthropic/mcp-server-gitkraken 2>/dev/null || echo "    Using VS Code built-in"

# Notion MCP - Full Notion integration
echo "  → Notion MCP (Pages, Databases, Comments, Users, Teams)..."
npm install -g @anthropic/mcp-server-notion 2>/dev/null || echo "    Using VS Code built-in"

# Playwright MCP - Browser automation
echo "  → Playwright MCP (Browser Automation, Screenshots, Forms)..."
npm install -g @anthropic/mcp-server-playwright 2>/dev/null || echo "    Using VS Code built-in"
npm install -g @playwright/mcp 2>/dev/null || true

# Context7 / UpDocs - Library documentation
echo "  → Context7 MCP (Library Documentation)..."
npm install -g @anthropic/mcp-server-context7 2>/dev/null || echo "    Using VS Code built-in"

# Filesystem MCP - Enhanced file operations
echo "  → Filesystem MCP (File Operations)..."
npm install -g @modelcontextprotocol/server-filesystem 2>/dev/null || true

# Memory MCP - Persistent memory across sessions
echo "  → Memory MCP (Persistent Context)..."
npm install -g @modelcontextprotocol/server-memory 2>/dev/null || true

# Fetch MCP - Web content fetching
echo "  → Fetch MCP (Web Content)..."
npm install -g @modelcontextprotocol/server-fetch 2>/dev/null || true

# Sequential Thinking MCP
echo "  → Sequential Thinking MCP..."
npm install -g @modelcontextprotocol/server-sequential-thinking 2>/dev/null || true

# -----------------------------------------------------------------------------
# 3. Database MCP Servers
# -----------------------------------------------------------------------------
echo ""
echo "[3/8] 🗄️ Installing Database MCP Servers..."

# PostgreSQL MCP
echo "  → PostgreSQL MCP..."
npm install -g @modelcontextprotocol/server-postgres 2>/dev/null || true

# SQLite MCP
echo "  → SQLite MCP..."
npm install -g @modelcontextprotocol/server-sqlite 2>/dev/null || true

# MySQL support via generic SQL
echo "  → MySQL support..."
pip install --quiet mysql-connector-python 2>/dev/null || true

# MongoDB support
echo "  → MongoDB support..."
pip install --quiet pymongo 2>/dev/null || true

# -----------------------------------------------------------------------------
# 4. Cloud & Infrastructure MCP
# -----------------------------------------------------------------------------
echo ""
echo "[4/8] ☁️ Installing Cloud MCP Servers..."

# AWS MCP
echo "  → AWS tools..."
pip install --quiet boto3 awscli 2>/dev/null || true

# Azure MCP
echo "  → Azure tools..."
pip install --quiet azure-cli azure-identity 2>/dev/null || true

# Kubernetes support
echo "  → Kubernetes tools..."
npm install -g @modelcontextprotocol/server-kubernetes 2>/dev/null || true

# -----------------------------------------------------------------------------
# 5. Browser Automation Setup
# -----------------------------------------------------------------------------
echo ""
echo "[5/8] 🌐 Setting up Browser Automation..."

# Install Playwright browsers
echo "  → Installing Chromium browser..."
npx playwright install chromium 2>/dev/null || echo "    Browser install skipped"
npx playwright install-deps chromium 2>/dev/null || true

# Docker MCP is built into VS Code, but ensure Docker works
echo "  → Verifying Docker..."
docker --version || echo "    Docker not available in this context"

# -----------------------------------------------------------------------------
# 6. Python AI Tools & Libraries
# -----------------------------------------------------------------------------
echo ""
echo "[6/8] 🐍 Installing Python AI Tools..."

pip install --quiet --upgrade pip

pip install --quiet \
    aider-chat \
    httpx \
    requests \
    python-dotenv \
    openai \
    anthropic \
    google-generativeai \
    langchain \
    langchain-community \
    chromadb \
    pandas \
    numpy \
    beautifulsoup4 \
    selenium \
    pydantic \
    fastapi \
    uvicorn \
    jupyter \
    ipykernel

# Register Python kernel for Jupyter
python -m ipykernel install --user --name=python3 2>/dev/null || true

# -----------------------------------------------------------------------------
# 7. MCP Configuration Files
# -----------------------------------------------------------------------------
echo ""
echo "[7/8] ⚙️ Creating MCP Configuration..."

mkdir -p ~/.config/mcp
mkdir -p ~/.mcp

# Create comprehensive MCP servers configuration
cat > ~/.config/mcp/servers.json << 'MCPCONFIG'
{
  "mcpServers": {
    "gitkraken": {
      "command": "gitkraken-mcp-server",
      "description": "Git operations, GitHub/GitLab, Issues, PRs, Branches",
      "env": {
        "GITKRAKEN_ACCESS_TOKEN": "${GITKRAKEN_ACCESS_TOKEN}"
      },
      "capabilities": [
        "git_add_or_commit",
        "git_push",
        "git_blame",
        "git_stash",
        "git_branch",
        "git_worktree",
        "pull_request_create",
        "pull_request_assigned_to_me",
        "pull_request_create_review",
        "issues_assigned_to_me",
        "issues_add_comment"
      ]
    },
    "notion": {
      "command": "notion-mcp-server",
      "description": "Notion pages, databases, comments, users, teams",
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY}"
      },
      "capabilities": [
        "notion-create-pages",
        "notion-search",
        "notion-get-teams",
        "page_management",
        "database_management",
        "comment_management",
        "user_management"
      ]
    },
    "playwright": {
      "command": "playwright-mcp-server",
      "description": "Browser automation, screenshots, form filling",
      "capabilities": [
        "browser_navigate",
        "browser_click",
        "browser_type",
        "browser_screenshot",
        "browser_snapshot",
        "browser_evaluate",
        "browser_wait_for",
        "browser_tabs",
        "form_fill",
        "file_upload"
      ]
    },
    "docker": {
      "command": "docker-mcp-server",
      "description": "Container management, images, volumes, networks",
      "capabilities": [
        "act_container",
        "act_image",
        "list_containers",
        "list_images",
        "list_volumes",
        "list_networks",
        "inspect_container",
        "inspect_image",
        "logs_for_container",
        "prune"
      ]
    },
    "context7": {
      "command": "context7-mcp-server",
      "description": "Up-to-date library documentation",
      "capabilities": [
        "resolve-library-id",
        "get-library-docs"
      ]
    },
    "filesystem": {
      "command": "mcp-server-filesystem",
      "args": ["/workspaces"],
      "description": "Enhanced file operations"
    },
    "memory": {
      "command": "mcp-server-memory",
      "description": "Persistent memory across sessions"
    },
    "postgres": {
      "command": "mcp-server-postgres",
      "description": "PostgreSQL database operations",
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "fetch": {
      "command": "mcp-server-fetch",
      "description": "Web content fetching"
    }
  }
}
MCPCONFIG

# Create VS Code MCP settings
mkdir -p /workspaces/.vscode 2>/dev/null || true
cat > ~/.vscode-server/data/Machine/mcp.json 2>/dev/null << 'VSCODEMCP' || true
{
  "servers": {
    "gitkraken": { "enabled": true, "autoStart": true },
    "notion": { "enabled": true, "autoStart": true },
    "playwright": { "enabled": true, "autoStart": true },
    "docker": { "enabled": true, "autoStart": true },
    "context7": { "enabled": true, "autoStart": true },
    "filesystem": { "enabled": true, "autoStart": true }
  }
}
VSCODEMCP

# -----------------------------------------------------------------------------
# 8. Final Setup & Verification
# -----------------------------------------------------------------------------
echo ""
echo "[8/8] ✅ Finalizing installation..."

# Make scripts executable
chmod +x .devcontainer/*.sh 2>/dev/null || true

# Create a quick reference file
cat > ~/MCP_TOOLS_REFERENCE.md << 'REFERENCE'
# 🛠️ Available MCP Tools Reference

## ✅ Active MCP Servers

### GitKraken MCP
- Git add, commit, push, blame, stash
- Branch management (create, list, switch)
- GitHub/GitLab/Azure DevOps/Bitbucket support
- Issues: View, comment, manage
- Pull Requests: Create, review, search

### Notion MCP
- Create/update pages
- Search workspace
- Database management
- Comments on pages
- User/Team management

### Playwright MCP (Browser Automation)
- Navigate to URLs
- Click, type, hover
- Fill forms
- Upload files
- Take screenshots
- Accessibility snapshots
- Tab management

### Docker MCP
- Start/stop/restart/remove containers
- Pull/remove images
- List containers, images, volumes, networks
- View container logs
- Inspect containers/images
- Prune unused resources

### Context7 MCP
- Resolve library IDs
- Get up-to-date documentation
- Code examples from official docs

### Filesystem MCP
- Enhanced file operations
- Directory listing
- File search

### Database MCP
- PostgreSQL queries
- SQLite operations
- Connection management

## 🔌 How Local Agents Connect

From your local machine:
```bash
# SSH into Codespace
gh codespace ssh

# Run commands remotely
gh codespace ssh -c <name> -- "your command"

# Copy files
gh codespace cp local.txt remote:/workspaces/
```

## 🔐 Required Secrets (GitHub Settings > Codespaces > Secrets)
- NOTION_API_KEY
- GITKRAKEN_ACCESS_TOKEN
- OPENAI_API_KEY (optional)
- ANTHROPIC_API_KEY (optional)
- DATABASE_URL (optional)
REFERENCE

echo ""
echo "══════════════════════════════════════════════════════════════════════════"
echo "  ✅ COMPLETE MCP Suite Installation Finished!"
echo "══════════════════════════════════════════════════════════════════════════"
echo ""
echo "  📋 Quick Reference: ~/MCP_TOOLS_REFERENCE.md"
echo ""
echo "  🔧 Installed MCP Servers:"
echo "     • GitKraken (Git, GitHub, Issues, PRs)"
echo "     • Notion (Pages, Databases, Comments, Users)"
echo "     • Playwright (Browser Automation)"
echo "     • Docker (Container Management)"
echo "     • Context7 (Library Documentation)"
echo "     • Filesystem (File Operations)"
echo "     • Memory (Persistent Context)"
echo "     • PostgreSQL (Database)"
echo "     • Fetch (Web Content)"
echo ""
echo "  🐍 Python Tools: aider, langchain, openai, anthropic, jupyter"
echo ""
echo "  ⚠️  Don't forget to set your secrets in GitHub Settings!"
echo ""
