USE DATABASE AIRBNB_DB;
USE SCHEMA ANALYTICS;

DROP TABLE IF EXISTS FACT_CALENDAR;

CREATE TABLE FACT_CALENDAR (
    listing_id INT,
    date DATE,
    available BOOLEAN,
    daily_price FLOAT,
    PRIMARY KEY (listing_id, date)
);

INSERT INTO FACT_CALENDAR
SELECT 
    c.listing_id::INT AS listing_id,
    c.date::DATE AS date,
    c.available::BOOLEAN AS available,
    TRY_TO_NUMBER(REPLACE(REPLACE(c.price, '$', ''), ',', ''))::FLOAT AS daily_price
FROM AIRBNB_DB.RAW.CALENDAR c
JOIN DIM_LISTING l
  ON c.listing_id::INT = l.listing_id
JOIN DIM_DATE d
  ON c.date::DATE = d.date
WHERE c.listing_id IS NOT NULL
  AND c.date IS NOT NULL;


-- After your INSERT completes, optionally add constraints:
ALTER TABLE FACT_CALENDAR 
ADD CONSTRAINT fk_listing 
FOREIGN KEY (listing_id) REFERENCES DIM_LISTING(listing_id);

ALTER TABLE FACT_CALENDAR 
ADD CONSTRAINT fk_date 
FOREIGN KEY (date) REFERENCES DIM_DATE(date);

SHOW IMPORTED KEYS IN TABLE FACT_CALENDAR;

SHOW IMPORTED KEYS IN TABLE AIRBNB_DB.ANALYTICS.FACT_CALENDAR;



SELECT *  FROM FACT_CALENDAR;

SELECT 
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    COUNT(DISTINCT date) AS unique_dates,
    COUNT(DISTINCT listing_id) AS unique_listings
FROM FACT_CALENDAR;

SELECT 
    MIN(daily_price) AS min_price,
    AVG(daily_price) AS avg_price,
    MAX(daily_price) AS max_price,
    SUM(IFF(daily_price IS NULL, 1, 0)) AS null_prices
FROM FACT_CALENDAR;

SELECT 
    available,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM FACT_CALENDAR
GROUP BY available;
