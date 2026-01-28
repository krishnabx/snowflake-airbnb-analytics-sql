-- Create database
CREATE DATABASE airbnb_db;
USE DATABASE airbnb_db;

-- Create RAW schema (for staging CSVs)
CREATE SCHEMA raw;

-- Create ANALYTICS schema (for star schema)
CREATE SCHEMA analytics;

-- Create warehouse
CREATE WAREHOUSE airbnb_wh
  WITH WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

USE WAREHOUSE airbnb_wh;

-- Verify
SHOW SCHEMAS IN DATABASE airbnb_db;

CREATE SCHEMA IF NOT EXISTS AIRBNB_DB.RAW;
