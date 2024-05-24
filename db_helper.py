import mysql.connector
global connection

def get_order_status(order_id: int):
    try:
        # Establish connection to the MySQL database
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Mahi@123",
            database="PharmaCare"
        )

        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()

        # SQL query to retrieve the status of the order based on Order_Id
        query = "SELECT Status FROM Order_Tracking WHERE Order_Id = %s"

        # Execute the query with the provided order_id
        cursor.execute(query, (order_id,))

        # Fetch the status from the result
        status = cursor.fetchone()

        if status:
            return status[0]  # Return the status
        else:
            return "Order not found"

    except mysql.connector.Error as error:
        print("Error reading data from MySQL table:", error)
    finally:
        # Close the cursor and connection
        if (connection.is_connected()):
            cursor.close()

def get_next_order_id():
    try:
        # Establish connection to the MySQL database
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Mahi@123",
            database="PharmaCare"
        )

        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()

        # SQL query to retrieve the maximum order_id from the orders table
        query = "SELECT MAX(order_id) FROM orders"

        # Execute the query
        cursor.execute(query)

        # Fetch the maximum order_id from the result
        max_order_id = cursor.fetchone()[0]

        if max_order_id is not None:
            return max_order_id + 1  # Return the next order ID
        else:
            return 1  # If no orders exist, start with order ID 1

    except mysql.connector.Error as error:
        print("Error reading data from MySQL table:", error)
        return None
    finally:
        # Close the cursor and connection
        if connection.is_connected():
            cursor.close()
            

def insert_order_item(medicine, quantity, order_id):
    try:
        # Establish connection to the MySQL database
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Mahi@123",
            database="PharmaCare"
        )
        
        cursor = connection.cursor()

        # Call the stored procedure
        cursor.callproc('insert_order_item', (medicine, quantity, order_id))

        # Commit the changes
        connection.commit()

        print("Order item inserted successfully!")
        return 1

    except mysql.connector.Error as err:
        print(f"Error inserting order item: {err}")
        if connection.is_connected():
            connection.rollback()
        return -1

    except Exception as e:
        print(f"An error occurred: {e}")
        if connection.is_connected():
            connection.rollback()
        return -1

    finally:
        # Ensure the cursor and connection are always closed properly
        if connection.is_connected():
            cursor.close()
            
def get_total_order_price(order_id):
    try:
        # Establish connection to the MySQL database
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Mahi@123",
            database="PharmaCare"
        )
        
        cursor = connection.cursor()

        # Using parameterized query to prevent SQL injection
        query = "SELECT get_total_order_price(%s)"
        cursor.execute(query, (order_id,))  # Pass order_id as a single-element tuple
        
        result = cursor.fetchone()[0]
        return result

    except mysql.connector.Error as err:
        print(f"Error retrieving total order price: {err}")
        return None

    finally:
        # Ensure the cursor and connection are always closed properly
        if connection.is_connected():
            cursor.close()
            
def insert_order_tracking(order_id, status):
    try:
        # Establish connection to the MySQL database
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Mahi@123",
            database="PharmaCare"
        )
        
        cursor = connection.cursor()
        
        # Inserting the record into the order_tracking table
        insert_query = "INSERT INTO order_tracking (order_id, status) VALUES (%s, %s)"
        cursor.execute(insert_query, (order_id, status))
        
        # Commit the transaction
        connection.commit()

        return 1

    except mysql.connector.Error as err:
        print(f"Error inserting order tracking record: {err}")
        if connection.is_connected():
            connection.rollback()
        return -1

    except Exception as e:
        print(f"An error occurred: {e}")
        if connection.is_connected():
            connection.rollback()
        return -1

    finally:
        # Ensure the cursor and connection are always closed properly
        if connection.is_connected():
            cursor.close()