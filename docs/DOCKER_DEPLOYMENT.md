# Docker & Dockploy Deployment Guide

## Overview

Parkertron is now fully containerized and ready for deployment with **Dockploy** or any Docker orchestration platform.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 1.29+
- Dockploy (optional, for management UI)

## Quick Start

### 1. Clone and Setup

```bash
git clone https://github.com/gOOvER/parkertron.git
cd parkertron
cp .env.example .env
```

### 2. Configure Environment

Edit `.env` and set your preferences:
```bash
nano .env
```

### 3. Setup Configuration Files

Create your bot configuration:
```bash
mkdir -p configs/discord
mkdir -p configs/irc
mkdir -p logs

# Copy example configs
cp configs/parkertron.example.yml parkertron.yml
cp configs/discord/example-bot/example.yml configs/discord/your-bot.yml
```

### 4. Build and Start

```bash
# Build the image
docker-compose build

# Start the container
docker-compose up -d

# View logs
docker-compose logs -f parkertron
```

## Dockploy Deployment

### 1. Add to Dockploy

**Via Docker Compose file:**
1. Upload `docker-compose.yml` to Dockploy
2. Set environment variables in Dockploy UI
3. Deploy

**Via Dockploy CLI:**
```bash
dockploy deploy --compose-file docker-compose.yml --service parkertron
```

### 2. Configure Webhooks (Optional)

For log aggregation and monitoring:

```bash
# In .env:
WEBHOOK_LOG_URL=https://discord.com/api/webhooks/YOUR_ID/YOUR_TOKEN
```

### 3. Monitor Health

```bash
# Check container health
docker-compose ps

# View real-time metrics
docker stats parkertron

# Check logs
docker-compose logs parkertron
```

## Configuration Files

### Project Structure

```
parkertron/
├── docker-compose.yml      # Docker Compose configuration
├── .env.example           # Environment template
├── .dockerignore          # Docker build ignore patterns
├── Dockerfile             # Multi-stage build
├── parkertron.exe         # Compiled binary (Linux will be built in container)
├── configs/               # Bot configurations
│   ├── parkertron.yml     # Main config
│   ├── discord/
│   │   └── example-bot/
│   │       └── example.yml
│   ├── irc/
│   │   └── example-bot/
│   │       └── irc.example.yml
│   └── slack/
│       └── example-bot/
│           └── slack.example.yml
└── logs/                  # Log files (persistent volume)
```

### Required Config Files

1. **parkertron.yml** - Main bot configuration
2. **discord/bot-name/config.yml** - Discord bot config (if enabled)
3. **irc/bot-name/config.yml** - IRC bot config (if enabled)

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LOG_LEVEL` | `info` | Logging level: debug, info, warn, error |
| `DISCORD_ENABLED` | `true` | Enable Discord service |
| `IRC_ENABLED` | `false` | Enable IRC service |
| `SLACK_ENABLED` | `false` | Enable Slack service |
| `LOG_DIR` | `/app/logs` | Container log directory |
| `CONFIG_DIR` | `/app/configs` | Container config directory |

## Volume Mounts

| Host Path | Container Path | Purpose |
|-----------|-----------------|---------|
| `./configs` | `/app/configs` | Bot configuration (read-only) |
| `parkertron-logs` | `/app/logs` | Persistent log storage |

## Resource Limits

Current defaults:
- **CPU**: 0.5 cores (limit) / 0.25 cores (reserved)
- **Memory**: 512MB (limit) / 256MB (reserved)

### Adjust for Your Needs

```yaml
deploy:
  resources:
    limits:
      cpus: '1.0'           # Increase CPU
      memory: 1G            # Increase memory
    reservations:
      cpus: '0.5'
      memory: 512M
```

## Health Checks

Container includes a health check:
```bash
# Manual health check
docker exec parkertron test -f /app/parkertron

# View health status
docker ps --no-trunc | grep parkertron
```

## Logging & Monitoring

### View Logs

```bash
# Stream logs
docker-compose logs -f

# Last 100 lines
docker-compose logs --tail=100

# Filter by time
docker-compose logs --since 1m

# Pretty print JSON logs
docker-compose logs | jq '.'
```

### Log Rotation

Logs are automatically rotated:
- Max file size: 10MB
- Max files retained: 3
- Format: JSON

## Networking

The container runs in `parkertron-network` bridge network. For multi-container setups:

```yaml
services:
  parkertron:
    networks:
      - parkertron-network
  
  other-service:
    networks:
      - parkertron-network

networks:
  parkertron-network:
    driver: bridge
```

## Common Commands

```bash
# Start service
docker-compose up -d parkertron

# Stop service
docker-compose down

# Restart service
docker-compose restart parkertron

# Rebuild image
docker-compose build --no-cache

# Execute command in container
docker-compose exec parkertron ls -la /app

# View resource usage
docker stats parkertron

# Push to registry
docker tag parkertron:latest myregistry/parkertron:latest
docker push myregistry/parkertron:latest
```

## Troubleshooting

### Container won't start

```bash
# Check logs
docker-compose logs parkertron

# Check resource availability
docker stats

# Check file permissions
ls -la configs/
```

### Configuration not loaded

```bash
# Verify config volume is mounted
docker inspect parkertron | grep -A 10 "Mounts"

# Check config syntax
docker-compose exec parkertron cat /app/parkertron.yml
```

### Memory/CPU issues

```bash
# Monitor resource usage in real-time
docker stats parkertron --no-stream

# Increase limits in docker-compose.yml
# Then rebuild: docker-compose up -d --no-deps parkertron
```

### Bot not responding

```bash
# Check if bot is running
docker-compose ps

# Check recent logs
docker-compose logs --tail=50 parkertron

# Verify Discord/IRC tokens in config
grep -i token configs/discord/*/config.yml
```

## Production Deployment

### Best Practices

1. **Use Named Volumes**
   ```bash
   docker volume create parkertron-logs
   ```

2. **Enable Restart Policy**
   ```yaml
   restart: unless-stopped  # Already in docker-compose.yml
   ```

3. **Set Resource Limits**
   - Prevent container from consuming all resources
   - Already configured with reasonable defaults

4. **Use Environment Variables**
   - Never commit `.env` file
   - Use `.env.example` as template

5. **Enable Logging**
   - JSON driver captures structured logs
   - Easy integration with log aggregation tools

6. **Regular Backups**
   ```bash
   # Backup logs volume
   docker run --rm -v parkertron-logs:/data -v $(pwd):/backup \
     ubuntu tar czf /backup/logs-backup.tar.gz -C /data .
   ```

### Scaling

For multiple bot instances:

```yaml
services:
  parkertron-1:
    build: .
    environment:
      - INSTANCE_NAME=bot-1
    volumes:
      - ./configs/bot-1:/app/configs:ro

  parkertron-2:
    build: .
    environment:
      - INSTANCE_NAME=bot-2
    volumes:
      - ./configs/bot-2:/app/configs:ro
```

## Support & Documentation

- **Main Repository**: https://github.com/gOOvER/parkertron
- **Issue Tracker**: https://github.com/gOOvER/parkertron/issues
- **Discord Documentation**: https://discord.com/developers/docs
- **Docker Documentation**: https://docs.docker.com

## License

See LICENSE file for details.
