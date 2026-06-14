/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- segment product into cost ranges and count how many products fall into that each range


WITH product_cost_segments AS
(
  SELECT 
  	product_key
  	,product_name
  	,product_cost
  	,CASE
  		WHEN product_cost < 500 THEN 'low'
  		WHEN product_cost <1000 THEN 'Medium'
  		WHEN product_cost < 1500 THEN 'High'
  		ELSE 'Premium'
  	END AS segment
  
  
  FROM gold.dim_products
  )

SELECT segment
	,COUNT(*) AS products
FROM 
	product_cost_segments
GROUP BY 
	segment
ORDER BY products DESC

  
-- customers segment

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_segment AS
(
	SELECT 
		c.customer_key
		,SUM(sales_amount) as total_sales
		,MIN(order_date) as first_order
		,MAX(order_date) as latest_order
		,DATEDIFF(MONTH,MIN(order_date), MAX(order_date) ) AS lifespan

	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers  AS c
		ON c.customer_key = s.customer_key
	GROUP BY 
		c.customer_key
	)


SELECT 
	customer_type
	,count(*) as total_customer
FROM 
(	
		SELECT 
			customer_key
			,CASE 
				WHEN total_sales >5000 and lifespan >=12 THEN 'VIP'
				WHEN total_sales <=5000 and lifespan >=12 THEN 'Regular'
				ELSE 'New'
			END AS customer_type
		FROM
			customer_segment
) as b


GROUP BY 
	customer_type
ORDER BY count(*) DESC
