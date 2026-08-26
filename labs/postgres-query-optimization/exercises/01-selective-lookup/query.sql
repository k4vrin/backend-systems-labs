-- Predict the access path, rows inspected, sort work, and useful index before execution.
SELECT id, status, created_at, total
FROM orders
WHERE user_id = 42
  AND created_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'
ORDER BY created_at DESC
LIMIT 25;
