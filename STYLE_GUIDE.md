# Style Guide

Standards for authoring control files and generation files in this repository.

## Control Files (`src/.github/`)

### Frontmatter

Every control file starts with a YAML frontmatter block:

```yaml
---
applyTo: "**/*.ts, **/*.js"
generation-source: "generation/instructions/example.md"
---
```

- `applyTo` values are **comma-separated strings**, not JSON arrays
- Quote values that contain special characters
- `generation-source` paths are relative to `src/`

### Body Content

- **Imperative voice**: "Use parameterized queries" not "You should use parameterized queries"
- **⛔/✅ markers** for do/don't rules:
  ```
  ⛔ NEVER commit secrets to source control
  ✅ ALWAYS use environment variables for credentials
  ```
- **MUST/NEVER/ALWAYS** for non-negotiable rules
- **SHOULD/PREFER** for strong recommendations
- Minimum 10 lines per file (enforced by validation)

### File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Instructions | `kebab-case.instructions.md` | `security-standards.instructions.md` |
| Prompts | `kebab-case.prompt.md` | `detect-stack.prompt.md` |
| Agents | `kebab-case.agent.md` | `security-reviewer.agent.md` |
| Skills | `kebab-case/SKILL.md` | `security-audit/SKILL.md` |

## Generation Files (`src/generation/`)

### Frontmatter

```yaml
---
generates: .github/instructions/example.instructions.md
---
```

- `generates` paths are relative to the `.github/` root (as consumers see them)
- Line 5 must be the `/create-*` command (`/create-instruction`, `/create-prompt`, `/create-agent`, or `/create-skill`)

### Body Content

- Write as a **SME braindump** — natural language, not structured markdown
- Include: what to enforce, which standards/frameworks, edge cases, examples of good/bad
- The LLM transforms this into a structured control file — you don't need to format it

## Changelog

Follows [Keep a Changelog v1.1.0](https://keepachangelog.com/en/1.1.0/):

- Write entries from the **consumer's perspective**
- Reference specific file names for control file changes
- Categories: Added, Changed, Fixed, Removed, Deprecated, Security
- Don't include empty categories

## Commit Messages

- Use [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `chore:`, `docs:`
- Keep the subject line under 72 characters
- Reference issue numbers when applicable: `feat: add threat-modeling skill (#42)`
