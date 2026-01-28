# Snowflake Airbnb Analytics (Seattle)

End-to-end analytics project using the Seattle Airbnb Open Data dataset.
The goal of this project is to model raw Airbnb data into a clean analytical (star) schema in Snowflake and answer business questions around demand, pricing, seasonality, and listing performance using SQL.

---

## Dataset

* Source: Kaggle – Seattle Airbnb Open Data
* Files used:

  * `calendar.csv`
  * `listings.csv`
  * `reviews.csv`

---

## Tech Stack

* Snowflake (SQL)
* Python (basic preprocessing)
* CSV exports for downstream analysis 

---

## Data Modeling (Star Schema)

### Fact Tables

* **FACT_CALENDAR**
  Daily grain (one row per listing per date)
  Key fields: availability, daily listed price

* **FACT_REVIEWS**
  Event grain (one row per review)

### Dimension Tables

* **DIM_LISTING** – property, location, pricing, and review attributes
* **DIM_HOST** – host-level attributes
* **DIM_DATE** – calendar attributes (year, month, weekday, weekend, etc.)

Detailed schema documentation is available in `/schema/star_schema.md`.

---

## Key Business Questions Answered

1. Which neighborhoods have the highest occupancy?
2. How does listed price (ADR) change by month?
3. Where is pricing most seasonal?
4. Are weekends priced at a premium compared to weekdays?
5. Which listings show declining demand over time?
6. How long does it take for listings to receive their first observed booking?

### SQL Files

* Questions 1–5: `/sql/Questions(1-5).sql`
* Questions 6–10: `/sql/Questions(6-10).sql`

Each file contains clearly labeled query sections corresponding to the questions above.

---

## Data Quality & Validation

Basic data quality checks were performed, including:

* Primary key uniqueness
* Null rate checks
* Referential integrity between fact and dimension tables
* Range and sanity checks on pricing and availability metrics

Basic data quality checks are included in the SQL files (clearly labeled) and focus on PK uniqueness, null checks, and join integrity.

---

## Assumptions & Limitations

* `available = TRUE` is used as a proxy for listed price (ADR).
  Prices are often missing when `available = FALSE`, so booked revenue is not directly calculated.
* Occupancy is inferred from availability and should be treated as a proxy, not confirmed bookings.
* “Time to first booking” is measured from the earliest available calendar date for a listing to the first observed unavailable date, not the true listing creation date.

Detailed assumptions are documented in `/docs/assumptions_limitations.md`.

---

## How to Run

1. Load raw Airbnb CSVs into `AIRBNB_DB.RAW`
2. Create dimension and fact tables using the SQL files in `/sql`
3. Run analysis queries in:

   * `/sql/Questions(1-5).sql`
   * `/sql/Questions(6-10).sql`
4. Export selected query outputs from Snowflake as CSV if needed

---

## Visualization Note

Power BI dashboards were originally planned for this project.
However, due to account and Power BI 9web version) connectivity limitations, visualization was intentionally skipped to keep the focus on **correct data modeling, SQL logic, and analytical reasoning**.
The exported query outputs are structured to be easily consumed by BI tools such as Power BI or Tableau.

---

## Notes

This project intentionally emphasizes SQL-based analytics, dimensional modeling, and data correctness over visualization tooling.
The structure and queries reflect patterns commonly used in real-world analytics and BI workflows.

---
