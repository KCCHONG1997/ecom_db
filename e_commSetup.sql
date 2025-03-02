-- Use existing database
CREATE DATABASE IF NOT EXISTS ecom_db;
USE ecom_db;

CREATE TABLE IF NOT EXISTS UserAccount (
    user_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for users
    username VARCHAR(50) NOT NULL UNIQUE,    -- Unique username
    email VARCHAR(100) NOT NULL UNIQUE,      -- User's email
    password_hash VARCHAR(255) NOT NULL,     -- Hashed password
    first_name VARCHAR(50),                  -- First name
    last_name VARCHAR(50),                   -- Last name
    phone_number VARCHAR(15),                -- Contact number
    address TEXT,                            -- Shipping address
    role ENUM('producer', 'learner', 'admin') DEFAULT 'learner', -- Roles
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS OrderTable (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'shipped', 'delivered', 'canceled') 
        DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id)
);

CREATE TABLE IF NOT EXISTS OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES OrderTable(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE IF NOT EXISTS sessions (
    session_id VARCHAR(255) NOT NULL PRIMARY KEY,
    expires BIGINT NOT NULL,
    data TEXT
);

CREATE TABLE IF NOT EXISTS user_sessions (
    user_id INT NOT NULL,
    session_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, session_id),
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id) 
        ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) 
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Course (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    creator_id INT NOT NULL, -- The producer who owns/created the course
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL, -- If courses can be paid
    max_capacity INT DEFAULT 0,     -- Optional: how many students can enroll
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creator_id) REFERENCES UserAccount(user_id)
);

CREATE TABLE IF NOT EXISTS CourseEnrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,      -- The learner's user_id
    course_id INT NOT NULL,    -- The specific course
    completion_percentage DECIMAL(5,2) DEFAULT 0.00, -- e.g. from 0.00 to 100.00
    is_kicked BOOLEAN DEFAULT 0, -- If the producer has removed the learner
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE IF NOT EXISTS CourseAttendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,   -- Link to CourseEnrollment
    date_attended DATE NOT NULL,  -- Or DATETIME if needed
    status ENUM('present', 'absent', 'late') DEFAULT 'present',
    FOREIGN KEY (enrollment_id) REFERENCES CourseEnrollment(enrollment_id)
);




