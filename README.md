# GA4 Attribution Pipeline — CustomerLabs Task

**Stack:** BigQuery · dbt Core · Looker Studio · Python  
**Dataset:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce`

---

## What this does

Takes raw GA4 event data from Google's public ecommerce dataset, builds a proper attribution pipeline in dbt, and answers one business question:

> Which marketing channel actually deserves credit for a sale — the one that introduced the customer, or the one that closed them?

Two models. First-click (who introduced them). 
Last-click (who closed them). 
A dashboard that shows where the credit shifts between the two.

---

## The thought process ( PLEASE REFER THE OTHER MD'S IN THE GITHUB REPO )

Started with discovery queries before touching dbt. Wanted to understand the data first — how many purchase events, which channels exist, what the funnel drop-off looks like. 

Biggest thing i noticed early: direct traffic showing up as #2 revenue channel. People don't just type a merch store URL from nowhere. That's a last-click problem — those users came from google or email first, bounced, then came back directly to buy. First-click attribution redistributes that credit back where it belongs.


## Errors i hit and how i fixed them

**Streaming insert 403 — not allowed on free tier**
`insert_rows_json` requires a paid BQ project. Switched to `load_table_from_file` which uses load jobs instead. 

**`accepted_values` test failing on `is_conversion`**
dbt was comparing an INT64 column to strings. Fixed by adding `quote: false` to the test config.

**`_TABLE_SUFFIX` learning**
Thought i needed to ingest the GA4 public dataset. You dont. It lives in BQ already at `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`. Just query it directly. `_TABLE_SUFFIX` filters which daily tables get scanned — critical for cost control.

---

## Cost notes

**This project as built: ~$0**

- GA4 public dataset queries: free (public data)
- BQ load jobs for streaming: free
- dbt Core: free (open source, runs locally)
- Looker Studio: free

**If productionised:**

- BQ queries cost $5 per TB scanned. The full GA4 dataset is ~2GB so a full scan costs ~$0.01. With `_TABLE_SUFFIX` filtering to one month it's closer to $0.001 per run.
- Streaming inserts on paid tier: $0.01 per 200MB. For 15 events per demo run this is effectively $0.
- dbt Cloud (if you want scheduling + CI): starts at $100/month for team plan. For solo use, dbt Core on a $5 VM is fine.
- Looker Studio: free forever for BQ connector.

Main cost risk is accidentally running a query without `_TABLE_SUFFIX` on a large date range. Always filter. Set a BQ budget alert just in case.

---

## Key findings from the data in my data discovery sequel


Built for CustomerLabs Data Engineer take-home task.  
Questions about the pipeline or live walkthrough — reply to jobs@customerlabs.co
