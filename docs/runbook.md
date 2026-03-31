# Runbook

## Backend Setup

```bash
make bootstrap
```

## Backend Validation

```bash
make check
```

## Backend Run

```bash
make run
```

## Frontend Run

```bash
make frontend-install
make run-frontend
```

## MySQL (Local Native Service)

```bash
make db-local-check
```

## MySQL (Containerized, Optional)

Use this only for deployment-like or containerized test scenarios:

```bash
make mysql-up-docker
```

## CI Failure Triage (Backend)

1. Reproduce locally with `make check`.
2. Fix formatting and lint errors first.
3. Re-run tests.
4. Update spec acceptance evidence if behavior changed.
