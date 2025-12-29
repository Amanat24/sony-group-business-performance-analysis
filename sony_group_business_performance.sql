CREATE DATABASE sony_analysis;
USE sony_analysis;

CREATE TABLE sony_segment_revenue (
    year INT,
    segment_name VARCHAR(50),
    revenue_billion_usd DECIMAL(10,2)
);

INSERT INTO sony_segment_revenue VALUES
(2019, 'ELECTRONICS PRODUCTS & SOLUTIONS', 32),
(2020, 'ELECTRONICS PRODUCTS & SOLUTIONS', 30),
(2021, 'ELECTRONICS PRODUCTS & SOLUTIONS', 29),
(2022, 'ELECTRONICS PRODUCTS & SOLUTIONS', 27),
(2023, 'ELECTRONICS PRODUCTS & SOLUTIONS', 28),

(2019, 'GAME & NETWORK SERVICES', 22),
(2020, 'GAME & NETWORK SERVICES', 25),
(2021, 'GAME & NETWORK SERVICES', 28),
(2022, 'GAME & NETWORK SERVICES', 26),
(2023, 'GAME & NETWORK SERVICES', 29),

(2019, 'MUSIC', 9),
(2020, 'MUSIC', 10),
(2021, 'MUSIC', 11),
(2022, 'MUSIC', 12),
(2023, 'MUSIC', 13),

(2019, 'PICTURES', 10),
(2020, 'PICTURES', 9),
(2021, 'PICTURES', 10),
(2022, 'PICTURES', 11),
(2023, 'PICTURES', 12);


-- Total revenue per year
SELECT
year,
SUM(revenue_billion_usd) AS total_revenue
FROM sony_segment_revenue
GROUP BY year
ORDER BY year;


-- Segment-wise revenue trend
SELECT
segment_name,year,revenue_billion_usd
FROM sony_segment_revenue
ORDER BY segment_name, year;


-- YoY Growth in SQL
SELECT
segment_name,year,revenue_billion_usd,
ROUND(
(revenue_billion_usd - LAG(revenue_billion_usd) 
OVER (PARTITION BY segment_name ORDER BY year))
/ LAG(revenue_billion_usd) 
OVER (PARTITION BY segment_name ORDER BY year),4) AS yoy_growth
FROM sony_segment_revenue
ORDER BY segment_name, year;


-- Revenue Contribution %
SELECT
year,segment_name,revenue_billion_usd,
ROUND(
revenue_billion_usd /
SUM(revenue_billion_usd) OVER (PARTITION BY year),4) AS revenue_contribution_pct
FROM sony_segment_revenue
ORDER BY year, segment_name;

-- Rank segments by revenue
SELECT
year,segment_name,revenue_billion_usd,
RANK() OVER (PARTITION BY year
ORDER BY revenue_billion_usd DESC
) AS revenue_rank
FROM sony_segment_revenue
ORDER BY year, revenue_rank;


-- Identify top revenue segment overall
SELECT
segment_name,
SUM(revenue_billion_usd) AS total_revenue
FROM sony_segment_revenue
GROUP BY segment_name
ORDER BY total_revenue DESC;


-- Growth comparison (Gaming vs Electronics)
SELECT
year,
SUM(CASE WHEN segment_name = 'GAME & NETWORK SERVICES' THEN revenue_billion_usd END) AS gaming_revenue,
SUM(CASE WHEN segment_name = 'ELECTRONICS PRODUCTS & SOLUTIONS' THEN revenue_billion_usd END) AS electronics_revenue
FROM sony_segment_revenue
GROUP BY year
ORDER BY year;


-- Identify declining segments
SELECT
segment_name,
MIN(revenue_billion_usd) AS min_revenue,
MAX(revenue_billion_usd) AS max_revenue
FROM sony_segment_revenue
GROUP BY segment_name;


-- Contribution %
SELECT
year,segment_name,
ROUND(revenue_billion_usd /
SUM(revenue_billion_usd) OVER (PARTITION BY year),4) AS revenue_contribution_pct
FROM sony_segment_revenue
ORDER BY year, segment_name;


-- i have imported the sony_region_revenue 
select * from sony_region_revenue;


-- we validates both table by using year 
SELECT
s.year,
SUM(s.revenue_billion_usd) AS segment_total,
SUM(r.revenue_billion_usd) AS region_total
FROM sony_segment_revenue s
JOIN sony_region_revenue r
ON s.year = r.year
GROUP BY s.year
ORDER BY s.year;


--

