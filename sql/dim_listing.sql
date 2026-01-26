USE DATABASE AIRBNB_DB;
USE SCHEMA ANALYTICS;


-- 1. CREATE TABLE with proper schema
CREATE TABLE DIM_LISTING (
    listing_id INT PRIMARY KEY,
    host_id INT,
    
    -- Property attributes
    property_type VARCHAR(100),
    room_type VARCHAR(50),
    accommodates INT,
    bathrooms FLOAT,
    bedrooms INT,
    beds INT,
    bed_type VARCHAR(50),
    amenities TEXT,
    
    -- Location
    neighbourhood_cleansed VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(50),
    zipcode VARCHAR(20),
    latitude FLOAT,
    longitude FLOAT,
    
    -- Pricing policy
    base_price FLOAT,
    extra_people FLOAT,
    guests_included INT,
    minimum_nights INT,
    maximum_nights INT,
    
    -- Booking policies
    instant_bookable BOOLEAN,
    cancellation_policy VARCHAR(50),
    require_guest_profile_picture BOOLEAN,
    require_guest_phone_verification BOOLEAN,
    
    -- Review metrics
    number_of_reviews INT,
    first_review DATE,
    last_review DATE,
    review_scores_rating FLOAT,
    review_scores_accuracy FLOAT,
    review_scores_cleanliness FLOAT,
    review_scores_checkin FLOAT,
    review_scores_communication FLOAT,
    review_scores_location FLOAT,
    review_scores_value FLOAT,
    reviews_per_month FLOAT,
    
    -- Foreign key
    FOREIGN KEY (host_id) REFERENCES DIM_HOST(host_id)
);

INSERT INTO DIM_LISTING
SELECT 
    id::INT AS listing_id,
    host_id::INT AS host_id,

    property_type::VARCHAR(100),
    room_type::VARCHAR(50),
    accommodates::INT,
    bathrooms::FLOAT,
    bedrooms::INT,
    beds::INT,
    bed_type::VARCHAR(50),
    amenities::TEXT,

    neighbourhood_cleansed::VARCHAR(100),
    city::VARCHAR(100),
    state::VARCHAR(50),
    zipcode::VARCHAR(20),
    latitude::FLOAT,
    longitude::FLOAT,

    TRY_TO_NUMBER(REPLACE(REPLACE(price, '$', ''), ',', ''))::FLOAT AS base_price,
    TRY_TO_NUMBER(REPLACE(REPLACE(extra_people, '$', ''), ',', ''))::FLOAT AS extra_people,
    guests_included::INT,
    minimum_nights::INT,
    maximum_nights::INT,

    instant_bookable::BOOLEAN,
    cancellation_policy::VARCHAR(50),
    require_guest_profile_picture::BOOLEAN,
    require_guest_phone_verification::BOOLEAN,

    number_of_reviews::INT,
    TRY_TO_DATE(first_review) AS first_review,
    TRY_TO_DATE(last_review) AS last_review,
    review_scores_rating::FLOAT,
    review_scores_accuracy::FLOAT,
    review_scores_cleanliness::FLOAT,
    review_scores_checkin::FLOAT,
    review_scores_communication::FLOAT,
    review_scores_location::FLOAT,
    review_scores_value::FLOAT,
    reviews_per_month::FLOAT
FROM AIRBNB_DB.RAW.LISTINGS
WHERE id IS NOT NULL;


SELECT * FROM AIRBNB_DB.ANALYTICS.DIM_LISTING;


SELECT base_price, extra_people
FROM AIRBNB_DB.ANALYTICS.DIM_LISTING
WHERE base_price IS NOT NULL
LIMIT 10;

show columns in table airbnb_db.analytics.dim_listing;