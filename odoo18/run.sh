#!/bin/bash
# Odoo 18 Deployment Script with Postgres Database, custom folder for Docker files,
# auto-generation of a minimal config file, and permission fix for host volumes.
#
# Usage:
#   curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo18/run.sh | sudo bash -s <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>
# Example:
#   sudo bash run.sh odoo-main 1018 2018 my_odoo18_instance

set -e

# Validate arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>"
    echo "Example: $0 odoo-main 1018 2018 my_odoo18_instance"
    exit 1
fi

INSTANCE_NAME="$1"
ODOO_PORT="$2"
LIVE_CHAT_PORT="$3"
DOCKER_FOLDER="$4"
ODOO_VERSION="18.0"
MASTER_PASSWORD="admin"  # Change default as needed

# Function to check port availability
check_port() {
    if lsof -i :"$1" >/dev/null ; then
        echo "Port $1 is already in use! Choose different ports."
        exit 1
    fi
}

check_port "$ODOO_PORT"
check_port "$LIVE_CHAT_PORT"

# Create and switch to the custom folder
mkdir -p "$DOCKER_FOLDER"
cd "$DOCKER_FOLDER"

# Export variables for substitution
export INSTANCE_NAME ODOO_PORT LIVE_CHAT_PORT ODOO_VERSION MASTER_PASSWORD

# Generate docker-compose.yml using envsubst
cat <<EOF | envsubst > docker-compose.yml
services:
  db-\${INSTANCE_NAME}:
    image: postgres:14
    environment:
      - POSTGRES_USER=odoo
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_DB=postgres
    volumes:
      - ./data_db_\${ODOO_PORT}:/var/lib/postgresql/data

  odoo-\${INSTANCE_NAME}:
    image: odoo:\${ODOO_VERSION}
    depends_on:
      - db-\${INSTANCE_NAME}
    ports:
      - "\${ODOO_PORT}:8069"
      - "\${LIVE_CHAT_PORT}:8072"
    environment:
      - DB_HOST=db-\${INSTANCE_NAME}
      - DB_PORT=5432
      - DB_USER=odoo
      - DB_PASSWORD=odoo
      - MASTER_PASSWORD=\${MASTER_PASSWORD}
    volumes:
      - ./addons_\${ODOO_PORT}:/mnt/extra-addons
     
