/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */


WITH products_yearly_sales AS 
(
	SELECT
			YEAR(order_date)  AS order_year
			,p.product_name
			,SUM(s.sales_amount) AS cy_sales
			
		FROM 
			gold.fact_sales s
		LEFT JOIN gold.dim_products p
			ON s.product_key = p.product_key

		WHERE YEAR(order_date)  IS NOT NULL
		GROUP BY 
			YEAR(order_date) ,
			product_name
) 

SELECT *,
	AVG(cy_sales) OVER(PARTITION BY product_name) AS average_sales
	,cy_sales -AVG(cy_sales) OVER(PARTITION BY product_name) as chages
	,CASE 
		WHEN cy_sales -AVG(cy_sales) OVER(PARTITION BY product_name)  >0 THEN 'Above average'
		WHEN cy_sales -AVG(cy_sales) OVER(PARTITION BY product_name)  <0 THEN 'Below average'
		ELSE 'Average' 
	 END AS performace
	 ,LAG(cy_sales) OVER(PARTITION BY product_name ORDER BY order_year ) as py_sales
	 ,cy_sales -LAG(cy_sales) OVER(PARTITION BY product_name ORDER BY order_year ) AS py_comp
	 ,CASE 
		WHEN cy_sales -LAG(cy_sales) OVER(PARTITION BY product_name ORDER BY order_year )  >0 THEN 'increased'
		WHEN cy_sales -LAG(cy_sales) OVER(PARTITION BY product_name ORDER BY order_year ) <0 THEN 'Decreased'
		ELSE 'n/a' 
	 END AS cy_py_growth
FROM products_yearly_sales 
ORDER BY
	product_name
	,order_year
