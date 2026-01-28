# Assumptions & Limitations

1) Pricing field availability
- In this dataset, daily_price is reliably available for `available = TRUE` rows (listed price).
- Price is often missing or not usable for `available = FALSE` (booked/unavailable), so analyses avoid claiming realized revenue.

2) Occupancy definition
- Occupancy proxy = share of dates where `available = FALSE` for a listing/neighborhood over the dataset period.

3) “New listing performance”
- Time-to-first-booking is calculated from the earliest calendar date present for that listing to the first observed booked date.
- This is not the true listing creation date.

4) Causality
- Review-related analyses are treated as correlation signals, not causal proof.
