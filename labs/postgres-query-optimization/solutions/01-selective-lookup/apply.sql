CREATE INDEX idx_orders_user_created_at_desc
    ON orders (user_id, created_at DESC);
