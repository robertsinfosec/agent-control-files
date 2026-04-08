---
generates: .github/prompts/plan-work.prompt.md
---

/create-prompt plan-work.prompt.md

# Plan Work — Generation Prompt

This prompt takes a braindump (rough ideas, feature requests, bug reports, strategic goals) and organizes them into well-structured GitHub Issues using the `gh` CLI.

## Workflow

1. User provides a braindump — free-form text describing what they want to accomplish
2. The prompt reads existing code, issues, and project context to understand the current state
3. It breaks the braindump into discrete, actionable work items
4. It identifies dependencies and ordering between items
5. It creates GitHub Issues for each item using `gh issue create`

## Issue Structure

Each created issue should include:
- **Title**: Clear, action-oriented ("Add input validation to user registration endpoint")
- **Type label**: `feature`, `enhancement`, `bug`, `chore`
- **Body**: Problem statement, acceptance criteria, technical approach, dependencies
- **Labels**: Appropriate labels from the repo's label set

## Key Behaviors

- Read `docs/PRD.md` and `docs/ARCHITECTURE.md` if they exist — use them to context-check the braindump
- Check existing issues to avoid duplicates
- If a work item is too large, break it into smaller issues with dependencies noted
- Ask the user for clarification if the braindump is ambiguous on scope or priority
- Create issues in dependency order — foundational items first

## Tools Required

- `read` + `search`: Understand current codebase and existing issues
- `execute`: Run `gh issue create` and `gh issue list`
