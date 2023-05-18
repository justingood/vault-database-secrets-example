# Vault Database Secrets Example

This is a quick example to show how Vault's Database secrets work. Docker-compose spins up three containers: 
* Vault
* PostgreSQL
* Configure
* Service

The test can be spun up by running:
```
docker-compose up --build
```

## What it's doing

1. The Configure container first runs a script that configures Vault's Database Secrets backend and creates the necessary Role (imaginatively-named `my-role`).

2. Then, the Service container requests new secrets for this Role. These secrets come with a **60s lease**.

3. The 'service' then runs a loop that tests the DB connection and renews the secret **lease** every 30 seconds.

4. This continues until the secret reaches the `max_ttl`, which is set to 4 minutes in this example. At this point, Vault revokes the secret, and the connection will fail. A warning will be returned when attempting to renew a lease that would go beyond the `max_ttl`.

## Other useful info
* You can connect to the Vault UI at http://localhost:8200 (if the Docker networking Gods allow)
  * You can login with the root token `abcd`
