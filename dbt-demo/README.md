# dbt demo

This is a _dbt_ demo project. You can use this as a template or to learn _dbt_ on your local machine!

## What it contains

- dbt
- postgres database
- sample data from jaffle_shop

## How to run (with the internet connection)

1. Clone this repository
2. Navigate to the directory
3. Run 'docker-compose up'
4. Attach to docker container with dbt `docker exec -it dbt-demo-dbt-1 /bin/bash`

### How to run docker-compose without the internet connection

1. Download all `.tar` files from the provided USB
2. Run these 3 docker load commands:
    ```
        docker load -i adminer.tar
        docker load -i postgres.tar
        docker load -i dbt-demo-dbt.tar
    ```
3. Navigate to dbt-demo directory and run `docker-compose up`

## How to use

You can either checkout branch 'model' and explore simple dimensional model based on raw data or you can start from scratch and write your own.

## Tips and next steps

- [Awesome dbt](https://github.com/Hiflylabs/awesome-dbt)
- [How we structure our dbt project](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview)
- [dbt docs](https://docs.getdbt.com/docs/build/projects)
- [dbt packages](https://hub.getdbt.com/)
- [dbt training](https://www.getdbt.com/dbt-learn/)
- [dbt slack](getdbt.slack.com)
