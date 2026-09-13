-- analyze sales performance overtime
-- yearly sales
select
YEAR(order_date) AS order_year,
SUM(sales_amount) AS total_sales,
COUNT (DISTINCT customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

-- year and month in different column
select
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT (DISTINCT customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date)

-- year+month in same col
select
DATETRUNC(month,order_date) as order_date,
SUM(sales_amount) AS total_sales,
COUNT (DISTINCT customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date)

-- custom format
select
FORMAT(order_date,'yyyy-MMM') as order_date,
SUM(sales_amount) AS total_sales,
COUNT (DISTINCT customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM')
