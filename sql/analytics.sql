
USE ecommerce_analytics;


-- ============================================================
-- 1. BUSINESS OVERVIEW KPIs
-- ============================================================

-- Total customers

SELECT
    COUNT(*) AS total_customers
FROM vw_customers;


-- Total products

SELECT
    COUNT(*) AS total_products
FROM vw_products;


-- Total carts

SELECT
    COUNT(*) AS total_carts
FROM vw_carts;


-- Total quantity across all carts

SELECT
    SUM(total_quantity) AS total_quantity
FROM vw_carts;


-- Original and discounted cart values

SELECT
    ROUND(SUM(total), 2) AS total_cart_value,
    ROUND(SUM(discounted_total), 2) AS total_discounted_value
FROM vw_carts;


-- Total discount amount

SELECT
    ROUND(SUM(total - discounted_total), 2) AS total_discount
FROM vw_carts;


-- Overall discount percentage

SELECT
    ROUND(
        100.0 * SUM(total - discounted_total)
        / NULLIF(SUM(total), 0),
        2
    ) AS discount_percentage
FROM vw_carts;


-- ============================================================
-- 2. CUSTOMER ANALYSIS
-- ============================================================

-- Customer distribution by gender

SELECT
    gender,
    COUNT(*) AS customer_count
FROM vw_customers
GROUP BY gender
ORDER BY customer_count DESC;


-- Customer distribution by age

SELECT
    age,
    COUNT(*) AS customer_count
FROM vw_customers
GROUP BY age
ORDER BY age;


-- Customer distribution by age group

SELECT
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age >= 50 THEN '50+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS customer_count
FROM vw_customers
GROUP BY
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age >= 50 THEN '50+'
        ELSE 'Unknown'
    END
ORDER BY MIN(age);


-- Customers with the highest cart value

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(ca.cart_id) AS cart_count,
    ROUND(COALESCE(SUM(ca.total), 0), 2) AS total_cart_value,
    COALESCE(SUM(ca.total_quantity), 0) AS total_quantity
FROM vw_customers c
LEFT JOIN vw_carts ca
    ON c.customer_id = ca.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_cart_value DESC
LIMIT 10;


-- Customer ranking by total cart value

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(ca.total), 2) AS total_cart_value,
    RANK() OVER (
        ORDER BY SUM(ca.total) DESC
    ) AS customer_rank
FROM vw_customers c
JOIN vw_carts ca
    ON c.customer_id = ca.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY customer_rank;


-- Average cart value by customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(ca.cart_id) AS cart_count,
    ROUND(AVG(ca.total), 2) AS average_cart_value,
    ROUND(COALESCE(SUM(ca.total), 0), 2) AS total_cart_value
FROM vw_customers c
LEFT JOIN vw_carts ca
    ON c.customer_id = ca.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_cart_value DESC;


-- ============================================================
-- 3. PRODUCT AND CATEGORY ANALYSIS
-- ============================================================

-- Products by category

SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price), 2) AS average_price,
    ROUND(AVG(rating), 2) AS average_rating
FROM vw_products
GROUP BY category
ORDER BY product_count DESC;


-- Top-rated products

SELECT
    product_id,
    product_name,
    category,
    rating
FROM vw_products
WHERE rating IS NOT NULL
ORDER BY rating DESC, product_id
LIMIT 10;


-- Products with the highest stock

SELECT
    product_id,
    product_name,
    category,
    stock
FROM vw_products
ORDER BY stock DESC, product_id
LIMIT 10;


-- Most purchased products by quantity

SELECT
    p.product_id,
    p.product_name,
    SUM(ci.quantity) AS total_quantity
FROM vw_cart_items ci
JOIN vw_products p
    ON ci.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_quantity DESC
LIMIT 10;


-- Products generating the highest cart value

SELECT
    p.product_id,
    p.product_name,
    SUM(ci.total) AS total_value
FROM vw_cart_items ci
JOIN vw_products p
    ON ci.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_value DESC
LIMIT 10;


-- Product ranking by carted quantity

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(ci.quantity) AS total_quantity,
    RANK() OVER (
        ORDER BY SUM(ci.quantity) DESC
    ) AS product_rank
FROM vw_cart_items ci
JOIN vw_products p
    ON ci.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY product_rank;


-- ============================================================
-- 4. INVENTORY ANALYSIS
-- ============================================================

-- High-stock products with low carted quantity

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.stock,
    COALESCE(SUM(ci.quantity), 0) AS total_quantity
FROM vw_products p
LEFT JOIN vw_cart_items ci
    ON p.product_id = ci.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.stock
HAVING
    p.stock > 50
    AND COALESCE(SUM(ci.quantity), 0) < 10
ORDER BY p.stock DESC;


-- ============================================================
-- 5. DISCOUNT ANALYSIS
-- ============================================================

-- Discount impact by category

SELECT
    p.category,
    ROUND(SUM(ci.total), 2) AS original_value,
    ROUND(SUM(ci.discounted_total), 2) AS discounted_value,
    ROUND(
        SUM(ci.total) - SUM(ci.discounted_total),
        2
    ) AS discount_amount
FROM vw_cart_items ci
JOIN vw_products p
    ON ci.product_id = p.product_id
GROUP BY p.category
ORDER BY discount_amount DESC;


-- Discount percentage by category

SELECT
    p.category,
    ROUND(SUM(ci.total), 2) AS original_value,
    ROUND(SUM(ci.discounted_total), 2) AS discounted_value,
    ROUND(
        SUM(ci.total) - SUM(ci.discounted_total),
        2
    ) AS discount_amount,
    ROUND(
        100.0 * (
            SUM(ci.total) - SUM(ci.discounted_total)
        ) / NULLIF(SUM(ci.total), 0),
        2
    ) AS discount_percentage
FROM vw_cart_items ci
JOIN vw_products p
    ON ci.product_id = p.product_id
GROUP BY p.category
ORDER BY discount_percentage DESC;


-- ============================================================
-- 6. CATEGORY CONTRIBUTION ANALYSIS
-- ============================================================

-- Percentage contribution of each category to total cart value

WITH category_sales AS (
    SELECT
        p.category,
        SUM(ci.total) AS category_cart_value
    FROM vw_cart_items ci
    JOIN vw_products p
        ON ci.product_id = p.product_id
    GROUP BY p.category
)
SELECT
    category,
    ROUND(category_cart_value, 2) AS category_cart_value,
    ROUND(
        100.0 * category_cart_value
        / NULLIF(
            (SELECT SUM(category_cart_value)
             FROM category_sales),
            0
        ),
        2
    ) AS percentage_of_total
FROM category_sales
ORDER BY category_cart_value DESC;


-- ============================================================
-- 7. CUSTOMER SPENDING SEGMENTATION
-- ============================================================

-- Group customers into spending categories

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COALESCE(SUM(ca.total), 0) AS total_cart_value
    FROM vw_customers c
    LEFT JOIN vw_carts ca
        ON c.customer_id = ca.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)
SELECT
    customer_id,
    first_name,
    last_name,
    ROUND(total_cart_value, 2) AS total_cart_value,
    CASE
        WHEN total_cart_value >= 1000 THEN 'High Value'
        WHEN total_cart_value >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_spending
ORDER BY total_cart_value DESC;


-- ============================================================
-- END OF E-COMMERCE SQL ANALYTICS
-- ============================================================

