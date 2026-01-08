# OpenCode + Cursor + Claude Setup Replication

Complete configuration for replicating my AI coding assistant setup across machines.

## Quick Start

```bash
# Clone this repo
git clone https://github.com/xkonjin/opencodejin.git
cd opencodejin

# Run the install script
chmod +x install.sh
./install.sh
```

## What's Included

| Directory | Purpose |
|-----------|---------|
| `opencode/` | OpenCode main config + plugin configs |
| `skills/` | Custom skills (systematic-debugging, etc.) |
| `cursor/` | Cursor IDE commands and rules |
| `claude-desktop/` | Claude Desktop MCP config |
| `project-template/` | Template for per-project configs |

## Manual Installation

### 1. Create Directories

```bash
mkdir -p ~/.config/opencode/plugins
mkdir -p ~/.cursor/commands
mkdir -p ~/.cursor/rules
mkdir -p ~/.claude/skills
mkdir -p ~/.claude/hooks
mkdir -p ~/Library/Application\ Support/Claude  # macOS only
```

### 2. Copy Config Files

```bash
# OpenCode
cp opencode/opencode.json ~/.config/opencode/
cp opencode/oh-my-opencode.json ~/.config/opencode/
cp opencode/vibe-skills.json ~/.config/opencode/

# Skills
cp -r skills/* ~/.config/opencode/plugins/

# Claude Desktop (macOS)
cp claude-desktop/claude_desktop_config.json ~/Library/Application\ Support/Claude/
```

### 3. Install OpenCode Plugins

```bash
npm install -g opencode
opencode plugin install oh-my-opencode
opencode plugin install opencode-antigravity-auth@1.2.8
opencode plugin install opencode-openai-codex-auth
```

### 4. Set Environment Variables

Add to `~/.zshrc` or `~/.bashrc`:

```bash
export PERPLEXITY_API_KEY="your_key"
export OPENAI_API_KEY="your_key"
export ANTHROPIC_API_KEY="your_key"
export GEMINI_API_KEY="your_key"
```

### 5. Update Tokens

Edit these files and replace placeholder tokens:
- `~/.config/opencode/opencode.json` - GitHub PAT, Rube token
- `~/Library/Application Support/Claude/claude_desktop_config.json` - MCP tokens

## Per-Project Setup

Copy `project-template/` contents to your project root:

```bash
cp -r project-template/.cursor your-project/
cp -r project-template/.claude your-project/
```

## MCP Servers Included

| Server | Purpose |
|--------|---------|
| `github` | GitHub operations via MCP |
| `playwright` | Browser automation |
| `filesystem` | File system access |
| `fetch` | HTTP requests |
| `context7` | Documentation lookup |
| `perplexity` | AI search |
| `rube` | Composio workflow automation |

## Models Configured

### Google (via Antigravity)
- `antigravity-gemini-3-flash` - Fast, 1M context
- `antigravity-gemini-3-pro-high` - High quality reasoning
- `antigravity-gemini-3-pro-low` - Balanced

### OpenAI (via OAuth)
- `gpt-5.2` - Latest flagship with reasoning variants
- `gpt-5.2-codex` - Coding optimized
- `gpt-5.1-codex-max` - Previous gen max

## Agent Model Assignments

| Agent | Model |
|-------|-------|
| `librarian` | glm-4.7-free |
| `explore` | gemini-3-flash |
| `frontend-ui-ux-engineer` | gemini-3-pro-high |
| `document-writer` | gemini-3-flash |
| `multimodal-looker` | gemini-3-flash |

## Skills Included

### Development
- `systematic-debugging` - Root cause analysis before fixes
- `test-driven-development` - TDD workflow
- `writing-plans` - Planning before coding

### Marketing/Creative
- `direct-response-copy` - Conversion copywriting
- `brand-voice` - Voice/tone extraction
- `content-atomizer` - Content repurposing
- `email-sequences` - Email campaigns
- `keyword-research` - SEO keywords
- `lead-magnet` - Lead gen ideas
- `newsletter` - Newsletter writing
- `positioning-angles` - Differentiation
- `seo-content` - SEO articles

### AI Creative
- `ai-creative-strategist` - Visual strategy
- `ai-image-generation` - Image prompts
- `ai-product-photo` - Product shots
- `ai-product-video` - Product videos
- `ai-social-graphics` - Social media graphics
- `ai-talking-head` - AI avatars

## License

MIT - Use however you want.
