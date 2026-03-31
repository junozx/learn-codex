# AGENTS.md

This file defines repository-wide instructions for Codex agents.

## Scope

1. Applies to the whole repository unless a deeper `AGENTS.md` overrides it.

## Source Of Truth

1. Feature intent and acceptance live in `specs/`.
2. Backend code lives in `backend/src/`.
3. Frontend code lives in `frontend/src/`.
4. Backend tests live in `backend/tests/`.
5. Infra definitions live in `infra/`.
6. Architecture and runbooks live in `docs/`.
7. Mode-specific context files live in `contexts/`.

## Required Workflow

1. Before coding, identify the target spec in `specs/<id>-<name>/`.
2. If no spec exists, create one from `specs/000-template/`.
3. Implement in small, reviewable steps by layer (`backend` / `frontend` / `infra`).
4. Add or update tests for backend behavior changes.
5. Run `make check` before finishing.

## Context Routing

1. Default to `contexts/dev.md` for implementation tasks.
2. Use `contexts/review.md` for review/audit requests.
3. Use `contexts/research.md` for investigation/comparison requests.
4. Explicit user instruction overrides the default context choice.
5. Context files are repository assets; actual auto-loading depends on the Codex runtime/integration.

## Skills Routing

1. Backend Python changes: prefer `python-patterns`, `python-testing`, `tdd-workflow`.
2. API contract work: prefer `api-design`.
3. Database/schema changes: prefer `database-migrations`.
4. Frontend React + Semi work: prefer `frontend-patterns`, `semi-ui-skills`.
5. Large tasks with many tools/files: use `context-budget` to reduce prompt bloat.
6. For deterministic behavior, explicitly mention required skills in the task prompt.

## Language Rule Docs

1. For Python edits, apply guidance from `.codex/rules/python/*.md`.
2. For TypeScript/React edits, apply guidance from `.codex/rules/typescript/*.md`.
3. If rule docs conflict with task requirements, follow user instruction and call out trade-offs.

## Custom Subagents

1. Project-scoped custom subagents are defined under `.codex/agents/*.toml`.
2. Use `planner` for implementation plans.
3. Use `architect` for architecture trade-offs.
4. Use `code-reviewer` / `python-reviewer` / `typescript-reviewer` for focused reviews.
5. Use `database-reviewer` for SQL/schema/index reviews.
6. Use `performance-optimizer` for bottleneck and runtime optimization.
7. Availability and auto-selection of subagents depend on runtime support for project-scoped agents.

## Engineering Constraints

1. Keep public interfaces typed.
2. Avoid adding dependencies unless the spec justifies it.
3. Prefer deterministic logic and deterministic tests.
4. Do not change unrelated files.
5. Database schema changes must be captured under `infra/mysql/init/`.
6. Default local development should not require Docker; treat Docker usage as deployment/containerized workflow unless explicitly requested.

## Output Requirements

1. Summarize changed files and behavioral impact.
2. Provide validation commands run and outcomes.
3. Call out residual risks or follow-up work explicitly.
