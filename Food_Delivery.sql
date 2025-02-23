drop database Foodies;

-- Create database
CREATE DATABASE Foodies;
USE Foodies;

-- Admin Table
CREATE TABLE admin_login (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    address TEXT,
    status ENUM('open', 'closed') NOT NULL,
    role ENUM('Super Admin', 'Restaurant Admin') NOT NULL
);

-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    address TEXT,
    user_type ENUM('customer', 'delivery_agent', 'admin') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Restaurants Table
CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    rating DECIMAL(3,2) DEFAULT 0.0
);

-- Menu Table
CREATE TABLE Menu (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    restaurant_id INT,
    order_status ENUM('Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    total_amount DECIMAL(10,2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_id INT DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    user_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    payment_method ENUM('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'COD') NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- FIXED: Delivery Table (Allowed NULL for delivery_agent_id)
CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE NOT NULL,
    delivery_agent_id INT NULL,
    delivery_status ENUM('Pending', 'Picked Up', 'In Transit', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    estimated_time TIME,
    delivered_time TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (delivery_agent_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Ratings & Reviews Table
CREATE TABLE Ratings_Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    restaurant_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);

-- INSERT DATA

-- Admin Users
INSERT INTO admin_login (name, email, phone, password, address, status, role) VALUES
('Prasad Joshi', 'prasad@foodies.com', '9876543210', SHA2('adminpass1', 256), 'Pune, Maharashtra', 'open', 'Super Admin'),
('Piyush Deshmukh', 'piyush@foodies.com', '9876543211', SHA2('adminpass2', 256), 'Mumbai, Maharashtra', 'open', 'Restaurant Admin'),
('Krishna Patil', 'krishna@foodies.com', '9876543212', SHA2('adminpass3', 256), 'Nagpur, Maharashtra', 'open', 'Restaurant Admin');

-- Users
INSERT INTO Users (name, email, phone, password, address, user_type) VALUES
('Kashup Sharma', 'kashup@gmail.com', '9876543213', SHA2('userpass1', 256), 'Delhi, India', 'customer'),
('Aniket Verma', 'aniket@gmail.com', '9876543214', SHA2('userpass2', 256), 'Bangalore, Karnataka', 'customer'),
('Rohan Gupta', 'rohan@gmail.com', '9876543215', SHA2('userpass3', 256), 'Hyderabad, Telangana', 'customer'),
('Sanket More', 'sanket@gmail.com', '9876543216', SHA2('userpass4', 256), 'Chennai, Tamil Nadu', 'delivery_agent'),
('Aditya Kulkarni', 'aditya@gmail.com', '9876543217', SHA2('userpass5', 256), 'Pune, Maharashtra', 'delivery_agent');

-- Restaurants
INSERT INTO Restaurants (name, address, phone, email, rating) VALUES
('The Food Lounge', 'Pune, Maharashtra', '9765432101', 'foodlounge@gmail.com', 4.5),
('Mumbai Tadka', 'Mumbai, Maharashtra', '9765432102', 'mumbaitadka@gmail.com', 4.2),
('Nagpur Biryani House', 'Nagpur, Maharashtra', '9765432103', 'nagpurbiryani@gmail.com', 4.8);

-- Menu Items
INSERT INTO Menu (restaurant_id, name, description, price, category) VALUES
(1, 'Paneer Butter Masala', 'Delicious paneer dish in creamy tomato gravy', 250.00, 'Main Course'),
(1, 'Veg Biryani', 'Aromatic rice with fresh vegetables', 200.00, 'Main Course'),
(2, 'Chicken Tandoori', 'Spicy grilled chicken with Indian spices', 350.00, 'Starter'),
(3, 'Mutton Biryani', 'Hyderabadi style slow-cooked mutton biryani', 400.00, 'Main Course');

-- Orders
INSERT INTO Orders (user_id, restaurant_id, order_status, total_amount) VALUES
(1, 1, 'Pending', 450.00),
(2, 2, 'Preparing', 350.00),
(3, 3, 'Out for Delivery', 400.00);

-- Payments
INSERT INTO Payments (order_id, user_id, amount, payment_status, payment_method) VALUES
(1, 1, 450.00, 'Completed', 'UPI'),
(2, 2, 350.00, 'Completed', 'Credit Card'),
(3, 3, 400.00, 'Pending', 'COD');

-- Delivery
INSERT INTO Delivery (order_id, delivery_agent_id, delivery_status, estimated_time) VALUES
(1, 4, 'Picked Up', '00:30:00'),
(2, 5, 'In Transit', '00:45:00'),
(3, 4, 'Delivered', '00:40:00');

-- Ratings & Reviews
INSERT INTO Ratings_Reviews (user_id, restaurant_id, rating, review_text) VALUES
(1, 1, 5, 'Amazing food, highly recommended!'),
(2, 2, 4, 'Tasty but a bit expensive.'),
(3, 3, 5, 'Best biryani ever!'),
(1, 2, 3, 'Good taste but slow delivery.'),
(2, 3, 5, 'Excellent food quality and packaging.'),
(3, 1, 4, 'Loved the flavors, will order again!');

-- Check all tables
SELECT * FROM admin_login;
SELECT * FROM Users;
SELECT * FROM Restaurants;
SELECT * FROM Menu;
SELECT * FROM Orders;
SELECT * FROM Payments;
SELECT * FROM Delivery;
SELECT * FROM Ratings_Reviews;
