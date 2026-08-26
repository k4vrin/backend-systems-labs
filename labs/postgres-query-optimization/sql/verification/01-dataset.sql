\echo 'Verifying deterministic dataset invariants'

SELECT count(*) = :expected_order_count::BIGINT AS order_count_matches
FROM orders
\gset

\if :order_count_matches
\else
  \echo 'Unexpected order count'
  \quit 1
\endif

SELECT count(*) = 0 AS no_orphan_items
FROM order_items item
LEFT JOIN orders order_row ON order_row.id = item.order_id
WHERE order_row.id IS NULL
\gset

\if :no_orphan_items
\else
  \echo 'Found orphaned order items'
  \quit 1
\endif

SELECT
    count(*) AS orders,
    count(DISTINCT user_id) AS customers_with_orders,
    min(created_at) AS earliest_order,
    max(created_at) AS latest_order
FROM orders;

SELECT status, count(*) AS rows
FROM orders
GROUP BY status
ORDER BY rows DESC;
