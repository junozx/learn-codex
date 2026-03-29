# Architecture Notes

## Components

1. Backend (`backend/src`): API and domain logic.
2. Frontend (`frontend/src`): React + Semi UI.
3. Infra (`infra/mysql`): local MySQL runtime and init SQL.

## Principles

1. Keep backend domain logic isolated from transport/infra concerns.
2. Keep frontend organized by business modules/routes.
3. Keep schema changes explicit and versioned under `infra/mysql/init`.

## Evolution Path

1. Start with a modular monolith for backend and frontend.
2. Split backend by domain packages when complexity increases.
3. Introduce async, queueing, and caching only when measurable need appears.
