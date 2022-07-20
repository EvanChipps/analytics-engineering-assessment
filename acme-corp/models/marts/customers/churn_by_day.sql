--for this model we are going to pick certain fields from our daily snapshot table to show the churned customers and rate by day

with

customer_daily_snapshot as (
    select * from {{ ref('customer_daily_snapshot') }}
),

churn_by_day as (

    SELECT  
        period,
        recently_churned_customers,
        total_churned_customers,
        churn_rate
    FROM customer_daily_snapshot
)

SELECT * FROM churn_by_day