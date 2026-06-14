/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/


 -- Cumulative anlaysis

 -- total sales per year and running total of sales over time
 SELECT 
	year
	,total_sales
	,SUM(total_sales) OVER(ORDER BY year ) as running_total_sales
	,avg_price
	,AVG(avg_price) OVER(ORDER BY year) as moving_avg_price
FROM
     (SELECT 
    	DATETRUNC(year,order_date ) AS year
       ,SUM(sales_amount) AS total_sales
       ,AVG(price) AS avg_price
     
    FROM 
    	gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY 
    	DATETRUNC(year,order_date )
	) AS B
