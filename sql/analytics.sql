USE ecommerce_analytics;

-- Total customers
SELECT COUNT(*) AS total_customers
FROM vw_customers;

-- Total products
SELECT COUNT(*) AS total_products
FROM vw_products;

-- Total carts
SELECT COUNT(*) AS total_carts
FROM vw_carts;

-- Total quantity
SELECT SUM(total_quantity) AS total_quantity
FROM vw_carts;

-- Total cart value
SELECT
    SUM(total) AS total_cart_value,
    SUM(discounted_total) AS total_discounted_value
FROM vw_carts;

-- Total discount given
SELECT
    SUM(total - discounted_total) AS total_discount
FROM vw_carts;

-- Customers by gender
SELECT
    gender,
    COUNT(*) AS customer_count
FROM vw_customers
GROUP BY gender
ORDER BY customer_count DESC;


-- Customers by age
SELECT
    age,
    COUNT(*) AS customer_count
FROM vw_customers
GROUP BY age
ORDER BY age;

-- Products by category
SELECT
    category,
    COUNT(*) AS product_count,
    AVG(price) AS average_price,
    AVG(rating) AS average_rating
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
ORDER BY rating DESC
LIMIT 10;


-- Products with highest stock
SELECT
    product_id,
    product_name,
    category,
    stock
FROM vw_products
ORDER BY stock DESC
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


-- Products generating highest cart value
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

-- customers with the highest number of carts and total cart value
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(ca.cart_id) AS cart_count,
    SUM(ca.total) AS total_cart_value,
    SUM(ca.total_quantity) AS total_quantity
FROM vw_customers c
JOIN vw_carts ca
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
    SUM(ca.total) AS total_cart_value,
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


-- Average cart value by customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(ca.cart_id) AS cart_count,
    ROUND(AVG(ca.total), 2) AS average_cart_value
FROM vw_customers c
JOIN vw_carts ca
    ON c.customer_id = ca.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY average_cart_value DESC;


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
HAVING p.stock > 50
   AND COALESCE(SUM(ci.quantity), 0) < 10
ORDER BY p.stock DESC;


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