USE DATABASE AIRBNB_DB;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE TABLE DIM_HOST (
    host_id INT PRIMARY KEY,
    host_name VARCHAR(255),
    host_since DATE,
    host_response_time VARCHAR(50),
    host_response_rate FLOAT,
    host_acceptance_rate FLOAT,
    host_is_superhost BOOLEAN,
    host_listings_count INT,
    host_total_listings_count INT,
    host_has_profile_pic BOOLEAN,
    host_identity_verified BOOLEAN
);

TRUNCATE TABLE DIM_HOST;

INSERT INTO DIM_HOST
SELECT DISTINCT
  host_id::INT AS host_id,
  host_name::VARCHAR(255) AS host_name,
  TRY_TO_DATE(host_since) AS host_since,
  host_response_time::VARCHAR(50) AS host_response_time,

  -- '96%' -> 96.0  (or make it 0.96 if you prefer; see note below)
  TRY_TO_NUMBER(REPLACE(host_response_rate, '%', ''))::FLOAT AS host_response_rate,
  TRY_TO_NUMBER(REPLACE(host_acceptance_rate, '%', ''))::FLOAT AS host_acceptance_rate,

  host_is_superhost::BOOLEAN AS host_is_superhost,
  host_listings_count::INT AS host_listings_count,
  host_total_listings_count::INT AS host_total_listings_count,
  host_has_profile_pic::BOOLEAN AS host_has_profile_pic,
  host_identity_verified::BOOLEAN AS host_identity_verified
FROM AIRBNB_DB.RAW.LISTINGS
WHERE host_id IS NOT NULL;


SELECT *
FROM DIM_HOST
WHERE host_response_rate IS NOT NULL


SHOW COLUMNS IN TABLE dim_host;
