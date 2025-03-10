# Odoo Multi-Version Docker Deployment

Deploy multiple Odoo instances (v16, v17, v18) with isolated environments using single-line commands.

![Odoo Docker Deployment](https://img.shields.io/badge/Odoo-18.0-%23a347ff?logo=odoo&logoColor=white)
![Docker Support](https://img.shields.io/badge/Docker-24.0+-%232496ED?logo=docker&logoColor=white)

## Features

- 🐳 One-command installation for any Odoo version
- 🔒 Isolated instances with dedicated ports
- 📦 Automatic addons directory creation
- 🔄 Easy scaling for multiple instances
- 🛡️ Persistent data storage
- 🔧 Centralized addons configuration

## Prerequisites

- Linux/Unix system (recommended)
- 4GB+ RAM (8GB recommended for multiple instances)
- Docker 24.0+ and Docker Compose 2.20+

### Install Latest Docker & Docker Compose

**For Ubuntu/Debian:**
```bash
# Remove old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install dependencies
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
docker --version
docker compose version
```

**For CentOS/RHEL:**
```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
```

## Quick Start

### Odoo 16
```bash
# First instance
curl -s https://raw.githubusercontent.com/webTronex/odoo16/main/run.sh | sudo bash -s odoo-main 1016 2016

# Additional instance
curl -s https://raw.githubusercontent.com/webTronex/odoo16/main/run.sh | sudo bash -s erp-aux 1116 2116
```

### Odoo 17
```bash
# First instance
curl -s https://raw.githubusercontent.com/webTronex/odoo17/main/run.sh | sudo bash -s odoo-main 1017 2017

# Additional instance
curl -s https://raw.githubusercontent.com/webTronex/odoo17/main/run.sh | sudo bash -s erp-aux 1117 2117
```

### Odoo 18
```bash
# First instance
curl -s https://raw.githubusercontent.com/webTronex/odoo18/main/run.sh | sudo bash -s odoo-main 1018 2018

# Additional instance
curl -s https://raw.githubusercontent.com/webTronex/odoo18/main/run.sh | sudo bash -s erp-aux 1118 2118
```

## Port Matrix

| Version | Default Port Range | Example Instance        |
|---------|--------------------|-------------------------|
| 16      | 1016-1999          | `erp-legacy 1016 2016`  |
| 17      | 1017-1999          | `main-erp 1017 2017`    |
| 18      | 1018-1999          | `new-system 1018 2018`  |

## Instance Management

### Accessing Instances
- **Web Interface:** `http://localhost:<YOUR_PORT>`
- **Master Password:** `admin` (change in script if needed)

### Adding Custom Modules
1. Place your addons in `addons_<PORT_NUMBER>` directory
2. Restart container: 
```bash
docker-compose restart
```

### Removing an Instance
```bash
docker-compose down -v
rm -rf addons_* config data
```

## Advanced Configuration

### Centralized Addons
1. Edit `docker-addons.yml` in version directory
2. Deploy with:
```bash
docker-compose -f docker-compose.yml -f docker-addons.yml up -d
```

### Custom Master Password
Edit the `MASTER_PASSWORD` variable in the run.sh script before execution.

## Security Best Practices

1. **Production Recommendations:**
   - Change default master password immediately
   - Enable HTTPS through reverse proxy (Nginx/Traefik)
   - Implement regular backups
   - Use firewall rules to restrict port access

2. **Non-Root Execution:**
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker  # Reload group permissions
```

## Troubleshooting

**Port Conflicts:**
```bash
# Check used ports
sudo lsof -i -P -n | grep LISTEN

# Find process using a port
sudo lsof -i :<PORT_NUMBER>
```

**Permission Issues:**
```bash
sudo chown -R $USER:$USER .
docker system prune -a --volumes
```

**View Container Logs:**
```bash
docker-compose logs -f
```

## Repository Structure
```
.
├── odoo16/
│   ├── run.sh
│   └── docker-addons.yml
├── odoo17/
│   ├── run.sh
│   └── docker-addons.yml
├── odoo18/
│   ├── run.sh
│   └── docker-addons.yml
└── README.md
```

## Support
For issues and feature requests, please [open an issue](https://github.com/webTronex/odoo-docker/issues).
