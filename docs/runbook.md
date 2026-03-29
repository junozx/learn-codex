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

## MySQL Run

```bash
make mysql-up
```

## CI Failure Triage (Backend)

1. Reproduce locally with `make check`.
2. Fix formatting and lint errors first.
3. Re-run tests.
4. Update spec acceptance evidence if behavior changed.
