# Odoo Multi-Version Docker Deployment

Deploy multiple Odoo instances (v16, v17, v18) with isolated environments using single-line commands.

![Odoo Docker Deployment](https://img.shields.io/badge/Odoo-18.0-%23a347ff?logo=odoo&logoColor=white)
![Docker Support](https://img.shields.io/badge/Docker-24.0+-%232496ED?logo=docker&logoColor=white)

## Features

- 🐳 One-command installation for any Odoo version
- 🔒 Isolated instances with dedicated ports and separate Docker folders
- 📦 Automatic addons directory creation
- 🔄 Easy scaling for multiple instances on the same server
- 🛡️ Persistent data storage
- 🔧 Centralized addons configuration (optional)

## Prerequisites

- Linux/Unix system (recommended)
- 4GB+ RAM (8GB recommended for multiple instances)
- Docker 24.0+ and Docker Compose 2.20+ installed

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
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
docker --version
docker compose version
