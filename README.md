# Odoo Docker Deployment with Custom Port Sequences and Addons

This repository contains deployment scripts for multiple Odoo instances (versions 16, 17, and 18) using Docker and Docker Compose with unique port sequences and support for third-party addons.

## Features

- **Custom Port Mapping:**
  - **Odoo 18:**
    - Instance 1: Odoo access on **1018**, Live Chat on **2018**
    - Instance 2: Odoo access on **1118**, Live Chat on **2118**
- **Odoo 17:**
    - Instance 1: Odoo access on **1017**, Live Chat on **2017**
    - Instance 2: Odoo access on **1117**, Live Chat on **2117**
  - **Odoo 16:**
    - Instance 1: Odoo access on **1016**, Live Chat on **2016**
    - Instance 2: Odoo access on **1116**, Live Chat on **2116**

- **Third‑Party Addons:**
  - Each instance mounts its own addons folder (e.g., `addons_1017` for an instance using port 1017).
  - Optionally, use the `docker-addons.yml` file to centralize addons configuration.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- odoo17 ├── run.sh # Deployment script for Odoo 17 └── addons_1017/ # Folder for third-party modules for the first instance /odoo18 ├── run.sh # Deployment script for Odoo 18 └── addons_1018/ # Folder for third-party modules for the first instance /odoo16 ├── run.sh # Deployment script for Odoo 16 └── addons_1016/ # Folder for third-party modules for the first instance /docker-addons.yml # (Optional) Docker addons configuration file README.md # This file

## How to Deploy an Odoo Instance

#1. **Clone this repository:**

   git clone https://github.com/webTronex/your_repo.git
   cd your_repo/odoo17   # Change to odoo17, odoo18, or odoo16 as needed
#Run the Deployment Script:

For example, to deploy the first Odoo 17 instance:

sudo bash run.sh odoo-one 1017 2017
#To deploy the second Odoo 17 instance:

sudo bash run.sh erp-second 1117 2117
#(Replace the port numbers as appropriate for Odoo 18 or Odoo 16.)

#Accessing the Instances:
#Open your browser and navigate to http://localhost:1017 (or the appropriate host port) for Odoo access.
#The live chat service is available on the corresponding live chat port (e.g., 2017).

#Adding Third‑Party Modules:
#Place your custom addons in the corresponding addons folder (e.g., addons_1017 for the instance running on port 1017).
#The container mounts this folder at /mnt/extra-addons, making your third‑party modules available.
#Using the Docker Addons File
#If you wish to use the separate docker-addons.yml file, customize it to suit your environment and run Docker Compose with an override:
docker-compose -f docker-compose.yml -f docker-addons.yml up -d
#Final Notes
#Ensure the host ports you choose are not already in use.
#Test the scripts in a staging environment before deploying to production.
#Modify the scripts and configuration files as needed to suit your deployment requirements.
#By following this guide and using the provided files, you’ll be able to deploy multiple Odoo instances with unique port configurations and separate addons directories for third‑party modules.
#Happy deploying!

## Repository Structure
