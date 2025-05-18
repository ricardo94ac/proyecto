#!/bin/bash

# Requiere jq instalado
if ! command -v jq &> /dev/null; then
  echo "jq no está instalado. Instálalo con: sudo apt install jq"
  exit 1
fi

echo "[web]" > inventory.ini

# Obtiene las IPs desde Terraform output y genera líneas para inventory
terraform output -json instance_ips | jq -r '.[]' | awk '{
    printf "web%d ansible_host=%s ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa_terraform\n", NR, $1
}' >> inventory.ini

echo "Inventory generado:"
cat inventory.ini

