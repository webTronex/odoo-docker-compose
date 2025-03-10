#!/bin/bash
# run.sh for Odoo 17 instance deployment with custom port mapping
# Usage: sudo bash run.sh <instance_name> <ODOO_ACCESS_PORT> <LIVE_CHAT_PORT>
#
# For instance 1 (Odoo 17): use: sudo bash run.sh odoo-one 1017 2017
# For instance 2 (Odoo 17): use: sudo bash run.sh erp-second 1117 2117

if [ "$#" -ne 3 ]; then
    echo "Usage: sudo bash run.sh <instance_name> <ODOO_ACCESS_PORT> <LIVE_CHAT_PORT>"
    exit 1
fi

INSTANCE_NAME=$1
ODOO_ACCESS_PORT=$2
LIVE_CHAT_PORT=$3

echo "Deploying Odoo 17 instance: $INSTANCE_NAME"
echo "Odoo Access Host Port: $ODOO_ACCESS_PORT"
echo "Live Chat Host Port: $LIVE_CHAT_PORT"

# Create a docker-compose.yml file dynamically
cat > docker-compose.yml <<EOF
version: '3'
services:
  odoo:
    image: odoo:17.0
    ports:
      - "$ODOO_ACCESS_PORT:8069"   # Maps host port (e.g., 1017 or 1117) to container’s Odoo port
      - "$LIVE_CHAT_PORT:8072"      # Maps host port (e.g., 2017 or 2117) to container’s live chat port
    environment:
      - INSTANCE_NAME=$INSTANCE_NAME
    volumes:
      - ./addons_${ODOO_ACCESS_PORT}:/mnt/extra-addons
EOF

# Create the addons directory for this instance if it doesn't exist
mkdir -p addons_${ODOO_ACCESS_PORT}

echo "Starting Odoo 17 instance..."
docker-compose up -d

echo "Odoo 17 instance '$INSTANCE_NAME' deployed with:"
echo "  - Odoo access on port: $ODOO_ACCESS_PORT"
echo "  - Live chat on port: $LIVE_CHAT_PORT"
