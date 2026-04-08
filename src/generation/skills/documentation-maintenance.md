---
generates: .github/skills/documentation-maintenance/SKILL.md
---

/create-skill documentation-maintenance

# Documentation Maintenance — Generation Prompt

Skill that provides a structured documentation audit and maintenance workflow.

## Design Intent

Documentation drifts from code constantly. This skill codifies a systematic audit: inventory all docs, verify each claim against actual code, and fix or report staleness.

## Key Behaviors

- Inventories ALL documentation (README, docs/, CHANGELOG, inline API docs, config comments)
- Verifies every claim against actual code — never writes aspirational content
- Code examples must be syntactically valid and checked against the codebase
- Fixes directly when the correct information can be determined from code
- Reports findings needing human input

## Audit Scope

1. README.md — description, setup, usage, badges, links, technology list
2. API docs — every public endpoint/function documented, examples current
3. Architecture docs — module structure, dependencies, data flows match reality
4. Changelog — recent changes documented, versions match manifests
5. Inline docs — JSDoc/docstrings/GoDoc for public APIs

## Writing Standards

- Clear, concise, active voice
- No jargon without definition
- Follows brand-compliance.instructions.md for tone
- Follows readme-badges.instructions.md for badges

## Related Files

- `.github/instructions/brand-compliance.instructions.md`
- `.github/instructions/readme-badges.instructions.md`
- `.github/agents/technical-writer.agent.md` — agent that uses this skill’s patterns
