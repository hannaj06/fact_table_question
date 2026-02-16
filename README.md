# fact_table_question

## Consider the following tables:

### orders
```sql
create or replace table orders (
    order_id            varchar,
    customer_id         varchar,
    customer_email      varchar,
    customer_country    varchar,
    order_timestamp     timestampntz,   
    order_status        varchar,
    currency            varchar,
    source_updated_at   timestampntz,   
    etl_loaded_at       timestampntz
);
```

### order_items
```sql
create or replace table order_items (
    order_id          varchar,
    product_id        varchar,
    quantity          number,
    unit_price        number,
    source_updated_at timestampntz,
    etl_loaded_at     timestampntz
);
```

### products
```sql
create or replace table products (
    product_id      varchar,
    product_name    varchar,
    category        varchar,
    brand           varchar,
    etl_loaded_at   timestampntz
);
```

## Part 1 — Design and create an order facts table


### Requirements

1. The solution is provided via a pull request within github. Use the file name `submission.sql`
2. Provide all DDL statement(s) needed to build the final table
3. Provide all DML statements to insert into the facts table

The table must:
- Support incremental loading
- Have grain: One row per order line (order_id + product_id)
- Include customer attributes
- Include product attributes
- Include revenue calculation
- Include data engineering metadata fields
