---
generates: .github/skills/sast-setup/SKILL.md
---

/create-skill sast-setup

# SAST Setup — Generation Prompt

Skill that detects project languages and generates a working GitHub Actions SAST workflow (CodeQL or Semgrep).

## Design Intent

Every repository should have SAST scanning. This skill removes the friction of setting it up by auto-detecting languages and producing a correctly configured workflow file.

## Key Behaviors

- Detects languages from package manifests and file extensions
- Defaults to CodeQL (free for public repos, included with GitHub Advanced Security)
- Generates `.github/workflows/codeql.yml` with correct language matrix
- Configures weekly scheduled scans plus PR triggers
- Sets correct permissions (security-events: write, contents: read)
- Optionally adds custom query packs for project-specific concerns

## Supported Languages

CodeQL: JavaScript, TypeScript, Python, Go, Java, Kotlin, C, C++, C#, Ruby
Semgrep: Broader coverage including PHP, Rust, Terraform, Docker

## Output

Working `.github/workflows/codeql.yml` and optional `codeql-config.yml`.

## Related Files

- `.github/instructions/sast-scanning.instructions.md` — SAST governance
- `.github/instructions/security-standards.instructions.md` — security governance
