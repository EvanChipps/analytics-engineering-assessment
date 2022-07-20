--this model provides a daily snapshot of various measures on the customer level, 
--and should contain one record per day 

with

-- get all customer records from staging
customer_activity_daily as (
    select * from {{ ref('customer_activity_daily') }}
),

customer_daily_aggregation as (

    SELECT  
        period,
        count(distinct customer_id) as total_customers,
        sum(is_active) as active_customers,
        sum(is_churned_recent) as recently_churned_customers,
        sum(is_churned_historic) as total_churned_customers
    FROM customer_activity_daily
    GROUP BY 1
),

--for this churn rate calculation, this would be viewing the customers who did not have an order in the previous 30-60
customer_daily_snapshot as (

    SELECT  
        a.*,
        round((a.recently_churned_customers  / b.active_customers) * 100 ,4)|| '%' as churn_rate
    FROM customer_daily_aggregation a 
    LEFT JOIN customer_daily_aggregation b 
        ON a.period = b.period + interval '30 days'
)

SELECT * FROM customer_daily_snapshot