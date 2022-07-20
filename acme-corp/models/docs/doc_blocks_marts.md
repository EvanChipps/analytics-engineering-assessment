{% docs customer_activity_daily %}

This model was created to provide a distinct record for each customer on each day after they were created. This model would should certain attributes and measures of that customer. 

{% enddocs %}

{% docs customer_daily_snapshot %}

This model was created to summarize the customer activity into a daily snapshot. This model can be used to show time series data of metrics such as Total Customers<sup>1</sup>, Active Customers<sup>2</sup>, and Churn %<sup>3</sup>. 

 1 - Total Customer are the amount of Customers that have been created at that point
 2 - Active Customers are the amount of Customers that have placed an order in the prior 30 day period
 3 - Churn % is the amount of Active Customers in the prior 30 day window have not placed an order in the trailing 30 day window

{% enddocs %}