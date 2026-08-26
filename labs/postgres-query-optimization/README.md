# PostgreSQL Query Optimization Lab

This SQL-first lab supports an interview-focused progression:

1. Build index and access-path intuition.
2. Read PostgreSQL execution plans as work.
3. Diagnose deliberately inefficient queries against a million-order workload.
4. Connect measured database behavior to Java/Spring concerns later.

The lab contains no solution indexes. Establish a baseline and make an unaided prediction before adding or changing anything.

## Safety boundary

- PostgreSQL 18 in a local Docker volume
- Synthetic deterministic data only
- The analyze runner rejects mutating SQL keywords
- `EXPLAIN ANALYZE` still executes accepted statements
- Never point these scripts at another database

## Dataset

The full local seed creates:

- 1,000,000 `orders`
- A skewed customer distribution with deliberately hot users
- Skewed order statuses
- Two years of deterministic timestamps
- Approximately two `order_items` per order
- Related `customers` and `products` tables for join exercises

Only primary-key indexes exist initially. Secondary indexes are exercise decisions, not bootstrap assumptions.

## Commands

```bash
./scripts/up.sh
./scripts/reset.sh
./scripts/smoke.sh
./scripts/run-query.sh plan sql/exercises/01-recent-orders-for-user.sql
./scripts/run-query.sh analyze sql/exercises/01-recent-orders-for-user.sql
./scripts/capture-plan.sh recent-user-baseline plan sql/exercises/01-recent-orders-for-user.sql
./scripts/down.sh
```

Remove the data volume only when you intentionally want a clean database:

```bash
./scripts/down.sh --volumes
```

Override the dataset size for CI or quick experiments:

```bash
LAB_ORDER_COUNT=50000 ./scripts/reset.sh
```

The supported range is 1,000–5,000,000 orders.

## First exercise protocol

Before running `01-recent-orders-for-user.sql`, write down:

- What PostgreSQL probably does
- How many rows it may inspect versus return
- Whether an index could help
- A possible single or composite index and its column order
- What the plan should reveal if the hypothesis is correct
- The write/storage cost of the proposed index

Then run `plan`, followed by `analyze`. Do not add the index until the baseline result and plan have been recorded.

## Plan-reading order

Read from actual work, not preferred node names:

1. Confirm the query result and parameters.
2. Find large rows-visited versus rows-returned amplification.
3. Check actual rows, loops, and buffers.
4. Locate sorts, spills, and repeatedly executed inner nodes.
5. Compare estimated and actual rows.
6. Propose the smallest query, index, or statistics change.
7. Re-run under equivalent conditions and a changed parameter.

## Evidence

Generated captures go to `evidence/generated/` and are intentionally ignored. Promote only reviewed artifacts into a named case-study directory, including the environment and dataset metadata needed to interpret them.

Use the repository-level [case-study template](../../docs/CASE_STUDY_TEMPLATE.md).

## Planned exercises

The course will reveal these one at a time:

- Selective lookup
- Reasonable sequential scan despite an available index
- Composite-index ordering
- Expensive sort
- Bad join
- Query-shape versus index trade-off
- Pagination
- Cardinality-estimate error
- JPA N+1 and excessive query count
- Workload ranking with `pg_stat_statements`

Only the first read-only query is included in the initial scaffold.
