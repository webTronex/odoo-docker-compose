#!/bin/bash
# Odoo 16 Deployment Script with Postgres Database, custom folder for Docker files,
# auto-generation of a minimal config file, and a command to fix permissions.
#
# Usage:
#   curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo16/run.sh | sudo bash -s <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>
# Example:
#   sudo bash run.sh odoo-main 1016 2016 my_odoo16_instance

set -e

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>"
    echo "Example: $0 odoo-main 1016 2016 my_odoo16_instance"
    exit 1
fi

INSTANCE_NAME="$1"
ODOO_PORT="$2"
LIVE_CHAT_PORT="$3"
DOCKER_FOLDER="$4"
ODOO_VERSION="16.0"
MASTER_PASSWORD="admin"

check_port() {
    if lsof -i :"$1" >/dev/null; then
        echo "Port $1 is already in use! Choose different ports."
        exit 1
    fi
}

check_port "$ODOO_PORT"
check_port "$LIVE_CHAT_PORT"

mkdir -p "$DOCKER_FOLDER"
cd "$DOCKER_FOLDER"

export INSTANCE_NAME ODOO_PORT LIVE_CHAT_PORT ODOO_VERSION MASTER_PASSWORD

cat <<EOF | envsubst > docker-compose.yml
services:
  db-\${INSTANCE_NAME}:
    image: postgres
