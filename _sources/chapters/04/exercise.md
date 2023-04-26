# Exercise

In this exercise we will create simple dimensional model consisting of one dimension table (`dim_customers`) and two fact tables (`fact_orders` and `fact_traffic`) - which you can already find as [the example](../04/marts.html#creating-core-folder).

1. **create `dim_customer`**: create dimension table for customers consisting of 3 staging models: `stg_jaffle_shop_customers`, `stg_jaffle_shop_orders` and `stg_jaffle_shop_orders_value`. Create SQL query which will calculate date of `first_order` and `last_order` for the customer and their number of orders (`no_of_orders`) and total amount paid (`total_amount`) for all orders. Follow [the recommended structure](../04/marts.html#creating-core-folder) while building SQL.

2. **create `fact_orders`**: create fact table for orders consisting of 2 staging models: `stg_jaffle_shop_orders` and `stg_jaffle_shop_orders_value`. Include `order_id`, `order_date`, `customer_id`, `status`, `total_amount` and `coupon_amount` columns. All these information were already calculated in staging layer, so there is no need for further calculations.

3. **create `fact_traffic`**: copy-paste SQL from [the provided example](../04/marts.html#creating-core-folder) into `fact_traffic.sql`

4. run `dbt run` command to create tables

 ![title](../../images/gifs/dbt_run.gif)

 ## Solution


 :::{admonition} `dim_customers.sql`
:class: dropdown

```
with customers as (

  select * from {{ ref('stg_jaffle_shop_customers') }}

), orders as (

  select * from {{ ref('stg_jaffle_shop_orders') }}

), payments as (

  select * from {{ ref('stg_jaffle_shop_orders_value') }}

), customer_orders as (

  select
    customer_id,
    min(order_date) as first_order,
    max(order_date) as last_order,
    count(*) as no_of_orders
  from orders
  group by 1

), customer_amounts as (

  select
    orders.customer_id,
    sum(payments.total_amount) as total_amount
  from orders
  left join payments on orders.order_id = payments.order_id
  group by 1

), final as (

  select 
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customers.full_name,
    customer_orders.first_order,
    customer_orders.last_order,
    customer_orders.no_of_orders,
    customer_amounts.total_amount
  from customers
  left join customer_orders on customers.customer_id = customer_orders.customer_id
  left join customer_amounts on customers.customer_id = customer_amounts.customer_id

)

select * from final

```
:::


:::{admonition} `fact_orders.sql`
:class: dropdown

```
with orders as (

  select * from {{ ref('stg_jaffle_shop_orders') }}

), payments as (

  select * from {{ ref('stg_jaffle_shop_orders_value') }}

), final as (

  select 
    orders.order_id,
    orders.order_date,
    orders.customer_id,
    orders.status,
    payments.total_amount,
    payments.coupon_amount
  from orders
  left join payments on orders.order_id = payments.order_id

)

select * from final

```
:::


:::{admonition} `fact_traffic.sql`
:class: dropdown

```
with traffic as (

  select * from {{ ref('stg_google_analytics_traffic') }}

), orders as (

  select * from {{ ref('stg_jaffle_shop_orders') }}

), orders_daily as (

  select
    orders.order_date as order_date,
    count(*) as orders_amount
  from orders
  group by 1

), final as (

select 
    traffic.date,
    traffic.sessions,
    traffic.visitors,
    traffic.page_views,
    orders_daily.orders_amount,
    round((orders_daily.orders_amount::decimal / traffic.visitors * 100 ), 2) as conversion_rate
  from traffic
  left join orders_daily on traffic.date = orders_daily.order_date

)

select * from final
```
:::
