---
generates: .github/instructions/sast-scanning.instructions.md
---

/create-instruction sast-scanning.instructions.md

# SAST Scanning — Generation Prompt

You are generating a Copilot instruction file that enforces Static Application Security Testing (SAST) requirements for every repository. This is a CI/CD governance file — it tells Copilot what SAST infrastructure must exist and how findings must be handled.

## Standards and References

- **NIST SSDF (SP 800-218)**: PW.7 (Review and/or Analyze Human-Readable Code), PW.8 (Test Executable Code)
- **OWASP SAMM**: Verification > Security Testing
- **SLSA v1.0**: Build integrity and provenance
- **NIST SP 800-53**: SA-11 (Developer Testing and Evaluation)
- **GitHub Advanced Security**: CodeQL as first-party SAST for GitHub-hosted repos
- **Semgrep**: Lightweight, fast SAST with custom rule support — good for private repos or orgs without GHAS

## Scope

CI/CD pipeline configuration and SAST workflow management:
- SAST tool selection and configuration
- GitHub Actions workflow setup
- Finding triage and remediation workflow
- Quality gates (block merge on high/critical findings)
- Suppression policy

NOT covered:
- Specific vulnerability remediation → security-standards
- Dependency scanning → sca-scanning
- Runtime/DAST scanning → separate concern

## Tool Selection Policy

This is an opinionated default — orgs can customize:
- **Public repositories**: CodeQL via GitHub Actions (free for public repos, deep semantic analysis)
- **Private repositories with GitHub Advanced Security**: CodeQL
- **Private repositories without GHAS**: Semgrep (free tier available, fast, custom rules)
- Both tools integrate with GitHub Security tab for centralized finding management

## Control Families (5 sections)

### 1. SAST Requirement
- Every repository MUST have SAST scanning enabled
- SAST must run on every pull request targeting the default branch
- SAST must run on push to the default branch (to catch direct pushes and establish baseline)

### 2. Tool Configuration
- CodeQL: enable for all supported languages in the repo; use default query suites + security-extended
- Semgrep: use recommended rulesets (p/default, p/security-audit, p/owasp-top-ten) at minimum
- Configure scanning for all languages present in the repository — not just the primary language

### 3. Quality Gates
- High and Critical severity findings MUST block PR merge
- Medium findings should be triaged within a defined timeframe
- New findings introduced by the PR are the responsibility of the PR author

### 4. Finding Management
- All findings must be triaged: fix, suppress with justification, or mark as false positive
- Suppressions require a code comment explaining why the finding is not applicable
- Track suppression count — rising suppressions without fixes is a smell
- Review and re-validate suppressions periodically

### 5. Workflow Template
- Provide the standard GitHub Actions workflow for CodeQL and Semgrep
- Workflow should upload results to GitHub Security tab (SARIF format)
- Schedule weekly full-repo scan in addition to PR-triggered scans

## Style Notes

- ⛔/✅ format, imperative voice
- 5 sections — CI/CD governance, not code-level rules
- Include example workflow YAML snippets in the control file
- Target ~45-60 lines of rules
