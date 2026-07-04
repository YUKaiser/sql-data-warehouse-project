/*
=============================================================
Create Bronze Layer Tables
=============================================================
Script Purpose:
    This script creates all tables required for the
    Bronze layer of the data warehouse.

Tables Created:
    - crm_cust_info
    - crm_prd_info
    - crm_sales_details
    - erp_cust_az12
    - erp_loc_a101
    - erp_px_cat_g1v2

Note:
    - IF NOT EXISTS is used to prevent errors if a table
      already exists.
    - These tables store raw data exactly as received from
      the source systems.
=============================================================
*/

-- Select the Bronze Database
USE bronze;

-- ==========================================================
-- Create CRM Customer Information Table
-- ==========================================================
CREATE TABLE IF NOT EXISTS crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

-- ==========================================================
-- Create CRM Product Information Table
-- ==========================================================
CREATE TABLE IF NOT EXISTS crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost DECIMAL(10,2),
    prd_line VARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);

-- ==========================================================
-- Create CRM Sales Details Table
-- ==========================================================
CREATE TABLE IF NOT EXISTS crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales DECIMAL(10,2),
    sls_quantity INT,
    sls_price DECIMAL(10,2)
);

-- ==========================================================
-- Create ERP Customer Information Table
-- ==========================================================
CREATE TABLE IF NOT EXISTS erp_cust_az12 (
    CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(50)
);

-- ==========================================================
-- Create ERP Location Information Table
-- ==========================================================
CREATE TABLE IF NOT EXISTS erp_loc_a101 (
    CID VARCHAR(50),
    CNTRY VARCHAR(50)
);

-- ==========================================================
-- Create ERP Product Category Table
-- ==========================================================
CREATE TABLE IF NOT EXISTS erp_px_cat_g1v2 (
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);

-- ==========================================================
-- End of Bronze Layer Table Creation
-- ==========================================================


