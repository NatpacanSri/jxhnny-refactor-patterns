---
name: jxhnny-refactor-patterns
description: Refactor frontend code to match jxhnny's preferred patterns and practices. Use when the user says refactor-pattern, asks to refactor to the existing system pattern, asks to adapt code to "pattern/practice", points at a frontend project and wants changes shaped by local conventions, wants large frontend files split into clearer responsibilities, or wants Codex to use a reference frontend project while still respecting the target repository.
---

# Jxhnny Refactor Patterns

## Core Workflow

1. Confirm the target is frontend work. If the request touches backend or API
   behavior, use this skill only for frontend-facing code and call out the
   boundary.
2. Read the target repository first. Prefer local conventions over generic
   best practice, especially existing component ownership, hook return shapes,
   service/type organization, UI libraries, and verification scripts.
3. Use a reference frontend project only when the target repo does not already
   have a clear local pattern. Read `references/frontend-patterns.md` before
   borrowing structure or behavior.
4. Read `references/target-repo-adaptation.md` before adapting the reference
   patterns into a different frontend stack.
5. Ask one small question at a time only when the user's preference cannot be
   inferred safely. Continue with a conservative implementation when the local
   code already answers the question.
6. Keep refactors scoped to the surface the user pointed at. Do not reshape
   shared hooks, shared services, or page-level ownership unless the request
   explicitly includes that scope or the existing pattern requires it.
7. For large files, follow the Large File Workflow before editing.
8. Implement using the target repo's libraries and styling system. Copy the
   pattern, not the dependency.
9. Verify with the target repo's own scripts. If full verification is blocked by
   environment issues, run the narrow checks that still prove source validity
   and report the blocker separately.

## Execution Guardrails

- Surface only assumptions that affect scope, ownership, or behavior. If a
  preference cannot be inferred from the repo, ask before broadening the change.
- Choose the smallest implementation that satisfies the user's request and the
  local pattern. Do not add speculative abstractions, configurability, or future
  flexibility.
- Keep every changed line traceable to the requested behavior or the declared
  refactor slice. Mention unrelated cleanup opportunities instead of taking
  them.
- When multiple interpretations are plausible, name the tradeoff and proceed
  with the conservative repo-aligned option unless the user asked to decide
  first.
- Define a verifiable success check before claiming completion. For refactors,
  preserve behavior and run focused checks after each meaningful slice when the
  change is large.

## Refactor Heuristics

- Prefer page-owned orchestration and leaf components that receive explicit
  props. Keep selection, modal, pagination, sort, and applied filter state at
  the level where sibling components need to coordinate.
- For prop-heavy page-owned children, group props by responsibility (`view`,
  `sort`, `filter`, `pagination`, `search`). Keep control-heavy props inline at
  the call site when that makes page flow easier to read. Build a typed
  props/options object before JSX only for boring data/config groups where it
  improves readability. Do not pass hook return objects wholesale just to
  shorten a call site; compactness should not hide the child API or increase
  coupling.
- In React Compiler-enabled projects, do not add `useMemo` or `useCallback`
  only to stabilize grouped props. Add manual memoization only when a real
  dependency, profiler result, or memoization boundary requires precise control.
- Optimize refactors for code that is both compact and easy to read. Prefer
  existing utility libraries such as `lodash-es` (`omit`, `pick`, `groupBy`,
  `keyBy`) when they make object/array transforms shorter and clearer than
  manual code. Avoid utility calls used only for cleverness, or when they hide
  domain behavior or weaken useful TypeScript inference.
- For shared utilities, prefer domain-named object exports such as `DateUtil`,
  `NumberUtil`, `TaskStatusUtil`, or `QueryKeyFactory`, with arrow-function
  methods and direct imports. Avoid catch-all exports named `utils`, `helpers`,
  `CommonUtil`, or `AppUtil`.
- Keep short, single-use variables and functions inline when the inline version
  is still readable. Extract helpers only when the expression is long, repeated,
  named domain logic, needs testing, or would make the parent component harder
  to scan. Avoid tiny wrappers that force readers to jump around the file
  without reducing real complexity.
- Keep local helpers as plain arrow-function assignments near their owner when
  they are used by one file, component, hook, or page surface. Promote them to a
  shared utility object only after reuse is real and the domain boundary is
  clear.
- Prefer domain hooks for async loading and derived options when the target repo
  already has hook folders. Keep hook return values compatible with existing
  callers.
- Prefer service modules with typed request/response models. Transform API
  shapes in one place instead of spreading ad hoc mapping across UI components.
- Prefer existing utilities for formatting, date handling, notifications,
  query strings, and downloads. Add a utility only when reuse is real.
- Prefer targeted audits over raw grep dumps. Separate user-facing display text
  from CSS units, layout percentages, comments, and test fixtures.
- Preserve existing UI idioms. Reuse established table, filter, chart, modal,
  title, badge, empty-state, skeleton, and dropdown components before creating
  new variants.
- When a file is large, reduce the next change's cognitive load. Extract
  cohesive pieces into page-local components, page-local hooks, local utils, or
  typed helpers only when the extracted piece has a clear responsibility and a
  natural name in the target repo.
- Treat the user's corrections as durable preferences. If they previously
  narrowed a change away from shared plumbing, keep that boundary unless they
  explicitly reopen it.

## Large File Workflow

Use this workflow when the pointed file is hard to scan, commonly around 250+
lines, or mixes several responsibilities such as data loading, filters, modals,
tables, charts, form state, and rendering.

1. Map the file before editing. Identify imports, local types, constants,
   state/effects, data loading, event handlers, derived values, render blocks,
   and side effects.
2. State the smallest safe refactor slice. Prefer one responsibility at a time:
   extract filter state, extract loading hook, extract table columns, extract
   modal body, extract chart data shaping, or move pure helpers.
3. Preserve behavior first. Keep prop names, hook return shapes, API criteria,
   and UI output stable unless the user asked for a behavior change.
4. Choose the destination by ownership:
   - page-only UI goes under the page's `components`;
   - page-only orchestration goes under the page's `hooks`;
   - reusable UI goes under shared `components`;
   - pure repeated transforms go under `utils`;
   - service request/response shapes stay near the service.
5. Avoid whole-file rewrites. Patch only the slice being refactored, then run
   focused verification before continuing to the next slice.
6. Ask before a broad split when the file has unclear ownership, public API
   changes, or multiple valid extraction paths. Offer 2-3 concrete extraction
   options rather than asking an open-ended question.
7. Stop after each meaningful slice if the user said there are many places to
   inspect. Summarize what improved, what risk remains, and ask for the next
   target.

Do not extract code just to make a file shorter. Extract when it clarifies a
responsibility, matches an existing repo pattern, improves testability, or
prevents the next change from touching unrelated logic.

## Progressive Pattern Lookup

Use these references only as needed:

- `references/frontend-patterns.md`: primary frontend pattern reference,
  especially services, typed dropdown hooks, list pages, filters, pagination,
  sorting, table wrappers, utilities, store boundaries, and large-file split
  patterns.
- `references/target-repo-adaptation.md`: guidance for translating the pattern
  into the target repository without copying unrelated dependencies or private
  conventions.

When the user says there are many places to inspect, start with the exact file
or UI surface they mention, then ask for the next surface after finishing or
reporting the first pass.
