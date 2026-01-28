SELECT listing_id, date, available, daily_price FROM AIRBNB_DB.ANALYTICS.FACT_CALENDAR LIMIT 100;
SELECT date, year, month, month_name, day_name, is_weekend FROM AIRBNB_DB.ANALYTICS.DIM_DATE ORDER BY date ;

SELECT listing_id, host_id, neighbourhood_cleansed, city, property_type, room_type, accommodates, base_price, review_scores_rating 
FROM AIRBNB_DB.ANALYTICS.DIM_LISTING LIMIT 10;


-- Q1) Occupancy rate by neighborhood (Top 20): 
select dl.neighbourhood_cleansed, SUM(CASE WHEN AVAILABLE = 'FALSE' then 1 else 0 end) as booked_nights
, COUNT(*) AS total_nights, 
(SUM(CASE WHEN AVAILABLE = 'FALSE' then 1 else 0 end)/COUNT(*) )*100 as occupancy_rate
from AIRBNB_DB.ANALYTICS.DIM_LISTING dl
join AIRBNB_DB.ANALYTICS.FACT_CALENDAR fc 
on dl.LISTING_ID= fc.listing_id
group by dl.neighbourhood_cleansed
order by occupancy_rate desc
limit 20
; 

--Q2)ADR (Average Daily Rate) for non-booked nights, by month
select  dd.month, dd.month_name, AVG(fc.daily_price) AS Avg_daily_price
FROM AIRBNB_DB.ANALYTICS.FACT_CALENDAR fc
join AIRBNB_DB.ANALYTICS.DIM_DATE dd 
on fc.date = dd.date
where fc.available = TRUE
group by 1,2
order by 1;

--Q3. Revenue proxy = sum(daily_price) on non-booked nights.
--Total potential listed revenue (inventory value) per listing
SELECT listing_id, sum(daily_price) as listed_inventory_value
from AIRBNB_DB.ANALYTICS.FACT_CALENDAR 
where available = TRUE
 AND daily_price IS NOT NULL
group by 1
order by 2 desc;

--Q4.High listed price but low booking pressure
select neighbourhood_cleansed, AVG(CASE WHEN available=TRUE THEN daily_price END) as listed_adr,
sum(case when available =FALSE then 1 else 0 END)/ count(*) as not_available_rate
from AIRBNB_DB.ANALYTICS.FACT_CALENDAR fc
join AIRBNB_DB.ANALYTICS.DIM_LISTING dl
on fc.listing_id = dl.listing_id
group by 1
order by listed_adr desc
limit 25;
--Occupancy here is measured as the share of calendar days marked unavailable, which approximates booking pressure but may also include host-blocked days.


--Problem 5: Weekend premium (price difference)
--Question: By neighborhood, compare weekend vs weekday on: occupancy, listed price
select neighbourhood_cleansed, sum(case when dd.is_weekend = TRUE and fc.available = FALSE then 1 else 0 end)/ 
nullif(SUM(CASE WHEN IS_WEEKEND = true then 1 else 0 end),0) as weekend_occupancy_rate,
sum(case when dd.is_weekend = FALSE and fc.available = FALSE then 1 else 0 end)/ 
nullif(SUM(CASE WHEN IS_WEEKEND = FALSE then 1 else 0 end),0) as weekday_occupancy_rate,
(sum(case when dd.is_weekend = TRUE and fc.available = FALSE then 1 else 0 end)/ 
nullif(SUM(CASE WHEN IS_WEEKEND = true then 1 else 0 end),0)) - (sum(case when dd.is_weekend = FALSE and fc.available = FALSE then 1 else 0 end)/ nullif(SUM(CASE WHEN IS_WEEKEND = FALSE then 1 else 0 end),0)) as occupancy_uplift ,
avg(iff(is_weekend = TRUE and available = TRUE, daily_price, NULL)) AS weekend_listed_adr,
AVG(IFF(IS_WEEKEND = false and available = TRUE,daily_price, NULL))  AS weekday_listed_adr,
(avg(iff(is_weekend = TRUE and available = TRUE, daily_price, NULL))) - (AVG(IFF(IS_WEEKEND = false and available = TRUE,daily_price, NULL)))  AS listed_premium
from AIRBNB_DB.ANALYTICS.DIM_LISTING dl 
join AIRBNB_DB.ANALYTICS.FACT_CALENDAR fc
on dl.listing_id = fc.listing_id
join AIRBNB_DB.ANALYTICS.DIM_DATE dd
on dd.date = fc.date
group by neighbourhood_cleansed
ORDER BY listed_premium DESC;
--Listings in that neighborhood are more booked on weekdays than weekends (negative occupancy_uplift)


