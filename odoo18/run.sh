#!/bin/bash
# Odoo 18 Deployment Script with Postgres Database
# Features: Auto-configuration, permission fixes, and folder isolation
# Usage:
#   curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo18/run.sh | sudo bash -s <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>
# Example:
#   sudo bash run.sh odoo-main 1018 2018 my_odoo18_instance

set -eo pipefail

# Validate arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>"
    echo "Example: $0 odoo-main 1018 2018 my_odoo18_instance"
    exit 1
fi

# Configuration
INSTANCE_NAME="$1"
ODOO_PORT="$2"
LIVE_CHAT_PORT="$3"
DOCKER_FOLDER="$4"
ODOO_VERSION="18.0"
MASTER_PASSWORD="admin"  # Change default before production use
ODOO_UID="101"           # Verified UID for Odoo container user
POSTGRES_UID="999"       # Verified UID for Postgres container user

# Dependency checks
command -v docker >/dev/null 2>&1 || { echo >&2 "Docker required. Install docker first."; exit 1; }
command -v lsof >/dev/null 2>&1 || { echo >&2 "lsof required. Install lsof (apt-get install lsof)."; exit 1; }

# Port validation
check_port() {
    if lsof -i :"$1" >/dev/null ; then
        echo "ERROR: Port $1 already in use!"
        exit 1
    fi
}

check_port "$ODOO_PORT"
check_port "$LIVE_CHAT_PORT"

# Folder setup
mkdir -p "$DOCKER_FOLDER"
cd "$DOCKER_FOLDER"

# Generate docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3.8'

services:
  db-${INSTANCE_NAME}:
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

  odoo-${INSTANCE_NAME}:
    image: odoo:${ODOO_VERSION}
    user: "${ODOO_UID}"
    depends_on:
      - db-${INSTANCE_NAME}
    ports:
      - "${ODOO_PORT}:8069"
      - "${LIVE_CHAT_PORT}:8072"
    environment:
      HOST: db-${INSTANCE_NAME}
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

# Create directories with correct permissions
mkdir -p {addons,config,data/postgres_data,data/session}

# Set permissions
sudo chown -R "${ODOO_UID}:${ODOO_UID}" addons config data
sudo chown -R "${POSTGRES_UID}:${POSTGRES_UID}" data/postgres_data
sudo chmod -R 755 addons config data

# Generate default configuration
if [ ! -f config/odoo.conf ]; then
  cat > config/odoo.conf <<EOC
[options]
db_host = db-${INSTANCE_NAME}
db_port = 5432
db_user = odoo
db_password = odoo
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo/data
session_dir = /var/lib/odoo/session
EOC
fi

# Deploy stack
docker compose up -d --pull always

# Verification
echo -e "\n\e[1;32mDeployment Successful!\e[0m"
echo -e "Access URL: \e[4mhttp://localhost:${ODOO_PORT}\e[0m"
echo -e "Master Password: \e[1;33m${MASTER_PASSWORD}\e[0m"
echo -e "Data Directory: \e[1;34m${PWD}/data\e[0m"
echo -e "To stop: \e[35mcd ${PWD} && docker compose down\e[0m\n"
