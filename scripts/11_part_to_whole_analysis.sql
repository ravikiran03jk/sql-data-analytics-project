/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- Which categories contribute the most to overall sales?

WITH category_sales AS 
(
SELECT p.category
	,SUM(s.sales_amount) as total_sales
FROM 
	gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY 
	category

)

SELECT 
	category
	,total_sales
	,SUM(total_sales) OVER() AS total_biz_sales
	,CONCAT(ROUND(CAST(total_sales AS float) /SUM(total_sales) OVER()   * 100.0 ,2),'%') AS percentage_contribution
FROM 
	category_sales

