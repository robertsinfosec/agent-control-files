---
generates: .github/skills/threat-modeling/SKILL.md
---

/create-skill threat-modeling

# Threat Modeling — Generation Prompt

Skill that provides a STRIDE-based threat modeling workflow producing threat tables, data flow diagrams, and mitigation checklists.

## Design Intent

Threat modeling should happen during design, not after incidents. This skill codifies the STRIDE methodology as a repeatable procedure: define scope, build data flow diagram, apply STRIDE to each component/flow, produce threat table, create mitigation checklist.

## Key Behaviors

- Reads `security-standards.instructions.md` and `docs/ARCHITECTURE.md` for context
- Defines scope (boundaries, actors, data classification, trust boundaries)
- Builds a data flow diagram showing protocols, auth mechanisms, and trust boundary crossings
- Applies all 6 STRIDE categories to each component and data flow
- Rates each threat on likelihood × impact
- Produces mitigation checklist with implementation status
- Stores output as `docs/THREAT-MODEL.md` or as an ADR

## STRIDE Categories

- **S**poofing — identity impersonation
- **T**ampering — data modification
- **R**epudiation — deniable actions
- **I**nformation Disclosure — unauthorized data access
- **D**enial of Service — availability attacks
- **E**levation of Privilege — unauthorized access escalation

## Output

Scope definition, data flow diagram (text-based), STRIDE threat table (Component, Threat, Description, Likelihood, Impact, Risk, Mitigation), and mitigation checklist with verification status.

## Related Files

- `.github/instructions/security-standards.instructions.md` — security governance
- `.github/skills/security-audit/SKILL.md` — complementary code-level audit
- `docs/ARCHITECTURE.md` — system architecture input
