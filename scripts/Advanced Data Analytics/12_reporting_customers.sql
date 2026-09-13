/*
Customer Report
1)gather essential fields such as names, ages, and transaction details.
2)segments customers into categories(VIP, Regular, new) and age groups
3)aggregate customer-level metrics
 total orders
 total sales
 total quantity purchased
 total products
 lifespan(in months)
 4)calculate valuable KPI's:
  recency(months since last order)
  average order value
  average monthly spend
*/

/*
step-by-step process
1) base query: retrives core columns from the tables
2) aggregate customer_level metrics
3) segment the customers
4)caluculate KPI's
*/
CREATE VIEW gold.report_customers AS
WITH base_query AS(
-- BASE QUERY
SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
DATEDIFF(year,c.birthdate,GETDATE()) AS age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key=f.customer_key
WHERE order_date IS NOT NULL )

, customer_aggregation AS(
-- CUSTOMER AGGREGATION
SELECT
customer_key,
customer_number,
customer_name,
age,
COUNT(distinct order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(distinct product_key) AS total_products,
MAX(order_date) AS last_order_date,
DATEDIFF(month,MIN(order_date),MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
customer_key,
customer_number,
customer_name,
age
) 


SELECT 
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age<20 THEN 'Under 20'
	 WHEN age BETWEEN 20 AND 29 THEN '20-29'
	 WHEN age BETWEEN 30 AND 39 THEN '30-39'
	 WHEN age BETWEEN 40 AND 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE WHEN lifespan>=12 AND total_sales >5000 THEN 'VIP'
	 WHEN lifespan>=12 AND total_sales <=5000 THEN 'Regular'
	 ELSE 'New'
END customer_segment,
last_order_date,
DATEDIFF(month,last_order_date,GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
-- avg order value
CASE WHEN total_sales=0 THEN 0
	 ELSE total_sales/total_orders 
END AS avg_order_value,
--average monthly spend
CASE WHEN lifespan=0 THEN total_sales
	 ELSE total_sales/lifespan
END AS avg_monthly_spend
FROM customer_aggregation
