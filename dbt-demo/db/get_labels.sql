alter table dbt_seeds_marts.dim_customers
add COLUMN registration int default 0;

update dbt_seeds_marts.dim_customers
set registration=1
where customer_id in (3, 13, 20, 35, 50, 51, 53, 54, 70, 71, 90);
