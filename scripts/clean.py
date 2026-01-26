import pandas as pd
import os

os.makedirs("data/clean", exist_ok=True)

# -------- CALENDAR --------
calendar = pd.read_csv("data/raw/calendar.csv")
calendar['date'] = pd.to_datetime(calendar['date'])
calendar['price'] = (
    calendar['price']
    .str.replace('[$,]', '', regex=True)
    .astype(float)
)
calendar['available'] = calendar['available'].map({'t': True, 'f': False})
calendar.to_csv("data/clean/calendar_clean.csv", index=False)

# -------- LISTINGS --------
listings = pd.read_csv("data/raw/listings.csv")
listings.columns = listings.columns.str.lower()
listings.to_csv("data/clean/listings_clean.csv", index=False)

# -------- REVIEWS --------
reviews = pd.read_csv("data/raw/reviews.csv")
reviews['date'] = pd.to_datetime(reviews['date'])
reviews.to_csv("data/clean/reviews_clean.csv", index=False)

print("Clean files saved in data/clean/")
