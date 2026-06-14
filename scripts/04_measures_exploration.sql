/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/


--Find the total sales
SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales

--Find the number of the items sold
SELECT SUM(quantity)  as no_of_items_sold
FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) as avg_selling_price
FROM gold.fact_sales

-- Find the total no of orders
SELECT COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales

--Find the total no of customers
SELECT COUNT(customer_key) AS total_customers
FROM gold.dim_customers

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers 
FROM gold.fact_sales;
