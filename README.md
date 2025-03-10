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

For CentOS/RHEL:
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
Quick Start
Each Odoo branch has its own folder and a deployment script that accepts four parameters:

instance_name (e.g. odoo-main)
ODOO_PORT (host port for Odoo web access)
LIVE_CHAT_PORT (host port for live chat service)
docker_folder (custom folder name for the instance)
Odoo 16
# First instance (using custom folder "my_odoo16_instance")
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo16/run.sh | sudo bash -s odoo-main 1016 2016 my_odoo16_instance

# Additional instance (using custom folder "my_odoo16_aux")
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo16/run.sh | sudo bash -s erp-aux 1116 2116 my_odoo16_aux
Odoo 17
# First instance (using custom folder "my_odoo17_instance")
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo17/run.sh | sudo bash -s odoo-main 1017 2017 my_odoo17_instance

# Additional instance (using custom folder "my_odoo17_aux")
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo17/run.sh | sudo bash -s erp-aux 1117 2117 my_odoo17_aux
Odoo 18
# First instance (using custom folder "my_odoo18_instance")
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo18/run.sh | sudo bash -s odoo-main 1018 2018 my_odoo18_instance

# Additional instance (using custom folder "my_odoo18_aux")
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo18/run.sh | sudo bash -s erp-aux 1118 2118 my_odoo18_aux
Port Matrix
Version	Default Port Range	Example Instance
16	1016-1999	erp-legacy 1016 2016
17	1017-1999	main-erp 1017 2017
18	1018-1999	new-system 1018 2018
Instance Management
Accessing Instances
Web Interface: http://localhost:<YOUR_PORT>
Master Password: admin (change in script if needed)
Adding Custom Modules
Place your addons in the directory named addons_<PORT_NUMBER> inside the instance folder.
Restart the container:
docker compose restart
Removing an Instance
Inside the instance folder, run:

docker compose down -v
rm -rf addons_* config data data_db_*
Advanced Configuration
Centralized Addons
To use a centralized addons configuration across all instances:

Edit the docker-addons.yml file in each Odoo branch directory.
Deploy with:
docker compose -f docker-compose.yml -f docker-addons.yml up -d
Custom Master Password
Edit the MASTER_PASSWORD variable in the respective run.sh script before execution.

Security Best Practices
Production Recommendations:

Change default master password immediately
Enable HTTPS through a reverse proxy (e.g., Nginx or Traefik)
Implement regular backups
Use firewall rules to restrict port access
Non-Root Execution:

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker  # Reload group permissions
Troubleshooting
Port Conflicts:

# Check used ports
sudo lsof -i -P -n | grep LISTEN

# Find process using a specific port
sudo lsof -i :<PORT_NUMBER>
Permission Issues:

sudo chown -R $USER:$USER .
docker system prune -a --volumes
View Container Logs:

docker compose logs -f
Repository Structure
arduino
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

Support
For issues and feature requests, please open an issue.

---

### docker-addons.yml

This file is identical for each Odoo branch. It provides a centralized addons configuration that you can use by mounting a shared addons directory into the Odoo container. Adjust as needed.

```yaml
version: '3'
services:
  odoo:
    volumes:
      # Centralized addons folder for all instances (optional)
      - ./central_addons:/mnt/central-addons
How to Use These Files
Repository Setup:
Organize your repository as shown in the structure above. Each Odoo version folder (odoo16, odoo17, odoo18) should contain its own run.sh and docker-addons.yml.

Deploy an Instance:
Use the provided curl commands (with the updated URLs) for each version, passing your desired folder name as the fourth parameter. For example, to deploy an Odoo 18 instance:

curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo18/run.sh | sudo bash -s odoo-main 1018 2018 my_odoo18_instance
(Optional) Use Centralized Addons:
Edit the docker-addons.yml file if you need to change the centralized addons directory path. Then deploy using:

docker compose -f docker-compose.yml -f docker-addons.yml up -d
Install Docker & Docker Compose as shown above if not already installed.

Happy deploying!
