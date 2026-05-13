with source as (
select * from {{ source('ga4', 'events') }}
where _table_suffix between '20201101' and '20210131'),

renamed as (
select
user_pseudo_id,
timestamp_micros(event_timestamp) as event_ts,
parse_date('%Y%m%d', event_date) as event_date,
(select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
event_name,
nullif(traffic_source.source, '(not set)') as source,
nullif(traffic_source.medium, '(not set)') as medium,
nullif(traffic_source.name, '(not set)') as campaign,
(select value.string_value from unnest(event_params) where key = 'page_location') as page_location,
coalesce(ecommerce.purchase_revenue, 0) as revenue,
(select value.string_value from unnest(event_params) where key = 'session_engaged') as session_engaged,
device.category as device_category,
device.operating_system as operating_system,
geo.country as country,
geo.region as region,
if(event_name = 'purchase', 1, 0) as is_purchase,
if(event_name = 'add_to_cart', 1, 0) as is_add_to_cart,
if(event_name = 'begin_checkout', 1, 0) as is_begin_checkout
from source
)

select * from renamed
where session_id is not null