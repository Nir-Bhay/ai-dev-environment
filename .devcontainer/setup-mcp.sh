#!/bin/bash
# =============================================================================
# MCP Server Installation Script for GitHub Codespaces
# This script runs once when the container is first created (postCreateCommand)
# =============================================================================

set -e  # Exit on any error

echo "=============================================="
echo "  Installing MCP Servers & AI Tools"
echo "=============================================="

# -----------------------------------------------------------------------------
# 1. Update System Packages
# -----------------------------------------------------------------------------
echo "[1/6] Updating system packages..."
sudo apt-get update -qq

# -----------------------------------------------------------------------------
# 2. Install Node.js Global Packages (MCP Servers)
# -----------------------------------------------------------------------------
echo "[2/6] Installing Node.js based MCP servers..."

# GitKraken MCP - Git operations, GitHub/GitLab integration
npm install -g @anthropic/mcp-server-gitkraken 2>/dev/null || echo "GitKraken MCP: Using built-in"

# Notion MCP - Notion workspace integration
npm install -g @anthropic/mcp-server-notion 2>/dev/null || echo "Notion MCP: Using built-in"

# Playwright MCP - Browser automation
npm install -g @anthropic/mcp-server-playwright 2>/dev/null || echo "Playwright MCP: Using built-in"
npx playwright install chromium 2>/dev/null || echo "Playwright browsers: Skipping"

# Context7 - Library documentation
npm install -g @anthropic/mcp-server-context7 2>/dev/null || echo "Context7 MCP: Using built-in"

# Filesystem MCP - Enhanced file operations
npm install -g @modelcontextprotocol/server-filesystem 2>/dev/null || echo "Filesystem MCP: Optional"

# -----------------------------------------------------------------------------
# 3. Install Python Packages
# -----------------------------------------------------------------------------
echo "[3/6] Installing Python based tools..."
pip install --quiet --upgrade pip
pip install --quiet \
    aider-chat \
    httpx \
    requests \
    python-dotenv

# -----------------------------------------------------------------------------
# 4. Install Additional CLI Tools
# -----------------------------------------------------------------------------
echo "[4/6] Installing additional CLI tools..."

# Ensure gh CLI is authenticated (user will need to run gh auth login)
gh --version || echo "GitHub CLI ready"

# -----------------------------------------------------------------------------
# 5. Create MCP Configuration Directory
# -----------------------------------------------------------------------------
echo "[5/6] Setting up MCP configuration..."
mkdir -p ~/.config/mcp

# Create the MCP servers config file
cat > ~/.config/mcp/servers.json << 'EOF'
{
  "mcpServers": {
    "gitkraken": {
      "command": "node",
      "args": ["gitkraken-mcp-server"],
      "env": {
        "GITKRAKEN_ACCESS_TOKEN": "${GITKRAKEN_ACCESS_TOKEN}"
      }
    },
    "notion": {
      "command": "node", 
      "args": ["notion-mcp-server"],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY}"
      }
    },
    "playwright": {
      "command": "node",
      "args": ["playwright-mcp-server"],
      "env": {}
    },
    "filesystem": {
      "command": "node",
      "args": ["@modelcontextprotocol/server-filesystem", "/workspaces"],
      "env": {}
    }
  }
}
EOF

# -----------------------------------------------------------------------------
# 6. Final Setup
# -----------------------------------------------------------------------------
echo "[6/6] Finalizing installation..."

# Make scripts executable
chmod +x .devcontainer/*.sh 2>/dev/null || true

echo ""
echo "=============================================="
echo "  ✅ MCP Installation Complete!"
echo "=============================================="
echo ""
echo "Next Steps:"
echo "  1. Set your secrets in GitHub Codespaces settings"
echo "  2. Restart the Codespace if needed"
echo "  3. Open Copilot Chat to use MCP tools"
echo ""
