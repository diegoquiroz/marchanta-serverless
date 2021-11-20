-- -------------------------------------------------------------
-- TablePlus 4.5.0(397)
--
-- https://tableplus.com/
--
-- Database: postgres
-- Generation Time: 2021-11-19 18:32:35.1800
-- -------------------------------------------------------------


-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.category_id_seq;

-- Table Definition
CREATE TABLE "orders"."category" (
    "id" int4 NOT NULL DEFAULT nextval('orders.category_id_seq'::regclass),
    "name" varchar(20),
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.client_id_seq;

-- Table Definition
CREATE TABLE "orders"."client" (
    "id" int4 NOT NULL DEFAULT nextval('orders.client_id_seq'::regclass),
    "legal_name" varchar(60) NOT NULL,
    "phone" int8 NOT NULL,
    "email" varchar(50) NOT NULL,
    "rfc" varchar(25),
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.currency_id_seq;

-- Table Definition
CREATE TABLE "orders"."currency" (
    "id" int4 NOT NULL DEFAULT nextval('orders.currency_id_seq'::regclass),
    "name" varchar(15) NOT NULL,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.order_id_seq;

-- Table Definition
CREATE TABLE "orders"."order" (
    "id" int4 NOT NULL DEFAULT nextval('orders.order_id_seq'::regclass),
    "client_id" int4 NOT NULL,
    "subtotal" float8 NOT NULL,
    "shipping_fee" float8 NOT NULL,
    "total" float8 NOT NULL,
    "status_id" int4 NOT NULL,
    "payment_method_id" int4 NOT NULL,
    "currency_id" int4 NOT NULL,
    "is_archived" bool NOT NULL,
    "created_on" date NOT NULL,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.order_has_products_id_seq;

-- Table Definition
CREATE TABLE "orders"."order_has_products" (
    "id" int4 NOT NULL DEFAULT nextval('orders.order_has_products_id_seq'::regclass),
    "order_id" int4 NOT NULL,
    "product_id" int4 NOT NULL,
    "quantity" float8 NOT NULL,
    "price" float8 NOT NULL,
    "product_price" float8 NOT NULL,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.payment_method_id_seq;

-- Table Definition
CREATE TABLE "orders"."payment_method" (
    "id" int4 NOT NULL DEFAULT nextval('orders.payment_method_id_seq'::regclass),
    "name" varchar(15) NOT NULL,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.product_id_seq;

-- Table Definition
CREATE TABLE "orders"."product" (
    "id" int4 NOT NULL DEFAULT nextval('orders.product_id_seq'::regclass),
    "sku" varchar(20) NOT NULL,
    "key" varchar(10) NOT NULL,
    "name" varchar(20) NOT NULL,
    "supplier_id" int4,
    "unit_id" int4,
    "wholesale_condition" varchar(30) NOT NULL,
    "is_active" bool DEFAULT true,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.product_has_category_id_seq;

-- Table Definition
CREATE TABLE "orders"."product_has_category" (
    "id" int4 NOT NULL DEFAULT nextval('orders.product_has_category_id_seq'::regclass),
    "id_product" int4,
    "id_category" int4,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.product_price_log_id_seq;

-- Table Definition
CREATE TABLE "orders"."product_price_log" (
    "id" int4 NOT NULL DEFAULT nextval('orders.product_price_log_id_seq'::regclass),
    "id_product" int4,
    "buy_price" int4 NOT NULL,
    "retail_price" int4 NOT NULL,
    "wholesale_percent" int4 NOT NULL,
    "sale_price" int4 NOT NULL,
    "created_on" date NOT NULL,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.purchase_order_id_seq;

-- Table Definition
CREATE TABLE "orders"."purchase_order" (
    "id" int4 NOT NULL DEFAULT nextval('orders.purchase_order_id_seq'::regclass),
    "status_id" int4 NOT NULL,
    "created_on" date NOT NULL,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.purchase_order_has_orders_id_seq;

-- Table Definition
CREATE TABLE "orders"."purchase_order_has_orders" (
    "id" int4 NOT NULL DEFAULT nextval('orders.purchase_order_has_orders_id_seq'::regclass),
    "purchase_order_id" int4 NOT NULL,
    "order_id" int4 NOT NULL,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS orders.status_id_seq;

-- Table Definition
CREATE TABLE "orders"."status" (
    "id" int4 NOT NULL DEFAULT nextval('orders.status_id_seq'::regclass),
    "name" varchar(15) NOT NULL,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Table Definition
CREATE TABLE "orders"."supplier" (
    "id" int4 NOT NULL,
    "name" varchar(20) NOT NULL,
    "priority" int4,
    PRIMARY KEY ("id")
);

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Table Definition
CREATE TABLE "orders"."unit" (
    "id" int4 NOT NULL,
    "name" varchar(10) NOT NULL,
    "key" varchar(10) NOT NULL,
    PRIMARY KEY ("id")
);

ALTER TABLE "orders"."order" ADD FOREIGN KEY ("client_id") REFERENCES "orders"."client"("id");
ALTER TABLE "orders"."order" ADD FOREIGN KEY ("status_id") REFERENCES "orders"."status"("id");
ALTER TABLE "orders"."order" ADD FOREIGN KEY ("payment_method_id") REFERENCES "orders"."payment_method"("id");
ALTER TABLE "orders"."order" ADD FOREIGN KEY ("currency_id") REFERENCES "orders"."currency"("id");
ALTER TABLE "orders"."order_has_products" ADD FOREIGN KEY ("product_id") REFERENCES "orders"."product"("id");
ALTER TABLE "orders"."order_has_products" ADD FOREIGN KEY ("order_id") REFERENCES "orders"."order"("id");
ALTER TABLE "orders"."product" ADD FOREIGN KEY ("unit_id") REFERENCES "orders"."unit"("id");
ALTER TABLE "orders"."product" ADD FOREIGN KEY ("supplier_id") REFERENCES "orders"."supplier"("id");
ALTER TABLE "orders"."product_has_category" ADD FOREIGN KEY ("id_category") REFERENCES "orders"."category"("id");
ALTER TABLE "orders"."product_has_category" ADD FOREIGN KEY ("id_product") REFERENCES "orders"."product"("id");
ALTER TABLE "orders"."product_price_log" ADD FOREIGN KEY ("id_product") REFERENCES "orders"."product"("id");
ALTER TABLE "orders"."purchase_order" ADD FOREIGN KEY ("status_id") REFERENCES "orders"."status"("id");
ALTER TABLE "orders"."purchase_order_has_orders" ADD FOREIGN KEY ("purchase_order_id") REFERENCES "orders"."purchase_order"("id");
ALTER TABLE "orders"."purchase_order_has_orders" ADD FOREIGN KEY ("order_id") REFERENCES "orders"."order"("id");
