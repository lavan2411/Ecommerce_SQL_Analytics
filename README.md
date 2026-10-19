# E-Commerce SQL Analytics

[![E-commerce SQL Analytics CI](https://github.com/Lavan2411/Ecommerce_SQL_Analytics/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/Lavan2411/Ecommerce_SQL_Analytics/actions/workflows/ci.yml)

An end-to-end analytics project that extracts e-commerce data from the DummyJSON REST API, loads it into MySQL, inspects and cleans the data, and answers business questions using SQL.

> **Data note:** The source contains customer, product, and cart data—not verified completed transactions. Cart values and quantities are analyzed as cart metrics, not confirmed sales or revenue.

## Project Objectives

* Inspect data quality and validate source records.
* Clean and standardize customer, product, cart, and cart-item data.
* Build reusable analytical SQL views.
* Analyze customer distribution, product categories, carted quantities, cart values, discounts, and inventory snapshots.
* Validate SQL transformations with automated tests in GitHub Actions.

## Tech Stack

| Technology        | Purpose                                                                       |
| ----------------- | ----------------------------------------------------------------------------- |
| Python            | API extraction and data loading                                               |
| Requests          | HTTP requests to the REST API                                                 |
| MySQL             | Data storage and SQL analysis                                                 |
| SQL               | Inspection, transformation, aggregation, joins, ranking, and window functions |
| SQL views         | Reusable cleaned analytical layer                                             |
| Python `unittest` | Automated SQL-view tests                                                      |
| Git and GitHub    | Version control and source-code hosting                                       |
| GitHub Actions    | Continuous integration                                                        |

## Project Architecture

```text
DummyJSON REST API
        |
        v
Python extraction and loading
        |
        v
MySQL raw tables
        |
        v
Data inspection and profiling
        |
        v
SQL cleaning and transformation
        |
        v
Curated SQL views
        |
        v
SQL analytics and business findings
        |
        v
GitHub Actions validation
```

## Data Pipeline

### 1. Extract and Load

Python retrieves data from these DummyJSON endpoints:

* Users: `https://dummyjson.com/users?limit=0`
* Products: `https://dummyjson.com/products?limit=0`
* Carts: `https://dummyjson.com/carts?limit=0`

The extracted data is loaded into the `ecommerce_analytics` MySQL database.

| Raw Table        | Purpose                                  |
| ---------------- | ---------------------------------------- |
| `raw_api_data`   | Preserves original API response payloads |
| `raw_users`      | Customer source data                     |
| `raw_products`   | Product source data                      |
| `raw_carts`      | Cart-level source data                   |
| `raw_cart_items` | Individual cart-item records             |

### 2. Inspect and Transform

`sql/inspect.sql` supports data profiling, including row counts, missing values, duplicate identifiers, invalid numerical values, and relationship checks.

`sql/transformation.sql` creates cleaned views. Transformations include trimming text, standardizing selected values, converting empty strings to `NULL`, validating prices, ratings, stock, discounts and quantities, and converting product timestamps.

### 3. Curated Views

| View            | Purpose                       |
| --------------- | ----------------------------- |
| `vw_customers`  | Customer-level analysis       |
| `vw_products`   | Product and category analysis |
| `vw_carts`      | Cart-level analysis           |
| `vw_cart_items` | Product-level cart analysis   |

The views provide a consistent analytical layer while keeping the raw tables available separately.

## SQL Analytics

The queries in `sql/analytics.sql` cover:

* Overall customer, product, and cart counts.
* Total carted quantity and aggregate cart values.
* Customer distribution by gender and age.
* Product counts, ratings, stock, and carted quantities.
* Aggregate cart-item values and discount differences.
* Customer-associated cart values and product rankings.

SQL techniques demonstrated include `SELECT`, filtering, `GROUP BY`, `HAVING`, `ORDER BY`, joins, aggregate functions, `CASE`, `COALESCE`, SQL views, data validation, ranking, and window functions.

## Key Findings

The figures below are from the existing query results for the available dataset.

### 1. Dataset Overview

| Metric                              |       Result |
| ----------------------------------- | -----------: |
| Customers                           |          208 |
| Products                            |          194 |
| Carts                               |          208 |
| Total quantity represented in carts |        2,417 |
| Total cart value                    | 3,834,278.63 |
| Total discounted cart value         | 3,456,709.58 |
| Difference between cart totals      |   377,569.05 |

The difference between the original and discounted aggregate cart values is approximately **9.85%** of the original aggregate cart value.

### 2. Customer Distribution

| Gender | Customers |  Share |
| ------ | --------: | -----: |
| Female |       106 | 50.96% |
| Male   |       102 | 49.04% |

The available customer dataset is relatively balanced by gender.

### 3. Product Category Analysis

| Category            | Product Count | Average Price | Average Rating |
| ------------------- | ------------: | ------------: | -------------: |
| Kitchen Accessories |            30 |         17.69 |           3.82 |
| Groceries           |            27 |          5.47 |           3.91 |
| Sports Accessories  |            17 |         24.11 |           4.01 |
| Smartphones         |            16 |        424.99 |           3.70 |
| Mobile Accessories  |            14 |        146.99 |           3.85 |

Kitchen Accessories has the largest product count in the listed categories, followed by Groceries. These counts describe catalogue composition, not sales performance.

### 4. Products with the Highest Carted Quantities

| Product                           | Quantity |
| --------------------------------- | -------: |
| Cat Food                          |       37 |
| Samsung Galaxy S10                |       31 |
| Generic Motorcycle                |       28 |
| Apple Airpods                     |       27 |
| Plant Pot                         |       27 |
| Gray Dress                        |       26 |
| Vaseline Men Body and Face Lotion |       25 |
| Tartan Dress                      |       25 |
| Ice Cream                         |       25 |
| Decoration Swing                  |       24 |

Cat Food has the highest carted quantity in the listed results.

### 5. Products with the Highest Aggregate Cart-Item Values

| Product                | Aggregate Cart-Item Value |
| ---------------------- | ------------------------: |
| Durango SXT RWD        |                702,999.81 |
| Dodge Hornet GT Plus   |                424,999.83 |
| MotoGP CI.H1           |                329,999.78 |
| 300 Touring            |                260,999.91 |
| Pacifica Touring       |                255,999.92 |
| Rolex Submariner Watch |                237,999.83 |
| Charger SXT RWD        |                230,999.93 |
| Rolex Datejust         |                153,999.86 |
| Rolex Datejust Women   |                153,999.86 |
| Sportbike Motorcycle   |                149,999.80 |

Durango SXT RWD has the highest aggregate cart-item value in the listed results. Quantity-based and value-based rankings highlight different aspects of the catalogue.

### 6. Product Rating Analysis

The existing rating query returns products with ratings close to 5. Amazon Echo Plus is listed at 4.99, followed by Huawei Matebook X Pro at 4.98.

These ratings provide a product-level snapshot and should be considered alongside other available product information.

### 7. Discount Analysis

| Metric                                       |       Amount |
| -------------------------------------------- | -----------: |
| Original Cart Value                          | 3,834,278.63 |
| Discounted Cart Value                        | 3,456,709.58 |
| Difference                                   |   377,569.05 |
| Difference as a Percentage of Original Value |        9.85% |

The difference is calculated as:

`Total Cart Value - Total Discounted Cart Value`

The percentage is calculated as:

`(Total Discount / Total Cart Value) * 100`

The difference between original and discounted aggregate cart values is 377,569.05, approximately 9.85% of the original aggregate cart value.

### 8. Inventory Snapshot

| Product                       | Category           | Stock |
| ----------------------------- | ------------------ | ----: |
| Longines Master Collection    | Men's Watches      |   100 |
| Baseball Ball                 | Sports Accessories |   100 |
| Essence Mascara Lash Princess | Beauty             |    99 |
| Heshe Women's Leather Bag     | Women's Bags       |    99 |
| Mulberry                      | Groceries          |    99 |
| Kiwi                          | Groceries          |    99 |
| Dior J'adore                  | Fragrances         |    98 |
| Cricket Bat                   | Sports Accessories |    98 |
| Chicken Meat                  | Groceries          |    97 |
| Football                      | Sports Accessories |    96 |

Longines Master Collection and Baseball Ball have the highest stock values in the listed results, at 100 units each.

## Business Recommendations

* **Review discount depth on women's dresses (16.4%) against product margins** before deciding whether to maintain or adjust discount levels.
* Compare high carted quantities with stock availability to identify products that may warrant an inventory review.
* Review products with high aggregate cart-item values separately from products with high quantities; they represent different prioritization signals.
* Review product ratings alongside other available product information rather than treating ratings alone as a performance measure.

These recommendations identify follow-up analyses; they do not establish confirmed sales or profitability.

## Data Model

The curated views are connected through customer, cart, and product identifiers.

```text
vw_customers
     |
     | customer_id
     v
vw_carts
     |
     | cart_id
     v
vw_cart_items <---- product_id ---- vw_products
```

Relationships:

* `vw_customers.customer_id` → `vw_carts.customer_id`
* `vw_carts.cart_id` → `vw_cart_items.cart_id`
* `vw_products.product_id` → `vw_cart_items.product_id`

These relationships support customer-level, cart-level, and product-level analysis.

## Data Dictionary

### 1. `vw_customers`

| Column        | Description                         |
| ------------- | ----------------------------------- |
| `customer_id` | Unique customer identifier          |
| `first_name`  | Customer's first name               |
| `last_name`   | Customer's last name                |
| `age`         | Customer age after basic validation |
| `gender`      | Standardized gender value           |

### 2. `vw_products`

| Column                   | Description                   |
| ------------------------ | ----------------------------- |
| `product_id`             | Unique product identifier     |
| `product_name`           | Product title                 |
| `category`               | Standardized product category |
| `price`                  | Product price                 |
| `discount_percentage`    | Product discount percentage   |
| `rating`                 | Product rating                |
| `stock`                  | Available stock quantity      |
| `brand`                  | Product brand                 |
| `sku`                    | Product SKU                   |
| `availability_status`    | Product availability status   |
| `minimum_order_quantity` | Minimum order quantity        |
| `created_at`             | Product creation timestamp    |

### 3. `vw_carts`

| Column             | Description                                         |
| ------------------ | --------------------------------------------------- |
| `cart_id`          | Unique cart identifier                              |
| `customer_id`      | Customer associated with the cart                   |
| `total`            | Original cart value                                 |
| `discounted_total` | Cart value after discounts                          |
| `total_products`   | Number of distinct products represented in the cart |
| `total_quantity`   | Total quantity of products in the cart              |

### 4. `vw_cart_items`

| Column                | Description                             |
| --------------------- | --------------------------------------- |
| `cart_item_id`        | Unique cart item record identifier      |
| `cart_id`             | Associated cart identifier              |
| `product_id`          | Associated product identifier           |
| `price`               | Product price recorded in the cart item |
| `quantity`            | Quantity of the product in the cart     |
| `total`               | Original cart item value                |
| `discount_percentage` | Discount percentage                     |
| `discounted_total`    | Cart item value after discounts         |

## Data Cleaning and Validation

The cleaning and transformation process includes:

* Trimming text values.
* Converting empty strings to `NULL`.
* Standardizing selected text fields.
* Validating prices and discount percentages.
* Validating product ratings.
* Validating stock values.
* Validating cart quantities.
* Converting product timestamps.
* Selecting relevant analytical columns.
* Excluding unnecessary or sensitive source fields from curated views.

The raw tables are retained separately from the curated views to preserve the original source data.

## Project Structure

```text
Ecommerce_SQL_Analytics/
├── .github/
│   └── workflows/
│       └── ci.yml
├── src/
│   ├── api_client.py
│   └── load_to_mysql.py
├── sql/
│   ├── schema.sql
│   ├── inspect.sql
│   ├── transformation.sql
│   └── analytics.sql
├── tests/
│   └── test_sql_views.py
├── requirements.txt
├── .gitignore
└── README.md
```

## How to Run the Project

### Prerequisites

* Python 3.12 or a compatible Python version.
* MySQL Server.
* Git.

### Step 1: Clone the Repository

```bash
git clone https://github.com/Lavan2411/Ecommerce_SQL_Analytics.git
cd Ecommerce_SQL_Analytics
```

### Step 2: Create a Virtual Environment

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

### Step 3: Install Dependencies

```bash
pip install -r requirements.txt
```

Ensure `requirements.txt` includes the dependencies required by the Python scripts.

### Step 4: Configure MySQL

Configure the local MySQL connection details expected by `src/load_to_mysql.py`.

Do not commit real passwords or local `.env` files to GitHub.

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

### Step 10: Run Automated Tests

Ensure the database has the schema and transformation views. Configure `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`, and `MYSQL_DATABASE` for your local test database.

Run:

```bash
python -m unittest discover -s tests -p "test_*.py" -v
```

## Continuous Integration

The GitHub Actions workflow in `.github/workflows/ci.yml` runs when changes are pushed or pull requests target `master` or `main`. It can also be started manually.

The workflow validates Python syntax and required project files, checks SQL files for accidental Markdown fences, creates a temporary MySQL database, creates the schema and views, and runs the SQL-view tests.

The status badge at the top of this README displays the workflow status for the `master` branch.

## Conclusion

This project demonstrates an end-to-end analytics workflow using Python, a REST API, MySQL, SQL views, automated tests, and GitHub Actions.

It combines data-quality checks with customer, product, cart, discount, and inventory analysis, and translates query results into practical follow-up actions.

## Author

**Lavankumar Chiluka**

B.Tech — Computer Science and Engineering

**Technical Skills:** Python · SQL · MySQL · Power BI · Excel · Data Cleaning · Data Analysis · Data Visualization

**GitHub:** https://github.com/Lavan2411

**Project Repository:** https://github.com/Lavan2411/Ecommerce_SQL_Analytics
