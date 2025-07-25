---
description: 安全清理已合并的 Git 分支（本地+远程）
argument-hint: <分支名>
allowed-tools: Bash(git status:*), Bash(git checkout:*), Bash(git pull:*), Bash(git branch:*), Bash(git rev-list:*), Bash(git push:*), Bash(git fetch:*), Bash(git remote:*)
---

## 上下文

要清理的分支：$ARGUMENTS

- 当前分支: !`git branch --show-current`
- 分支状态（含追踪）: !`git branch -vv`
- staging 分支是否存在: !`git branch -l staging | wc -l`
- 已合并到 staging 的分支: !`git branch --merged staging 2>/dev/null || echo ""`
- 已合并到 main 的分支: !`git branch --merged main`
- 分支远程追踪信息: !`git for-each-ref --format='%(refname:short) %(upstream:short) %(upstream:track)' refs/heads | grep "^$ARGUMENTS " || echo ""`

## 你的任务

1. **确定目标基准分支**
   - 如果 staging 存在，以 staging 为基准
   - 否则以 main 为基准

2. **验证安全性**
   - 确认目标分支存在
   - 检查是否已合并到基准分支
   - 确保不是 main 或 staging 分支
   - 检查是否有未推送的提交（从追踪信息中的 ahead 数字）

3. **执行清理**（仅在验证通过后）
   - 切换到基准分支并更新
   - 删除本地分支
   - 删除远程分支（如果存在）
   - 清理远程引用

4. **报告结果**
   - 显示清理后的分支列表
   - 确认操作成功

## 安全约束

- 只删除已合并到基准分支的分支
- 禁止删除 main 和 staging 分支
- 如有未推送提交，先警告

## 输出格式

```
🧹 分支清理操作
━━━━━━━━━━━━━━━

目标分支: [branch-name]
基准分支: [staging/main]

✅ 安全检查:
- 已合并到 [基准分支]: [是/否]
- 包含未推送提交: [是/否]
- 远程追踪状态: [ahead X/behind Y/同步]

执行操作:
[列出执行的命令]

📊 清理结果:
- 本地分支: [已删除/失败]
- 远程分支: [已删除/不存在/失败]

当前分支列表:
[更新后的分支列表]
```