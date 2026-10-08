USE ecommerce_analytics;


-- =========================================================
-- 1. ROW COUNTS
-- =========================================================

SELECT 'raw_users' AS table_name, COUNT(*) AS row_count
FROM raw_users

UNION ALL

SELECT 'raw_products', COUNT(*)
FROM raw_products

UNION ALL

SELECT 'raw_carts', COUNT(*)
FROM raw_carts

UNION ALL

SELECT 'raw_cart_items', COUNT(*)
FROM raw_cart_items;


-- =========================================================
-- 2. SAMPLE DATA
-- =========================================================

SELECT *
FROM raw_users
LIMIT 10;

SELECT *
FROM raw_products
LIMIT 10;

SELECT *
FROM raw_carts
LIMIT 10;

SELECT *
FROM raw_cart_items
LIMIT 20;


-- =========================================================
-- 3. DUPLICATE CHECKS
-- =========================================================

SELECT
    id,
    COUNT(*) AS occurrences
FROM raw_users
GROUP BY id
HAVING COUNT(*) > 1;


SELECT
    id,
    COUNT(*) AS occurrences
FROM raw_products
GROUP BY id
HAVING COUNT(*) > 1;


-- =========================================================
-- 4. MISSING VALUE CHECKS
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(title IS NULL) AS missing_title,
    SUM(category IS NULL) AS missing_category,
    SUM(price IS NULL) AS missing_price,
    SUM(rating IS NULL) AS missing_rating,
    SUM(stock IS NULL) AS missing_stock
FROM raw_products;


SELECT
    COUNT(*) AS total_rows,
    SUM(firstName IS NULL) AS missing_first_name,
    SUM(lastName IS NULL) AS missing_last_name,
    SUM(email IS NULL) AS missing_email,
    SUM(age IS NULL) AS missing_age,
    SUM(gender IS NULL) AS missing_gender
FROM raw_users;


SELECT
    COUNT(*) AS total_rows,
    SUM(userId IS NULL) AS missing_user_id,
    SUM(total IS NULL) AS missing_total,
    SUM(discountedTotal IS NULL) AS missing_discounted_total,
    SUM(totalQuantity IS NULL) AS missing_quantity
FROM raw_carts;


SELECT
    COUNT(*) AS total_rows,
    SUM(cart_id IS NULL) AS missing_cart_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(price IS NULL) AS missing_price,
    SUM(total IS NULL) AS missing_total
FROM raw_cart_items;


-- =========================================================
-- 5. VALUE VALIDATION
-- =========================================================

SELECT *
FROM raw_products
WHERE price < 0;


SELECT *
FROM raw_products
WHERE rating < 0
   OR rating > 5;


SELECT *
FROM raw_products
WHERE stock < 0;


SELECT *
FROM raw_carts
WHERE total < 0
   OR discountedTotal < 0;


SELECT *
FROM raw_cart_items
WHERE quantity <= 0;


-- =========================================================
-- 6. RELATIONSHIP CHECKS
-- =========================================================

SELECT DISTINCT
    c.userId
FROM raw_carts c
LEFT JOIN raw_users u
    ON c.userId = u.id
WHERE u.id IS NULL;


SELECT DISTINCT
    ci.product_id
FROM raw_cart_items ci
LEFT JOIN raw_products p
    ON ci.product_id = p.id
WHERE p.id IS NULL;