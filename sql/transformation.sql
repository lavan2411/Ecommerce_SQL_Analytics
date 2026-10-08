USE ecommerce_analytics;


-- =========================================================
-- 1. CLEAN CUSTOMERS
-- =========================================================

CREATE OR REPLACE VIEW vw_customers AS
SELECT
    id AS customer_id,

    NULLIF(TRIM(firstName), '') AS first_name,

    NULLIF(TRIM(lastName), '') AS last_name,

    CASE
        WHEN age >= 18 THEN age
        ELSE NULL
    END AS age,

    CASE
        WHEN gender IS NULL OR TRIM(gender) = '' THEN NULL
        ELSE LOWER(TRIM(gender))
    END AS gender

FROM raw_users;


-- =========================================================
-- 2. CLEAN PRODUCTS
-- =========================================================

CREATE OR REPLACE VIEW vw_products AS
SELECT
    id AS product_id,

    NULLIF(TRIM(title), '') AS product_name,

    NULLIF(LOWER(TRIM(category)), '') AS category,

    CASE
        WHEN price >= 0 THEN price
        ELSE NULL
    END AS price,

    CASE
        WHEN discountPercentage >= 0 THEN discountPercentage
        ELSE NULL
    END AS discount_percentage,

    CASE
        WHEN rating BETWEEN 0 AND 5 THEN rating
        ELSE NULL
    END AS rating,

    CASE
        WHEN stock >= 0 THEN stock
        ELSE NULL
    END AS stock,

    NULLIF(TRIM(brand), '') AS brand,

    NULLIF(TRIM(sku), '') AS sku,

    NULLIF(LOWER(TRIM(availabilityStatus)), '') AS availability_status,

    CASE
        WHEN minimumOrderQuantity > 0
        THEN minimumOrderQuantity
        ELSE NULL
    END AS minimum_order_quantity,

    STR_TO_DATE(
        REPLACE(REPLACE(createdAt, 'T', ' '), 'Z', ''),
        '%Y-%m-%d %H:%i:%s.%f'
    ) AS created_at

FROM raw_products;


-- =========================================================
-- 3. CLEAN CARTS
-- =========================================================

CREATE OR REPLACE VIEW vw_carts AS
SELECT
    id AS cart_id,

    userId AS customer_id,

    CASE
        WHEN total >= 0 THEN total
        ELSE NULL
    END AS total,

    CASE
        WHEN discountedTotal >= 0 THEN discountedTotal
        ELSE NULL
    END AS discounted_total,

    CASE
        WHEN totalProducts >= 0 THEN totalProducts
        ELSE NULL
    END AS total_products,

    CASE
        WHEN totalQuantity >= 0 THEN totalQuantity
        ELSE NULL
    END AS total_quantity

FROM raw_carts;


-- =========================================================
-- 4. CLEAN CART ITEMS
-- =========================================================

CREATE OR REPLACE VIEW vw_cart_items AS
SELECT
    cart_item_id,

    cart_id,

    product_id,

    CASE
        WHEN price >= 0 THEN price
        ELSE NULL
    END AS price,

    CASE
        WHEN quantity > 0 THEN quantity
        ELSE NULL
    END AS quantity,

    CASE
        WHEN total >= 0 THEN total
        ELSE NULL
    END AS total,

    CASE
        WHEN discountPercentage >= 0
        THEN discountPercentage
        ELSE NULL
    END AS discount_percentage,

    CASE
        WHEN discountedTotal >= 0
        THEN discountedTotal
        ELSE NULL
    END AS discounted_total

FROM raw_cart_items;