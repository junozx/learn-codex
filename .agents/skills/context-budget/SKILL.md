---
name: context-budget
description: Audit prompt/context overhead in Codex-style projects and provide prioritized reductions for better latency and answer quality.
origin: ECC-adapted
---

# Context Budget

Analyze context overhead across project instructions, skills, rules, and custom agents, then provide actionable optimizations.

## Scope and Positioning

1. This skill is compatible with Codex-style workflows.
2. It does not assume a specific IDE implementation.
3. Runtime behavior (auto-loading, token accounting, tool metadata size) depends on your integration.

## When To Use

1. Responses become slow or low quality on larger tasks.
2. You recently added many skills, rules, or subagents.
3. You want a deterministic plan to reduce context bloat.

## Audit Method

### Phase 1: Inventory

1. Check `AGENTS.md` chain (root + nested).
2. Check `.agents/skills/*/SKILL.md`.
3. Check `.codex/agents/*.toml`.
4. Check `.codex/rules/*.rules` and language guidance docs.
5. Check optional context assets under `contexts/` and `docs/`.

### Phase 2: Size And Risk Classification

1. Mark very large skill files and very long instruction docs.
2. Mark overlapping guidance across AGENTS/rules/skills.
3. Mark stale assets not referenced by current workflows.
4. Mark high-frequency assets that should be concise.

### Phase 3: Optimization Plan

1. Keep only high-signal instructions in top-level files.
2. Move detailed references to per-skill files.
3. Reduce duplicated guidance across layers.
4. Require explicit skill names for critical flows.

## Report Format

Produce:

1. **Current Overhead Summary**: largest sources by file group.
2. **High-Impact Cuts**: top 3 changes with expected gains.
3. **Safety Notes**: what not to delete to avoid behavior regression.
4. **Execution Order**: smallest-risk edits first.

## Practical Rules

1. Prefer short root `AGENTS.md`; push details into scoped files.
2. Keep skill descriptions precise and activation-oriented.
3. Avoid embedding long examples in always-loaded instructions.
4. Treat context files as reusable assets, not guaranteed auto-loaded inputs.
5. Re-run audit after major structural changes.

