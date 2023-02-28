# Base models - `base_[sourcename]_[tablename].sql`

Base models are stored in **staging/[sourcename]/base** folder. No transformation are performed in this stage, only renaming or recasting of columns. 

:::{admonition} Use `{{ source() }}` function
    
💡 Select from source tables in your models using the `{{ source() }}` function, which is helping define the lineage of your data. 

 ```
 select * from {{ source(source_name, table_name) }}
 ```

Values for each data source are defined in `_src_[sourcename].yml` which was done [in the previous step](../02/data_sources.md).

* `source_name`: The `name:` defined under a `sources:` key
* `table_name`: The `name:` defined under a `tables:` key
:::

📝 **example for `base_jaffle_shop__customers.sql`**

 ```
with

source as (

    select * from {{ source('raw','customers') }}

),

customers as (

    select
        id as customer_id,
        first_name,
        last_name
    from source

)

select * from customers
 ```