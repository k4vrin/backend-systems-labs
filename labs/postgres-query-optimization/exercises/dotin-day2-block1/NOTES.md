# Attempt Notes

## Before running the query

- Which predicates belong in `ON`, and which belong in `WHERE`? Why?
- What does `COUNT(...)` need to count so a customer with no match produces zero?
- What must be converted from `NULL` to zero?

## Plan prediction

- Expected scan and join strategy:
- Expected expensive work:
- Expected rows or selectivity:

## Observed `EXPLAIN (ANALYZE, BUFFERS)` facts

- Scan and join nodes:
- Estimated rows versus actual rows:
- Rows removed by filters, loops, and buffer activity:
- Sort or aggregate behavior:
- Execution time:

## One proposed composite index

```sql
-- Write the CREATE INDEX statement here; do not execute it during the attempt.
```

- Why this column order fits the query:
- Work it may reduce:
- Write or storage cost:
- Is PostgreSQL guaranteed to use it? Why or why not?

## Brief complexity statement

- Explain the dominant database work in terms of rows scanned, joined, and sorted. Exact Big-O notation is optional.

