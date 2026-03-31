# Codex 工程化模板（Python + MySQL + React + Semi）

[English](./README.md) | [简体中文](./README.zh-CN.md)

本仓库面向你的技术栈，并保持对 Codex 官方能力结构的兼容：

1. `AGENTS.md`：仓库级指令与协作约束。
2. `.agents/skills/`：可复用的项目技能。
3. `.codex/rules/`：命令审批规则（`.rules`）。
4. `.codex/agents/`：项目级自定义 subagents。
5. `specs/`：需求上下文与验收标准。

## 目录结构

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

## 快速开始

1. 后端初始化与检查：

```bash
make bootstrap
make run
make check
```

2. 前端安装与运行：

```bash
make frontend-install
make run-frontend
```

3. 检查本地 MySQL（原生服务，非 Docker）：

```bash
make db-local-check
```

## 常用命令

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

## 本地数据库策略

1. 默认本地开发使用原生本地 MySQL，不要求 Docker。
2. `docker compose` 仅用于部署风格/容器化场景。
3. 临时需要容器化数据库时可执行：
   ```bash
   make mysql-up-docker
   ```

## 如何在 Codex 中使用

1. 先在 `specs/<id>-<name>/` 编写任务说明。
2. 全局路由与约束放在 `AGENTS.md`。
3. 可复用流程放在 `.agents/skills/*/SKILL.md`。
4. 命令审批策略放在 `.codex/rules/*.rules`。
5. 自定义 subagents 放在 `.codex/agents/*.toml`。
6. 让 Codex 实施后执行 `make check`。

## 运行时兼容说明

1. 本模板按 Codex 风格工作流设计，目标是“兼容”而非绑定单一运行时。
2. 自动加载与路由行为取决于你使用的 Codex 运行时/集成方式。
3. `contexts/` 是仓库资产与路由提示，不保证被自动注入。
4. 项目级 subagent 是否可用，取决于运行时是否支持 `.codex/agents/*.toml`。
5. 需要稳定结果时，请在任务中显式点名 skill/subagent。

## 自动接线说明

1. 上下文预设：`contexts/dev.md`（开发）、`contexts/review.md`（评审）、`contexts/research.md`（调研）。
2. skill 与 subagent 路由是“推荐+运行时相关”机制。
3. 可显式点名 skills（如 `python-patterns`、`frontend-patterns`、`semi-ui-skills`）。
4. 可显式点名 subagents（如 `planner`、`architect`、`code-reviewer`、`python-reviewer`、`typescript-reviewer`、`database-reviewer`、`performance-optimizer`）。

## 官方参考

1. [AGENTS.md 指南](https://developers.openai.com/codex/guides/agents-md)
2. [Skills](https://developers.openai.com/codex/skills)
3. [Rules](https://developers.openai.com/codex/rules)
4. [Codex 文档首页](https://developers.openai.com/codex)

