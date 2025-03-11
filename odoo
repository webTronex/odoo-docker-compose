#!/bin/bash
# Unified Odoo Deployment Script (Supports 16, 17, 18)
# Usage: curl -s https://raw.githubusercontent.com/YOUR_GITHUB_USER/odoo-docker-compose/main/run.sh | sudo bash -s <version> <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>

set -eo pipefail

# Validate arguments
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <version> <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>"
    echo "Example: $0 18 odoo-main 1018 2018 my_odoo18_instance"
    exit 1
fi

# Configuration
VERSION="$1"
INSTANCE_NAME="$2"
ODOO_PORT="$3"
LIVE_CHAT_PORT="$4"
DOCKER_FOLDER="$5"
MASTER_PASSWORD="admin"  # Change before production
ODOO_UID="101"
POSTGRES_UID="999"

# Version-specific settings
case "$VERSION" in
  16)
    ODOO_IMAGE="odoo:16"
    ;;
  17)
    ODOO_IMAGE="odoo:17"
    ;;
  18)
    ODOO_IMAGE="odoo:18"
    ;;
  *)
    echo "Invalid version. Use 16, 17, or 18."
    exit 1
esac

# Dependency checks
command -v docker >/dev/null 2>&1 || { echo >&2 "Docker required. Install first."; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo >&2 "Docker Compose required."; exit 1; }

# Port validation
check_port() {
    if lsof -i :"$1" >/dev/null 2>&1; then
        echo "ERROR: Port $1 already in use!"
        exit 1
    fi
}

check_port "$ODOO_PORT"
check_port "$LIVE_CHAT_PORT"

# Directory setup
mkdir -p "$DOCKER_FOLDER"
cd "$DOCKER_FOLDER"

# Generate docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3.8'

services:
  db:
    image: postgres:14
    user: "${POSTGRES_UID}"
    environment:
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: odoo
      POSTGRES_DB: postgres
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
    networks:
      - odoo-net

  odoo:
    image: ${ODOO_IMAGE}
    user: "${ODOO_UID}"
    depends_on:
      - db
    ports:
      - "${ODOO_PORT}:8069"
      - "${LIVE_CHAT_PORT}:8072"
    environment:
      HOST: db
      USER: odoo
      PASSWORD: ${MASTER_PASSWORD}
    volumes:
      - ./addons:/mnt/extra-addons
      - ./config:/etc/odoo
      - ./data:/var/lib/odoo
    networks:
      - odoo-net

networks:
  odoo-net:
    driver: bridge
EOF

# Directory structure
mkdir -p {addons,config,data,postgres_data}

# Permissions
sudo chown -R ${ODOO_UID}:${ODOO_UID} addons config data
sudo chown -R ${POSTGRES_UID}:${POSTGRES_UID} postgres_data
sudo chmod -R 755 addons config data postgres_data

# Configuration file
if [ ! -f config/odoo.conf ]; then
  cat > config/odoo.conf <<EOC
[options]
db_host = db
db_port = 5432
db_user = odoo
db_password = odoo
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo/data
session_dir = /var/lib/odoo/session
EOC
fi

# Deployment
docker compose up -d --pull always

# Success message
echo -e "\n\e[1;32mOdoo ${VERSION} Deployment Successful!\e[0m"
echo -e "Access: \e[4mhttp://localhost:${ODOO_PORT}\e[0m"
echo -e "Master Password: \e[1;33m${MASTER_PASSWORD}\e[0m"
echo -e "Data Directory: \e[1;34m${PWD}\e[0m"
echo -e "Stop command: \e[35mcd ${PWD} && docker compose down\e[0m"
