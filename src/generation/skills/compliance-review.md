---
generates: .github/skills/compliance-review/SKILL.md
---

/create-skill compliance-review

# Compliance Review — Generation Prompt

Skill that provides a structured GRC compliance audit workflow producing a compliance matrix with regulatory citations.

## Design Intent

Compliance auditing requires methodical control-by-control evaluation with evidence collection and regulatory citations. This skill codifies that methodology as a repeatable procedure that any agent can invoke.

## Key Behaviors

- Reads `compliance-controls.instructions.md` first to understand org-specific obligations
- Warns if that file is a stub (generic review only)
- Maps data flows before evaluating controls
- Every finding cites specific regulation sections (e.g., "GDPR Article 32(1)(a)")
- Produces a compliance matrix as primary output

## Audit Domains

1. Data Protection — encryption, classification, retention, cross-border transfers
2. Access Control — authentication, authorization, least privilege, sessions
3. Privacy — consent, data subject rights, minimization, privacy by design
4. Audit Trail — logging completeness, tamper-resistance, evidence collection
5. Incident Response — breach notification, emergency access revocation, forensic logging

## Output

Compliance matrix: Control ID, Regulation, Description, Status (PASS/FAIL), Evidence, Finding. Plus detailed findings with risk and remediation.

## Related Files

- `.github/instructions/compliance-controls.instructions.md` — org-specific controls
- `.github/agents/compliance-auditor.agent.md` — agent that uses this skill’s patterns
