-- FILE 3: MONTHLY ANALYTICS REPORTS (DQL)
-- These queries generate the reports management requested.
-- Note: Using the last 60 days filter for reliable testing on any system date.

USE retail_analytics;

-- 1. TOTAL REVENUE BY CHANNEL AND PAYMENT METHOD
SELECT
    DATE_FORMAT(s.sale_date, '%Y-%m') AS sale_month,
    sc.channel_name,
    pm.method_name,
    SUM(s.total_amount) AS total_monthly_revenue
FROM
    sales s
JOIN sales_channels sc ON s.sales_channel_id = sc.id
JOIN payment_methods pm ON s.payment_method_id = pm.id
WHERE
    s.sale_date >= DATE_SUB(NOW(), INTERVAL 60 DAY)
GROUP BY
    1, 2, 3
ORDER BY
    sale_month DESC, total_monthly_revenue DESC;


-- 2. AVERAGE ORDER VALUE (AOV) BY CHANNEL
SELECT
    DATE_FORMAT(s.sale_date, '%Y-%m') AS sale_month,
    sc.channel_name,
    COUNT(s.id) AS total_orders,
    SUM(s.total_amount) AS total_revenue,
    SUM(s.total_amount) / COUNT(s.id) AS average_order_value_aov
FROM
    sales s
JOIN sales_channels sc ON s.sales_channel_id = sc.id
WHERE
    s.sale_date >= DATE_SUB(NOW(), INTERVAL 60 DAY)
GROUP BY
    1, 2
ORDER BY
    sale_month DESC, average_order_value_aov DESC;


-- 3. PRICE DEVIATION ANALYTICS (Unit Price vs. Base Price)
SELECT
    DATE_FORMAT(s.sale_date, '%Y-%m') AS sale_month,
    p.category,
    COUNT(sli.id) AS total_line_items,
    AVG(p.base_price - sli.unit_price) AS avg_price_deviation_amount,
    (AVG(p.base_price - sli.unit_price) / AVG(p.base_price)) * 100 AS avg_price_deviation_percent
FROM
    sale_line_items sli
JOIN sales s ON sli.sale_id = s.id
JOIN products p ON sli.product_id = p.id
WHERE
    s.sale_date >= DATE_SUB(NOW(), INTERVAL 60 DAY)
GROUP BY
    1, 2
ORDER BY
    sale_month DESC, avg_price_deviation_percent DESC;