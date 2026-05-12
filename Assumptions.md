These are the assumptions made for the dbt models

**For verifying a persons identity**
1. Using `user_pseudo_id` as the user identifier
2. This is a device-level ID, not a person-level ID
3. Limitation: same person on mobile + desktop = two different users
4. Production fix: join on `user_id` (logged-in) where available, 
  fall back to `user_pseudo_id` for anonymous users


**Conversion Events**
1. Only `purchase` events counted as conversions
2. `begin_checkout` and `add_to_cart` are NOT conversions
3. Revenue taken from `ecommerce.purchase_revenue`


**Lookback window ( 30 days )**
1. 30 days before each conversion
2. dont want to include older as they attribute to irrelevnt old touches. 


**Multiconversion users ( if the make purchages at more than one touch point )**
1. Each conversion is treated independently
2. Both have thier own 30-day lookback window
3. No deduplicaiton of users across conversions


**Session Sources **
1. Using `traffic_source.*` which is set at user acquisition level in GA4
2. We dont have per session source. thus we have only the first session source - 
3. Workaround: use `session_traffic_source_last_click` event params where available


**Tie breakers**
 1. If 2 touchpoints same timestamp → lower session_id wins (deterministic)
 2. Direct traffic ((direct)/(none)) IS counted as a touchpoint
 3. Self-referral (shop.googlemerchandisestore.com) included but flagged
