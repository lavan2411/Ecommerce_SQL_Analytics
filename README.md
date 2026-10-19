# E-commerce SQL Analytics

An end-to-end data analytics project using Python, MySQL, and SQL to extract, organize, validate, and analyze e-commerce data from the DummyJSON API.

The project explores customer spending, product performance, cart values, category contribution, inventory indicators, and discount patterns using SQL queries.

> **Dataset:** DummyJSON provides synthetic sample data. The findings demonstrate SQL and data analytics techniques and should not be interpreted as actual business performance.

## Table of Contents

* [Project Overview](#project-overview)
* [Business Questions](#business-questions)
* [Technology Stack](#technology-stack)
* [Data Source](#data-source)
* [Project Workflow](#project-workflow)
* [Project Structure](#project-structure)
* [SQL Analysis](#sql-analysis)
* [Key Findings](#key-findings)
* [Recommendations](#recommendations)
* [Data Quality Checks](#data-quality-checks)
* [SQL Concepts Demonstrated](#sql-concepts-demonstrated)
* [Setup and Execution](#setup-and-execution)
* [Limitations](#limitations)
* [Future Improvements](#future-improvements)
* [Author](#author)

## Project Overview

The goal of this project is to demonstrate how SQL can be used to transform e-commerce data into structured information for business analysis.

Python handles API extraction and database loading, while MySQL stores the data and executes analytical queries.

The analysis covers customers, products, carts, cart items, and discounts.

## Business Questions

This project addresses the following questions:

1. How many customers, products, and carts are present in the dataset?
2. What are the total cart value, discounted cart value, and discount amount?
3. How are customers distributed by gender and age group?
4. Which product categories contain the most products?
5. Which products have the highest ratings and stock levels?
6. Which products appear most frequently in carts by quantity?
7. Which customers have the highest total cart values?
8. Which product categories contribute the most to total cart value?
9. How do discount amounts and percentages vary across categories?
10. Which products have high stock but low quantities in the available carts?

## Technology Stack

| Technology | Purpose                                                             |
| ---------- | ------------------------------------------------------------------- |
| Python     | API data extraction and database loading                            |
| MySQL      | Data storage and SQL analysis                                       |
| SQL        | Data inspection, transformation, aggregation, and business analysis |
| Git        | Version control                                                     |
| GitHub     | Source code hosting and project documentation                       |

## Data Source

The project uses the [DummyJSON API](https://dummyjson.com/) to retrieve sample e-commerce data.

The dataset includes four main entities:

* Users
* Products
* Carts
* Cart items

The data is synthetic and is used to demonstrate data engineering and analytical techniques.

## Project Workflow

The project follows an ETL workflow.

### 1. Extract

Python retrieves user, product, and cart information from the DummyJSON API.

### 2. Load

The extracted data is loaded into MySQL tables.

### 3. Inspect

SQL queries examine row counts, sample records, missing values, duplicate records, invalid values, and relationships between tables.

### 4. Transform

The project organizes the data into tables and views suitable for analysis.

### 5. Analyze

SQL queries calculate business KPIs and examine customer, product, inventory, category, and discount patterns.

## Project Structure

The repository contains Python scripts for API extraction and database loading, SQL scripts for database setup and analysis, and project documentation.

Main components:

* `src/` — Python extraction and loading scripts.
* `sql/` — SQL scripts for schema management, transformations, data inspection, and analytics.
* `README.md` — Project documentation.

Individual filenames are maintained in the repository's actual directory structure.

## SQL Analysis

The main analytics script is `sql/analytics.sql`.

### 1. Business Overview

Calculates:

* Total customers
* Total products
* Total carts
* Total quantity across carts
* Original cart value
* Discounted cart value
* Total discount amount
* Overall discount percentage

### 2. Customer Analysis

Examines:

* Customer distribution by gender
* Customer distribution by age
* Customer distribution by age group
* Customers with the highest cart values
* Customer ranking by total cart value
* Average cart value by customer
* Customer spending segments

### 3. Product and Category Analysis

Examines:

* Product counts by category
* Average product prices and ratings
* Top-rated products
* Products with the highest stock
* Products with the highest carted quantities
* Products generating the highest cart value
* Product ranking by carted quantity

### 4. Inventory Analysis

Identifies products with relatively high stock but low quantities in the available carts.

This analysis demonstrates how SQL can identify products for further investigation. Cart quantities alone do not establish actual sales velocity or inventory turnover.

### 5. Discount Analysis

Calculates discount amounts and discount percentages by product category.

The analysis distinguishes categories with large absolute discounts from categories with high discount percentages.

### 6. Category Contribution

Uses a Common Table Expression (CTE) to calculate category-level cart values and each category's percentage contribution to the total.

### 7. Customer Spending Segmentation

Uses a `CASE` expression to classify customers into spending categories based on their total cart values.

The configured thresholds are illustrative and should be validated against an appropriate business context before being used for real customer segmentation.

## Key Findings

The following findings are based on query results obtained from the project's MySQL database.

### 1. Category Contribution to Cart Value

The category contribution query produced the following results for the three highest-contributing categories.

| Category                  |       Cart Value | Contribution |
| ------------------------- | ---------------: | -----------: |
| Vehicles                  |     1,875,999.40 |       48.93% |
| Motorcycles               |       669,999.16 |       17.47% |
| Men's watches             |       644,849.28 |       16.82% |
| **Combined contribution** | **3,190,847.84** |   **83.22%** |

These three categories account for 83.22% of the observed cart value.

Vehicles contribute the largest share, at 48.93%.

The results indicate a concentration of cart value in a small number of categories within this dataset.

### 2. Customer Spending Segmentation

Customers were classified using the following illustrative thresholds:

* **High Value:** Total cart value greater than or equal to 1,000.
* **Medium Value:** Total cart value from 500 to below 1,000.
* **Low Value:** Total cart value below 500.

The resulting distribution is:

| Customer Segment | Customers | Percentage |
| ---------------- | --------: | ---------: |
| High Value       |       135 |     64.90% |
| Medium Value     |        16 |      7.69% |
| Low Value        |        57 |     27.40% |
| **Total**        |   **208** |   **100%** |

Approximately 64.90% of customers fall into the high-value segment under these rules.

The distribution also shows that the configured thresholds create uneven group sizes.

These thresholds are illustrative, not validated business rules. The results should be interpreted accordingly.

### 3. Discount Analysis by Category

The discount analysis identified differences in discount percentages and absolute discount amounts.

| Category        | Original Value | Discount Amount | Discount Percentage |
| --------------- | -------------: | --------------: | ------------------: |
| Women's dresses |       4,859.51 |          795.38 |              16.37% |
| Skin care       |         506.54 |           76.30 |              15.06% |
| Tops            |       2,589.23 |          355.99 |              13.75% |
| Women's bags    |       6,749.38 |          899.47 |              13.33% |
| Furniture       |      88,399.27 |       10,724.30 |              12.13% |
| Women's watches |     282,859.55 |       33,670.04 |              11.90% |
| Smartphones     |      82,348.23 |        9,217.28 |              11.19% |
| Vehicles        |   1,875,999.40 |      193,935.35 |              10.34% |
| Motorcycles     |     669,999.16 |       60,538.55 |               9.04% |
| Men's watches   |     644,849.28 |       51,785.42 |               8.03% |
| Laptops         |      91,899.44 |        6,893.20 |               7.50% |
| Men's shoes     |       8,589.25 |          310.35 |               3.61% |

*Values are expressed in the dataset's monetary units.*

Key observations:

* Women's dresses have the highest discount percentage among the listed categories, at 16.37%.
* Men's shoes have the lowest discount percentage, at 3.61%.
* Vehicles have the largest absolute discount amount, at 193,935.35.
* Vehicles have a lower discount percentage than women's dresses but a much larger absolute discount amount.

These findings demonstrate why both absolute values and percentages are useful when comparing categories.

## Recommendations

The following recommendations illustrate how the analysis could inform business investigations in a real retail environment.

### 1. Investigate High-Contribution Categories

Vehicles, motorcycles, and men's watches account for 83.22% of observed cart value in this dataset.

A retailer could investigate these categories further when reviewing product availability, pricing, and merchandising priorities.

### 2. Validate Customer Segmentation Thresholds

The current spending thresholds classify 135 of 208 customers as high value.

Before applying these categories to real customer retention or marketing strategies, a business should validate the thresholds against its actual customer spending distribution and objectives.

### 3. Review Discount Policies

Women's dresses have a higher discount percentage than vehicles, while vehicles have a much larger absolute discount amount.

A retailer could investigate discount policies alongside sales volume, product costs, and profit margins before changing prices or promotions.

These are potential applications of the analytical methods, not verified recommendations for an actual retailer.

## Data Quality Checks

The `sql/inspect.sql` script contains checks for:

* Row counts in raw tables
* Sample records
* Duplicate user and product IDs
* Missing values in important columns
* Invalid product prices, ratings, and stock values
* Invalid cart totals and cart-item quantities
* Relationships between carts and customers
* Relationships between cart items and products

These checks help identify potential data quality issues before analysis.

The results must be reviewed after executing the queries. The existence of inspection queries does not establish that all records are valid or complete.

## SQL Concepts Demonstrated

The project demonstrates practical use of:

* `SELECT` and `WHERE`
* Aggregate functions such as `COUNT()`, `SUM()`, and `AVG()`
* `GROUP BY` and `HAVING`
* `ORDER BY` and `LIMIT`
* `INNER JOIN` and `LEFT JOIN`
* Common Table Expressions (CTEs)
* `CASE` expressions
* Window functions such as `RANK()`
* Null handling with `COALESCE()` and `NULLIF()`
* Percentage calculations
* Data quality checks

## Setup and Execution

### Prerequisites

Install or configure:

* Python
* MySQL Server
* A MySQL client such as MySQL Workbench
* Git

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd Ecommerce_SQL_Analytics
```

Replace `<your-repository-url>` with your actual GitHub repository URL.

### 2. Configure MySQL

Create the `ecommerce_analytics` database and execute the schema script included in the repository.

Use the table names, column names, and database configuration defined by the project.

### 3. Configure Python dependencies

If the repository contains a `requirements.txt` file, install its dependencies with:

```bash
pip install -r requirements.txt
```

Configure the database connection using your local environment settings.

Do not commit database passwords, API credentials, or other secrets.

### 4. Run the ETL scripts

Execute the existing Python extraction and loading scripts in the order required by the project.

Confirm that the expected tables contain data before proceeding.

### 5. Inspect the data

Run the SQL inspection script in your MySQL client.

Review the row counts, missing-value checks, duplicate checks, value validations, and relationship checks.

### 6. Run the analytics

Execute `sql/analytics.sql` against the `ecommerce_analytics` database.

Review the output of each query to investigate customer, product, cart, category, inventory, and discount patterns.

**Compatibility:** The analytics script uses MySQL 8.0-compatible window functions. Use the database schema and column names defined in the project.

## Limitations

* The dataset contains synthetic sample data and may not represent real purchasing behavior.
* Cart values are not necessarily equivalent to completed sales or recognized revenue.
* Carted quantities do not establish actual product demand or inventory turnover.
* Discount amounts do not establish profitability because verified product costs are unavailable.
* Customer segmentation depends on illustrative thresholds that have not been validated against real business requirements.
* Findings describe the supplied dataset and should not be generalized to actual retailers or customers.

## Future Improvements

Potential future enhancements include:

* Additional data quality validation
* Further customer and product analysis
* Automated checks for ETL outputs
* A data dictionary documenting table definitions and column meanings
* Visual reporting using Power BI or Excel

These are possible extensions, not claims about currently implemented features.

## Author

**Lavankumar Chiluka**

Computer Science and Engineering | Aspiring Data Analyst

Areas of interest: SQL, Python, MySQL, data analytics, and business intelligence.
