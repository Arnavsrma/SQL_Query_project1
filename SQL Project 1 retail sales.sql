-- Sql Retail Sales analysis project 1;

Create database p1_retail_db;
use p1_retail_db;

-- Create table as per need; 
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

Select * from retail_sales
limit 2;

-- Data Exploration and cleaning
-- **Record Count**: Determine the total number of records in the dataset.
Select count(*) as total_count from retail_sales;

-- **Customer Count**: Find out how many unique customers are in the dataset.
Select count(Distinct customer_id) as unique_customers from retail_sales;

-- **Category Count**: Identify all unique product categories in the dataset.
Select distinct category from retail_sales;

-- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
Delete from retail_sales
where 
	transactions_id is Null
    or
    sale_date is NUll
    or 
    sale_time is Null
	or
    customer_id is Null
    or
    gender is null
    or 
    age is null
    or 
    category is null
    or 
    quantity is null
    or 
    price_per_unit is null
    or
    cogs is null
    or 
    total_sale is null;
    
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
### 3. Data Analysis & Findings

-- The following SQL queries were developed to answer specific business questions:

-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
Select * from retail_sales where sale_date = '2022-11-05';

-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022**:
Select * from retail_sales 
where 
category = 'clothing' 
and 
Date_Format(sale_date, '%Y-%m') = '2022-11'
and 
quantity >= 4 ;

use p1_retail_db;
-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
Select category,sum(total_sale) as net_sale,count(total_sale) as sale_count from retail_sales group by category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Select Round(avg(age),2) as avg_age from retail_sales where category = 'Beauty';

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**
Select * from retail_sales where total_sale > 1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**
Select category,gender,count(transactions_id) as total_count from retail_sales group by category,gender order by 1;

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
Select year,month,avg_sale from
(
Select year(sale_date) as year, month(sale_date) as month,round(avg(total_sale),2) as avg_sale,
	RANK() over(partition by year(sale_date) order by avg(total_sale)DESC) as rnk
	from retail_sales 
	group by 1,2
) as t2 where rnk = 1;


-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
Select 
customer_id,
sum(total_sale) as total_sales 
from retail_sales group by customer_id 
order by 2 DESC limit 5;

-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
Select category,count(distinct(customer_id)) cust_count from retail_sales
group by 1;

-- 10. **Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**
WITH hourly_sales as
(
Select *,
	CASE
		WHEN hour(sale_time) < 12 THEN 'Morning'
        WHEN hour(sale_time) in(12,17) THEN 'Afternoon'
        ELSE 'Evening'
	END
as shift FROM retail_sales
)
Select shift,count(*) as total_orders from hourly_sales Group by shift order by 1;
