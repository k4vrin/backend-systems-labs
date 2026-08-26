\echo 'Seeding deterministic customers, products, orders, and order items'

\if :{?order_count}
\else
  \set order_count 1000000
\endif

CREATE TEMP TABLE seed_config AS
SELECT
    :order_count::BIGINT AS order_count,
    GREATEST(2000, (:order_count / 5))::BIGINT AS customer_count,
    LEAST(10000, GREATEST(1000, (:order_count / 100)))::BIGINT AS product_count;

INSERT INTO customers (id, email, region, created_at)
SELECT
    customer_id,
    'user-' || customer_id || '@example.test',
    CASE customer_id % 5
        WHEN 0 THEN 'EU'
        WHEN 1 THEN 'NA'
        WHEN 2 THEN 'APAC'
        WHEN 3 THEN 'MEA'
        ELSE 'LATAM'
    END,
    TIMESTAMPTZ '2021-01-01 00:00:00+00' + ((customer_id % 1095) * INTERVAL '1 day')
FROM seed_config
CROSS JOIN LATERAL generate_series(1, customer_count) AS customer_id;

INSERT INTO products (id, sku, category, price)
SELECT
    product_id,
    'SKU-' || lpad(product_id::TEXT, 6, '0'),
    CASE product_id % 6
        WHEN 0 THEN 'BOOKS'
        WHEN 1 THEN 'ELECTRONICS'
        WHEN 2 THEN 'HOME'
        WHEN 3 THEN 'SPORT'
        WHEN 4 THEN 'FOOD'
        ELSE 'OTHER'
    END,
    (500 + ((product_id * 37) % 250000))::NUMERIC / 100
FROM seed_config
CROSS JOIN LATERAL generate_series(1, product_count) AS product_id;

INSERT INTO orders (
    id,
    user_id,
    status,
    created_at,
    total,
    currency,
    payment_method,
    shipping_country,
    notes
)
SELECT
    order_id,
    CASE
        WHEN order_id % 10 < 3 THEN 1 + (order_id % 1000)
        ELSE 1001 + (order_id % (customer_count - 1000))
    END,
    CASE
        WHEN order_id % 100 < 50 THEN 'COMPLETED'
        WHEN order_id % 100 < 75 THEN 'SHIPPED'
        WHEN order_id % 100 < 87 THEN 'PENDING'
        WHEN order_id % 100 < 93 THEN 'PAID'
        WHEN order_id % 100 < 98 THEN 'CANCELLED'
        ELSE 'FAILED'
    END,
    TIMESTAMPTZ '2024-01-01 00:00:00+00'
        + ((order_id % 730) * INTERVAL '1 day')
        + ((order_id % 86400) * INTERVAL '1 second'),
    (1000 + ((order_id * 97) % 500000))::NUMERIC / 100,
    CASE WHEN order_id % 10 < 8 THEN 'USD' ELSE 'EUR' END,
    CASE order_id % 4
        WHEN 0 THEN 'CARD'
        WHEN 1 THEN 'WALLET'
        WHEN 2 THEN 'BANK'
        ELSE 'COD'
    END,
    CASE order_id % 6
        WHEN 0 THEN 'US'
        WHEN 1 THEN 'DE'
        WHEN 2 THEN 'GB'
        WHEN 3 THEN 'CA'
        WHEN 4 THEN 'JP'
        ELSE 'AE'
    END,
    CASE WHEN order_id % 20 = 0 THEN repeat('priority note ', 8) END
FROM seed_config
CROSS JOIN LATERAL generate_series(1, order_count) AS order_id;

INSERT INTO order_items (order_id, line_number, product_id, quantity, unit_price)
SELECT
    order_id,
    line_number::SMALLINT,
    1 + ((order_id * 13 + line_number * 17) % product_count),
    1 + ((order_id + line_number) % 4)::INTEGER,
    (500 + ((order_id * 31 + line_number * 101) % 250000))::NUMERIC / 100
FROM seed_config
CROSS JOIN LATERAL generate_series(1, order_count) AS order_id
CROSS JOIN LATERAL generate_series(1, 1 + (order_id % 3)::INTEGER) AS line_number;

DROP TABLE seed_config;
