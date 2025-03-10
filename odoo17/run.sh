#!/bin/bash
# Odoo 17 Deployment Script
# Usage: curl -s https://raw.githubusercontent.com/<your-repo>/odoo17/run.sh | sudo bash -s <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT>

set -e  # Exit on error

# Validate arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <instance_name> <ODOO_PORT> <LIVE_CHAT_PORT>"
    echo "Example: $0 odoo-main 1017 2017"
    exit 1
fi

INSTANCE_NAME=$1
ODOO_PORT=$2
LIVE_CHAT_PORT=$3
ODOO_VERSION="17.0"
MASTER_PASSWORD="admin"  # Change default as needed

# Check port availability
check_port() {
    if lsof -i :$1 >/dev/null ; then
        echo "Port $1 is already in use! Choose different ports."
        exit 1
    fi
}

check_port $ODOO_PORT
check_port $LIVE_CHAT_PORT

# Generate docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3'
services:
  odoo-$INSTANCE_NAME:
    image: odoo:$ODOO_VERSION
    ports:
      - "$ODOO_PORT:8069"
      - "$LIVE_CHAT_PORT:8072"
    environment:
      - HOST=localhost
      - USER=odoo
      - PASSWORD=$MASTER_PASSWORD
    volumes:
      - ./addons_$ODOO_PORT:/mnt/extra-addons
      - ./config:/etc/odoo
      - ./data:/var/lib/odoo
EOF

# Create required directories
mkdir -p {addons_$ODOO_PORT,config,data}

# Start container
docker-compose up -d

echo "Odoo $ODOO_VERSION instance '$INSTANCE_NAME' deployed!"
echo "Access URL: http://localhost:$ODOO_PORT"
echo "Master Password: $MASTER_PASSWORD"
