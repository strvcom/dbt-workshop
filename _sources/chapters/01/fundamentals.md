# dbt Fundamentals

## Main files

| filename          | description                                                                                                                                                                                                                                      |
| :---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `dbt_project.yml` | The main file for project configuration. The project name is defined here, and folder paths for specific functions and models from the transform folder are defined here as well. Additionally, hookups that can e.g. grant permissions on schemas are set up here. |
| `profiles.yml`    | Connection to the database is set up here including **schema**.                                                                                                                                                                                  |
| `schema.yml`      | YAML definition file for models. This can have the same name as subfolder inside transform folder. Used for documenting each table and most importantly setting up tests on these tables.                                                        |
| `sources.yml`     | YAML definition of source tables. Raw database/schema is defined here.                                                                                                                                                                           |

## Main dbt commands

| command             | description                                                                                                                 |
| :------------------ | --------------------------------------------------------------------------------------------------------------------------- |
| `dbt run`           | Initiate compilation and run of model DAGs                                                                                |
| `dbt test`          | Initiate testing on current models. Needs to run on existing tables/views so need to be run after at least one `dbt run`. |
| `dbt compile`       | Runs compilations only. Good for testing before changing anything. Compiled SQL can be run against DB.           |
| `dbt docs generate` | Generates documentation from `schema.yml` files and on top of a database. Includes useful info such as number of rows.            |
| `dbt docs serve`    | Starts webserver to provide documentation on localhost.                                                                     |
| `dbt seed`          | Takes .csv files from folder `seeds` and uploads it into a database. The schema where it ends up can be changed in `dbt_project.yml`   |
| `dbt build`         | A new command to do `dbt run` and `dbt test` sequentially.                                                                    |

## Main jinja functions

```{note}
jinja is web template engine for Python that uses curly brackets to define it's variables.
```

```python
{%- for item in item_list %}
    <li>{{ item }}</li>
{%- endfor %}
```

```html
<li>1</li>
<li>2</li>
<li>3</li>
```

| function              | description                                                                                   |
| :-------------------- | --------------------------------------------------------------------------------------------- |
| `{{ ref('') }}`       | A jinja function to reference previous models. It doesn't need path inside, filename is enough. |
| `{{ source('','') }}` | A jinja function to reference source tables defined in `sources.yml`.                           |

## Model settings

| setting         | value        | description                                                                                                                                                                                                                                                                                                                        |
| :-------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| materialization | `view`         | Default materialization that only `CREATE VIEW AS` on top of model's sql.                                                                                                                                                                                                                                                          |
| materialization | `table`        | This uses sql `CREATE TABLE AS `                                                                                                                                                                                                                                                                                                   |
| materialization | `ephemeral`    | This creates the model in a temporary table in the session. These are used as middle-step models to fill dependent tables that do not necessarily need to be materialized for other use cases.                                                                                                                                      |
| materialization | `incremental`  | Most difficult to set up but can help optimizing compute. This creates temporary table on the incremental part of source. Defined via jinja statement `{% if is_incremental() %} where event_time > (select max(event_time) from {{ this }}) {% endif %}`. Then it runs `MERGE INTO` sql statements that inserts/updates rows in the table. |
| schema          | `dev_fullname` | Schema for development. This is set via `profiles.yml` file or env variable.                                                                                                                                                                                                                                                       |
| schema          | `prod`         | Schema for production, usually behind BI tool.                                                                                                                                                                                                                                                                                                                                   |
