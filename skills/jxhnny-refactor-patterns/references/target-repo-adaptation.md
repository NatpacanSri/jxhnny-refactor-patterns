# Target Repository Adaptation

Use this reference to adapt the frontend pattern to a target repository without
copying private assumptions, unrelated dependencies, or a different stack's
component model.

## Target-Repo First

Read the target repository before borrowing a pattern. Prefer existing target
building blocks:

- page title/header components
- date or period pickers
- detail modals and selected-item ownership
- formatting utilities
- chart helpers and wrappers
- dropdown hooks
- service folders and typed request/response models
- page-owned hooks under `src/pages/<page>/hooks`
- local table, filter, empty-state, skeleton, and badge components

## User Preferences

- For `refactor-pattern` work, inspect the pointed file or UI surface first and
  follow the nearest established pattern.
- For many-surface work, finish one narrow surface and ask for the next one
  instead of sweeping unrelated files.
- Reuse page-owned modal state when the page already owns the modal flow. Avoid
  creating a second modal flow inside a leaf component.
- Keep shared hooks unchanged unless the user explicitly asks to change their
  API. Prefer component-only adaptation when a hook already returns usable data.
- For dropdown refactors, consume existing dropdown hooks and convert values at
  the component boundary if needed.
- For percent or number display audits, inspect user-facing text and use the
  target repo's number formatting utility; ignore CSS layout percentages and
  non-display tokens.
- For charts, reuse existing chart library conventions and tooltip/style
  helpers.
- For mock UI additions, look for existing mock-data or page-local mock
  conventions before inventing a new setup.
- For Team-like pages, keep period range and period scope at page level, and
  pass derived state into list/filter hooks.
- For large files, do not keep adding unrelated logic into the same file. Map
  the file first, extract one cohesive responsibility, and preserve behavior.
  Prefer page-local `components`, `hooks`, and `utils` before promoting code to
  shared folders.
- For shared `src/utils`, prefer domain object exports such as `DateUtil`,
  `NumberUtil`, `TaskStatusUtil`, or `QueryKeyFactory`, with arrow-function
  methods and direct imports. Keep one-consumer helpers as local arrow
  functions near the component, hook, or page owner.

## Common Refactor Boundaries

- Page component: owns cross-component coordination, selected entity state,
  period/filter scope, and top-level modals.
- Page-local hook: owns loading, query criteria assembly, pagination effects,
  refresh/reload behavior, and data normalization needed by that page.
- Leaf component: renders UI from props and emits explicit events.
- Service: owns HTTP request shape and typed response models.
- Utility: owns reusable formatting or transformation behavior used in multiple
  places.

## Large File Candidates

Common large frontend file categories:

- generated or library-style shared UI wrappers
- layout/navigation components
- dense task/list views
- filter/toolbar/search components
- chart and table wrappers
- map/canvas/imperative integration hooks

Do not blindly split generated or third-party-derived UI wrappers. For app-owned
large files, prefer these extraction directions:

- Move table column definitions and row rendering helpers near the table
  component or page-local utils.
- Move filter form state and applied-filter logic into page-local hooks.
- Move repeated chart data shaping into page-local hooks or utilities.
- Move modal body sections into page-local components while keeping open/close
  state at the page owner.
- Keep detail-modal behavior aligned with existing page ownership instead of
  nesting another modal flow inside a large child component.

## Verification

Use the target repo's existing verification scripts. Prefer the full repo check
when available, then fall back to focused checks such as typecheck, lint, format
check, or targeted tests. Report warnings and known environment noise separately
from source failures.
