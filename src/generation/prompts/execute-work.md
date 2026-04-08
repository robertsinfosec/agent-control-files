---
generates: .github/prompts/execute-work.prompt.md
---

/create-prompt execute-work.prompt.md

# Execute Work — Generation Prompt

This prompt takes a GitHub Issue (or ad-hoc task description) and implements the solution following all project governance standards.

## Workflow

1. User provides a GitHub Issue number or task description
2. The prompt reads the issue details (via `gh issue view`)
3. It reads relevant code, docs, and instruction files to understand context
4. It implements the solution following all governance rules
5. It creates/updates tests, documentation, and related files
6. It produces a PR-ready changeset

## Key Behaviors

- Read the issue fully before writing any code
- Check `docs/ARCHITECTURE.md` for structural guidance
- Follow ALL scoped instruction files that apply to the changed files
- Implement tests that cover the changed behavior (per testing-standards)
- Update documentation if behavior, APIs, or configuration changed
- Follow the change completeness checklist from copilot-instructions.md
- If the issue is ambiguous, ask the user rather than guessing

## What "PR-ready" Means

- All governance rules followed
- Tests pass
- No lint errors
- Documentation updated
- Commit message follows conventional format

## Tools Required

- `agent` mode: Full tool access for reading, editing, searching, and running commands
