SELECT * FROM walmartsales.sales;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------- Feature Engineering------------------------------------------------------------------------

-- time_of_day
SELECT 
	time,
    (CASE
    WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
	END
    ) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
CASE
    WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
	END
);

-- day_name
SELECT
	date,
    DAYNAME(DATE) AS day_name
    FROM sales;
    
    ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name

SELECT 
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);


UPDATE sales
SET month_name = MONTHNAME(date);

SELECT time_of_day, day_name, month_name
FROM sales;


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------Exploratory Data Analysis--------------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	distinct city
FROM sales;

-- In which city is each branch?
SELECT 
	distinct city, branch
FROM sales;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------- Product -------------------------------------------------------------------

-- How many unique product lines foes the data have?
SELECT
COUNT(DISTINCT product_line)
FROM sales; 

-- What is the most common payment method? 
SELECT payment_method,
COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- what is the most selling product line?
SELECT product_line,
COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;


-- what is the total revenue by month?
SELECT month_name AS month,
SUM(total) AS total_month
FROM sales
GROUP BY month
ORDER BY total_month DESC;

-- what month had the largest COGS?
SELECT month_name as month, 
SUM(cogs) AS month_cogs
FROM sales
GROUP BY month
ORDER BY month_cogs DESC;


-- What product line had the largest revenue?
SELECT product_line AS product,
SUM(total) AS product_total
FROM sales
GROUP BY product
ORDER BY product_total DESC;

-- what city had the largeset revenue? 

SELECT city,
SUM(total) AS city_total
FROM sales
GROUP BY city
ORDER BY city_total DESC;

-- what product line had the largest VAT?

SELECT product_line,
MAX(VAT) as VAT_largest
FROM sales
GROUP BY product_line
ORDER BY VAT_largest DESC;

-- which branch sold more products than average product sold?

SELECT branch,
SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- what is the most common product line by gender?

SELECT 
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- what is the average rating of each product line? 
SELECT product_line, 
ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
#UPDATE sales ADD COLUMN product_quality; 


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------ SALES --------------------------------------------------------------------------------------------------------------------

-- number of sales made in each time of the day per weekday 
SELECT time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- which type of customer types brings the most revenue?

SELECT customer_type, 
	SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

--  which city has the largest tax percent/ VAT(Value Added Tax)?
SELECT city, 
AVG(VAT) AS VAT 
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- which customer type pays the most in VAT?
SELECT customer_type, 
AVG(VAT) AS VAT 
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------- Customers ----------------------------------------------------------------------------------------------------------------

-- how many unique customer types does the data have?

SELECT COUNT(DISTINCT customer_type) 
FROM sales;

SELECT DISTINCT customer_type
FROM sales;

-- how many unique payment methods does the data have? 

SELECT DISTINCT payment_method
FROM sales; 

-- which customer type makes the most purchases? 
SELECT customer_type, 
	COUNT(*) AS cstm_cnt
    FROM sales
    GROUP BY customer_type;
    
    -- which gender is more common amongst customers? 
    
    SELECT gender,
    COUNT(*) as gender_total
    FROM sales
    GROUP BY gender;