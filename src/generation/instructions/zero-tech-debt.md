---
generates: .github/instructions/zero-tech-debt.instructions.md
---

/create-instruction zero-tech-debt.instructions.md

# Zero Technical Debt — Generation Prompt

You are generating a Copilot instruction file that enforces a zero-tolerance policy for technical debt accumulation. It uses `applyTo: "**"` so it loads into every interaction — but this is a POLICY file, not a technical tutorial. Keep it short, sharp, and gate-shaped.

## Framing: Debt Admission Control

This file is NOT about how to write clean code (that's `coding-standards.instructions.md`). This file defines:

- What counts as **making the codebase worse**
- What counts as **deferred rework**
- What must happen when debt **cannot be avoided**

Think of it as a **debt firewall**: every change must pass through it, and no change may introduce untracked, unowned, or unbounded maintenance liability.

The litmus test for whether a rule belongs here vs. in `coding-standards`:
- If the rule is about **code quality in general** → `coding-standards`
- If the rule is about **whether a change is allowed to leave behind deferred cost, inconsistency, or cleanup liability** → this file

## Conceptual Anchors

Reference these in the generation file for traceability, but do NOT overload the control file with framework citations:

- **SEI Technical Debt Work**: Technical debt as principal/interest — debt can reside in code, tests, documentation, and infrastructure. Debt must be inventoried, assessed, and managed, not ignored.
- **Fowler/Cunningham Technical Debt Metaphor**: Not all debt is equal — Fowler's Technical Debt Quadrant (deliberate vs. inadvertent, prudent vs. reckless). Even "prudent" debt requires deliberate tracking and repayment planning.
- **ISO/IEC 25010 Maintainability**: Ties maintainability to modularity, analysability, modifiability, and testability. Justifies why debt governance exists — it protects the quality characteristics that make software changeable.

## Debt Categories to Cover

### 1. No Net-New Debt
Core principle. Every touched area must be left equal to or better. Reduce existing debt when working in debt-heavy code. No shortcuts, placeholders, or structural degradation with "fix later" expectations. No local changes that increase future maintenance cost.

### 2. No Deferred Cleanup
Complete cleanup, renaming, simplification, consistency fixes required by the change before it's done. No "follow-up PR" promises. No partially updated code paths, stale branches, half-finished refactors.

### 3. No Untracked Temporary Code
Every temporary workaround, TODO, FIXME, compatibility shim, fallback path, and migration helper must be tracked with: owner, rationale, removal condition. No unlinked TODOs. No "temporary" code with no accountable path to removal.

### 4. No Incomplete Migrations
This is one of the biggest LLM-introduced debt patterns. Models introduce new patterns without fully removing old ones, leaving:
- Mixed calling conventions, error models, config styles, logging styles
- Mixed dependency patterns, naming schemes, helper utilities
- Two competing ways to solve the same problem

Rules: Complete migrations within the scope or explicitly track them. Remove superseded patterns when introducing replacements. No split-brain states.

### 5. No Suppression-Based Progress
LLMs and humans both do this — suppress warnings, skip tests, ignore lint, bypass policy checks to make a change "work." That's hidden debt.
- Resolve warnings, failing checks, deprecated usage introduced by the change
- Treat all suppressions as debt requiring tracking and expiry
- No disabled tests, no ignored failures, no bypass flags without remediation or tracked retirement

### 6. No Stale Artifacts
Documentation is an artifact where debt resides (SEI). When behavior changes:
- Update docs, examples, comments, generated outputs, config references, migration notes
- Remove dead code, dead flags, unused dependencies, obsolete documentation
- No stale artifacts retained after their purpose has ended

### 7. No Inconsistency Expansion
LLMs often solve local problems by introducing one-off patterns in a mature codebase. That's debt even if the code "works."
- Reuse established project patterns when valid
- Improve consistency in touched areas
- No one-off patterns, helper styles, naming schemes that increase divergence

### 8. Debt Exceptions Must Be Explicit
A zero-debt policy without an exception mechanism encourages dishonesty. The rule is:
- Debt is not allowed by default
- If unavoidable: tracked, owned, scoped, justified, time-bounded, and removable
- Hidden debt is worse than admitted debt
- Known debt is never acceptable merely because it's common, inherited, or inconvenient

## Style Notes

- This should be **one of the shortest `applyTo: "**"` files** — policy overlay, not technical tutorial
- 1-paragraph core principle at the top, then 8 tight sections
- Very few rules per section — almost all framed as **merge-blockers**, not best practices
- ⛔/✅ format, imperative voice
- No overlap with `coding-standards` engineering practices — this is governance, not guidance
- Target ~50-60 lines of rules total
