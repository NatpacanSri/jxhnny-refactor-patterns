# jxhnny-refactor-patterns

A frontend refactoring skill for coding agents. Preserve behavior, follow local
patterns, and split large files by responsibility. The complete instructions
live in `skills/jxhnny-refactor-patterns/`.

## Install With Skills CLI

Requires Node.js and npm. Run this inside the project where you want the skill:

```bash
npx skills add NatpacanSri/jxhnny-refactor-patterns --skill jxhnny-refactor-patterns
```

Choose your agents interactively, or specify them:

```bash
npx skills add NatpacanSri/jxhnny-refactor-patterns --skill jxhnny-refactor-patterns --agent codex claude-code cursor opencode
```

Add `--global` to install for your user across projects. Prefer project scope
when sharing the skill with a team.

The [Skills CLI](https://github.com/vercel-labs/skills) manages agent installation
locations and supports symlink or copy installs. Its current documentation lists
the supported agents and options. Installation compatibility does not guarantee
identical refactor results across models.

Check and update Skills CLI-managed installations:

```bash
npx skills check
npx skills update
```

## Install For Codex Without Node.js

The shell installer remains available. Download and inspect it, then run:

```bash
curl -fsSL https://raw.githubusercontent.com/NatpacanSri/jxhnny-refactor-patterns/main/scripts/install-codex.sh -o install-codex.sh
bash install-codex.sh
```

Use `bash install-codex.sh --force` to update a shell-managed installation.
It keeps a backup of the previous install. The script respects `CODEX_HOME`
and refuses to replace symlinks managed by another installer.

Start a new agent session after installing to pick up the skill.

## Agents With Project Instruction Files

For agents without native skill discovery, install the complete skill and a
pointer in the project's instruction file:

```bash
git clone https://github.com/NatpacanSri/jxhnny-refactor-patterns.git
cd jxhnny-refactor-patterns
./scripts/install-agent-instructions.sh /path/to/project
```

The default instruction file is `AGENTS.md`. Select another filename with:

```bash
./scripts/install-agent-instructions.sh /path/to/project --file CLAUDE.md
./scripts/install-agent-instructions.sh /path/to/project --file GEMINI.md
```

The installer copies the canonical skill and all its references into
`.agent-instructions/jxhnny-refactor-patterns/`. It preserves existing project
instructions and adds the pointer once. Re-running updates the skill files.
Use a filename that your agent actually reads.

If you used the older installer, the old instruction may refer to
`.agent-instructions/jxhnny-refactor-patterns.md`. After reinstalling, use the
new directory's `SKILL.md` pointer; the old copied guide is no longer maintained.

## Use

For Codex, invoke `$jxhnny-refactor-patterns`. For other agents, use their
native skill invocation or ask:

```text
Use jxhnny-refactor-patterns to refactor this frontend component.
```

Examples:

- `refactor-pattern`
- `refactor this to match the existing frontend pattern`
- `split this large file by responsibility`
- `adapt this implementation to the system practice`

## Maintain

Edit the canonical skill and its references. The generic agent guide links to
that source instead of duplicating the refactor rules.

Run the installer smoke checks:

```bash
bash scripts/test-installers.sh
```

The public version contains no machine-specific paths or private project names.
Keep private project references in a private fork.
