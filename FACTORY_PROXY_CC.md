## Executive Summary

This guide documents how to use Factory's Droid CLI with your Claude Code Max subscription (OAuth authentication) instead of pay-per-token API keys. The solution leverages CLIProxyAPI as a transparent authentication proxy that converts API key requests from Factory CLI into OAuth-authenticated requests for Anthropic's API.

## Architecture Overview

```
Factory CLI → [Anthropic Format + API Key] → CLIProxyAPI → [Anthropic Format + OAuth] → Anthropic API
                                                  ↓
                                          (Auth Header Swap)
```

### Key Components

1. **Factory Droid CLI**: AI-powered development assistant with BYOK (Bring Your Own Key) support
2. **CLIProxyAPI**: Open-source proxy server that handles OAuth authentication for CLI models
3. **Claude Code Max Subscription**: Consumer subscription using OAuth tokens instead of API keys
4. **Anthropic Messages API**: Native API endpoint for Claude models

## Why This Solution?

### The Problem
- Factory CLI expects API keys (`x-api-key` header) for Anthropic integration
- Claude Code Max subscriptions use OAuth tokens (`Authorization: Bearer`)
- Anthropic's public API doesn't accept OAuth tokens directly
- No need for expensive pay-per-token API access when you have a Max subscription

### The Solution
CLIProxyAPI acts as a transparent proxy that:
- Accepts native Anthropic format requests from Factory CLI
- Replaces dummy API keys with valid OAuth tokens
- Handles OAuth token refresh automatically
- Preserves request/response format (no translation needed)

## Prerequisites

### System Requirements
- Linux, macOS, or WSL2 on Windows
- Go 1.24 or higher (for building from source)
- Git for cloning the repository
- Active Claude Code Max subscription
- Factory CLI installed and configured

### Network Requirements
- Port 8317 (default) or any available port for the proxy
- Port 54545 for OAuth callback during initial setup
- Internet access to Anthropic's API endpoints

## Installation Guide

### Step 0: Install Factory Droid
- Sign up at https://factory.ai/ and install the bridge
- Install the Droid CLI. 
```
curl -fsSL https://app.factory.ai/cli | sh
```

### Step 1: Install Go (if not already installed)

```bash
# Download and install Go
brew install go

# Add to PATH (add to ~/.bashrc or ~/.zshrc for persistence)
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Verify installation
go version
```

### Step 2: Clone and Build CLIProxyAPI

```bash
# Clone the repository
git clone https://github.com/luispater/CLIProxyAPI.git
cd CLIProxyAPI

# Build the binary
go build -o cli-proxy-api ./cmd/server

# Verify the binary was created
ls -la cli-proxy-api
```

### Step 3: Configure the Proxy

Create a `config.yaml` file in the CLIProxyAPI directory:

```yaml
# Server port (use any available port)
port: 8317

# Management API settings
remote-management:
  allow-remote: false
  secret-key: ""  # Leave empty to disable management API

# Authentication directory (stores OAuth tokens)
auth-dir: "~/.cli-proxy-api"

# Logging configuration
debug: false
logging-to-file: false

# Usage statistics
usage-statistics-enabled: true

# Network proxy (if needed for corporate networks)
proxy-url: ""

# Retry configuration
request-retry: 3

# Quota management
quota-exceeded:
  switch-project: true
  switch-preview-model: true

# Disable request authentication (Factory handles its own)
auth:
  providers: []

# No API keys needed for Claude OAuth
generative-language-api-key: []
```

### Step 4: OAuth Authentication Setup

Run the OAuth login flow to authenticate with your Claude Code account:

```bash
./cli-proxy-api --claude-login
```

For getting OpenAI Codex working with this: 
```bash
./cli-proxy-api --codex-login
```

This will:
1. Start a local OAuth callback server on port 54545
2. Provide an authentication URL (open in browser if not automatic)
3. Complete the OAuth flow with Anthropic / OpenAI
4. Save tokens to `~/.cli-proxy-api/claude-{email}.json`

**For Remote Servers**: If running on a remote server, you'll need an SSH tunnel:
```bash
# On your local machine (not the server):
ssh -L 54545:127.0.0.1:54545 user@your-server-ip
```

### Step 5: Configure Factory CLI

Create or modify `~/.factory/config.json`:

```json
{
  "custom_models": [
    {
      "model": "claude-opus-4-1-20250805",
      "base_url": "http://localhost:8317",
      "api_key": "dummy-not-used",
      "provider": "anthropic"
    },
    {
      "model": "claude-sonnet-4-20250514",
      "base_url": "http://localhost:8317",
      "api_key": "dummy-not-used",
      "provider": "anthropic"
    },
    {
      "model": "gpt-5",
      "base_url": "http://localhost:8317",
      "api_key": "dummy-not-used",
      "provider": "openai"
    },
    {
      "model": "gpt-5-minimal",
      "base_url": "http://localhost:8317",
      "api_key": "dummy-not-used",
      "provider": "openai"
    },
    {
      "model": "gpt-5-medium",
      "base_url": "http://localhost:8317",
      "api_key": "dummy-not-used",
      "provider": "openai"
    },
    {
      "model": "gpt-5-high",
      "base_url": "http://localhost:8317",
      "api_key": "dummy-not-used",
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex",
      "base_url": "http://localhost:8317",
      "api_key": "dummy-not-used",
      "provider": "openai"
    },
    {
      "model": "gpt-5-codex-high",
      "base_url": "http://localhost:8317",
      "api_key": "dummy-not-used",
      "provider": "openai"
    }
  ]
}
```


**Note**: The `api_key` field is required by Factory but ignored by the proxy (OAuth is used instead).

## Running the System

### Start the Proxy Server

```bash
# Start in foreground (for testing)
./cli-proxy-api --config config.yaml

# Or start in background
nohup ./cli-proxy-api --config config.yaml > proxy.log 2>&1 &

# Or use systemd service (see below)
```

Expected output:
```
CLIProxyAPI Version: dev, Commit: none, BuiltAt: unknown
API server started successfully
server clients and configuration updated: 1 clients (1 auth files)
```

### Using Factory CLI

1. Start Factory Droid:
   ```bash
   droid
   ```

2. Select your custom model:
   ```
   /model
   ```
   Choose either:
   - `claude-opus-4-1-20250805` (Claude Opus 4.1)
   - `claude-sonnet-4-20250514` (Claude Sonnet 4)
   - or other openAI models. 

3. Use as normal - Factory will now use your Claude Code subscription!

## Production Setup

### Systemd Service (Linux)

Create `/etc/systemd/system/cli-proxy-api.service`:

```ini
[Unit]
Description=CLI Proxy API for Factory Claude Integration
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/CLIProxyAPI
ExecStart=/path/to/CLIProxyAPI/cli-proxy-api --config config.yaml
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable cli-proxy-api
sudo systemctl start cli-proxy-api
sudo systemctl status cli-proxy-api
```

### Docker Deployment

Create a `Dockerfile`:

```dockerfile
FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o cli-proxy-api ./cmd/server

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/cli-proxy-api .
COPY config.yaml .
CMD ["./cli-proxy-api", "--config", "config.yaml"]
```

Build and run:
```bash
docker build -t cli-proxy-api .
docker run -d -p 8317:8317 -v ~/.cli-proxy-api:/root/.cli-proxy-api cli-proxy-api
```

## Troubleshooting

### Common Issues and Solutions

#### Port Already in Use
```
Error: listen tcp :8317: bind: address already in use
```
**Solution**: Change the port in both `config.yaml` and `~/.factory/config.json`.

#### OAuth Token Expired
```
Error: OAuth token unavailable or expired
```
**Solution**: Re-run `./cli-proxy-api --claude-login` to refresh authentication.

#### Factory Can't Connect to Proxy
```
Error: Connection refused
```
**Solutions**:
- Ensure proxy is running: `ps aux | grep cli-proxy-api`
- Check correct port in Factory config matches proxy config
- Verify firewall allows localhost connections

#### Model Not Found
```
Error: Model claude-xxx not found
```
**Solution**: Use exact model names from the supported list:
- `claude-opus-4-1-20250805`
- `claude-sonnet-4-20250514`

### Debug Mode

Enable debug logging for troubleshooting:

```yaml
# In config.yaml
debug: true
logging-to-file: true
```

Check logs in `logs/` directory relative to config file.

## Security Considerations

### OAuth Token Security
- Tokens stored in `~/.cli-proxy-api/` with user-only permissions
- Never commit token files to version control
- Tokens auto-refresh before expiration
- No tokens appear in logs (automatically redacted)

### Network Security
- Proxy binds to localhost only by default
- No external access without explicit configuration
- HTTPS used for all Anthropic API communication
- Optional proxy authentication can be enabled

### Best Practices
1. Run proxy as non-root user
2. Use systemd service with restart policies
3. Monitor logs for authentication failures
4. Rotate OAuth tokens periodically (re-login)
5. Keep CLIProxyAPI updated for security patches

## Supported Models

### Currently Available
- **Claude Opus 4.1** (`claude-opus-4-1-20250805`)
  - Most capable model for complex reasoning
  - Best for architecture, planning, deep analysis

- **Claude Sonnet 4** (`claude-sonnet-4-20250514`)
  - Balanced performance and speed
  - Ideal for general development tasks

### Adding New Models
When Anthropic releases new models, update Factory config with the exact model ID:
```json
{
  "model": "claude-{new-model-id}",
  "base_url": "http://localhost:8317",
  "api_key": "dummy-not-used",
  "provider": "anthropic"
}
```

## Technical Details

### How the Proxy Works

1. **Request Flow**:
   - Factory sends Anthropic-format request with dummy API key
   - Proxy receives request on `/v1/messages` endpoint
   - Proxy strips `X-Api-Key` header
   - Proxy adds `Authorization: Bearer {oauth_token}`
   - Proxy adds required beta headers for OAuth
   - Request forwarded to Anthropic unchanged

2. **Response Flow**:
   - Anthropic responds in native format
   - Proxy streams response back to Factory
   - No format translation needed

3. **Token Management**:
   - OAuth tokens cached until near expiration
   - Automatic refresh using refresh token
   - Multiple account support with round-robin

### Key Files and Directories

```
~/
├── .factory/
│   └── config.json          # Factory CLI configuration
├── .cli-proxy-api/
│   └── claude-*.json        # OAuth tokens (auto-generated)
└── projects/CLIProxyAPI/
    ├── cli-proxy-api        # Compiled binary
    ├── config.yaml          # Proxy configuration
    └── logs/               # Log files (if enabled)
```

## Performance Optimization

### Latency Reduction
- No format translation overhead (native Anthropic format)
- Direct pass-through of streaming responses
- Connection pooling for API requests
- Local caching of OAuth tokens

### Resource Usage
- Minimal CPU usage (< 1% idle, < 5% active)
- Low memory footprint (< 50MB typical)
- No disk I/O except for logs (if enabled)
- Stateless operation (except OAuth tokens)

## Monitoring and Maintenance

### Health Checks
```bash
# Check if proxy is running
curl -s http://localhost:8317/health || echo "Proxy not responding"

# View real-time logs
tail -f logs/app.log  # If file logging enabled

# Check OAuth token status
ls -la ~/.cli-proxy-api/
```

### Regular Maintenance
- **Weekly**: Check logs for errors
- **Monthly**: Update CLIProxyAPI if new version available
- **Quarterly**: Re-authenticate OAuth (preventive)
- **As Needed**: Adjust port if conflicts arise

## Conclusion

This solution enables seamless integration between Factory's Droid CLI and Claude Code Max subscriptions, eliminating the need for pay-per-token API access. The CLIProxyAPI serves as a lightweight, transparent proxy that handles OAuth authentication while preserving the native Anthropic API format that Factory already supports.

### Benefits Achieved
- ✅ Use Claude Code Max subscription with Factory CLI
- ✅ No API key costs
- ✅ Automatic token refresh
- ✅ Native Anthropic format (no translation overhead)
- ✅ Simple one-time setup
- ✅ Production-ready with systemd/Docker support

### Next Steps
1. Set up the proxy following this guide
2. Test with a simple Factory CLI interaction
3. Configure for production use if successful
4. Share with team members who have Claude Code subscriptions

## Support and Resources

### CLIProxyAPI Resources
- GitHub Repository: https://github.com/luispater/CLIProxyAPI
- Issues/Support: https://github.com/luispater/CLIProxyAPI/issues
- Documentation: See repository README.md

### Factory CLI Resources
- Documentation: https://docs.factory.ai/cli
- BYOK Configuration: https://docs.factory.ai/cli/configuration/byok
- Support: Contact Factory support team

### Anthropic/Claude Resources
- API Documentation: https://docs.anthropic.com
- Model Information: https://docs.anthropic.com/en/docs/about-claude/models
- Claude Code: https://claude.ai

## Appendix: Quick Reference

### Essential Commands
```bash
# Build proxy
go build -o cli-proxy-api ./cmd/server

# OAuth setup
./cli-proxy-api --claude-login

# Start proxy
./cli-proxy-api --config config.yaml

# Test with curl
curl -X POST http://localhost:8317/v1/messages \
  -H "Content-Type: application/json" \
  -H "x-api-key: dummy" \
  -H "anthropic-version: 2023-06-01" \
  -d '{"model":"claude-opus-4-1-20250805","messages":[{"role":"user","content":"Hello"}],"max_tokens":100}'

# Use with Factory
droid
/model  # Select custom model
```

### Configuration Templates
All configuration templates are provided in the main guide above and can be copied directly.

---
