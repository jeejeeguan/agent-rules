# agent-rules（多 Agent 统一规则与同步）

将多种 AI Agent（Claude、Codex 等）的规则集中到单一真源 `AGENT_RULES.md`，
通过 CI 自动同步到下游文件，并提供 Bash 脚本在本地覆盖更新 `~/.claude`、`~/.codex`、`~/.gemini`。

## 目录结构

```
.
├── AGENT_RULES.md                  # 唯一真源（SSOT）
├── .claude/
│   └── CLAUDE.md                   # 由 CI 复制自 AGENT_RULES.md
├── .codex/
│   └── AGENTS.md                   # 由 CI 复制自 AGENT_RULES.md
├── scripts/
│   └── sync-agent-rules.sh         # 本地同步脚本（macOS/Linux）
└── .github/workflows/
    └── sync-agent-rules.yml        # CI：同步 SSOT 到下游
```

## 快速开始

```bash
git clone https://github.com/jeejeeguan/agent-rules.git
cd agent-rules

# 同步默认分支（main）
bash scripts/sync-agent-rules.sh

# 或指定分支
bash scripts/sync-agent-rules.sh exp/breaking-rewrite
```

脚本行为：
- 仅覆盖“仓库中存在的同名文件”；不会删除你本地的多余文件
- 覆盖前自动备份到 `~/.agent-rules-backup/<agent>/...`，备份文件名追加 `_YYYYMMDD_HHMMSS_backup`
- 支持的本地目录：`~/.claude`、`~/.codex`、`~/.gemini`（存在才处理）

依赖：`curl`、`tar`（macOS 和 Linux 默认可用）。

## CI 自动同步（SSOT）

- 当 `main` 分支有 push（包含合并 PR）时，CI 将：
  - 将 `AGENT_RULES.md` 复制到 `.claude/CLAUDE.md` 与 `.codex/AGENTS.md`
  - 如有变更则自动提交（带 `[skip ci]`，避免循环）
- 维护规则时，仅编辑根目录的 `AGENT_RULES.md` 即可。

## 自定义（Fork）

Fork 后可通过环境变量覆盖脚本默认仓库：

```bash
REPO_OWNER="你的用户名" REPO_NAME="agent-rules" bash scripts/sync-agent-rules.sh main
```

## 许可证

MIT，见 [LICENSE](LICENSE)。
