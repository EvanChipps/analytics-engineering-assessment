--the model is on the grain of customer and day for each day from the day the individual customer 
--was created until the current day. As an example, if a customer was created 100 days ago, they would have
--100 records in this model

with

-- get all customer records from staging
customers as (
    select * from {{ ref('stg_customers') }}
),

-- get all orders records from staging
orders as (
    select * from {{ ref('stg_orders') }}
),

-- find the first day a customer record was created
first_date as (
    select date_trunc('month', min(created_at)) as month_first_customer_created
    from customers
),

-- generate a day-wise spine from the first day of the month the first customer
-- joined.  
days as (
    select generate_series(
        first_date.month_first_customer_created,
        current_date,
        '1 day'
        )::date as datestamp
    from first_date
), 

customer_activity_calculations as (
    select
        days.datestamp as period,
        c.customer_id ,
        COUNT(distinct CASE WHEN o.order_date + interval '7 days' > days.datestamp THEN o.order_id END) orders_past_7_days,
        COUNT(distinct CASE WHEN o.order_date + interval '30 days' > days.datestamp THEN o.order_id END) orders_past_30_days,
        COUNT(distinct CASE WHEN o.order_date + interval '60 days' > days.datestamp THEN o.order_id END) orders_past_60_days,
        COUNT(distinct CASE WHEN o.order_date + interval '90 days' > days.datestamp THEN o.order_id END) orders_past_90_days,
        COUNT(distinct o.order_id ) total_orders
    from days
    left outer join customers c  on days.datestamp >= c.created_at
    left outer join orders o     on o.customer_id = c.customer_id 
                                 and o.order_date < days.datestamp
    group by days.datestamp, c.customer_id
),


--for defining active/churned, I have seen this be as much of a business problem from a statistical standpoint
--From a statistical standpoint, we can see at what point a customer becomes unlikely to return - this is dependent
--on the business model and the historical amount of data available. For this exercise, I am going to
--arbitrarily say here that is a customer has "placed an order in the past 30 days" - they are active. The
--status of the order may play a role here as well

customer_activity_daily as (
    select
        period,
        customer_id,
        orders_past_7_days,
        orders_past_30_days,
        orders_past_60_days,
        orders_past_90_days,
        CASE WHEN orders_past_30_days > 0 THEN 1 ELSE 0 END as is_active,
        CASE WHEN orders_past_30_days = 0 AND orders_past_60_days > 0 THEN 1 ELSE 0 END as is_churned_recent,
        CASE WHEN orders_past_30_days = 0 AND total_orders > 0 THEN 1 ELSE 0 END as is_churned_historic
    from customer_activity_calculations 
)


select * from customer_activity_daily
