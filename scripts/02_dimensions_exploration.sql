/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/


-- Explore the dimensions  in customers table( unique values / categories  in each dimesion) 

SELECT DISTINCT country FROM gold.dim_customers
SELECT DISTINCT marital_status FROM gold.dim_customers
SELECT DISTINCT gender FROM gold.dim_customers
 
-- Explore all the categories  in the products table(Major divisions) 

SELECT  DISTINCT
    category
   ,subcategory
   ,product_name
FROM gold.dim_products
ORDER BY 1,2,3

