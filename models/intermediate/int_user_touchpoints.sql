with sessions as (
select * from {{ ref('stg_ga4__sessions') }}),

conversions as (
select * from sessions
where is_conversion = 1),

touchpoints as (
select
c.user_pseudo_id,
c.session_id as conversion_session_id,
c.session_start as conversion_ts,
c.revenue,
t.session_id as touch_session_id,
t.session_start as touch_ts,
t.source,
t.medium,
t.campaign,
t.country,
t.device_category,
t.funnel_stage,
timestamp_diff(c.session_start, t.session_start, day) as days_before_conversion,
if(t.session_id = c.session_id, 1, 0) as is_conversion_touch,
row_number() over (
    partition by c.user_pseudo_id, c.session_id
    order by t.session_start asc, t.session_id asc
) as touch_rank_asc,
row_number() over (
    partition by c.user_pseudo_id, c.session_id
    order by t.session_start desc, t.session_id desc
) as touch_rank_desc,
count(*) over (
    partition by c.user_pseudo_id, c.session_id
) as total_touches
from conversions c
join sessions t
    on c.user_pseudo_id = t.user_pseudo_id
    and t.session_start between timestamp_sub(c.session_start, interval 30 day) and c.session_start
)

select * from touchpoints