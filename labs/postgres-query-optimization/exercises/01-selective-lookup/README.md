# Exercise 01 — Recent orders for one customer

## Scenario

An order-history endpoint needs the 25 most recent orders for customer `42` since the beginning of 2025. The endpoint has become noticeably slower as the `orders` table grows.

Your goal is not to force a particular plan node. Diagnose the work PostgreSQL performs, preserve the result, and justify the smallest useful change.

## Study prerequisites

If indexes and plans are new to you, read these before attempting the lab:

1. [Use The Index, Luke! — Anatomy of an Index](https://use-the-index-luke.com/sql/anatomy)
2. [Use The Index, Luke! — Concatenated Keys](https://use-the-index-luke.com/sql/where-clause/the-equals-operator/concatenated-keys)
3. [Use The Index, Luke! — Indexed ORDER BY](https://use-the-index-luke.com/sql/sorting-grouping/indexed-order-by)
4. [PostgreSQL 18 — Using EXPLAIN](https://www.postgresql.org/docs/18/using-explain.html), especially sections 14.1.1–14.1.3
5. [PostgreSQL 18 — Multicolumn Indexes](https://www.postgresql.org/docs/18/indexes-multicolumn.html) and [Indexes and ORDER BY](https://www.postgresql.org/docs/18/indexes-ordering.html)

Reading is preparation. The written prediction and measured attempt are the exercise evidence.

## Rules

- Do not open `solutions/01-selective-lookup/` before completing the attempt gate.
- Write predictions before executing either plan command.
- Treat timing from one run as evidence about this environment, not a universal benchmark.
- `EXPLAIN ANALYZE` executes the read-only query against the synthetic local database.
- Resetting the lab removes any secondary index added by the solution.

## 1. Prepare

From `labs/postgres-query-optimization`:

```bash
./scripts/reset.sh
cp exercises/01-selective-lookup/WORKSHEET.md \
  evidence/generated/01-selective-lookup-notes.md
```

The default seed contains one million orders. Use `LAB_ORDER_COUNT=50000 ./scripts/reset.sh` for a quicker exploratory run, but record the chosen size.

## 2. Predict before execution

Open [query.sql](query.sql), but do not run it yet. Record:

1. Which access path PostgreSQL is likely to choose with only the baseline indexes.
2. Roughly how much of `orders` it may inspect versus return.
3. Whether the `ORDER BY` is likely to require separate work.
4. Whether an index could help.
5. The index columns and order you would try, if any.
6. The plan changes that would support or falsify your hypothesis.
7. The storage and write costs your proposed index introduces.

This written prediction is the attempt gate.

## 3. Observe without executing the query

```bash
./scripts/run-query.sh plan exercises/01-selective-lookup/query.sql
```

Record the estimated rows and costs. Explain the plan in terms of work rather than labeling a node as good or bad.

## 4. Measure the baseline

```bash
./scripts/run-query.sh analyze exercises/01-selective-lookup/query.sql
./scripts/capture-plan.sh selective-lookup-baseline analyze \
  exercises/01-selective-lookup/query.sql
```

Record actual rows, rows removed by filtering, sort behavior, buffers, and execution time. Run the query separately if you want to inspect its result:

```bash
./scripts/run-query.sh query exercises/01-selective-lookup/query.sql
```

## 5. Propose and test one change

Write your own SQL change in `evidence/generated/01-candidate.sql` before opening the reference solution. Explain why each indexed column belongs there and why its position matters. Apply it to the synthetic lab with:

```bash
docker compose exec -T postgres psql -X -v ON_ERROR_STOP=1 \
  -U labs -d backend_labs \
  -f /workspace/evidence/generated/01-candidate.sql
```

After applying your change, repeat the analyze and capture commands with a new label. Verify that the returned rows remain correct with:

```bash
docker compose exec -T postgres psql -X -v ON_ERROR_STOP=1 \
  -U labs -d backend_labs \
  -f /workspace/exercises/01-selective-lookup/verify-result.sql
```

If you override the database credentials, use the equivalent values in that command.

## 6. Test transfer

Change `user_id` from `42` to a customer outside the hot range, such as `1500`. Predict whether the same plan and index remain appropriate, then measure it. Restore `query.sql` before committing shared changes.

## 7. Explain the trade-off

Answer in 60–90 seconds:

> Why was the baseline slow, what did you change, which plan evidence supports the change, and what did the change cost?

## Attempt gate

Before revealing the reference, confirm that your worksheet contains:

- A pre-execution prediction
- A captured baseline plan
- One justified change
- A captured changed plan
- A result-correctness check
- A changed-parameter observation
- Storage/write trade-offs and at least one rejected alternative

<details>
<summary>I completed the attempt gate — show the reference solution</summary>

[Open the reference solution](../../solutions/01-selective-lookup/README.md).

</details>

## Share your attempt

The stable exercise URL is:

`https://github.com/k4vrin/backend-systems-labs/tree/main/labs/postgres-query-optimization/exercises/01-selective-lookup`

Use the repository's [LinkedIn exercise template](../../../../docs/LINKEDIN_EXERCISE_POST_TEMPLATE.md). Share your prediction, one measured before/after artifact, and the trade-off—without putting the solution in the opening paragraph.
