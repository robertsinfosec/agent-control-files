---
generates: .github/instructions/testing-standards.instructions.md
---

/create-instruction testing-standards.instructions.md

# Testing Standards — Generation Prompt

You are generating a Copilot instruction file that enforces consistent, reliable, and valuable testing practices. This file covers test design, structure, and strategy — not specific framework configuration (that belongs in stack-standards).

## References

- **Martin Fowler's Test Pyramid**: Unit tests as the broad base, integration in the middle, E2E at the top
- **Kent Beck — TDD By Example**: Arrange-Act-Assert structure, test-driven design
- **Gerard Meszaros — xUnit Test Patterns**: Test double taxonomy (stub, mock, fake, spy), test isolation
- **ISTQB Foundation Syllabus**: Test levels, test types, coverage concepts
- **Google Testing Blog / Testing on the Toilet**: Practical test design patterns
- **OWASP Testing Guide**: Security-focused test cases (cross-ref security-standards)

## Scope

Universal testing principles applicable across all languages and frameworks:

- Test structure and naming
- Unit test design (isolation, determinism, speed)
- Integration test boundaries and strategy
- Test double usage (when to mock, when not to)
- Edge cases, error paths, and boundary conditions
- Coverage: what to measure, what targets are useful
- CI integration and test reliability
- What NOT to test (trivial getters, framework internals, third-party code)

Explicitly NOT covered:
- Framework-specific test configuration (Jest, pytest, JUnit, etc.) → stack-standards
- Security-specific test cases → security-standards
- Performance/load testing → separate concern

## Critical LLM Failure Modes

### Test structure
- Tests that assert on implementation details (mock call counts, internal state) instead of behavior
- Tests tightly coupled to production code structure — break when code is refactored without behavior change
- Tests that test the mocking framework rather than the code under test
- Missing Arrange-Act-Assert separation — setup, action, and assertion tangled together
- Test names that describe implementation (`testMethodX`) instead of behavior (`rejects_expired_tokens`)

### Test isolation
- Tests that depend on execution order — pass in sequence, fail in isolation
- Shared mutable state between tests (global variables, database state, filesystem)
- Tests that make real network calls, hit real databases, or read real filesystems without explicit integration test marking
- Time-dependent tests that fail on different dates or timezones

### Test value
- Testing trivial code (getters, setters, data classes with no logic)
- Testing framework internals or third-party library behavior
- Happy-path-only testing — no error paths, no edge cases, no boundary values
- Snapshot tests on large structures that change frequently (snapshot fatigue → auto-update → no value)
- Excessive mocking that makes tests pass regardless of real behavior

### Coverage gaming
- Chasing line coverage percentage with low-value tests
- Testing generated code, configuration files, or type definitions to inflate numbers
- No coverage on the code that actually matters (business logic, error handling, security paths)

### CI reliability
- Flaky tests left in the suite (intermittent failures erode trust)
- Slow test suites that block CI pipelines
- Tests that pass locally but fail in CI due to environment dependencies

## Control Families (8 sections)

### 1. Test Structure
- Arrange-Act-Assert (or Given-When-Then) — clear separation
- One logical assertion per test (multiple physical asserts of the same concept are fine)
- Tests must be independent — no execution order dependency

### 2. Test Naming
- Names describe behavior and expected outcome, not implementation
- Pattern: `[unit]_[scenario]_[expected_result]` or natural language equivalent
- Names must make failures self-diagnosing without reading the test body

### 3. Unit Tests
- Test behavior through public interfaces, not internal implementation
- Deterministic — same input always produces same output
- Fast — individual unit tests should complete in milliseconds
- Isolated from external systems (network, database, filesystem)

### 4. Integration Tests
- Explicitly mark integration tests — they run in a separate CI stage or suite
- Test real boundaries: database queries, HTTP calls, file I/O, message queues
- Use test containers, in-memory databases, or fixtures — not production services
- Clean up test data — don't leak state between test runs

### 5. Test Doubles (Mocks, Stubs, Fakes)
- Prefer fakes and stubs over mocks when possible — they test behavior, not interaction
- Mock at architectural boundaries (external services, I/O), not between internal modules
- Never mock the thing you're testing
- If a test requires more than 3 mocks, the code under test likely needs refactoring

### 6. Edge Cases and Error Paths
- Test boundary values: zero, one, max, empty, null, negative
- Test error/exception paths — not just happy paths
- Test invalid inputs, unauthorized access, timeout scenarios
- Test concurrency scenarios where applicable

### 7. Coverage
- Measure branch coverage, not just line coverage
- Coverage is a useful signal for finding untested code — it is NOT a quality metric
- Cover business logic, error handling, and security-sensitive paths first
- Don't test generated code, type definitions, or trivial data structures to inflate percentage

### 8. CI Integration and Reliability
- All tests must run in CI on every PR — failing tests block merge
- Quarantine flaky tests immediately — fix or remove within a defined timeframe
- Separate unit and integration test stages for fast feedback
- Test suite must complete within a reasonable time bound

## Style Notes

- ⛔/✅ format, imperative voice, no hedging
- 8 sections
- No framework-specific syntax — rules must apply to any language/framework
- Target ~65-80 lines of rules
