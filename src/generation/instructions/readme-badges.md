---
generates: .github/instructions/readme-badges.instructions.md
---

/create-instruction readme-badges.instructions.md

# README Badges — Generation Prompt

You are generating a Copilot instruction file that enforces a standard set of badges at the top of every README.md. This is a documentation governance file — lightweight, prescriptive, and template-oriented.

## Purpose

Badges serve as an at-a-glance project health dashboard:
- CI/CD status visible immediately
- Security scanning status (SAST, SCA) proves compliance
- Coverage and test status signal code quality
- License, issues, PRs, and releases signal project health and openness

## Required Badge Set

These badges MUST appear at the top of every README.md, in this order:

### Row 1: CI/CD and Quality
1. **Build Status** — GitHub Actions workflow badge for the main CI workflow
2. **Tests** — GitHub Actions workflow badge for the test suite
3. **Code Coverage** — From Codecov, Coveralls, or equivalent coverage service

### Row 2: Security
4. **SAST** — CodeQL or Semgrep workflow status
5. **SCA / Dependabot** — Dependency scanning status

### Row 3: Project Info
6. **License** — shields.io badge showing the repo license
7. **Open Issues** — shields.io badge showing open issue count
8. **Open PRs** — shields.io badge showing open PR count
9. **Latest Release** — shields.io badge showing latest release/tag

## Badge Sources

- **GitHub Actions badges**: Use the native workflow badge URL format: `https://github.com/{owner}/{repo}/actions/workflows/{workflow}.yml/badge.svg`
- **shields.io**: Use for license, issues, PRs, releases: `https://img.shields.io/github/{metric}/{owner}/{repo}`
- **Coverage**: Depends on service — Codecov, Coveralls, etc. each have their own badge URL format

## Badge Format

```markdown
[![Build](https://github.com/{owner}/{repo}/actions/workflows/ci.yml/badge.svg)](https://github.com/{owner}/{repo}/actions/workflows/ci.yml)
[![Tests](https://github.com/{owner}/{repo}/actions/workflows/tests.yml/badge.svg)](https://github.com/{owner}/{repo}/actions/workflows/tests.yml)
[![Coverage](https://codecov.io/gh/{owner}/{repo}/branch/main/graph/badge.svg)](https://codecov.io/gh/{owner}/{repo})
```

Each badge MUST link to its source (workflow run page, shields.io detail, coverage report).

## Control Families (3 sections)

### 1. Required Badge Set
- The 9 badges listed above must appear at the top of README.md
- Badges must appear BEFORE any other content (title, description, etc. come after)
- Badge names/labels must be consistent across all repositories

### 2. Badge Formatting
- Use Markdown image-link syntax: `[![label](badge-url)](link-url)`
- Group by row as defined above — CI/Quality, Security, Project Info
- Every badge must link to its detail page

### 3. Template
- Provide a copy-paste badge template with placeholder variables
- Template must be adaptable to the actual workflow file names in the repo

## Style Notes

- ⛔/✅ format, imperative voice
- 3 sections — this is the lightest instruction file
- Include the actual badge markdown template in the control file
- Target ~30-40 lines of rules
