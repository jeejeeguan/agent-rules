# Anti-Patterns to Avoid

Common mistakes in Skill authoring and how to avoid them.

## Avoid Windows-Style Paths

Always use forward slashes in file paths, even on Windows.

### The Problem

Windows-style paths with backslashes cause errors on Unix systems (Linux, macOS).

### Examples

**✓ Good: Unix-style paths**
```markdown
See [reference guide](reference/guide.md)
Run: `python scripts/helper.py`
```

**✗ Avoid: Windows-style paths**
```markdown
See [reference guide](reference\guide.md)
Run: `python scripts\helper.py`
```

### Why It Matters

- Unix-style paths (`/`) work on all platforms (Windows, Linux, macOS)
- Windows-style paths (`\`) only work on Windows
- Most servers and development environments use Unix-based systems

### Apply Consistently

Use forward slashes in:
- File references in markdown: `[link](path/to/file.md)`
- Command examples: `python scripts/process.py`
- Configuration files: `"path": "data/config.json"`
- Directory structures in documentation

## Avoid Offering Too Many Options

Don't present multiple approaches unless necessary.

### The Problem

Too many options create decision paralysis and confusion.

### Examples

**✗ Bad: Too many choices** (confusing):

```markdown
## PDF text extraction

You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image with pytesseract,
or camelot for tables, or tabula-py, or pdfminer.six, or...

Each has different strengths:
- pypdf is fast but basic
- pdfplumber handles tables well
- PyMuPDF is feature-rich but complex
- pdf2image needs OCR setup
...
```

**✓ Good: Provide a default** (with escape hatch):

```markdown
## PDF text extraction

Use pdfplumber for text extraction:

```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

### When Multiple Options Are Appropriate

It's okay to present options when:

1. **Clear decision criteria exist:**

```markdown
**Text-based PDFs:** Use pdfplumber (fast, simple)
**Scanned PDFs:** Use pdf2image + pytesseract (OCR required)
```

2. **Different use cases require different tools:**

```markdown
**Creating new documents:** Use docx-js library
**Editing existing documents:** Modify XML directly
```

3. **Performance trade-offs matter:**

```markdown
**Small files (<10MB):** Load into memory (faster)
**Large files (>10MB):** Use streaming (memory efficient)
```

### Guideline

Provide one recommended approach that handles 80% of cases. Mention alternatives only when they solve different problems.

## Avoid Time-Sensitive Information

Don't include information that will become outdated.

### The Problem

Time-sensitive instructions become incorrect and misleading as time passes.

### Examples

**✗ Bad: Time-sensitive** (will become wrong):

```markdown
If you're doing this before August 2025, use the old API.
After August 2025, use the new API.
```

**Problems:**
- Becomes incorrect after August 2025
- Requires manual updates
- Confusion about which version is "current"

**✓ Good: Use "old patterns" section**:

```markdown
## Current method

Use the v2 API endpoint: `api.example.com/v2/messages`

## Old patterns

<details>
<summary>Legacy v1 API (deprecated 2025-08)</summary>

The v1 API used: `api.example.com/v1/messages`

This endpoint is no longer supported.

</details>
```

### Benefits of Old Patterns Section

- Always shows current method first
- Preserves historical context
- Helps users migrate old code
- No confusion about "current" vs "old"
- Collapsible details keep content clean

### Use Cases for Old Patterns

- Deprecated APIs or methods
- Legacy file formats
- Superseded approaches
- Migration guides

### Template

```markdown
## Current approach

[Current best practice]

## Old patterns

<details>
<summary>[Legacy method name] (deprecated [YYYY-MM])</summary>

[Old approach with brief explanation]

[Why it changed / why avoid]

</details>
```

## Use Consistent Terminology

Choose one term and use it throughout the Skill.

### The Problem

Inconsistent terms confuse Claude and make instructions harder to follow.

### Examples

**✗ Bad: Inconsistent**

Mix these terms interchangeably:
- "API endpoint", "URL", "API route", "path", "API address"
- "field", "box", "element", "control", "input"
- "extract", "pull", "get", "retrieve", "obtain"

**✓ Good: Consistent**

Choose one term and stick with it:
- Always "API endpoint"
- Always "field"
- Always "extract"

### Creating a Terminology List

For complex Skills, define key terms once:

```markdown
## Terminology

Throughout this Skill:
- **API endpoint**: The URL where API requests are sent
- **Field**: An input area in a form
- **Extract**: To pull specific data from a document

We use these terms consistently.
```

### Benefits

- Easier to search (grep for specific terms)
- Clearer instructions
- Better Claude comprehension
- More maintainable documentation

## Avoid Assuming Tools Are Installed

Don't assume packages or tools are available.

### The Problem

Assuming installation leads to confusing errors when dependencies are missing.

### Examples

**✗ Bad: Assumes installation**:

```markdown
Use the pdf library to process the file.
```

**Problems:**
- Which pdf library? (pypdf, pdfplumber, PyMuPDF?)
- Is it installed?
- What if it's not available?

**✓ Good: Explicit about dependencies**:

````markdown
Install required package: `pip install pdfplumber`

Then use it:

```python
import pdfplumber
reader = pdfplumber.open("file.pdf")
```
````

### Best Practices

**Show installation command:**

```markdown
Install dependencies:
```bash
pip install pdfplumber pandas
```
```

**Check for availability:**

```python
try:
    import pdfplumber
except ImportError:
    print("Install pdfplumber: pip install pdfplumber")
    exit(1)
```

**Provide requirements file:**

```markdown
Install all dependencies:
```bash
pip install -r requirements.txt
```

See `requirements.txt` for the complete list.
```

## Avoid Vague Degrees of Freedom

Be intentional about how much flexibility Claude has.

### The Problem

Unclear guidance leads to unpredictable behavior.

### Examples

**✗ Bad: Vague freedom**:

```markdown
Process the data in whatever way makes sense.
```

**Problems:**
- What approaches are valid?
- What's the expected output format?
- What constraints exist?

**✓ Good: Clear freedom**:

```markdown
Process the data by:
1. Removing rows with null values
2. Normalizing numeric columns (0-1 range)
3. Sorting by date column

Output format: CSV with headers
```

Or for high freedom:

```markdown
Analyze the data quality. Consider:
- Missing values (how many? which columns?)
- Outliers (any suspicious values?)
- Consistency (formats, ranges, relationships)

Summarize findings in plain English.
```

Both are clear about expectations, even though one is more flexible.

## Avoid Nested Skill References

Don't reference Skills from within other Skills.

### The Problem

Nested Skill calls create complexity and unpredictable behavior.

### Examples

**✗ Bad: Nested reference**:

```markdown
# Skill A

To process Excel files, use the `excel-processing` Skill.
```

**Problems:**
- Claude might not reliably invoke the other Skill
- Context switching is complex
- Dependencies between Skills are fragile

**✓ Good: Self-contained or direct reference**:

```markdown
# Skill A

To process Excel files, use pandas:

```python
import pandas as pd
df = pd.read_excel("file.xlsx")
```

For advanced Excel operations, see [reference/excel.md](reference/excel.md)
```

Or tell the user explicitly:

```markdown
For Excel processing, use the `excel-processing` Skill separately.
```

### Exception

It's okay to mention other Skills to the user:

```markdown
Note: For PDF generation, consider using the `pdf-generation` Skill.
```

But don't instruct Claude to invoke them automatically.

## Avoid Over-Explanation

Remember: Claude is already smart.

### The Problem

Explaining common knowledge wastes tokens and obscures important information.

### Examples

**✗ Bad: Over-explained**:

```markdown
Python is a programming language. Functions in Python are defined using the
`def` keyword. When you want to create a function, you write `def` followed
by the function name, then parentheses, and then a colon. Inside the function,
you indent the code. To call a function, you write its name followed by
parentheses.
```

**✓ Good: Assumes knowledge**:

```markdown
Define and use the helper function:

```python
def extract_text(pdf_path):
    return pdfplumber.open(pdf_path).pages[0].extract_text()

text = extract_text("file.pdf")
```
```

### What to Explain

**Do explain:**
- Domain-specific concepts unique to your Skill
- Non-obvious tool behavior or gotchas
- Why a particular approach is recommended

**Don't explain:**
- Basic programming concepts
- Common tool usage
- Well-documented library APIs

### Example: Right Amount of Explanation

```markdown
## Form filling

Use fillable PDF forms, not flattened PDFs. Flattened forms have no field
definitions and can't be filled programmatically.

Check if a PDF has fillable fields:
```python
fields = pdf.get_fields()
if not fields:
    print("This PDF has no fillable fields")
```
```

This explains the domain-specific concept (fillable vs flattened) but assumes
Claude knows Python basics.

## Summary

Anti-patterns to avoid:

1. **Windows-style paths**: Use forward slashes everywhere
2. **Too many options**: Provide one default with escape hatches
3. **Time-sensitive info**: Use "old patterns" section instead
4. **Inconsistent terms**: Pick terms and stick with them
5. **Assuming installation**: Show installation commands
6. **Vague freedom**: Be clear about constraints and expectations
7. **Nested Skill references**: Keep Skills self-contained
8. **Over-explanation**: Trust Claude's knowledge

Following these guidelines keeps your Skills reliable, maintainable, and easy to use.
