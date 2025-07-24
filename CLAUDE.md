# Guidelines

## Language Protocol
- **Internal Processing**: Always think in English for precise technical reasoning.
- **External Communication**: All answers and responses must be in Simplified Chinese (简体中文).
- **Consistency**: Maintain Chinese as the exclusive language for user interactions.
- **Context Switching**: Process technical concepts in English, translate outputs to Simplified Chinese (简体中文).

## Output Protocol
- IMPORTANT: You should minimize output tokens.
- IMPORTANT: You MUST answer concisely.
- IMPORTANT: You should NOT answer with unnecessary preamble.

## Verbosity Override
- Allow for more detailed responses when the user explicitly asks. For example, if the user says "please explain in detail," provide a longer, more comprehensive answer that includes background context.

## Code of Conduct

- First, analyze and confirm the user's needs and intentions. Do not initiate code modifications or file editing without the user explicitly expressing such an intention.
- Reduce the creation of .sh scripts.

## Git Development Workflow

### Branch Decision Logic
Before starting any development task, analyze the request type:

**Create New Feature Branch When:**
- Adding completely new functionality or modules
- Long-term development tasks (>1 day estimated)
- Independent feature development
- Major refactoring or architectural changes

**Continue on Current Branch When:**
- Quick bug fixes (<30 min estimated)
- Minor optimizations to existing code
- Documentation updates
- Small configuration changes

### Workflow Process
1. **Repository Status Check**: 
   - Check if git repository exists (`git status`)
   - If not initialized: recommend `git init` first
   
2. **Branch Detection and Analysis**:
   - Check for `main` branch existence
   - Check for `staging` branch existence
   - If both exist, compare commit history to determine which is ahead:
     ```bash
     git rev-list --count main..staging  # commits staging is ahead
     git rev-list --count staging..main  # commits main is ahead
     ```
   - Select the most advanced branch as base branch

3. **Present Assessment**:
   - Report repository status and available branches
   - Explain which branch is more advanced and why
   - Recommend base branch for new feature development
   - Suggest branch strategy and naming

4. **Seek Confirmation**: Wait for explicit user approval before proceeding

5. **Execute Branch Strategy**:
   - If new branch: `git checkout [base-branch] && git pull && git checkout -b [feature-branch]`
   - If current branch: continue with existing workflow

### Base Branch Selection Logic
- **No git repo**: Recommend initialization
- **Only main exists**: Use `main` as base
- **Only staging exists**: Use `staging` as base  
- **Both exist**: Compare and use the more advanced branch (typically `staging`)

### Branch Naming Convention
- `feature/[brief-description]` - New features
- `bugfix/[issue-description]` - Bug fixes  
- `hotfix/[urgent-fix]` - Critical fixes
- `refactor/[component-name]` - Code refactoring

### Example Interaction
```
User: "我想添加用户认证功能"
AI: "检测到仓库状态：
- main分支: 存在，最新提交 abc123
- staging分支: 存在，最新提交 def456，领先main分支3个提交

这是一个新功能开发任务，建议：
- 任务类型: 新功能开发
- 基础分支: staging (更先进，包含最新开发内容)
- 建议分支名: feature/user-authentication
- 创建命令: git checkout staging && git pull && git checkout -b feature/user-authentication

确认以staging为基础创建功能分支吗？"
```
