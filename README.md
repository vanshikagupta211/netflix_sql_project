# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/vanshikagupta211/netflix_sql_project/blob/main/netflix_image.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)


## Schema

```sql
drop table if exists netflix_
CREATE TABLE netflix_
(
    show_id      NVARCHAR(6),
    type_        NVARCHAR(10),
    title        NVARCHAR(150),
    director     NVARCHAR(208),
    casts        NVARCHAR(1000),
    country      NVARCHAR(150),
    date_added   NVARCHAR(50),
    release_year INT,
    rating       NVARCHAR(10),
    duration     NVARCHAR(15),
    listed_in    NVARCHAR(100),
    description  NVARCHAR(250)
)
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type_,
    COUNT(type_) AS total
FROM netflix_
GROUP BY type_
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix_
WHERE release_year = 2020 and type_= 'movie'
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
TOP 5 TRIM(value) AS country,
      COUNT(show_id) AS total_content
FROM netflix_
CROSS APPLY STRING_SPLIT(country, ',')
WHERE value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY total_content DESC
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT *
FROM netflix_
WHERE type_ = 'Movie' and duration = (select max(duration) from netflix_)
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix_
WHERE TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE())
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM netflix_
WHERE director LIKE '%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix_
WHERE type_ = 'TV Show' AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    TRIM(value) AS genre,
    COUNT(show_id) AS total_content
FROM netflix_
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY total_content DESC
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT TOP 5 release_year,
    COUNT(show_id) AS total_release,
    ROUND (CAST (COUNT(show_id) AS FLOAT) / (SELECT COUNT(*) FROM netflix_ WHERE country LIKE '%India%') * 100, 2) AS avg_release
FROM netflix_
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY avg_release DESC
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix_
WHERE listed_in LIKE '%Documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix_
WHERE director IS NULL 
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix_
WHERE casts LIKE '%Salman Khan%' AND release_year >= YEAR(GETDATE()) - 10 AND type_ = 'Movie'
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
TOP 10 TRIM(value) AS actor,
COUNT(*) AS appearances
FROM netflix_
CROSS APPLY STRING_SPLIT(casts, ',')
WHERE country LIKE '%India%' AND type_ = 'Movie'
AND value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY appearances DESC
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
SELECT 
category,
COUNT(show_id) AS content_count
FROM (
SELECT *,
CASE WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad' ELSE 'Good' END AS category
FROM netflix_
) AS categorized_content
GROUP BY category
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

