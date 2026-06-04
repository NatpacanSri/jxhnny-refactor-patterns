#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTRUCTION_SOURCE="$SOURCE_DIR/agent-instructions/jxhnny-refactor-patterns.md"
AGENTS_SOURCE="$SOURCE_DIR/agent-instructions/AGENTS.md"

mkdir -p "$TARGET_DIR/.agent-instructions"
cp "$INSTRUCTION_SOURCE" "$TARGET_DIR/.agent-instructions/jxhnny-refactor-patterns.md"

if [ ! -e "$TARGET_DIR/AGENTS.md" ]; then
  cp "$AGENTS_SOURCE" "$TARGET_DIR/AGENTS.md"
  echo "Created $TARGET_DIR/AGENTS.md"
else
  cat >> "$TARGET_DIR/AGENTS.md" <<'EOF'

## Jxhnny Refactor Patterns

For frontend refactors, read `.agent-instructions/jxhnny-refactor-patterns.md`.
Follow target-repo conventions first, preserve behavior, and split large files
by one responsibility at a time.
EOF
  echo "Appended Jxhnny Refactor Patterns note to $TARGET_DIR/AGENTS.md"
fi

echo "Installed generic agent instructions into $TARGET_DIR"
