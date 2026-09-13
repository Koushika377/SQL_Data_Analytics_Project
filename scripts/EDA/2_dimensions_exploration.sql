/*
explore the structure of dimension tables
*/

-- explore all countries our customers come from
SELECT DISTINCT country 
FROM gold.dim_customers

-- explore all categories "the major divisions"
select distinct category,subcategory,product_name 
from gold.dim_products
order by 1,2,3
