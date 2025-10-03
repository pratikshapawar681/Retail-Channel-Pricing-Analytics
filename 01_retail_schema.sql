-- FILE 1: DATABASE SCHEMA AND INTEGRITY (DDL)
-- This file creates the database, all tables, foreign key relationships, and integrity checks.

-- 1. DATABASE CREATION
CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

-- 2. MASTER TABLES
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at DATETIME NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category VARCHAR(100),
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price > 0), -- Enforced positivity
    active BOOLEAN NOT NULL
);

CREATE TABLE payment_methods (
    id INT PRIMARY KEY,
    method_name VARCHAR(100) UNIQUE NOT NULL,
    active BOOLEAN NOT NULL
);

CREATE TABLE sales_channels (
    id INT PRIMARY KEY,
    channel_name VARCHAR(100) UNIQUE NOT NULL,
    active BOOLEAN NOT NULL
);

-- 3. TRANSACTIONAL TABLES
CREATE TABLE sales (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    sale_date DATETIME NOT NULL,
    payment_method_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    sales_channel_id INT NOT NULL,

    -- Foreign Keys enforcing consistent channels/payments
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE RESTRICT,
    FOREIGN KEY (sales_channel_id) REFERENCES sales_channels(id) ON DELETE RESTRICT
);

-- sale_line_items: Uses GENERATED COLUMN to enforce pricing integrity (line_total = quantity * unit_price)
CREATE TABLE sale_line_items (
    id INT PRIMARY KEY,
    sale_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    
    -- Corrected: Uses GENERATED COLUMN for calculated integrity
    line_total DECIMAL(10, 2) AS (quantity * unit_price) STORED, 
    
    product_id INT NOT NULL,

    FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 4. PERFORMANCE IMPROVEMENTS (Indexes)
CREATE INDEX idx_sale_date ON sales(sale_date);
CREATE INDEX idx_line_product_id ON sale_line_items(product_id);