# Building marts - `dim_[name].sql / fact_[name].sql`

We can now start creating data marts. In this lecture, we will follow dimensional modeling practice, but other techniques can be also used. 

:::{admonition} Kimball's dimensional modelling
The key concept of dimensional modeling is the creation of a star schema, which consists of a central **fact table** surrounded by one or more **dimension tables**. `The fact table contains the measures or quantitative data` that is to be analyzed, such as sales revenue or customer orders, while `the dimension tables contain descriptive attributes` or qualitative data, such as product or customer information. The relationship between the fact and dimension tables is established through a set of keys, called foreign keys, that allow the data to be joined together.
:::

## Creating `core` folder

In our example, we will be creating `core` folder within `marts` folder.

**Setup:**
1. go to `models/marts` folder and create `core` folder
2. create `_core.yml` where we store documentation and tests for the tables
3. create `dim_[].sql` and `fact_[].sql` files with SQL transformations

:::{admonition} Data marts covering multiple areas
:class: tip
The `marts` folder typically contains multiple subfolders, each of which corresponds to a specific business function or analytical domain. For example, you might have a *finance* subfolder that contains tables related to finance data, a *marketing* subfolder that contains tables related to marketing data, and so on. 
```
models/marts
├── finance
│   ├── _finance__models.yml
│   ├── orders.sql
│   └── payments.sql
└── marketing
    ├── _marketing__models.yml
    └── customers.sql
```
:::

## [Optional] Creating `intermediate` folder

Within our `core` folder (or optionally within each folder covering different area), we can create intermediate models `[entity]s_[verb]s.sql`. Intermediate models are used to break down complex data transformations into smaller, more manageable steps. These intermediate models act as building blocks, enabling you to create a modular (meaning that they can be reused in multiple data pipelines), and scalable data transformation process that is easier to understand, test, and maintain.  