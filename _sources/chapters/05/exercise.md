# Exercise

To proceed with this exercise we firstly need to have some new or updated records in our database. We have prepared `update.sql` file with batch of fresh data which we now import into our current DB. To do that follow next steps:

1. open terminal and navigate to the `dbt-workshop/db` folder

2. copy the `update.sql` file into the container using the following command:

    `docker cp update.sql dbt-demo-workshop-database-1:/update.sql`

2. connect to the Postgres container:

    `docker exec -it  dbt-demo-workshop-database-1 psql -U postgres datawarehouse`

3. run the .sql file inside postgres container:

    `\i update.sql`

Now we should have some fresh and updated records in our DB.

## Task

TODO

## Solution