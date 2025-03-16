# Odoo Docker Deployment Suite
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Odoo Versions](https://img.shields.io/badge/Odoo-16%20%7C%2017%20%7C%2018-%23a347ff?logo=odoo&logoColor=white)]()
[![Docker](https://img.shields.io/badge/Docker-24.0+-%232496ED?logo=docker&logoColor=white)]()

One-command deployment system for Odoo 16, 17, and 18 with Docker.

## Features
✅ Single script for all Odoo versions (16/17/18)  
✅ Automatic port conflict detection  
✅ Centralized addons support  
✅ Isolated data directories  
✅ Production-ready permission management  
✅ Easy multi-instance deployment  

## Requirements
1. **Docker Engine** 20.10+ ([Install Docker](https://docs.docker.com/get-docker/))
2. **Docker Compose** V2 ([Install Compose](https://docs.docker.com/compose/install/))
3. Linux/macOS environment
4. `lsof` utility (for port checking)

### Install Docker & Docker Compose
#### For Ubuntu/Debian:
```bash
# Remove old versions of Docker
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install dependencies
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, CLI, and Compose Plugin
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
docker --version
docker compose version
```

#### For CentOS/RHEL:
```bash
# Remove old versions of Docker
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# Install required packages
sudo yum install -y yum-utils

# Add Docker repository
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker Engine, CLI, and Compose Plugin
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker installation
docker --version
docker compose version
```

## Quick Start
Each command deploys an isolated Odoo instance with dedicated ports and folders.

### Deploy Odoo 18
```bash
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/66bd7fcc5305870ac9d4b4873108260342fcc427/run.sh | sudo bash -s 18 odoo-main 10018 20018 my_odoo18_instance
```

### Deploy Odoo 17
```bash
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/66bd7fcc5305870ac9d4b4873108260342fcc427/run.sh | sudo bash -s 17 odoo-main 10017 20017 my_odoo17_instance
```

### Deploy Odoo 16
```bash
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/66bd7fcc5305870ac9d4b4873108260342fcc427/run.sh | sudo bash -s 16 odoo-main 1016 2016 my_odoo16_instance
```

## Centralized Addons
To share addons between instances, use the `--addons` flag during deployment:
```bash
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/66bd7fcc5305870ac9d4b4873108260342fcc427/run.sh | sudo bash -s 18 odoo-main 10018 20018 my_odoo18_instance --addons
```

## Customization
1. **Ports**: Change the `10XX` and `20XX` numbers in commands to avoid conflicts.
2. **Master Password**: 
   ```bash
   export MASTER_PASSWORD="your_secure_password"
   curl ... | sudo -E bash -s ...
   ```
3. **Addons Path**: Modify `docker-addons.yml` for custom paths.

## Directory Structure
After deployment, each instance folder will have the following structure:
```
your_instance_folder/
├── addons/          # Custom Odoo addons
├── config/          # Odoo configuration files
├── data/            # Filestore and sessions
├── postgres_data/   # Database storage
└── docker-compose.yml
```

## Stopping Instances
To stop and remove an instance:
```bash
cd your_instance_folder
sudo docker compose down
```

To remove all associated data:
```bash
sudo rm -rf addons config data postgres_data
```

## Security
⚠️ Before production use:
1. Change `MASTER_PASSWORD` in the deployment command.
2. Restrict database access by configuring firewall rules.
3. Configure HTTPS using a reverse proxy like Nginx or Traefik.
4. Set appropriate file permissions:
   ```bash
   sudo chown -R 101:101 addons config data
   sudo chown -R 999:999 postgres_data
   ```

## Troubleshooting
- **Port Conflicts**: Identify blocking processes:
  ```bash
  sudo lsof -i :<port>
  ```
- **Permission Issues**: Fix permissions:
  ```bash
  sudo chown -R 101:101 addons config data
  sudo chown -R 999:999 postgres_data
  ```
- **Database Errors**: Check container logs:
  ```bash
  docker compose logs -f
  ```
Error Handling:
If users encounter issues with docker compose, they can fall back to installing the standalone docker-compose binary using pip:
sudo apt-get install python3-pip
pip3 install docker-compose

## Repository Structure
```
.
├── docker-addons.yml
├── run.sh
└── README.md
```

## Support
For issues and feature requests, please open an issue:
- [Create GitHub Issue](https://github.com/webTronex/odoo-docker-compose/issues)
- [Documentation](https://github.com/webTronex/odoo-docker-compose/wiki)

---

### How to Use These Files
1. **Repository Setup**: Ensure your repository matches the structure above.
2. **Deploy an Instance**: Use the provided `curl` commands for each version.
3. **Centralized Addons**: Edit `docker-addons.yml` if needed and deploy with:
   ```bash
   docker compose -f docker-compose.yml -f docker-addons.yml up -d
   ```

Happy deploying! 🚀
```
