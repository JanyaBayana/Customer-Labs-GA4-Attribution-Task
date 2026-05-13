with first_click as (
select
source, medium,
sum(conversions) as fc_conversions,
round(sum(revenue), 2) as fc_revenue
from {{ ref('mart_attribution_first_click') }}
group by 1, 2),

last_click as (
select
source, medium,
sum(conversions) as lc_conversions,
round(sum(revenue), 2) as lc_revenue
from {{ ref('mart_attribution_last_click') }}
group by 1, 2),

combined as (
select
coalesce(f.source, l.source) as source,
coalesce(f.medium, l.medium) as medium,
coalesce(f.fc_conversions, 0) as first_click_conversions,
coalesce(l.lc_conversions, 0) as last_click_conversions,
coalesce(f.fc_revenue, 0) as first_click_revenue,
coalesce(l.lc_revenue, 0) as last_click_revenue,
coalesce(f.fc_conversions, 0) - coalesce(l.lc_conversions, 0) as conversion_delta,
coalesce(f.fc_revenue, 0) - coalesce(l.lc_revenue, 0) as revenue_delta
from first_click f
full outer join last_click l using (source, medium)
)

select * from combined
order by first_click_conversions desc