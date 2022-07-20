{% test not_greater_than(model, column_name, comparison_field) %}

with validation as (

    select
        {{ column_name }} as test_column,
        {{ comparison_field }} as not_greater_than_column --this field should not be greater than the test column
    from {{ model }}

),

validation_errors as (

    select
        test_column
    from validation 
    where test_column > not_greater_than_column

)

select *
from validation_errors

{% endtest %}