---
generates: .github/prompts/detect-stack.prompt.md
---

/create-prompt detect-stack.prompt.md

# Detect Stack — Generation Prompt

This prompt scans the repository for technologies, researches current best practices for each one, and generates `stack-standards.instructions.md` with tech-specific coding conventions.

## Design Intent

`coding-standards.instructions.md` is universal — simplicity, modularity, error handling, etc. But every stack has its own idioms: Go's error handling, React's hooks rules, Python's PEP-8. These stack-specific rules belong in `stack-standards.instructions.md`, which this prompt generates.

The key insight: the LLM executing `/detect-stack` already has extensive training data on technology best practices. It also has web search capability. The prompt should instruct the LLM to **use both** to produce high-quality, current best practices — not just parrot a static checklist.

## Architecture

1. User runs `/detect-stack` in chat
2. **Phase 1 — Detection**: Scan for manifests, configs, and framework files. Note exact versions.
3. **Phase 2 — Research**: For each detected technology, the LLM synthesizes best practices from its training data and verifies/updates them via web search. This is where the substance comes from.
4. **Phase 3 — Generation**: Write `.github/instructions/stack-standards.instructions.md` with the researched best practices in ⛔/✅ format.
5. The user re-runs `/detect-stack` whenever the stack changes or wants to refresh best practices.

## Why Research Matters

Best practices are not static. Examples of things that changed:
- React 19 introduced Server Components as default — the "best practice" for component architecture changed fundamentally
- Next.js App Router replaced Pages Router — file conventions, data fetching patterns, and caching behavior all changed
- Python 3.12+ introduced new type syntax (`type` statement) — type annotation best practices shifted
- Tailwind CSS v4 changed configuration from `tailwind.config.js` to CSS-based config
- ESLint flat config replaced `.eslintrc` — configuration best practices changed

A static list of rules goes stale. The research phase ensures the output reflects the **detected version**, not generic advice.

## Research Strategy

The prompt instructs the LLM to:
1. Start with training data (deep knowledge of established conventions)
2. Use web search to verify currency and catch post-training changes
3. Prioritize authoritative sources (official docs > community guides > blog posts)
4. Note version-specific differences where they matter
5. Focus on: idioms, conventions, pitfalls, security, performance, and tooling

## Detection Signals

Scan in priority order:
1. **Package manifests** — definitive signals (package.json, go.mod, Cargo.toml, etc.)
2. **Framework config files** — strong signals (next.config.*, vite.config.*, etc.)
3. **Tool config files** — supporting signals (.eslintrc*, .prettierrc*, tsconfig.json, etc.)
4. **Import patterns in source** — weak signals (only if manifests/configs are insufficient)

Version detection is critical — best practices vary significantly between major versions.

## Output Constraints

- Same ⛔/✅ format as all instruction files
- Only rules that ADD to or DIFFER FROM coding-standards.instructions.md
- 5-15 rules per technology, prioritized by impact
- HTML comments citing sources for traceability
- Specific and actionable rules — never vague
- Target ~60-100 lines total (if more, consider splitting into per-tech instruction files with scoped `applyTo`)

## Tools Required

- `read` + `search`: Detect technologies from files
- `execute`: Run package manager commands to check versions
- `web`: Research current best practices and verify training data currency
