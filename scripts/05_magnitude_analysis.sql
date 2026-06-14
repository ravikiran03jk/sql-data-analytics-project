/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

--Find the total number of customers by country
SELECT country, COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY COUNT(DISTINCT customer_key) DESC


--Find the total number of customers by gender

--Find the total number of customers by country
SELECT gender, COUNT( customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

-- Find total products by category
SELECT category 
	,COUNT(product_key) as total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC
	 
--What is the average cost in each category
SELECT category
	, AVG(product_cost) as avg_product_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_product_cost 

--What is the total revenue generated for each category

SELECT
	 p.category
	
	,SUM(s.sales_amount) AS total_revenue
	
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY category
ORDER BY total_revenue DESC

--What is the total revenue generated for each customer

SELECT 
	 c.customer_key
	,c.first_name
	,c.last_name
	,SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key

GROUP BY c.customer_key ,c.first_name,c.last_name
ORDER BY total_revenue DESC

---What is the distribution of items sold across countries

SELECT country
	,SUM(quantity) as items_sold
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
GROUP BY country
ORDER BY items_sold DESC
