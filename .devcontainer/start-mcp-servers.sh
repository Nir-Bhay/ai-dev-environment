#!/bin/bash
# =============================================================================
# MCP Server Startup Script
# This script runs every time the container starts (postStartCommand)
# =============================================================================

echo "Starting MCP environment..."

# Verify environment variables are set
if [ -z "$NOTION_API_KEY" ]; then
    echo "⚠️  Warning: NOTION_API_KEY is not set. Notion MCP will not work."
fi

if [ -z "$GITKRAKEN_ACCESS_TOKEN" ]; then
    echo "⚠️  Warning: GITKRAKEN_ACCESS_TOKEN is not set. Some GitKraken features may be limited."
fi

# Display active configuration
echo ""
echo "🚀 MCP Environment Ready"
echo "   - VS Code Server: Running"
echo "   - GitHub Copilot: Enabled"
echo "   - MCP Gateway: Active"
echo ""
echo "Available MCP Servers:"
echo "   ✅ GitKraken (Git, GitHub, Issues, PRs)"
echo "   ✅ Notion (Pages, Databases, Search)"
echo "   ✅ Playwright (Browser Automation)"
echo "   ✅ Docker (Container Management)"
echo ""
