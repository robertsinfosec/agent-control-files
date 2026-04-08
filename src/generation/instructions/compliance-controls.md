---
generates: .github/instructions/compliance-controls.instructions.md
---

/create-instruction compliance-controls.instructions.md

# Compliance Controls — Generation Prompt

**This file requires org-specific SME input.** Unlike other instruction files in this governance system, compliance controls cannot be written universally — they depend on the organization's regulatory obligations, industry, and jurisdiction.

## What the SME Must Provide

An SME (GRC analyst, compliance officer, or security architect) should fill in this generation file with:

### 1. Applicable Regulatory Frameworks
Which regulations apply to this organization? Examples:
- **PCI-DSS v4.0** — payment card data handling
- **GDPR** — EU personal data protection
- **CCPA/CPRA** — California consumer privacy
- **HIPAA** — US healthcare data
- **SOC 2 Type II** — service organization controls
- **FedRAMP** — US federal cloud security
- **SOX** — financial reporting controls
- **ISO 27001** — information security management

### 2. Data Classification Scheme
How does the organization classify data? Example tiers:
- Public, Internal, Confidential, Restricted
- What handling rules apply at each tier?

### 3. Mandatory Controls
Which controls MUST be coded into every application? Examples:
- Encryption at rest for Confidential+ data
- Audit logging for all data access
- Data retention and deletion schedules
- Consent management for personal data
- Geographic data residency requirements

### 4. Evidence and Audit Requirements
What evidence must the code produce for auditors? Examples:
- Immutable audit logs with specific fields
- Encryption status reporting
- Access control matrices
- Data flow documentation

### 5. Incident Response Hooks
What must the code support for incident response? Examples:
- Circuit breakers for data flows
- Emergency access revocation
- Forensic logging capabilities

## Output Format

Same ⛔/✅ format as other instruction files. Organize by control family:
1. Data Classification and Handling
2. Encryption and Key Management
3. Access Control and Authorization
4. Audit Logging and Evidence
5. Data Retention and Deletion
6. Consent and Privacy
7. Incident Response Support

## Why This Can't Be Universal

- A healthcare startup needs HIPAA but not PCI-DSS
- An e-commerce company needs PCI-DSS but not HIPAA
- A European SaaS needs GDPR but may not need SOX
- A US federal contractor needs FedRAMP but probably not GDPR

The compliance-controls file is the one governance file that MUST be customized per organization.
