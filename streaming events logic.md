user → google/cpc     → page_view      (Day 1 - first touch)
user → email          → add_to_cart    (Day 3 - middle touch)
user → instagram      → purchase       (Day 5 - last touch, converts)

First-Click credits → google/cpc
Last-Click credits  → instagram


Script that:

1. Randomly chooses a person out of 30 users 
2. Create a funnel sequence where the user always moves forward
3. list out all the sources possible
4. ensure no duplication - > within one min window must deduple based on UUID



Code Logic Base:

sources  = google, cpc, instagram, email, newsletter., direct, none, facebook, social, 

Funnel = page view, add to cart, purchase , page view 

user pool =  user for i in range ( 1, 31)  -> 30 fake users


Core;
```
for i in range(1, 31):
    user_id       = random.choice(USER_POOL)
    src, med      = random.choice(SOURCES)
    event         = random.choice(FUNNEL)
    is_purchase   = event == "purchase"
    revenue       = round(random.uniform(20, 200), 2) if is_purchase else 0.0

    row=
  { "event_id":   str(uuid.uuid4()),
        "event_ts":   datetime.now(timezone.utc).isoformat(),
        "user_id":    user_id,
        "event_name": event,
        "source":     src,
        "medium":     med,
        "revenue":    revenue, } 

```



Streaming doesnt work on free trials - an other alternative would be the load jobs ( we can mimic the streaming process.  so i will have both the codes linked. But im using the load jobs to complete this section of the task

load jobs->
changes would be : 
Added imports — json, os, tempfile 
Added job_config — defines the schema and tells BQ to append rows
Replaced the insert_rows_json block with the temp file → load job → delete temp file pattern
event_ts format changed from .isoformat() to strftime("%Y-%m-%d %H:%M:%S") — BQ load jobs are stricter about timestamp format

    
