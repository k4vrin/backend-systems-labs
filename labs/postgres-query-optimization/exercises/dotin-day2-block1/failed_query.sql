SELECT c.id                      AS customer_id,
       c.email,
       COUNT(o.id)               AS failed_order_count,
       COALESCE(SUM(o.total), 0) AS failed_total
FROM customers c
         LEFT JOIN orders o
                   ON o.user_id = c.id
                       AND o.status IN ('FAILED', 'CANCELLED')
                       AND o.created_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'
    AND o.created_at < TIMESTAMPTZ '2026-01-01 00:00:00+00'
WHERE c.region = 'APAC'
GROUP BY c.id, c.email
ORDER BY failed_order_count DESC, customer_id ASC;
