
SELECT c.id AS customer_id,
       c.email,
       COUNT(o.id) AS qualifying_order_count,
       COALESCE(SUM(o.total), 0) AS qualifying_total
FROM customers c
LEFT JOIN orders o
    ON o.user_id = c.id
    AND o.status IN ('COMPLETED', 'SHIPPED')
    AND o.created_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'
    AND o.created_at < TIMESTAMPTZ '2026-01-01 00:00:00+00'
WHERE c.region = 'MEA'
GROUP BY c.id, c.email
ORDER BY qualifying_total DESC, customer_id ASC;
