# E-Commerce SQL Analytics

An end-to-end data analytics project that extracts e-commerce data from a REST API, loads it into MySQL, performs data inspection and cleaning, and generates business insights using SQL.

The project demonstrates a practical data analytics workflow, from API extraction to business analysis, using Python and MySQL.

---

## Project Objective

The objective of this project is to analyze customer, product, cart, discount, and inventory data to identify useful patterns and generate business insights using SQL.

The project focuses on:

- Customer distribution and customer-level cart analysis
- Product category and rating analysis
- Product quantity and cart value analysis
- Cart discount analysis
- Product stock analysis
- Data quality inspection and validation

> **Data limitation:** The dataset contains cart records, not verified completed transactions. Cart values and quantities should not be interpreted as confirmed sales or revenue.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Python | API extraction and data loading |
| Requests | HTTP requests to the REST API |
| MySQL | Raw data storage and SQL analytics |
| SQL | Data inspection, cleaning, transformation, and analysis |
| SQL Views | Cleaned analytical layer |
| Git | Version control |
| GitHub | Source code management and portfolio presentation |
| VS Code | Development environment |

---

## Project Architecture

```text
                  DummyJSON REST API
                          |
                          v
                  Python Extraction
                          |
                          v
                    MySQL Database
                          |
                          v
                    Raw Data Tables
                          |
                          v
                Data Inspection & Profiling
                          |
                          v
                 Cleaning & Transformation
                          |
                          v
                    Curated SQL Views
                          |
                          v
                     SQL Analytics
                          |
                          v
                  Business Insights
```

---

## Complete Data Pipeline

### 1. Extract

Python retrieves data from the DummyJSON API using HTTP requests.

The pipeline extracts:

- Customer data
- Product data
- Cart data
- Cart item data

API endpoints:

- Users: `https://dummyjson.com/users?limit=0`
- Products: `https://dummyjson.com/products?limit=0`
- Carts: `https://dummyjson.com/carts?limit=0`

The extraction process uses HTTP status validation and request timeouts to handle API errors.

### 2. Load

The extracted data is loaded into the MySQL database `ecommerce_analytics`.

The raw layer contains five tables:

| Table | Purpose |
|---|---|
| `raw_api_data` | Preserves original API response payloads |
| `raw_users` | Stores customer source data in tabular form |
| `raw_products` | Stores product source data in tabular form |
| `raw_carts` | Stores cart-level source data |
| `raw_cart_items` | Stores individual cart item records |

The original JSON payloads are retained separately from the tabular raw data.

### 3. Inspect and Profile

The raw data is inspected before analytical transformations are applied.

The inspection process includes:

- Row count verification
- Missing-value checks
- Duplicate identifier checks
- Invalid numerical value checks
- Product rating validation
- Stock and quantity validation
- Referential integrity checks between related entities

These checks help identify potential data quality issues before analysis.

### 4. Clean and Transform

The transformation layer prepares data for analytical queries.

The cleaning logic includes:

- Trimming text fields
- Converting empty strings to `NULL`
- Standardizing selected text values
- Validating prices
- Validating product ratings
- Validating stock values
- Validating cart quantities
- Validating discount values
- Converting product timestamps
- Selecting relevant analytical columns
- Excluding unnecessary or sensitive source fields from curated views

The raw tables remain separate from the curated analytical layer.

### 5. Create Curated Views

The cleaned data is exposed through SQL views.

| View | Purpose |
|---|---|
| `vw_customers` | Customer-level analysis |
| `vw_products` | Product and category analysis |
| `vw_carts` | Cart-level analysis |
| `vw_cart_items` | Product-level cart analysis |

The views provide a consistent analytical layer without creating duplicate copies of the underlying raw data.

Because these are views, their results reflect changes in the underlying raw tables.

### 6. Perform SQL Analytics

The analytics layer uses SQL queries to answer business questions involving customers, products, cart values, discounts, and inventory.

The analysis includes aggregate calculations, joins, grouping, sorting, ranking, and window functions.

### 7. Document Business Insights

The findings are documented in this README using the actual SQL query results.

The analysis highlights customer distribution, product catalogue composition, carted quantities, aggregate cart item values, and discount differences.

---

## Data Model

The curated views are related through customer, cart, and product identifiers.

```text
vw_customers
     |
     | customer_id
     |
     v
vw_carts
     |
     | cart_id
     |
     v
vw_cart_items
     ^
     |
     | product_id
     |
vw_products
```

### Relationships

- `vw_customers.customer_id` → `vw_carts.customer_id`
- `vw_carts.cart_id` → `vw_cart_items.cart_id`
- `vw_products.product_id` → `vw_cart_items.product_id`

These relationships support customer-level, cart-level, and product-level analysis.

---

## SQL Analytics

### 1. Overall Dataset Metrics

The project calculates:

- Total customers
- Total products
- Total carts
- Total quantity in carts
- Total cart value
- Total discounted cart value
- Total discount amount

### 2. Customer Analysis

The analysis answers questions such as:

- How many customers are available?
- How are customers distributed by gender?
- How are customers distributed by age?
- Which customers have the highest customer-associated cart values?
- How can customers be ranked by cart value?

### 3. Product Analysis

The analysis answers questions such as:

- How many products exist in each category?
- Which products have the highest ratings?
- Which products have the highest stock?
- Which products have the highest carted quantities?
- Which products have the highest aggregate cart item values?

### 4. Cart and Discount Analysis

The analysis calculates:

- Original aggregate cart value
- Aggregate discounted cart value
- Difference between original and discounted values
- Total quantity represented in carts
- Customer-associated cart values

### 5. Inventory Analysis

Product stock levels are examined to understand the available inventory snapshot.

Comparing stock with carted quantity can help identify products for further investigation, although it does not establish actual sales demand or inventory turnover.

---

## Key Business Findings

The following findings are based on the SQL query results generated from the available dataset.

### 1. Dataset Overview

| Metric | Result |
|---|---:|
| Total Customers | 208 |
| Total Products | 194 |
| Total Carts | 208 |
| Total Quantity in Carts | 2,417 |
| Total Cart Value | 3,834,278.63 |
| Total Discounted Cart Value | 3,456,709.58 |
| Total Discount Amount | 377,569.05 |

**Finding:** The dataset contains 208 customers, 194 products, and 208 carts, with 2,417 units represented in the cart records.

### 2. Customer Distribution

| Gender | Customer Count | Approximate Share |
|---|---:|---:|
| Female | 106 | 50.96% |
| Male | 102 | 49.04% |

**Finding:** The customer gender distribution is relatively balanced. Female customers represent approximately 50.96% of the dataset, while male customers represent approximately 49.04%.

This describes the composition of the available customer data, not differences in purchasing behavior.

### 3. Product Category Analysis

| Category | Product Count | Average Price | Average Rating |
|---|---:|---:|---:|
| Kitchen Accessories | 30 | 17.69 | 3.82 |
| Groceries | 27 | 5.47 | 3.91 |
| Sports Accessories | 17 | 24.11 | 4.01 |
| Smartphones | 16 | 424.99 | 3.70 |
| Mobile Accessories | 14 | 146.99 | 3.85 |

*Prices and ratings are rounded to two decimal places.*

**Finding:** Kitchen accessories has the largest product count, with 30 products, followed by groceries with 27 products.

These results describe product catalogue composition rather than category-level sales performance.

### 4. Top Products by Carted Quantity

| Product | Total Quantity |
|---|---:|
| Cat Food | 37 |
| Samsung Galaxy S10 | 31 |
| Generic Motorcycle | 28 |
| Apple Airpods | 27 |
| Plant Pot | 27 |
| Gray Dress | 26 |
| Vaseline Men Body and Face Lotion | 25 |
| Tartan Dress | 25 |
| Ice Cream | 25 |
| Decoration Swing | 24 |

**Finding:** Cat Food has the highest carted quantity in the reported results, at 37 units, followed by Samsung Galaxy S10 with 31 units.

Carted quantity does not necessarily represent completed purchases.

### 5. Top Products by Aggregate Cart Item Value

| Product | Aggregate Cart Item Value |
|---|---:|
| Durango SXT RWD | 702,999.81 |
| Dodge Hornet GT Plus | 424,999.83 |
| MotoGP CI.H1 | 329,999.78 |
| 300 Touring | 260,999.91 |
| Pacifica Touring | 255,999.92 |
| Rolex Submariner Watch | 237,999.83 |
| Charger SXT RWD | 230,999.93 |
| Rolex Datejust | 153,999.86 |
| Rolex Datejust Women | 153,999.86 |
| Sportbike Motorcycle | 149,999.80 |

**Finding:** Durango SXT RWD has the highest aggregate cart item value in the reported results, at 702,999.81.

The product with the highest carted quantity is not the product with the highest aggregate cart item value. This demonstrates the difference between quantity-based and value-based analysis.

These figures represent aggregate cart item values, not verified sales revenue.

### 6. Product Rating Analysis

The ten highest-rated products in the query results have ratings ranging from 4.91 to 4.99.

The highest-rated product returned is Amazon Echo Plus, with a rating of 4.99, followed by Huawei Matebook X Pro, with a rating of 4.98.

**Finding:** Several products have ratings close to the maximum rating of 5. However, product ratings alone do not establish sales performance or customer satisfaction across the entire customer base.

### 7. Discount Analysis

| Metric | Amount |
|---|---:|
| Original Cart Value | 3,834,278.63 |
| Discounted Cart Value | 3,456,709.58 |
| Difference | 377,569.05 |
| Difference as a Percentage of Original Value | 9.85% |

The difference is calculated as:

`Total Cart Value - Total Discounted Cart Value`

The percentage is calculated as:

`(Total Discount / Total Cart Value) * 100`

**Finding:** The difference between original and discounted aggregate cart values is 377,569.05, approximately 9.85% of the original aggregate cart value.

This reflects the difference in the available cart values. It should not be interpreted as an accounting measure of realized discounts or discount effectiveness on completed sales.

### 8. Inventory Snapshot

| Product | Category | Stock |
|---|---|---:|
| Longines Master Collection | Men's Watches | 100 |
| Baseball Ball | Sports Accessories | 100 |
| Essence Mascara Lash Princess | Beauty | 99 |
| Heshe Women's Leather Bag | Women's Bags | 99 |
| Mulberry | Groceries | 99 |
| Kiwi | Groceries | 99 |
| Dior J'adore | Fragrances | 98 |
| Cricket Bat | Sports Accessories | 98 |
| Chicken Meat | Groceries | 97 |
| Football | Sports Accessories | 96 |

**Finding:** Longines Master Collection and Baseball Ball have the highest stock values in the reported results, at 100 each.

High stock alone does not establish excess inventory or weak demand. A complete inventory assessment would require more information about actual sales and stock movement over time.

---

## Data Dictionary

The following tables describe the curated SQL views and their analytical columns.

### 1. `vw_customers`

| Column | Description |
|---|---|
| `customer_id` | Unique customer identifier |
| `first_name` | Customer's first name |
| `last_name` | Customer's last name |
| `age` | Customer age after basic validation |
| `gender` | Standardized gender value |

### 2. `vw_products`

| Column | Description |
|---|---|
| `product_id` | Unique product identifier |
| `product_name` | Product title |
| `category` | Standardized product category |
| `price` | Product price |
| `discount_percentage` | Product discount percentage |
| `rating` | Product rating |
| `stock` | Available stock quantity |
| `brand` | Product brand |
| `sku` | Product SKU |
| `availability_status` | Product availability status |
| `minimum_order_quantity` | Minimum order quantity |
| `created_at` | Product creation timestamp |

### 3. `vw_carts`

| Column | Description |
|---|---|
| `cart_id` | Unique cart identifier |
| `customer_id` | Customer associated with the cart |
| `total` | Original cart value |
| `discounted_total` | Cart value after discounts |
| `total_products` | Number of distinct products represented in the cart |
| `total_quantity` | Total quantity of products in the cart |

### 4. `vw_cart_items`

| Column | Description |
|---|---|
| `cart_item_id` | Unique cart item record identifier |
| `cart_id` | Associated cart identifier |
| `product_id` | Associated product identifier |
| `price` | Product price recorded in the cart item |
| `quantity` | Quantity of the product in the cart |
| `total` | Original cart item value |
| `discount_percentage` | Discount percentage |
| `discounted_total` | Cart item value after discount |

---

## Data Cleaning and Validation

The cleaning and transformation process includes:

- Trimming text values
- Converting empty strings to `NULL`
- Standardizing selected text fields
- Validating prices and discount percentages
- Validating product ratings
- Validating stock values
- Validating cart quantities
- Converting product timestamps
- Selecting relevant analytical columns
- Excluding unnecessary or sensitive source fields from curated views

The raw tables are retained separately from the curated views to preserve the original source data.

---

## Advanced SQL Concepts Demonstrated

The project demonstrates practical SQL concepts, including:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `INNER JOIN`
- `LEFT JOIN`
- `COUNT()`
- `SUM()`
- `AVG()`
- `CASE`
- `COALESCE()`
- `ROUND()`
- SQL views
- Data validation
- Ranking
- Window functions
- Aggregate calculations
- Customer-level and product-level analysis

---

## Project Structure

```text
Ecommerce_SQL_Analytics/
├── src/
│   ├── api_client.py
│   └── load_to_mysql.py
├── sql/
│   ├── schema.sql
│   ├── inspect.sql
│   ├── transformation.sql
│   └── analytics.sql
├── tests/
│   └── test_pipeline.py
├── .env.example
├── .gitignore
└── README.md
```

All project documentation, including the data dictionary and business insights, is maintained in this README.

The project documentation and findings are maintained in this README. The `docs/data_dictionary.md` file may be retained for detailed reference, but it is not required to understand the main project workflow or findings.

---

## How to Run the Project

### Prerequisites

Install the following:

- Python 3.12 or a compatible Python version
- MySQL Server
- MySQL Workbench or another MySQL client
- Git

### Step 1: Clone the Repository

```bash
git clone https://github.com/Lavan2411/Ecommerce_SQL_Analytics.git
cd Ecommerce_SQL_Analytics
```

### Step 2: Create a Virtual Environment

```bash
python -m venv .venv
```

Activate it in Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### Step 3: Install Dependencies

```bash
pip install requests pandas mysql-connector-python python-dotenv
```

### Step 4: Configure Environment Variables

Create a local `.env` file in the project root.

Add your own MySQL configuration:

```env
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=YOUR_ACTUAL_PASSWORD
MYSQL_DATABASE=ecommerce_analytics
```

Replace `YOUR_ACTUAL_PASSWORD` with your local MySQL password.

**Never upload `.env` or actual database credentials to GitHub.**

### Step 5: Create the Database and Raw Tables

Execute:

```text
sql/schema.sql
```

This creates the database and required raw tables.

### Step 6: Extract and Load API Data

Run:

```bash
python src/load_to_mysql.py
```

The script retrieves data from the API and loads it into MySQL.

### Step 7: Inspect the Data

Execute:

```text
sql/inspect.sql
```

Review row counts, missing values, invalid values, and relationship checks.

### Step 8: Clean and Transform the Data

Execute:

```text
sql/transformation.sql
```

This creates the curated analytical views.

### Step 9: Run SQL Analytics

Execute:

```text
sql/analytics.sql
```

Review the resulting customer, product, cart, discount, and inventory analyses.

---

## Data Limitations

The project has several important limitations:

1. The source provides cart data, not verified completed transactions.
2. Cart values must not be treated as confirmed sales or revenue.
3. A reliable historical order or transaction date is unavailable.
4. Monthly sales trends, month-over-month growth, and year-over-year growth cannot be reliably calculated.
5. Carted quantity does not necessarily represent completed purchases.
6. Customer ranking does not establish loyalty or retention.
7. Stock levels represent the available dataset and do not establish historical inventory movement.
8. Product ratings are source attributes and do not independently measure sales performance.
9. Findings are specific to the available dataset and should not automatically be generalized to a real business.

---

## Conclusion

This project demonstrates an end-to-end data analytics workflow using Python, a REST API, MySQL, and SQL.

It covers API extraction, raw data storage, data inspection, cleaning, curated views, and business-oriented SQL analysis.

The analysis identifies customer distribution, product catalogue composition, high-carted-quantity products, products with high aggregate cart item values, and the difference between original and discounted cart values.

The project demonstrates practical SQL skills while documenting the limitations of the available source data.

---

## Author

**Lavankumar Chiluka**

B.Tech — Computer Science and Engineering

**Technical Skills:** Python · SQL · MySQL · Power BI · Excel · Data Cleaning · Data Analysis · Data Visualization

**GitHub:** [Lavan2411](https://github.com/Lavan2411)

**Project Repository:** [E-Commerce SQL Analytics](https://github.com/Lavan2411/Ecommerce_SQL_Analytics)