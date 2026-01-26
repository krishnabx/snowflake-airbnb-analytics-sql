# Star Schema (Seattle Airbnb)

This project models raw Airbnb CSV data into a dimensional (star) schema in Snowflake for analytics.

---

## Fact Tables

### FACT_CALENDAR (daily grain)
**Grain:** 1 row per `listing_id` per `date`

**Primary key:** (`listing_id`, `date`)

**Key columns**
- `listing_id` (FK → DIM_LISTING)
- `date` (FK → DIM_DATE)
- `available` (boolean)
- `daily_price` (listed price when available)

**Purpose**
Used for occupancy proxy, pricing trends, seasonality, and weekend vs weekday analysis.

---

### FACT_REVIEWS (event grain)
**Grain:** 1 row per review event

**Primary key:** `review_id`

**Key columns**
- `review_id` (PK)
- `listing_id` (FK → DIM_LISTING)
- `date` (FK → DIM_DATE)
- `reviewer_id`
- `reviewer_name`
- `comments`

**Purpose**
Used to analyze review volume and connect review activity to listing performance signals.

---

## Dimension Tables

### DIM_LISTING
**Grain:** 1 row per listing (`listing_id`)

**Primary key:** `listing_id`

**Foreign keys**
- `host_id` (FK → DIM_HOST)

**Key attributes (examples)**
- Location: `neighbourhood_cleansed`, `city`, `state`, `zipcode`, `latitude`, `longitude`
- Property: `property_type`, `room_type`, `accommodates`, `bedrooms`, `beds`, `bathrooms`
- Pricing policy: `base_price`, `extra_people`, `guests_included`, `minimum_nights`, `maximum_nights`
- Booking policies: `instant_bookable`, `cancellation_policy`
- Review metrics: `review_scores_rating`, `number_of_reviews`, `reviews_per_month`

**Purpose**
Provides stable listing-level attributes used to group, filter, and segment fact table metrics.

---

### DIM_HOST
**Grain:** 1 row per host (`host_id`)

**Primary key:** `host_id`

**Key attributes (examples)**
- `host_is_superhost`
- `host_response_rate`
- `host_acceptance_rate`
- `host_since`
- `host_listings_count`

**Purpose**
Used to compare performance of superhosts vs non-superhosts and host-level behavior.

---

### DIM_DATE
**Grain:** 1 row per date (`date`)

**Primary key:** `date`

**Key attributes**
- `year`, `month`, `month_name`, `quarter`
- `day_of_week`, `day_name`, `is_weekend`
- `week_of_year`

**Purpose**
Supports time series analysis and seasonality (month/quarter/weekend breakdowns).

---

## Relationships (Join Map)

- FACT_CALENDAR.`listing_id` → DIM_LISTING.`listing_id`
- FACT_CALENDAR.`date` → DIM_DATE.`date`
- DIM_LISTING.`host_id` → DIM_HOST.`host_id`
- FACT_REVIEWS.`listing_id` → DIM_LISTING.`listing_id`
- FACT_REVIEWS.`date` → DIM_DATE.`date`

---

## Notes
- `base_price` in DIM_LISTING represents the listing-level price field from listings.csv.
- `daily_price` in FACT_CALENDAR represents the date-level listed price from calendar.csv.
