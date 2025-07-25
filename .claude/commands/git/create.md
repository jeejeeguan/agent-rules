---
description: 根据任务描述创建语义化分支
argument-hint: <任务描述>
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git checkout:*), Bash(git pull:*)
---

## 上下文

任务描述：$ARGUMENTS

- 工作区状态: !`git status --porcelain`
- 当前分支: !`git branch --show-current`
- 所有分支: !`git branch -a`

## 你的任务

1. **检查工作区状态**
   
   - 如果工作区有未提交的更改，提醒用户先提交或暂存
   - 只有工作区干净时才继续创建分支

2. **分析任务类型**

   - 根据 "$ARGUMENTS" 确定类型（功能/修复/重构等）
   - 将中文描述转换为英文 slug（小写，连字符分隔）

3. **生成分支名**

   - feature/[description] - 新功能
   - bugfix/[description] - Bug 修复
   - hotfix/[description] - 紧急修复
   - refactor/[description] - 重构
   - docs/[description] - 文档、说明、注释
   - test/[description] - 测试、单元测试

4. **选择基础分支**

   - 优先使用 staging（如果存在）
   - 否则使用 main

5. **创建分支**
   - 输出将要执行的命令
   - 执行创建并切换

## 输出格式

```
🌿 创建分支
━━━━━━━━━━━

工作区状态: [clean/dirty]

⚠️ [如果工作区不干净，显示警告]
请先提交或暂存当前更改：
- git add .
- git commit -m "..."
或使用 git stash 暂存

任务类型: [feature/bugfix/refactor/...]
分支名: [生成的分支名]
基础分支: [staging/main]

执行命令:
git checkout [base-branch]
git pull
git checkout -b [new-branch]

✅ 分支创建成功
当前在: [new-branch]
```
