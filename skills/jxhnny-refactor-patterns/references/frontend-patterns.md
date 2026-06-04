# Frontend Pattern Reference

Use this as a generic reference for frontend refactors. Borrow architectural
intent, not dependencies. If the target project uses different UI libraries,
router, form library, or data-fetching layer, translate the pattern into the
target repo's existing tools.

## Project Shape

- App code lives under `src`.
- Pages live in `src/pages`, with page-local `components`, `hooks`, and `utils`
  when behavior belongs only to that page.
- Shared UI lives in `src/components`.
- Domain services live in `src/services/<DomainService>/index.ts`.
- Service DTOs live in `src/services/<DomainService>/types/*Request.ts` and
  `*Response.ts`.
- Domain UI models live in `src/types/<domain>`.
- Cross-cutting hooks are grouped by concern under `src/hooks`: `dropdown`,
  `pagination`, `sorting`, `table`, `queryObject`, `navigation`, `basic`,
  `translation`, and similar folders.
- Utilities live in `src/utils/<Name>Util.ts` or `src/utils/<Name>Util/` for
  larger utilities.
- Global/client state lives in `src/stores` when state must be shared beyond a
  component tree.

## Service Pattern

Use object-style domain services with typed method inputs and typed returns.
Keep URL construction and HTTP implementation inside the service.

Pattern:

```ts
export const BranchService = {
  async getBranchList(
    data: GetBranchListRequest,
  ): ApiReturn<GetBranchListResponse> {
    return HttpUtil.createRequest<GetBranchListResponse>({
      method: "POST",
      url: "/branch/list",
      data,
    });
  },
};
```

When adapting:

- Keep request/response types near the service if that is already the repo
  convention.
- Use the target repo's HTTP helper instead of importing a new one.
- Keep API criteria shaping close to the loader/hook or service boundary, not
  deep inside presentational components.

## Dropdown Hook Pattern

Dropdown hooks own raw dropdown data and expose mapped UI options plus a load
function.

Pattern:

```ts
export const useBranches = () => {
  const [branches, setBranches] = useState<BranchDropdown[]>([]);

  const callGetBranchDropdown = async (): Promise<boolean> => {
    const response = await BranchService.getBranchForDropdown();

    if (!response.ok) {
      return false;
    }

    setBranches(response.data || []);
    return true;
  };

  const branchOptions = branches.map((item) => ({
    value: item.branch_id,
    label: item.name,
  }));

  return { branches, branchOptions, callGetBranchDropdown };
};
```

When adapting:

- Preserve existing hook return names if callers already depend on them.
- Convert option values at the component boundary when the component requires a
  different primitive type.
- Avoid widening a shared hook API for a single component unless the user asks.

## Page-Orchestrated List Pattern

List pages typically own search input, debounced search, modal state, sort,
pagination, applied filter state, loading, and save/import actions. Page-local
hooks load data and dropdown options.

Useful moves:

- Keep temporary filter form state separate from applied filter state when the
  user must press Apply.
- Keep active filter count derived from applied filter state.
- Reset page to 1 when search or applied filters change.
- Load main records and dropdown dependencies together on initial load when the
  UI needs all of them.
- Return reload functions from loader hooks so Refresh buttons and save flows
  can reuse the same path.
- Use a single notification path for async load failures.

## Large File Split Pattern

Large frontend files are sometimes acceptable when a domain is dense, but
refactor them when a change would otherwise keep adding unrelated
responsibilities.

Common split directions:

- Page files: keep route-level orchestration in `index.tsx`; move data loading
  to page-local hooks, large panels to page-local components, pure shaping to
  page-local utils, and repeated table/modal pieces to shared components only
  after reuse is real.
- Modal files: keep open/close/save orchestration at the owner; move long form
  sections into local components and validation/default value helpers into
  local utils or schemas when the repo has that pattern.
- Map/canvas/integration hooks: keep imperative integration in hooks, but split
  loading, drawing, clearing, and data conversion when each step can be named
  clearly.
- Mock data: keep mock builders in page-local hooks or files. Do not mix large
  mock datasets into production render components.
- Utilities: split only when the utility has separable commands or domains.

Refactor sequence for a large file:

1. Read the file outline with targeted tools such as `rg`, `sed`, and symbol
   searches.
2. Identify the responsibility that the current user request touches.
3. Extract that responsibility first, keeping all other code stable.
4. Run type/lint checks before extracting the next responsibility.
5. Keep names domain-specific and boring. Prefer names like
   `useLoadInitialData`, `useImportSaleFilter`, `CreateOrUpdateBranchModal`,
   `OverviewSearchResult`, or `useDrawMapPolygons` over generic names like
   `helpers` or `Manager`.

Ask the user before turning one large file into many files if the target
structure is not obvious from nearby code.

## Table, Pagination, And Sort Pattern

Reusable table wrappers centralize styling, empty state, pagination wiring, and
sort props. Page code creates `pagination` and `sortHandler`, then passes them
to the table component.

When adapting:

- Reuse the target repo's table abstraction if it exists.
- Keep pagination state as a small hook with page, limit, totals, setters, and
  reset.
- Keep sort state in a dedicated hook that returns both raw query fields and UI
  props for the table wrapper.
- Keep empty states and fixed table styling inside the shared table component.

## Query And URL State

Use URL state when a target repo needs stable page query state, but check the
target router first. Do not introduce URL state for a small local refactor
unless the existing page already uses it.

## Comments And Scope

Use short comments to document non-obvious behavior, especially lifecycle
choices like "run once on mount" or "reset page when filters change." Comment
only when it protects future maintenance.
