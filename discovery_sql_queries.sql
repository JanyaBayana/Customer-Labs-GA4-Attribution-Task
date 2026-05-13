-- TIMESTAMP_MICROS converts GA4's weird microsecond timestamps to datetime. 
--_TABLE_SUFFIX is how you filter across tables without scanning everything — critical for cost control. : THIS IS A NEW LEARNING 

select *
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
where _TABLE_SUFFIX = '20201101'
limit 5;


-- checking the events 
select
event_name,
count(*) as total
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
where _TABLE_SUFFIX between '20201101' and '20210131' group by 1 order by total desc;

-- Row	event_name	total
-- 1	page_view	1350428
-- 2	user_engagement	1058721
-- 3	scroll	493072
-- 4	view_item	386068
-- 5	session_start	354970
-- 6	first_visit	257462
-- 7	view_promotion	190104
-- 8	add_to_cart	58543
-- 9	begin_checkout	38757
-- 10	select_item	31007
-- 11	view_search_results	26172
-- 12	add_shipping_info	19722
-- 13	add_payment_info	13899
-- 14	select_promotion	9450
-- 15	purchase	5692
-- 16	click	1446
-- 17	view_item_list	71


 -- how much purchages were actually there
select
count(*) as total_purchases,
count(distinct user_pseudo_id) as unique_buyers,
round(sum(ecommerce.purchase_revenue), 2) as total_revenue,
round(avg(ecommerce.purchase_revenue), 2) as avg_order_value,
round(min(ecommerce.purchase_revenue), 2) as min_order,
round(max(ecommerce.purchase_revenue), 2) as max_order
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
where _TABLE_SUFFIX between '20201101' and '20210131' and event_name = 'purchase';
  
-- Row	total_purchases	unique_buyers	total_revenue	avg_order_value	min_order	max_order
-- 1	5692	4419	362165.0	69.09	1.0	1530.0


-- which channels are driving the most traffic
select
traffic_source.source as source,
traffic_source.medium as medium,
count(distinct user_pseudo_id) as users,
count(*) as events
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` where _TABLE_SUFFIX between '20201101' and '20210131'
group by 1, 2 order by users desc 
limit 15;

-- THERE IS DATA DELETED HEREEou can't attribute this properly — it needs to be flagged
-- in here looks like google organic  is driving most of it. 

-- what channels are drivng the most revenuE
select
traffic_source.source  as source,
traffic_source.medium  as medium,
count(*)  as purchases,
count(distinct user_pseudo_id)    as unique_buyers,
round(sum(ecommerce.purchase_revenue), 2) as total_revenue,
round(avg(ecommerce.purchase_revenue), 2) as avg_order_value
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
where _TABLE_SUFFIX between '20201101' and '20210131' and event_name = 'purchase'
group by 1, 2 order by total_revenue desc;

-- notes here worth to note 
-- google organic tops with most rev - but aov 71 
-- direct traffic is next highest, which means this is a last click issue, these users maybe came from google / email 
-- reffferal channel has the highes aov, so might get more credit for the first click??
-- paid ads from google showing the least purchases and cheapest ones.  ( BUT IMP TO NOTE IS THAT : IT STILL SHOWS GOOD TRAFFIC AND EVENTS CREATED ) so still gets some atrribution. 

-- seeing both traffic and rev driving channels 
-- google organic- brings the most but converts the least
-- google cpc is the worst , lowest aov
-- direct traffic converts better than 
--   Shop referral converts — highest of all channels.







