# Contributing

## 1. Workflow

1. Create or update a spec under `specs/<id>-<name>/`.
2. Implement by scope: `backend/`, `frontend/`, `infra/`.
3. Keep changes focused and reviewable.
4. Link spec and acceptance criteria in your PR.

## 2. Local Setup

1. Backend:
   ```bash
   make bootstrap
   ```
2. Frontend:
   ```bash
   make frontend-install
   ```

## 3. Validation

1. Backend quality gate:
   ```bash
   make check
   ```
2. Codex wiring check:
   ```bash
   make codex-wiring
   ```
3. Frontend build check:
   ```bash
   cd frontend && npm run build
   ```

## 4. Pull Request Requirements

1. Explain problem, solution, and verification evidence.
2. Include impacted paths (`backend` / `frontend` / `infra`).
3. Include test/build outputs for changed areas.
4. Keep PR scoped to one objective when possible.

