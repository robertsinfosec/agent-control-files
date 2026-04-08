---
description: "Generate or update CHANGELOG.md from git history since the last release tag"
mode: "agent"
tools: ["execute", "read", "search"]
---

# Update Changelog

You are updating `CHANGELOG.md` in a repository that follows [Keep a Changelog v1.1.0](https://keepachangelog.com/en/1.1.0/).

## Step 1: Gather context

Run these commands to collect what changed since the last release:

```bash
# Find the most recent release tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
echo "Last tag: ${LAST_TAG:-none (first release)}"

# Show commits since that tag (or all commits if no tag)
if [[ -n "$LAST_TAG" ]]; then
  git log "$LAST_TAG"..HEAD --oneline --no-merges
else
  git log --oneline --no-merges
fi
```

```bash
# Show files changed (summary) since the last tag
if [[ -n "$LAST_TAG" ]]; then
  git diff "$LAST_TAG" --stat
else
  git diff --stat $(git rev-list --max-parents=0 HEAD) HEAD
fi
```

## Step 2: Read the current CHANGELOG

Read `CHANGELOG.md` and understand the existing structure and entries.

## Step 3: Categorize changes

Group commits into Keep a Changelog categories:

- **Added** — new files, features, or capabilities
- **Changed** — modifications to existing behavior
- **Fixed** — bug fixes
- **Removed** — deleted files or capabilities
- **Deprecated** — features marked for future removal
- **Security** — vulnerability fixes or security improvements

Rules:
- ⛔ NEVER include a category with no entries
- ⛔ NEVER fabricate changes that don't appear in the git history
- ✅ Write entries from the consumer's perspective (what changed for them), not implementation details
- ✅ Reference specific file names when a control file was added, changed, or removed
- ✅ Collapse related commits into a single entry (e.g., 5 commits fixing the same instruction → one "Changed" entry)

## Step 4: Update the `[Unreleased]` section

Replace the contents of the `[Unreleased]` section in `CHANGELOG.md` with the categorized entries. Preserve all previous release sections below it.

If there is no `[Unreleased]` section, add one immediately after the header block.

## Step 5: Archive previous release (if needed)

Check whether the most recent release tag's version already appears as a section heading in the changelog (e.g., `## [v26.407.0] - 2026-04-07`).

- **If the tag is NOT in the changelog**: The `[Unreleased]` section was just shipped. Archive it by:
  1. Inserting a new heading below `[Unreleased]` with the tag name and today's date: `## [v26.407.0] - 2026-04-07`
  2. Moving the old `[Unreleased]` content under that new heading
  3. Writing fresh entries under `[Unreleased]` based on commits since that tag

- **If the tag IS already in the changelog**: No archiving needed — just update `[Unreleased]` with new commits since that tag.

This ensures the changelog always has a clean `[Unreleased]` section for in-progress work and a historical record of every release.
