with touchpoints as (
select * from {{ ref('int_user_touchpoints') }}
where touch_rank_asc = 1),

aggregated as (
select
date(conversion_ts) as conversion_date,
coalesce(source, '(direct)') as source,
coalesce(medium, '(none)') as medium,
coalesce(campaign, '(not set)') as campaign,
country,
device_category,
count(*) as conversions,
round(sum(revenue), 2) as revenue,
round(avg(revenue), 2) as avg_order_value,
round(avg(total_touches), 2) as avg_touches_to_convert,
round(avg(days_before_conversion), 1) as avg_days_to_convert
from touchpoints
group by 1, 2, 3, 4, 5, 6
)

select * from aggregated
order by conversion_date, conversions desc