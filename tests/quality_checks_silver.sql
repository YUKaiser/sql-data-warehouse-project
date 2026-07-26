-- ==========================================================
-- Start of Silver Layer ETL
-- ==========================================================
DROP PROCEDURE IF EXISTS silver.load_silver;
DELIMITER $$
Create procedure silver.load_silver()
Begin
SELECT '=============================================' AS Message;
SELECT 'Starting Silver Layer Load...' AS Message;
SELECT CONCAT('Started At : ', NOW()) AS Message;
SELECT '=============================================' AS Message;
#Inserting in silver.crm_cust_info
SELECT '------------------------------------------------' AS Message;
SELECT 'Loading Table : silver.crm_cust_info' AS Message;
SELECT 'Step 1 : Truncating existing data...' AS Message;
truncate table silver.crm_cust_info;
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname),
    TRIM(cst_lastname),
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END,
    cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY cst_id
               ORDER BY cst_create_date DESC
           ) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
      AND cst_id <> 0
) AS t
WHERE flag_last = 1;

SELECT
'✔ silver.crm_cust_info loaded successfully' AS Status,
COUNT(*) AS Total_Rows,
NOW() AS Loaded_At
FROM silver.crm_cust_info;


#Inserting in Silver.crm_prd_info
-- Load cleaned and transformed product data from Bronze to Silver layer
SELECT '------------------------------------------------' AS Message;
SELECT 'Loading Table : silver.crm_prd_info' AS Message;
SELECT 'Step 1 : Truncating existing data...' AS Message;

truncate table silver.crm_prd_info;
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)

SELECT
    -- Product ID
    prd_id,

    -- Extract Category ID from the first 5 characters of prd_key
    -- Example: 'AC-HE-HL-U509' → 'AC_HE'
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,

    -- Extract the actual Product Key by removing the category prefix
    -- Example: 'AC-HE-HL-U509' → 'HL-U509'
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,

    -- Product Name
    prd_nm,

    -- Replace NULL product costs with 0
    IFNULL(prd_cost, 0) AS prd_cost,

    -- Convert product line codes into meaningful descriptions
    CASE
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line,

    -- Ensure the start date is stored as a DATE
    CAST(prd_start_dt AS DATE) AS prd_start_dt,

    -- Calculate the end date as one day before the next version's start date
    -- LEAD() gets the next start date for the same product
    -- DATE_SUB() subtracts one day to avoid overlapping date ranges
    CAST(
        DATE_SUB(
            LEAD(prd_start_dt) OVER (
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            ),
            INTERVAL 1 DAY
        ) AS DATE
    ) AS prd_end_dt

FROM bronze.crm_prd_info;

SELECT
'✔ silver.crm_prd_info loaded successfully' AS Status,
COUNT(*) AS Total_Rows,
NOW() AS Loaded_At
FROM silver.crm_prd_info;

-- Load cleaned sales data from Bronze to Silver.crm_sales_details layer
SELECT '------------------------------------------------' AS Message;
SELECT 'Loading Table : silver.crm_sales_details' AS Message;
SELECT 'Step 1 : Truncating existing data...' AS Message;
Truncate Table silver.crm_sales_details;
INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)

SELECT
    -- Order Number
    sls_ord_num,

    -- Product Key
    sls_prd_key,

    -- Customer ID
    sls_cust_id,

    -- Validate and convert Order Date
    CASE
        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')
    END AS sls_order_dt,

    -- Validate and convert Ship Date
    CASE
        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')
    END AS sls_ship_dt,

    -- Validate and convert Due Date
    CASE
        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')
    END AS sls_due_dt,

    -- Recalculate Sales if missing, zero, or inconsistent
    CASE
        WHEN sls_sales IS NULL
          OR sls_sales <= 0
          OR sls_sales <> sls_quantity * ABS(sls_price)
        THEN ROUND(sls_quantity * ABS(sls_price), 2)
        ELSE sls_sales
    END AS sls_sales,

    -- Quantity
    sls_quantity,

    -- Derive Price if missing or invalid
    CASE
        WHEN sls_price IS NULL
          OR sls_price <= 0
        THEN ROUND(sls_sales / NULLIF(sls_quantity, 0), 2)
        ELSE sls_price
    END AS sls_price

FROM bronze.crm_sales_details;

SELECT
'✔ silver.crm_sales_details loaded successfully' AS Status,
COUNT(*) AS Total_Rows,
NOW() AS Loaded_At
FROM silver.crm_sales_details;


-- Load cleaned customer data from Bronze to Silver
SELECT '------------------------------------------------' AS Message;
SELECT 'Loading Table : silver.erp_cust_az12' AS Message;
SELECT 'Step 1 : Truncating existing data...' AS Message;
TRUNCATE TABLE silver.erp_cust_az12;
INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)

SELECT

    -- Remove the 'NAS' prefix from Customer ID if it exists
    CASE
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID))
        ELSE CID
    END AS CID,

    -- Set future birth dates to NULL (invalid data)
    CASE
        WHEN BDATE > CURDATE() THEN NULL
        ELSE BDATE
    END AS BDATE,

    -- Standardize gender values
    -- M, MALE   -> Male
    -- F, FEMALE -> Female
    -- Anything else -> n/a
    CASE
        WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS GEN

FROM bronze.erp_cust_az12;

SELECT
'✔ silver.erp_cust_az12 loaded successfully' AS Status,
COUNT(*) AS Total_Rows,
NOW() AS Loaded_At
FROM silver.erp_cust_az12;


-- ==========================================================
-- Purpose: Load and clean location data from Bronze.erp_loc_a101 to Silver.erp_loc_a101
-- ==========================================================

-- Remove all existing records from the Silver table
SELECT '------------------------------------------------' AS Message;
SELECT 'Loading Table : silver.erp_loc_a101' AS Message;
SELECT 'Step 1 : Truncating existing data...' AS Message;
TRUNCATE TABLE silver.erp_loc_a101;

-- Insert cleaned data into the Silver table
INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry
)

SELECT

    -- Customer IDs should not contain '-' in the Silver layer.
    -- Example: AW-0001 -> AW0001
    REPLACE(CID, '-', '') AS CID,

    -- Standardize country values so that different representations
    -- of the same country are stored consistently.
    CASE

        -- Convert country code 'DE' to the full country name.
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'

        -- Convert both 'US' and 'USA' to a single standard value.
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'

        -- If the country is blank or NULL, replace it with 'n/a'
        -- to indicate missing information.
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'

        -- Otherwise, keep the original value after removing
        -- any extra spaces.
        ELSE TRIM(cntry)

    END AS CNTRY

-- Read data from the Bronze layer
FROM bronze.erp_loc_a101;
SELECT
'✔ silver.erp_loc_a101 loaded successfully' AS Status,
COUNT(*) AS Total_Rows,
NOW() AS Loaded_At
FROM silver.erp_loc_a101;

-- ==========================================================
-- Purpose: Load product category data from Bronze to Silver
-- No data cleaning or transformation is required.
-- ==========================================================

-- Remove all existing records from the Silver table

SELECT '------------------------------------------------' AS Message;
SELECT 'Loading Table : silver.erp_px_cat_g1v2' AS Message;
SELECT 'Step 1 : Truncating existing data...' AS Message;
TRUNCATE TABLE silver.erp_px_cat_g1v2;

-- Insert data into the Silver table
INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)

SELECT
    -- Product category ID
    id,

    -- Product category name
    cat,

    -- Product subcategory name
    subcat,

    -- Product maintenance information
    maintenance

-- Read data directly from the Bronze layer
FROM bronze.erp_px_cat_g1v2;
SELECT
'✔ silver.erp_px_cat_g1v2 loaded successfully' AS Status,
COUNT(*) AS Total_Rows,
NOW() AS Loaded_At
FROM silver.erp_px_cat_g1v2;

SELECT '=============================================' AS Message;
SELECT 'Silver Layer Loading Completed Successfully!' AS Message;
SELECT CONCAT('Completed At : ', NOW()) AS Message;
SELECT '=============================================' AS Message;

END $$
DELIMITER ;




