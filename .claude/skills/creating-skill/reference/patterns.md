# Common Patterns

Reusable patterns for structuring Skill content and guiding Claude's behavior.

## Template Pattern

Provide templates for output format. Match the level of strictness to your needs.

### For Strict Requirements

Use when consistency is critical (like API responses or data formats):

````markdown
## Report structure

ALWAYS use this exact template structure:

```markdown
# [Analysis Title]

## Executive summary

[One-paragraph overview of key findings]

## Key findings

- Finding 1 with supporting data
- Finding 2 with supporting data
- Finding 3 with supporting data

## Recommendations

1. Specific actionable recommendation
2. Specific actionable recommendation
```
````

**When to use strict templates:**
- API response formats
- Data file formats (JSON, CSV, XML)
- Formal documents with required sections
- Output consumed by other systems

### For Flexible Guidance

Use when adaptation is useful:

````markdown
## Report structure

Here is a sensible default format, but use your best judgment based on the analysis:

```markdown
# [Analysis Title]

## Executive summary

[Overview]

## Key findings

[Adapt sections based on what you discover]

## Recommendations

[Tailor to the specific context]
```

Adjust sections as needed for the specific analysis type.
````

**When to use flexible templates:**
- Creative or exploratory tasks
- Context-dependent outputs
- User-facing documents where tone matters
- Analysis where findings dictate structure

### Template Best Practices

**Use actual examples:**
```markdown
# Q4 Sales Analysis

## Executive summary

Sales increased 23% YoY, driven primarily by enterprise accounts in the Northeast region.
```

Not just placeholders:
```markdown
## Executive summary

[Write summary here]
```

**Show formatting:**

Include formatting like bold, italics, lists, and structure in your templates.

**Explain optional sections:**

```markdown
## Optional: Technical details

Include this section only if the analysis involves technical implementation.
```

## Examples Pattern

For Skills where output quality depends on seeing examples, provide input/output pairs just like in regular prompting.

### Commit Message Example

````markdown
## Commit message format

Generate commit messages following these examples:

**Example 1:**
Input: Added user authentication with JWT tokens
Output:

```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**Example 2:**
Input: Fixed bug where dates displayed incorrectly in reports
Output:

```
fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation
```

**Example 3:**
Input: Updated dependencies and refactored error handling
Output:

```
chore: update dependencies and refactor error handling

- Upgrade lodash to 4.17.21
- Standardize error response format across endpoints
```

Follow this style: type(scope): brief description, then detailed explanation.
````

Examples help Claude understand the desired style and level of detail more clearly than descriptions alone.

### Example Best Practices

**Show variety:**

Include examples covering different scenarios:
- Simple cases
- Complex cases
- Edge cases
- Common patterns

**Use realistic content:**

Don't use "foo", "bar", "example1". Use realistic domain content:

**Good:**
```
Input: Added user authentication with JWT tokens
```

**Bad:**
```
Input: Implemented feature X
```

**Annotate when helpful:**

```markdown
**Example 1: Simple feature addition**
Input: Added dark mode toggle
Output: feat(ui): add dark mode toggle

**Example 2: Bug fix with root cause** (Note the detailed explanation)
Input: Fixed crash when saving empty forms
Output: fix(forms): prevent crash on empty form submission

Added null check before validation to handle edge case
```

**Include counter-examples:**

Show what NOT to do:

```markdown
**Good example:**
```
feat(auth): implement JWT authentication
```

**Avoid (too vague):**
```
Updated login stuff
```

**Avoid (too detailed):**
```
feat(auth): implement JWT-based authentication using jsonwebtoken package version 9.0.0 with RS256 algorithm and 24-hour expiration including refresh token rotation and secure httpOnly cookies
```
```

## Conditional Workflow Pattern

Guide Claude through decision points based on task characteristics.

### Basic Conditional Workflow

```markdown
## Document modification workflow

1. Determine the modification type:

   **Creating new content?** → Follow "Creation workflow" below
   **Editing existing content?** → Follow "Editing workflow" below

2. Creation workflow:
   - Use docx-js library
   - Build document from scratch
   - Export to .docx format

3. Editing workflow:
   - Unpack existing document
   - Modify XML directly
   - Validate after each change
   - Repack when complete
```

### Multi-Level Conditional

For more complex decision trees:

```markdown
## Processing workflow

**Step 1: Identify input type**

- Is it a PDF? → Go to Step 2
- Is it a Word document? → Go to Step 3
- Is it plain text? → Go to Step 4

**Step 2: PDF processing**

- Is it a form? → Use form filling workflow
- Is it text-heavy? → Use text extraction workflow
- Is it image-based? → Use OCR workflow

**Step 3: Word document processing**

- DOCX format? → Use docx-js library
- DOC format? → Convert to DOCX first, then process

**Step 4: Plain text processing**

- Apply formatting directly
```

### Conditional Best Practices

**Use clear decision criteria:**

**Good:**
```
- File size > 10MB? → Use streaming processing
- File size ≤ 10MB? → Load into memory
```

**Bad:**
```
- Large file? → Use different method
```

**Provide escape paths:**

```markdown
If none of these conditions match, ask the user for clarification about the input format.
```

**Keep nesting shallow:**

Deeply nested conditionals are hard to follow. Consider splitting into separate sections or files.

## Configuration Pattern

For Skills that need user configuration, use a consistent pattern.

### Simple Configuration

```markdown
## Configuration

Create a `config.json` file:

```json
{
  "api_key": "your_api_key_here",
  "endpoint": "https://api.example.com",
  "timeout": 30
}
```

Claude will read this file when processing requests.
```

### Validated Configuration

```markdown
## Configuration

1. Copy `config.template.json` to `config.json`
2. Fill in your values
3. Run validation: `python validate_config.py`
4. Fix any errors before proceeding
```

### Environment-Based Configuration

```markdown
## Configuration

Set environment variables:

```bash
export API_KEY="your_key"
export API_ENDPOINT="https://api.example.com"
```

Or create a `.env` file:

```
API_KEY=your_key
API_ENDPOINT=https://api.example.com
```
```

## Error Handling Pattern

Guide Claude on handling common errors.

### Explicit Error Handling

```markdown
## Error handling

**File not found:**
- Check the file path is correct
- Verify you're in the right directory
- Try using absolute path instead of relative

**Permission denied:**
- Check file permissions: `ls -l filename`
- Try running with appropriate permissions
- Verify you own the file

**Format error:**
- Validate the input file format
- Run the format checker: `python check_format.py`
- See examples/ for reference formats
```

### Fallback Pattern

```markdown
## Processing approach

1. Try method A (fastest, handles 90% of cases)
2. If method A fails with error X, try method B
3. If method B fails, try method C (slower but more robust)
4. If all methods fail, ask user for manual intervention
```

## Combining Patterns

Patterns work together. A realistic Skill might use:

````markdown
## Workflow (Conditional + Template)

**Step 1: Identify document type**

- Invoice? → Use invoice template
- Report? → Use report template
- Letter? → Use letter template

**Step 2: Invoice template**

```markdown
# Invoice [Number]

**Bill To:** [Customer Name]
**Date:** [Date]
**Due Date:** [Due Date]

| Item | Quantity | Price | Total |
|------|----------|-------|-------|
| ...  | ...      | ...   | ...   |

**Total Due:** $[Amount]
```

**Step 3: Validate**

Run: `python validate_invoice.py output.md`

If validation fails, fix errors and validate again.

**Step 4: Convert to PDF**

Run: `python convert_to_pdf.py output.md invoice.pdf`
````

This combines:
- Conditional workflow (document type selection)
- Template pattern (invoice structure)
- Workflow pattern (step-by-step process)
- Feedback loop (validation)

## Pattern Selection Guide

Choose patterns based on your needs:

| Need | Pattern |
|------|---------|
| Consistent output format | Template (strict) |
| Flexible but guided output | Template (flexible) |
| Teaching by example | Examples |
| Different paths for different inputs | Conditional workflow |
| User-specific settings | Configuration |
| Handling common failures | Error handling |
| Complex multi-step process | Workflow + feedback loop |

Most Skills use multiple patterns together.
