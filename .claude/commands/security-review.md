---
allowed-tools: Read, Glob, Grep, Bash(find:*), Bash(grep:*), Bash(head:*)
description: 对项目进行全面的安全风险审计分析
---

## 安全审计分析

你是一个经验丰富的安全工程师，需要对当前项目进行全面的安全审计。

### 当前项目概况

- 项目结构：!`find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.json" \) | head -20`
- Package 文件：@package.json @requirements.txt @Cargo.toml
- 配置文件：@.env @.env.* @config/*.json @config/*.yaml @config/*.yml

### 你的任务

请按照以下步骤进行安全审计：

1. **项目结构扫描**
   - 识别项目类型（前端/后端/全栈）
   - 统计代码文件数量和分布
   - 识别核心功能模块

2. **自动化安全检测**
   - 敏感信息扫描：!`grep -R -n -E '(API_KEY|SECRET|BEGIN RSA PRIVATE KEY)' -i . 2>/dev/null | grep -v node_modules | head -10`
   - 可疑执行检测：!`grep -R -n -E '(eval\\(|new Function|child_process\\.exec)' -i . 2>/dev/null | grep -v node_modules | head -10`

3. **重点风险审查**
   - 硬编码密钥/凭证/API Token
   - 任意文件读写（未经校验的 `fs.readFile`, `path` 拼接等）
   - SSRF、XSS、RCE、路径遍历、命令注入等 Web 安全风险
   - 用户输入校验/转义缺失
   - 反调试、混淆、可疑编码片段（base64 + eval、动态函数创建等恶意代码特征）

4. **依赖项漏洞检查**
   - 检查 package-lock.json/yarn.lock 中的版本锁定
   - 识别已知高危依赖（如过时的 lodash、minimist 等）
   - 建议更新存在 CVE 的依赖版本

5. **配置文件审查**
   - 环境变量配置是否安全
   - 是否存在开发环境密钥泄露风险
   - CORS、CSP 等安全策略配置

### 输出格式

```markdown
## 📦 项目概况

- **项目类型**：[前端/后端/全栈/库]
- **主要语言**：[JavaScript/TypeScript/Python 等]
- **核心功能**：[简要描述]
- **代码规模**：[文件数量统计]

## 🔍 自动化扫描结果

### 敏感信息检测
[列出发现的硬编码密钥、API Token 等]

### 危险函数使用
[列出 eval、exec 等危险函数调用]

## ⚠️ 安全风险详情

### 高危风险
#### [具体文件:行号]
- **风险类型**：[如：硬编码密钥/命令注入/XSS]
- **问题代码**：
```[语言]
[具体代码片段]
```
- **影响范围**：[说明潜在危害]
- **修复方案**：[具体修复建议]

### 中危风险
[同上格式]

### 低危风险
[同上格式]

## 📊 依赖项安全

- **总依赖数**：[数量]
- **过时依赖**：[列出需要更新的包]
- **已知漏洞**：[CVE 编号及影响包]

## 🛡️ 安全建议

1. **立即修复**：[最紧急的安全问题]
2. **短期改进**：[1-2周内应完成]
3. **长期优化**：[架构层面的安全增强]

## 📈 风险评级

**总体评级**：[高/中/低]

**生产环境建议**：[是否可以部署到生产环境，如果不能，说明必须先解决哪些问题]
```
