# Document Organization

How to structure your Skill content for optimal performance and maintainability.

## Progressive Disclosure Patterns

SKILL.md serves as an overview that points Claude to detailed materials as needed, like a table of contents in an onboarding guide.

### Practical Guidance

- Keep SKILL.md body under 500 lines for optimal performance
- Split content into separate files when approaching this limit
- Use the patterns below to organize instructions, code, and resources effectively

### Visual Overview: From Simple to Complex

A basic Skill starts with just a SKILL.md file containing metadata and instructions.

As your Skill grows, you can bundle additional content that Claude loads only when needed.

The complete Skill directory structure might look like this:

```
pdf/
├── SKILL.md              # Main instructions (loaded when triggered)
├── FORMS.md              # Form-filling guide (loaded as needed)
├── reference.md          # API reference (loaded as needed)
├── examples.md           # Usage examples (loaded as needed)
└── scripts/
    ├── analyze_form.py   # Utility script (executed, not loaded)
    ├── fill_form.py      # Form filling script
    └── validate.py       # Validation script
```

## Pattern 1: High-Level Guide with References

Keep common operations in SKILL.md, link to detailed documentation for advanced features.

````markdown
---
name: pdf-processing
description: Extracts text and tables from PDF files, fills forms, and merges documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---

# PDF Processing

## Quick start

Extract text with pdfplumber:

```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Advanced features

**Form filling**: See [FORMS.md](FORMS.md) for complete guide
**API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
**Examples**: See [EXAMPLES.md](EXAMPLES.md) for common patterns
````

Claude loads FORMS.md, REFERENCE.md, or EXAMPLES.md only when needed.

### When to Use

- You have basic operations that cover 80% of use cases
- Advanced features require significant documentation
- You want to keep SKILL.md focused and scannable

## Pattern 2: Domain-Specific Organization

For Skills with multiple domains, organize content by domain to avoid loading irrelevant context. When a user asks about sales metrics, Claude only needs to read sales-related schemas, not finance or marketing data. This keeps token usage low and context focused.

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

````markdown
# BigQuery Data Analysis

## Available datasets

**Finance**: Revenue, ARR, billing → See [reference/finance.md](reference/finance.md)
**Sales**: Opportunities, pipeline, accounts → See [reference/sales.md](reference/sales.md)
**Product**: API usage, features, adoption → See [reference/product.md](reference/product.md)
**Marketing**: Campaigns, attribution, email → See [reference/marketing.md](reference/marketing.md)

## Quick search

Find specific metrics using grep:

```bash
grep -i "revenue" reference/finance.md
grep -i "pipeline" reference/sales.md
grep -i "api usage" reference/product.md
```
````

### When to Use

- Your Skill covers multiple distinct domains
- Each domain has substantial documentation
- Users typically work within one domain at a time
- Loading all domains would waste tokens

### Benefits

- **Token efficiency**: Load only relevant domain
- **Faster responses**: Less context to process
- **Easier maintenance**: Update one domain without affecting others
- **Clearer organization**: Domain boundaries are explicit

## Pattern 3: Conditional Details

Show basic content, link to advanced content only when specific features are needed.

```markdown
# DOCX Processing

## Creating documents

Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents

For simple edits, modify the XML directly.

**For tracked changes**: See [REDLINING.md](REDLINING.md)
**For OOXML details**: See [OOXML.md](OOXML.md)
```

Claude reads REDLINING.md or OOXML.md only when the user needs those features.

### When to Use

- Most users need basic functionality
- Advanced features are complex but rarely used
- You want to avoid overwhelming users with details
- Advanced features require different tools or approaches

## Avoid Deeply Nested References

Claude may partially read files when they're referenced from other referenced files. When encountering nested references, Claude might use commands like `head -100` to preview content rather than reading entire files, resulting in incomplete information.

**Keep references one level deep from SKILL.md**. All reference files should link directly from SKILL.md to ensure Claude reads complete files when needed.

### Bad Example: Too Deep

```markdown
# SKILL.md
See [advanced.md](advanced.md)...

# advanced.md
See [details.md](details.md)...

# details.md
Here's the actual information...
```

**Problem**: Claude may only preview `details.md`, missing critical information.

### Good Example: One Level Deep

```markdown
# SKILL.md

**Basic usage**: [instructions in SKILL.md]
**Advanced features**: See [advanced.md](advanced.md)
**API reference**: See [reference.md](reference.md)
**Examples**: See [examples.md](examples.md)
```

**Why it works**: Claude reads complete files when they're directly referenced from SKILL.md.

## Structure Longer Reference Files with Table of Contents

For reference files longer than 100 lines, include a table of contents at the top. This ensures Claude can see the full scope of available information even when previewing with partial reads.

### Example

```markdown
# API Reference

## Contents

- Authentication and setup
- Core methods (create, read, update, delete)
- Advanced features (batch operations, webhooks)
- Error handling patterns
- Code examples

## Authentication and setup

...

## Core methods

...
```

Claude can then read the complete file or jump to specific sections as needed.

### Benefits

- **Quick scanning**: Claude sees all available topics immediately
- **Partial read friendly**: TOC remains visible even in previews
- **Better navigation**: Claude can jump to relevant sections
- **Documentation clarity**: Shows the file's scope at a glance

## File Organization Decision Tree

Use this decision tree to determine how to organize your Skill content:

1. **Is your SKILL.md under 300 lines?**
   - Yes → Keep everything in SKILL.md
   - No → Continue to question 2

2. **Does your Skill cover multiple distinct domains?**
   - Yes → Use Pattern 2 (Domain-specific organization)
   - No → Continue to question 3

3. **Do most users need only basic features?**
   - Yes → Use Pattern 3 (Conditional details)
   - No → Use Pattern 1 (High-level guide with references)

4. **Will any reference file exceed 100 lines?**
   - Yes → Add table of contents to that file
   - No → Simple structure is fine

## Refactoring Tips

When refactoring a large SKILL.md file:

1. **Identify natural boundaries**: Look for distinct topics or domains
2. **Extract infrequently needed content first**: Move advanced features to separate files
3. **Maintain context**: Ensure SKILL.md provides enough context to know when to load references
4. **Test navigation**: Verify Claude can find and load reference files
5. **Add TOCs**: Include table of contents in longer reference files
6. **Keep one level deep**: Avoid references within reference files

## Example: Well-Organized Skill

```
excel-skill/
├── SKILL.md              # Overview, basic operations, navigation
├── formulas.md           # Formula reference (loaded when needed)
├── pivot-tables.md       # Pivot table guide (loaded when needed)
├── charts.md             # Chart creation guide (loaded when needed)
└── scripts/
    ├── validate.py       # Data validation script
    └── export.py         # Export utilities
```

**SKILL.md** (~200 lines): Quick start, common operations, links to reference files

**Reference files** (~150 lines each): Focused documentation with table of contents

**Scripts** (varies): Utility scripts Claude can execute

This structure keeps SKILL.md lean while providing comprehensive documentation through progressive disclosure.
