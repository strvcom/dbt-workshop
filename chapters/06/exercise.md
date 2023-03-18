# Exercise
In this example we will use Python and some simple ML to predict whether a customer will register for a loyalty program. In order to do so, we will use the `dim_customers` table we created in the previous exercise. To incorporate Python in our workflow, we will use Fal. For more information on Fal, please refer to the [Fal documentation](https://fal-ai.github.io/fal/).

## Prerequisite
To proceed with this exercise we first need to know which customers have registered for the loyalty program. We have prepared the `get_labels.sql` file with a script that will add the column `loyalty_program` to the `dim_customers` table. To do that follow the next steps:

1. open the terminal and navigate to the `dbt-demo/db` folder

2. copy the `get_labels.sql` file into the container using the following command:

    `docker cp get_labels.sql dbt-demo_database_1:/get_labels.sql`

2. connect to the Postgres container:

    `docker exec -it  dbt-demo_database_1 psql -U postgres datawarehouse`

3. run the .sql file inside Postgres container:

    `\i get_labels.sql`

Now we have our labels, we are ready for some ML! 

## Exercise

1. **setup:** Create a new folder called `ml` in the `models` folder. This is where we will store our ML models. Inside the `ml` folder, create a new file called `schema.yml` according to [the provided example](../06/schema.md).
2. **create a model:** create a model called `customer_registration_prediction` in the `ml` folder. Inside this model, select data from the `dim_customers` table.
3. **create a python script:** create a script called `__main__.py` in the `ml` folder. Inside this script, use the data from the model to train a simple ML model. The model should predict whether a customer will register for the loyalty program. The script should save the model to the source defined in the `schema.yml` file. For more information on how to do this, please refer to the [Fal documentation](https://docs.fal.ai/fal/reference/variables-and-functions#write_to_source-function). 
4. Rerun the model using `dbt run`. 
5. Run fal using `fal run`.

## Solution
**1. Setup**

:::{admonition} `schema.yml`
:class: dropdown

```yaml
version: 2

sources:
  - name: dbt
    tables:
      - name: customer_registration_prediction

models:
  - name: customer_registration_prediction
    meta:
      fal:
        scripts:
          - models/python_scripts/__main__.py
```

**2. Create a model**

:::{admonition} `schema.yml`
:class: dropdown

```sql
select * from {{ ref('dim_customers') }}
```

**3. Create a python script**
```python
import pandas as pd
from sklearn.linear_model import LogisticRegression

ref_df = ref('customer_registration_prediction')

# fill missing values with 0
ref_df.fillna(0, inplace=True)

# Extract the input and output variables
X = ref_df[["no_of_orders", "total_amount"]]
y = ref_df["loyalty_program"]

# Create a logstic regression model
model = LogisticRegression()

# Fit the model to the data
model.fit(X, y)

# Print the intercept and coefficient
print('Intercept:', model.intercept_)
print('Coefficient:', model.coef_)

ref_df['prediction'] = model.predict(X)

# Upload a `pandas.DataFrame` back to the datawarehouse
write_to_source(ref_df, "dbt", "customer_registration_prediction")
```

