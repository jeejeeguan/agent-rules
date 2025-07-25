---
description: 从 GitHub 远程仓库同步更新本地 Claude 模板文件（含子目录），自动备份
argument-hint: "[可选] 分支名（默认 main）"
allowed-tools: Bash(curl:*), Bash(cp:*), Bash(mkdir:*), Bash(ls:*), Bash(date:*), Bash(tar:*), Bash(rm:*), Bash(find:*), Bash(head:*)
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
set -euo pipefail

# 配置变量
REPO_OWNER="jeejeeguan"
REPO_NAME="agent-rules"
BRANCH="${ARGUMENTS:-main}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BASE_DIR="$HOME/.claude"
BACKUP_DIR="$BASE_DIR/backup/$TIMESTAMP"
TMP_DIR="$(mktemp -d)"
TARBALL_URL="https://codeload.github.com/${REPO_OWNER}/${REPO_NAME}/tar.gz/refs/heads/${BRANCH}"

echo "📦 同步分支: $BRANCH"
echo "🔗 源仓库: https://github.com/${REPO_OWNER}/${REPO_NAME}/"

# 1. 创建必要的目录
mkdir -p "$BASE_DIR/commands" "$BASE_DIR/backup"

# 2. 下载仓库 tarball
echo "⬇️  下载中: $TARBALL_URL"
if ! curl -fL "$TARBALL_URL" -o "$TMP_DIR/repo.tar.gz"; then
    echo "❌ 下载失败（请检查分支名或网络连接）"
    rm -rf "$TMP_DIR"
    exit 0
fi

# 3. 备份现有配置
if [ -d "$BASE_DIR/commands" ] || [ -f "$BASE_DIR/CLAUDE.md" ]; then
    echo "💾 备份到: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    cp -r "$BASE_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
fi

# 4. 解压 tarball
echo "📂 解压中..."
tar -xzf "$TMP_DIR/repo.tar.gz" -C "$TMP_DIR"

# 5. 找到解压后的目录
SRC_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name "${REPO_NAME}-*" | head -1)"
if [ -z "$SRC_DIR" ]; then
    echo "❌ 未找到解压后的源目录"
    rm -rf "$TMP_DIR"
    exit 0
fi

# 6. 同步文件
if [ -f "$SRC_DIR/.claude/CLAUDE.md" ]; then
    cp -f "$SRC_DIR/.claude/CLAUDE.md" "$BASE_DIR/CLAUDE.md"
    echo "✓ 已更新 CLAUDE.md"
fi

if [ -d "$SRC_DIR/.claude/commands" ]; then
    cp -rf "$SRC_DIR/.claude/commands/." "$BASE_DIR/commands/"
    echo "✓ 已更新 commands/ 目录（含子目录）"
fi

# 7. 清理临时目录
rm -rf "$TMP_DIR"

# 8. 显示同步结果
echo ""
echo "✅ 同步完成！"
echo "📋 当前文件列表:"
echo "━━━━━━━━━━━━━━━"
ls -R "$BASE_DIR/commands" | head -50
```

## 输出格式示例

```
📦 同步分支: main
🔗 源仓库: https://github.com/jeejeeguan/agent-rules/
⬇️  下载中: https://codeload.github.com/jeejeeguan/agent-rules/tar.gz/refs/heads/main
💾 备份到: /Users/xxx/.claude/backup/20241225_143022
📂 解压中...
✓ 已更新 CLAUDE.md
✓ 已更新 commands/ 目录（含子目录）

✅ 同步完成！
📋 当前文件列表:
━━━━━━━━━━━━━━━
/Users/xxx/.claude/commands:
git
security-review.md
sync-templates.md

/Users/xxx/.claude/commands/git:
commit.md
workflow.md
```

## 错误处理

- 如果网络连接失败，提示检查网络
- 如果下载失败（404），提示检查仓库地址是否正确
- 如果解压失败，提示检查磁盘空间
- 如果权限不足，提示使用适当权限运行
