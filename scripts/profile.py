import pandas as pd

calendar = pd.read_csv("data/raw/calendar.csv")
listings = pd.read_csv("data/raw/listings.csv")
reviews = pd.read_csv("data/raw/reviews.csv")

for name, df in {
    "calendar": calendar,
    "listings": listings,
    "reviews": reviews
}.items():
    print(f"\n{name.upper()} | shape = {df.shape}")
    print(df.dtypes)
    print("\nNull % (top 10):")
    print((df.isna().mean() * 100).sort_values(ascending=False).head(10))
