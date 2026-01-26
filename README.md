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
