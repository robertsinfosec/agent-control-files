---
generates: .github/skills/sca-setup/SKILL.md
---

/create-skill sca-setup

# SCA Setup — Generation Prompt

Skill that detects package ecosystems and generates Dependabot configuration plus CI audit checks for dependency vulnerability scanning.

## Design Intent

Every repository using third-party dependencies needs SCA. This skill auto-detects all package ecosystems and produces both Dependabot config (for automated updates) and CI audit steps (for blocking vulnerable dependencies in PRs).

## Key Behaviors

- Detects all package ecosystems from manifests and lockfiles
- Generates `.github/dependabot.yml` with one entry per ecosystem
- Always includes `github-actions` ecosystem to keep workflow actions updated
- Adds CI audit step appropriate to each package manager (npm audit, pip-audit, govulncheck, cargo audit)
- Reports GitHub repo settings that need manual enablement (Dependabot alerts, security updates)

## Output

Working `.github/dependabot.yml` and CI workflow updates with audit steps.

## Related Files

- `.github/instructions/sca-scanning.instructions.md` — SCA governance
- `.github/instructions/security-standards.instructions.md` — security governance
