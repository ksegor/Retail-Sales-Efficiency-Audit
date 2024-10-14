with tab as(
select
c.customer_id,
s.sale_date,
p.price,
s.quantity
from customers c
join sales s on
c.customer_id = s.customer_id
join products p on
s.product_id = p.product_id
)
select
to_char(sale_date, 'YYYY-MM') as selling_month,
count (distinct customer_id) as total_customers,
sum(price * quantity) as income
from tab
group by sale_date
order by sale_date;