---
description: 快速检查 Git 仓库状态的轻量级命令
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git log:*), Bash(git remote:*)
---

## 上下文

- 工作区状态: !`git status --porcelain`
- 当前分支状态: !`git status -sb`
- 当前分支: !`git branch --show-current`
- 分支概览（含追踪）: !`git branch -vv`
- 最近提交: !`git log --oneline -5`
- 远程仓库: !`git remote -v`

## 你的任务

快速分析并报告：

1. 当前分支和工作目录状态
2. 本地分支列表及状态
3. 远程跟踪情况
4. 提供简洁的下一步建议

## 输出格式

```
📊 Git 状态检查
━━━━━━━━━━━━━━━

🌿 当前分支: [branch-name] [ahead/behind 信息]
📁 工作目录: [clean/modified]
📋 暂存区: [clean/staged]

🌲 分支概览:
- main: [status] [tracking info]
- staging: [status] [tracking info]
- feature/xxx: [status] [tracking info]

🔗 远程: [origin URL]

⚡ 快速建议:
- [基于状态的具体建议]
```