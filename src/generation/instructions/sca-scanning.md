---
generates: .github/instructions/sca-scanning.instructions.md
---

/create-instruction sca-scanning.instructions.md

# SCA Scanning — Generation Prompt

You are generating a Copilot instruction file that enforces Software Composition Analysis (SCA) — dependency vulnerability scanning and supply chain security. This is a CI/CD and dependency governance file.

## Standards and References

- **NIST SSDF (SP 800-218)**: PW.4 (Reuse Existing, Well-Secured Software)
- **SLSA v1.0**: Supply chain integrity — provenance, build isolation
- **OWASP Top 10 2021**: A06 Vulnerable and Outdated Components
- **CWE-1104**: Use of Unmaintained Third-Party Components
- **CISA Secure by Design**: Secure defaults for dependency management
- **GitHub Dependabot**: Automated dependency update PRs and security alerts  
- **OpenSSF Scorecard**: Supply chain security health metrics

## Scope

Dependency management and supply chain security:
- Dependabot configuration and alert response
- Lockfile management and integrity
- Dependency update cadence
- Vulnerability response timelines
- Dependency selection criteria

NOT covered:
- Static code analysis → sast-scanning
- Runtime vulnerability scanning → separate concern
- Specific vulnerability remediation → security-standards

## Critical LLM Failure Modes

### Dependency management
- Adding dependencies without checking for known vulnerabilities
- Using wildcard or range version specifiers in production dependencies
- Not committing lockfiles to version control
- Suggesting deprecated or unmaintained packages
- Installing from unverified registries or sources

### Supply chain
- No Dependabot or equivalent automated scanning configured
- Dependabot alerts ignored or dismissed without review
- No policy for maximum age of known vulnerability before remediation
- Mixing production and development dependencies

## Control Families (6 sections)

### 1. SCA Requirement
- Every repository MUST have Dependabot enabled (or equivalent SCA tool)
- Dependabot security alerts must be enabled and routed to the responsible team
- `dependabot.yml` must exist in `.github/` with configuration for all package ecosystems in the repo

### 2. Dependabot Configuration
- Configure update schedules for each package ecosystem (npm, pip, go, cargo, maven, bundler, etc.)
- Group minor/patch updates to reduce PR noise
- Security updates must be on a more aggressive schedule than feature updates
- Target the default branch

### 3. Lockfile Management
- Lockfiles MUST be committed to version control
- Dependencies installed from lockfile in CI (npm ci, pip install --require-hashes, etc.)
- Lockfile changes must be reviewed — they represent actual dependency changes

### 4. Vulnerability Response
- Critical/High: remediate within defined SLA (e.g., 7 days for Critical, 30 days for High)
- Medium: remediate within reasonable timeframe, track in backlog
- Low: assess and track, remediate during regular maintenance
- If a fix is not available: document risk, apply mitigating controls, track for fix availability

### 5. Dependency Selection
- Evaluate dependencies before adding: maintenance status, known vulnerabilities, license compatibility, transitive dependency count
- Prefer well-maintained packages with active communities
- Minimize dependency count — every dependency is attack surface
- Never install from unverified registries or directly from Git URLs without pinning to a specific commit

### 6. Supply Chain Integrity
- Use package manager integrity verification (npm integrity checks, pip --require-hashes, go.sum)
- Pin GitHub Actions to full commit SHA, not tags
- Consider OpenSSF Scorecard for dependency health assessment

## Style Notes

- ⛔/✅ format, imperative voice
- 6 sections — dependency governance + supply chain
- Cross-references security-standards for general supply chain security rules
- Include Dependabot config YAML example in the control file
- Target ~50-65 lines of rules
