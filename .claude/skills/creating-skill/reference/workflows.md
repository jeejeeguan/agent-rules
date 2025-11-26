# Workflows and Feedback Loops

How to structure complex, multi-step processes and implement quality checks.

## Use Workflows for Complex Tasks

Break complex operations into clear, sequential steps. For particularly complex workflows, provide a checklist that Claude can copy into its response and check off as it progresses.

### Example 1: Research Synthesis Workflow (Non-Code)

For Skills without code, workflows help organize analysis and research tasks.

````markdown
## Research synthesis workflow

Copy this checklist and track your progress:

```
Research Progress:
- [ ] Step 1: Read all source documents
- [ ] Step 2: Identify key themes
- [ ] Step 3: Cross-reference claims
- [ ] Step 4: Create structured summary
- [ ] Step 5: Verify citations
```

**Step 1: Read all source documents**

Review each document in the `sources/` directory. Note the main arguments and supporting evidence.

**Step 2: Identify key themes**

Look for patterns across sources. What themes appear repeatedly? Where do sources agree or disagree?

**Step 3: Cross-reference claims**

For each major claim, verify it appears in the source material. Note which source supports each point.

**Step 4: Create structured summary**

Organize findings by theme. Include:

- Main claim
- Supporting evidence from sources
- Conflicting viewpoints (if any)

**Step 5: Verify citations**

Check that every claim references the correct source document. If citations are incomplete, return to Step 3.
````

This example shows how workflows apply to analysis tasks that don't require code. The checklist pattern works for any complex, multi-step process.

### Example 2: PDF Form Filling Workflow (With Code)

For Skills with executable code, workflows coordinate script execution and validation.

````markdown
## PDF form filling workflow

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Step 1: Analyze the form (run analyze_form.py)
- [ ] Step 2: Create field mapping (edit fields.json)
- [ ] Step 3: Validate mapping (run validate_fields.py)
- [ ] Step 4: Fill the form (run fill_form.py)
- [ ] Step 5: Verify output (run verify_output.py)
```

**Step 1: Analyze the form**

Run: `python scripts/analyze_form.py input.pdf`

This extracts form fields and their locations, saving to `fields.json`.

**Step 2: Create field mapping**

Edit `fields.json` to add values for each field.

**Step 3: Validate mapping**

Run: `python scripts/validate_fields.py fields.json`

Fix any validation errors before continuing.

**Step 4: Fill the form**

Run: `python scripts/fill_form.py input.pdf fields.json output.pdf`

**Step 5: Verify output**

Run: `python scripts/verify_output.py output.pdf`

If verification fails, return to Step 2.
````

Clear steps prevent Claude from skipping critical validation. The checklist helps both Claude and users track progress through multi-step workflows.

## When to Use Workflows

Use structured workflows when:

- **Multiple steps required**: Task has 3+ sequential steps
- **Order matters**: Steps must execute in specific sequence
- **Validation needed**: Each step should be verified before proceeding
- **Error-prone**: Users or Claude might skip important steps
- **Complex coordination**: Multiple tools or files involved

Don't use workflows for:

- Simple one-step operations
- Obvious sequences that Claude handles naturally
- Tasks where flexibility is more important than structure

## Checklist Best Practices

### Format

Use markdown checkboxes for clarity:

```
- [ ] Step description
```

Not:

```
1. Step description
✓ Step description
* Step description
```

### Granularity

Each checkbox should represent:
- A distinct, completable action
- Something that produces verifiable output
- A clear state change (before/after)

### Step Descriptions

Make step descriptions:
- **Action-oriented**: Start with verbs (Run, Create, Verify)
- **Specific**: Include exact commands or file names
- **Self-contained**: Understandable without reading other steps

## Implement Feedback Loops

**Common pattern**: Run validator → fix errors → repeat

This pattern greatly improves output quality.

### Example 1: Style Guide Compliance (Non-Code)

```markdown
## Content review process

1. Draft your content following the guidelines in STYLE_GUIDE.md
2. Review against the checklist:
   - Check terminology consistency
   - Verify examples follow the standard format
   - Confirm all required sections are present
3. If issues found:
   - Note each issue with specific section reference
   - Revise the content
   - Review the checklist again
4. Only proceed when all requirements are met
5. Finalize and save the document
```

This shows the validation loop pattern using reference documents instead of scripts. The "validator" is STYLE_GUIDE.md, and Claude performs the check by reading and comparing.

### Example 2: Document Editing Process (With Code)

```markdown
## Document editing process

1. Make your edits to `word/document.xml`
2. **Validate immediately**: `python ooxml/scripts/validate.py unpacked_dir/`
3. If validation fails:
   - Review the error message carefully
   - Fix the issues in the XML
   - Run validation again
4. **Only proceed when validation passes**
5. Rebuild: `python ooxml/scripts/pack.py unpacked_dir/ output.docx`
6. Test the output document
```

The validation loop catches errors early.

## Feedback Loop Best Practices

### Early Validation

Validate as soon as possible after making changes:

**Good:**
```markdown
1. Edit configuration file
2. Validate configuration
3. If validation fails, fix and validate again
4. Deploy configuration
```

**Bad:**
```markdown
1. Edit configuration file
2. Update related files
3. Make more changes
4. Deploy and hope it works
```

### Clear Failure Paths

Always specify what to do when validation fails:

**Good:**
```markdown
3. Run validation script
4. If validation fails:
   - Review error messages
   - Fix specific issues
   - Return to step 3
5. Only proceed when validation passes
```

**Bad:**
```markdown
3. Run validation script
4. Proceed with deployment
```

### Iteration Limits

For operations that might loop indefinitely, consider adding limits:

```markdown
3. Run validation (maximum 3 attempts)
4. If validation fails after 3 attempts:
   - Document the remaining errors
   - Ask user for guidance
```

## Combining Workflows and Feedback Loops

Workflows and feedback loops work together. A complete pattern might look like:

````markdown
## Complete workflow with validation

Copy this checklist:

```
Progress:
- [ ] Step 1: Initial setup
- [ ] Step 2: Main processing (with validation loop)
- [ ] Step 3: Final verification
```

**Step 1: Initial setup**

Prepare input files and dependencies.

**Step 2: Main processing**

1. Process the data: `python process.py input.json`
2. **Validate output**: `python validate.py output.json`
3. **If validation fails:**
   - Review errors
   - Fix issues in input.json
   - Return to step 2.1
4. **Only proceed when validation passes**

**Step 3: Final verification**

Review complete output and confirm results meet requirements.
````

## Advanced: Conditional Workflows

Guide Claude through decision points based on context.

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

### When Workflows Become Large

If workflows become large or complicated with many steps, consider pushing them into separate files and tell Claude to read the appropriate file based on the task at hand.

**Example:**

```markdown
## Workflow selection

**Creating new documents?** See [workflows/creation.md](workflows/creation.md)
**Editing existing documents?** See [workflows/editing.md](workflows/editing.md)
**Converting formats?** See [workflows/conversion.md](workflows/conversion.md)
```

This keeps SKILL.md clean while providing detailed workflow guidance.

## Testing Your Workflows

Before finalizing a workflow, verify:

1. **Completeness**: Does it cover all necessary steps?
2. **Order**: Are steps in the correct sequence?
3. **Clarity**: Can Claude follow it without ambiguity?
4. **Error handling**: What happens when steps fail?
5. **Exit conditions**: How does Claude know when to stop?

Try the workflow manually to ensure it works as intended.

## Workflow Anti-Patterns

### Too Many Steps

Breaking tasks into 10+ steps can be overwhelming. Group related actions:

**Too granular:**
```
1. Open file
2. Read file
3. Close file
4. Parse content
5. Validate content
...
```

**Better:**
```
1. Load and parse input file
2. Validate content structure
3. Process data
...
```

### Vague Steps

Steps should be actionable, not aspirational:

**Vague:**
```
1. Fix the issues
2. Make it better
```

**Actionable:**
```
1. Run `python validate.py` and fix reported errors
2. Optimize queries with indexes on frequently accessed columns
```

### Missing Failure Paths

Every validation should include what to do on failure:

**Incomplete:**
```
3. Validate output
4. Continue processing
```

**Complete:**
```
3. Validate output
4. If validation fails, return to step 2
5. If validation passes, continue processing
```
