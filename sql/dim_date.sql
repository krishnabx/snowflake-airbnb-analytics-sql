USE DATABASE AIRBNB_DB;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE TABLE DIM_DATE (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    day_of_month INT,
    day_of_week INT,
    day_name VARCHAR(20),
    is_weekend BOOLEAN,
    week_of_year INT
);

-- Now populate it
INSERT INTO DIM_DATE
SELECT DISTINCT
  d::DATE AS date,
  YEAR(d::DATE) AS year,
  MONTH(d::DATE) AS month,
  MONTHNAME(d::DATE) AS month_name,
  QUARTER(d::DATE) AS quarter,
  DAY(d::DATE) AS day_of_month,
  DAYOFWEEKISO(d::DATE) AS day_of_week,
  DAYNAME(d::DATE) AS day_name,
  IFF(DAYOFWEEKISO(d::DATE) IN (6,7), TRUE, FALSE) AS is_weekend,
  WEEKOFYEAR(d::DATE) AS week_of_year
FROM (
  SELECT DATE AS d
  FROM AIRBNB_DB.RAW.CALENDAR
)
WHERE d IS NOT NULL
;

---------------------

SELECT * 
FROM DIM_DATE

show columns in table dim_date;


