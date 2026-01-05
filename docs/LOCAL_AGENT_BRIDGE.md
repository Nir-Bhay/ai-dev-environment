# 🔗 Local AI Agent Bridge Guide

This guide explains how to connect AI agents running on your local machine to a GitHub Codespace.

## Overview

```
┌─────────────────────┐         ┌─────────────────────┐
│   LOCAL MACHINE     │         │   GITHUB CODESPACE  │
│                     │         │                     │
│  ┌───────────────┐  │   SSH   │  ┌───────────────┐  │
│  │ Gemini CLI    │──┼────────►│  │ Project Files │  │
│  │ Aider         │  │         │  │ MCP Servers   │  │
│  │ Custom Agent  │  │         │  │ Docker        │  │
│  └───────────────┘  │         │  └───────────────┘  │
│                     │         │                     │
│  ┌───────────────┐  │         │                     │
│  │ GitHub CLI    │  │         │                     │
│  │ (gh)          │  │         │                     │
│  └───────────────┘  │         │                     │
└─────────────────────┘         └─────────────────────┘
```

## Prerequisites

### 1. Install GitHub CLI

**Windows (PowerShell):**
```powershell
winget install GitHub.cli
```

**macOS:**
```bash
brew install gh
```

**Linux:**
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

### 2. Authenticate with GitHub

```bash
gh auth login
```
- Select "GitHub.com"
- Choose "HTTPS" or "SSH"
- Authenticate via browser

## Connection Methods

### Method 1: Interactive SSH Session

Open a terminal directly into your Codespace:

```bash
# List your Codespaces
gh codespace list

# Connect to a specific Codespace
gh codespace ssh -c <codespace-name>
```

### Method 2: Run Remote Commands

Execute commands without entering an interactive session:

```bash
# Run a single command
gh codespace ssh -c <codespace-name> -- "npm install"

# Run a script
gh codespace ssh -c <codespace-name> -- "bash ./scripts/build.sh"

# Run multiple commands
gh codespace ssh -c <codespace-name> -- "cd /workspaces/project && npm test"
```

### Method 3: SSH Config Integration

Generate an SSH config entry for easy access:

```bash
# Generate SSH config
gh codespace ssh --config >> ~/.ssh/config

# Now you can use standard SSH commands
ssh codespace-<name>
scp local_file.txt codespace-<name>:/workspaces/project/
```

### Method 4: File Transfer

Copy files between local and remote:

```bash
# Upload file to Codespace
gh codespace cp local_file.txt remote:/workspaces/project/

# Download file from Codespace  
gh codespace cp remote:/workspaces/project/output.txt ./

# Upload entire folder
gh codespace cp -r ./local_folder remote:/workspaces/project/
```

### Method 5: Port Forwarding

Access services running in Codespace from your local machine:

```bash
# Forward a single port
gh codespace ports forward 3000:3000

# Forward with visibility
gh codespace ports forward 8080:8080 --visibility public
```

## Connecting Specific AI Agents

### Aider (AI Coding Assistant)

If Aider runs locally but you want it to edit files in the Codespace:

```bash
# Option 1: Run Aider inside Codespace
gh codespace ssh -c <name> -- "cd /workspaces/project && aider"

# Option 2: Mount Codespace files locally (Linux/macOS)
mkdir ~/codespace-mount
sshfs codespace-<name>:/workspaces/project ~/codespace-mount
cd ~/codespace-mount
aider
```

### Gemini CLI

```bash
# Execute Gemini commands against remote files
gh codespace ssh -c <name> -- "gemini analyze /workspaces/project/src"
```

### Custom Python Agent

```python
import subprocess

def run_in_codespace(command: str, codespace_name: str) -> str:
    """Run a command in a GitHub Codespace and return output."""
    result = subprocess.run(
        ["gh", "codespace", "ssh", "-c", codespace_name, "--", command],
        capture_output=True,
        text=True
    )
    return result.stdout

# Example usage
output = run_in_codespace("ls -la /workspaces", "my-codespace")
print(output)
```

### Node.js Agent

```javascript
const { execSync } = require('child_process');

function runInCodespace(command, codespaceName) {
  const result = execSync(
    `gh codespace ssh -c ${codespaceName} -- "${command}"`,
    { encoding: 'utf-8' }
  );
  return result;
}

// Example usage
const files = runInCodespace('ls /workspaces/project', 'my-codespace');
console.log(files);
```

## Automation Script

Save this as `connect-codespace.ps1` on Windows:

```powershell
# connect-codespace.ps1
param(
    [string]$Action = "shell",
    [string]$Command = ""
)

# Get active Codespace
$codespace = gh codespace list --json name,state -q '.[] | select(.state=="Available") | .name' | Select-Object -First 1

if (-not $codespace) {
    Write-Error "No active Codespace found. Start one first."
    exit 1
}

Write-Host "Using Codespace: $codespace" -ForegroundColor Green

switch ($Action) {
    "shell" {
        gh codespace ssh -c $codespace
    }
    "run" {
        gh codespace ssh -c $codespace -- $Command
    }
    "ports" {
        gh codespace ports -c $codespace
    }
    default {
        Write-Host "Usage: .\connect-codespace.ps1 -Action [shell|run|ports] -Command 'your command'"
    }
}
```

Usage:
```powershell
# Open shell
.\connect-codespace.ps1

# Run command
.\connect-codespace.ps1 -Action run -Command "npm test"

# List forwarded ports
.\connect-codespace.ps1 -Action ports
```

## Troubleshooting

### "No Codespaces found"
- Ensure you have an active Codespace running
- Run `gh codespace list` to check

### "Permission denied"
- Re-authenticate: `gh auth login`
- Ensure your token has `codespace` scope

### "Connection timeout"
- The Codespace might be stopped. Start it via GitHub web UI
- Check your internet connection

### "Command not found" in Codespace
- The tool might not be installed. SSH in and install it
- Or add it to `.devcontainer/setup-mcp.sh`

## Best Practices

1. **Keep Codespace Running**: Use the GitHub web UI to prevent auto-stop during long sessions
2. **Use SSH Keys**: Add your SSH key to GitHub for passwordless access
3. **Script Repetitive Tasks**: Create local scripts that run remote commands
4. **Monitor Resources**: Use `gh codespace list` to check machine types and usage

---

**Need help?** Open an issue in this repository!
