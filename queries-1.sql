select concat(e.first_name, ' ', e.last_name) as seller,
count(s.sales_id) as operations,
sum(s.quantity * p.price) as income
from sales s
join employees e on
s.sales_person_id = e.employee_id
join products p on
s.product_id = p.product_id
group by e.employee_id 
order by income desc
limit 10;