#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-dev}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$REPO_ROOT/src/.github"
DIST_DIR="$REPO_ROOT/dist/.github"

# Clean previous build
rm -rf "$REPO_ROOT/dist"

# Copy source to dist
mkdir -p "$DIST_DIR"
cp -r "$SRC_DIR"/* "$DIST_DIR"/
cp -r "$SRC_DIR"/.[!.]* "$DIST_DIR"/ 2>/dev/null || true

# Inject version into consumer README
if [[ -f "$DIST_DIR/README.md" ]]; then
  sed -i "s/{{VERSION}}/$VERSION/g" "$DIST_DIR/README.md"
fi

# Summary
echo "Build complete: dist/.github/ ($VERSION)"
echo ""
find "$DIST_DIR" -type f | sed "s|$REPO_ROOT/||" | sort
echo ""
echo "Files: $(find "$DIST_DIR" -type f | wc -l)"
