-- ==========================================================
-- Create Customer Dimension (gold.dim_customers)
-- ==========================================================
-- Purpose:
-- Create the Customer Dimension table in the Gold layer by
-- combining customer information from CRM and ERP systems.
--
-- Transformations:
-- 1. Generate a surrogate key for each customer.
-- 2. Merge customer master data with ERP customer details.
-- 3. Merge customer location information.
-- 4. Resolve gender using CRM first, otherwise ERP.
-- ==========================================================
Create view gold.dim_customers as
(
select

-- Generate a surrogate key (Primary Key) for each customer
-- This key is system-generated and used for analytical purposes.
row_number() Over(order by cst_id) as customer_key,

-- Customer ID from CRM
ci.cst_id as customer_id,

-- Customer Business Key / Customer Number
ci.cst_key as customer_number,

-- Customer First Name
ci.cst_firstname as first_name,

-- Customer Last Name
ci.cst_lastname as last_name,

-- Customer Country from ERP Location table
la.cntry as country,

-- Customer Marital Status
ci.cst_marital_status as marital_status,

-- Gender Preference:
-- 1. Use CRM gender if it is available.
-- 2. If CRM contains 'n/a', use ERP gender.
-- 3. If ERP gender is NULL, return 'n/a'.
case
    when ci.cst_gndr != 'n/a' then ci.cst_gndr
    else coalesce(ca.gen,'n/a')
end as gender,

-- Customer Birth Date from ERP
ca.bdate as birth_date,

-- Customer Record Creation Date
ci.cst_create_date as create_date

from silver.crm_cust_info as ci

-- Join ERP Customer table to get Birth Date and Gender
left join silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid

-- Join ERP Location table to get Country
left join silver.erp_loc_a101 as la
on ci.cst_key = la.cid

);

-- ============================================================
-- Create Product Dimension View
-- This view combines product information from CRM and ERP tables.
-- It keeps only the latest active products (where end date is NULL)
-- and generates a surrogate key for each product.
-- ============================================================

CREATE VIEW gold.dim_products AS

SELECT
    -- Generate a unique surrogate key for each product
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,

    -- Original product ID from CRM
    pn.prd_id AS product_id,

    -- Business product key/number
    pn.prd_key AS product_number,

    -- Product name
    pn.prd_nm AS product_name,

    -- Category ID
    pn.cat_id AS category_id,

    -- Category name from ERP category table
    pc.cat AS category,

    -- Subcategory name
    pc.subcat AS subcategory,

    -- Maintenance information
    pc.maintenance,

    -- Product cost
    pn.prd_cost AS cost,

    -- Product line/type
    pn.prd_line AS product_line,

    -- Date from which the product became active
    pn.prd_start_dt AS start_date

-- Product information table
FROM silver.crm_prd_info AS pn

-- Join with ERP category table to get category details
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
    ON pn.cat_id = pc.ID

-- Keep only the current (active) version of each product
WHERE pn.prd_end_dt IS NULL;

-- ============================================================
-- Create Fact Sales View
-- This view stores sales transaction data and connects it with
-- the Product and Customer dimensions using surrogate keys.
-- It serves as the central fact table for sales analytics.
-- ============================================================

CREATE VIEW gold.fact_sales AS

SELECT
    -- Sales order number
    sd.sls_ord_num AS order_number,

    -- Surrogate key from Product Dimension
    pr.product_key,

    -- Surrogate key from Customer Dimension
    cu.customer_key,

    -- Date when the order was placed
    sd.sls_order_dt AS order_date,

    -- Date when the order was shipped
    sd.sls_ship_dt AS shipping_date,

    -- Due date for the order
    sd.sls_due_dt AS due_date,

    -- Total sales amount for the order
    sd.sls_sales AS sales_amount,

    -- Number of units sold
    sd.sls_quantity AS quantity,

    -- Price per unit
    sd.sls_price AS price

-- Sales transaction table
FROM silver.crm_sales_details AS sd

-- Join with Product Dimension to retrieve the product surrogate key
LEFT JOIN gold.dim_products AS pr
    ON sd.sls_prd_key = pr.product_number

-- Join with Customer Dimension to retrieve the customer surrogate key
LEFT JOIN gold.dim_customers AS cu
    ON sd.sls_cust_id = cu.customer_id;
