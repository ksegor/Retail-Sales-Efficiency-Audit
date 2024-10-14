
with average_income as (
select sales_person_id,
floor(sum(quantity * price)/ count(sales_id)) as avg_income
from sales s
join products p on
s.product_id = p.product_id
group by sales_person_id
),
overall_average as (
select floor(avg(avg_income)) as overall_avg
from average_income
)
select concat(e.first_name,' ', e.last_name) as seller,
ai.avg_income as average_income
from average_income ai
join employees e on
ai.sales_person_id = e.employee_id
where
ai.avg_income < (select overall_avg from overall_average)
order by average_income asc;