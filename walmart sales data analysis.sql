-- TASK FOR PRODUCT ASPECT -----------------------

-- FEATURE ENGINEERING 

-- Time_of_day
SELECT 
	time,
    (CASE
		When Time Between "00:00:00" AND "12:00:00" THEN "MORNING"
        When Time Between "12:01:00" AND "16:00:00" THEN "AFTERNOON"
        ELSE "EVENING"
        END
        ) AS time_of_day
        
FROM `walmartsalesdata.csv`;

ALTER TABLE `walmartsalesdata.csv` ADD COLUMN  time_of_day VARCHAR(20);
UPDATE `walmartsalesdata.csv`
SET time_of_day = (
	CASE
		When Time Between "00:00:00" AND "12:00:00" THEN "MORNING"
        When Time Between "12:01:00" AND "16:00:00" THEN "AFTERNOON"
        ELSE "EVENING"
	 END
        ); 
        
-- day_name
SELECT 
	date,
    dayname(date) AS day_name
FROM `walmartsalesdata.csv`;
ALTER TABLE `walmartsalesdata.csv` ADD COLUMN day_name  VARCHAR(10);

UPDATE `walmartsalesdata.csv`
SET day_name = dayname(date); 

-- Month column 
SELECT 
	date,
    monthname(date)
FROM `walmartsalesdata.csv`;

ALTER TABLE `walmartsalesdata.csv` ADD COLUMN month_name VARCHAR(10) ;
UPDATE `walmartsalesdata.csv`
SET month_name = monthname(date);

-- Generic Questions 
-- How many unique cities does the data have ?

SELECT 
	DISTINCT city 
FROM `walmartsalesdata.csv`;
-- How many unique branches  does the data have ?
SELECT 
	DISTINCT branch
FROM `walmartsalesdata.csv`;

-- How many unique branches are in the cities ?

SELECT
	DISTINCT city,
    branch
FROM `walmartsalesdata.csv`;

-- Product Questions --

-- How many unique products lines does the data have?

SELECT 
	count(DISTINCT `Product line`) 
FROM `walmartsalesdata.csv`;

-- What is the most common payment method
SELECT 
	 Payment,
     COUNT(Payment) AS cnt
FROM `walmartsalesdata.csv`
GROUP BY Payment
ORDER BY cnt DESC;

-- what is the most common product line 
SELECT 
	 `Product line`,
     COUNT(`Product line`) AS prd
FROM `walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY prd DESC;

-- What is the total revenue by month
SELECT
	month_name AS month,
    SUM(total) AS total_revenue 
FROM`walmartsalesdata.csv`
GROUP BY month_name
ORDER BY total_revenue DESC; 
    
-- What month had the largest cost of goods sold 
SELECT
	month_name AS month,
    SUM(cogs) AS cogs
FROM`walmartsalesdata.csv`
GROUP BY month_name
ORDER BY cogs DESC; 

-- what product line had the largesr revenue 
SELECT
	`Product line` AS product,
    SUM(total) AS total_revenue 
FROM`walmartsalesdata.csv`
GROUP BY product
ORDER BY total_revenue DESC; 

-- What is the city with the largest revenue 
SELECT
	branch,
	City AS city,
    SUM(total) AS total_revenue 
FROM`walmartsalesdata.csv`
GROUP BY city, branch
ORDER BY total_revenue DESC; 

-- what product line had the highest VAT
SELECT 
	 `Product line`,
    ROUND(  avg(`Tax 5%`), 5) AS avg_VAT
FROM `walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY avg_VAT DESC;

-- Which branch sold more products than average sold 

SELECT 
	branch,
    SUM(Quantity) AS Quantity 
FROM`walmartsalesdata.csv`
GROUP BY branch 
HAVING sum(Quantity) > (SELECT AVG(Quantity) FROM `walmartsalesdata.csv`);

-- What is the most common product line by gender?
SELECT 
	Gender,
    `Product line`,
    count(Gender) AS total_count
FROM `walmartsalesdata.csv`
GROUP BY Gender, `Product line`
ORDER BY total_count DESC;

-- What is the average rating of each product line?
SELECT 
	ROUND(avg(Rating),2) AS avg_rating,
    `Product line`
FROM `walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY avg_rating DESC;
-------------------------------------------------------------------------------------
-- TASK FOR SALES ASPECT-------------

-- Number of sales made in each time of the day per weekday --
SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM `walmartsalesdata.csv`
WHERE day_name = "MONDAY"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?--
SELECT 
	`Customer type`,
	ROUND(SUM(Total), 5)AS total_rev
FROM `walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY total_rev DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?--
SELECT 
	City,
	ROUND(avg(`Tax 5%`),5) AS tax 
FROM `walmartsalesdata.csv`
GROUP BY city 
ORDER BY tax DESC;

-- Which customer type pays the most in VAT?--
SELECT 
	`Customer type`,
	ROUND(avg(`Tax 5%`),5) AS tax 
FROM `walmartsalesdata.csv`
GROUP BY `Customer type` 
ORDER BY tax DESC;

--  -------------------------------------CUSTOMER SECTION------------------------------------

-- How many unique customer types does the data have?
SELECT 
	COUNT(distinct(`Customer type`))
    FROM `walmartsalesdata.csv`;
-- How many unique payment methods does the data have?
SELECT 
	COUNT(distinct(Payment))
FROM `walmartsalesdata.csv`;

-- What is the most common customer type?-----
SELECT 
	`Customer type`,
    COUNT(*) AS count 
FROM `walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY count DESC;

-- Which customer type buys the most? --
SELECT 
	`Customer type`,
    COUNT(*) AS CNT 
FROM `walmartsalesdata.csv`
GROUP BY `Customer type`; 

-- What is the gender of most of the customers? --
SELECT 
	Gender,
    COUNT(*) AS cnt 
FROM `walmartsalesdata.csv`
GROUP BY Gender
ORDER BY cnt ;

-- What is the gender distribution per branch? --
SELECT 
	Gender,
    COUNT(*) AS cnt 
FROM `walmartsalesdata.csv`
WHERE Branch = "c"
GROUP BY Gender
ORDER BY cnt ;

-- Which time of the day do customers give most ratings? -- 
SELECT 
	time_of_day,
    ROUND(avg(Rating),5) AS avg_rating 
FROM `walmartsalesdata.csv`
GROUP BY time_of_day
ORDER BY avg_rating DESC ;

-- Which time of the day do customers give most ratings per branch?--
SELECT 
	time_of_day,
    ROUND(avg(Rating),5) AS avg_rating 
FROM `walmartsalesdata.csv`
WHERE Branch = "A"
GROUP BY time_of_day, Branch
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?--
SELECT 
	day_name,
    ROUND(avg(Rating),5) AS avg_rating 
FROM `walmartsalesdata.csv`
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch? -- 
SELECT 
	day_name,
    ROUND(avg(Rating),5) AS avg_rating 
FROM `walmartsalesdata.csv`
WHERE Branch = "A"
GROUP BY day_name
ORDER BY avg_rating DESC;
