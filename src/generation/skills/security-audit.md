---
generates: .github/skills/security-audit/SKILL.md
---

/create-skill security-audit

# Security Audit — Generation Prompt

Skill that provides a comprehensive security audit workflow covering OWASP Top 10, API Security Top 10, and secrets scanning.

## Design Intent

A full security audit requires systematic coverage across multiple frameworks. This skill codifies the methodology: scope, OWASP Top 10 review, API Security review (if applicable), secrets scan, and structured reporting with CWE identifiers and remediation.

## Key Behaviors

- Reads `security-standards.instructions.md` first to load project governance
- Scopes the audit (full codebase or specific module)
- Systematically checks all OWASP Top 10 categories (A01-A10)
- Adds OWASP API Security Top 10 if reviewing API code
- Scans for hardcoded secrets, API keys, tokens
- Every finding gets a CWE identifier and severity classification
- Provides evidence (code snippets) and specific remediation with code examples

## Output

Executive summary, findings table (Severity, CWE, OWASP category, File:Line, Description, Remediation), and detailed findings with evidence and impact.

## Related Files

- `.github/instructions/security-standards.instructions.md` — security governance
- `.github/agents/security-reviewer.agent.md` — agent that uses this skill’s patterns
- `.github/skills/threat-modeling/SKILL.md` — complementary threat analysis
