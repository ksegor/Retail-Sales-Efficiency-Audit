SELECT 
    concat(e.first_name, ' ', e.last_name) AS seller,
    to_char(sale_date, 'Day') AS day_of_week,
    floor(sum(p.price * s.quantity)) AS income
FROM 
    sales s
JOIN 
    employees e ON s.sales_person_id = e.employee_id
JOIN 
    customers c ON s.customer_id = c.customer_id
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    e.employee_id, sale_date
ORDER BY 
    extract(dow from sale_date), e.last_name, e.first_name;