-- FILE 2: SAMPLE DATA INSERTION (DML)
-- This file inserts the sample data used to test the analytics.

USE retail_analytics;

-- A. INSERT MASTER DATA
INSERT INTO payment_methods (id, method_name, active) VALUES
(1, 'Credit Card', TRUE),
(2, 'Cash', TRUE);

INSERT INTO sales_channels (id, channel_name, active) VALUES
(1, 'E-commerce', TRUE),
(2, 'Retail Store', TRUE);

INSERT INTO customers (id, name, email, phone, created_at) VALUES
(101, 'Alice Johnson', 'alice@example.com', '555-1234', NOW());

INSERT INTO products (id, name, sku, category, base_price, active) VALUES
(1, 'Laptop Pro', 'LPT-001', 'Electronics', 1200.00, TRUE),
(2, 'Coffee Mug', 'MUG-010', 'Homeware', 15.00, TRUE);

-- B. INSERT TRANSACTIONAL DATA (Using dates 60 days in the past for robust testing)
SET @reference_date = DATE_SUB(NOW(), INTERVAL 45 DAY); -- Ensures data falls within the 60-day filter

-- Sale 1: E-commerce sale (Laptop, full price)
INSERT INTO sales (id, customer_id, sale_date, payment_method_id, total_amount, sales_channel_id) VALUES
(1001, 101, DATE_ADD(@reference_date, INTERVAL 5 DAY), 1, 1200.00, 1);
INSERT INTO sale_line_items (id, sale_id, quantity, unit_price, product_id) VALUES
(2001, 1001, 1, 1200.00, 1); 

-- Sale 2: Retail Store sale (Mugs, discounted)
INSERT INTO sales (id, customer_id, sale_date, payment_method_id, total_amount, sales_channel_id) VALUES
(1002, 101, DATE_ADD(@reference_date, INTERVAL 15 DAY), 2, 28.00, 2);
INSERT INTO sale_line_items (id, sale_id, quantity, unit_price, product_id) VALUES
(2002, 1002, 2, 14.00, 2); -- Discounted from $15.00 base price