---
description: 从 GitHub 远程仓库同步更新本地 Claude 模板文件
allowed-tools: Bash(curl:*), Bash(cp:*), Bash(mkdir:*), Bash(ls:*), Bash(date:*)
---

## 上下文

- 本地配置目录: !`ls -la ~/.claude 2>/dev/null || echo "目录不存在"`
- 当前时间戳: !`date +%Y%m%d_%H%M%S`

## 你的任务

**⚠️ 重要提示**: 此命令硬编码使用仓库 https://github.com/jeejeeguan/agent-rules/
如果你 fork 了此仓库，请修改此文件中的 URL 为你自己的仓库地址。

1. **检查本地目录**
   - 确认 ~/.claude 目录是否存在
   - 如果不存在，创建相应目录结构

2. **备份现有文件**（如果存在）
   - 创建带时间戳的备份目录 ~/.claude/backup/[timestamp]/
   - 备份现有的 CLAUDE.md 和 commands 目录

3. **下载远程文件**
   - 从 GitHub 下载 CLAUDE.md
   - 递归下载 commands 目录下的所有文件

4. **更新本地文件**
   - 替换 ~/.claude/CLAUDE.md
   - 更新 ~/.claude/commands/ 目录内容

5. **验证更新**
   - 显示更新后的文件列表
   - 确认文件是否成功更新

## 执行步骤

```bash
# 1. 创建必要的目录
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/backup

# 2. 创建时间戳备份（如果有现有文件）
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
if [ -f ~/.claude/CLAUDE.md ] || [ -d ~/.claude/commands ]; then
    mkdir -p ~/.claude/backup/$TIMESTAMP
    [ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md ~/.claude/backup/$TIMESTAMP/
    [ -d ~/.claude/commands ] && cp -r ~/.claude/commands ~/.claude/backup/$TIMESTAMP/
fi

# 3. 下载 CLAUDE.md
curl -s -o ~/.claude/CLAUDE.md https://raw.githubusercontent.com/jeejeeguan/agent-rules/main/.claude/CLAUDE.md

# 4. 下载 commands 目录
# 首先获取目录结构
REPO_API="https://api.github.com/repos/jeejeeguan/agent-rules/contents/.claude/commands"
curl -s "$REPO_API" | grep '"path"' | cut -d'"' -f4 | while read -r file_path; do
    # 从完整路径中提取相对路径
    relative_path="${file_path#.claude/commands/}"
    target_path="$HOME/.claude/commands/$relative_path"
    
    # 创建子目录（如果需要）
    target_dir=$(dirname "$target_path")
    mkdir -p "$target_dir"
    
    # 下载文件
    curl -s -o "$target_path" "https://raw.githubusercontent.com/jeejeeguan/agent-rules/main/$file_path"
done
```

## 输出格式

```
📥 同步 Claude 模板
━━━━━━━━━━━━━━━

⚠️  源仓库: https://github.com/jeejeeguan/agent-rules/
   (如果你 fork 了此仓库，请修改此命令中的 URL)

📁 检查本地目录
[显示目录状态]

💾 备份现有文件
[如果有备份，显示备份位置]

🔄 下载远程文件
- CLAUDE.md ... [完成/失败]
- commands/ ... [完成/失败]

✅ 同步完成

📋 更新后的文件:
[列出更新的文件]

💡 提示: 可以查看 ~/.claude/backup/ 目录以恢复之前的版本
```

## 错误处理

- 如果网络连接失败，提示检查网络
- 如果 GitHub API 限流，提示稍后重试
- 如果权限不足，提示使用适当权限运行