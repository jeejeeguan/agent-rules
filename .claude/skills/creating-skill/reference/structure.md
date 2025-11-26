# Skill Structure

Every Skill requires a `SKILL.md` file with YAML frontmatter containing metadata and markdown body containing instructions.

## Basic Structure

```yaml
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it
---

# Your Skill Name

## Instructions
[Clear, step-by-step guidance for Claude to follow]

## Examples
[Concrete examples of using this Skill]
```

## Required Fields

### name

The `name` field identifies your Skill.

**Requirements:**
- Maximum 64 characters
- Must contain only lowercase letters, numbers, and hyphens
- Cannot contain XML tags
- Cannot contain reserved words: "anthropic", "claude"

**Validation:**
- ✓ Valid: `pdf-processing`, `excel-analysis`, `git-helper`
- ✗ Invalid: `PDF-Processing` (uppercase), `excel_analysis` (underscores), `claude-helper` (reserved word)

### description

The `description` field enables Skill discovery and should include both what the Skill does and when to use it.

**Requirements:**
- Must be non-empty
- Maximum 1024 characters
- Cannot contain XML tags

**Critical importance**: Claude uses this description to choose the right Skill from potentially 100+ available Skills. Your description must provide enough detail for Claude to know when to select this Skill.

## Naming Conventions

Use consistent naming patterns to make Skills easier to reference and discuss. We recommend using **gerund form** (verb + -ing) for Skill names, as this clearly describes the activity or capability the Skill provides.

Remember that the `name` field must use lowercase letters, numbers, and hyphens only.

### Good Naming Examples (Gerund Form)

- `processing-pdfs`
- `analyzing-spreadsheets`
- `managing-databases`
- `testing-code`
- `writing-documentation`

### Avoid

- Vague names: `helper`, `utils`, `tools`
- Overly generic: `documents`, `data`, `files`
- Reserved words: `anthropic-helper`, `claude-tools`
- Inconsistent patterns within your skill collection

### Naming Tips

1. **Be specific**: "processing-pdfs" is better than "documents"
2. **Use action words**: Gerunds (verb + -ing) describe what the Skill does
3. **Stay consistent**: If you use gerund form for one skill, use it for all
4. **Think about discovery**: Names should hint at the skill's purpose

## Writing Effective Descriptions

The `description` field enables Skill discovery and should include both what the Skill does and when to use it.

### Always Write in Third Person

**CRITICAL**: The description is injected into the system prompt, and inconsistent point-of-view can cause discovery problems.

- ✓ **Good:** "Processes Excel files and generates reports"
- ✗ **Avoid:** "I can help you process Excel files"
- ✗ **Avoid:** "You can use this to process Excel files"

### Be Specific and Include Key Terms

Include both what the Skill does and specific triggers/contexts for when to use it.

Each Skill has exactly one description field. The description is critical for skill selection: Claude uses it to choose the right Skill from potentially 100+ available Skills.

### Effective Examples

**PDF Processing skill:**

```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Excel Analysis skill:**

```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

**Git Commit Helper skill:**

```yaml
description: Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
```

### Avoid Vague Descriptions

Don't write descriptions like these:

```yaml
description: Helps with documents
```

```yaml
description: Processes data
```

```yaml
description: Does stuff with files
```

These don't provide enough information for Claude to know when to use the Skill.

### Description Checklist

Before finalizing your description, verify:

- [ ] Written in third person
- [ ] Describes what the Skill does
- [ ] Specifies when to use it
- [ ] Includes key terms and triggers
- [ ] Contains no XML tags
- [ ] Under 1024 characters
- [ ] Specific enough to distinguish from other Skills

## Skill Body Content

After the YAML frontmatter, add your instructions in markdown format.

### Recommended Sections

**Instructions**: Clear, step-by-step guidance for Claude to follow

**Examples**: Concrete examples showing how to use the Skill

**Reference**: Links to additional documentation (when using progressive disclosure)

### Keep It Focused

- Start with the most common use case
- Add complexity only when needed
- Use progressive disclosure for advanced topics (see [Document Organization](organization.md))
- Keep SKILL.md body under 500 lines for optimal performance

## Complete Example

Here's a well-structured minimal Skill:

```yaml
---
name: processing-pdfs
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---

# PDF Processing

## Quick Start

Extract text with pdfplumber:

```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Extract Tables

```python
with pdfplumber.open("file.pdf") as pdf:
    table = pdf.pages[0].extract_table()
```

## Advanced Features

**Form filling**: See [FORMS.md](FORMS.md) for complete guide
**API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
```

This example demonstrates:
- Valid YAML frontmatter
- Clear naming (gerund form)
- Effective description (what + when)
- Concise instructions
- Progressive disclosure for advanced topics
