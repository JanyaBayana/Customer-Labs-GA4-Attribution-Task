import uuid, time, random
from datetime import datetime, timezone
from google.cloud import bigquery

PROJECT = "customer-labs-ga4-attribution"
client  = bigquery.Client(project=PROJECT)
TABLE   = f"{PROJECT}.attribution_demo.streaming_events"

SOURCES = [
    ("google",    "cpc"),
    ("email",     "newsletter"),
    ("instagram", "social"),
    ("(direct)",  "(none)"),
    ("facebook",  "social"),
]

FUNNEL = ["page_view", "page_view", "add_to_cart", "purchase"]

USER_POOL = [f"user_{i:03d}" for i in range(1, 31)]  

print("Streaming events...\n")
print(f"{'#':<4} {'user':<12} {'event':<14} {'source':<12} {'medium':<14} {'revenue'}")
print("-" * 65)

for i in range(1, 16):
    user_id       = random.choice(USER_POOL)
    src, med      = random.choice(SOURCES)
    event         = random.choice(FUNNEL)
    is_purchase   = event == "purchase"
    revenue       = round(random.uniform(20, 200), 2) if is_purchase else 0.0

    row = {
        "event_id":   str(uuid.uuid4()),
        "event_ts":   datetime.now(timezone.utc).isoformat(),
        "user_id":    user_id,
        "event_name": event,
        "source":     src,
        "medium":     med,
        "revenue":    revenue,
    }

    errors = client.insert_rows_json(TABLE, [row], row_ids=[row["event_id"]])
    status = "✓" if not errors else "✗"

    print(f"{status} [{i:<2}] {user_id:<12} {event:<14} {src:<12} {med:<14} {revenue if is_purchase else ''}")
    time.sleep(2)

print("\nDone. Verify in BQ:")
print(f"  SELECT * FROM `{TABLE}` ORDER BY event_ts DESC LIMIT 20")