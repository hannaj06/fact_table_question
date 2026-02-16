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

## Part 1 — Design and Create an Order Facts table with the following parameters:

Build a table named:

**fact_order_lines**

### Requirements

Please provide:
1. The DDL for the final table
2. The DML to insert into the facts table

The table must:
- Support incremental loading
- Have grain: One row per order line (order_id + product_id)
- Include customer attributes
- Include product attributes
- Include revenue calculation
- Include data engineering metadata fields
