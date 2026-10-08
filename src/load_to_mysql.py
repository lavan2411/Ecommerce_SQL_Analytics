import os
import json
import mysql.connector
from pathlib import Path
from dotenv import load_dotenv

from api_client import extract


# --------------------------------------------------
# Load environment variables
# --------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")


# --------------------------------------------------
# Database configuration
# --------------------------------------------------

DB_CONFIG = {
    "host": os.getenv("MYSQL_HOST"),
    "port": 3306,
    "user": os.getenv("MYSQL_USER"),
    "password": os.getenv("MYSQL_PASSWORD"),
    "database": os.getenv("MYSQL_DATABASE")
}


# --------------------------------------------------
# API endpoints
# --------------------------------------------------

API_URLS = [
    "https://dummyjson.com/users?limit=0",
    "https://dummyjson.com/products?limit=0",
    "https://dummyjson.com/carts?limit=0"
]


# --------------------------------------------------
# Load original JSON response
# --------------------------------------------------

def load_raw_json(cursor, url, payload):

    query = """
        INSERT INTO raw_api_data (
            source_url,
            payload
        )
        VALUES (%s, %s)
    """

    cursor.execute(
        query,
        (
            url,
            json.dumps(payload)
        )
    )


# --------------------------------------------------
# Load users
# --------------------------------------------------

def load_users(cursor, users):

    query = """
        INSERT INTO raw_users (
            id,
            firstName,
            lastName,
            maidenName,
            age,
            gender,
            email,
            phone,
            username,
            password,
            birthDate,
            image,
            bloodGroup,
            height,
            weight,
            eyeColor,
            university,
            role
        )
        VALUES (
            %s, %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s, %s
        )
    """

    for user in users:

        cursor.execute(
            query,
            (
                user.get("id"),
                user.get("firstName"),
                user.get("lastName"),
                user.get("maidenName"),
                user.get("age"),
                user.get("gender"),
                user.get("email"),
                user.get("phone"),
                user.get("username"),
                user.get("password"),
                user.get("birthDate"),
                user.get("image"),
                user.get("bloodGroup"),
                user.get("height"),
                user.get("weight"),
                user.get("eyeColor"),
                user.get("university"),
                user.get("role")
            )
        )


# --------------------------------------------------
# Load products
# --------------------------------------------------

def load_products(cursor, products):

    query = """
        INSERT INTO raw_products (
            id,
            title,
            description,
            category,
            price,
            discountPercentage,
            rating,
            stock,
            brand,
            sku,
            weight,
            warrantyInformation,
            shippingInformation,
            availabilityStatus,
            returnPolicy,
            minimumOrderQuantity,
            createdAt,
            updatedAt
        )
        VALUES (
            %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s,
            %s, %s, %s
        )
    """

    for product in products:

        meta = product.get("meta", {})

        cursor.execute(
            query,
            (
                product.get("id"),
                product.get("title"),
                product.get("description"),
                product.get("category"),
                product.get("price"),
                product.get("discountPercentage"),
                product.get("rating"),
                product.get("stock"),
                product.get("brand"),
                product.get("sku"),
                product.get("weight"),
                product.get("warrantyInformation"),
                product.get("shippingInformation"),
                product.get("availabilityStatus"),
                product.get("returnPolicy"),
                product.get("minimumOrderQuantity"),
                meta.get("createdAt"),
                meta.get("updatedAt")
            )
        )


# --------------------------------------------------
# Load carts and cart items
# --------------------------------------------------

def load_carts(cursor, carts):

    cart_query = """
        INSERT INTO raw_carts (
            id,
            total,
            discountedTotal,
            userId,
            totalProducts,
            totalQuantity
        )
        VALUES (%s, %s, %s, %s, %s, %s)
    """

    item_query = """
        INSERT INTO raw_cart_items (
            cart_id,
            product_id,
            title,
            price,
            quantity,
            total,
            discountPercentage,
            discountedTotal
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """

    for cart in carts:

        # Cart-level data
        cursor.execute(
            cart_query,
            (
                cart.get("id"),
                cart.get("total"),
                cart.get("discountedTotal"),
                cart.get("userId"),
                cart.get("totalProducts"),
                cart.get("totalQuantity")
            )
        )

        # Products inside the cart
        for product in cart.get("products", []):

            cursor.execute(
                item_query,
                (
                    cart.get("id"),
                    product.get("id"),
                    product.get("title"),
                    product.get("price"),
                    product.get("quantity"),
                    product.get("total"),
                    product.get("discountPercentage"),
                    product.get("discountedTotal")
                )
            )


# --------------------------------------------------
# Clear previous raw data
# --------------------------------------------------

def clear_raw_tables(cursor):

    cursor.execute("SET FOREIGN_KEY_CHECKS = 0")

    cursor.execute("TRUNCATE TABLE raw_cart_items")
    cursor.execute("TRUNCATE TABLE raw_carts")
    cursor.execute("TRUNCATE TABLE raw_products")
    cursor.execute("TRUNCATE TABLE raw_users")
    cursor.execute("TRUNCATE TABLE raw_api_data")

    cursor.execute("SET FOREIGN_KEY_CHECKS = 1")


# --------------------------------------------------
# Main pipeline
# --------------------------------------------------

def main():

    print("Connecting to MySQL...")

    connection = mysql.connector.connect(**DB_CONFIG)

    cursor = connection.cursor()

    try:

        print("Clearing previous raw data...")

        clear_raw_tables(cursor)

        for url in API_URLS:

            print(f"Extracting: {url}")

            payload = extract(url)

            # Store original API response
            load_raw_json(
                cursor,
                url,
                payload
            )

            # Convert API JSON into raw tables
            if "/users" in url:

                users = payload.get("users", [])

                print(f"Loading {len(users)} users...")

                load_users(
                    cursor,
                    users
                )

            elif "/products" in url:

                products = payload.get("products", [])

                print(f"Loading {len(products)} products...")

                load_products(
                    cursor,
                    products
                )

            elif "/carts" in url:

                carts = payload.get("carts", [])

                print(f"Loading {len(carts)} carts...")

                load_carts(
                    cursor,
                    carts
                )

        # Commit everything
        connection.commit()

        print()
        print("======================================")
        print("API DATA LOADED SUCCESSFULLY")
        print("======================================")


    except Exception as error:

        connection.rollback()

        print()
        print("ERROR:", error)

        raise


    finally:

        cursor.close()
        connection.close()

        print("MySQL connection closed.")


# --------------------------------------------------
# Run program
# --------------------------------------------------

if __name__ == "__main__":
    main()