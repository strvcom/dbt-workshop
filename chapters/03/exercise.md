# Exercise

1. **Create base models:** create base models for each source table (total 4 base models). Make sure all `id` columns are renamed according to the entity they represent e.g. for customer table set `id as customer_id`. *(tip: sample SQL for `base_jaffle_shop_customers` is already included as [the example](../03/base_models.md) in the lecture)*
2. **Create staging models:** 
    * firstly create staging models for each base table (total 4 staging models). In `stg_jaffle_shop_payments` filter only payments where amount is bigger than 0. *(tip: sample SQL for `stg_jaffle_shop_customers` is already included as [the example](../03/staging_models.md) in the lecture)*
    * then create one additional `stg_jaffle_shop_orders_value` model which will be selecting from already created `stg_jaffle_shop_payments` model in the previous step. This model should contain columns: `order_id`, `total_amount` and `coupon_amount` (tip: use case when payment_method ...)

3. **Fill `_stg_[sourcename].yml` files:** finish [the provided example](../03/documentation_tests.md#summary)   for `_stg_jaffle_shop.yml` file and fill `_stg_google_analytics.yml`. 
Once it is all set, don't forget to run your models by `dbt run` command and test your models by `dbt test` in your terminal

 ![title](../../images/gifs/dbt_run_staging.gif)

 ![title](../../images/gifs/dbt_test.gif)

## Solution

**1. Base models**

:::{admonition} `base_jaffle_shop_customers.sql`
:class: dropdown

```
with source as (

  select * from {{ source('raw', 'customers') }}

), renamed as (

  select
    id as customer_id,
    first_name,
    last_name
  from source

)

select * from renamed
```
:::


:::{admonition} `base_jaffle_shop_orders.sql`
:class: dropdown

```
with source as (

  select * from {{ source('raw', 'orders') }}

), renamed as (

  select
    id as order_id,
    customer_id,
    order_date,
    status
  from source

)

select * from renamed
```
:::


:::{admonition} `base_jaffle_shop_payments.sql`
:class: dropdown

```
with source as (

  select * from {{ source('raw', 'payments') }}

), renamed as (

  select
    id as payment_id,
    order_id,
    payment_method,
    amount / 100 as amount
  from source

)

select * from renamed
```
:::


:::{admonition} `base_google_analytics_traffic.sql`
:class: dropdown

```
with source as (

  select * from {{ source('dbt_seeds', 'ga_traffic') }}

), renamed as (

  select
    date,
    sessions,
    users as visitors,
    pageviews as page_views
  from source

)

select * from renamed

```
:::


**2. Staging models**

:::{admonition} `stg_jaffle_shop_customers.sql`
:class: dropdown

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
:::


:::{admonition} `stg_jaffle_shop_orders.sql`
:class: dropdown

```
with orders as (

  select * from {{ ref('base_jaffle_shop_orders') }}

)

select * from orders
```
:::


:::{admonition} `stg_jaffle_shop_orders_value.sql`
:class: dropdown

```
with payments as (

  select * from {{ ref('stg_jaffle_shop_payments') }}

), aggregated as (

  select
    order_id,
    sum(amount) as total_amount,
    sum(case payment_method when 'coupon' then amount else 0 end) as coupon_amount
  from payments
  group by 1

)

select * from aggregated
```
:::


:::{admonition} `stg_jaffle_shop_payments.sql`
:class: dropdown

```
with payments as (

  select * from {{ ref('base_jaffle_shop_payments') }}

), filtered as (

  select * from payments
  where amount > 0

)

select * from filtered
```
:::

:::{admonition} `stg_google_analytics_traffic.sql`
:class: dropdown

```
with traffic as (

  select * from {{ ref('base_google_analytics_traffic') }}

)

select * from traffic

```
:::

**3. Docs & Tests**

:::{admonition} `_stg_jaffle_shop.yml`
:class: dropdown

```yaml
version: 2

models:
  - name: base_jaffle_shop_customers
    description: Basic information about customers.
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
  - name: base_jaffle_shop_orders
    description: Basic information about orders.
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
  - name: base_jaffle_shop_payments
    description: Basic information about payments.
    columns:
      - name: payment_id
        tests:
          - unique
          - not_null
  - name: stg_jaffle_shop_customers
    description: Contains information about customers.
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
  - name: stg_jaffle_shop_orders
    description: Contains information about orders.
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
  - name: stg_jaffle_shop_orders_value
    description: Contains information about paid amounts per order.
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
  - name: stg_jaffle_shop_payments
    description: Contains information about payments.
    columns:
      - name: payment_id
        tests:
          - unique
          - not_null

```
:::


:::{admonition} `_stg_google_analytics.yml`
:class: dropdown

```yaml
version: 2

models:
  - name: base_google_analytics_traffic
    description: Date field
    columns:
      - name: date
        tests:
          - unique
          - not_null
```
:::