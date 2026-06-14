/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO
  
CREATE VIEW gold.products_report AS

WITH base_query AS 
(
    /*---------------------------------------------------------------------------
      1) Base Query: Retrieves core columns from fact_sales and dim_products
    ---------------------------------------------------------------------------*/
		SELECT s.order_number
			,s.customer_key
			,s.order_date
			,s.sales_amount
			,s.quantity
			,p.product_key
			,p.product_name
			,p.category
			,p.subcategory
			,p.product_cost
		FROM 
			gold.fact_sales s
		LEFT JOIN gold.dim_products p
			ON s.product_key = p.product_key
		WHERE order_date IS NOT NULL
),

products_aggregation AS
(

  /*---------------------------------------------------------------------------
    2) Product Aggregations: Summarizes key metrics at the product level
    ---------------------------------------------------------------------------*/
SELECT 
	product_key
	,product_name
	,category
	,subcategory
	,product_cost
	,SUM(sales_amount) AS total_sales
	,SUM(quantity) AS total_quantity
	,ROUND(AVG(CAST(sales_amount  AS FLOAT) / NULLIF(quantity,0)),2) AS avg_selling_price
	,COUNT(DISTINCT order_number) AS total_orders
	,COUNT(DISTINCT customer_key) AS total_customers
	,MIN(order_date) AS first_order
	,MAX(order_date) AS last_order
	,DATEDIFF(MONTH, MIN(order_date) ,MAX(order_date) )AS life_span_months

FROM 
	base_query

GROUP BY 
	product_key
	,product_name
	,category
	,subcategory
	,product_cost
)

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/

  
SELECT 
	product_key
	,product_name
	,category
	,subcategory
	,product_cost
	,avg_selling_price
	,total_sales
	,CASE 
		WHEN total_sales <50000 THEN 'Low-Perfomers'
		WHEN total_sales <250000 THEN 'Mid-Range'
		ELSE 'High Performers'
	 END AS performance
	,total_quantity
	,total_orders
	,CASE 
		WHEN total_orders =0 THEN total_sales
		ELSE total_sales /total_orders
	 END AS avg_order_value

	,CASE 
		WHEN life_span_months =0 THEN total_sales
		ELSE total_sales / life_span_months
	 END AS avg_monthly_revenue

	,total_customers
	,first_order
	,last_order
	,life_span_months
	,DATEDIFF(MONTH,last_order,GETDATE()) AS recency

FROM 
products_aggregation



