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

