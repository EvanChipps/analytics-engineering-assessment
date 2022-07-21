with next_days_value as (

select
    period,
    total_customers,
    LEAD(total_customers) OVER (ORDER BY period ) as next_days_total_customers
from {{ ref('customer_daily_snapshot' )}}
)
SELECT 
    total_customers
FROM next_days_value
WHERE period not in (SELECT max(period) FROM next_days_value)
    AND total_customers > next_days_total_customers
