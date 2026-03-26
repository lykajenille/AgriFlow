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

-- Insert sample users (change passwords in production!)
INSERT INTO users (username, password, email, full_name, role) VALUES
('admin', 'admin123', 'admin@agriflow.com', 'Admin User', 'admin'),
('farmer', '1234', 'farmer@agriflow.com', 'John Farmer', 'farmer');

-- Create index for faster lookups
CREATE INDEX idx_username ON users(username);
