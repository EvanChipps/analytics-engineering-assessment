select
    count(*)
from {{ ref('customer_daily_snapshot' )}}
where total_customers - total_churned_customers - active_customers != 0 

--this test is failing, we should ask ourselves here:
-- "Is the assertion that (total customers = churned + active) should be true? Do we need to redefine our fields or our test?"