# Claude Code 配置模板仓库

一个用于管理和同步 Claude Code 配置文件和自定义命令的模板仓库。

## 项目概述

本项目提供了一套完整的 Claude Code 配置模板，包括全局配置文件和各种实用的 slash 命令。通过一键同步功能，用户可以轻松获取并保持最新的配置模板。

## 目录结构

```
.
├── .claude/
│   ├── CLAUDE.md                    # Claude 全局配置文件（语言协议、行为准则等）
│   └── commands/                    # 自定义 slash 命令目录
│       ├── sync-templates.md        # 🔄 模板同步命令（核心功能）
│       ├── security-review.md       # 🔐 安全代码审查命令
│       └── git/                     # Git 相关命令组
│           ├── commit.md            # Git 提交辅助
│           └── workflow.md          # Git 工作流指导
├── .gitignore                       # Git 忽略规则
└── README.md                        # 项目说明（本文件）
```

## 快速开始

### 1. 获取模板

```bash
# 克隆项目（方式一：推荐）
git clone https://github.com/jeejeeguan/agent-rules.git
cd agent-rules

# 或直接下载（方式二）
curl -L https://github.com/jeejeeguan/agent-rules/archive/main.zip -o agent-rules.zip
unzip agent-rules.zip && cd agent-rules-main
```

### 2. 同步到本地配置

在项目目录下启动 Claude Code：

```bash
claude
```

执行同步命令：

```
/sync-templates
```

**就这么简单！** 🎉

### 3. 验证安装

同步完成后，检查本地配置：

```bash
ls -la ~/.claude/
ls -R ~/.claude/commands/
```

### 4. 清理（可选）

模板同步完成后，项目文件夹可以删除：

```bash
cd .. && rm -rf agent-rules
```

以后在任何目录下都可以使用 `/sync-templates` 命令更新模板。

## 核心功能：同步命令详解

### `/sync-templates` 命令

这是本项目的核心功能，用于将远程仓库的配置模板同步到本地 `~/.claude/` 目录。

#### 使用方法

```bash
# 同步默认分支（main）
/sync-templates

# 同步指定分支
/sync-templates dev
```

#### 功能特性

- ✅ **完整同步**：自动同步 `CLAUDE.md` 和整个 `commands/` 目录（含子目录）
- ✅ **智能备份**：同步前自动备份现有配置到 `~/.claude/backup/时间戳/`
- ✅ **分支支持**：可指定同步不同分支的配置
- ✅ **错误处理**：网络异常或其他错误时提供明确提示
- ✅ **进度反馈**：实时显示同步进度和结果

#### 工作原理

1. **下载**：从 GitHub 下载整个仓库的 tarball 压缩包
2. **备份**：将现有的 `~/.claude/` 配置备份到带时间戳的目录
3. **解压**：解压下载的压缩包到临时目录
4. **同步**：将 `.claude/` 目录内容复制到 `~/.claude/`
5. **清理**：删除临时文件，显示同步结果

#### 输出示例

```
📦 同步分支: main
🔗 源仓库: https://github.com/jeejeeguan/agent-rules/
⬇️  下载中: https://codeload.github.com/jeejeeguan/agent-rules/tar.gz/refs/heads/main
💾 备份到: /Users/username/.claude/backup/20241225_143022
📂 解压中...
✓ 已更新 CLAUDE.md
✓ 已更新 commands/ 目录（含子目录）

✅ 同步完成！
📋 当前文件列表:
━━━━━━━━━━━━━━━
/Users/username/.claude/commands:
git
security-review.md
sync-templates.md
...
```

## 可用命令

同步完成后，以下 slash 命令将在 Claude Code 中可用：

| 命令 | 描述 | 用途 |
|------|------|------|
| `/sync-templates` | 🔄 模板同步 | 从远程仓库更新本地配置 |
| `/security-review` | 🔐 安全审查 | 对代码进行安全漏洞检查 |
| `/git/commit` | 📝 提交助手 | 生成规范的 Git 提交信息 |
| `/git/workflow` | 🌊 工作流 | Git 分支管理和协作指导 |

## 自定义配置

### Fork 本仓库

如果你想自定义配置模板：

1. Fork 本仓库到你的 GitHub 账号
2. 修改 `.claude/commands/sync-templates.md` 中的仓库地址：
   ```bash
   REPO_OWNER="你的用户名"
   REPO_NAME="agent-rules"
   ```
3. 添加或修改 `.claude/` 目录下的配置文件
4. 提交并推送更改

### 添加新命令

在 `.claude/commands/` 目录下创建新的 `.md` 文件，支持任意深度的子目录结构：

```
.claude/commands/
├── 你的命令.md
├── 分类目录/
│   ├── 子命令1.md
│   └── 深层目录/
│       └── 子命令2.md
```

## 技术说明

- **同步方式**：使用 GitHub tarball API，支持完整的目录树结构
- **备份策略**：每次同步前自动创建时间戳备份
- **兼容性**：支持 macOS、Linux 等 POSIX 兼容系统
- **依赖工具**：`curl`、`tar`、`cp`、`rm`、`find`（系统内置）

## 故障排除

### 常见问题

**Q: 同步失败，提示网络错误**
```
A: 检查网络连接，或稍后重试。GitHub 偶尔会有访问限制。
```

**Q: 提示找不到分支**
```
A: 确认分支名称正确，或使用默认的 main 分支。
```

**Q: 权限不足**
```
A: 确保对 ~/.claude/ 目录有读写权限。
```

**Q: 想要恢复之前的配置**
```
A: 查看 ~/.claude/backup/ 目录，复制对应时间戳的备份文件。
```

### 手动恢复

如果需要恢复之前的配置：

```bash
# 查看可用备份
ls ~/.claude/backup/

# 恢复指定时间戳的备份
cp -r ~/.claude/backup/20241225_143022/* ~/.claude/
```

## 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/新功能`
3. 提交更改：`git commit -m '添加新功能'`
4. 推送分支：`git push origin feature/新功能`
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 支持

- 🐛 [报告问题](https://github.com/jeejeeguan/agent-rules/issues)
- 💡 [功能建议](https://github.com/jeejeeguan/agent-rules/discussions)
- 📚 [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code)

---

**开始使用：`git clone` → `claude` → `/sync-templates` 🚀**