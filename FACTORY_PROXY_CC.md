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

# 5. Copy the Factory config below to ~/.factory/settings.json

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

### ~/.factory/settings.json

**IMPORTANT**: 
- Factory uses `settings.json` (camelCase), NOT `config.json` (snake_case)
- The URL format differs between providers:
  - **Anthropic (Claude)**: Use `http://127.0.0.1:8317` (NO `/v1` suffix)
  - **OpenAI (Codex)**: Use `http://127.0.0.1:8317/v1` (WITH `/v1` suffix)
- Model IDs must follow the format: `custom:{model-name}-{index}`
- Each model needs unique `id` and `index` values

```json
{
  "sessionDefaultSettings": {
    "autonomyMode": "auto-high",
    "model": "custom:claude-sonnet-4-5-20250929-0",
    "reasoningEffort": "none"
  },
  "customModels": [
    {
      "model": "claude-sonnet-4-5-20250929",
      "id": "custom:claude-sonnet-4-5-20250929-0",
      "index": 0,
      "baseUrl": "http://127.0.0.1:8317",
      "apiKey": "sk-dummy",
      "displayName": "claude-sonnet-4-5-20250929",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "claude-opus-4-5-20251101",
      "id": "custom:claude-opus-4-5-20251101-1",
      "index": 1,
      "baseUrl": "http://127.0.0.1:8317",
      "apiKey": "sk-dummy",
      "displayName": "claude-opus-4-5-20251101",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "claude-haiku-4-5-20251001",
      "id": "custom:claude-haiku-4-5-20251001-2",
      "index": 2,
      "baseUrl": "http://127.0.0.1:8317",
      "apiKey": "sk-dummy",
      "displayName": "claude-haiku-4-5-20251001",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "gpt-5.2-codex",
      "id": "custom:gpt-5.2-codex-3",
      "index": 3,
      "baseUrl": "http://127.0.0.1:8317/v1",
      "apiKey": "sk-dummy",
      "displayName": "gpt-5.2-codex",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "gpt-5.1-codex-max",
      "id": "custom:gpt-5.1-codex-max-4",
      "index": 4,
      "baseUrl": "http://127.0.0.1:8317/v1",
      "apiKey": "sk-dummy",
      "displayName": "gpt-5.1-codex-max",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex",
      "id": "custom:gpt-5-codex-5",
      "index": 5,
      "baseUrl": "http://127.0.0.1:8317/v1",
      "apiKey": "sk-dummy",
      "displayName": "gpt-5-codex",
      "noImageSupport": false,
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

debug: true
logging-to-file: true

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

| Model | API ID | Description |
|-------|--------|-------------|
| Claude Opus 4.5 | `claude-opus-4-5-20251101` | Premium model, maximum intelligence |
| Claude Sonnet 4.5 | `claude-sonnet-4-5-20250929` | Best for complex agents and coding |
| Claude Haiku 4.5 | `claude-haiku-4-5-20251001` | Fastest model |

## OpenAI Codex Model IDs (January 2026)

| Model | Description |
|-------|-------------|
| `gpt-5` | Base GPT-5 model |
| `gpt-5-codex` | Codex optimized for coding |
| `gpt-5.1-codex-max` | Max tier - highest capability |
| `gpt-5.2` | Latest GPT-5 version |
| `gpt-5.2-codex` | Latest Codex version |

### Reasoning Effort Levels

Use parentheses syntax for reasoning levels (NOT dashes):
- `gpt-5.2-codex(medium)` - Medium reasoning
- `gpt-5.2-codex(high)` - High reasoning  
- `gpt-5.2-codex(xhigh)` - Maximum reasoning
- `gpt-5.1-codex-max(high)` - Max tier with high reasoning
- `gpt-5.1-codex-max(xhigh)` - Max tier with maximum reasoning

**WRONG**: `gpt-5-codex-medium` (dash syntax not supported)
**CORRECT**: `gpt-5-codex(medium)` (parentheses syntax)

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
debug: true
logging-to-file: true
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

# For OpenAI Codex (requires ChatGPT Plus/Pro)
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

# Remove any legacy config.json if it exists
rm -f ~/.factory/config.json

cat > ~/.factory/settings.json << 'EOF'
{
  "sessionDefaultSettings": {
    "autonomyMode": "auto-high",
    "model": "custom:claude-sonnet-4-5-20250929-0",
    "reasoningEffort": "none"
  },
  "customModels": [
    {
      "model": "claude-sonnet-4-5-20250929",
      "id": "custom:claude-sonnet-4-5-20250929-0",
      "index": 0,
      "baseUrl": "http://127.0.0.1:8317",
      "apiKey": "sk-dummy",
      "displayName": "claude-sonnet-4-5-20250929",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "claude-opus-4-5-20251101",
      "id": "custom:claude-opus-4-5-20251101-1",
      "index": 1,
      "baseUrl": "http://127.0.0.1:8317",
      "apiKey": "sk-dummy",
      "displayName": "claude-opus-4-5-20251101",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "claude-haiku-4-5-20251001",
      "id": "custom:claude-haiku-4-5-20251001-2",
      "index": 2,
      "baseUrl": "http://127.0.0.1:8317",
      "apiKey": "sk-dummy",
      "displayName": "claude-haiku-4-5-20251001",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "gpt-5.2-codex",
      "id": "custom:gpt-5.2-codex-3",
      "index": 3,
      "baseUrl": "http://127.0.0.1:8317/v1",
      "apiKey": "sk-dummy",
      "displayName": "gpt-5.2-codex",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "gpt-5.1-codex-max",
      "id": "custom:gpt-5.1-codex-max-4",
      "index": 4,
      "baseUrl": "http://127.0.0.1:8317/v1",
      "apiKey": "sk-dummy",
      "displayName": "gpt-5.1-codex-max",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex",
      "id": "custom:gpt-5-codex-5",
      "index": 5,
      "baseUrl": "http://127.0.0.1:8317/v1",
      "apiKey": "sk-dummy",
      "displayName": "gpt-5-codex",
      "noImageSupport": false,
      "provider": "openai"
    }
  ]
}
EOF
```

### 7. Test

```bash
# Test Claude (Anthropic Messages API)
curl -s -X POST http://127.0.0.1:8317/v1/messages \
  -H "Content-Type: application/json" \
  -H "x-api-key: sk-dummy" \
  -H "anthropic-version: 2023-06-01" \
  -d '{"model":"claude-sonnet-4-5-20250929","messages":[{"role":"user","content":"Say OK"}],"max_tokens":20}'

# Test Codex (OpenAI Responses API)
curl -s -X POST http://127.0.0.1:8317/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-dummy" \
  -d '{"model":"gpt-5.2-codex","input":[{"type":"message","role":"user","content":"Say OK"}],"max_output_tokens":20}'

# Check available models
curl -s http://127.0.0.1:8317/v1/models | python3 -c "import json,sys; [print(m['id']) for m in json.load(sys.stdin)['data']]"
```

### 8. Use with Factory Droid

```bash
# Start droid
droid

# Use /model command to see and select custom models
# They appear under "Custom models" section
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

### "400 status code (no body)" error

This error comes from Factory CLI, not the proxy. Check:

1. **Verify proxy is working**:
   ```bash
   curl -s http://127.0.0.1:8317/v1/models
   ```

2. **Check proxy logs** - all requests should show 200:
   ```bash
   tail -20 /path/to/CLIProxyAPI/logs/main.log
   ```

3. **Remove legacy config.json**:
   ```bash
   rm -f ~/.factory/config.json
   ```

4. **Ensure settings.json has correct format** with `id` and `index` fields

5. **Restart droid** after config changes

### Wrong URL format for provider

- Claude models: `http://127.0.0.1:8317` (no `/v1`)
- OpenAI models: `http://127.0.0.1:8317/v1` (with `/v1`)

### "unknown provider for model" error

Use exact model names. For Codex reasoning levels, use parentheses:
- **CORRECT**: `gpt-5-codex(high)`
- **WRONG**: `gpt-5-codex-high`

### OAuth token expired

```bash
./cli-proxy-api --claude-login
./cli-proxy-api --codex-login
```

### Proxy not running

```bash
ps aux | grep cli-proxy-api
cat /path/to/CLIProxyAPI/logs/main.log
```

### Models not showing in /model command

1. Ensure `settings.json` (not `config.json`) exists
2. Check each model has unique `id` and `index`
3. Restart droid completely

## API Endpoints

| Endpoint | Provider | Description |
|----------|----------|-------------|
| `/v1/messages` | Anthropic | Claude Messages API |
| `/v1/responses` | OpenAI | Responses API (recommended) |
| `/v1/chat/completions` | OpenAI | Chat Completions API (legacy) |
| `/v1/models` | Both | List available models |

## Key Files

```
~/.factory/settings.json         # Factory CLI custom models config (USE THIS)
~/.factory/config.json           # Legacy format (DELETE THIS)
~/.cli-proxy-api/
├── claude-{email}.json          # Claude OAuth token
├── codex-{email}.json           # Codex OAuth token
└── cli-proxy-api.log            # Proxy logs (if configured)
/path/to/CLIProxyAPI/
├── cli-proxy-api                # Binary
├── config.yaml                  # Proxy config
└── logs/main.log               # Request logs
```

## Resources

- [CLIProxyAPI GitHub](https://github.com/luispater/CLIProxyAPI)
- [CLIProxyAPI Docs](https://help.router-for.me/)
- [Factory Droid Docs](https://docs.factory.ai/)
- [Anthropic Models](https://docs.anthropic.com/en/docs/about-claude/models)
