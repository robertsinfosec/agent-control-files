---
generates: .github/prompts/review-work.prompt.md
---

/create-prompt review-work.prompt.md

# Review Work — Generation Prompt

This prompt performs a comprehensive code review of completed work, checking against all governance standards. This is the prompt where human-written code gets evaluated against the same standards the LLM follows natively.

## Workflow

1. User provides a GitHub Issue number, branch name, or set of changed files
2. The prompt gathers the changeset (via `gh pr diff`, `git diff`, or file inspection)
3. It reviews against every applicable governance standard
4. It produces a structured review report
5. Optionally creates new GitHub Issues for findings that need remediation

## Review Checklist

The review MUST check against ALL of these, referencing the specific instruction file:

### Security (security-standards.instructions.md)
- Input validation and parameterized queries
- Authentication and authorization
- Secrets management
- Output encoding
- Error handling (no information leakage)

### Code Quality (coding-standards.instructions.md)
- Simplicity and clarity
- Modularity and dependency boundaries
- Naming and readability
- Error handling semantics

### Technical Debt (zero-tech-debt.instructions.md)
- No net-new debt introduced
- No deferred cleanup
- No incomplete migrations
- No stale artifacts

### Testing (testing-standards.instructions.md)
- Tests exist for changed behavior
- Tests follow AAA structure
- Edge cases and error paths covered
- Coverage target met (minimum 75% branch coverage)

### Stack-Specific (stack-standards.instructions.md)
- Technology-specific idioms followed
- Linter/formatter compliance

### Database (database-safety.instructions.md) — if applicable
- Migration safety
- Parameterized queries
- Data protection

### API Design (api-design.instructions.md) — if applicable
- Resource naming and HTTP semantics
- Error response format
- Pagination and versioning

### Accessibility (accessibility.instructions.md) — if applicable
- Semantic HTML
- Keyboard operability
- ARIA compliance

## Output Format

Structured review report with:
- **Summary**: Pass/fail with severity breakdown
- **Findings**: Each finding cites the specific governance rule violated
- **Severity**: Critical, High, Medium, Low, Informational
- **Remediation**: Specific fix recommendation for each finding

## Key Behaviors

- Be thorough and uncompromising — this is the quality gate
- Cite specific section numbers from instruction files
- Distinguish between governance violations (must fix) and suggestions (nice to have)
- If creating issues for findings, label them appropriately and link to the original issue

## Tools Required

- `read` + `search`: Inspect code and governance files
- `execute`: Run `gh`, `git diff`, test commands, lint commands
