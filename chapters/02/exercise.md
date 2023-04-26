# Exercise
    
1. **Load data:** we have 4 raw tables, 3 of them are jaffle_shop data which are already loaded in our postgres db: *orders*, *customers* and *payments*. GA traffic data are located in *ga_traffic.csv* file seeds folder. To load these dataset run command `dbt seed` in dbt docker container.
2. **Configure sources:** create and edit `src_[sourcename].yml` for both data sources according [to the example](../02/data_sources.md).
3. **Test new source:** Define and run tests for ga_traffic data.


## Solution


:::{admonition} `_src_jaffle_shop.yml`
:class: dropdown

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
:::


:::{admonition} `_src_google_analytics.yml`
:class: dropdown

```yaml
version: 2

sources:
  - name: dbt_seeds
    tables:
      - name: ga_traffic
        columns:
          - name: date
            tests:
              - unique
```
:::
