select pageview_url,
count(distinct website_pageview_id) as pvs
 from website_pageviews
where website_pageview_id<1000
group by 1
order by 2 desc;

###Analyzing Top website pages

create temporary table first_pageview
select 
min(website_pageview_id) as min_pv_id,
website_session_id
from website_pageviews
where website_pageview_id<1000
group by 2;

select *
from first_pageview f
left join website_pageviews w on
f.min_pv_id=w.website_pageview_id;

select w.pageview_url as landing_page,
count(distinct f.website_session_id) as sessions_hitting_this_lander
from first_pageview f
left join website_pageviews w on
f.min_pv_id=w.website_pageview_id
group by 1;

select distinct pageview_url from website_pageviews;

##identifying top website pages

select pageview_url,
count(distinct website_pageview_id) as sessions
from website_pageviews
where created_at<'2012-06-09'
group by 1
order by 2 desc;

## Finding top entry pages

create temporary table first_page_views
select website_session_id,
min(website_pageview_id) as min_page
from website_pageviews
where created_at<'2012-06-12'
group by 1;

select * from first_page_views;

select w.pageview_url as landing_page,
count(distinct f.website_session_id) as sessions_hitting_this_landing_page
from first_page_views f 
left join website_pageviews w on
f.min_page=w.website_pageview_id
group by 1
order by 2 desc;

###Analyzing Bounce Rates and Landing pages
select * from website_pageviews;

select wp.website_session_id,
min(wp.website_pageview_id) as min_pageview_id
from website_pageviews wp
inner join website_sessions w on
w.website_session_id=wp.website_session_id and
wp.created_at between '2014-01-01' and '2014-02-01'
group by wp.website_session_id;

create temporary table first_pageviews_demo3
select wp.website_session_id,
min(wp.website_pageview_id) as min_pageview_id
from website_pageviews wp
inner join website_sessions w on
w.website_session_id=wp.website_session_id and
wp.created_at between '2014-01-01' and '2014-02-01'
group by wp.website_session_id;

select * from first_pageviews_demo3;
select * from website_pageviews;
select * from website_sessions;

create temporary table sessions_w_landing_page_demo3
select fpd.website_session_id,
wp.pageview_url as landing_page
from first_pageviews_demo3 fpd
left join website_pageviews wp on
wp.website_pageview_id=fpd.min_pageview_id;

select * from sessions_w_landing_page_demo3;

create temporary table bounced_sessions_only
select swlpd3.website_session_id,
swlpd3.landing_page,
count(distinct wp.website_pageview_id) as count_of_pages_viewed
from sessions_w_landing_page_demo3 swlpd3
left join website_pageviews wp on
wp.website_session_id=swlpd3.website_session_id
group by 1,2
having count(wp.website_pageview_id)=1;

select * from bounced_sessions_only;

select swlpd3.landing_page,
swlpd3.website_session_id,
bso.website_session_id as bounced_sessions
from sessions_w_landing_page_demo3 as swlpd3
left join bounced_sessions_only bso on
swlpd3.website_session_id=bso.website_session_id
order by 2;

select * from sessions_w_landing_page_demo3;
select * from bounced_sessions_only;

select swlpd3.landing_page,
count(distinct swlpd3.website_session_id) as sessions,
count(distinct bso.website_session_id) as bounced_sessions,
round(count(distinct bso.website_session_id)/count(distinct swlpd3.website_session_id)*100,2)as bounced_rate
from sessions_w_landing_page_demo3 swlpd3
left join bounced_sessions_only bso on
swlpd3.website_session_id=bso.website_session_id
where swlpd3.landing_page in ('/home','/lander-3','/lander-2')
group by 1
order by 4 desc;

###Calculating bounce rates

select wp.website_session_id,
min(wp.website_pageview_id) as min_pageview_id
from website_sessions w
inner join website_pageviews wp on 
w.website_session_id=wp.website_session_id
and w.created_at<'2012-06-14'
group by 1;

create temporary table first_pageview_demo5
select wp.website_session_id,
min(wp.website_pageview_id) as min_pageview_id
from website_sessions w
inner join website_pageviews wp on 
w.website_session_id=wp.website_session_id
and w.created_at<'2012-06-14'
group by 1;

create temporary table session_w_landing_page_w_home
select fpd5.website_session_id,
fpd5.min_pageview_id,
wp.pageview_url as landing_page
from first_pageview_demo5 fpd5 
left join website_pageviews wp on fpd5.min_pageview_id=wp.website_pageview_id
group by 1;

create temporary table bounced_sessions5
select swlpdh.website_session_id,
swlpdh.landing_page,
count(distinct wp.website_pageview_id) as count_of_pages_viewed
from session_w_landing_page_w_home swlpdh
left join website_pageviews wp on
wp.website_session_id=swlpdh.website_session_id
group by 1,2
having count(wp.website_pageview_id)=1;

select * from session_w_landing_page_w_home;

select swlpdh.landing_page,
count(distinct swlpdh.website_session_id) as sessions,
count(distinct bso.website_session_id) as bounced_sessions5,
round(count(distinct bso.website_session_id)/count(distinct swlpdh.website_session_id)*100,2)as bounced_rate
from session_w_landing_page_w_home as swlpdh
left join bounced_sessions5 bso on
swlpdh.website_session_id=bso.website_session_id
group by swlpdh.landing_page
order by 2;

##Analyzing landing page tests

select 
min(created_at) as first_created_at,
min(website_pageview_id) as first_pageview_id
from website_pageviews
where pageview_url='/lander-1'
and created_at is not null;


create temporary table first_test_pageviews
select wp.website_session_id,
min(wp.website_pageview_id) as min_pageview_id
from website_pageviews wp
inner join website_sessions w on wp.website_session_id=w.website_session_id
and w.created_at<'2012-07-28'
and wp.website_pageview_id>23504
and w.utm_source='gsearch'
and w.utm_campaign='nonbrand'
group by 1;

select * from first_test_pageviews;

create temporary table non_brand_test_w_landing_page
select ftp.website_session_id,
wp.pageview_url as landing_page
from first_test_pageviews ftp
left join website_pageviews wp on ftp.min_pageview_id=wp.website_pageview_id
where wp.pageview_url in ('/home','/lander-1');

select * from non_brand_test_w_landing_page;

create temporary table non_brand_test_bounced_sessions
select nbtwlp.website_session_id,
nbtwlp.landing_page,
count(wp.website_pageview_id) as count_of_sessions
from non_brand_test_w_landing_page nbtwlp
left join website_pageviews wp on nbtwlp.website_session_id=wp.website_session_id
group by 1,2
having count_of_sessions=1;

select * from non_brand_test_bounced_sessions;

select nbtwlp.landing_page,
count(distinct nbtwlp.website_session_id) as sessions,
count(distinct nbtbs.website_session_id) as bounced_sessions,
round(count(distinct nbtbs.website_session_id) /count(distinct nbtwlp.website_session_id)*100,2) as bounce_rates
from non_brand_test_w_landing_page nbtwlp
left join non_brand_test_bounced_sessions nbtbs on nbtwlp.website_session_id=nbtbs.website_session_id
group by 1;

#Landing page trend analysis

create temporary table sessions_w_min_pv_id_and_view_count
select website_sessions.website_session_id,
min(website_pageviews.website_pageview_id) as first_pageview_id,
count(website_pageviews.website_pageview_id) as count_of_pageviews
from website_sessions 
left join website_pageviews on website_pageviews.website_session_id=website_sessions.website_session_id
where website_sessions.created_at >'2012-06-01' and  website_sessions.created_at<'2012-08-31'
and website_sessions.utm_source='gsearch'
and website_sessions.utm_campaign='nonbrand'
group by website_sessions.website_session_id;

select * from sessions_w_min_pv_id_and_view_count;

create temporary table sessions_w_counts_lander_and_created_at
select swmpiav.website_session_id,
swmpiav.first_pageview_id,
swmpiav.count_of_pageviews,
wp.pageview_url as landing_page,
wp.created_at as session_created_at
from sessions_w_min_pv_id_and_view_count as swmpiav
left join website_pageviews wp on swmpiav.first_pageview_id=wp.website_pageview_id;

select * from sessions_w_counts_lander_and_created_at;

select 
min(date(session_created_at)) as week_start_date,
round(count(distinct case when count_of_pageviews=1 then website_session_id else null end)*100/count(distinct website_session_id),2) as bounce_rate,
count(distinct case when landing_page='/home' then website_session_id else null end) as home_sessions,
count(distinct case when landing_page='/lander-1' then website_session_id else null end) as lander_sessions,
round(count(distinct case when landing_page='/home' then website_session_id else null end)/count(distinct website_session_id)*100,2) as home_bounced_sessions,
round(count(distinct case when landing_page='/lander-1' then website_session_id else null end)/ count(distinct website_session_id)*100,2) as lander_bounced_sessions
from sessions_w_counts_lander_and_created_at
group by yearweek(session_created_at);

###Building conversion funnels

select w.website_session_id,
wp.pageview_url,
wp.created_at as pageview_created_at,
case when pageview_url='/products' then 1 else 0 end as products_page,
case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mr_fuzzy_page,
case when pageview_url='/cart' then 1 else 0 end as cart_page
from website_pageviews wp
left join website_sessions w on w.website_session_id=wp.website_session_id
where w.created_at between '2014-01-01' and '2014-02-01'
and wp.pageview_url in ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
order by 1,3;

create temporary table A
select website_session_id,
max(products_page) as product_made_it,
max(mr_fuzzy_page) as mrfuzzy_made_it,
max(cart_page) as cart_made_it
from
(select w.website_session_id,
wp.pageview_url,
wp.created_at as pageview_created_at,
case when pageview_url='/products' then 1 else 0 end as products_page,
case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mr_fuzzy_page,
case when pageview_url='/cart' then 1 else 0 end as cart_page
from website_pageviews wp
left join website_sessions w on w.website_session_id=wp.website_session_id
where w.created_at between '2014-01-01' and '2014-02-01'
and wp.pageview_url in ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
order by 1,3) as pageview_level
group by 1;

select * from A;

select 
count(distinct website_session_id) as sessions,
count(distinct case when product_made_it=1 then website_session_id else null end) as product_funnel,
count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end) as mrfuzzy_funnel,
count(distinct case when cart_made_it=1 then website_session_id else null end) as cart_funnel
from A;

select count(distinct website_session_id) as sessions,
round(count(distinct case when product_made_it=1 then website_session_id else null end)/count(distinct website_session_id)*100,2) as lander_clickthrough_rate ,
round(count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end)/count(distinct case when product_made_it=1 then website_session_id else null end)*100,2) as product_clickthrough_rate,
round(count(distinct case when cart_made_it=1 then website_session_id else null end)/count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end)*100,2) as mrfuzzy_clickthrough_rate
from A;

##Building conversion funnels

create temporary table D
select website_session_id,
max(products_page) as product_made_it,
max(mr_fuzzy_page) as mrfuzzy_made_it,
max(cart_page) as cart_made_it,
max(shipping_page) as shipping_made_it,
max(billing_page) as billing_made_it,
max(thankyou_page) as final_made_it
from
(select w.website_session_id,
wp.pageview_url,
case when pageview_url='/products' then 1 else 0 end as products_page,
case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mr_fuzzy_page,
case when pageview_url='/cart' then 1 else 0 end as cart_page,
case when pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when pageview_url='/billing' then 1 else 0 end as billing_page,
case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_pageviews wp
left join website_sessions w on w.website_session_id=wp.website_session_id
where w.created_at between '2012-08-05' and '2012-09-05'
##and wp.pageview_url in ('/products','/the-original-mr-fuzzy','/cart','/billing','/shipping','/thank-you-for-your-order')
and w.utm_source='gsearch'
and w.utm_campaign='nonbrand'
order by 1,3) as pageview_level
group by 1;

select * from D;

select 
round(count(distinct case when product_made_it=1 then website_session_id else null end)
/count(distinct website_session_id)*100,2) as lander1_clickthrough_rate,
round(count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end)
/count(distinct case when product_made_it=1 then website_session_id else null end)*100,2) as product_clickthrough_rate,
round(count(distinct case when cart_made_it=1 then website_session_id else null end)
/count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end)*100,2) as mrfuzzy_clickthrough_rate,
round(count(distinct case when shipping_made_it=1 then website_session_id else null end)
/count(distinct case when cart_made_it=1 then website_session_id else null end)*100,2) as cart_clickthrough_rate,
round(count(distinct case when billing_made_it=1 then website_session_id else null end)
/count(distinct case when shipping_made_it=1 then website_session_id else null end)*100,2) as shipping_clickthrough_rate,
round(count(distinct case when final_made_it=1 then website_session_id else null end)
/count(distinct case when billing_made_it=1 then website_session_id else null end)*100,2) as billing_clickthrough_rate
from D;

##Analyzing Conversion Funnel Tests

select 
min(website_pageview_id) as first_pv_id
from website_pageviews
where pageview_url='/billing-2';

select wp.website_session_id,
wp.website_pageview_id as billing_version_seen,
o.order_id
from website_pageviews wp
left join orders o on o.website_session_id=wp.website_session_id
where wp.created_at<'2012-11-10' and
wp.website_pageview_id>=53550 and
wp.pageview_url in ('/billing','/billing-2');


select billing_version_seen,
count(distinct website_session_id) as sessions,
count(distinct order_id) as orders,
round(count(distinct order_id)/count(distinct website_session_id)*100,2) as session_order_rt
from(
select wp.website_session_id,
wp.pageview_url as billing_version_seen,
o.order_id
from website_pageviews wp
left join orders o on o.website_session_id=wp.website_session_id
where wp.created_at<'2012-11-10' and
wp.website_pageview_id>=53550 and
wp.pageview_url in ('/billing','/billing-2') )as billing_sessions_w_orders
group by 1;