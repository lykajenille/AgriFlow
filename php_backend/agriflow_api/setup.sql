-- ============================================================
-- AgriFlow Database Setup — migrate:fresh --seed
-- WARNING: This DROPS all tables and recreates them from scratch!
-- ============================================================

-- DROP & RECREATE DATABASE
DROP DATABASE IF EXISTS agriflow;
CREATE DATABASE agriflow;
USE agriflow;

-- USERS TABLE
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role ENUM('admin','farmer') DEFAULT 'farmer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- FARMS TABLE
CREATE TABLE IF NOT EXISTS farms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    farm_name VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    size DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- CROPS TABLE
CREATE TABLE IF NOT EXISTS crops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    crop_name VARCHAR(100) NOT NULL,
    planting_date DATE,
    expected_harvest DATE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
);

-- INVENTORY TABLE
CREATE TABLE IF NOT EXISTS inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    item_name VARCHAR(100),
    quantity INT,
    unit VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
);

-- EXPENSES TABLE
CREATE TABLE IF NOT EXISTS expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    description VARCHAR(150),
    amount DECIMAL(10,2),
    expense_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
);

-- HARVESTS TABLE
CREATE TABLE IF NOT EXISTS harvests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    crop_id INT NOT NULL,
    quantity DECIMAL(10,2),
    harvest_date DATE,
    notes VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE
);

-- SAMPLE ADMIN ACCOUNT (password: admin123, hashed with bcrypt via password_hash())
INSERT INTO users (fullname, username, password, role)
VALUES ('System Admin', 'admin', '$2y$10$CP0e50c0cZXahdkAzKSBIOrGZPxEWWlgR5GxUOP//Y0UMenSVPlQG', 'admin');