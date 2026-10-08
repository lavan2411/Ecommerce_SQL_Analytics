CREATE DATABASE IF NOT EXISTS ecommerce_analytics;

USE ecommerce_analytics;

-- Original API responses for traceability
CREATE TABLE IF NOT EXISTS raw_api_data (
    ingestion_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    source_url TEXT NOT NULL,
    payload JSON NOT NULL,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Raw users
CREATE TABLE IF NOT EXISTS raw_users (
    id INT PRIMARY KEY,
    firstName VARCHAR(100),
    lastName VARCHAR(100),
    maidenName VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    email VARCHAR(255),
    phone VARCHAR(50),
    username VARCHAR(100),
    password VARCHAR(255),
    birthDate VARCHAR(30),
    image TEXT,
    bloodGroup VARCHAR(20),
    height DECIMAL(10,2),
    weight DECIMAL(10,2),
    eyeColor VARCHAR(50),
    university VARCHAR(255),
    role VARCHAR(50)
);

-- Raw products
CREATE TABLE IF NOT EXISTS raw_products (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    category VARCHAR(100),
    price DECIMAL(12,2),
    discountPercentage DECIMAL(10,2),
    rating DECIMAL(10,2),
    stock INT,
    brand VARCHAR(255),
    sku VARCHAR(100),
    weight DECIMAL(10,2),
    warrantyInformation TEXT,
    shippingInformation TEXT,
    availabilityStatus VARCHAR(100),
    returnPolicy TEXT,
    minimumOrderQuantity INT,
    createdAt VARCHAR(50),
    updatedAt VARCHAR(50)
);

-- Raw carts
CREATE TABLE IF NOT EXISTS raw_carts (
    id INT PRIMARY KEY,
    total DECIMAL(14,2),
    discountedTotal DECIMAL(14,2),
    userId INT,
    totalProducts INT,
    totalQuantity INT
);

-- Raw products inside carts
CREATE TABLE IF NOT EXISTS raw_cart_items (
    cart_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT,
    product_id INT,
    title VARCHAR(255),
    price DECIMAL(12,2),
    quantity INT,
    total DECIMAL(12,2),
    discountPercentage DECIMAL(10,2),
    discountedTotal DECIMAL(12,2)
);