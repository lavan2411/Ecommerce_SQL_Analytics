# E-Commerce SQL Analytics

An end-to-end SQL analytics project that extracts e-commerce data from an API, loads it into MySQL, performs data inspection and cleaning, and generates business insights using SQL.

## Project Objective

The objective of this project is to analyze customer, product, cart, pricing, discount, and inventory data using SQL.

The project demonstrates a practical data workflow:

**API → MySQL → Data Inspection → Data Cleaning → Curated Views → SQL Analytics**

## Tech Stack

- **Python** — API extraction and data loading
- **Requests** — API communication
- **Pandas** — Data handling
- **MySQL** — Data storage and SQL analytics
- **SQL** — Data cleaning, transformation, validation, and analysis
- **Git / GitHub** — Version control
- **VS Code** — Development environment

## Architecture

```text
DummyJSON API
      ↓
Python Extraction
      ↓
MySQL Raw Tables
      ↓
Data Inspection & Profiling
      ↓
Cleaning & Preprocessing
      ↓
Curated SQL Views
      ↓
SQL Analytics
      ↓
Business Insights
```

## Data Pipeline

### 1. Extract

Python retrieves data from the DummyJSON API using HTTP requests.

The extraction process retrieves:

- User data
- Product data
- Cart data
- Cart item data

### 2. Load

The extracted data is loaded into MySQL.

The raw layer contains:

```text
raw_api_data
raw_users
raw_products
raw_carts
raw_cart_items
```

`raw_api_data` preserves the original API responses, while the other raw tables store the source data in tabular form.

### 3. Inspect

The raw data is profiled to identify potential data-quality issues.

The inspection process checks:

- Row counts
- Missing values
- Duplicate records
- Invalid numerical values
- Referential integrity
- Basic data-quality issues

### 4. Clean

The cleaning layer prepares the data for analysis.

The process includes:

- Trimming text fields
- Handling empty values
- Standardizing text values
- Validating numerical fields
- Validating ratings
- Validating stock values
- Validating quantities
- Converting timestamps
- Removing unnecessary fields from the curated layer

### 5. Curated Views

The cleaned data is exposed through SQL views:

```text
vw_customers
vw_products
vw_carts
vw_cart_items
```

The views provide the cleaned analytical layer without duplicating the underlying raw data.

### 6. SQL Analytics

The curated views are used as the analytical layer for SQL-based business analysis.

The analytics process includes:

- Customer analysis
- Product analysis
- Cart analysis
- Discount analysis
- Inventory analysis
- Ranking and window-function analysis

## Data Model

The curated views are connected using the following relationships:

```text
vw_customers
     |
     | customer_id
     ↓
vw_carts
     |
     | cart_id
     ↓
vw_cart_items
     |
     | product_id
     ↓
vw_products
```

### Relationships

```text
vw_customers.customer_id
        ↓
vw_carts.customer_id

vw_carts.cart_id
        ↓
vw_cart_items.cart_id

vw_products.product_id
        ↓
vw_cart_items.product_id
```

## SQL Analytics

The analytics layer is designed to answer practical business questions.

### Customer Analysis

- How many customers are available?
- How are customers distributed by gender?
- How are customers distributed by age?
- Which customers have the highest total cart value?
- Which customers have the highest number of carts?
- What is the average cart value per customer?
- How are customers ranked by total cart value?

### Product Analysis

- How many products exist in each category?
- Which products have the highest ratings?
- Which products have the highest stock?
- Which products have the highest carted quantity?
- Which products generate the highest cart value?
- Which products have high stock but relatively low carted quantity?
- How are products ranked by carted quantity?

### Cart & Discount Analysis

- What is the total cart value?
- What is the total discounted cart value?
- What is the total discount amount?
- What is the average cart value?
- How does discount impact different product categories?

## Advanced SQL Concepts Demonstrated

This project demonstrates practical SQL concepts including:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `HAVING`
- `JOIN`
- `LEFT JOIN`
- Aggregate functions
- `COUNT()`
- `SUM()`
- `AVG()`
- `COALESCE()`
- `CASE`
- `ROUND()`
- `RANK()`
- Window functions
- `PARTITION BY`
- Percentage calculations
- Data validation
- SQL views

## Key Business Analyses

### Customer Ranking

Customers are ranked based on their total cart value using SQL window functions.

### Product Ranking

Products are ranked based on their total quantity added to carts.

### Inventory Analysis

Products with relatively high stock and low carted quantity are identified to highlight potential inventory concerns.

### Discount Analysis

The difference between original and discounted values is analyzed by product category to understand discount impact.

## Data Cleaning

The curated SQL views apply preprocessing such as:

- Trimming text fields
- Converting empty strings to `NULL`
- Standardizing gender values
- Standardizing category values
- Validating prices
- Validating ratings
- Validating stock
- Validating quantities
- Converting product timestamps
- Selecting only relevant analytical fields

Sensitive or unnecessary source fields are excluded from the curated analytical layer.

## Data Dictionary

A detailed description of the curated views and their columns is available in:

```text
docs/data_dictionary.md
```

The data dictionary documents:

- `vw_customers`
- `vw_products`
- `vw_carts`
- `vw_cart_items`

## Important Data Limitation

The API provides cart data but does not provide a reliable historical order or transaction date.

Therefore, this project does not perform:

- Monthly sales analysis
- Daily sales trends
- Month-over-month growth
- Year-over-year growth
- Time-based sales forecasting

Cart values are treated as cart-level values, not confirmed completed sales or orders.

## Data Security

Database credentials are stored in environment variables rather than directly in the Python source code.

The `.env` file is excluded from version control using `.gitignore`.

Sensitive source fields are not used in the curated analytical layer.

Actual credentials and sensitive raw data should never be committed to GitHub.

## Project Structure

```text
Ecommerce_SQL_Analytics/
│
├── src/
│   ├── api_client.py
│   └── load_to_mysql.py
│
├── sql/
│   ├── schema.sql
│   ├── inspect.sql
│   ├── cleaning.sql
│   └── analytics.sql
│
├── docs/
│   └── data_dictionary.md
│
├── tests/
│   └── test_pipeline.py
│
├── powerbi/
│   └── ecommerce_analytics.pbix
│
├── .env
├── .gitignore
└── README.md
```

## How to Run the Project

### 1. Clone the Repository

```bash
git clone <your-github-repository-url>
```

### 2. Navigate to the Project

```bash
cd Ecommerce_SQL_Analytics
```

### 3. Create a Virtual Environment

```bash
python -m venv .venv
```

### 4. Activate the Virtual Environment

For Windows PowerShell:

```powershell
.venv\Scripts\Activate.ps1
```

### 5. Install Dependencies

```bash
pip install requests pandas mysql-connector-python python-dotenv
```

### 6. Configure Environment Variables

Create a `.env` file in the project root:

```env
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=YOUR_PASSWORD
MYSQL_DATABASE=ecommerce_analytics
```

Do not commit the `.env` file to GitHub.

### 7. Create the Database and Raw Tables

Run:

```text
sql/schema.sql
```

in MySQL.

### 8. Load API Data

Run:

```bash
python src/load_to_mysql.py
```

### 9. Inspect the Data

Run the queries in:

```text
sql/inspect.sql
```

### 10. Create the Curated Views

Run:

```text
sql/cleaning.sql
```

### 11. Run the SQL Analytics

Run:

```text
sql/analytics.sql
```

## Project Workflow

```text
API
 ↓
Extract
 ↓
Raw Data
 ↓
Inspect
 ↓
Clean & Validate
 ↓
Curated Views
 ↓
SQL Analytics
 ↓
Business Insights
```

## Future Improvements

Possible future improvements include:

- Automated scheduled data ingestion
- Incremental data loading
- Additional data-quality tests
- More advanced customer segmentation
- Automated reporting
- Additional analytical models

## Author

**Lavankumar Chiluka**

B.Tech – Computer Science and Engineering

**Interests:** Data Analytics, SQL, Python, Power BI, and Business Intelligence