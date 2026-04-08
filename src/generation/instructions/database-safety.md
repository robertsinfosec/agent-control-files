---
generates: .github/instructions/database-safety.instructions.md
---

/create-instruction database-safety.instructions.md

# Database Safety — Generation Prompt

You are generating a Copilot instruction file that enforces safe database practices — queries, migrations, schema design, data protection, connection management, and authorization at the data layer. Scoped to database-related file patterns via `applyTo`.

## Standards and References

- **OWASP ASVS v5 Chapter V5**: Validation, Sanitization — parameterized queries, input binding
- **OWASP ASVS v5 Chapter V8**: Data Protection — encryption at rest, data classification, sensitive data handling
- **CWE-89**: SQL Injection — the #1 database vulnerability, consistently in CWE Top 25
- **CWE-312**: Cleartext Storage of Sensitive Information
- **CWE-319**: Cleartext Transmission of Sensitive Information
- **CWE-862/863**: Missing/Incorrect Authorization — row-level access control gaps
- **CWE-916**: Use of Password Hash With Insufficient Computational Effort
- **NIST SP 800-53**: SC-28 (Protection of Information at Rest), SC-8 (Transmission Confidentiality)
- **OWASP Top 10 2021**: A03 Injection, A04 Insecure Design

## Scope

This file covers how application code interacts with databases — NOT database server administration, DBA operations, or infrastructure provisioning. Topics:

- Query construction and parameterization
- Migration safety (additive, backward-compatible, reversible)
- Schema design (constraints, indexes, referential integrity, data types)
- Data protection (encryption at rest, hashing, masking, classification)
- Connection management (pooling, credentials, TLS)
- Authorization and tenant isolation at the query layer
- Transaction safety and consistency
- Data lifecycle and retention

## Cross-References

- `security-standards.instructions.md` already covers general injection prevention (Section 1) and secrets management (Section 4). This file adds database-specific depth — it should not duplicate those general rules but can reference them and extend with database-specific patterns.

## Critical LLM Failure Modes

### Query construction
- String concatenation or template literals in SQL queries — the most common SQLi vector LLMs produce
- Dynamic table/column names from user input without allowlist validation
- Using raw queries when ORM query builders can express the operation
- Missing parameterization in "read-only" queries (SELECT injection is still injection)
- Building IN clauses by joining strings instead of using parameterized arrays

### Migration safety
- Destructive migrations without backward compatibility (DROP COLUMN, RENAME COLUMN in production)
- Adding NOT NULL columns without DEFAULT value or backfill plan
- Missing rollback/down migration
- Schema changes that acquire exclusive locks on large tables (ALTER TABLE ADD COLUMN with DEFAULT on old PostgreSQL, etc.)
- Mixing DDL (schema) and DML (data) in the same migration

### Data protection
- Storing passwords with MD5, SHA-1, or unsalted SHA-256
- PII appearing in log output, error messages, or API responses
- Sensitive data in URL query parameters
- Database credentials hardcoded or committed to version control
- Missing encryption at rest for columns containing PII, credentials, or financial data

### Connection management
- Opening connections without closing/returning to pool
- Missing TLS for database connections
- Connection strings with embedded credentials in source code
- No connection timeout, idle timeout, or max pool size configuration

### Authorization
- Queries that fetch rows by ID without scoping to the authenticated user/tenant
- Client-supplied IDs trusted as proof of access without server-side verification
- Multi-tenant systems where tenant isolation depends on application code but is not enforced at query level

## Control Families (8 sections)

### 1. Parameterized Queries and Injection Prevention
- Always use parameterized queries or ORM query builders — for ALL operations including SELECT
- Allowlist-validate dynamic identifiers (table, column names) — never pass user input directly
- Use ORM built-in methods when they can express the operation
- Cross-ref: security-standards Section 1 for general input handling

### 2. Migration Safety
- Additive, backward-compatible with the currently deployed application version
- Destructive changes staged across multiple deployments
- Every migration has a rollback/down path
- Schema migrations separated from data migrations
- NOT NULL columns added with DEFAULT or added nullable first → backfill → add constraint
- Test against production-scale data volumes

### 3. Schema Design and Data Integrity
- Database-level constraints: NOT NULL, UNIQUE, CHECK, FOREIGN KEY
- Appropriate indexes for query patterns
- Correct data types (dates as date/timestamp, money as decimal, UUIDs as UUID)
- Audit columns on every table (created_at, updated_at)

### 4. Data Protection and Encryption
- Encrypt sensitive data at rest
- Hash passwords with bcrypt, scrypt, or Argon2id
- Classify data by sensitivity, apply controls accordingly
- Never log/return/expose PII inappropriately
- Cross-ref: security-standards Section 4 for general secrets management

### 5. Connection Management
- Connection pooling with configured limits
- TLS required, server certificates verified
- Credentials from secrets manager, injected at runtime
- Connections closed/returned after use via framework lifecycle

### 6. Authorization and Tenant Isolation
- Queries scope to authenticated user/tenant
- Server-side authorization verification, never trust client IDs
- Multi-tenant boundary enforced at query layer

### 7. Transaction Safety
- Explicit transactions for multi-step writes
- Rollback on every error path — no partial state
- Appropriate isolation levels
- Never hold transactions open during external calls

### 8. Data Lifecycle and Retention
- Retention policies for sensitive data
- Soft-delete with configurable hard-delete
- Backup and restore verification

## Style Notes

- ⛔/✅ format, imperative voice, no hedging
- 8 sections, developer-activity-oriented
- HTML comments for traceability: `<!-- OWASP-ASVS: V5 | CWE: 89 -->`
- Cross-references security-standards for shared concerns — no duplication
- Target ~75-90 lines of rules
