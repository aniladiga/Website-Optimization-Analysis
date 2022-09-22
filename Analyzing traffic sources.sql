#Traffic Source Analysis

select * from website_sessions
where website_session_id between 1000 and 2000;

select 
w.utm_content,
count(distinct w.website_session_id) as sessions,
count(distinct o.order_id) as orders,
round(count(distinct o.order_id)/count(distinct w.website_session_id)*100,2) as session_to_order
from website_sessions as w
left join orders as o on w.website_session_id=o.website_session_id
where w.website_session_id between 1000 and 2000
group by 1
order by 2 desc;

#Finding top traffic sources

select utm_source,
utm_campaign,
http_referer,
count(distinct website_session_id) as sessions
from website_sessions
where created_at<'2012-04-12'
group by 1,2,3
order by 4 desc;

#Traffic source conversion rates

select count(distinct w.website_session_id) as sessions,
count(distinct o.order_id) as orders,
round(count(distinct o.order_id)/count(distinct w.website_session_id)*100,2) as session_to_order_conv_rate
from website_sessions w
left join orders o on w.website_session_id=o.website_session_id
where w.created_at<'2012-04-14' and w.utm_source='gsearch' and w.utm_campaign='nonbrand';

#Bid Optimization

select year(created_at),
week(created_at),
min(date(created_at)) as week_start,
count(distinct website_session_id) as sessions
from website_sessions
where website_session_id between 100000 and 115000
group by 2;

select primary_product_id,
count(distinct case when items_purchased=1 then order_id else null end) o1,
count(distinct case when items_purchased=2 then order_id else null end) o2,
count(distinct order_id) as orders
from orders
where order_id between 31000 and 32000
group by 1;

#Traffic source trending

select 
min(date(created_at)) as week_start_date,
count(distinct website_session_id) as sessions
from website_sessions where 
created_at <'2012-05-10' and utm_source='gsearch' and utm_campaign='nonbrand'
group by week(created_at);

#Bid optimization for paid traffic based on device_type

select w.device_type,
count(distinct w.website_session_id) as sessions,
count(distinct o.order_id) as orders,
round(count(distinct o.order_id)/count(distinct w.website_session_id)*100,2) as session_to_order_conv_rate
from website_sessions w
left join orders o on w.website_session_id=o.website_session_id
where w.created_at<'2012-05-11' and utm_source='gsearch' and utm_campaign='nonbrand'
group by 1;

#Traffic source with segment trending

select min(date(created_at)) as week_start_date,
count(distinct case when device_type='desktop' then website_session_id else null end)as dtop_sessions,
count(distinct case when device_type='mobile' then website_session_id else null end)as mob_sessions
from website_sessions
where created_at between '2012-04-15' and '2012-06-09'
and utm_source='gsearch' 
and utm_campaign='nonbrand' 
group by week(created_at);