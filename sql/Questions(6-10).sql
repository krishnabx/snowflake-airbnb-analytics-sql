SELECT listing_id, date, available, daily_price FROM AIRBNB_DB.ANALYTICS.FACT_CALENDAR LIMIT 100;
SELECT listing_id, host_id, neighbourhood_cleansed, city, property_type, room_type, accommodates, base_price, review_scores_rating
FROM AIRBNB_DB.ANALYTICS.DIM_LISTING LIMIT 50;

SELECT host_id, host_is_superhost, host_total_listings_count FROM AIRBNB_DB.ANALYTICS.DIM_HOST LIMIT 50;
SELECT date, year, month, month_name, day_name, is_weekend FROM AIRBNB_DB.ANALYTICS.DIM_DATE ORDER BY date;
select * from airbnb_db.analytics.fact_reviews;

--Q6.: Compare performance of superhosts vs non-superhosts - Superhost impact
select IFF(host_is_superhost=true,'Yes', 'No') as Is_superhost,
sum(iff(AVAILABLE=false,1,0))/ COUNT(*) AS occupancy_rate,
avg(iff(AVAILABLE=TRUE, DAILY_PRICE, NULL)) as  listed_adr
from AIRBNB_DB.ANALYTICS.DIM_HOST dh
JOIN AIRBNB_DB.ANALYTICS.DIM_LISTING dl
on dh.host_id = dl.host_id
JOIN AIRBNB_DB.ANALYTICS.FACT_CALENDAR FC
ON FC.LISTING_ID = dl.listing_id
group by 1;

--Q7.Quarter-over-quarter occupancy change/ Listings with declining demand
--Question: For each listing, compute occupancy by quarter, then compute change vs previous quarter
WITH cte as (select fc.listing_id, dd.QUARTER, COUNT(*) AS nights_in_quarter,
    sum(iff(available=FALSE,1,0))/COUNT(*) AS occupancy_rate
    from AIRBNB_DB.ANALYTICS.DIM_DATE dd
    join airbnb_db.analytics.fact_calendar fc on dd.date = fc.date
    group by 1,2)
select listing_id, QUARTER, round(occupancy_rate,2) AS occupancy_rate,
lag(occupancy_rate) over(partition by listing_id order by quarter) as prev_quarter_occupancy,
(occupancy_rate- (lag(occupancy_rate) over(partition by listing_id order by quarter))) as occupancy_change
from cte
WHERE nights_in_quarter >= 60
QUALIFY prev_quarter_occupancy IS NOT NULL and occupancy_rate > 0 and  occupancy_rate < 1 
order by 1,2,5 ;

--Q8.Seasonal price sensitivity
--Goal: Find neighborhoods where listed prices change the most across seasons.
WITH seasonal_prices AS (
  SELECT l.neighbourhood_cleansed, d.quarter,AVG(f.daily_price) AS listed_adr
  FROM AIRBNB_DB.ANALYTICS.FACT_CALENDAR f
  JOIN AIRBNB_DB.ANALYTICS.DIM_DATE d ON f.date = d.date
  JOIN AIRBNB_DB.ANALYTICS.DIM_LISTING l ON f.listing_id = l.listing_id
  WHERE f.available = TRUE AND f.daily_price IS NOT NULL
  GROUP BY 1, 2
)
SELECT  
  neighbourhood_cleansed,
  MAX(listed_adr) AS max_listed_adr,
  MIN(listed_adr) AS min_listed_adr,
  MAX(listed_adr) - MIN(listed_adr) AS price_range
FROM seasonal_prices
GROUP BY neighbourhood_cleansed
ORDER BY price_range DESC;


--Q9. Review impact on demand
--Do better-reviewed listings have higher occupancy?
WITH CTE as (
    SELECT fc.listing_id, review_scores_rating, (SUM(IFF(AVAILABLE=false,1,0))/ COUNT(*)) AS occupancy_rate,
    CASE WHEN dl.review_scores_rating BETWEEN 95 AND 100 THEN '95–100' 
         WHEN dl.review_scores_rating BETWEEN 90 AND 94 THEN '90–94'
         WHEN dl.review_scores_rating BETWEEN 85 AND 89 THEN '85–89'
         WHEN dl.review_scores_rating BETWEEN 80 AND 84 THEN '80–84'
    ELSE 'Other'  END AS rating_bucket
    FROM AIRBNB_DB.ANALYTICS.FACT_CALENDAR fc
    JOIN AIRBNB_DB.ANALYTICS.DIM_LISTING dl
    on fc.listing_id = dl.listing_id
    where review_scores_rating is not null
    group by 1,2
)
select rating_bucket, COUNT(distinct listing_id), avg(occupancy_rate) as avg_occ_rate
from CTE
GROUP BY rating_bucket
order by avg_occ_rate desc;


--Q10. Newly listed performance
--How quickly do new listings get booked?
SELECT fc.listing_id, dl.neighbourhood_cleansed, MIN(fc.date) AS first_calendar_date, MIN(IFF(fc.available = FALSE, fc.date, NULL)) AS first_booked_date,
  DATEDIFF('day', MIN(fc.date), MIN(IFF(fc.available = FALSE, fc.date, NULL))) AS days_to_first_booking,  SUM(IFF(fc.available = FALSE, 1, 0)) AS total_booked_nights
FROM AIRBNB_DB.ANALYTICS.FACT_CALENDAR fc
JOIN AIRBNB_DB.ANALYTICS.DIM_LISTING dl
  ON fc.listing_id = dl.listing_id
GROUP BY  fc.listing_id, dl.neighbourhood_cleansed
HAVING days_to_first_booking IS NOT NULL AND days_to_first_booking > 0
ORDER BY days_to_first_booking DESC;
