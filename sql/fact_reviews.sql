USE DATABASE AIRBNB_DB;
USE SCHEMA ANALYTICS;

-- Add missing dates from reviews to DIM_DATE
INSERT INTO DIM_DATE
SELECT DISTINCT
  r.date::DATE AS date,
  YEAR(r.date::DATE) AS year,
  MONTH(r.date::DATE) AS month,
  MONTHNAME(r.date::DATE) AS month_name,
  QUARTER(r.date::DATE) AS quarter,
  DAY(r.date::DATE) AS day_of_month,
  DAYOFWEEK(r.date::DATE) AS day_of_week,
  DAYNAME(r.date::DATE) AS day_name,
  IFF(DAYOFWEEK(r.date::DATE) IN (0, 6), TRUE, FALSE) AS is_weekend,
  WEEKOFYEAR(r.date::DATE) AS week_of_year
FROM AIRBNB_DB.RAW.REVIEWS r
WHERE r.date IS NOT NULL
  AND r.date NOT IN (SELECT date FROM DIM_DATE);  -- Only add NEW dates

-- Verify DIM_DATE now has more rows
SELECT 
    COUNT(*) AS total_dates,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date
FROM DIM_DATE;


SELECT *
FROM AIRBNB_DB.RAW.REVIEWS
WHERE listing_id = 'listing_id'
   OR id = 'id'
LIMIT 5;


DELETE FROM AIRBNB_DB.RAW.REVIEWS
WHERE listing_id = 'listing_id';

ALTER TABLE FACT_REVIEWS 
ADD CONSTRAINT fk_reviews_listing 
FOREIGN KEY (listing_id) REFERENCES DIM_LISTING(listing_id);

ALTER TABLE FACT_REVIEWS 
ADD CONSTRAINT fk_reviews_date 
FOREIGN KEY (date) REFERENCES DIM_DATE(date);


SELECT 
    MIN(date) AS earliest_review,
    MAX(date) AS latest_review,
    COUNT(DISTINCT date) AS unique_dates,
    COUNT(DISTINCT listing_id) AS listings_with_reviews,
    COUNT(DISTINCT reviewer_id) AS unique_reviewers
FROM FACT_REVIEWS;

SELECT * FROM AIRBNB_DB.RAW.REVIEWS LIMIT 10;


-- Clear the empty table
TRUNCATE TABLE FACT_REVIEWS;

-- Now insert with expanded DIM_DATE
INSERT INTO FACT_REVIEWS
SELECT 
    r.id::INT AS review_id,
    r.listing_id::INT AS listing_id,
    r.date::DATE AS date,
    r.reviewer_id::INT AS reviewer_id,
    r.reviewer_name::VARCHAR(255) AS reviewer_name,
    r.comments::TEXT AS comments
FROM AIRBNB_DB.RAW.REVIEWS r
JOIN DIM_LISTING l
  ON r.listing_id::INT = l.listing_id
JOIN DIM_DATE d
  ON r.date::DATE = d.date
WHERE r.id IS NOT NULL
  AND r.listing_id IS NOT NULL
  AND r.date IS NOT NULL;

-- Verify it worked
SELECT COUNT(*) AS total_reviews FROM FACT_REVIEWS;

SELECT 
    MIN(date) AS earliest_review,
    MAX(date) AS latest_review,
    COUNT(DISTINCT date) AS unique_dates,
    COUNT(DISTINCT listing_id) AS listings_with_reviews,
    COUNT(DISTINCT reviewer_id) AS unique_reviewers
FROM FACT_REVIEWS;

