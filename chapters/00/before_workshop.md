# Before workshop

1. Clone dbt demo project -> https://github.com/strvcom/dbt-workshop and navigate to `dbt-demo` folder, which contains following:
   * dbt project
   * postgres database
   * sample data from jaffle_shop (already loaded in postgres db)
     * tables: *customers*, *orders*, *payments*
   * sample google analytics events data with traffic (.csv file in seeds folder within dbt folder)
2. Make sure to have [Docker Desktop](https://www.docker.com/products/docker-desktop/) running on your machine.
3. Once you are in `dbt-demo` folder, run `docker-compose up` which will download all images needed and start three containers:
   1. `dbt-demo-database-1` - postgres server as our data warehouse
   2. `dbt-demo-dbt-1` - container where to run dbt command 
   3. `dbt-demo-adminer-1` - container with adminer, simple SQL IDE available on [localhost:8080](http://localhost:8080)
4. Log into the adminer to confirm everything is running:
   1. server: `database`
   2. user/pass: `postgres/postgres`
   3. databse: `datawarehouse`
5. You should see following screen:
   ![adminer](../../images/adminer_success.png)
