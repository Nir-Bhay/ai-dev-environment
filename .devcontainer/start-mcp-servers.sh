#!/bin/bash
# =============================================================================
# MCP Server Startup Script - Runs on every Codespace start
# =============================================================================

echo "══════════════════════════════════════════════════════════════════════════"
echo "  🚀 Starting AI-Powered Development Environment"
echo "══════════════════════════════════════════════════════════════════════════"

# Check environment variables
echo ""
echo "🔐 Checking Secrets Configuration..."

if [ -z "$NOTION_API_KEY" ]; then
    echo "   ⚠️  NOTION_API_KEY not set - Notion MCP limited"
else
    echo "   ✅ NOTION_API_KEY configured"
fi

if [ -z "$GITKRAKEN_ACCESS_TOKEN" ]; then
    echo "   ⚠️  GITKRAKEN_ACCESS_TOKEN not set - GitKraken MCP limited"
else
    echo "   ✅ GITKRAKEN_ACCESS_TOKEN configured"
fi

if [ -z "$OPENAI_API_KEY" ]; then
    echo "   ℹ️  OPENAI_API_KEY not set (optional)"
else
    echo "   ✅ OPENAI_API_KEY configured"
fi

if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "   ℹ️  ANTHROPIC_API_KEY not set (optional)"
else
    echo "   ✅ ANTHROPIC_API_KEY configured"
fi

if [ -z "$DATABASE_URL" ]; then
    echo "   ℹ️  DATABASE_URL not set (optional)"
else
    echo "   ✅ DATABASE_URL configured"
fi

# Display active MCP servers
echo ""
echo "══════════════════════════════════════════════════════════════════════════"
echo "  ✅ MCP Environment Ready!"
echo "══════════════════════════════════════════════════════════════════════════"
echo ""
echo "  🔧 Available MCP Servers:"
echo "  ┌─────────────────────────────────────────────────────────────────────┐"
echo "  │ GitKraken    │ Git, GitHub, GitLab, Issues, PRs, Branches          │"
echo "  │ Notion       │ Pages, Databases, Comments, Users, Teams            │"
echo "  │ Playwright   │ Browser Automation, Screenshots, Forms              │"
echo "  │ Docker       │ Containers, Images, Volumes, Networks               │"
echo "  │ Context7     │ Library Documentation, Code Examples                │"
echo "  │ Filesystem   │ File Operations, Directory Management               │"
echo "  │ Memory       │ Persistent Context Storage                          │"
echo "  │ PostgreSQL   │ Database Queries, Schema Management                 │"
echo "  │ Fetch        │ Web Content Fetching                                │"
echo "  └─────────────────────────────────────────────────────────────────────┘"
echo ""
echo "  🐍 Python Tools: aider, langchain, jupyter, openai, anthropic"
echo ""
echo "  📡 Local Agent Connection:"
echo "     gh codespace ssh -c \$(gh codespace list -q '.[0].name')"
echo ""
echo "  📋 Reference: ~/MCP_TOOLS_REFERENCE.md"
echo ""
echo "══════════════════════════════════════════════════════════════════════════"
echo "  Happy Coding! 🎉"
echo "══════════════════════════════════════════════════════════════════════════"
