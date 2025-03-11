# Odoo Docker Deployment Suite
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

One-command deployment system for Odoo 16, 17, and 18 with Docker

## Features
✅ Single script for all Odoo versions (16/17/18)  
✅ Automatic port conflict detection  
✅ Centralized addons support  
✅ Isolated data directories  
✅ Production-ready permission management  
✅ Easy multi-instance deployment  

## Requirements
1. Docker Engine 20.10+
2. Docker Compose V2
3. Linux/macOS environment
4. `lsof` utility (for port checking)

## Quick Start
### Deploy Odoo 18
```bash
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/08d9a17b8c964b58a8580d478a14b58e2f2061a6/odoo/run.sh | sudo bash -s 18 odoo18 10018 20018 odoo18_instance
```

### Deploy Odoo 17
```bash
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/08d9a17b8c964b58a8580d478a14b58e2f2061a6/odoo/run.sh | sudo bash -s 17 odoo17 10017 20017 odoo17_instance
```

### Deploy Odoo 16
```bash
curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/08d9a17b8c964b58a8580d478a14b58e2f2061a6/odoo/run.sh | sudo bash -s 16 odoo16 10016 20016 odoo16_instance
```

## Centralized Addons
To share addons between instances:
```bash
# Add --addons flag during deployment
curl -s ... | sudo bash -s 18 odoo18 10018 20018 odoo18_instance --addons
```

## Customization
1. **Ports**: Change the 1001X/2001X numbers in commands
2. **Master Password**: 
   ```bash
   export MASTER_PASSWORD="your_secure_password"
   curl ... | sudo -E bash -s ...
   ```
3. **Addons Path**: Add custom paths in `docker-addons.yml`

## Directory Structure
```
your_instance_folder/
├── addons/          # Custom Odoo addons
├── config/          # Odoo configuration files
├── data/            # Filestore and sessions
├── postgres_data/   # Database storage
└── docker-compose.yml
```

## Stopping Instances
```bash
cd your_instance_folder
sudo docker compose down
```

## Security
⚠️ Before production use:
1. Change `MASTER_PASSWORD` in deployment command
2. Restrict database access
3. Configure HTTPS
4. Set appropriate file permissions

## Troubleshooting
- Port conflicts: Use `sudo lsof -i :<port>` to identify blocking processes
- Permission issues: `sudo chown -R 101:101 addons config data`
- Database errors: Check container logs with `docker compose logs -f`

## Support
[Create GitHub Issue](https://github.com/webTronex/odoo-docker-compose/issues)  
[Documentation](https://github.com/webTronex/odoo-docker-compose/wiki)  
```
