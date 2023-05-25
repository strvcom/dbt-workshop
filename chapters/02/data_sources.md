# Data sources - `_src_[sourcename].yml`

Inside **each** source subfolder (*jaffle_shop* and *google_analytics*) located in models/staging folder, we need to create `_src_[sourcename].yml` yaml file containing table reference to the raw data. Sources make it possible to name and describe the data loaded into your warehouse. We will setup up these files in the following **Exercise** on the next page.

📝 **example of `_src_[sourcename].yml`**

```yaml
version: 2

sources:
 - name: test
   schema: raw # schema where it sits
   description: [Optional] # describe source table
   tables:
     - name: table_name
 ```

### Defining tests
Additionally, in `_src_[sourcename].yml` we can add tests that for example ensure a column contains no duplicates (`unique`) or zero null values (`not_null`). Once these tests are defined, you can validate their correctness by running `dbt test` in command line.

```yaml
version: 2

sources:
 - name: test
   schema: raw # schema where it sits
   description: [Optional] # describe source table
   tables:
     - name: table_name
       columns:
          - name: id
            tests:
              - unique
              - not_null
 ```

📝 **example for `_src_jaffle_shop.yml`**

 ```yaml
 version: 2
 
 sources:
  - name: jaffle_shop
    schema: raw
    tables:
      - name: orders
        columns:
          - name: id
            tests:
              - unique
      - name: customers
        columns: id
          - name: 
            tests:
              - unique
      - name: payments
        columns:
          - name: id
            tests:
              - unique
```

:::{admonition} Data loading options
 Data can be loaded into DB by either using some EL tool like Meltano, Fivetran etc. or by uploading `.csv` files. By running dbt command `dbt seed` you can easily load your .csv files into your database. Place all .csv files in seeds folder within you dbt folder. Destination schema can be modified in `dbt_project.yml` by adding:
```yaml
seeds:
  +schema: seeds
```

:::

