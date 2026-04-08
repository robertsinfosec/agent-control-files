---
generates: .github/skills/readme-badge-bar/SKILL.md
---

/create-skill readme-badge-bar

# README Badge Bar — Generation Prompt

Skill that detects applicable badges from repository configuration and generates a formatted badge bar for README.md.

## Design Intent

Badges signal project health at a glance but go stale easily. This skill auto-detects what badges are applicable by scanning workflows, coverage tools, package registries, and license files, then generates correct URLs.

## Key Behaviors

- Detects repository owner/name from git config
- Scans `.github/workflows/` for CI workflows → GitHub Actions status badges
- Scans for coverage tools (Codecov, Coveralls) → coverage badges
- Scans package manifests → package version badges (npm, PyPI, crates.io)
- Detects LICENSE file → license badge
- Only generates badges for services actually configured — never for services not in use

## Badge Order

CI status → Coverage → Package version → License

## Output

Single-line badge bar inserted after the `# Title` heading in README.md. Replaces existing badge bar if present.

## Related Files

- `.github/instructions/readme-badges.instructions.md` — badge formatting governance
