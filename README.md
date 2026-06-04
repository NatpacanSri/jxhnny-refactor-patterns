# jxhnny-refactor-patterns

Codex skill for frontend refactors that preserve behavior, follow local
patterns first, and split large files by responsibility instead of rewriting
them wholesale.

## Install For Codex

Recommended one-line install:

```bash
curl -fsSL https://raw.githubusercontent.com/NatpacanSri/jxhnny-refactor-patterns/main/scripts/install-codex.sh | bash
```

Replace an existing install:

```bash
curl -fsSL https://raw.githubusercontent.com/NatpacanSri/jxhnny-refactor-patterns/main/scripts/install-codex.sh | bash -s -- --force
```

Or install with the Codex skill installer from this repository path:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo NatpacanSri/jxhnny-refactor-patterns \
  --path skills/jxhnny-refactor-patterns
```

Restart Codex after installing the skill.

## Use With Other CLI Agents

Other coding agents may not understand Codex `SKILL.md` folders directly. Use
the agent-agnostic instructions instead:

```bash
git clone https://github.com/NatpacanSri/jxhnny-refactor-patterns.git
cd jxhnny-refactor-patterns
./scripts/install-agent-instructions.sh /path/to/your/project
```

That copies:

```text
/path/to/your/project/.agent-instructions/jxhnny-refactor-patterns.md
```

and creates or appends:

```text
/path/to/your/project/AGENTS.md
```

For tools that use a different project instruction filename, copy or reference
`agent-instructions/jxhnny-refactor-patterns.md` from that tool's native
instruction file.

## Use

Invoke the skill explicitly:

```text
Use $jxhnny-refactor-patterns to refactor this frontend component.
```

The skill also triggers naturally for requests like:

- `refactor-pattern`
- `refactor this to match the existing frontend pattern`
- `split this large file by responsibility`
- `adapt this implementation to the system practice`

## Layout

```text
skills/
└── jxhnny-refactor-patterns/
    ├── SKILL.md
    ├── agents/
    │   └── openai.yaml
    └── references/
        ├── frontend-patterns.md
        └── target-repo-adaptation.md
agent-instructions/
├── AGENTS.md
└── jxhnny-refactor-patterns.md
scripts/
├── install-agent-instructions.sh
└── install-codex.sh
```

## Notes

This public version avoids machine-specific paths and private project names.
For team use, keep private repo-specific references in a private fork or add a
separate private reference file.
