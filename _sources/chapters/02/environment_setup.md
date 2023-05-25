# Environment setup

1. clone dbt demo project -> https://github.com/strvcom/dbt-workshop and navigate to `dbt-demo` folder:
    * this demo project contains:
        * dbt
        * postgres database
        * sample data from jaffle_shop (already loaded in postgres db)
            * tables: *customers*, *orders*, *payments*
        * sample google analytics events data with traffic (.csv file in seeds folder within dbt folder)


2. once you are in `dbt-demo` folder, run `docker-compose up`
3. attach to docker container with dbt `docker exec -it dbt-demo-dbt-1 /bin/bash`
4. you are now in dbt container where you can execute `dbt` commands