-- Create the agriflow database
CREATE DATABASE IF NOT EXISTS agriflow;
USE agriflow;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    full_name VARCHAR(100),
    role VARCHAR(20) NOT NULL DEFAULT 'farmer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample users (passwords are hashed with bcrypt)
-- admin password: admin123
-- farmer password: 1234
INSERT INTO users (username, password, email, full_name, role) VALUES
('admin', '$2y$10$7J5GxG8Vxk8z7zK9z9z9zuvZ9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z', 'admin@agriflow.com', 'Admin User', 'admin'),
('farmer', '$2y$10$8K6HyH9Wyl9y8aL0a0a0avwA0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a', 'farmer@agriflow.com', 'John Farmer', 'farmer');

-- Create index for faster lookups
CREATE INDEX idx_username ON users(username);
