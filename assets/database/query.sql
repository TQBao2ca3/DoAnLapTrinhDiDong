create database phoneshop;

USE phoneshop;

-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Categories table
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES Categories(category_id)
);

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    name VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Create ProductDetail table
CREATE TABLE ProductDetail (
    product_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    storage VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    image_url TEXT,
    description TEXT,
    colors VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create Cart table
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create CartItem table
CREATE TABLE CartItem (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT,
    product_detail_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    FOREIGN KEY (product_detail_id) REFERENCES ProductDetail(product_detail_id)
);

-- Create Reviews table
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create Image table
CREATE TABLE Image (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_detail_id INT,
    image_url TEXT NOT NULL,
    FOREIGN KEY (product_detail_id) REFERENCES ProductDetail(product_detail_id)
);

-- Create Address table
CREATE TABLE Address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Discounts table
CREATE TABLE Discounts (
    discount_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_amount DECIMAL(10, 2) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    status_order VARCHAR(50) NOT NULL,
    shipping_address TEXT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_payment VARCHAR(50) NOT NULL,
    payment_date TIMESTAMP,
    payment_method VARCHAR(50),
    tracking_number VARCHAR(100),
    discount_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id)
);

-- Create OrdersDetail table
CREATE TABLE OrdersDetail (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    product_deatail_id INT,
    quantity INT NOT NULL,
    discount_id INT,
    FOREIGN KEY (product_deatail_id) REFERENCES ProductDetail(product_detail_id),
    FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id)
);

-- Create Wishlist table (additional table for extra points)
CREATE TABLE Wishlist (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);