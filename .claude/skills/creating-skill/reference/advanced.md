# Advanced: Skills with Executable Code

The sections below focus on Skills that include executable scripts and advanced patterns.

## Solve, Don't Punt

When writing scripts for Skills, handle error conditions rather than punting to Claude.

### The Principle

Scripts should be robust and self-sufficient. Don't fail with cryptic errors and expect Claude to figure it out.

### Examples

**✗ Bad: Punt to Claude**:

```python
def process_file(path):
    # Just fail and let Claude figure it out
    return open(path).read()
```

**Problems:**
- Fails with exception on missing file
- Fails with exception on permission error
- No guidance on what went wrong or how to fix it

**✓ Good: Handle errors explicitly**:

```python
def process_file(path):
    """Process a file, creating it if it doesn't exist."""
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        # Create file with default content instead of failing
        print(f"File {path} not found, creating default")
        with open(path, 'w') as f:
            f.write('')
        return ''
    except PermissionError:
        # Provide alternative instead of failing
        print(f"Cannot access {path}, using default")
        return ''
```

### Configuration Parameters

Configuration parameters should be justified and documented to avoid "voodoo constants" (Ousterhout's law). If you don't know the right value, how will Claude determine it?

**✗ Bad: Magic numbers**:

```python
TIMEOUT = 47  # Why 47?
RETRIES = 5   # Why 5?
```

**✓ Good: Self-documenting**:

```python
# HTTP requests typically complete within 30 seconds
# Longer timeout accounts for slow connections
REQUEST_TIMEOUT = 30

# Three retries balances reliability vs speed
# Most intermittent failures resolve by the second retry
MAX_RETRIES = 3
```

### Guideline

Ask yourself: "If this script fails, can Claude recover without my help?"

If not, add error handling, fallbacks, or clear error messages.

## Provide Utility Scripts

Even if Claude could write a script, pre-made scripts offer advantages.

### Benefits of Utility Scripts

- **More reliable**: Tested and debugged
- **Save tokens**: No need to include code in context
- **Save time**: No code generation required
- **Ensure consistency**: Same behavior every time

### Important Distinction

Make clear in your instructions whether Claude should:

- **Execute the script** (most common): "Run `analyze_form.py` to extract fields"
- **Read it as reference** (for complex logic): "See `analyze_form.py` for the field extraction algorithm"

For most utility scripts, execution is preferred because it's more reliable and efficient.

### Example

````markdown
## Utility scripts

**analyze_form.py**: Extract all form fields from PDF

```bash
python scripts/analyze_form.py input.pdf > fields.json
```

Output format:

```json
{
  "field_name": { "type": "text", "x": 100, "y": 200 },
  "signature": { "type": "sig", "x": 150, "y": 500 }
}
```

**validate_boxes.py**: Check for overlapping bounding boxes

```bash
python scripts/validate_boxes.py fields.json
# Returns: "OK" or lists conflicts
```

**fill_form.py**: Apply field values to PDF

```bash
python scripts/fill_form.py input.pdf fields.json output.pdf
```
````

### Script Documentation

For each utility script, document:

1. **Purpose**: What it does in one sentence
2. **Usage**: Command line syntax with examples
3. **Input**: What files/arguments it needs
4. **Output**: What it produces (format, location)
5. **Errors**: Common failure modes and solutions

## Use Visual Analysis

When inputs can be rendered as images, have Claude analyze them.

### Why Visual Analysis

Claude can see:
- Layout and structure
- Field positions
- Visual relationships
- Design elements

This is often more reliable than parsing text descriptions.

### Example

````markdown
## Form layout analysis

1. Convert PDF to images:

   ```bash
   python scripts/pdf_to_images.py form.pdf
   ```

2. Analyze each page image to identify form fields
3. Claude can see field locations and types visually
````

In this example, you'd need to write the `pdf_to_images.py` script.

### When to Use Visual Analysis

- **Form layouts**: Field positions and types
- **UI screenshots**: Element locations and relationships
- **Diagrams**: Structure and flow
- **Document layouts**: Section organization

### Image Conversion Example

```python
# scripts/pdf_to_images.py
import pdf2image
import sys

def convert_pdf_to_images(pdf_path, output_dir="images"):
    images = pdf2image.convert_from_path(pdf_path)
    for i, img in enumerate(images):
        img.save(f"{output_dir}/page_{i+1}.png")
    print(f"Converted {len(images)} pages to {output_dir}/")

if __name__ == "__main__":
    convert_pdf_to_images(sys.argv[1])
```

## Create Verifiable Intermediate Outputs

When Claude performs complex, open-ended tasks, it can make mistakes. The "plan-validate-execute" pattern catches errors early by having Claude first create a plan in a structured format, then validate that plan with a script before executing it.

### The Problem

Imagine asking Claude to update 50 form fields in a PDF based on a spreadsheet. Without validation, Claude might:
- Reference non-existent fields
- Create conflicting values
- Miss required fields
- Apply updates incorrectly

### The Solution

Use the workflow pattern with an intermediate validation step. The workflow becomes:

1. Analyze input
2. **Create plan file** (structured data)
3. **Validate plan** (machine-verifiable)
4. Execute plan
5. Verify output

### Example

````markdown
## PDF form update workflow

**Step 1: Analyze the form and data**

Run: `python analyze_form.py input.pdf`
Run: `python analyze_data.py data.xlsx`

**Step 2: Create changes plan**

Create a `changes.json` file mapping data to fields:

```json
{
  "field_name": "John Doe",
  "field_email": "john@example.com",
  "field_date": "2025-01-15"
}
```

**Step 3: Validate the plan**

Run: `python validate_changes.py changes.json input.pdf`

This checks:
- All fields exist in the PDF
- Values match expected formats
- Required fields are populated
- No conflicting values

**If validation fails:**
- Review error messages
- Fix `changes.json`
- Run validation again

**Step 4: Apply changes**

Only after validation passes:

```bash
python apply_changes.py input.pdf changes.json output.pdf
```

**Step 5: Verify output**

Run: `python verify_output.py output.pdf`
````

### Why This Pattern Works

- **Catches errors early**: Validation finds problems before changes are applied
- **Machine-verifiable**: Scripts provide objective verification
- **Reversible planning**: Claude can iterate on the plan without touching originals
- **Clear debugging**: Error messages point to specific problems

### When to Use

- **Batch operations**: Many items to process
- **Destructive changes**: Hard to undo
- **Complex validation rules**: Multiple constraints
- **High-stakes operations**: Errors are costly

### Implementation Tip

Make validation scripts verbose with specific error messages:

**✓ Good error message:**
```
Error: Field 'signature_date' not found
Available fields: customer_name, order_total, signature_date_signed
Did you mean 'signature_date_signed'?
```

**✗ Bad error message:**
```
Error: Invalid field
```

This helps Claude fix issues quickly.

## MCP Tool References

If your Skill uses MCP (Model Context Protocol) tools, always use fully qualified tool names to avoid "tool not found" errors.

### Format

`ServerName:tool_name`

### Examples

```markdown
Use the BigQuery:bigquery_schema tool to retrieve table schemas.
Use the GitHub:create_issue tool to create issues.
```

Where:
- `BigQuery` and `GitHub` are MCP server names
- `bigquery_schema` and `create_issue` are the tool names within those servers

### Why Fully Qualified Names

Without the server prefix, Claude may fail to locate the tool, especially when multiple MCP servers are available.

### Best Practices

**Always include server name:**

```markdown
✓ Use GitHub:create_pull_request to create PRs
✗ Use create_pull_request to create PRs
```

**Document server dependencies:**

```markdown
## Requirements

This Skill requires the following MCP servers:
- BigQuery server (for data queries)
- GitHub server (for issue management)
```

**Provide setup instructions:**

```markdown
## Setup

Install required MCP servers:

```bash
npm install -g @anthropic/mcp-server-bigquery
npm install -g @anthropic/mcp-server-github
```

Configure in your Claude settings.
```

## Runtime Environment

Understanding how Claude executes your scripts.

### Execution Model

When your Skill instructs Claude to run a script:

1. Claude uses the Bash tool to execute the command
2. The script runs in the user's current working directory
3. Output (stdout/stderr) is captured and returned to Claude
4. Claude uses the output to continue the task

### Environment Assumptions

**Safe assumptions:**
- Standard Unix tools available (bash, grep, find, etc.)
- Python 3.x typically available
- User's current shell environment

**Don't assume:**
- Specific Python packages installed
- Specific tools like Node.js, Ruby, etc.
- Specific environment variables
- Running as root or with special permissions

### Dependencies

Always document and check for dependencies:

```python
# scripts/process.py
import sys

# Check dependencies
try:
    import pdfplumber
    import pandas
except ImportError as e:
    print(f"Missing dependency: {e}")
    print("Install with: pip install pdfplumber pandas")
    sys.exit(1)

# Rest of script...
```

### Working Directory

Scripts should handle paths correctly:

**Use relative paths from Skill directory:**

```python
# Assuming script is in skill_name/scripts/process.py
# and data is in skill_name/data/

import os
from pathlib import Path

# Get skill directory (parent of scripts/)
SKILL_DIR = Path(__file__).parent.parent
DATA_DIR = SKILL_DIR / "data"

def load_config():
    config_path = SKILL_DIR / "config.json"
    with open(config_path) as f:
        return json.load(f)
```

### Error Output

Make scripts communicative:

```python
import sys

def process_data(input_file):
    if not os.path.exists(input_file):
        print(f"Error: Input file not found: {input_file}", file=sys.stderr)
        print(f"Current directory: {os.getcwd()}", file=sys.stderr)
        print(f"Expected path: {os.path.abspath(input_file)}", file=sys.stderr)
        sys.exit(1)

    try:
        # Process...
        print("Success: Processed data")
    except Exception as e:
        print(f"Error processing data: {e}", file=sys.stderr)
        sys.exit(1)
```

This helps Claude (and users) understand what went wrong.

## Testing Your Scripts

Before including scripts in your Skill:

1. **Test in isolation**: Run scripts manually to verify behavior
2. **Test error cases**: Try invalid inputs, missing files, etc.
3. **Check error messages**: Are they clear and actionable?
4. **Verify output format**: Does it match documentation?
5. **Test with Claude**: Have Claude use the Skill and scripts

### Testing Checklist

```markdown
- [ ] Script runs successfully with valid input
- [ ] Script fails gracefully with invalid input
- [ ] Error messages are clear and specific
- [ ] Required dependencies are documented
- [ ] Output format matches documentation
- [ ] Claude can successfully execute the script
- [ ] Script handles missing files appropriately
- [ ] Script handles permission errors appropriately
```

## Advanced Pattern: Self-Validating Scripts

Scripts can validate their own outputs:

```python
# scripts/process_and_validate.py

def process_data(input_file, output_file):
    # Process data
    result = do_processing(input_file)

    # Write output
    with open(output_file, 'w') as f:
        json.dump(result, f)

    # Self-validate
    validation_errors = validate_output(result)

    if validation_errors:
        print(f"Warning: Validation found {len(validation_errors)} issues:")
        for error in validation_errors:
            print(f"  - {error}")
        return False
    else:
        print("Success: Output validated successfully")
        return True
```

This combines processing and validation in one step, ensuring output is always checked.

## Summary

Advanced patterns for Skills with executable code:

1. **Solve, don't punt**: Handle errors in scripts, not in Claude
2. **Provide utility scripts**: Pre-made scripts are more reliable
3. **Use visual analysis**: Let Claude see layouts and structures
4. **Verifiable intermediate outputs**: Validate plans before execution
5. **MCP tool references**: Use fully qualified names
6. **Understand runtime**: Know what's available in execution environment
7. **Test thoroughly**: Verify scripts work before shipping

These patterns make your Skills more robust, reliable, and maintainable.
