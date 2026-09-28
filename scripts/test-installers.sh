#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT
SKILL="jxhnny-refactor-patterns"
PROJECT="$TEST_DIR/project with spaces"
mkdir -p "$PROJECT"
printf '# Existing rules\n\nKeep this rule.\n' > "$PROJECT/AGENTS.md"

bash "$ROOT/scripts/install-agent-instructions.sh" "$PROJECT"
cp "$PROJECT/AGENTS.md" "$TEST_DIR/first-install.md"
bash "$ROOT/scripts/install-agent-instructions.sh" "$PROJECT"
cmp "$PROJECT/AGENTS.md" "$TEST_DIR/first-install.md"
grep -Fq 'Keep this rule.' "$PROJECT/AGENTS.md"
cmp "$ROOT/skills/$SKILL/SKILL.md" "$PROJECT/.agent-instructions/$SKILL/SKILL.md"
cmp "$ROOT/skills/$SKILL/references/frontend-patterns.md" \
  "$PROJECT/.agent-instructions/$SKILL/references/frontend-patterns.md"

for filename in CLAUDE.md GEMINI.md; do
  bash "$ROOT/scripts/install-agent-instructions.sh" "$PROJECT" --file "$filename"
  grep -Fq ".agent-instructions/$SKILL/SKILL.md" "$PROJECT/$filename"
done

if bash "$ROOT/scripts/install-agent-instructions.sh" "$PROJECT" --file; then
  echo "Missing --file argument should fail" >&2
  exit 1
fi
if bash "$ROOT/scripts/install-agent-instructions.sh" "$PROJECT" --file ../escape.md; then
  echo "Unsupported instruction filename should fail" >&2
  exit 1
fi

# Use a local archive to exercise installs without network or real agent homes.
mkdir -p "$TEST_DIR/archive/repo/skills" "$TEST_DIR/bin"
cp -R "$ROOT/skills/$SKILL" "$TEST_DIR/archive/repo/skills/"
tar -czf "$TEST_DIR/fixture.tar.gz" -C "$TEST_DIR/archive" repo
printf '%s\n' '#!/usr/bin/env bash' 'set -euo pipefail' \
  'while [ "$#" -gt 0 ]; do' \
  '  if [ "$1" = "-o" ]; then cp "$INSTALL_TEST_ARCHIVE" "$2"; exit; fi' \
  '  shift' 'done' 'exit 1' > "$TEST_DIR/bin/curl"
chmod +x "$TEST_DIR/bin/curl"

run_codex_install() {
  INSTALL_TEST_ARCHIVE="$TEST_DIR/fixture.tar.gz" \
    PATH="$TEST_DIR/bin:$PATH" CODEX_HOME="$TEST_DIR/codex home" \
    bash "$ROOT/scripts/install-codex.sh" "$@"
}

run_codex_install
DEST="$TEST_DIR/codex home/skills/$SKILL"
cmp "$ROOT/skills/$SKILL/SKILL.md" "$DEST/SKILL.md"
printf 'custom local content\n' > "$DEST/local-note.md"
if run_codex_install; then
  echo "Existing install should require --force" >&2
  exit 1
fi
test -f "$DEST/local-note.md"
run_codex_install --force
test ! -f "$DEST/local-note.md"
BACKUP_NOTE="$(find "$TEST_DIR/codex home/skills" -name local-note.md -print)"
test -n "$BACKUP_NOTE"
grep -Fq 'custom local content' "$BACKUP_NOTE"

mkdir -p "$TEST_DIR/symlink home/skills"
ln -s "$DEST" "$TEST_DIR/symlink home/skills/$SKILL"
if CODEX_HOME="$TEST_DIR/symlink home" bash "$ROOT/scripts/install-codex.sh" --force; then
  echo "Symlink install should not be replaced" >&2
  exit 1
fi
test -f "$DEST/SKILL.md"

echo "Installer checks passed."
