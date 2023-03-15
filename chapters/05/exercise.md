# Exercise

## Prerequisite
To proceed with this exercise we first need to have some new or updated records in our database. We have prepared the `update.sql` file with a batch of fresh data which we now import into our current DB. To do that follow the next steps:

1. open the terminal and navigate to the `dbt-workshop/db` folder

2. copy the `update.sql` file into the container using the following command:

    `docker cp update.sql dbt-workshop_database_1:/update.sql` (WIP)

2. connect to the Postgres container:

    `docker exec -it  dbt-workshop_database_1 psql -U postgres datawarehouse`  (WIP)

3. run the .sql file inside Postgres container:

    `\i update.sql`

Now we should have some fresh and updated records in our DB.

## Exercise

1. **create `dim_customers_snapshot`**: create `dim_customers_snapshot.sql` model in `snapshots` folder according to [the provided example](../05/historization.md#creating-snapshots). Check `all` columns for the change.
2. **create `fact_orders_snapshot`**: create `fact_orders_snapshot.sql` model. Check only `status` column for the change.
3. run `dbt run` to load new and updated records into our models
4. run `dbt snapshot` to create snapshots 

## Solution

:::{admonition} `dim_customers_snapshot.sql`
:class: dropdown

```
{% snapshot dim_customers_snapshot %}

    {{
        config(
          unique_key='customer_id',
          strategy='check',
          target_schema='snapshots',
          check_cols='all',
        )
    }}

    select * from {{ ref('dim_customers') }}

{% endsnapshot %}
```
:::


:::{admonition} `fact_orders_snapshot.sql`
:class: dropdown

```
{% snapshot fact_orders_snapshots %}

    {{
        config(
          unique_key='order_id',
          strategy='check',
          target_schema='snapshots',
          check_cols=['status'],
        )
    }}

  select * from {{ ref('fact_orders') }}

{% endsnapshot %}
```
:::