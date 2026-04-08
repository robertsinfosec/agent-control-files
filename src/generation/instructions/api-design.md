---
generates: .github/instructions/api-design.instructions.md
---

/create-instruction api-design.instructions.md

# API Design — Generation Prompt

You are generating a Copilot instruction file that enforces consistent, predictable, and well-documented API design. This file focuses on design patterns and developer experience — the security aspects (authentication, authorization, input validation, rate limiting) are covered by `security-standards.instructions.md` and cross-referenced, not duplicated.

## Standards and References

- **RFC 9110** (HTTP Semantics): Definitive reference for HTTP methods, status codes, content negotiation
- **RFC 9457** (Problem Details for HTTP APIs): Structured error response format (supersedes RFC 7807)
- **OpenAPI Specification 3.1**: API contract definition standard
- **OWASP API Security Top 10 (2023)**: API-specific attack surface — cross-referenced, security rules live in security-standards
- **JSON:API**: Optional structured response convention — referenced but not mandated (org may use different conventions)
- **REST Architectural Constraints**: Uniform interface, statelessness, resource-oriented design
- **Google API Design Guide, Microsoft REST API Guidelines**: Industry design guidance

## Scope

API design patterns for HTTP/REST APIs. Covers:

- Resource naming and URL structure
- HTTP method semantics and status codes
- Request/response format consistency
- Error responses (structured, machine-readable)
- Versioning strategy
- Pagination for collection endpoints
- Idempotency and retry safety
- API documentation and contracts

Explicitly NOT covered here (covered elsewhere):
- Authentication/authorization mechanics → security-standards
- Input validation and sanitization → security-standards
- Rate limiting implementation → security-standards
- GraphQL-specific rules (could be a separate file if org uses GraphQL heavily)

## Critical LLM Failure Modes

### URL and resource naming
- Verb-based URLs (`/getUsers`, `/createOrder`) instead of resource nouns
- Inconsistent pluralization (`/user/1` vs `/orders`)
- Action endpoints that should be state transitions on resources
- Deeply nested URLs beyond 2 levels (`/orgs/1/teams/2/members/3/roles`)

### HTTP method misuse
- Using GET for operations with side effects
- Using POST for everything instead of appropriate methods (PUT, PATCH, DELETE)
- DELETE returning 200 with a body instead of 204 No Content
- PUT used for partial updates instead of PATCH
- Missing 201 Created for successful POST that creates a resource

### Error handling
- Returning 200 OK with `{ "error": "..." }` in the body
- Inconsistent error response shapes across endpoints
- Exposing stack traces, internal paths, or implementation details in error responses
- Generic 500 for all server errors with no structured detail
- Missing `Content-Type: application/problem+json` for error responses

### Pagination
- Returning unbounded collections without pagination
- Offset-based pagination on large datasets (performance cliff)
- Missing pagination metadata (total count, next/prev links)
- Inconsistent pagination parameter names across endpoints

### Versioning
- No versioning strategy at all
- Breaking changes without version bump
- Version in request body instead of URL path or header

### Documentation
- Endpoints without OpenAPI/Swagger definitions
- Request/response examples that don't match the actual schema
- Missing description of error responses and status codes

## Control Families (8 sections)

### 1. Resource Naming and URL Structure
- Plural nouns for collections, singular identifiers for resources
- Kebab-case for multi-word segments
- Maximum 2 levels of nesting — flatten with query parameters or top-level resources
- Consistent patterns across all endpoints

### 2. HTTP Methods and Status Codes
- GET: read-only, cacheable, no side effects
- POST: create resource → 201 with Location header
- PUT: full resource replacement → 200 or 204
- PATCH: partial update → 200
- DELETE: remove resource → 204 No Content
- Return appropriate status codes: 2xx success, 4xx client error, 5xx server error
- Use 404 Not Found, 409 Conflict, 422 Unprocessable Entity where semantically correct

### 3. Request and Response Format
- Consistent envelope or flat structure across all endpoints (pick one, enforce it)
- camelCase for JSON property names (unless org standard differs)
- ISO 8601 for dates and timestamps, always with timezone
- Consistent null handling — decide between null, omitting the field, or empty value

### 4. Error Responses
- Follow RFC 9457 Problem Details structure: `type`, `title`, `status`, `detail`, `instance`
- Return `Content-Type: application/problem+json` for errors
- Include validation errors as an array with field-level detail
- Never expose stack traces, internal paths, or infrastructure details

### 5. Versioning
- Version all APIs from the start — default is URL path prefix (`/v1/`)
- Semantic meaning: increment major version only for breaking changes
- Support at most N and N-1 simultaneously — document sunset timeline

### 6. Pagination
- All collection endpoints must support pagination — never return unbounded results
- Default page size with configurable limit (with a maximum cap)
- Prefer cursor-based pagination for large or frequently-changing datasets
- Include pagination metadata: total count (when feasible), next/previous links

### 7. Idempotency and Retry Safety
- GET, PUT, DELETE must be idempotent
- POST endpoints that create resources should support idempotency keys (Idempotency-Key header) for safe client retries
- Document which endpoints are safe to retry

### 8. API Documentation and Contracts
- Every endpoint must have an OpenAPI 3.x definition
- Include request/response examples and all possible status codes
- Keep OpenAPI spec in sync with implementation — generate from code or validate in CI

## Style Notes

- ⛔/✅ format, imperative voice, no hedging
- 8 sections, design-pattern-oriented
- HTML comments for traceability: `<!-- RFC: 9457 | OWASP-API: API1 -->`
- Cross-references security-standards for auth, validation, rate limiting — no duplication
- Target ~70-85 lines of rules
