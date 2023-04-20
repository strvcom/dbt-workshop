# Data schema - `_ml.yml`

For fal AI we are going to define a model and a data source. The model will be trigered first to read the `dim_customer` table. The python script will then be executed and the result will be stored to the `customer_registration_prediction` table. 

An examle of the model and the data source to add to the `_ml.yml` file:

```yaml
version: 2

sources:
  - name: ml
    schema: dbt_ml
    tables:
      - name: customer_registration_prediction
models:
  - name: customer_registration_prediction
    meta:
      fal:
        scripts:
          after:
            - customer_registration_prediction.py
```

# Settings `dbt_project.yml`

Append following lines so fal will know wheret to look for models and python scripts.

```yaml
vars:
  fal-models-paths: "models/ml"
  fal-scripts-path: "scripts"
```
# Python script

Script is referencing table that will be used in prediction `dim_customers` but does not refer output model since this is define inside the meta tag above.

```python
import pandas as pd
from sklearn.linear_model import LogisticRegression

ref_df = ref('dim_customers')

# fill missing values with 0
ref_df.fillna(0, inplace=True)

# Extract the input and output variables
X = ref_df[["no_of_orders", "total_amount"]]
y = ref_df["is_registered"]

# Create a logstic regression model
model = LogisticRegression()

# Fit the model to the data
model.fit(X, y)

# Print the intercept and coefficient
print('Intercept:', model.intercept_)
print('Coefficient:', model.coef_)

ref_df['is_predicted_to_register'] = model.predict(X)

# Upload a `pandas.DataFrame` back to the datawarehouse
write_to_model(ref_df[['customer_id','is_predicted_to_register']])
```
