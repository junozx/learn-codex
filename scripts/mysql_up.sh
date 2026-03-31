#!/usr/bin/env bash
set -euo pipefail

echo "This command is intended for deployment-like or containerized environments."
echo "For daily local development, prefer your native local MySQL service."

cd infra/mysql
docker compose up -d
