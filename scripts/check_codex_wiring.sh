#!/usr/bin/env bash
set -euo pipefail

missing=0

for required in AGENTS.md .agents/skills .codex/rules .codex/agents contexts; do
  if [[ ! -e "${required}" ]]; then
    echo "Missing: ${required}"
    missing=1
  fi
done

for context_file in contexts/dev.md contexts/review.md contexts/research.md; do
  if [[ ! -f "${context_file}" ]]; then
    echo "Missing context file: ${context_file}"
    missing=1
  fi
done

for agent_md in agents/*.md; do
  base="$(basename "${agent_md}" .md)"
  if [[ ! -f ".codex/agents/${base}.toml" ]]; then
    echo "Missing mapped subagent: .codex/agents/${base}.toml"
    missing=1
  fi
done

if [[ -x ".venv/bin/python" ]]; then
  .venv/bin/python - <<'PY'
import glob
import tomllib
from pathlib import Path

paths = [*glob.glob(".codex/agents/*.toml"), ".codex/config.toml"]
for path in paths:
    data = Path(path).read_text(encoding="utf-8")
    tomllib.loads(data)
print("TOML parse check passed.")
PY
else
  echo "Skip TOML parse check: .venv/bin/python not found."
fi

if [[ ${missing} -ne 0 ]]; then
  echo "Codex wiring check failed."
  exit 1
fi

echo "Codex wiring check passed."
