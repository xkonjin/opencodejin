#!/bin/bash
set -e

echo "=== OpenCode + Cursor + Claude Setup ==="

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
else
    CLAUDE_CONFIG_DIR="$HOME/.config/claude"
fi

# Create directories
echo "Creating directories..."
mkdir -p ~/.config/opencode/plugins
mkdir -p ~/.cursor/commands
mkdir -p ~/.cursor/rules
mkdir -p ~/.claude/skills
mkdir -p ~/.claude/hooks
mkdir -p "$CLAUDE_CONFIG_DIR"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy OpenCode configs
echo "Copying OpenCode configs..."
cp "$SCRIPT_DIR/opencode/opencode.json" ~/.config/opencode/
cp "$SCRIPT_DIR/opencode/oh-my-opencode.json" ~/.config/opencode/
cp "$SCRIPT_DIR/opencode/vibe-skills.json" ~/.config/opencode/

# Copy skills
echo "Copying skills..."
cp -r "$SCRIPT_DIR/skills/"* ~/.config/opencode/plugins/

# Copy Claude Desktop config
echo "Copying Claude Desktop config..."
cp "$SCRIPT_DIR/claude-desktop/claude_desktop_config.json" "$CLAUDE_CONFIG_DIR/"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Next steps:"
echo "1. Install OpenCode plugins:"
echo "   npm install -g opencode"
echo "   opencode plugin install oh-my-opencode"
echo "   opencode plugin install opencode-antigravity-auth@1.2.8"
echo "   opencode plugin install opencode-openai-codex-auth"
echo ""
echo "2. Set environment variables in ~/.zshrc or ~/.bashrc:"
echo "   export PERPLEXITY_API_KEY=\"your_key\""
echo "   export OPENAI_API_KEY=\"your_key\""
echo "   export ANTHROPIC_API_KEY=\"your_key\""
echo "   export GEMINI_API_KEY=\"your_key\""
echo ""
echo "3. Update tokens in:"
echo "   ~/.config/opencode/opencode.json"
echo "   $CLAUDE_CONFIG_DIR/claude_desktop_config.json"
echo ""
echo "4. Replace YOUR_USERNAME in vibe-skills.json with your actual username"
echo ""
echo "5. Authenticate OpenCode:"
echo "   opencode auth"
