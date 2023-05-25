# Loyalty data
In this example we will use Python and some simple ML to predict whether a customer will register for a loyalty program. In order to do so, we will use the `customers` table we created in the previous exercise. Let's first add information which customer is registered already.

## Exercise

1. **Add data:** To proceed with this exercise we first need to know which customers have registered for the loyalty program. For the sake of simplicity, we got this list in form of csv file. You can find it inside `seeds` folder. 
   1. Run seed command to load the csv data into database `dbt seed --select loyalty_customers`
2. **Add staging model:** Create staging dbt model (since it's very simple, base is not needed) and configs:
   1. Create subfolder `loyalty` for this new data source in `dbt-demo/models/staging/`
   2. Add data source defintion into `_src_loyalty.yml`
   3. Add staging dbt model `stg_loyalty_customers.sql`
   4. Add model definition `_stg_loyalty.yml`
3. **Update table `customers`:** Update `marts/core/customers.sql` file to use this new source and show which customers are registered.

## Solution
**2.2**

:::{admonition} `_src_loyalty.yml`
:class: dropdown

```yaml
version: 2

sources:
 - name: loyalty
   schema: dbt_seeds
   tables:
     - name: loyalty_customers
       columns:
         - name: customer_id
           tests:
             - unique
```
:::

**2.3**

:::{admonition} `stg_loyalty_customers.sql`
:class: dropdown

```sql
with loyal_customers as (

  select * from {{ source('loyalty', 'loyalty_customers') }}

)

select * from loyal_customers
```
:::

**2.4**

:::{admonition} `_stg_loyalty.yml`
:class: dropdown

```yaml
version: 2

models:
  - name: stg_loyalty_customers
    description: List of registered customers
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null

```
:::

**3 Update dim customer**

:::{admonition} Update `customers.sql`
:class: dropdown

```sql
...
, loyalty_customers as (

 select * from {{ ref('stg_loyalty_customers') }}

),
...
  customer_amounts.total_amount,
   case
      when customers.customer_id = loyalty_customers.customer_id then true
      else false
    end as is_registered
 from customers
 left join customer_orders on customers.customer_id = customer_orders.customer_id
 left join customer_amounts on customers.customer_id = customer_amounts.customer_id
 left join loyalty_customers on customers.customer_id = loyalty_customers.customer_id
```
:::
