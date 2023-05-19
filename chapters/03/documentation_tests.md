# Documentation & tests - `_stg_[sourcename].yml`

To properly documentate and test our newly created models, we will create `_stg_[sourcename].yml` file for each data source we have (e.g. 1 file for jaffle_shop source data and 1 file for google_analytics data). These files are stored in **models/staging/[sourcename]** folder and provide a way to define the properties of dbt models (such as description and used tests) in a structured, human-readable format. 

For example, a typical YAML configuration file for a model might look something like this:

 ```yaml
version: 2

models:
  - name: my_model
    description: This is my model.
    columns:
      - name: column_1
        description: This is column 1.
        tests:
          - unique
          - not_null
      - name: column_2
        description: This is column 2.
        tests:
          - not_null
```

## Defining description

We can define description for each model and column. It can be either simple one line description or if you have a long description, you can use `docs block` and create additional markdown file in the same folder:

* `_stg_[sourcename].yml`
```yaml
version: 2

models:
  - name: orders
    description: This table has basic information about orders, as well as some derived facts based on payments

    columns:
      - name: status
        description: '{{ doc("orders_status") }}'
```

* `docs.md`
```
{% docs orders_status %}

Orders can be one of the following statuses:

| status         | description                                                               |
|----------------|---------------------------------------------------------------------------|
| placed         | The order has been placed but has not yet left the warehouse              |
| shipped        | The order has ben shipped to the customer and is currently in transit     |
| completed      | The order has been received by the customer                               |
| returned       | The order has been returned by the customer and received at the warehouse |


{% enddocs %}
```


## Defining tests

Additionally, in `_stg_[sourcename].yml` we can add tests that for example ensure a column contains no duplicates (**unique**) or zero null values (**not_null**). Once these tests are defined, you can validate their correctness by running `dbt test` in command line.

```yaml
version: 2

models:
  - name: orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
```
To check your test, run `dbt test` command in terminal

 ![title](../../images/gifs/dbt_test.gif)

## Summary 

📝 **example for `_stg_jaffle_shop.sql`**

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
    ...
  ```