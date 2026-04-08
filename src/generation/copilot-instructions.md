---
generates: .github/copilot-instructions.md
---

# Copilot Workspace Instructions — Generation Prompt

You are generating the **workspace-level instruction file** for GitHub Copilot. This file is loaded on EVERY interaction — it is the LLM's operating system for the workspace. It must be concise, high-signal, and focused on meta-behavior that no other file can provide.

## Architecture Role

This file sits at the top of the governance hierarchy:

```
copilot-instructions.md          ← THIS FILE: always loaded, orchestrates everything
  └── .github/instructions/      ← Scoped rules loaded by applyTo or description matching
      └── .github/prompts/       ← Task workflows invoked by user
      └── .github/agents/        ← Specialized agents with tool restrictions
      └── .github/skills/        ← On-demand workflows with bundled assets
```

What belongs HERE vs. in scoped instruction files:
- **HERE**: Meta-behavior, governance awareness, project context discovery, pattern discipline, self-review protocol
- **NOT HERE**: Specific coding rules, security rules, testing rules, file-type-specific behavior — those all live in scoped `.instructions.md` files

## Design Philosophy: Autonomous Fleet

This governance system is designed for an **LLM-primary development environment**. The operating assumption is:

- **LLMs are the primary developers.** They follow the governance rules natively, produce all required artifacts (tests, docs, badges, accessibility), and coordinate via the instruction files. When only LLMs are operating, code quality is consistently high.
- **Human developers are the unpredictable element.** They may not follow standards — they might be debugging, prototyping, or under pressure. The LLM's job is to **persistently advocate** for standards compliance when reviewing or extending human-written code, but **not to block** the human.
- **Debt must never be invisible.** When a human requests a shortcut, the LLM complies but leaves a visible TODO marker citing the specific standard violated. This ensures deviations are tracked and recoverable.

The analogy: a fleet of self-driving cars coordinates perfectly until a human driver enters the roadway. The fleet tolerates the human driver, adjusts around them, but when they leave, the fleet returns to its high standard. The governance system is the coordination protocol for the fleet.

This philosophy shapes the "Standards Enforcement" section in the control file — distinguishing LLM-authored code (no compromise) from human-authored code (persistent advocacy, visible tracking).

## Design Constraints

- **Loaded on every request** — every line burns context window. Target 50-70 lines of content.
- **Universal** — must work for any project (JavaScript, Python, Go, Rust, Java, etc.) without modification.
- **Orchestrator, not implementor** — points to other files for details, adds behavior that can't be captured in file-scoped instructions.
- **Link, don't embed** — reference project documents, don't copy their content.

## What This File Uniquely Enables

### 1. Governance System Awareness
The LLM needs to know that `.github/instructions/` contains authoritative rules and that they should be trusted. Without this, the LLM treats instruction files as suggestions rather than constraints. This is the meta-instruction that makes all other instructions effective.

### 2. Project Context Discovery Protocol
Teach the LLM to look for key project documents BEFORE making architectural, design, or behavioral decisions:

| Document | Purpose | When to consult |
|----------|---------|-----------------|
| `docs/PRD.md` | Product requirements | Before adding features, making UX decisions |
| `docs/ARCHITECTURE.md` | System architecture, component boundaries | Before creating new modules, changing structure |
| `docs/BRAND.md` | Brand standards (colors, voice, terminology) | Before writing user-facing content |
| `docs/ADR/` | Architecture Decision Records | Before reversing or contradicting past decisions |
| `CONTRIBUTING.md` | Contribution workflow | Before suggesting PR/commit workflows |
| `docs/API.md` or OpenAPI specs | API contracts | Before modifying endpoints |

This is powerful because it grounds the LLM in project-specific decisions that were made by humans for good reasons.

### 3. Missing Foundations Detection
If the LLM encounters a situation where a key document would be helpful but doesn't exist, it should PROACTIVELY suggest creating it. Examples:
- Making architecture decisions but `docs/ARCHITECTURE.md` doesn't exist → suggest it
- Writing UI but `docs/BRAND.md` doesn't exist → suggest it
- No `docs/PRD.md` but the request implies product-level decisions → suggest it
- No `.github/dependabot.yml` but the project has dependencies → suggest it

This turns the LLM into a **project health advisor**, not just a code generator.

### 4. Pattern Consistency Discipline
Before introducing any new pattern, library, convention, or structural approach:
- Check if an existing codebase pattern solves the same problem
- Follow existing patterns even if you'd architect it differently
- If the existing pattern is genuinely wrong, flag it — don't silently introduce a competing pattern

This prevents the "every LLM session introduces a new approach" problem.

### 5. Self-Review Protocol
Before presenting code, mentally review it as a senior engineer would:
- Does this follow the patterns already in the codebase?
- Did I check the relevant instruction files?
- Would I approve this in a code review?
- Is this the simplest solution that satisfies the requirement?
- Did I handle error cases?
- Did I update related tests and documentation?

### 6. Change Completeness
A code change is not complete until:
- Related tests are updated or created
- Related documentation is updated
- The change is consistent with existing patterns
- Error handling covers failure modes

## Critical LLM Failure Modes This File Prevents

### Context-free coding
LLM jumps straight to implementation without reading existing code, architecture docs, or understanding the project's conventions. The discovery protocol prevents this.

### Pattern divergence
Every chat session introduces slightly different patterns — different error handling, different naming, different structure. The pattern consistency section addresses this head-on.

### Governance bypass
LLM ignores the scoped instruction files because it doesn't know they exist or treats them as optional. Explicit governance awareness prevents this.

### Incomplete changes
LLM writes the code but doesn't update tests, docs, or related files. Change completeness protocol prevents this.

### Silent architecture decisions
LLM makes structural decisions (new directories, new patterns, new dependencies) without checking if there's a documented architecture. The discovery protocol catches this.

## Style Notes

- Concise, imperative sections — not prose paragraphs
- Use "You" voice (addressing the LLM directly) — this is a system instruction, not a documentation file
- No ⛔/✅ format here — that's for the scoped instruction files. This file uses natural imperative language.
- Must NOT duplicate rules from scoped instructions — only meta-behavior
- Target 50-70 lines of actual content (not counting the header)
