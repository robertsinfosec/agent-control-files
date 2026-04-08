---
generates: .github/instructions/brand-compliance.instructions.md
---

/create-instruction brand-compliance.instructions.md

# Brand Compliance — Generation Prompt

You are generating a Copilot instruction file that enforces brand consistency across user-facing output. This file is a governance layer that points to an org-specific `docs/BRAND.md` file — it does NOT contain the brand standards themselves but enforces that they exist and are followed.

## Architecture

This is a two-layer system:
1. **This instruction file** (brand-compliance.instructions.md): Universal governance rules — ensure BRAND.md exists, reference it for specifics, enforce consistency.
2. **`docs/BRAND.md`** (per-repository): The actual brand standards — colors, typography, voice, tone, logo usage, terminology. This file is org-specific and must be authored by the brand team.

The instruction file should WARN when `docs/BRAND.md` is missing and provide minimal universal defaults for common brand consistency concerns.

## Scope

User-facing content and presentation:
- UI components and styling
- Documentation and README files
- Error messages and user notifications
- HTML email templates
- Marketing pages and landing pages
- CLI output (help text, error messages)

NOT covered:
- Internal code comments or developer documentation
- Log messages (not user-facing)
- Test fixtures

## Control Families (5 sections)

### 1. Brand File Requirement
- The repository MUST contain `docs/BRAND.md` defining brand standards
- If `docs/BRAND.md` is missing, WARN on every user-facing content change
- BRAND.md should define at minimum: color palette (with hex/RGB values), typography, voice/tone guidelines, logo usage rules, approved terminology

### 2. Voice and Tone
- Follow the voice and tone guidelines defined in `docs/BRAND.md`
- Universal fallback: clear, professional, consistent, free of jargon
- Error messages must be helpful, not blaming — describe what happened and what the user can do
- Use consistent terminology throughout — don't mix synonyms for the same concept

### 3. Visual Identity
- Reference `docs/BRAND.md` for color palette, typography, and spacing
- Use design tokens or CSS custom properties for brand colors — never hardcode hex values in components
- Logo usage must follow brand guidelines (minimum size, clear space, approved variations)

### 4. Terminology and Naming
- Use the approved terminology list from `docs/BRAND.md`
- Product names, feature names, and UI labels must be consistent across all surfaces
- Capitalization, hyphenation, and abbreviation must follow the terminology guide

### 5. Consistency Across Surfaces
- Error messages, button labels, navigation items, and headings must use consistent language
- Date, time, number, and currency formatting must follow a single convention (defined in BRAND.md)
- Tone must be consistent across UI, documentation, and error states

## Style Notes

- ⛔/✅ format, imperative voice
- 5 sections — this is a lighter file since specifics live in BRAND.md
- Key rule: Copilot must READ `docs/BRAND.md` when making brand-related decisions — the instruction file teaches it to look there
- Target ~35-45 lines of rules
