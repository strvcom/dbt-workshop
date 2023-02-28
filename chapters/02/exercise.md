# Exercise
    
1. **Setup:** perform steps in Environment and Project Setup

2. **Load data:** we have 4 raw tables, 3 of them are jaffle_shop data which are already loaded in our postgres db: *orders*, *customers* and *payments*. GA traffic data are located in *ga_traffic.csv* file seeds folder. To load these dataset run command `dbt seed` in dbt docker container.

3. **Configure sources:** create and edit `src_[sourcename].yml` for both data sources according [to the example](../02/data_sources.md).


## Solution


:::{admonition} `_src_jaffle_shop.yml`
:class: dropdown

```yaml
version: 2

sources:
  - name: raw
    tables:
      - name: orders
      - name: customers
      - name: payments
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
```
:::