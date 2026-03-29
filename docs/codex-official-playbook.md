# Codex Official Playbook (Project Mapping)

This repository maps to Codex official concepts as follows:

1. `AGENTS.md`: repository-wide instructions and constraints.
2. `.agents/skills/`: reusable project skills.
3. `.codex/rules/`: command-approval rule files (`.rules`).
4. `.codex/agents/`: project-scoped custom subagents (`.toml`).
5. `specs/`: task-specific context and acceptance criteria.
6. `contexts/`: mode presets routed from `AGENTS.md`.

## Recommended Use

1. Start every non-trivial task from a spec in `specs/`.
2. Keep `AGENTS.md` concise and stable.
3. Put reusable workflows into skills.
4. Use `.codex/rules` for command approval policy.
5. Use `.codex/agents` for specialist subagents.
6. Validate with `make check`.
7. Treat auto-loading behavior as runtime-dependent; explicitly naming required skills/agents is the most reliable workflow.

## References

1. https://developers.openai.com/codex/guides/agents-md
2. https://developers.openai.com/codex/skills
3. https://developers.openai.com/codex/rules
4. https://developers.openai.com/codex
