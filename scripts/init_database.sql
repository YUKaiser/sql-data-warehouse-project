```Mysql
/*====================================================================
  Project  : Data Warehouse & Analytics
  Database : MySQL

  Description:
  This script initializes the Data Warehouse project by creating the
  main database and defining the Bronze, Silver, and Gold layers
  following the Medallion Architecture.

  Note:
  The original project is designed for SQL Server, where Bronze,
  Silver, and Gold are implemented as schemas within a database.

  In MySQL, CREATE SCHEMA is an alias for CREATE DATABASE. Therefore,
  these layers are typically implemented as separate databases
  (e.g., datawarehouse_bronze, datawarehouse_silver,
  datawarehouse_gold). The following statements are retained to
  match the original project structure.
====================================================================*/


/*--------------------------------------------------------------------
  Step 1: Create the Data Warehouse Database
--------------------------------------------------------------------*/
-- Create the main database
CREATE DATABASE IF NOT EXISTS DataWarehouse;
USE DataWarehouse;


/*--------------------------------------------------------------------
  Step 2: Create Medallion Architecture Layers
--------------------------------------------------------------------*/

-- Bronze Layer : Stores raw data imported from source systems.
CREATE SCHEMA bronze;

-- Silver Layer : Stores cleansed, standardized, and transformed data.
CREATE SCHEMA silver;

-- Gold Layer : Stores business-ready data optimized for reporting
--              and analytical queries.
CREATE SCHEMA gold;
```
