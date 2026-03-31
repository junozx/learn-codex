# Stack Structure

This repository uses:

1. Backend: Python (`backend/src`, `backend/tests`)
2. Frontend: React + Semi Design (`frontend/src`)
3. Database: MySQL (`infra/mysql`)

## Local Flow

1. Check local MySQL: `make db-local-check`
2. Run backend: `make run`
3. Run frontend: `make run-frontend`
4. Validate backend quality gate: `make check`

## Containerized MySQL (Optional)

For deployment-like/containerized scenarios only:

1. `make mysql-up-docker`
