#!/bin/bash
# Define the Ansible inventory file
INVENTORY_FILE="../Ansible/ansible_inventory.ini"

# Run terraform output to get the instance's public IPs as a space-separated list
PUBLIC_IPS=$(terraform output -json web-address_test_instance_public_ip | jq -r '. | sub("\""; "")')


# Ensure that the "all" group exists in the inventory file
if ! grep -wq "all" "$INVENTORY_FILE"; then
  echo "[all]" >> "$INVENTORY_FILE"
  echo "Added [all] to $INVENTORY_FILE"
else
  echo "[all] already exists in $INVENTORY_FILE"
fi

# Check if the IP addresses already exist in the inventory file
for IP in $PUBLIC_IPS; do
  if ! grep -q "$IP" "$INVENTORY_FILE"; then
    # IP address not found, so add it to the inventory file under the "all" group
    echo "$IP" >> "$INVENTORY_FILE"
    echo "Added $IP to $INVENTORY_FILE"
  else
    echo "$IP already exists in $INVENTORY_FILE"
  fi
done
