# agent-rules（多 Agent 统一规则与同步）

将多种 AI Agent（Claude、Codex 等）的规则集中到单一真源 `AGENT_RULES.md`，
通过 CI 自动同步到下游文件，并提供可执行脚本在本地覆盖更新 `~/.claude`、`~/.codex`、`~/.gemini`。

## 目录结构

```
.
├── AGENT_RULES.md                  # 唯一真源（SSOT）
├── .claude/
│   ├── CLAUDE.md                   # 由 CI 复制自 AGENT_RULES.md
│   └── skills/creating-skill/      # Skill（本地同步时可下发）
├── .codex/
│   └── AGENTS.md                   # 由 CI 复制自 AGENT_RULES.md
├── scripts/
│   └── sync-agent-rules.sh         # 本地同步脚本
└── .github/workflows/
    └── sync-agent-rules.yml        # CI：同步 SSOT 到下游
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

核心脚本 `scripts/sync-agent-rules.sh`：

- 从 `https://github.com/${REPO_OWNER}/${REPO_NAME}` 下载指定分支 tar 包（默认 `main`，可通过参数或环境变量覆盖），再同步到本地
- 同步会包含远端新增文件；不会删除你本地的多余文件
- 覆盖前自动备份到你的本地备份目录 `~/.agent-rules-backup/<agent>/...`，备份文件名追加 `_YYYYMMDD_HHMMSS_backup`
- 执行前会提示即将使用的仓库与分支并要求 `y/N` 确认，避免误覆盖
- 支持的 AI Agent 目录：`~/.claude`、`~/.codex`、`~/.gemini`

依赖：`curl`、`tar`（macOS/Linux 默认可用）。

## CI 自动同步

- 当 `main` 分支有 push（包含合并 PR）时，CI 将：
  - 将 `AGENT_RULES.md` 复制到 `.claude/CLAUDE.md` 与 `.codex/AGENTS.md`
  - 如有变更则自动提交（带 `[skip ci]`，避免循环）
- 维护规则时，仅编辑根目录的 `AGENT_RULES.md` 即可。

## 自定义

可通过环境变量覆盖脚本默认值：

- `BRANCH`：可作为脚本第 1 个参数传入，默认 `main`，可通过参数或环境变量覆盖
- `REPO_OWNER` / `REPO_NAME`：默认 `jeejeeguan/agent-rules`，可通过参数或环境变量覆盖
