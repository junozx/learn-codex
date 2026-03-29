PYTHON ?= .venv/bin/python

.PHONY: bootstrap frontend-install fmt lint test check run run-frontend mysql-up codex-wiring tree

bootstrap:
	./scripts/bootstrap.sh

frontend-install:
	cd frontend && npm install

fmt:
	uv run ruff format .

lint:
	uv run ruff check .

test:
	uv run pytest

check:
	./scripts/check.sh

run:
	./scripts/run.sh

run-frontend:
	./scripts/run_frontend.sh

mysql-up:
	./scripts/mysql_up.sh

codex-wiring:
	./scripts/check_codex_wiring.sh

tree:
	@find . -maxdepth 4 | sort
