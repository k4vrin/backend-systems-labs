\echo 'Creating query optimization schema'

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id BIGINT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    region TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE products (
    id BIGINT PRIMARY KEY,
    sku TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    price NUMERIC(12, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE orders (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES customers(id),
    status TEXT NOT NULL CHECK (status IN ('PENDING', 'PAID', 'SHIPPED', 'COMPLETED', 'CANCELLED', 'FAILED')),
    created_at TIMESTAMPTZ NOT NULL,
    total NUMERIC(12, 2) NOT NULL CHECK (total >= 0),
    currency CHAR(3) NOT NULL,
    payment_method TEXT NOT NULL,
    shipping_country CHAR(2) NOT NULL,
    notes TEXT
);

CREATE TABLE order_items (
    order_id BIGINT NOT NULL REFERENCES orders(id),
    line_number SMALLINT NOT NULL,
    product_id BIGINT NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, line_number)
);

COMMENT ON TABLE orders IS 'Synthetic skewed workload; secondary indexes are added only by exercises.';
