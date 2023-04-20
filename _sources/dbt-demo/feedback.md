Notes:

# Env setup
3. be in correct folder: `docker exec -w /project/dbt_demo/ -it dbt-demo-dbt-1 /bin/bash`
4. run dbt --version where you should see 1.2.0

# Project structure
models/staging - add note from core
models/marts/core - core data model with dimensions and facts
models/marts/intermediate - combine two data sources form staging
run `dbt debug` you should see All checks passed!
run `dbt list` you should see
```
There are 3 unused configuration paths:
- models.dbt_workshop.staging
- models.dbt_workshop.marts
- models.dbt_workshop.marts.core
```

# Data sources
name = jaffle_shop
dbt seeds under dbt schema not dbt_seeds
add _src_ga `schema: dbt`

# Staging models
I would enrich by number of orders so it's clear that staging should be creating join on top of base models

# Documentation & tests
we have created on _src, not stg_ instead of _stg_

## defining description - move after test
add subfolder where to put it
run docs command?

### exercise
split ga and jaffle
add stg ga

# snapshots
docker cmd to copy `docker cp update.sql dbt-demo-database-1:/update.sql` instead of `docker cp update.sql dbt-workshop-database-1:/update.sql`


### falai

labels into seeds
change base, stg, dim
create _ml.yml and _src_ml.yml
run fal ai
change dim_customers to contain flag
