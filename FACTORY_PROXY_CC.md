# Factory Droid CLI + CLIProxyAPI Setup Guide

Use Factory's Droid CLI with your Claude Code Max subscription and/or OpenAI Codex subscription via OAuth - no API keys needed.

## Quick Start

```bash
# 1. Install Go
brew install go

# 2. Clone and build CLIProxyAPI
git clone https://github.com/luispater/CLIProxyAPI.git
cd CLIProxyAPI
go build -o cli-proxy-api ./cmd/server

# 3. Login to your accounts
./cli-proxy-api --claude-login    # For Claude
./cli-proxy-api --codex-login     # For OpenAI Codex

# 4. Start the proxy
./cli-proxy-api --config config.yaml

# 5. Copy the Factory config below to ~/.factory/config.json

# 6. Run droid and use /model to select your custom model
droid
```

## Architecture

```
Factory CLI → CLIProxyAPI (localhost:8317) → Claude/OpenAI APIs
                    ↓
            OAuth Token Injection
```

## Working Configuration (Tested January 2026)

### ~/.factory/config.json

**IMPORTANT**: The URL format differs between providers:
- **Anthropic (Claude)**: Use `http://127.0.0.1:8317` (NO `/v1` suffix)
- **OpenAI (Codex)**: Use `http://127.0.0.1:8317/v1` (WITH `/v1` suffix)

```json
{
  "custom_models": [
    {
      "model": "claude-opus-4-5-20251101",
      "base_url": "http://127.0.0.1:8317",
      "api_key": "sk-dummy",
      "provider": "anthropic"
    },
    {
      "model": "claude-sonnet-4-5-20250929",
      "base_url": "http://127.0.0.1:8317",
      "api_key": "sk-dummy",
      "provider": "anthropic"
    },
    {
      "model": "claude-haiku-4-5-20251001",
      "base_url": "http://127.0.0.1:8317",
      "api_key": "sk-dummy",
      "provider": "anthropic"
    },
    {
      "model": "gpt-5",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5(medium)",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5(high)",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex(medium)",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex(high)",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    }
  ]
}
```

### CLIProxyAPI config.yaml

```yaml
port: 8317

remote-management:
  allow-remote: false
  secret-key: ""

auth-dir: "~/.cli-proxy-api"

debug: false
logging-to-file: false

usage-statistics-enabled: true
proxy-url: ""
request-retry: 3

quota-exceeded:
  switch-project: true
  switch-preview-model: true

auth:
  providers: []

generative-language-api-key: []
```

## Latest Claude Model IDs (January 2026)

From [Anthropic's official docs](https://platform.claude.com/docs/en/about-claude/models/overview):

| Model | API ID | Description |
|-------|--------|-------------|
| Claude Opus 4.5 | `claude-opus-4-5-20251101` | Premium model, maximum intelligence |
| Claude Sonnet 4.5 | `claude-sonnet-4-5-20250929` | Best for complex agents and coding |
| Claude Haiku 4.5 | `claude-haiku-4-5-20251001` | Fastest model |

## OpenAI Codex Model IDs

| Model | Description |
|-------|-------------|
| `gpt-5` | Base GPT-5 model |
| `gpt-5(minimal)` | Minimal reasoning |
| `gpt-5(low)` | Low reasoning |
| `gpt-5(medium)` | Medium reasoning |
| `gpt-5(high)` | High reasoning |
| `gpt-5-codex` | Codex optimized |
| `gpt-5-codex(low)` | Codex with low reasoning |
| `gpt-5-codex(medium)` | Codex with medium reasoning |
| `gpt-5-codex(high)` | Codex with high reasoning |

## Installation Steps

### 1. Install Prerequisites

```bash
# macOS
brew install go git

# Verify
go version  # Should be 1.24+
```

### 2. Build CLIProxyAPI

```bash
git clone https://github.com/luispater/CLIProxyAPI.git
cd CLIProxyAPI
go build -o cli-proxy-api ./cmd/server
```

### 3. Create config.yaml

```bash
cat > config.yaml << 'EOF'
port: 8317
remote-management:
  allow-remote: false
  secret-key: ""
auth-dir: "~/.cli-proxy-api"
debug: false
logging-to-file: false
usage-statistics-enabled: true
proxy-url: ""
request-retry: 3
quota-exceeded:
  switch-project: true
  switch-preview-model: true
auth:
  providers: []
generative-language-api-key: []
EOF
```

### 4. OAuth Login

```bash
# For Claude (requires Claude Max subscription)
./cli-proxy-api --claude-login

# For OpenAI Codex (requires ChatGPT Plus/Team)
./cli-proxy-api --codex-login
```

This opens a browser for OAuth. Tokens are saved to `~/.cli-proxy-api/`.

### 5. Start the Proxy

```bash
# Foreground (for testing)
./cli-proxy-api --config config.yaml

# Background
nohup ./cli-proxy-api --config config.yaml > ~/.cli-proxy-api/proxy.log 2>&1 &
```

### 6. Configure Factory CLI

```bash
mkdir -p ~/.factory
cat > ~/.factory/config.json << 'EOF'
{
  "custom_models": [
    {
      "model": "claude-opus-4-5-20251101",
      "base_url": "http://127.0.0.1:8317",
      "api_key": "sk-dummy",
      "provider": "anthropic"
    },
    {
      "model": "claude-sonnet-4-5-20250929",
      "base_url": "http://127.0.0.1:8317",
      "api_key": "sk-dummy",
      "provider": "anthropic"
    },
    {
      "model": "claude-haiku-4-5-20251001",
      "base_url": "http://127.0.0.1:8317",
      "api_key": "sk-dummy",
      "provider": "anthropic"
    },
    {
      "model": "gpt-5",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5(medium)",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5(high)",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex(medium)",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex(high)",
      "base_url": "http://127.0.0.1:8317/v1",
      "api_key": "sk-dummy",
      "provider": "openai"
    }
  ]
}
EOF
```

### 7. Test

```bash
# Test Claude
curl -s -X POST http://127.0.0.1:8317/v1/messages \
  -H "Content-Type: application/json" \
  -H "x-api-key: sk-dummy" \
  -H "anthropic-version: 2023-06-01" \
  -d '{"model":"claude-sonnet-4-5-20250929","messages":[{"role":"user","content":"Say test"}],"max_tokens":20}'

# Test Codex
curl -s -X POST http://127.0.0.1:8317/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-dummy" \
  -d '{"model":"gpt-5-codex","messages":[{"role":"user","content":"Say test"}],"max_tokens":20}'
```

## Running as a Service (macOS)

Create `~/Library/LaunchAgents/com.cliproxyapi.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.cliproxyapi</string>
    <key>ProgramArguments</key>
    <array>
        <string>/path/to/CLIProxyAPI/cli-proxy-api</string>
        <string>--config</string>
        <string>/path/to/CLIProxyAPI/config.yaml</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/cliproxyapi.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/cliproxyapi.err</string>
</dict>
</plist>
```

Load it:
```bash
launchctl load ~/Library/LaunchAgents/com.cliproxyapi.plist
```

## Troubleshooting

### "400 Bad Request" errors

**Cause**: Wrong URL format for provider.

**Fix**: 
- Claude models: `http://127.0.0.1:8317` (no `/v1`)
- OpenAI models: `http://127.0.0.1:8317/v1` (with `/v1`)

### "unknown provider for model" error

**Cause**: Model name not recognized by proxy.

**Fix**: Use exact model names as listed above. For Codex reasoning levels, use parentheses: `gpt-5(high)`, not `gpt-5-high`.

### OAuth token expired

```bash
# Re-login
./cli-proxy-api --claude-login
./cli-proxy-api --codex-login
```

### Proxy not running

```bash
# Check if running
ps aux | grep cli-proxy-api

# Check logs
cat ~/.cli-proxy-api/cli-proxy-api.log
```

### Connection refused

```bash
# Ensure proxy is running on correct port
curl http://127.0.0.1:8317/v1/models
```

## Key Files

```
~/.factory/config.json           # Factory CLI custom models config
~/.cli-proxy-api/
├── claude-{email}.json          # Claude OAuth token
├── codex-{email}.json           # Codex OAuth token
└── cli-proxy-api.log            # Proxy logs
~/path/to/CLIProxyAPI/
├── cli-proxy-api                # Binary
└── config.yaml                  # Proxy config
```

## Resources

- [CLIProxyAPI GitHub](https://github.com/luispater/CLIProxyAPI)
- [CLIProxyAPI Docs](https://help.router-for.me/)
- [Factory Droid Docs](https://docs.factory.ai/)
- [Anthropic Models](https://platform.claude.com/docs/en/about-claude/models/overview)
