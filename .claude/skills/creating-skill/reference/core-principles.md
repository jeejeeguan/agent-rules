# Core Principles

Two fundamental principles guide effective Skill authoring: conciseness and appropriate degrees of freedom.

## Concise is Key

**Default assumption**: Claude is already very smart.

Only add context Claude doesn't already have. Challenge each piece of information:

- "Does Claude really need this explanation?"
- "Can I assume Claude knows this?"
- "Does this paragraph justify its token cost?"

### Example: Concise vs Verbose

**Good example: Concise** (approximately 50 tokens):

````markdown
## Extract PDF text

Use pdfplumber for text extraction:

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
````

**Bad example: Too verbose** (approximately 150 tokens):

```markdown
## Extract PDF text

PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. There are many libraries available for PDF processing, but we
recommend pdfplumber because it's easy to use and handles most cases well.
First, you'll need to install it using pip. Then you can use the code below...
```

The concise version assumes Claude knows what PDFs are and how libraries work.

### Why Conciseness Matters

1. **Token efficiency**: Less context means faster responses and lower costs
2. **Clarity**: Shorter content is easier to scan and understand
3. **Maintenance**: Less content means less to update and maintain
4. **Focus**: Concise instructions highlight what truly matters

### Applying Conciseness

Before including information, ask:
- Does this explain common knowledge? (Remove it)
- Does this repeat Claude's training? (Remove it)
- Does this provide unique domain knowledge? (Keep it)
- Does this prevent a specific error? (Keep it)

## Set Appropriate Degrees of Freedom

Match the level of specificity to the task's fragility and variability.

Think of Claude as a robot exploring a path:
- **Narrow bridge with cliffs**: Only one safe way forward → Use specific guardrails (low freedom)
- **Open field with no hazards**: Many paths lead to success → Give general direction (high freedom)

### High Freedom (Text-Based Instructions)

Use when:
- Multiple approaches are valid
- Decisions depend on context
- Heuristics guide the approach

**Example:**

```markdown
## Code review process

1. Analyze the code structure and organization
2. Check for potential bugs or edge cases
3. Suggest improvements for readability and maintainability
4. Verify adherence to project conventions
```

This gives Claude flexibility to adapt the review to the specific code and context.

### Medium Freedom (Pseudocode or Scripts with Parameters)

Use when:
- A preferred pattern exists
- Some variation is acceptable
- Configuration affects behavior

**Example:**

````markdown
## Generate report

Use this template and customize as needed:

```python
def generate_report(data, format="markdown", include_charts=True):
    # Process data
    # Generate output in specified format
    # Optionally include visualizations
```
````

This provides structure while allowing customization through parameters.

### Low Freedom (Specific Scripts, Few or No Parameters)

Use when:
- Operations are fragile and error-prone
- Consistency is critical
- A specific sequence must be followed

**Example:**

````markdown
## Database migration

Run exactly this script:

```bash
python scripts/migrate.py --verify --backup
```

Do not modify the command or add additional flags.
````

This ensures critical operations execute correctly without variation.

## Choosing the Right Level

Ask these questions:

1. **How fragile is this operation?**
   - Very fragile → Low freedom
   - Robust → High freedom

2. **How many valid approaches exist?**
   - One correct way → Low freedom
   - Many valid ways → High freedom

3. **What's the cost of mistakes?**
   - High cost (data loss, security) → Low freedom
   - Low cost (style preferences) → High freedom

4. **Does context matter?**
   - Heavily context-dependent → High freedom
   - Context-independent → Low freedom

## Balancing the Principles

Conciseness and degrees of freedom work together:

- **High freedom + Concise**: Give brief heuristic guidance
- **Low freedom + Concise**: Provide exact commands without explanation
- **Medium freedom + Concise**: Show pattern with minimal commentary

The goal is always the same: give Claude exactly what it needs to succeed, nothing more, nothing less.
