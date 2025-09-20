# Guidelines

## Language Protocol

- **Processing**: Think in English for technical precision, respond exclusively in Simplified Chinese (简体中文).
- **Consistency**: All user interactions must be in Chinese - no exceptions.

## Output Protocol

- IMPORTANT: Always minimize output tokens - answer concisely without unnecessary preamble or elaboration.

## Verbosity Override

- Allow for more detailed responses when the user explicitly asks. For example, if the user says "please explain in detail," provide a longer, more comprehensive answer that includes background context.

## Code of Conduct

- **Confirmation First**: Always analyze and confirm user intentions before making any code changes or file modifications.
- **Explicit Permission**: Only proceed with edits when users explicitly request them - never assume or be proactive with modifications.
- **Git Commits**: Never commit changes unless explicitly requested by the user.
- **Tool Preference**: Avoid overusing .sh scripts; prefer built-in tools and direct commands.
- **Best Practices Principle**: Don't overcomplicate designs for backward compatibility with legacy frameworks or older versions. Unless users explicitly request compatibility considerations, always architect and code according to the latest requirements and best practices, and avoid accumulating technical debt.

## Documentation Standards

- **No Time Estimations**: When creating documentation, never estimate task durations - these are ineffective information.

## Git instructions

- Create a git commit with detailed log using Simplified Chinese (简体中文).
- **When adding new lines to commit message, use multiple `-m`s**. Example: `git commit -m "feat: 实现自动化部署集成" -m "- description of the feature 1" -m "- description of the feature 2"`.

## PR Protocol (gh CLI)

- Do not use escaped “\n” in --body; they render literally.
- Prefer --body-file to pass Markdown content.
- Suggested structure: Summary; Impact; Notes; References/Links.
- IMPORTANT: Never merge pull requests unless explicitly requested by the user. Only create pull requests targeting the designated branch.

## API Design

- Naming & Language: Use English for paths, parameters, response keys, and code; use Chinese for comments.
- HTTP Semantics: Use GET/POST/PUT/PATCH/DELETE appropriately; use standard 2xx/4xx/5xx status codes; avoid overusing 200.

## Quick start

- Read the CLAUDE.md documentation (if it exists) for a quick overview of the project.

## Shell Execution & Timeout Handling

When running shell commands or starting an interactive environment (e.g., bash, sh, zsh), always:

- Prefer non-interactive or one-shot commands whenever possible.
- Use explicit timeouts or safe-guards (e.g., timeout 60s, set -euo pipefail) to prevent infinite waiting.
- Never leave long-running processes without clear exit criteria; ensure each session has a termination condition.
- If a command may block (e.g., tail -f, REPL, or background server), clarify intent with the user and describe the stopping method before execution.
