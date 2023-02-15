# Vault Database Secrets Example

This is a quick example to show how Vault's Database secrets work. Docker-compose spins up three containers: 
* Vault
* PostgreSQL
* Ubuntu

The test can be spun up by running:
```
docker-compose up --build
```

## What it's doing

1. The Ubuntu container first runs a script that configures Vault's Database Secrets backend and creates the necessary Role (imaginatively named `my-role`).

2. Then, it requests new secrets for this Role. They come with a 60s lease.

3. It then runs a loop that tests the DB connection and renews the secret lease every 30 seconds.

4. This continues until the secret reaches the `max_ttl`, which is set to 4 minutes. At this point, Vault revokes the secret, and the connection will fail. We will see a warning when we attempt to renew a leas that would go beyond the `max_ttl`.

## Other useful info
* You can connect to the Vault UI at http://localhost:8200
  * You can login with the root token `abcd`
