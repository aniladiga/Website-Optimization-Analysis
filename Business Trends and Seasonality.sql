##Analyzing Business Patterns and Seasonality

select website_session_id,created_at,
hour(created_at) as hr,
weekday(created_at) as wkday,
case when weekday(created_at)=0 then 'Monday'
when weekday(created_at)=1 then 'Tuesday'
else 'Other Day'
end as clean_weekday,
quarter(created_at) as qtr,
month(created_at) as mo,
date(created_at) as dt,
week(created_at) as wk
from website_sessions
where website_session_id between 150000 and 155000;

##Analyzing Seasonality

select year(w.created_at) as yr,
month(w.created_at) as mo,
week(w.created_at) as wk,
min(date(w.created_at)) as week_start,
count(distinct w.website_session_id) as sessions,
count(distinct o.order_id) as orders
from website_sessions w
left join orders o on w.website_session_id=o.website_session_id
where w.created_at< '2013-01-01'
group by 1,2,3;

##Analyzing business patterns

select hr,
round(avg(case when wkday=0 then sessions else null end),1) as Mon,
round(avg(case when wkday=1 then sessions else null end),1) as Tue,
round(avg(case when wkday=2 then sessions else null end),1) as Wed,
round(avg(case when wkday=3 then sessions else null end),1) as Thu,
round(avg(case when wkday=4 then sessions else null end),1) as Fri,
round(avg(case when wkday=5 then sessions else null end),1) as Sat,
round(avg(case when wkday=6 then sessions else null end),1) as Sun
from(
select date(created_at) as created_date,
weekday(created_at) as wkday,
hour(created_at) as hr,
count(distinct website_session_id) as sessions
from website_sessions
where created_at between '2012-09-15' and '2012-11-15'
group by 1,2,3) as daily_hourly_sessions
group by 1;