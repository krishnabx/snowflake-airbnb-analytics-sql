<<<<<<< HEAD
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
=======
# snowflake-airbnb-analytics

# Snowflake Airbnb Analytics (Seattle)

End-to-end analytics project using the Seattle Airbnb dataset.
Built a star schema in Snowflake, validated data quality, and answered business questions on occupancy, pricing, seasonality, and demand decline.

## Dataset
Source: Kaggle Seattle Airbnb (calendar.csv, listings.csv, reviews.csv)

## Tech
Snowflake (SQL), basic preprocessing in Python (optional), outputs exported as CSV.

## Star schema
- FACT_CALENDAR (daily grain: listing_id x date)
- FACT_REVIEWS (review event grain)
- DIM_LISTING
- DIM_HOST
- DIM_DATE

Schema notes: see `/schema/star_schema.md`

## Key analyses
1. Occupancy rate by neighborhood (Top demand hotspots)
2. ADR trend by month (seasonality)
3. Weekend vs weekday differences (pricing + booking pressure)
4. Seasonal price sensitivity (month of peak vs dip)
5. Listings with declining demand (QoQ occupancy change)
6. First observed booking delay (diagnostic)

Full SQL: `/sql/04_analysis_queries.sql`

## Data quality checks
Primary keys, null rates, referential integrity, and range checks in:
`/sql/05_data_quality_checks.sql`

## Assumptions and limitations (important)
- `available = TRUE` is used as listed price (ADR); price is often missing when `available = FALSE`, so revenue is not computed from booked nights.
- “Time to first booking” is measured as time from first calendar date in dataset to first observed booked date; it is not true listing creation date.
See `/docs/assumptions_limitations.md`

## How to run
1. Create Snowflake DB/Schema: see `/sql/00_setup_context.sql`
2. Load RAW tables (calendar, listings, reviews) into `AIRBNB_DB.RAW`
3. Build dimensions: `/sql/02_dimensions.sql`
4. Build facts: `/sql/03_facts.sql`
5. Run analysis queries: `/sql/04_analysis_queries.sql`

## Outputs
Selected exports are in `/outputs/` for quick review.
>>>>>>> 4c3d4d4823e8de8308b5a29987671cd846f9dcc7
# snowflake-airbnb-analytics-sql
