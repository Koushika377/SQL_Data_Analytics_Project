-- find the total sales
select sum(sales_amount) as total_sales from gold.fact_sales

-- find how many items are sold
select sum(quantity) as total_quantity from gold.fact_sales

-- find the avg selling price
select avg(price) as avg_price from gold.fact_sales

-- find the total no of orders
select count(distinct order_number) as total_orders from gold.fact_sales

-- find the total no of products
select count(distinct product_key) as total_products from [gold].[dim_products]

-- find the total no of customers
select count(customer_key) as total_customers from [gold].[dim_customers]

-- find the total no of customers that has placed an order
select count(distinct customer_key) as total_customers from gold.fact_sales


-- Generate a Report that shows all key metrics of the business

SELECT 'Total Sales' as measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total no of Orders', count(distinct order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total no of Products', count(product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total no of Customers', count(customer_key) FROM gold.dim_customers
