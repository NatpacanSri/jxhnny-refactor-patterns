#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="."
INSTRUCTION_FILE="AGENTS.md"
TARGET_SET=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --file)
      if [ "$#" -lt 2 ]; then
        echo "--file requires AGENTS.md, CLAUDE.md, or GEMINI.md" >&2
        exit 2
      fi
      INSTRUCTION_FILE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [project-directory] [--file AGENTS.md|CLAUDE.md|GEMINI.md]"
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
    *)
      if [ "$TARGET_SET" -eq 1 ]; then
        echo "Only one project directory is accepted" >&2
        exit 2
      fi
      TARGET_DIR="$1"
      TARGET_SET=1
      shift
      ;;
  esac
done

case "$INSTRUCTION_FILE" in
  AGENTS.md|CLAUDE.md|GEMINI.md) ;;
  *) echo "Unsupported instruction filename: $INSTRUCTION_FILE" >&2; exit 2 ;;
esac

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="jxhnny-refactor-patterns"
SKILL_SOURCE="$SOURCE_DIR/skills/$SKILL_NAME"
DEST="$TARGET_DIR/.agent-instructions/$SKILL_NAME"
POINTER=".agent-instructions/$SKILL_NAME/SKILL.md"

if [ -L "$DEST" ] || [ -L "$TARGET_DIR/$INSTRUCTION_FILE" ]; then
  echo "Refusing to modify a symlinked install or instruction file" >&2
  exit 1
fi

mkdir -p "$DEST"
cp -R "$SKILL_SOURCE/." "$DEST/"

if ! [ -f "$TARGET_DIR/$INSTRUCTION_FILE" ] ||
  ! grep -Fq "$POINTER" "$TARGET_DIR/$INSTRUCTION_FILE"; then
  printf '\n## Jxhnny Refactor Patterns\n\nFor frontend refactors, read `%s` and its reference links.\n' \
    "$POINTER" >> "$TARGET_DIR/$INSTRUCTION_FILE"
fi

echo "Installed $SKILL_NAME to $DEST"
echo "Project instructions: $TARGET_DIR/$INSTRUCTION_FILE"
