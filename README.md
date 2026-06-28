# 📊 Data Warehouse & Analytics Project (MySQL)

A modern **Data Warehouse and Analytics** project built using **MySQL**, implementing an end-to-end ETL pipeline, dimensional data modeling, and analytical reporting.

This project demonstrates industry-standard data engineering practices using the **Medallion Architecture (Bronze, Silver, Gold)** to transform raw business data into actionable insights.

---

# 🚀 Project Overview

This project covers the complete lifecycle of building a modern data warehouse:

* Designing a scalable data warehouse architecture
* Building ETL pipelines to ingest and transform data
* Performing data cleansing and standardization
* Creating dimensional models (Fact & Dimension Tables)
* Generating analytical reports using SQL

The primary objective is to consolidate data from multiple business systems into a centralized warehouse for efficient reporting and decision-making.

---

# 🏗️ Data Architecture

The project follows the **Medallion Architecture**, consisting of three logical layers:

<img width="1024" height="604" alt="image" src="https://github.com/user-attachments/assets/a24b961a-68ad-4574-be81-9b436b88a62f" />


## 🥉 Bronze Layer

The Bronze layer stores raw data exactly as received from the source systems.

**Purpose**

* Load data from CSV files
* Preserve original source data
* No transformations applied

---

## 🥈 Silver Layer

The Silver layer performs data cleaning and transformation.

**Processes**

* Data cleansing
* Handling missing values
* Removing duplicates
* Standardizing formats
* Normalizing data
* Data validation

---

## 🥇 Gold Layer

The Gold layer contains business-ready data optimized for analytics.

**Features**

* Star Schema implementation
* Fact Tables
* Dimension Tables
* Aggregated business metrics
* Reporting-ready datasets

---

# ⚙️ ETL Pipeline

The ETL process consists of:

1. **Extract**

   * Import CSV datasets from ERP and CRM systems

2. **Transform**

   * Clean data
   * Standardize formats
   * Resolve quality issues
   * Merge datasets

3. **Load**

   * Load processed data into Bronze
   * Transform into Silver
   * Publish analytical models in Gold

---

# 📊 Data Modeling

The Gold layer is designed using a **Star Schema** consisting of:

### Fact Tables

* Sales Fact

### Dimension Tables

* Customer Dimension
* Product Dimension
* Date Dimension

This model is optimized for high-performance analytical queries.

---

# 📈 Analytics & Reporting

SQL queries are used to generate business insights, including:

* 📌 Customer Behavior Analysis
* 📌 Product Performance
* 📌 Sales Trends
* 📌 Revenue Analysis
* 📌 Customer Segmentation
* 📌 Business KPIs

---

# 🎯 Project Objectives

* Build a modern data warehouse using MySQL
* Implement ETL pipelines
* Apply data quality techniques
* Design dimensional models
* Generate analytical reports
* Follow industry-standard Data Engineering practices

---

# 🛠️ Technologies Used

| Category        | Tools        |
| --------------- | ------------ |
| Database        | MySQL        |
| ETL             | SQL          |
| Data Modeling   | Star Schema  |
| Data Source     | CSV Files    |
| Documentation   | Markdown     |
| Version Control | Git & GitHub |
| Diagramming     | Draw.io      |

---

# 📂 Project Structure

```text
data-warehouse-project/
│
├── datasets/
│   ├── crm/
│   └── erp/
│
├── docs/
│   ├── data_architecture.drawio
│   ├── data_flow.drawio
│   ├── data_models.drawio
│   ├── etl.drawio
│   ├── data_catalog.md
│   └── naming_conventions.md
│
├── scripts/
│   ├── bronze/
│   │   ├── create_tables.sql
│   │   ├── load_csv.sql
│   │   └── bronze_etl.sql
│   │
│   ├── silver/
│   │   ├── clean_data.sql
│   │   ├── transform_data.sql
│   │   └── silver_etl.sql
│   │
│   ├── gold/
│   │   ├── dimension_tables.sql
│   │   ├── fact_tables.sql
│   │   └── analytical_views.sql
│   │
│   └── tests/
│       └── data_quality_checks.sql
│
├── README.md
├── LICENSE
└── .gitignore
```

---

# 📌 Data Sources

The project uses two business source systems:

* ERP Dataset
* CRM Dataset

Both datasets are provided as CSV files and are integrated into a unified analytical model.

---

# 📚 Skills Demonstrated

* SQL Development
* Data Engineering
* ETL Pipeline Design
* Data Warehouse Development
* Data Cleaning
* Data Modeling
* Star Schema Design
* Analytical SQL
* Data Analytics

---

# 📝 License

This project is licensed under the **MIT License**.

Feel free to use, modify, and share this project with proper attribution.
