#!/bin/bash
# Odoo 17 Deployment Script with Postgres Database, custom folder for Docker files,
# auto-generation of a minimal config file, and permission fix for host volumes.
#
# Usage:
#   curl -s https://raw.githubusercontent.com/webTronex/odoo-docker-compose/main/odoo17/run.sh | sudo bash -s <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>
# Example:
#   sudo bash run.sh odoo-main 1017 2017 my_odoo17_instance

set -e

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT> <docker_folder>"
    echo "Example: $0 odoo-main 1017 2017 my_odoo17_instance"
    exit 1
fi

INSTANCE_NAME="$1"
ODOO_PORT="$2"
LIVE_CHAT_PORT="$3"
DOCKER_FOLDER="$4"
ODOO_VERSION="17.0"
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
      - ./config:/etc/odoo
      - ./data:/var/lib/odoo
EOF

mkdir -p addons_"$ODOO_PORT" config data data_db_"$ODOO_PORT"

sudo chown -R 999:999 addons_"$ODOO_PORT" config data data_db_"$ODOO_PORT"

if [ ! -f config/odoo.conf ]; then
  cat > config/odoo.conf <<EOC
[options]
db_host = db-${INSTANCE_NAME}
db_port = 5432
db_user = odoo
db_password = odoo
addons_path = /mnt/extra-addons
EOC
fi

docker compose up -d

echo "Odoo ${ODOO_VERSION} instance '${INSTANCE_NAME}' deployed in folder '${DOCKER_FOLDER}'!"
echo "Access URL: http://localhost:${ODOO_PORT}"
echo "Master Password: ${MASTER_PASSWORD}"
