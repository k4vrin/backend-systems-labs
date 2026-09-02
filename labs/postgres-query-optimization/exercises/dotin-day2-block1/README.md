# Dotin Day 2 Block 1: SQL, Index, and Plan

## Time box

- 50 minutes total
- 35 minutes: independent attempt
- 15 minutes: scoring and correction
- Internet and PostgreSQL documentation are allowed; AI assistance is not allowed during the attempt

## Requirement

Produce one row for **every customer in the `MEA` region**, including customers who have no qualifying orders.

For each customer, return:

- `customer_id`
- `email`
- `qualifying_order_count`
- `qualifying_total`

An order qualifies only when:

- its status is `COMPLETED` or `SHIPPED`; and
- `created_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'`; and
- `created_at < TIMESTAMPTZ '2026-01-01 00:00:00+00'`.

Result rules:

- A customer with no qualifying orders must have count `0` and total `0`.
- Return exactly one row per `MEA` customer.
- Sort by `qualifying_total` descending, then `customer_id` ascending.
- Do not change the schema or data during the independent attempt.

## Deliverables

1. Put the query in `query.sql`.
2. Complete `NOTES.md` before running a plan.
3. Run the query and check that the result obeys the requirements.
4. Predict the important plan behavior, then run one safe `EXPLAIN (ANALYZE, BUFFERS)`.
5. Record the important observed plan facts in `NOTES.md`.
6. Propose exactly one composite index and explain:
   - why the column order fits this query;
   - which work it may reduce;
   - one write or storage cost;
   - whether the planner is guaranteed to use it.

## Commands

Run these from `labs/postgres-query-optimization`:

```bash
./scripts/run-query.sh query exercises/dotin-day2-block1/query.sql
./scripts/run-query.sh analyze exercises/dotin-day2-block1/query.sql
```

`EXPLAIN ANALYZE` executes the query, but this runner accepts only read-only SQL against the local synthetic database.

## Scoring: 10 points

- 3 points: correct join, filter, and projection
- 2 points: preserves zero-order customers and produces correct zero values
- 1 point: correct aggregation and grouping
- 2 points: defensible composite index and trade-off
- 2 points: accurate interpretation of observed plan evidence

Target floor: **8/10**.

