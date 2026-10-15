CREATE DATABASE zomato_resturants;
USE zomato_resturants;

SELECT * FROM restaurants;

-- Q.1 Which 10 locations (location) have the most restaurants?
SELECT location, COUNT(name) AS total_restaurants
FROM restaurants
GROUP BY location
ORDER BY total_restaurants DESC LIMIT 10;

-- Whitefield has most number of restaurants, with '614'.

-- Q.2 Which restaurant types (rest_type) are the most common, and what are their average rating and cost for two?
SELECT rest_type, COUNT(*) AS total_restaurants,
ROUND(AVG(rate),2) AS Average_rating, 
ROUND(AVG(cost_for_two),2) AS average_cost_for_two
FROM restaurants
WHERE rest_type IS NOT NULL
GROUP BY rest_type
HAVING total_restaurants >= 20
ORDER BY total_restaurants DESC;

-- Q.3 Do restaurants with online ordering (online_order) have a higher average rating than those without?
SELECT online_order,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(rate), 2) AS average_rating
FROM restaurants
GROUP BY online_order;

-- Q.4 Does table booking (book_table) go with a higher rating or a higher cost for two?
SELECT book_table,
	   COUNT(*) AS table_restaurants,
       ROUND(AVG(rate), 2) AS average_rating,
       ROUND(AVG(cost_for_two), 2) AS average_cost_for_two
FROM restaurants
GROUP BY book_table;

-- Q.5 Which locations have the highest average rating? Count only locations with at least 20 restaurants.
SELECT location,
		COUNT(*) AS total_restaurants, 
		ROUND(AVG(rate) ,2) AS average_rating
FROM restaurants
GROUP BY location
HAVING COUNT(*) >= 20
ORDER BY average_rating DESC
LIMIT 10;        

-- Q.6 How do the number of restaurants and the average rating differ across the cost bands (cost_band)?
SELECT cost_band, 
		COUNT(*) AS total_restaurants,
		ROUND(AVG(rate), 2) AS Average_rating
FROM restaurants
WHERE cost_band IS NOT NULL
GROUP BY cost_band
ORDER BY FIELD(cost_band, 'Budget', 'Mid-range', 'Premium');

-- Q.7 Which are the top 3 most-voted restaurants in each location? (Use ROW_NUMBER().)
WITH ranked_restaurants AS (
	SELECT location,
		   name,
           votes,
           ROW_NUMBER() OVER (PARTITION BY location ORDER BY votes DESC) AS vote_rank
	FROM restaurants
)
SELECT location, name, votes, vote_rank
FROM ranked_restaurants
WHERE vote_rank <= 3
ORDER BY location, vote_rank;

-- Q.8 Which restaurants cost under ₹500 for two but have a rating of 4.0 or higher?
SELECT name, location, rate, cost_for_two
FROM restaurants
WHERE cost_for_two < 500 
AND rate >= 4.0
ORDER BY rate DESC, votes DESC
LIMIT 20;

-- Q.9 Do restaurants serving more cuisines (cuisine_count) get better ratings?
SELECT cuisines_count, ROUND(AVG(rate), 2) AS Average_rating
FROM restaurants
GROUP BY cuisines_count
HAVING COUNT(*) >= 20
ORDER BY cuisines_count DESC;

-- Q.10 What share of restaurants in each rating band (rating_band) offers online ordering?
SELECT rating_band,
       COUNT(*) AS total_restaurants,
       SUM(CASE WHEN online_order = 'Yes' THEN 1 ELSE 0 END) AS online_restaurants,
       ROUND(100.0 * SUM(CASE WHEN online_order = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS online_share_pct
FROM restaurants
WHERE rating_band IS NOT NULL
GROUP BY rating_band
ORDER BY FIELD(rating_band, 'Low', 'Average', 'Good', 'Excellent');

-- Q.11 Which locations are the most expensive? Group by location and show AVG(cost_for_two), with HAVING COUNT(*) >= 20.
SELECT location, ROUND(AVG(cost_for_two), 2) AS Average_cost_for_two
FROM restaurants 
GROUP BY location
HAVING COUNT(*) >= 20
ORDER BY location DESC
LIMIT 10;

-- Q.12 Which restaurant types get the most votes on average? Group by rest_type and show AVG(votes). Votes show popularity, which is different from rating.
SELECT rest_type,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(votes), 0) AS average_votes
FROM restaurants
WHERE rest_type IS NOT NULL
GROUP BY rest_type
HAVING COUNT(*) >= 20
ORDER BY average_votes DESC;

-- Q13. Does online ordering go with a lower or higher cost for two?
SELECT online_order,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(cost_for_two), 0) AS average_cost_for_two
FROM restaurants
GROUP BY online_order;

-- Q14. Do better-rated restaurants cost more? (average cost for two by rating band)
SELECT rating_band,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(cost_for_two), 0) AS average_cost_for_two
FROM restaurants
WHERE rating_band IS NOT NULL
GROUP BY rating_band
ORDER BY FIELD(rating_band, 'Low', 'Average', 'Good', 'Excellent');

-- Q15. Which locations have the highest share of Premium restaurants (at least 20 restaurants)?
SELECT location,
       COUNT(*) AS total_restaurants,
       SUM(CASE WHEN cost_band = 'Premium' THEN 1 ELSE 0 END) AS premium_restaurants,
       ROUND(100.0 * SUM(CASE WHEN cost_band = 'Premium' THEN 1 ELSE 0 END) / COUNT(*), 2) AS premium_share_pct
FROM restaurants
GROUP BY location
HAVING COUNT(*) >= 20
ORDER BY premium_share_pct DESC
LIMIT 10;