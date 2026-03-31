# Codex-Aligned Starter For Python + MySQL + React + Semi

[English](./README.md) | [简体中文](./README.zh-CN.md)

This repository is tailored to your current stack while keeping Codex official structure:

1. `AGENTS.md` for repository instructions.
2. `.agents/skills/` for reusable project skills.
3. `.codex/rules/` for command approval rules.
4. `.codex/agents/` for project-scoped custom subagents.
5. `specs/` for task context and acceptance.

## Directory Layout

```text
.
├── AGENTS.md
├── .agents/
│   └── skills/
├── .codex/
│   ├── rules/
│   └── agents/
├── backend/
│   ├── src/backend_service/
│   └── tests/
├── frontend/
│   ├── src/
│   └── package.json
├── infra/
│   └── mysql/
├── specs/
├── docs/
├── scripts/
├── Makefile
└── pyproject.toml
```

## Quick Start

1. Backend bootstrap and checks:

```bash
make bootstrap
make run
make check
```

2. Frontend bootstrap and run:

```bash
make frontend-install
make run-frontend
```

3. Check local MySQL (native service, non-Docker):

```bash
make db-local-check
```

## Command Reference

```bash
make fmt
make lint
make test
make check
make run
make frontend-install
make run-frontend
make db-local-check
make mysql-up-docker
make codex-wiring
```

## Local DB Policy

1. Default local development uses native local MySQL (no Docker required).
2. Docker compose is kept for deployment-like/containerized scenarios only.
3. If you need containerized DB temporarily, use:
   ```bash
   make mysql-up-docker
   ```

## How To Use With Codex

1. Write the task in `specs/<id>-<name>/`.
2. Keep global routing and constraints in `AGENTS.md`.
3. Put reusable routines in `.agents/skills/*/SKILL.md`.
4. Put command-approval policies in `.codex/rules/*.rules`.
5. Put custom subagents in `.codex/agents/*.toml`.
6. Ask Codex to implement and then run `make check`.

## Runtime Compatibility Notes

1. This template is designed to be compatible with Codex-style workflows.
2. Actual auto-loading and routing behavior depends on the Codex runtime/integration you use.
3. `contexts/` are repository assets and routing hints, not guaranteed auto-loaded components.
4. Project-scoped subagent availability depends on runtime support for `.codex/agents/*.toml`.
5. For deterministic behavior, explicitly name required skills/subagents in your prompt.

## Auto-Wiring Map

1. Context presets: `contexts/dev.md` (implementation), `contexts/review.md` (review), `contexts/research.md` (research).
2. Skill and subagent routing is recommendation-oriented and runtime-dependent.
3. Skills can be requested by name (for example `python-patterns`, `frontend-patterns`, `semi-ui-skills`).
4. Custom subagents can be requested by name: `planner`, `architect`, `code-reviewer`, `python-reviewer`, `typescript-reviewer`, `database-reviewer`, `performance-optimizer`.

## Official References

1. [AGENTS.md guide](https://developers.openai.com/codex/guides/agents-md)
2. [Skills](https://developers.openai.com/codex/skills)
3. [Rules](https://developers.openai.com/codex/rules)
4. [Codex docs home](https://developers.openai.com/codex)
