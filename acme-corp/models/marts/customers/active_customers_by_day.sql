--for this model we are going to pick certain fields from our daily snapshot table to show the active customers by day

with

customer_daily_snapshot as (
    select * from {{ ref('customer_daily_snapshot') }}
),

active_customers_by_day as (

    SELECT  
        period,
        active_customers
    FROM customer_daily_snapshot
)

SELECT * FROM active_customers_by_day