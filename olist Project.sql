# KPI 1: Weekdays vs Weekend Payment Statistics

SELECT * FROM olist_orders_dataset;
SELECT * FROM olist_order_payments_dataset;

with Day_orders as (
select Daynames, count(orders) total_orders from (
select dayname(order_purchase_timestamp) as Daynames,order_id as Orders from olist_orders_dataset
) t1
group by daynames),
weekly_orders as (
select case when daynames = 'sunday' or 'saturday' 
then 'Weekends' else 'Weekdays'end as Week_status, total_orders 
from Day_orders)
select Week_status, sum(total_orders) as Total_Orders from weekly_orders
group by Week_status;


# KPI 2: Average payment_value : Weekday Vs Weekend

with Payment_value_day as (
select DayName, avg(payment_value) as Avg_Payment_value from (
select dayname(o.order_purchase_timestamp) as DayName, p.payment_value from 
olist_orders_dataset o inner join olist_order_payments_dataset p 
on o.order_id = p.order_id
) o1
group by DayName
),
weekly_payment_value as (
select case when DayName = 'Sunday' or 'saturday' then 'WeekEnds' else 'WeekDays' end as Week_status,
Avg_Payment_value from Payment_value_day
)
select week_status, round(avg(Avg_Payment_value),2) as Avg_Payment_value 
from weekly_payment_value 
Group by week_status;


#KPI 3: Total Number of Orders with review score 5 and payment type as credit card.
select * from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;

select count(op.order_id)  as Orders, payment_type, review_score 
from olist_order_payments_dataset op inner join olist_order_reviews_dataset ro 
on op.order_id = ro.order_id
where payment_type = 'credit_card' and review_score = 5;


#KPI 4: Average number of days taken for order_delivered_customer_date for pet_shop
select * from olist_products_dataset;
select * from olist_orders_dataset;
select * from olist_order_items_dataset;
select * from product_category_name_translation;

with Delivery_days as (
select pt.product_category_name_english, Abs(datediff(str_to_date(order_delivered_customer_date,'%m/%d/%Y'),str_to_date(order_estimated_delivery_date,'%m/%d/%Y'))) 
as Days_diff
from product_category_name_translation pt inner join olist_products_dataset op
on pt.ï»¿product_category_name = op.product_category_name inner join olist_order_items_dataset oi 
on op.product_id = oi.product_id inner join olist_orders_dataset od 
on oi.order_id = od.order_id 
where pt.product_category_name_english  = 'pet_shop'
)
select product_category_name_english, round(avg(Days_diff),2) as Avg_Days from Delivery_days;


#KPI 5: Average price and payment values from customers of sao paulo city
select * from olist_sellers_dataset;
select * from olist_order_items_dataset;
select * from olist_order_payments_dataset;

select sl.seller_city, round(avg(oi.price),2) as Avg_price, round(avg(op.payment_value),2) as Avg_payment_value from 
olist_sellers_dataset sl inner join olist_order_items_dataset oi
on sl.seller_id = oi.seller_id inner join olist_order_payments_dataset op 
on oi.order_id = op.order_id
where seller_city = 'sao paulo'
group by seller_city;


#KPI 6: Relationship between shipping days Vs review scores.
select * from olist_orders_dataset;
select * from olist_order_reviews_dataset;

select rew.review_score,
round (avg(datediff(ord.order_delivered_customer_date ,order_purchase_timestamp)),0) as "Avg shipping days"
From olist_orders_dataset ord
Join olist_order_reviews_dataset rew on rew.order_id = ord.order_id
group by rew.review_score order by rew.review_score;

