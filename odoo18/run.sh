#!/bin/bash
# run.sh for Odoo 18 instance deployment with custom port mapping
# Usage: sudo bash run.sh <instance_name> <ODOO_ACCESS_PORT> <LIVE_CHAT_PORT>
#
# Example for instance 1 (Odoo 18): sudo bash run.sh odoo-one 1018 2018
# Example for instance 2 (Odoo 18): sudo bash run.sh erp-second 1118 2118

if [ "$#" -ne 3 ]; then
    echo "Usage: sudo bash run.sh <instance_name> <ODOO_ACCESS_PORT> <LIVE_CHAT_PORT>"
    exit 1
fi

INSTANCE_NAME=$1
ODOO_ACCESS_PORT=$2
LIVE_CHAT_PORT=$3

echo "Deploying Odoo 18 instance: $INSTANCE_NAME"
echo "Odoo Access Host Port: $ODOO_ACCESS_PORT"
echo "Live Chat Host Port: $LIVE_CHAT_PORT"

cat > docker-compose.yml <<EOF
version: '3'
services:
  odoo:
    image: odoo:18.0
    ports:
      - "$ODOO_ACCESS_PORT:8069"
      - "$LIVE_CHAT_PORT:8072"
    environment:
      - INSTANCE_NAME=$INSTANCE_NAME
    volumes:
      - ./addons_${ODOO_ACCESS_PORT}:/mnt/extra-addons
EOF

mkdir -p addons_${ODOO_ACCESS_PORT}

echo "Starting Odoo 18 instance..."
docker-compose up -d

echo "Odoo 18 instance '$INSTANCE_NAME' deployed with Odoo access on port $ODOO_ACCESS_PORT and live chat on port $LIVE_CHAT_PORT"
