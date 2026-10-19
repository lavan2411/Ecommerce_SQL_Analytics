import os
import unittest
import mysql.connector


class TestSQLViews(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.connection = mysql.connector.connect(
            host=os.getenv("MYSQL_HOST", "127.0.0.1"),
            port=int(os.getenv("MYSQL_PORT", "3306")),
            user=os.getenv("MYSQL_USER", "root"),
            password=os.getenv("MYSQL_PASSWORD", "test_password"),
            database=os.getenv("MYSQL_DATABASE", "ecommerce_analytics"),
        )
        cls.cursor = cls.connection.cursor()

    @classmethod
    def tearDownClass(cls):
        cls.cursor.close()
        cls.connection.close()

    def tearDown(self):
        self.connection.rollback()
        self.cursor.execute("DELETE FROM raw_users WHERE id = 9001")
        self.cursor.execute("DELETE FROM raw_products WHERE id = 9001")
        self.cursor.execute(
            "DELETE FROM raw_cart_items WHERE cart_id = 9001 AND product_id = 9001"
        )
        self.connection.commit()

    def test_customer_view_cleans_names_and_gender(self):
        self.cursor.execute("""
            INSERT INTO raw_users
                (id, firstName, lastName, age, gender)
            VALUES
                (9001, '  Test ', ' Customer  ', 25, ' FEMALE ')
        """)
        self.connection.commit()

        self.cursor.execute("""
            SELECT first_name, last_name, gender
            FROM vw_customers
            WHERE customer_id = 9001
        """)
        result = self.cursor.fetchone()

        self.assertEqual(result, ("Test", "Customer", "female"))

    def test_invalid_product_price_becomes_null(self):
        self.cursor.execute("""
            INSERT INTO raw_products
                (id, title, category, price, discountPercentage, rating, stock)
            VALUES
                (9001, 'Test Product', ' TEST-CATEGORY ', -10, 5, 4, 10)
        """)
        self.connection.commit()

        self.cursor.execute("""
            SELECT category, price
            FROM vw_products
            WHERE product_id = 9001
        """)
        result = self.cursor.fetchone()

        self.assertEqual(result[0], "test-category")
        self.assertIsNone(result[1])

    def test_invalid_cart_item_quantity_becomes_null(self):
        self.cursor.execute("""
            INSERT INTO raw_cart_items
                (cart_id, product_id, price, quantity, total,
                 discountPercentage, discountedTotal)
            VALUES
                (9001, 9001, 10, 0, 0, 0, 0)
        """)
        self.connection.commit()

        self.cursor.execute("""
            SELECT quantity
            FROM vw_cart_items
            WHERE cart_id = 9001 AND product_id = 9001
        """)
        result = self.cursor.fetchone()

        self.assertIsNotNone(result)
        self.assertIsNone(result[0])


if __name__ == "__main__":
    unittest.main()