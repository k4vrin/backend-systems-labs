SELECT c.id                    AS customer_id,
       c.email                 AS email,
       COUNT(o.id)               AS paid_order_count,
       COALESCE(SUM(o.total),0) AS paid_total
FROM customers c
         LEFT JOIN orders o
                   ON o.user_id = c.id
                       AND o.status IN ('PAID')
                       AND o.created_at >= TIMESTAMPTZ '2025-10-01 00:00:00+00'
                       AND o.created_at < TIMESTAMPTZ '2026-01-01 00:00:00+00'
WHERE c.region = 'EU'
GROUP BY c.id, c.email
ORDER BY paid_total DESC, customer_id ASC;
