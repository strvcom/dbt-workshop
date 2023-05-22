# Project setup - `dbt_project.yml`

Firstly, we need to setup our dbt project by adjusting `dbt_project.yml` file and creating subfolders in `models` folder which will contain our models.

1. Go to `dbt_project.yml` located in `dbt_demo` folder.
3. According to our recommended structure, we have defined submodels *staging*, *marts* and *ml* with materialization and schema settings which will be used throughout the workshop:

📝 **example for `dbt_project.yml`**

```yaml
models:
  dbt_demo:
    staging:
      materialized: view
    marts:
      +schema: marts
      core:
        materialized: table
      ml: 
        materialized: table
```
4. Go to `models` folder and firstly **delete** everything what is inside (it contains sample models which we are not going to use) and **create subfolders** `staging`, `marts` and `ml`. In the previous step we set up configuration for all models which will be placed in these folders.

5. Inside `staging` folder, create subfolder for each data source, in our case *jaffle_shop* and *google_analytics*.

## Exercise - Pro Tip

Run `dbt ls --resource-type model --output path`

If everything is setup correctly, you should see this

```shell
09:19:56  [WARNING]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 4 unused configuration paths:
- models.dbt_demo.marts.core
- models.dbt_demo.marts.ml
- models.dbt_demo.marts
- models.dbt_demo.staging
```