-- sql Retail Sale Analysis - P1

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT

)

SELECT * FROM retail_sales
LIMIT 50;

-- Data Cleaning
SELECT
	COUNT(*) 
FROM retail_sales

-- 

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
--
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

-- How many sales we have
SELECT COUNT(*) AS total_sale
FROM retail_sales

-- How many Unique customers we have
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales

-- How many categories we have
SELECT COUNT(DISTINCT category) AS total_num_of_categories
FROM retail_sales

-- Names of the category
SELECT DISTINCT category AS category_names
FROM retail_sales

-- Data Analysis & Bussiness Problem

--Q1: Write a sql query to retrive all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

--Q2: Write a SQL query to retreive all transactions where the category is 'Clothing' and 
-- the quantity  sold is more than 3 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	  AND 
	  TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	  AND
	  quantity > 3

-- Q3: Write a sql query to calculate the total sales and totla orders(total_sale) for each category

SELECT category,SUM(total_sale) AS Totla_sale,COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category

-- Q4: Write a SQL query to calculate the average age of the customer who purchasee items from 
-- the 'Beauty' category.

SELECT ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000;

SELECT *
FROM retail_sales
WHERE total_sale > 1000

-- Q6: Write a SQL query to find the total number of transactions made by each gender in each category

SELECT category,gender,COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category,gender
ORDER BY category

-- Q7: Write SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT *
FROM (
	SELECT 
		   EXTRACT(YEAR FROM sale_date) AS year,
		   EXTRACT(MONTH FROM sale_date) AS month_number,
		   TRIM(TO_CHAR(sale_date,'Month')) AS month_name,
		   ROUND(AVG(total_sale)::numeric,2) AS average_sale,
		   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)::numeric,2) DESC) AS sales_rank
	FROM retail_sales
	GROUP BY year,month_number,month_name
) AS t1
WHERE sales_rank = 1
-- ORDER BY year,average_sale DESC

-- Q8: Write SQL query to find the top 5 customer's based on the higest total sale

SELECT customer_id,SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- Q9: Write a SQL query to find the number of unique customers who purchased items from each categories.

SELECT COUNT(DISTINCT customer_id) AS,
	   category
FROM retail_sales
GROUP BY category

-- Q10: Write a SQL query to create eacg shift and number of orders (Example Morning < 12,Afternoon between
-- 12 & 17, Evening > 17) 
WITH hourly_sale
AS(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS Shift
	FROM retail_sales
)
SELECT shift,COUNT(*)
FROM hourly_sale
GROUP BY shift
ORDER BY shift

-- End of project





