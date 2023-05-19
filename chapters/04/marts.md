# Building marts - `[tablename].sql`

This is the layer where everything comes together and we start to arrange all of our staging models into marts that have identity and purpose.

## Creating `core` folder

According to the best practice, it is recommended to create a subfolder for each area of concern within **marts** folder. In our example, we will be creating `core` folder within `marts` folder.

**Setup:**
1. go to `models/marts` folder and create `core` folder
2. create `_core.yml` where we store documentation and tests for the tables
3. create a `[tablename].sql` file with SQL transformations following this recommended structure:
    * create `a CTE table for each staging model` from which you are selecting 
         ```
            with traffic as (

                select * from {{ ref('stg_google_analytics_traffic') }}

            )
        ```
    * create `helping CTEs for additional calculations`
        ```
            orders_daily as (

                select
                    orders.order_date as order_date,
                    count(*) as orders_amount
                from orders
                group by 1

            )
        ```
    * create `the final CTE` which will bring together all helping CTEs
        ```
            final as (

            select 
                traffic.date,
                traffic.sessions,
                traffic.visitors,
                traffic.page_views,
                orders_daily.orders_amount,
                round((orders_daily.orders_amount::decimal / traffic.visitors * 100 ), 2) as coversion_rate
            from traffic
            left join orders_daily on traffic.date = orders_daily.order_date

            )
        ```

    * `select * from final`

📝 **example for `traffic.sql`**

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
    round((orders_daily.orders_amount::decimal / traffic.visitors * 100 ), 2) as coversion_rate
  from traffic
  left join orders_daily on traffic.date = orders_daily.order_date

)

select * from final
 ```




Once it is all set, don't forget to run `dbt run` command in terminal to create all tables in database.

:::{admonition} `dbt run --select [model_folder/model_name]`
:class: tip
You can add argument `--select` to `dbt run` command and specify model name or model folder to execute only subset of models.
 ![title](../../images/gifs/dbt_marts.gif)
:::


:::{admonition} Data marts covering multiple areas
:class: tip
The `marts` folder typically contains multiple subfolders, each of which corresponds to a specific business function or analytical domain. For example, you might have a *finance* subfolder that contains tables related to finance data, a *marketing* subfolder that contains tables related to marketing data, and so on. 
```
models/marts
├── finance
│   ├── _finance__models.yml
│   ├── orders.sql
│   └── payments.sql
└── marketing
    ├── _marketing__models.yml
    └── customers.sql
```
:::
## [Optional] Creating `intermediate` folder

Within our `core` folder (or optionally within each folder covering different area), we can create intermediate models `[entity]s_[verb]s.sql`. Intermediate models are used to break down complex data transformations into smaller, more manageable steps. These intermediate models act as building blocks, enabling you to create a modular (meaning that they can be reused in multiple data pipelines), and scalable data transformation process that is easier to understand, test, and maintain.  