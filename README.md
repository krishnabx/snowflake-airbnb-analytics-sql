# Snowflake Airbnb Analytics (Seattle)

End-to-end analytics project using the Seattle Airbnb dataset.  
The goal of this project is to model raw Airbnb data into a clean analytical schema and answer business questions around demand, pricing, seasonality, and listing performance using SQL.

---

## Dataset
- Source: Kaggle – Seattle Airbnb Open Data
- Files used:
  - calendar.csv
  - listings.csv
  - reviews.csv

---

## Tech Stack
- Snowflake (SQL)
- Basic preprocessing in Python (optional)
- Outputs exported as CSV for reporting

---

## Data Modeling (Star Schema)

### Fact Tables
- **FACT_CALENDAR**  
  Daily grain (one row per listing per date)  
  Fields: availability, daily listed price

- **FACT_REVIEWS**  
  Event grain (one row per review)

### Dimension Tables
- **DIM_LISTING** – property, location, pricing, review attributes  
- **DIM_HOST** – host-level attributes  
- **DIM_DATE** – calendar attributes (year, month, weekday, weekend, etc.)

Detailed schema notes are in `/schema/star_schema.md`.

---

## Key Business Questions Answered
1. Which neighborhoods have the highest occupancy?
2. How does listed price (ADR) change by month?
3. Where is pricing most seasonal?
4. Are weekends priced at a premium compared to weekdays?
5. Which listings show declining demand over time?
6. How long does it take for listings to receive their first observed booking?

All SQL used to answer these questions is in `/sql/04_analysis_queries.sql`.

---

## Data Quality & Validation
Basic data quality checks were performed, including:
- Primary key uniqueness
- Null rate checks
- Referential integrity between fact and dimension tables
- Range checks on pricing and occupancy metrics

Queries are documented in `/sql/05_data_quality_checks.sql`.

---

## Assumptions & Limitations
- `available = TRUE` is used to represent listed price (ADR).  
  Price is often missing when `available = FALSE`, so booked revenue is not directly calculated.
- Occupancy is treated as a proxy based on availability, not confirmed bookings.
- “Time to first booking” is measured from the earliest calendar date available for a listing to the first observed booked date, not the true listing creation date.

Details are documented in `/docs/assumptions_limitations.md`.

---

## How to Run
1. Load raw Airbnb CSVs into `AIRBNB_DB.RAW`
2. Create dimensions using `/sql/02_dimensions.sql`
3. Create fact tables using `/sql/03_facts.sql`
4. Run analysis queries in `/sql/04_analysis_queries.sql`
5. Export selected outputs from Snowflake as CSV

---

## Outputs
Selected query outputs used for reporting are stored in `/outputs/`.

---

## Notes
This project focuses on SQL-based analytics and data modeling.  
Visualization tools were intentionally kept lightweight to emphasize analytical reasoning and correctness over tooling.
