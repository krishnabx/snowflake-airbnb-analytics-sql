import pandas as pd

calendar = pd.read_csv("data/raw/calendar.csv")
listings = pd.read_csv("data/raw/listings.csv")
reviews = pd.read_csv("data/raw/reviews.csv")

# Shapes
print("calendar:", calendar.shape)
print("listings:", listings.shape)
print("reviews:", reviews.shape)

# Basic checks
print(calendar.head())
print(listings.head())
print(reviews.head())

# Price distribution (calendar)
calendar['price'] = calendar['price'].str.replace('[$,]', '', regex=True).astype(float)
print(calendar['price'].describe())

# Availability rate
print(calendar['available'].value_counts(normalize=True))

# Reviews over time
reviews['date'] = pd.to_datetime(reviews['date'])
print(reviews.groupby(reviews['date'].dt.year).size())
