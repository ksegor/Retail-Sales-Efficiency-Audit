CUSTOMERS_COUNT


SELECT COUNT(*) AS customers_count
FROM customers;


Этот запрос подсчитывает общее количество покупателей в таблице customers и возвращает результат в колонке с именем customers_count. Он использует функцию COUNT(*), которая считает все строки в таблице, не учитывая, есть ли в них значения NULL.


top_10_total_income


SELECT
   CONCAT(e.first_name, ' ', e.last_name) AS seller,
   COUNT(s.sales_id) AS operations,
   FLOOR(SUM(p.price * s.quantity)) AS income
   FROM
   employees e
JOIN
   sales s ON e.employee_id = s.sales_person_id
JOIN
   products p ON s.product_id = p.product_id
GROUP BY
   e.employee_id
ORDER BY
   income DESC
LIMIT 10;


Этот запрос извлекает информацию о десяти лучших продавцах на основе их общей выручки. Он выполняет следующие действия:
1. Выбор данных:
   * CONCAT(e.first_name, ' ', e.last_name) AS seller: Объединяет имя и фамилию продавца в одну строку и называет эту колонку seller.
   * COUNT(s.sales_id) AS operations: Подсчитывает количество сделок, совершенных каждым продавцом, и называет эту колонку operations.
   * FLOOR(SUM(p.price * s.quantity)) AS income: Вычисляет общую выручку от продаж, умножая цену товара на количество проданных единиц, суммирует эти значения и округляет результат вниз до целого числа. Эта колонка называется income.

2. Объединение таблиц:
* FROM employees e: Начинает выборку из таблицы сотрудников.
* JOIN sales s ON e.employee_id = s.sales_person_id: Объединяет таблицу employees с таблицей sales по полю employee_id, чтобы получить информацию о продажах, совершенных каждым сотрудником.
*JOIN products p ON s.product_id = p.product_id: Объединяет таблицу sales с таблицей products по полю product_id, чтобы получить информацию о товарах, которые были проданы.

3. Группировка данных:
* GROUP BY e.employee_id: Группирует результаты по идентификатору сотрудника, чтобы агрегировать данные по каждому продавцу.

4. Сортировка и ограничение результатов:
* ORDER BY income DESC: Сортирует результаты по общей выручке в порядке убывания.
* LIMIT 10: Ограничивает вывод до десяти записей, чтобы получить только лучших продавцов.



day_of_the_week_income


SELECT
   CONCAT(e.first_name, ' ', e.last_name) AS seller,
   TO_CHAR(s.sale_date, 'Day') AS day_of_week,
   FLOOR(SUM(p.price * s.quantity)) AS income
FROM
   employees e
JOIN
   sales s ON e.employee_id = s.sales_person_id
JOIN
   products p ON s.product_id = p.product_id
GROUP BY
    EXTRACT(ISODOW FROM s.sale_date), CONCAT(e.first_name, ' ', e.last_name), TO_CHAR(s.sale_date, 'Day')
   ORDER BY
   EXTRACT(ISODOW FROM s.sale_date), seller;


Этот SQL-запрос выполняет следующие действия:
1. Выбор данных:
* CONCAT(e.first_name, ' ', e.last_name) AS seller: Объединяет имя и фамилию продавца в одну строку и называет эту колонку seller.
* TO_CHAR(s.sale_date, 'Day') AS day_of_week: Извлекает название дня недели из даты продажи и называет эту колонку day_of_week.
* FLOOR(SUM(p.price * s.quantity)) AS income: Вычисляет общую выручку от продаж, умножая цену товара на количество проданных единиц, суммирует эти значения и округляет результат вниз до целого числа. Эта колонка называется income.

2. Объединение таблиц:
* FROM employees e: Начинает выборку из таблицы сотрудников.
* JOIN sales s ON e.employee_id = s.sales_person_id: Объединяет таблицу employees с таблицей sales по полю employee_id, чтобы получить информацию о продажах, совершенных каждым сотрудником.
* JOIN products p ON s.product_id = p.product_id: Объединяет таблицу sales с таблицей products по полю product_id, чтобы получить информацию о товарах, которые были проданы.

3. Группировка данных:
* EXTRACT(ISODOW FROM s.sale_date), CONCAT(e.first_name, ' ', e.last_name), TO_CHAR(s.sale_date, 'Day') Группирует результаты по идентификатору сотрудника и дню недели, чтобы агрегировать данные по каждому продавцу и каждому дню.

4. Сортировка результатов:
* EXTRACT(ISODOW FROM s.sale_date), seller: Сортирует результаты по дню недели начиная с понедельника и по имени продавца.



lowest_average_income.


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

1. CTE average_income:
* Этот (CTE) вычисляет средний доход для каждого продавца.
* sales_person_id: Идентификатор продавца.
* FLOOR(SUM(quantity * price) / COUNT(sales_id)) AS avg_income: Вычисляет средний доход, умножая количество проданных товаров на их цену, суммируя эти значения и деля на количество сделок. Результат округляется вниз до целого числа.
* FROM sales s JOIN products p ON s.product_id = p.product_id: Объединяет таблицы sales и products, чтобы получить информацию о продажах и ценах товаров.
* GROUP BY sales_person_id: Группирует результаты по идентификатору продавца.

2. CTE overall_average:
* Этот CTE вычисляет общий средний доход всех продавцов.
* FLOOR(AVG(avg_income)) AS overall_avg: Вычисляет среднее значение из всех средних доходов, полученных в предыдущем CTE, и округляет его вниз до целого числа.

3. Основной запрос:
* SELECT CONCAT(e.first_name, ' ', e.last_name) AS seller: Объединяет имя и фамилию продавца в одну строку и называет эту колонку seller.
* ai.avg_income AS average_income: Извлекает средний доход из CTE average_income.
* FROM average_income ai JOIN employees e ON ai.sales_person_id = e.employee_id: Объединяет CTE average_income с таблицей employees, чтобы получить имена продавцов.
* WHERE ai.avg_income < (SELECT overall_avg FROM overall_average): Фильтрует результаты, оставляя только тех продавцов, чей средний доход ниже общего среднего дохода.
* ORDER BY average_income ASC: Сортирует результаты по среднему доходу в порядке возрастания.


customers_by_month


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
   FLOOR(SUM(price * quantity)) AS income
FROM tab
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY TO_CHAR(sale_date, 'YYYY-MM');

1.
* Создается временная таблица tab, которая объединяет данные из трех таблиц: customers, sales и products.
* В выборке из tab выбираются следующие колонки:
* customer_id — ID покупателя.
* sale_date — дата продажи.
* price — цена товара.
* quantity — количество проданных единиц товара.
2. Основной запрос:
* Из временной таблицы tab выбираются следующие данные:
* TO_CHAR(sale_date, 'YYYY-MM') AS selling_month — преобразует дату продажи в строку формата "ГГГГ-ММ", представляющую месяц продажи.
* COUNT(DISTINCT customer_id) AS total_customers — подсчитывает общее количество уникальных покупателей, совершивших покупки в каждом месяце.
* FLOOR(SUM(price * quantity)) AS income — вычисляет общую выручку за месяц, округляя сумму вниз до ближайшего целого числа.

3. Группировка и сортировка:
* Данные группируются по месяцу продажи (TO_CHAR(sale_date, 'YYYY-MM')), что позволяет получить агрегированные результаты для каждого месяца.
* Результаты сортируются по месяцу продажи в порядке 


special_offer


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
1.
* Создается временная таблица tab, которая объединяет данные из четырех таблиц: customers, sales, employees и products.
* В выборке из tab выбираются следующие колонки:
* customer_id — ID покупателя.
* CONCAT(c.first_name, ' ', c.last_name) AS customer — полное имя покупателя (имя и фамилия).
* MIN(s.sale_date) AS sale_date — минимальная (первая) дата продажи для каждого покупателя.
* CONCAT(e.first_name, ' ', e.last_name) AS seller — полное имя продавца (имя и фамилия).
* Запрос фильтрует только те продажи, где цена товара равна нулю (WHERE p.price = 0).
* Данные группируются по имени и фамилии покупателя, а также имени и фамилии продавца, что позволяет получить уникальные записи для каждого покупателя и продавца.
* Результаты сортируются по дате продажи.

2. Основной запрос:
* Из временной таблицы tab выбираются следующие данные:
* customer — полное имя покупателя.
* sale_date — дата первой продажи.
* seller — полное имя продавца.
* Запрос фильтрует результаты, чтобы оставить только те записи, где дата продажи совпадает с минимальной датой продажи для каждого покупателя. Это достигается с помощью подзапроса:
* SELECT MIN(sale_date) FROM sales s GROUP BY customer_id — находит минимальную дату продажи для каждого покупателя.

3. Сортировка:
* Результаты сортируются по имени покупателя в порядке возрастания.