# Vault Database Secrets Example

This is a quick example to show how Vault's Database secrets work. Docker-compose spins up three containers: Vault, PostgreSQL, Ubuntu. 

It can be spun up by running:
```
docker-compose up --build
```

## What it's doing

1. The Ubuntu container first runs a script that configures Vault's Database Secrets backend and creates the necessary Role (named `my-role`)

2. Then, it requests new secrets for this Role. They come with a 1 minute TTL. 

3. It then runs a loop that tests the DB connection and renews the secret lease every 30 seconds.

4. This continues until the secret reaches the `max_ttl`, which is 4 minutes in this example. At this point, Vault revokes the secret, and the connection will fail. We will see a warning when we attempt to renew a least that would go beyond the `max_ttl`.
