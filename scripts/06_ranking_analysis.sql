/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

--Which five products generate the highest revenue

SELECT TOP(5)
	 p.product_name
	,SUM(s.sales_amount) AS total_revenue
	
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC


-- Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

--What are the five worst performing products in terms of total sales

SELECT TOP(5)
	 p.product_name
	,SUM(s.sales_amount) AS total_revenue
	
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue 

-- top five categories by revenue

SELECT TOP(5)
	 p.category
	,SUM(s.sales_amount) AS total_revenue
	
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue 

 -- Top 10 customers by revenue

SELECT  TOP 10
c.customer_key,
		first_name
		,last_name  
		,SUM(sales_amount) as total_revenue
		,DENSE_RANK() OVER( ORDER BY SUM(sales_amount) DESC) AS rnk
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
GROUP BY c.customer_key 
		,first_name
		,last_name

ORDER BY total_revenue DESC



-- three customers with few orders placed
SELECT TOP 3
c.customer_key,
	first_name
	,last_name  
	,COUNT(DISTINCT order_number) as total_orders
			   
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key,
			   first_name
			   ,last_name  
ORDER BY total_orders 
