# Exercise
In this example we will use Python and some simple ML to predict whether a customer will register for a loyalty program. In order to do so, we will use the `dim_customers` table we created in the previous exercise. To incorporate Python in our workflow, we will use Fal. For more information on Fal, please refer to the [Fal documentation](https://fal-ai.github.io/fal/).

## Exercise

1. **Add data source:** To proceed with this exercise we first need to know which customers have registered for the loyalty program. For the sake of simplicity, we got this list in form of csv file. You can find it inside `seeds` folder. 
   1. Create subfolder `loyalty` for this new data source in `dbt-demo/models/staging/`
   2. Run seed command to load the csv data into database `dbt seed --select loyalty_customers`
2. **Add staging model:** Create staging dbt model (since it's very simple, base is not needed) and configs:
      1. _src_loyalty.yml
      2. stg_loyalty_customer.sql
      3. _stg_loyalty.yml
3. **Update dim_customers:** Update `marts/core/dim_customers.sql` file to use this new source and show which customers are registered.
4. **Setup fal python models:** 
   1. Create a new folder called `ml` in the `models/marts` folder. This is where we will store our ML models.
   2. Inside the `ml` folder, create a new file called `_ml.yml` with model and source defintion according to [the provided example](../06/python.md).
   3. Also add the dbt model itself `customer_registration_prediction.sql` with query `select 1` inside.
5. **Setup fal python scripts:** 
   1. Add prediction script called `customer_registration_prediction.py` into `scripts` subfolders in the dbt project folder with script according to [the provided example](../06/python.md).
   2. Append fal var setting into `dbt_project.yml` so fal-ai knows where to find them according to [the provided example](../06/python.md).
6. **Setup fal python models:** Ready to run it 
   1. First run the selected new dbt models `dbt run --select --select marts.ml.*`
   2. Take a look at the created table `dbt_ml.customer_registration_prediction`
   3. Then run the python script itself `fal run`
   4. Now you can take a look at the table again.
7. [BONUS] Add staging ml folder and incorporate all the way up into dim so you manager can see it in his dashboard!

## Solution
**1. Setup**

:::{admonition} `_ml.yml`
:class: dropdown

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

**2. Create a model**

:::{admonition} `customer_registration_prediction.sql`
:class: dropdown

```sql
select 1
```

**3. Create a python script**

Append fal ai setting into `dbt_project.yml`

```yaml
vars:
  fal-models-paths: "models/ml"
  fal-scripts-path: "scripts"
```

**4. Create a python script**
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

