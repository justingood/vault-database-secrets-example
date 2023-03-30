#!/bin/bash

export VAULT_TOKEN="abcd"
export VAULT_ADDR="http://vault:8200"
export VAULT_SKIP_VERIFY=true

sleep 7

echo -e "\n##################################"
echo -e "# Pretend this is an application #"
echo -e "##################################"


echo -e "\nRetrieving new DB secrets..."
CREDS=$(vault read -format=json database/creds/my-role)
echo $CREDS | jq .
LEASE_ID=$(echo $CREDS | jq -r '.lease_id')
USER=$(echo $CREDS | jq -r '.data.username')
PASS=$(echo $CREDS | jq -r '.data.password')


while true; do
  sleep $(shuf -i 2-5 -n 1)

  echo -e "\nThe time on our lease is:"
  echo -e "-------------------------"
  vault lease lookup $LEASE_ID

  echo -e "\nTesting database connection..."
  pg_isready -d "postgresql://${USER}:${PASS}@postgres:5432/postgres?sslmode=disable"

  echo -e "\nWaiting for 30 seconds..."
  sleep 30

  echo -e "\nTesting database connection..."
  pg_isready -d "postgresql://${USER}:${PASS}@postgres:5432/postgres?sslmode=disable"
  
  echo -e "\nRenewing lease..."
  echo -e "-------------------"
  vault lease renew $LEASE_ID
done
