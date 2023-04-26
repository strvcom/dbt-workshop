# dbt Python model

To incorporate Python in our workflow, we will use Fal. For more information on Fal, please refer to the [Fal documentation](https://fal-ai.github.io/fal/).
The latest version of dbt support python models on its own, however these are models running directly inside vendors: e.g. Snowpark or Databricks. Due to limits of this workshops, we are running python model locally and for this purpose Fal AI is perfect choice.

## Setup all things needed

1. **fal python models:** 
   1. Create a new folder called `ml` in the `models/marts` folder. This is where we will store our ML models.
   2. Inside the `ml` folder, create a new file called `_ml.yml` with model and source defintion.
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
      :::
   3. Also add the dbt model itself `customer_registration_prediction.sql` with simple query inside.
      :::{admonition} `customer_registration_prediction.sql`
      :class: dropdown

      ```sql
      select 1
      ```
      :::
1. **fal python scripts:** 
   1. Add prediction script called `customer_registration_prediction.py` into `scripts` subfolders in the dbt project folder with script.
      :::{admonition} `customer_registration_prediction.py`
      :class: dropdown

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
      :::
   2. Append fal var setting into `dbt_project.yml` so fal-ai knows where to find them.
      :::{admonition} Append fal ai setting into `dbt_project.yml`
      :class: dropdown

      ```yaml
      vars:
        fal-models-paths: "models/ml"
        fal-scripts-path: "scripts"
      ```
      :::
1. **fal python models:** Ready to run it 
   1. First run the selected new dbt models `dbt run --select marts.ml.*`
   2. Take a look at the created table `dbt_ml.customer_registration_prediction`
   3. Then run the python script itself `fal run`
   4. Now you can take a look at the table again.
2. [BONUS] Add staging ml folder and incorporate all the way up into dim so you manager can see it in his dashboard!
