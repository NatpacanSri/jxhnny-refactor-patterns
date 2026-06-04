# Jxhnny Refactor Patterns

Use these instructions for frontend refactors when the environment does not
support Codex `SKILL.md` loading.

## When To Use

Use this guide when the user asks to:

- refactor frontend code to match local patterns;
- apply `refactor-pattern`;
- adapt code to the existing system practice;
- split or tame a large frontend file;
- preserve behavior while moving code to better responsibilities.

## Core Workflow

1. Confirm the target is frontend work. If the request touches backend or API
   behavior, apply this guide only to frontend-facing code and state the
   boundary.
2. Read the target repository first. Prefer local conventions over generic
   advice, especially component ownership, hook return shapes, service/type
   organization, UI libraries, and verification scripts.
3. Use a reference frontend project only when the target repo has no clear
   local pattern. Borrow intent, not dependencies.
4. Ask one small question at a time only when the preference cannot be inferred
   safely. Continue with a conservative repo-aligned implementation when the
   local code already answers the question.
5. Keep refactors scoped to the surface the user pointed at. Do not reshape
   shared hooks, shared services, or page-level ownership unless the request
   explicitly includes that scope or the existing pattern requires it.
6. For large files, map the file before editing and refactor one responsibility
   at a time.
7. Verify with the target repo's scripts. If full verification is blocked by
   environment issues, run focused checks and report the blocker separately.

## Ownership Rules

- Page component: own cross-component coordination, selected entity state,
  period/filter scope, and top-level modals.
- Page-local hook: own loading, query criteria assembly, pagination effects,
  refresh/reload behavior, and data normalization needed by that page.
- Leaf component: render from props and emit explicit events.
- Service: own HTTP request shape and typed response models.
- Utility: own reusable formatting or transformation behavior used in multiple
  places.

## Large File Workflow

Use this when a file is hard to scan, commonly around 250+ lines, or mixes data
loading, filters, modals, tables, charts, form state, and rendering.

1. Map imports, local types, constants, state/effects, data loading, event
   handlers, derived values, render blocks, and side effects.
2. Pick the smallest safe slice: filter state, loading hook, table columns,
   modal body, chart data shaping, or pure helpers.
3. Preserve behavior. Keep prop names, hook return shapes, API criteria, and UI
   output stable unless the user asked for behavior changes.
4. Place extracted code by ownership:
   - page-only UI under page-local `components`;
   - page-only orchestration under page-local `hooks`;
   - reusable UI under shared `components`;
   - pure repeated transforms under `utils`;
   - service request/response shapes near the service.
5. Avoid whole-file rewrites. Patch only the current slice, then verify before
   continuing.
6. Ask before a broad split when ownership is unclear, public APIs change, or
   multiple extraction paths are valid. Offer 2-3 concrete options.

Do not extract code just to make a file shorter. Extract only when it clarifies
a responsibility, matches the repo pattern, improves testability, or prevents
the next change from touching unrelated logic.

## Refactor Preferences

- Prefer page-owned orchestration and leaf components with explicit props.
- Group prop-heavy child props by responsibility only when it improves
  readability. Do not pass hook return objects wholesale just to shorten JSX.
- In React Compiler-enabled projects, avoid adding `useMemo` or `useCallback`
  only to stabilize grouped props.
- Prefer existing utility libraries when they make transforms shorter and
  clearer without hiding domain behavior.
- Prefer domain-named utility object exports such as `DateUtil`, `NumberUtil`,
  `TaskStatusUtil`, or `QueryKeyFactory`.
- Keep short single-use expressions inline when readable. Extract helpers only
  when repeated, long, domain-named, test-worthy, or scan-improving.
- Keep one-consumer helpers local near their owner. Promote to shared utilities
  only after reuse is real and the domain boundary is clear.
- Preserve existing UI idioms and reuse table, filter, chart, modal, title,
  badge, empty-state, skeleton, and dropdown components before creating new
  variants.
- Prefer targeted audits over raw grep dumps. Separate user-facing display text
  from CSS units, layout percentages, comments, and fixtures.
