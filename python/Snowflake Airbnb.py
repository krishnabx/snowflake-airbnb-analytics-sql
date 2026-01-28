#!/usr/bin/env python
# coding: utf-8

# In[19]:


import pandas as pd


# In[20]:


calendar = pd.read_csv("/Users/krishnabarfiwala/Desktop/Projects/Snowflake Airbnb/data/clean/calendar_clean.csv")


# In[21]:


calendar.head()


# In[22]:


df =calendar 


# In[23]:


df.shape


# In[24]:


df.info()


# In[25]:


df['price'].isna().sum()


# In[26]:


df.isnull().sum()


# In[27]:


1393570-459028


# In[ ]:





# In[28]:


listing = pd.read_csv("/Users/krishnabarfiwala/Desktop/Projects/Snowflake Airbnb/data/clean/listings_clean.csv")


# In[29]:


listing.head()


# In[30]:


listing.shape


# In[31]:


listing.columns


# In[32]:


listing.info()


# In[33]:


#listing.drop(columns=['experiences_offered','license'], inplace = True)


# In[34]:


listing.shape


# In[36]:


import os
desktop_path = os.path.expanduser("~/Desktop/listings_cleaned.csv")

listing.to_csv(desktop_path, index=False)

print(f"File saved to: {desktop_path}")


# In[37]:


reviews = pd.read_csv("/Users/krishnabarfiwala/Desktop/Projects/Snowflake Airbnb/data/clean/reviews_clean.csv")


# In[38]:


reviews.head()


# In[39]:


reviews.info()


# In[41]:


print("calendar cols:", list(calendar.columns)[:20])
print("listings cols:", list(listing.columns)[:20])
print("reviews cols:", list(reviews.columns)[:20])


# In[42]:


listing_key = "id"  # if your column name differs, change this

total_rows = len(listing)
unique_ids = listing[listing_key].nunique()
dupe_rows  = total_rows - unique_ids

print("LISTINGS grain: 1 row = 1 listing")
print("rows:", total_rows)
print("unique listing ids:", unique_ids)
print("duplicate id rows:", dupe_rows)

# show duplicates (if any)
listing[listing.duplicated(subset=[listing_key], keep=False)].head(10)


# In[43]:


cal_keys = ["listing_id", "date"]  # change if your columns differ

total_rows = len(calendar)
unique_pairs = calendar[cal_keys].drop_duplicates().shape[0]
dupe_rows = total_rows - unique_pairs

print("CALENDAR grain: 1 row = 1 listing x 1 date")
print("rows:", total_rows)
print("unique (listing_id, date):", unique_pairs)
print("duplicate pairs:", dupe_rows)

# show duplicate pairs (if any)
calendar[calendar.duplicated(subset=cal_keys, keep=False)].sort_values(cal_keys).head(10)


# In[44]:


# common columns: listing_id, date, reviewer_id (sometimes), comments
print(reviews.head(3))

# If reviewer_id exists, use it. If not, use a safer dedupe proxy.
candidate_cols = [c for c in ["listing_id", "date", "reviewer_id", "comments"] if c in reviews.columns]
print("Using these columns to check dupes:", candidate_cols)

total_rows = len(reviews)
unique_proxy = reviews[candidate_cols].drop_duplicates().shape[0] if candidate_cols else total_rows
dupe_rows = total_rows - unique_proxy

print("REVIEWS grain: 1 row = 1 review event (proxy check)")
print("rows:", total_rows)
print("unique (proxy):", unique_proxy)
print("duplicate proxy rows:", dupe_rows)


# In[45]:


calendar.isna().mean().sort_values(ascending=False).head(10)


# In[65]:


listing.isna().mean().sort_values(ascending=False).head(10)


# In[48]:


reviews.isna().mean().sort_values(ascending=False).head(10)


# In[66]:


calendar.dtypes


# In[51]:


reviews.dtypes


# In[52]:


listing.dtypes


# In[53]:


calendar_clean = calendar.copy()
calendar_clean['date'] = pd.to_datetime(calendar_clean['date'])


# In[67]:


calendar_clean.dtypes


# In[55]:


reviews_clean = reviews.copy()
reviews_clean['date'] = pd.to_datetime(reviews_clean['date'])


# In[56]:


reviews_clean.dtypes


# In[58]:


listing.dtypes.value_counts()


# In[59]:


#gives the columns with % of missing values. eg. square_feet column has 97% of rows missing. 
(listing.isna().mean().sort_values(ascending=False).head(20))


# In[60]:


#based on the above information, removing a few columns
listing.drop(columns=['scrape_id', 'last_scraped', 'square_feet','monthly_price','security_deposit', 'weekly_price','notes',
                      'neighborhood_overview','cleaning_fee', 'transit', 'host_about'], inplace = True)


# In[73]:


desktop_path = os.path.expanduser("~/Desktop/Projects/Snowflake Airbnb/data/clean/listings_cleaned.csv")
listing.to_csv(desktop_path, index=False)
print(f"File saved to: {desktop_path}")


# In[68]:


desktop_path = os.path.expanduser("~/Desktop/Projects/Snowflake Airbnb/data/clean/calendar_cleaned.csv")
calendar_clean.to_csv(desktop_path, index=False)
print(f"File saved to: {desktop_path}")


# In[69]:


desktop_path = os.path.expanduser("~/Desktop/Projects/Snowflake Airbnb/data/clean/reviews_cleaned.csv")
reviews_clean.to_csv(desktop_path, index=False)
print(f"File saved to: {desktop_path}")


# In[77]:


calendar_clean.columns


# In[78]:


reviews_clean.columns


# In[80]:


listing.columns


# In[81]:


calendar_clean.columns


# In[84]:


reviews_clean.columns


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




