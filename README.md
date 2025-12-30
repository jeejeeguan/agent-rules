# agent-rules (Unified Rules & Sync for Multiple Agents)

**[中文版](./README.zh-CN.md)** | English

Centralize rules for multiple AI Agents (Claude, Codex, Gemini, Crkilo, Kilocode, etc.) in a single source of truth `AGENT_RULES.md`, automatically sync to each agent's rule files via CI, and provide an executable script to locally update `~/.claude`, `~/.codex`, `~/.gemini`, `~/.crkilo`, `~/.kilocode`.

## Directory Structure

```
.
├── AGENT_RULES.md                  # Single Source of Truth (SSOT)
├── .claude/
│   ├── CLAUDE.md                   # Copied from AGENT_RULES.md by CI
│   └── skills/creating-skill/      # Skill (synced locally)
├── .codex/
│   └── AGENTS.md                   # Copied from AGENT_RULES.md by CI
├── .gemini/
│   └── GEMINI.md                   # Copied from AGENT_RULES.md by CI
├── .crkilo/
│   └── rules/
│       └── AGENTS.md               # Copied from AGENT_RULES.md by CI
├── .kilocode/
│   └── rules/
│       └── AGENTS.md               # Copied from AGENT_RULES.md by CI
├── scripts/
│   └── sync-agent-rules.sh         # Local sync script
└── .github/workflows/
    └── sync-agent-rules.yml        # CI: sync AGENT_RULES.md to each agent
```

## Quick Start

```bash
git clone https://github.com/jeejeeguan/agent-rules.git
cd agent-rules

# Sync default branch (main)
./scripts/sync-agent-rules.sh

# Or specify a branch
./scripts/sync-agent-rules.sh exp/breaking-rewrite
```

## Script Behavior

The core script `scripts/sync-agent-rules.sh` uses a **one-way sync** strategy (remote → local):

- Downloads the specified branch tarball from `https://github.com/${REPO_OWNER}/${REPO_NAME}` (default `main`) and syncs to local
- Sync behavior (remote → local):
  - Remote has, local has → Overwrite local file (with backup)
  - Remote has, local missing → Add to local
  - Remote missing, local has → No action
- Automatically backs up to `~/.agent-rules-backup/<agent>/...` before overwriting, backup filename appends `_YYYYMMDD_HHMMSS_backup`
- Prompts for repo/branch confirmation with `y/N` before execution
- Supported directories: `~/.claude`, `~/.codex`, `~/.gemini`, `~/.crkilo`, `~/.kilocode`

Dependencies: `curl`, `tar` (available by default on macOS/Linux).

## CI Auto Sync

- When `main` branch receives a push (including PR merges), CI will:
  - Copy `AGENT_RULES.md` to `.claude/CLAUDE.md`, `.codex/AGENTS.md`, `.gemini/GEMINI.md`, `.crkilo/rules/AGENTS.md`, `.kilocode/rules/AGENTS.md`
  - Auto-commit if there are changes (with `[skip ci]` to avoid loops)
- When maintaining rules, only edit `AGENT_RULES.md` in the root directory.

## Customization

Override script defaults via environment variables:

- `BRANCH`: Can be passed as the first script parameter, defaults to `main`, overridable via parameter or env var
- `REPO_OWNER` / `REPO_NAME`: Defaults to `jeejeeguan/agent-rules`, overridable via parameter or env var
