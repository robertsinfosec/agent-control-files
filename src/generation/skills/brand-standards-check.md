---
generates: .github/skills/brand-standards-check/SKILL.md
---

/create-skill brand-standards-check

# Brand Standards Check — Generation Prompt

Skill that provides a structured brand compliance audit workflow against `docs/BRAND.md`.

## Design Intent

Brand consistency is hard to enforce because it requires domain knowledge (the brand guidelines) applied to scattered outputs (UI strings, docs, error messages). This skill codifies the audit as a repeatable procedure.

## Key Behaviors

- Must read `docs/BRAND.md` as prerequisite — if missing, stop and warn
- Audits only user-facing content (not internal variable names or private comments)
- Every finding cites the exact brand rule from `docs/BRAND.md`
- Never invents brand rules

## Audit Scope

1. Terminology — product names, company name, feature names (exact spelling, capitalization, trademark symbols)
2. Voice and Tone — user-facing language matches documented voice guidelines
3. Visual Identity — colors, fonts, logos in code match brand tokens
4. UI Components — buttons, headings, labels use approved terminology
5. Documentation — README, API docs follow brand voice

## Output

Findings table: File, Line, Issue, Brand Rule (quoted), Recommended Fix. Grouped by category.

## Related Files

- `.github/instructions/brand-compliance.instructions.md` — governance rules
- `.github/agents/brand-guardian.agent.md` — agent that uses this skill’s patterns
