# Project setup - `dbt_project.yml`

1. Go to `dbt_project.yml` and set project name, e.g. *dbt_workshop*
2. Scroll down and under *models*, change first submodel to the new project name - *dbt_workshop*
3. According to our recommended structure, add submodels *staging* and *marts* with materialization and schema settings:

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
```
4. Inside models folder create subfolders `staging` and `marts`. In the previous step we set up configuration for all models which will be placed in these folders.

5. Inside `staging` folder, create subfolder for each data source, in our case *jaffle_shop* and *google_analytics*

## Exercise - Pro Tip

Run `dbt ls --resource-type model --output path`
