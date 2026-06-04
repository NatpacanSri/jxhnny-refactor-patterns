#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-NatpacanSri/jxhnny-refactor-patterns}"
REF="${REF:-main}"
SKILL_NAME="jxhnny-refactor-patterns"
CODEX_HOME_DIR="${CODEX_HOME:-"$HOME/.codex"}"
DEST_PARENT="$CODEX_HOME_DIR/skills"
DEST="$DEST_PARENT/$SKILL_NAME"
FORCE=0

usage() {
  cat <<USAGE
Install $SKILL_NAME into Codex skills.

Usage:
  scripts/install-codex.sh [--force]

Environment:
  REPO        GitHub repo to install from. Default: $REPO
  REF         Git ref to install from. Default: $REF
  CODEX_HOME  Codex home directory. Default: ~/.codex

Options:
  --force     Replace an existing installed skill.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -e "$DEST" ] && [ "$FORCE" -ne 1 ]; then
  echo "Skill already exists: $DEST" >&2
  echo "Run with --force to replace it." >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ARCHIVE="$TMP_DIR/archive.tar.gz"
EXTRACT_DIR="$TMP_DIR/extract"
mkdir -p "$EXTRACT_DIR" "$DEST_PARENT"

echo "Downloading https://github.com/$REPO/archive/$REF.tar.gz"
curl -fsSL "https://github.com/$REPO/archive/$REF.tar.gz" -o "$ARCHIVE"
tar -xzf "$ARCHIVE" -C "$EXTRACT_DIR"

SOURCE="$(find "$EXTRACT_DIR" -path "*/skills/$SKILL_NAME/SKILL.md" -print -quit)"
if [ -z "$SOURCE" ]; then
  echo "Could not find skills/$SKILL_NAME/SKILL.md in archive." >&2
  exit 1
fi

SOURCE_DIR="$(dirname "$SOURCE")"

if [ -e "$DEST" ]; then
  rm -rf "$DEST"
fi

cp -R "$SOURCE_DIR" "$DEST"

echo "Installed $SKILL_NAME to $DEST"
echo "Restart Codex to pick up the skill."
