alter table dbt_marts.dim_customers
add COLUMN loyalty_program int default 0;

update dbt_marts.dim_customers
set loyalty_program=1
where customer_id in (3, 13, 20, 35, 50, 51, 53, 54, 70, 71, 90);
