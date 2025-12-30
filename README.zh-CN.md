# agent-rules（多 Agent 统一规则与同步）

将多种 AI Agent（Claude、Codex、Gemini、Crkilo、Kilocode 等）的规则集中到单一真源 `AGENT_RULES.md`，
通过 CI 自动同步到各个 Agent 的规则文件，并提供可执行脚本在本地更新 `~/.claude`、`~/.codex`、`~/.gemini`、`~/.crkilo`、`~/.kilocode`。

## 目录结构

```
.
├── AGENT_RULES.md                  # 唯一真源（SSOT）
├── .claude/
│   ├── CLAUDE.md                   # 由 CI 复制自 AGENT_RULES.md
│   └── skills/creating-skill/      # Skill（本地同步时可下发）
├── .codex/
│   └── AGENTS.md                   # 由 CI 复制自 AGENT_RULES.md
├── .gemini/
│   └── GEMINI.md                   # 由 CI 复制自 AGENT_RULES.md
├── .crkilo/
│   └── rules/
│       └── AGENTS.md               # 由 CI 复制自 AGENT_RULES.md
├── .kilocode/
│   └── rules/
│       └── AGENTS.md               # 由 CI 复制自 AGENT_RULES.md
├── scripts/
│   └── sync-agent-rules.sh         # 本地同步脚本
└── .github/workflows/
    └── sync-agent-rules.yml        # CI：同步 AGENT_RULES.md 到各个 Agent
```

## 快速开始

```bash
git clone https://github.com/jeejeeguan/agent-rules.git
cd agent-rules

# 同步默认分支（main）
./scripts/sync-agent-rules.sh

# 或指定分支
./scripts/sync-agent-rules.sh exp/breaking-rewrite
```

## 脚本行为

核心脚本 `scripts/sync-agent-rules.sh` 采用**单向同步**策略：

- 从 `https://github.com/${REPO_OWNER}/${REPO_NAME}` 下载指定分支 tar 包（默认 `main`），再同步到本地
- 同步行为（远端 → 本地）：
  - 远端有、本地有 → 覆盖本地文件（先备份）
  - 远端有、本地没有 → 新增到本地
  - 远端没有、本地有 → 不做任何操作
- 覆盖前自动备份到 `~/.agent-rules-backup/<agent>/...`，备份文件名追加 `_YYYYMMDD_HHMMSS_backup`
- 执行前提示仓库与分支并要求 `y/N` 确认
- 支持的目录：`~/.claude`、`~/.codex`、`~/.gemini`、`~/.crkilo`、`~/.kilocode`

依赖：`curl`、`tar`（macOS/Linux 默认可用）。

## CI 自动同步

- 当 `main` 分支有 push（包含合并 PR）时，CI 将：
  - 将 `AGENT_RULES.md` 复制到 `.claude/CLAUDE.md`、`.codex/AGENTS.md`、`.gemini/GEMINI.md`、`.crkilo/rules/AGENTS.md`、`.kilocode/rules/AGENTS.md`
  - 如有变更则自动提交（带 `[skip ci]`，避免循环）
- 维护规则时，仅编辑根目录的 `AGENT_RULES.md` 即可。

## 自定义

可通过环境变量覆盖脚本默认值：

- `BRANCH`：可作为脚本第 1 个参数传入，默认 `main`，可通过参数或环境变量覆盖
- `REPO_OWNER` / `REPO_NAME`：默认 `jeejeeguan/agent-rules`，可通过参数或环境变量覆盖
