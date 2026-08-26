# Reference solution 01 — Selective lookup

## Reasoning

With only the primary-key index, PostgreSQL has no ordered access path beginning with `user_id`. On the supplied workload, the baseline commonly scans `orders`, filters for the customer and date range, and performs top-N sort work before returning 25 rows. Use your own captured plan as the authority for what happened in your environment.

The query first constrains `user_id` by equality, then constrains `created_at` by range and requests descending timestamp order. A B-tree index on `(user_id, created_at DESC)` matches that access pattern: PostgreSQL can navigate to one customer's timestamp range, read it in the requested order, and stop after the limit instead of finding and sorting every match.

PostgreSQL can also scan a normal ascending B-tree backward, so `DESC` is not required for this single ordered column. It is written explicitly here to document the workload's requested direction; mixed-direction multicolumn ordering has additional considerations.

## Apply the reference change

```bash
./scripts/run-change.sh solutions/01-selective-lookup/apply.sql
./scripts/run-query.sh analyze exercises/01-selective-lookup/query.sql
./scripts/capture-plan.sh selective-lookup-reference analyze \
  exercises/01-selective-lookup/query.sql
```

Do not claim a speedup until your before/after captures show it under equivalent conditions.

## Why this is not a covering index

The reference deliberately starts with the smaller access-path index. Adding `id`, `status`, and `total` through `INCLUDE` could make index-only access possible when PostgreSQL's visibility checks permit it, but it also enlarges the index and increases write cost. Fetching 25 heap rows may already be cheap, so measure before widening it.

## Expected evidence

Look for evidence such as:

- An index-based access path using both predicates
- Far fewer rows visited to produce 25 results
- Equivalent result invariants
- Different buffer and timing behavior in your measured environment

At the full dataset size, the ordered index may let PostgreSQL avoid a separate sort and stop early. At a reduced dataset size, PostgreSQL may reasonably choose a bitmap scan plus a small sort instead. Explain the cost trade-off shown by your plan instead of treating either shape as mandatory.

Do not treat `Index Scan` as automatically better. The evidence must show less relevant work for this query and dataset.

## Costs and rejected alternatives

- Every insert and relevant key update must maintain another B-tree.
- The index occupies storage and cache space.
- An index only on `created_at` does not directly isolate one user.
- An index only on `user_id` can reduce filtering but does not supply the requested timestamp order.
- A covering index may be unjustified for a result limited to 25 heap fetches.
- Application caching does not remove the database access-path problem and introduces invalidation concerns.

## Roll back

```bash
./scripts/run-change.sh solutions/01-selective-lookup/rollback.sql
```

Alternatively, `./scripts/reset.sh` recreates the baseline schema.

## Transfer check

Repeat the prediction and measurement for a colder customer such as `1500`, and for a query without `LIMIT`. Explain which conclusions transfer and which depend on selectivity and result size.
