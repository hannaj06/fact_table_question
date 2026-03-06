---Customer dimension table

CREATE TABLE CUSTOMER (
customer_id   varchar,
customer_email      varchar,
customer_country    varchar,
etl_loaded_at     timestampntz
);



---fact table creation (assuming id values can be AlphaNumeric)
CREATE TABLE FACT_ORDERS (
order_id    varchar NOT NULL,
product_id    varchar NOT NULL,
customer_id   varchar NOT NULL,
order_status   varchar,
quantity   number,
unit_price   number,
currency   VARCHAR,
source_updated_at timestampntz,
etl_loaded_at     timestampntz,
primary key (order_id, product_id, customer_id)
);

--temporary table creation for incremental load


CREATE TEMP TABLE SOURCE_DETAILS_CDC (
ORDER_ID,
PRODUCT_ID,
CUSTOMER_ID,
CUSTOMER_EMAIL,
CUSTOMER_COUNTRY,
ORDER_STATUS,
QUANTITY,
UNIT_PRICE,
CURRENCY,
SOURCE_UPDATED_AT,
ETL_LOADED_AT
);



----FULL LOAD/INITAL LOAD LOGIC


INSERT INTO fact_orders (order_id,product_id, customer_id, order_status,currency,  quantity, unit_price, source_updated_at, etl_loaded_at)

SELECT
	ORDER.order_id ,ORDER.product_id, ORDER.customer_id ,ORDER.order_status, ORDER.currency,  ORDER_ITM.quantity, ORDER_ITM.unit_price, ORDER.source_updated_at, ORDER.etl_loaded_at

FROM ORDER as ORDR
INNER JOIN ORDER_ITEMS as ORDER_ITM on ORDER.order_id = ORDER_ITM.order_id ;



----INCREMENTAL LOAD LOGIC

Step 1: 

INSERT INTO SOURCE_DETAILS_CDC (order_id,product_id, customer_id, order_status,currency,  quantity, unit_price, source_updated_at, etl_loaded_at)

SELECT
	ORDER.order_id ,ORDER.product_id, ORDER.customer_id ,ORDER.order_status, ORDER.currency,  ORDER_ITM.quantity, ORDER_ITM.unit_price, ORDER.source_updated_at, ORDER.etl_loaded_at

FROM ORDERS as ORDER
INNER JOIN ORDER_ITEMS as ORDER_ITM on ORDER.order_id = ORDER.order_id

WHERE ORDER.etl_loaded_at > (SELECT MAX(etl_loaded_at) FROM FACT_ORDERS) ; --taking newly added data in source


Step 2:

MERGE INTO fact_orders as T
USING SOURCE_DETAILS_CDC as S
On T.order_id = S.order_id and T.product_id = S. product_id and T.customer_id = S.customer_id
WHEN MATCHED THEN
	UPDATE ALL BY NAME
WHEN NOT MATCHED THEN
	INSERT ALL BY NAME
;




---FINAL QUERY TO BRING ALL REQUIRED ATTRIBUTES

SELECT a.customer_id,c.customer_email,c.customer_country,a.order_id,p.product_name,p.category,p.brand,(o.quantity*o.unit_price) as revenue, o.currency, o.etl_loaded_at
FROM fact_orders as o
INNER JOIN products as p on o.product_id = p.product_id
INNER JOIN CUSTOMERS as c on c.customer_id = o.customer_id;