WITH tab AS (
    SELECT
        c.customer_id,
        s.sale_date,
        p.price,
        s.quantity
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    JOIN products p ON s.product_id = p.product_id
)
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(price * quantity), 0) AS income
FROM tab
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY TO_CHAR(sale_date, 'YYYY-MM');