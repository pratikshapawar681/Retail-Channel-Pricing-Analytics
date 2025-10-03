-- FILE 4: OPTIONAL ANALYTICS AUTOMATION (Stored Procedure)
-- This procedure automates the Monthly Revenue report for easy use.

USE retail_analytics;

-- Set delimiter to allow MySQL to parse the procedure block
DELIMITER $$

-- Stored Procedure to calculate Monthly Revenue (Query 1)
CREATE PROCEDURE GetMonthlyRevenueReport()
BEGIN
    -- This query uses the original strict monthly filter logic 
    SELECT
        DATE_FORMAT(s.sale_date, '%Y-%m') AS sale_month,
        sc.channel_name,
        pm.method_name,
        SUM(s.total_amount) AS total_monthly_revenue
    FROM
        sales s
    JOIN
        sales_channels sc ON s.sales_channel_id = sc.id
    JOIN
        payment_methods pm ON s.payment_method_id = pm.id
    WHERE
        s.sale_date >= DATE_SUB(LAST_DAY(NOW()), INTERVAL 1 MONTH) + INTERVAL 1 DAY
        AND s.sale_date < DATE_SUB(LAST_DAY(NOW()), INTERVAL 0 MONTH) + INTERVAL 1 DAY
    GROUP BY
        1, 2, 3
    ORDER BY
        sale_month DESC, total_monthly_revenue DESC;
END $$

-- Reset delimiter back to semicolon
DELIMITER ;