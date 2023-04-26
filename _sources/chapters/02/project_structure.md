# *BONUS* Project structure

Recommended project structure:

```
├── dbt_project.yml
└── models
    ├── marts
    |   └── core
    |       ├── intermediate
    |       |   ├── intermediate.yml
    |       |   ├── customers__unioned.sql
    |       |   ├── customers__grouped.sql
    |       └── core.yml
    |       └── core.docs
    |       └── dim_customers.sql
    |       └── fct_orders.sql
    └── staging
        └── stripe
            ├── base
            |   ├── base__stripe_invoices.sql
            ├── src_stripe.yml
            ├── src_stripe.docs
            ├── stg_stripe.yml
            ├── stg_stripe__customers.sql
            └── stg_stripe__invoices.sql
```



* `dbt_project.yml` - every dbt project needs a `dbt_project.yml` file — this is how dbt knows a directory is a dbt project. It also contains important information that tells dbt how to operate on your project.


* `models` - folder for all dbt models, containing two subfolders: `staging` and `marts`

    * `staging` - add subfolder for each source, e.g. *backend*, *google_analytics*, *salesforce*, etc.
        * `base` - source-centric, renaming and recasting is done here
    * `marts` - can contain subfolders for specific domains (sales, marketing etc.)
        * `core` - contains the SQL code that defines how raw data is transformed into a structured data model optimized for reporting and analysis (fact / dim tables)
            * `intermediate` - contains SQL code that defines tables or views used to transform, clean, or filter data before it is loaded into the final data mart. Typically when these transformation are used in multiple models.
            
