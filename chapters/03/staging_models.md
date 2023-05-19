# Staging models - `stg_[sourcename]_[tablename].sql`

Staging models are built on top of base models. In this layer we can **enrich**, **aggregate** and **filter** base model or **join** multiple base models within one source together. These files are stored in **models/staging/[sourcename]** folder.

📝 **example for `stg_jaffle_shop_customers.sql`**

```
with customers as (

  select * from {{ ref('base_jaffle_shop_customers') }}

), enriched as (

  select 
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name
  from customers

)

select * from enriched
```

 To create staging models in database, run `dbt run` command in terminal