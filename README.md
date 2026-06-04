# jxhnny-refactor-patterns

Codex skill for frontend refactors that preserve behavior, follow local
patterns first, and split large files by responsibility instead of rewriting
them wholesale.

## Install

Install with Codex skill installer from this repository path:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo <owner>/jxhnny-refactor-patterns \
  --path skills/jxhnny-refactor-patterns
```

Restart Codex after installing the skill.

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
```

## Notes

This public version avoids machine-specific paths and private project names.
For team use, keep private repo-specific references in a private fork or add a
separate private reference file.
