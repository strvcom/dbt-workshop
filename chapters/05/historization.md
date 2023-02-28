# Creating historized table - `[model_name]_snapshot.sql`

In our example we will use dbt snapshot functionality to create Slowly Changing Dimensions (SCD).

:::{admonition} type-2 Slowly Changing Dimensions
A Slowly Changing Dimension is a dimension table that includes historical data, allowing you to track changes to dimension data over time. Type 2 SCDs **add a new row to the dimension table whenever a change occurs**. This new row contains the updated data while **the old row is marked as inactive**. This allows you to keep a historical record of changes to the dimension data over time. 
:::

## How dbt snapshot works

We have an orders table where the status field can be overwritten as the order is processed. 

| order_id | status | order_date |
|----------|--------|------------|
| 1        | placed | 2018-01-01 |

Now, the order goes from "placed" to "shipped". That same record will now look like:

| order_id | status | order_date |
|----------|--------|------------|
| 1        | shipped | 2018-01-01 |

To prevent losing the primary information about *placed* state, we use dbt snapshots which will add a new row containing the most recent state together with two new columns **dbt_valid_from** and **dbt_valid_to**:

| order_id | status  | order_date | dbt_valid_from | dbt_valid_to |
|----------|---------|------------|----------------|--------------|
| 1        | placed  | 2018-01-01 | 2018-01-01     | 2018-01-04   |
| 1        | shipped | 2018-01-01 | 2018-01-04     | _null_       |


## Creating snapshots 

1. Create a `[model_name]_snapshot.sql` file inside `snapshots` folder.
2. Use a snapshot block, set config properties and insert the query, e.g.

```
{% snapshot orders_snapshot %}

{% endsnapshot %}
```

3. insert select statement which defined what you want to snapshot. Don't forget to use `source` or `ref` function here.

```
{% snapshot orders_snapshot %}

select * from {{ source('jaffle_shop', 'orders') }}

{% endsnapshot %}
```

4. add snapshot configuration using config block

```
{% snapshot orders_snapshot %}

    {{
        config(
          target_schema='snapshots',
          unique_key='order_id',
          strategy='check',
          check_cols=['status'],
        )
    }}

    select * from {{ source('jaffle_shop', 'orders') }}

{% endsnapshot %}
```

**Config block:**

* `target_schema`: where to store snapshot tables
* `unique_key (required)`: primary key column
* `strategy`: either *check* or *timestamp*
* `check_cols`: array of columns to check for changes or *'all'* to check all columns
* `updated_at`: If using the *timestamp* strategy, the timestamp column to compare
