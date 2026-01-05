# 🚀 AI-Powered Development Environment

This repository provides a **ready-to-use GitHub Codespaces environment** with all AI tools and MCP (Model Context Protocol) servers pre-configured.

## ✨ Features

| Tool | Description |
|------|-------------|
| **GitHub Copilot** | AI pair programmer integrated into VS Code |
| **GitKraken MCP** | Git operations, GitHub/GitLab issues, pull requests |
| **Notion MCP** | Create/search Notion pages and databases |
| **Playwright MCP** | Browser automation and web scraping |
| **Docker MCP** | Container management from within the editor |
| **Context7** | Up-to-date library documentation |

## 🏃 Quick Start

### Option 1: Open in Codespaces (Recommended)
1. Click the green **"Code"** button above
2. Select **"Create codespace on main"**
3. Wait for the environment to build (~3-5 minutes first time)
4. Start coding with AI assistance!

### Option 2: Local Development
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ai-dev-environment.git
cd ai-dev-environment

# Open in VS Code with Dev Containers
code .
# Then: Ctrl+Shift+P -> "Dev Containers: Reopen in Container"
```

## 🔐 Setting Up Secrets

For full functionality, add these secrets to your Codespace:

1. Go to **GitHub Settings** → **Codespaces** → **Secrets**
2. Add the following:

| Secret Name | Where to Get It |
|-------------|-----------------|
| `NOTION_API_KEY` | [Notion Integrations](https://www.notion.so/my-integrations) |
| `GITKRAKEN_ACCESS_TOKEN` | GitKraken account settings |
| `OPENAI_API_KEY` | [OpenAI Platform](https://platform.openai.com/api-keys) (optional) |

## 📁 Project Structure

```
.
├── .devcontainer/
│   ├── devcontainer.json      # Codespace configuration
│   ├── setup-mcp.sh           # One-time installation script
│   └── start-mcp-servers.sh   # Startup script
├── .vscode/
│   ├── settings.json          # VS Code settings
│   └── extensions.json        # Recommended extensions
├── docs/
│   └── LOCAL_AGENT_BRIDGE.md  # Guide for local AI agent connection
├── CODESPACES_MIGRATION_PLAN.md
└── README.md
```

## 🔗 Connecting Local AI Agents

You can connect local CLI tools (like Gemini CLI, Aider, etc.) to this Codespace:

```powershell
# Install GitHub CLI on your local machine
winget install GitHub.cli

# Login to GitHub
gh auth login

# Connect to your Codespace
gh codespace ssh
```

See [docs/LOCAL_AGENT_BRIDGE.md](docs/LOCAL_AGENT_BRIDGE.md) for detailed instructions.

## 🛠️ Available Commands

Inside the Codespace terminal:

```bash
# Check MCP server status
cat ~/.config/mcp/servers.json

# Run Aider (AI coding assistant)
aider

# Check Docker containers
docker ps
```

## 📊 Resource Usage

| Component | RAM Usage |
|-----------|-----------|
| VS Code Server | ~500MB |
| MCP Servers | ~200MB total |
| Docker | ~300MB base |
| **Total** | ~1GB (handled by cloud) |

Your local machine only needs resources to run the VS Code client (~200MB).

## 🤝 Contributing

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - Feel free to use and modify!

---

**Built with ❤️ using GitHub Codespaces + Copilot + MCP**
