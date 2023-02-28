# Data sources - `_src_[sourcename].yml`

Inside **each** source subfolder (*jaffle_shop* and *google_analytics*), create `_src_[sourcename].yml` yaml file. Edit `_src_[sourcename].yml` and add table reference to the raw data. Sources make it possible to name and describe the data loaded into your warehouse.
    
```yaml
version: 2

sources:
 - name: test
   database: raw ## db name
   schema: raw_test # schema where it sits
   description: [Describe source table]
   tables:
     - name: table_test # name by which we reference it, can be the same as in db or different
       identifier: profiles # name in the db
       
 ```

:::{admonition} Data loading options
 Data can be loaded into DB by either using some EL tool like Meltano, Fivetran etc. or by uploading `.csv` files. By running dbt command `dbt seed` you can easily load your .csv files into your database. Place all .csv files in seeds folder within you dbt folder. Destination schema can be modified in `dbt_project.yml` by adding:
```yaml
seeds:
  +schema: seeds
```

:::

📝 **example for `_src_jaffle_shop.yml`**

 ```yaml
 version: 2
 
 sources:
  - name: raw
    tables:
      - name: orders
      - name: customers
      - name: payments
```