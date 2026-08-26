\echo 'Verifying Exercise 01 result invariants'

WITH result AS MATERIALIZED (
    SELECT id, user_id, status, created_at, total
    FROM orders
    WHERE user_id = 42
      AND created_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'
    ORDER BY created_at DESC
    LIMIT 25
), checks AS (
    SELECT
        count(*) BETWEEN 0 AND 25 AS valid_row_count,
        count(*) = LEAST(
            25,
            (SELECT count(*) FROM orders WHERE user_id = 42 AND created_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00')
        ) AS expected_row_count,
        COALESCE(bool_and(user_id = 42), true) AS correct_customer,
        COALESCE(bool_and(created_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'), true) AS correct_date_range,
        count(*) = count(DISTINCT id) AS unique_orders,
        NOT EXISTS (
            SELECT 1
            FROM orders candidate
            WHERE candidate.user_id = 42
              AND candidate.created_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'
              AND candidate.id NOT IN (SELECT id FROM result)
              AND candidate.created_at > (SELECT min(created_at) FROM result)
        ) AS no_newer_order_omitted
    FROM result
)
SELECT
    valid_row_count
    AND expected_row_count
    AND correct_customer
    AND correct_date_range
    AND unique_orders
    AND no_newer_order_omitted AS result_is_correct
FROM checks
\gset

\if :result_is_correct
  \echo 'Exercise 01 result invariants passed'
\else
  \echo 'Exercise 01 result invariants failed'
  \quit 1
\endif
