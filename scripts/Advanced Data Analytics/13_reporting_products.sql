/*
product report

1) gather essential fields such as product name, category, subcategory,
cost.
2) segment products by revenue to identify high-performance, mid-range
or low performance
3) aggregate product-level metrics:
total orders
total sales
total quantity sold,
total customers
lifespan
4) calculate value kpi's
recency(months since last sale)
average order revenue
average monthly revenue
*/

CREATE VIEW gold.report_products AS 
WITH base_query AS(
SELECT
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
f.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key=p.product_key
WHERE order_date IS NOT NULL
)

, product_aggregations AS (
SELECT
product_key,
product_name,
category,
subcategory,
cost,
DATEDIFF(month,MIN(order_date),MAX(order_date)) AS lifespan,
COUNT(DISTINCT order_number) AS total_orders,
MAX(order_date) AS last_order_date,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity_sold,
ROUND(AVG(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0)),1) avg_selling_price
FROM base_query
GROUP BY
product_key,
product_name,
category,
subcategory,
cost
)

/*
recency(months since last sale)
average order revenue
average monthly revenue
*/
SELECT
product_key,
product_name,
category,
subcategory,
cost,
last_order_date,
DATEDIFF(month,last_order_date,GETDATE()) AS recency_in_months,
CASE WHEN total_sales>50000 THEN 'High-Performer'
	 WHEN total_sales>=10000 THEN 'Mid-Range'
	 ELSE 'Low Performer'
END AS product_segment,
lifespan,
total_orders,
total_sales,
total_quantity_sold,
total_customers,
avg_selling_price,
CASE WHEN total_orders=0 THEN 0
	 ELSE total_sales/total_orders
END AS avg_order_revenue,
CASE WHEN lifespan=0 THEN total_sales
	 ELSE total_sales/lifespan
END AS avg_monthly_revenue
FROM product_aggregations
