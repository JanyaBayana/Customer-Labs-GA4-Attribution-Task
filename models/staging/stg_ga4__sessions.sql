with events as (
select * from {{ ref('stg_ga4__events') }}),

sessions as (
select
user_pseudo_id,
session_id,
min(event_ts) as session_start,
max(event_ts) as session_end,
max(source) as source,
max(medium) as medium,
max(campaign) as campaign,
max(country) as country,
max(device_category) as device_category,
max(is_purchase) as is_conversion,
max(revenue) as revenue,
countif(event_name = 'page_view') as pageviews,
countif(event_name = 'view_item') as product_views,
max(if(session_engaged = '1', 1, 0)) as is_engaged,
case
    when max(is_purchase) = 1 then '4_purchase'
    when max(is_begin_checkout) = 1 then '3_checkout'
    when max(is_add_to_cart) = 1 then '2_add_to_cart'
    else '1_browse'
end as funnel_stage
from events
group by 1, 2
)

select * from sessions
where session_start is not null