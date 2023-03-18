# Data schema - `schema.yml`

For fal AI we are going to define a model and a data source. The model will be trigered first to read the `dim_customer` table. The python script will then be executed and the result will be stored to the `customer_registration_prediction` table. 

An examle of the model to add to the `schema.yml` file:
```yaml


```yaml
models:
  - name: customer_registration_prediction
    meta:
      fal:
        scripts:
          - models/ml/__main__.py
```

An example of the data source to add to the `schema.yml` file:
```yaml
version: 2

sources:
  - name: dbt
    tables:
      - name: customer_registration_prediction
```