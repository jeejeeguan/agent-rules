---
description: 分析 Git 仓库状态并提供分支策略建议
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git log:*), Bash(git rev-list:*), Bash(git remote:*), Bash(git fetch:*), Bash(git for-each-ref:*), Bash(git merge-base:*)
---

## 上下文

- 仓库状态: !`git status --porcelain`
- 当前分支: !`git branch --show-current`
- 所有分支（含追踪信息）: !`git branch -vv`
- 最近提交: !`git log --oneline -10`
- 远程仓库: !`git remote -v`
- 同步远程（静默）: !`git fetch --prune 2>/dev/null || true`
- 分支追踪详情: !`git for-each-ref --format='%(refname:short) %(upstream:short) %(upstream:track)' refs/heads`
- 无 upstream 分支: !`git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads | awk '$2=="" {print $1}'`

## 分支比较（如果存在 main 和 staging）

- staging 领先 main: !`git rev-list --count main..staging 2>/dev/null || echo "0"`
- main 领先 staging: !`git rev-list --count staging..main 2>/dev/null || echo "0"`

## 你的任务

基于以上仓库信息：

1. 报告当前仓库状态和分支结构
2. 如果存在 main 和 staging，分析它们的关系
3. 推荐适合的基础分支（优先 staging，其次 main）
4. 提供具体的分支策略建议
5. 建议下一步操作
6. 列出所有跟踪分支的 ahead/behind 状态，识别落后/领先的主体
7. 对无 upstream 分支推断其可能基线及同步风险

## 输出格式

使用结构化 Markdown：

```
📊 仓库分析报告
━━━━━━━━━━━━━━━

🌿 当前状态
- 当前分支：[branch]
- 工作目录：[状态]
- 远程仓库：[origin URL]

🌲 分支结构
- main: [提交数/状态]
- staging: [提交数/状态]
- 其他分支：[数量]

📈 分支关系
[分支比较分析]

📌 跟踪分支状态
| 分支 | Upstream | Ahead | Behind |
|------|----------|-------|--------|
| [branch] | [upstream] | [num] | [num] |

🧭 无 upstream 分支
- [branch] → 可能基于 [base]
- [风险评估]

💡 策略建议
- 推荐基础分支：[staging/main]
- 理由：[原因]

⚡ 下一步操作
[具体建议的命令]
```