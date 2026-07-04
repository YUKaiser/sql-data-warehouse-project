/*
=============================================================
Load Bronze Layer Data
=============================================================
Script Purpose:
    This script loads raw data from CSV files into the
    Bronze layer tables.

Steps Performed:
    1. Select the Bronze database.
    2. Truncate each table to remove existing data.
    3. Load fresh data from the corresponding CSV file.
    4. Verify the number of records loaded.

Note:
    - The source files are located in the project datasets folder.
    - This script can be executed multiple times safely because
      each table is truncated before loading.
=============================================================
*/

-- Select the Bronze Database
USE bronze;

-- ==========================================================
-- Load CRM Customer Information
-- ==========================================================
TRUNCATE TABLE crm_cust_info;

LOAD DATA LOCAL INFILE 'C:/Users/praso/Desktop/DE_WAR_PR/sql-data-warehouse-project-main/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Verify Data Load
SELECT COUNT(*) AS Total_Customers FROM crm_cust_info;


-- ==========================================================
-- Load CRM Product Information
-- ==========================================================
TRUNCATE TABLE crm_prd_info;

LOAD DATA LOCAL INFILE 'C:/Users/praso/Desktop/DE_WAR_PR/sql-data-warehouse-project-main/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Verify Data Load
SELECT COUNT(*) AS Total_Products FROM crm_prd_info;


-- ==========================================================
-- Load CRM Sales Details
-- ==========================================================
TRUNCATE TABLE crm_sales_details;

LOAD DATA LOCAL INFILE 'C:/Users/praso/Desktop/DE_WAR_PR/sql-data-warehouse-project-main/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Verify Data Load
SELECT COUNT(*) AS Total_Sales FROM crm_sales_details;


-- ==========================================================
-- Load ERP Customer Information
-- ==========================================================
TRUNCATE TABLE erp_cust_az12;

LOAD DATA LOCAL INFILE 'C:/Users/praso/Desktop/DE_WAR_PR/sql-data-warehouse-project-main/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Verify Data Load
SELECT COUNT(*) AS Total_ERP_Customers FROM erp_cust_az12;


-- ==========================================================
-- Load ERP Location Information
-- ==========================================================
TRUNCATE TABLE erp_loc_a101;

LOAD DATA LOCAL INFILE 'C:/Users/praso/Desktop/DE_WAR_PR/sql-data-warehouse-project-main/datasets/source_erp/LOC_A101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Verify Data Load
SELECT COUNT(*) AS Total_Locations FROM erp_loc_a101;


-- ==========================================================
-- Load ERP Product Category Information
-- ==========================================================
TRUNCATE TABLE erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE 'C:/Users/praso/Desktop/DE_WAR_PR/sql-data-warehouse-project-main/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Verify Data Load
SELECT COUNT(*) AS Total_Product_Categories FROM erp_px_cat_g1v2;

-- ==========================================================
-- End of Bronze Layer Data Load
-- ==========================================================