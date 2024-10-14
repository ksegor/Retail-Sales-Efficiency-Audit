with tab as (
select
c.customer_id,
concat(c.first_name, ' ', c.last_name) as customer,
MIN(s.sale_date) as sale_date,
concat(e.first_name, ' ', e.last_name) as seller
from customers c
join sales s on
c.customer_id = s.customer_id
join employees e on
s.sales_person_id = e.employee_id
join products p on
s.product_id = p.product_id
where p.price = 0
group by c.first_name, c.customer_id, c.last_name, e.first_name, e.last_name
order by sale_date
)
select
customer,
sale_date,
seller
from tab
where sale_date in (
select min(sale_date)
from sales s group by customer_id
)
order by customer;