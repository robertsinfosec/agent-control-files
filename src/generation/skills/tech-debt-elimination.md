---
generates: .github/skills/tech-debt-elimination/SKILL.md
---

/create-skill tech-debt-elimination

# Tech Debt Elimination — Generation Prompt

Skill that provides a systematic debt detection, prioritization, and remediation workflow.

## Design Intent

Tech debt accumulates silently. This skill codifies a full-codebase sweep: explicit markers (TODO/FIXME/HACK), structural debt (dead code, duplication, complexity), architecture debt (circular deps, god objects), and test debt (missing tests, flaky tests). Each item gets risk-rated and effort-estimated, then prioritized via a matrix.

## Key Behaviors

- Reads `zero-tech-debt.instructions.md` for the debt-free standard
- Scans the ENTIRE codebase, not just recent changes
- Detects explicit markers, structural debt, architecture debt, and test debt
- Prioritizes via risk × effort matrix (Critical+Small = Fix NOW, Low+Large = Backlog)
- Fixes small items directly, reports medium/large for approval
- Runs tests after every remediation
- Never introduces new debt while fixing existing debt

## Output

Debt inventory table (Type, Location, Risk, Effort, Status), priority matrix, and remediation summary.

## Related Files

- `.github/instructions/zero-tech-debt.instructions.md` — debt-free governance
- `.github/agents/tech-debt-hunter.agent.md` — agent that uses this skill’s patterns
