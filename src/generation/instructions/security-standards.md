---
generates: .github/instructions/security-standards.instructions.md
---

/create-instruction security-standards.instructions.md

# Security Standards — Generation Prompt

You are generating a Copilot instruction file that enforces security engineering standards across ALL code in a workspace. It uses `applyTo: "**"` so it loads into every Copilot interaction — be concise, prescriptive, and dense. Every line must earn its context tokens.

## Framework Hierarchy

Do NOT organize the output by framework. Organize by developer activity. Use this hierarchy to inform the RULES, not the STRUCTURE:

- **OWASP ASVS (v5)**: The primary app-level control baseline. "What must the application do?" Use this as the source of truth for concrete verification requirements across auth, session, access control, input, crypto, files, API, config, logging, and error handling.
- **NIST SP 800-218 (SSDF)**: The SDLC/process baseline. "How do we build and maintain securely?" Covers secure design practices, build integrity, vulnerability response, and software lifecycle controls. More developer-workflow-relevant than 800-53 for code-level instructions.
- **SLSA (v1.0)**: Build pipeline and artifact integrity. "Can we trust the build and the artifact?" Covers provenance, tamper resistance, and supply chain trust.
- **CWE Top 25**: Weakness reality check. "What classes of implementation mistakes keep recurring?" Use as a sanity check that the rules address the weakness classes that actually get exploited — injection, auth bypass, memory corruption, path traversal, etc.
- **OWASP Top 10 (2021) + API Security Top 10 (2023)**: Risk catalogs — useful for ensuring coverage of common attack scenarios but NOT sufficient as a control framework. Rules should address these risks but be anchored to ASVS controls.
- **OWASP Proactive Controls (2024)**: Developer-facing best-practice techniques. Use to validate that the instruction covers what OWASP says every developer should know.
- **NIST SP 800-53**: Enterprise governance overlay. Reference control family IDs (AC, AU, IA, SC, SI) in traceability comments for organizations that need to map to compliance frameworks. Do NOT use as the primary source — it's written for system administrators, not developers.
- **CISA Secure by Design**: Reframes security as a producer responsibility. Emphasizes safe defaults, reduced attack surface, transparency. Informs the "Secure Configuration" and "AI-Generated Code" sections.

## Control Families to Cover

Organize by what the developer is DOING, not by framework category numbers:

### 1. Input Handling & Injection Prevention
- All external input is untrusted. Validate at trust boundaries with allowlists (type, length, range, pattern, schema). Canonicalize before validation.
- Parameterized queries, safe APIs, structured interfaces ONLY — never string concatenation into SQL, NoSQL, LDAP, shell, XPath, templates, or interpreters.
- No dynamic execution features (eval, exec, Function constructor, template injection) unless explicitly justified.
- Reject malformed, ambiguous, or unexpected input. Denylists are always incomplete.
- No deserialization of untrusted data without schema validation and type constraints.
- Enforce request size limits.
- ASVS: V5 (Validation), CWE: 78, 79, 89, 94, 502

### 2. Authentication & Session Management
- No custom authentication implementations unless approved. Use established identity providers and libraries.
- Server-side identity verification for every protected operation.
- Adaptive hashing ONLY for passwords: bcrypt, Argon2id, scrypt. Name the algorithms — "approved" without specifics is unenforceable.
- Constant-time comparison for secrets and tokens. Session cookies: Secure, HttpOnly, SameSite=Strict.
- Enforce idle and absolute session timeout. Invalidate server-side on logout, password change, privilege change.
- Short-lived credentials > long-lived. Account lockout / progressive delay on repeated failures.
- Never embed credentials in URLs.
- ASVS: V2 (Authentication), V3 (Session), CWE: 287, 384, 613

### 3. Authorization & Access Control
- Default deny. Every resource requires explicit grants. Least privilege for users, services, jobs, components.
- Object-level, function-level, AND field-level access enforcement.
- Separate authentication from authorization — valid identity ≠ permission.
- Admin/privileged functions enforced at middleware, not hidden URLs.
- Separation of duties for sensitive operations (requester ≠ approver).
- Re-authenticate for sensitive operations.
- No reliance on obscurity, client-side checks, or role names alone.
- ASVS: V4 (Access Control), CWE: 862, 863, 639

### 4. Secrets & Credential Management
- Never hardcode secrets in code, tests, docs, examples, logs, or CI configs.
- Secrets only in approved secret management systems (env vars as minimum, vault preferred).
- Rotate on schedule and on suspicion of exposure. Scoped, least-privilege credentials.
- Prefer ephemeral credentials over long-lived static secrets.
- Remove test credentials before merge. Block commits containing secrets.
- Keys stored separately from encrypted data. Support key rotation without data loss.
- ASVS: V2.10 (Service Auth), CWE: 798, 522

### 5. Cryptography & Data Protection
- Use platform/approved cryptographic libraries only. No custom algorithms or protocols.
- Name specific algorithms: AES-256-GCM or ChaCha20-Poly1305 symmetric, RSA-2048+/Ed25519 asymmetric. Ban MD5, SHA1-for-security, DES, 3DES, RC4, ECB.
- TLS 1.2+ mandatory, no exceptions. No sensitive data in query strings.
- Encrypt PII, PHI, financial data, credentials at rest.
- Minimize collection, retention, replication, exposure of sensitive data. Classify data and handle per policy.
- Redact/mask sensitive data in logs, telemetry, traces, errors, debugging output.
- Define retention and deletion behavior.
- Never commit .env, private keys, credential files to version control.
- ASVS: V6 (Cryptography), V8 (Data Protection), CWE: 327, 328, 311

### 6. Output & Response Security
- Context-aware output encoding: HTML entities for HTML, JS escaping for JS, URL encoding for URLs.
- Never reflect user input without encoding.
- Security headers on all responses: CSP, X-Content-Type-Options: nosniff, X-Frame-Options: DENY, HSTS (1yr+, includeSubDomains), Referrer-Policy: strict-origin-when-cross-origin or stricter.
- Strip stack traces, internal paths, debug info from production responses. Generic errors to users, details to server-side logs.
- ASVS: V14 (Configuration), CWE: 79, 116

### 7. API Security
- Auth + authz on every API request. Object-level access validation on every ID parameter.
- Explicit field allowlists for serialization — never expose full objects.
- Rate limiting on all endpoints, stricter on auth + sensitive business endpoints.
- Pagination with enforced max page size. Request size limits.
- Protect business flows (checkout, transfer, registration) against automation.
- Validate all third-party API response data. Never trust external data.
- Version and document all endpoints. Remove deprecated endpoints promptly.
- Strict CORS — never `Access-Control-Allow-Origin: *` with credentials.
- Make idempotency, replay protection, concurrency behavior explicit when relevant.
- ASVS: V13 (API), OWASP API Top 10: API1-API10

### 8. Server-Side Requests
- Allowlist outbound domains/IPs. Block localhost, link-local, cloud metadata (169.254.169.254), internal ranges.
- Only https:// unless explicitly justified. Resolve DNS and verify resolved IP not in blocked range.
- ASVS: V12 (Files & Resources), CWE: 918

### 9. File, Process & System Interaction
- Validate and constrain file paths, filenames, archive contents, upload types.
- Prevent path traversal, archive extraction abuse (zip slip), arbitrary file overwrite.
- Avoid invoking shells unless strictly necessary. Fixed arguments, least privilege for external processes.
- Isolate OS/container/infrastructure interaction code.
- CWE: 22, 73, 434

### 10. Error Handling & Fail-Safe
- Fail closed — security check errors = deny access.
- No silently swallowed security exceptions. Catch specific exceptions, not catch-all.
- No internal implementation details in error responses.
- Handle invalid states, timeouts, dependency failures, partial failures explicitly.
- Assume downstream systems can fail or return malicious/malformed data.
- Clear sensitive data in memory (zero buffers, close connections) in error/finally blocks.
- ASVS: V7 (Error Handling), CWE: 209, 755

### 11. Logging & Auditability
- Log: auth events (success+failure), authz failures, input validation failures, sensitive admin actions, config changes, system errors.
- Never log: passwords, tokens, session IDs, PII, card numbers, keys, raw request/response bodies without redaction.
- Structured JSON: ISO 8601 timestamp, user/session ID, action, resource, outcome, source IP, correlation ID.
- Tamper-evident, append-only where possible. Protect logs from unauthorized access.
- Make security events detectable and actionable by monitoring systems.
- ASVS: V7 (Error & Logging), NIST 800-53: AU-2, AU-3, AU-6

### 12. Secure Configuration & Defaults
- Ship with safest configuration enabled by default.
- Require explicit approval to weaken security settings.
- Disable unused features, protocols, ports, endpoints, accounts, integrations.
- Restrict admin interfaces and debug functionality.
- Externalize security-relevant configuration. Validate on startup. Fail closed on missing/invalid security config.
- CISA Secure by Design, ASVS: V14

### 13. Availability & Resilience
- Timeouts, retries with backoff, circuit breaking, resource limits where appropriate.
- Prevent unbounded memory, CPU, storage, queue, network consumption.
- Protect expensive operations from abuse. Graceful degradation under load/fault.
- DoS considerations are part of normal design, not an afterthought.
- CWE: 400, 770

### 14. Memory Safety & Unsafe Operations
- Prefer memory-safe languages and libraries.
- Minimize unsafe code, native interop, direct memory access, manual buffer management.
- Isolate and justify unsafe operations.
- Validate lengths, offsets, bounds, lifetimes explicitly where safety isn't guaranteed.
- Use compiler/runtime/platform hardening features.
- CWE: 119, 120, 125, 416, 787

### 15. Business Logic & Abuse Resistance
- Identify misuse cases and abuse paths during design and review.
- Protect high-value workflows against fraud, enumeration, replay, race conditions, privilege escalation.
- Enforce workflow invariants server-side. Don't assume users follow intended paths.
- Anti-automation controls where abuse risk exists.
- CWE: 362, 840

### 16. AI-Generated Code
- Treat ALL AI-generated code as untrusted until reviewed.
- Review for: auth, authz, input validation, secrets exposure, insecure dependencies, insecure defaults, logging issues, business logic flaws.
- Reject generated code that bypasses established security patterns or approved libraries.
- Verify against project standards, threat models, and tests.
- Never paste secrets, proprietary source, regulated data, or sensitive production data into prompts unless explicitly approved.
- CISA Secure by Design, NIST SSDF

### 17. Supply Chain & Build Integrity
- Verified, maintained dependencies from approved sources only. Minimize dependency count.
- Pin versions, commit lockfiles, verify checksums/signatures.
- Continuous vulnerability scanning. SBOM generation when required.
- Treat build scripts, CI/CD workflows, plugins, transitive deps as attack surface.
- Peer review for security-relevant changes. Automated security checks in CI/CD.
- Block release on critical security failures unless formally approved.
- Protect build pipelines, runners, secrets, signing. Reproducible builds where feasible.
- Restrict who can approve, merge, tag, publish, deploy. Source-to-artifact traceability.
- Cross-reference sca-scanning.instructions.md and sast-scanning.instructions.md rather than duplicating tooling details.
- SLSA, NIST SSDF, CWE: 829

## Structure and Style

- Organize by DEVELOPER ACTIVITY (the numbered sections above) — developers don't think in framework category numbers.
- Imperative voice. "NEVER do X. ALWAYS do Y." No hedging, no "consider," no "you may want to," no "where appropriate."
- Use ⛔ for absolute prohibitions and ✅ for required practices.
- Include HTML comments mapping rules back to framework IDs for traceability. Use this format: `<!-- ASVS: V5, CWE: 89, OWASP: A03, NIST: SI-10 -->`. Always include ASVS and CWE. Add OWASP Top 10 / API Top 10 and NIST 800-53 where they map directly.
- Include a "Required Security Mindset" section at the end that sets the adversarial assumption posture.
- Include a "Non-Negotiable Rules" quick-reference summary of the absolute hardest rules (~6-8 lines).
- Short inline code examples ONLY where the wrong-vs-right way is genuinely ambiguous.
- Cross-reference other instruction files (database-safety, sca-scanning, sast-scanning, testing-standards) briefly rather than duplicating.
- Include a "Reference Standards" footer listing the frameworks and their roles, so future SMEs understand the hierarchy.
- Target ~150 lines of rules. This IS the most important file and loads on every interaction — density is more important than brevity here.
