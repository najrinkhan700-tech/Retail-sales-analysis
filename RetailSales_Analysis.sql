CREATE DATABASE RetailSalesDB
use RetailSalesDB
select top 20 * from sample_superstore

-- 1. What is the total sales and profit by category?
select category, 
		SUM(sales) as 'Total Sales', 
		SUM(profit) as 'Total Profit'
from sample_superstore
group by category
order by 'Total Sales', 'Total Profit' Desc;


-- 2. Which sub-category is generating the most loss?
select 
		[sub-category],
		SUM(profit) as 'Total Profit'
from sample_superstore
group by [sub-category]
order by 'Total Profit';


-- 3. What is the sales and profit performance by region?
select region,
			SUM(sales) as 'Total Sales',
			SUM(profit) as 'Total Profit'
From sample_superstore
group by region
order by 'Total Profit' Desc;


-- 4. What does the month-wise sales trend look like (seasonality)?
select 
		YEAR(order_date) as Order_year,
		MONTH(order_date) as Order_month,
		SUM(sales) as 'Total Sales'
From sample_superstore
Group by YEAR(order_date), MONTH(order_date)
order by Order_year, Order_month;

-- 5. What are the top 10 best-selling products?
SELECT TOP 10
			product_id,
			product_name,
			SUM(quantity) as 'Total Quantity',
			SUM(sales) as 'Total Sales'
FROM sample_superstore
Group by product_id, product_name
Order by 'Total Sales' DESC;


-- 6. What are the top 10 products causing the most loss?
SELECT TOP 10 
			product_id,
			product_name,
			SUM(profit) as 'Total Profit'
from sample_superstore
group by product_id, product_name
order by 'Total Profit' ASC ;


-- 7. What is the relationship between discount and profit?
SELECT 
	  category,
	  AVG(discount) as 'Average Discount',
	  AVG(profit) as 'Average Profit',
	  SUM(profit) as 'Total Profit'
From sample_superstore
Group by category
order by 'Average Discount' DESC;
--What this does: It shows the average discount and average/total profit for each category — 
--so you can see whether categories with higher discounts tend to have lower or negative profit.



-- 8. Which customers are the most valuable (top spenders)?
SELECT TOP 10
			customer_id,
			customer_name,
			SUM(sales) as 'Total Sales',
			SUM(profit) as 'Total Profit'
From sample_superstore
Group by customer_id, customer_name
order by 'Total Sales' DESC;



-- 9. What is the average shipping/delivery time?
SELECT 
	 ship_mode,
	 AVG(DATEDIFF(day, order_date, ship_date)) AS Avg_shipping_days
From sample_superstore
group by ship_mode
order by Avg_shipping_days ASC;
--What this does: It calculates the average number of days between order date and ship date,
--grouped by ship mode — so you can see which shipping method is fastest/slowest.


-- 10. What percentage of total orders result in a loss?
SELECT 
	COUNT(CASE WHEN profit < 0 THEN 1 END) as loss_orders,
	COUNT(*) AS Total_Orders,
	CAST(COUNT(CASE WHEN profit < 0 THEN 1 END) AS FLOAT) * 100 / COUNT(*) AS loss_Percentage
FROM sample_superstore;
--What this does: It counts how many orders have negative profit, divides that by the 
--total number of orders, and gives you the percentage of orders that result in a loss.



-- 11. Bonus: What is the month-over-month sales growth %?
WITH monthly_sales AS(
		select 
			YEAR(order_date) as Order_year,
			MONTH(order_date) as Order_month,
			SUM(sales) as Total_sales
from sample_superstore
group by YEAR(Order_date), MONTH(Order_date)
)
SELECT 
	Order_year,
	Order_month,
	Total_sales,
	LAG(Total_sales) OVER (ORDER BY Order_month) AS previous_month_sales,
	CAST((Total_sales - LAG(Total_sales) OVER (ORDER BY Order_year, Order_month)) AS FLOAT)
	/ LAG(Total_sales) OVER (ORDER BY Order_year, Order_month) * 100 as growth_percentage
FROM monthly_sales
order by Order_year, Order_month;
--First (WITH monthly_sales) it calculates total sales for each month
--Then LAG() pulls the previous month's sales into the same row
--Finally it calculates the % growth compared to the previous month



-- 12. Bonus: How does ship mode affect sales/profit?
SELECT 
		ship_mode,
		COUNT(*) as Total_orders,
		SUM(sales) as Total_sales,
		SUM(profit) as Total_profit,
		AVG(profit) as Avg_profit
from sample_superstore
group by ship_mode
order by Total_sales DESC;
--shows total orders, total sales, total profit, and average profit per order — 
--so you can see which shipping method is used most and whether it affects profitability.