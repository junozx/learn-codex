#!/usr/bin/env bash
set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required. Install: https://docs.astral.sh/uv/getting-started/installation/"
  exit 1
fi

uv sync --dev

if [[ "${INSTALL_FRONTEND:-0}" == "1" ]]; then
  if ! command -v npm >/dev/null 2>&1; then
    echo "npm is required for frontend bootstrap."
    exit 1
  fi
  (cd frontend && npm install)
fi

echo "Bootstrap complete (backend)."
echo "Frontend deps are optional: run 'make frontend-install' when needed."
