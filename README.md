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

## Repository Structure
