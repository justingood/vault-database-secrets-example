#!/bin/bash

echo "Waiting for Vault to be ready"
sleep 3

export VAULT_TOKEN="abcd"
export VAULT_ADDR="http://vault:8200"
export VAULT_SKIP_VERIFY=true

echo -e "\nEnabling Vault database secrets mount"
vault secrets enable database

echo -e "\nConfiguring Vault database connection"
vault write database/config/my-postgresql-database \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="my-role" \
    connection_url="postgresql://{{username}}:{{password}}@postgres:5432/postgres?sslmode=disable" \
    username="postgres" \
    password="password"

echo -e "\nConfiguring Vault database secrets role"
vault write database/roles/my-role \
    db_name="my-postgresql-database" \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1m" \
    max_ttl="4m"
