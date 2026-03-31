# Infra AGENTS.md

Additional instructions for files under `infra/`.

## Database Focus

1. Database runtime is MySQL.
2. Schema/init scripts live in `infra/mysql/init/`.
3. Keep SQL changes idempotent where possible.
4. Local development defaults to native MySQL; docker compose here is for deployment-like/containerized usage.

## Preferred Skills

1. `database-migrations`
2. `api-design` when schema changes impact public contracts.
