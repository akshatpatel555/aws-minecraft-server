#!/bin/bash
set -e

echo "========================================="
echo "  Minecraft Server - AWS Deployment"
echo "========================================="

# ── Step 1: Terraform Init & Apply ──
echo ""
echo "[1/4] Initializing Terraform..."
cd terraform
terraform init

echo ""
echo "[2/4] Provisioning AWS infrastructure..."
terraform apply -auto-approve

# Get the public IP from Terraform output
SERVER_IP=$(terraform output -raw instance_public_ip)
echo ""
echo "Instance public IP: $SERVER_IP"

# ── Step 2: Wait for EC2 to be ready ──
echo ""
echo "[3/4] Waiting for EC2 instance to be ready..."
sleep 60
echo "Instance should be ready."

# ── Step 3: Generate Ansible inventory ──
echo ""
echo "[4/4] Configuring Minecraft server with Ansible..."
cd ../ansible

# Replace placeholder in inventory with real IP
sed "s/\${SERVER_IP}/$SERVER_IP/" inventory.ini > inventory_generated.ini

# Run Ansible playbook
ansible-playbook -i inventory_generated.ini playbook.yml

# ── Step 4: Verify ──
echo ""
echo "========================================="
echo "  Deployment Complete!"
echo "========================================="
echo ""
echo "Verifying Minecraft server is reachable..."
sleep 10
nmap -sV -Pn -p T:25565 $SERVER_IP

echo ""
echo "Connect to your Minecraft server at: $SERVER_IP:25565"