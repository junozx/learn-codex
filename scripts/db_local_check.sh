#!/usr/bin/env bash
set -euo pipefail

MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3306}"

python3 - <<PY
import socket
host = "${MYSQL_HOST}"
port = int("${MYSQL_PORT}")
sock = socket.socket()
sock.settimeout(1.5)
try:
    sock.connect((host, port))
except OSError as exc:
    raise SystemExit(
        f"Local MySQL is not reachable at {host}:{port}. "
        f"Start your local MySQL service and retry."
    ) from exc
finally:
    sock.close()

print(f"Local MySQL is reachable at {host}:{port}.")
PY

