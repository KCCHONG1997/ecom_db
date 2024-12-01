-- Create database
CREATE DATABASE IF NOT EXISTS ecom_db;
USE ecom_db;

-- Create UserAccorderitemsorderitemsount table
CREATE TABLE IF NOT EXISTS UserAccount (
    user_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for users
    username VARCHAR(50) NOT NULL UNIQUE,  -- Unique username
    email VARCHAR(100) NOT NULL UNIQUE,    -- User's email
    password_hash VARCHAR(255) NOT NULL,   -- Hashed password
    first_name VARCHAR(50),                -- First name
    last_name VARCHAR(50),                 -- Last name
    phone_number VARCHAR(15),              -- Contact number
    address TEXT,                          -- Shipping address
    role ENUM('customer', 'admin') DEFAULT 'customer', -- User role
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Account creation timestamp
);

-- Create Product table
CREATE TABLE IF NOT EXISTS Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for products
    name VARCHAR(100) NOT NULL,               -- Product name
    description TEXT,                         -- Product description
    price DECIMAL(10, 2) NOT NULL,            -- Product price
    stock INT DEFAULT 0,                      -- Available stock
    category VARCHAR(50),                     -- Product category
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp
);

-- Create Order table
CREATE TABLE IF NOT EXISTS OrderTable (
    order_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for orders
    user_id INT NOT NULL,                     -- User who placed the order
    total_amount DECIMAL(10, 2) NOT NULL,     -- Total order amount
    status ENUM('pending', 'shipped', 'delivered', 'canceled') DEFAULT 'pending', -- Order status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of order creation
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id) -- Link to UserAccount
);

-- Create OrderItems table
CREATE TABLE IF NOT EXISTS OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for order items
    order_id INT NOT NULL,                        -- Associated order
    product_id INT NOT NULL,                      -- Product in the order
    quantity INT NOT NULL,                        -- Quantity of the product
    price DECIMAL(10, 2) NOT NULL,                -- Price at the time of order
    FOREIGN KEY (order_id) REFERENCES OrderTable(order_id), -- Link to OrderTable
    FOREIGN KEY (product_id) REFERENCES Product(product_id) -- Link to Product
);
