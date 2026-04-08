---
generates: .github/instructions/stack-standards.instructions.md
---

/create-instruction stack-standards.instructions.md

# Stack Standards — Generation Prompt

This file is NOT authored by an SME. It is **dynamically generated** by the `/detect-stack` prompt, which scans the repository for package managers, config files, frameworks, and tools, then produces a `stack-standards.instructions.md` file with tech-specific conventions.

## Architecture

- `coding-standards.instructions.md` contains universal engineering principles (simplicity, modularity, contracts, etc.)
- `stack-standards.instructions.md` (this file's output) contains stack-specific idioms that complement those universals
- The two files together provide complete coding governance without overlapping

## What detect-stack Generates

For each detected technology, the output should include:
- Language-specific idioms and conventions (Go error handling, Python PEP-8, Rust ownership patterns, etc.)
- Framework conventions (React hooks rules, Express middleware patterns, Django model conventions, etc.)
- Tool configuration expectations (ESLint, Prettier, Black, rustfmt, etc.)
- Testing framework conventions (Jest, pytest, Go testing, etc.)
- Package manager conventions (npm vs yarn vs pnpm, pip vs poetry, etc.)

## Format

Same ⛔/✅ format as other instruction files. Organized by technology, each as a top-level section.

## Key Constraint

This file has `applyTo: "**"` because the detected stack applies broadly. The file should stay concise — only rules that differ from or extend the universal coding-standards. If it grows beyond ~100 lines, that's a signal to split into per-technology instruction files with scoped `applyTo`.
