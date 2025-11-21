# Dockploy Quick Reference

## 📋 Dockploy Integration Guide

### Prepare Files for Dockploy Upload

```bash
# Copy environment template
cp .env.example .env

# Edit with your values
nano .env
```

### Upload to Dockploy

1. **Open Dockploy Web UI** → Services → Add Service
2. **Select Upload Method**:
   - Option A: Upload `docker-compose.yml` directly
   - Option B: Use git repository
3. **Configure**:
   - Name: `parkertron`
   - Description: `Discord/IRC Chatbot with Message Parsing`
   - Stack File: `docker-compose.yml`

### Environment Variables in Dockploy UI

Set these in Dockploy's environment section:

| Variable | Value | Notes |
|----------|-------|-------|
| `LOG_LEVEL` | `info` | Change to `debug` for troubleshooting |
| `DISCORD_ENABLED` | `true` | Set `false` if not using Discord |
| `IRC_ENABLED` | `false` | Set `true` if using IRC |
| `SLACK_ENABLED` | `false` | For future use |

### Mount Configuration Files

In Dockploy UI under "Volumes":

```
configs/  →  /app/configs:ro
logs/     →  /app/logs
```

**Create the directories on your host:**

```bash
mkdir -p configs/discord
mkdir -p configs/irc
mkdir -p logs

# Copy example configs
cp configs/parkertron.example.yml parkertron.yml
cp configs/discord/example-bot/example.yml configs/discord/my-bot.yml
```

### Deploy

1. Click "Deploy" in Dockploy UI
2. Monitor deployment progress
3. Check logs: Dockploy UI → Logs tab

## 🚀 Common Dockploy Operations

### View Container Status

```
Dockploy → Services → parkertron → Container Status
```

### View Logs in Dockploy

```
Dockploy → Services → parkertron → Logs
```

### Restart Service

```
Dockploy → Services → parkertron → Actions → Restart
```

### Update Configuration

```bash
# 1. Edit local files
nano configs/discord/my-bot.yml

# 2. In Dockploy: Services → parkertron → Actions → Restart
```

### View Resource Usage

```
Dockploy → Services → parkertron → Stats
```

## 🔧 Advanced Dockploy Configuration

### Add Additional Services (Monitoring Stack)

Copy `docker-compose.override.yml.example`:

```bash
cp docker-compose.override.yml.example docker-compose.override.yml
```

Then uncomment services in your override file:
- Prometheus (metrics)
- Grafana (dashboards)
- Loki (log aggregation)

Upload both files to Dockploy for full monitoring stack.

### Configure Resource Limits

In Dockploy UI or in `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'      # Adjust based on your needs
      memory: 512M     # Increase for heavy workloads
```

### Enable Auto-Restart

Already configured in `docker-compose.yml`:

```yaml
restart: unless-stopped
```

This means:
- ✅ Restarts automatically if bot crashes
- ✅ Won't restart if you stop it manually
- ✅ Survives Docker daemon restarts

## 📊 Monitoring & Alerts

### Health Check Status

Dockploy automatically monitors container health:

```
Status: Healthy  ✅  (Running)
Status: Unhealthy ❌ (Check logs)
Status: Starting ⏳  (Initializing)
```

### Set Up Webhook Notifications (Optional)

In `.env`:
```bash
WEBHOOK_LOG_URL=https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_TOKEN
```

### View Metrics

With `docker-compose.override.yml` enabled:

```
Access Grafana at: http://your-host:3000
Default credentials: admin / admin
```

## 🐛 Troubleshooting in Dockploy

### Service Won't Start

1. Check logs: Dockploy → Logs → Filter by "error"
2. Common issues:
   - Invalid bot tokens in config
   - Missing `/app/configs` volume mount
   - Port conflicts

### Configuration Not Loading

1. Verify volume mount:
   - Dockploy → Services → parkertron → Volumes
   - Should show: `configs/ → /app/configs:ro`
2. Check file permissions:
   - Ensure `configs/` is readable by container

### High CPU/Memory Usage

1. Check resource limits in compose file
2. View metrics: Dockploy → Stats
3. Reduce `LOG_LEVEL` to `warn` to decrease logging overhead

### Logs Not Appearing

1. Verify log volume is mounted: `/app/logs`
2. Check Docker daemon logging driver:
   ```bash
   docker info | grep "Logging Driver"
   ```

## 📁 Directory Structure for Dockploy

```
parkertron/
├── docker-compose.yml          # Main compose file (upload to Dockploy)
├── docker-compose.override.yml  # Optional monitoring stack
├── .env.example                 # Template (copy to .env)
├── .dockerignore               # Build optimization
├── DOCKER_DEPLOYMENT.md        # Full documentation
├── DOCKPLOY_QUICKREF.md       # This file
├── configs/                    # Mount to /app/configs
│   ├── parkertron.yml
│   ├── discord/
│   │   └── my-bot/
│   │       └── config.yml
│   └── irc/
│       └── my-bot/
│           └── config.yml
└── logs/                       # Mount to /app/logs (persistent)
```

## 🔐 Security Considerations

### Secrets Management

**Never commit sensitive data!**

Store tokens and passwords in Dockploy's secret management:

```
Dockploy → Projects → Secrets
```

Then reference in `.env`:
```bash
# In Dockploy UI, create secret named: DISCORD_TOKEN
# Then reference: ${DISCORD_TOKEN}
```

### File Permissions

```bash
# Make configs read-only (best practice)
chmod 444 configs/**/*.yml

# Keep logs writable
chmod 755 logs/
```

### Network Isolation

Services run in isolated Docker network: `parkertron-network`

Only expose ports if needed (default: no exposed ports for security)

## 📞 Support

- **Dockploy Docs**: https://dockploy.io/docs
- **Docker Compose Docs**: https://docs.docker.com/compose
- **Parkertron Issues**: https://github.com/gOOvER/parkertron/issues

---

**Last Updated**: November 21, 2025  
**Parkertron Version**: 0.5.0 (Go 1.22 LTS)
