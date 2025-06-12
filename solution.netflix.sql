
-- 1. Count the number of Movies vs TV Shows
SELECT 
    type_,
    COUNT(type_) AS total
FROM netflix_
GROUP BY type_


-- 2. Find the most common rating for movies and TV shows
WITH RatingCounts AS (
    SELECT 
        type_,
        rating,
        COUNT(rating) AS rating_count
    FROM netflix_
    GROUP BY type_, rating
),
RankedRatings AS (
    SELECT 
        type_,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type_ ORDER BY rating_count DESC) AS rnk
    FROM RatingCounts
)
SELECT 
    type_,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rnk = 1


-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM netflix_
WHERE release_year = 2020 and type_= 'movie'


-- 4. Find the top 5 countries with the most content on Netflix
SELECT 
TOP 5 TRIM(value) AS country,
      COUNT(show_id) AS total_content
FROM netflix_
CROSS APPLY STRING_SPLIT(country, ',')
WHERE value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY total_content DESC


-- 5. Identify the longest movie
SELECT *
FROM netflix_
WHERE type_ = 'Movie' and duration = (select max(duration) from netflix_)


-- 6. Find content added in the last 5 years
SELECT *
FROM netflix_
WHERE TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE())


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT *
FROM netflix_
WHERE director LIKE '%Rajiv Chilaka%'


-- 8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix_
WHERE type_ = 'TV Show' AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5


-- 9. Count the number of content items in each genre
SELECT 
    TRIM(value) AS genre,
    COUNT(show_id) AS total_content
FROM netflix_
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY total_content DESC


-- 10. Find each year and the average numbers of content release by India on Netflix
SELECT TOP 5 release_year,
    COUNT(show_id) AS total_release,
    ROUND (CAST (COUNT(show_id) AS FLOAT) / (SELECT COUNT(*) FROM netflix_ WHERE country LIKE '%India%') * 100, 2) AS avg_release
FROM netflix_
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY avg_release DESC


-- 11. List all movies that are documentaries
SELECT * 
FROM netflix_
WHERE listed_in LIKE '%Documentaries%'


-- 12. Find all content without a director
SELECT * 
FROM netflix_
WHERE director IS NULL 


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years
SELECT * 
FROM netflix_
WHERE casts LIKE '%Salman Khan%' AND release_year >= YEAR(GETDATE()) - 10 AND type_ = 'Movie'


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
SELECT 
TOP 10 TRIM(value) AS actor,
COUNT(*) AS appearances
FROM netflix_
CROSS APPLY STRING_SPLIT(casts, ',')
WHERE country LIKE '%India%' AND type_ = 'Movie'
AND value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY appearances DESC


-- 15. Categorize content based on presence of 'kill' or 'violence' in description
SELECT 
category,
COUNT(show_id) AS content_count
FROM (
SELECT *,
CASE WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad' ELSE 'Good' END AS category
FROM netflix_
) AS categorized_content
GROUP BY category