---
generates: .github/instructions/coding-standards.instructions.md
---

/create-instruction coding-standards.instructions.md

# Coding Standards — Generation Prompt

You are generating a Copilot instruction file that enforces universal software engineering and design principles across ALL code in a workspace. It uses `applyTo: "**"` so it loads into every Copilot interaction — be concise, prescriptive, and dense. Every line must earn its context tokens.

## Scope Boundaries

This file covers **universal principles that apply to any language, framework, or artifact type** — Python, Go, TypeScript, C#, Rust, bash, Terraform, Ansible, libraries, CLIs, daemons, Lambdas, automation scripts, everything.

**NOT in scope** (handled by other instruction files):
- Stack-specific rules (React hooks, PEP-8, Go formatting, Redis patterns, Terraform module structure) → `stack-standards.instructions.md`
- Security controls (auth, input validation, crypto, secrets, SSRF, supply chain) → `security-standards.instructions.md`
- Testing strategy (coverage, test structure, test isolation) → `testing-standards.instructions.md`
- API design (REST conventions, versioning, pagination) → `api-design.instructions.md`
- Database concerns (migrations, encryption at rest, RLS) → `database-safety.instructions.md`

## Seven Universal Outcomes

Every rule in this file should serve at least one of these outcomes:

1. **Simplicity** — the simplest design that satisfies the requirement
2. **Clear boundaries** — between components, layers, concerns, and responsibilities
3. **Explicit contracts** — inputs, outputs, invariants, and assumptions are visible
4. **Controlled state and side effects** — mutation is localized, side effects are isolated
5. **Predictable failure behavior** — errors are explicit, contextual, and consistent
6. **Diagnosable runtime behavior** — you can understand what happened and why from the output
7. **Safe change over time** — refactors preserve semantics, breaking changes are visible

## Control Families

Organize the output into these 14 sections. Each section should have 2-5 ✅ rules and 1-3 ⛔ prohibitions. Use imperative voice — no hedging, no "consider," no "where appropriate."

### 1. Simplicity and Clarity
This is FIRST for a reason. LLMs naturally over-engineer — add indirection, wrappers, abstractions, patterns. This section is the primary brake.
- Choose simplest design that satisfies the requirement
- Optimize for clarity and predictability over cleverness
- Straightforward control flow, easy to trace
- No unnecessary indirection, abstraction, or genericity
- No hiding critical behavior behind surprising side effects or non-obvious execution paths
- Reduce branching depth and hidden behavior

### 2. Modularity and Separation of Concerns
- Small, focused units with single clear responsibility
- Business logic, orchestration, I/O, persistence, presentation, environment concerns separated
- Clear boundaries between components and layers
- No combining unrelated responsibilities in same unit
- No cross-layer leakage coupling core logic to delivery/storage/infrastructure

### 3. Dependency Boundaries
NOT "dependency injection" — that's too OO-specific. The universal principle is explicit dependencies and replaceable boundaries.
- Dependencies explicit
- External systems, frameworks, tools isolated behind clear boundaries
- Program against stable contracts and replaceable interfaces native to the stack
- No hard-wiring business logic to specific infra, vendor APIs, global state, or process environment
- No hidden dependencies through ambient context, implicit globals, non-local side effects

### 4. Data Contracts and Type Discipline
Not just API design — internal code quality too.
- Inputs, outputs, invariants, assumptions explicit
- Prefer strongly defined structures, types, schemas over loosely shaped data
- Validate at boundaries, normalize before core processing
- No overloading one structure/field/parameter with multiple unrelated meanings
- No passing opaque, weakly defined data through multiple layers when a domain model can be defined

### 5. State and Side-Effect Control
Broader than just "prefer immutability."
- Minimize mutable state
- State transitions explicit and localized
- Side effects isolated from pure decision logic and data transformation
- Prefer immutable values, readonly references, pure functions when supported
- No spreading shared mutable state across unrelated components
- No mixing mutation, I/O, and business rules in ways that make behavior hard to reason about

### 6. Naming and Readability
- Names reveal purpose, scope, and behavior
- Consistent conventions within codebase
- Readable without tribal knowledge
- No misleading, overloaded, vague, or throwaway names
- No hidden assumptions encoded in abbreviations, magic values, undocumented conventions

### 7. Duplication and Abstraction Discipline
NOT "DRY after 3 repetitions" — that's a gameable heuristic.
- Eliminate repeated logic that creates maintenance risk
- Extract shared behavior only when abstraction is clearer AND more stable than duplication
- Keep abstractions narrow, purposeful, easy to understand
- No speculative abstractions for hypothetical future needs

### 8. Configuration and Environment Isolation
- Environment-specific behavior in configuration, not business logic
- Centralize configuration access, validate at startup/entry
- Named constants or explicit configuration replace magic numbers and hidden defaults
- No hardcoded deploy-time values, endpoints, ports, flags in core logic
- No scattered configuration lookup across codebase

### 9. Error and Failure Semantics
Broader than "meaningful error messages." Security-related error handling is in security-standards — this covers the engineering discipline.
- Handle expected failure modes explicitly
- Propagate errors with actionable context for developers and operators
- Structured error types, result models, or failure mechanisms native to the stack
- Consistent failure behavior within a component
- No swallowed errors, ignored return values, or continuing after invalid state
- No stringly-typed error handling when stack supports structured alternatives
- Fail fast on invalid internal state

### 10. Diagnostics and Observability
Universal framing — not just "health checks and metrics" which doesn't apply to scripts/libraries.
- Runtime behavior diagnosable
- Structured diagnostics through standard platform mechanisms
- Enough context to trace execution, decisions, and failures
- Meaningful operational signals at component boundaries and critical paths
- No silent branches, implicit retries, opaque background work
- No context-free or operationally useless diagnostics

### 11. Code Hygiene and Lifecycle Discipline
- Remove dead code, obsolete branches, stale feature paths, unused dependencies
- Warnings, suppressions, ignores: explicit, minimal, justified
- Deferred work tracked in the project's system of record (not TODO comments without linked issues)
- Leave codebase clearer than you found it
- No commented-out code — that's what version control is for
- No suppressed warnings/lint/static analysis without documented reason

### 12. Resource and Concurrency Discipline
Every codebase consumes resources, even if not all are concurrent.
- Bound resource usage explicitly
- Acquire and release resources predictably
- Concurrency, parallelism, retries, scheduling explicit
- Loops, tasks, background work designed to terminate, back off, or fail safely
- No unbounded work, retries, memory, file, connection, or queue growth
- No leaked resources, locks, handles, tasks, temporary artifacts

### 13. Change Safety and Compatibility
Maintainability control — not just API versioning.
- Preserve existing behavior unless change is intentional and explicit
- Breaking changes visible in code, review, and documentation
- Migrations, transitions, compatibility boundaries explicit
- Refactor in ways that preserve semantics
- No silent behavioral drift during cleanup, optimization, or abstraction work
- No changing public/shared/downstream behavior without updating contract and migration path

### 14. Documentation of Intent
Code-level only — not broad documentation strategy.
- Document non-obvious constraints, invariants, tradeoffs, edge cases
- Comments explain why, not what
- Entry points, extension points, public contracts discoverable
- No comments that merely restate the code
- No undocumented complex behavior, hidden assumptions, or important limitations

## Style Notes

- ⛔ for absolute prohibitions, ✅ for required practices
- No numeric heuristics that the LLM can game ("no 500-line functions", "extract after 3 repetitions") — use the principle instead
- No stack-specific pattern names (DI, interfaces, health checks) — use universal principle language (explicit dependencies, replaceable boundaries, diagnosable behavior, stable contracts)
- Each section should open with 2-4 ✅ affirmative rules, then 1-2 ⛔ prohibitions
- Target ~100-120 lines of rules total — this is the second-most-loaded file after security-standards
