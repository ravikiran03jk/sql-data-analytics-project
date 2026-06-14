/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
-- Analyse sales performance over time

SELECT 
   YEAR(order_date) AS year
	,MONTH(order_date) AS Month

	,SUM(sales_amount) AS total_sales
	,SUM(quantity) AS total_quantity
	,COUNT(DISTINCT customer_key ) AS total_customers
FROM
gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(order_date)
  ,MONTH(order_date)
ORDER BY
	YEAR(order_date)
   ,MONTH(order_date)

  
-- using DATETRUNC()

SELECT 
   DATETRUNC(YEAR,order_date) AS date
	,SUM(sales_amount) AS total_sales
	,SUM(quantity) AS total_quantity
	,COUNT(DISTINCT customer_key ) AS total_customers
FROM
gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	DATETRUNC(YEAR,order_date)
ORDER BY
	DATETRUNC(YEAR,order_date)

  
--Using FORMAT()
SELECT 
  FORMAT(order_date,'yyyy-MMM') AS date
	,SUM(sales_amount) AS total_sales
	,SUM(quantity) AS total_quantity
	,COUNT(DISTINCT customer_key ) AS total_customers
FROM
gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	FORMAT(order_date,'yyyy-MMM')
ORDER BY
	FORMAT(order_date,'yyyy-MMM')
