CREATE DATABASE  IF NOT EXISTS `railway` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `railway`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: monorail.proxy.rlwy.net    Database: railway
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Address`
--

DROP TABLE IF EXISTS `Address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Address` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`address_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Address`
--

LOCK TABLES `Address` WRITE;
/*!40000 ALTER TABLE `Address` DISABLE KEYS */;
/*!40000 ALTER TABLE `Address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cart`
--

DROP TABLE IF EXISTS `Cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cart` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cart`
--

LOCK TABLES `Cart` WRITE;
/*!40000 ALTER TABLE `Cart` DISABLE KEYS */;
INSERT INTO `Cart` VALUES (1,3,'2025-01-12 08:54:02','2025-01-12 08:54:02'),(2,1,'2025-01-17 03:54:55','2025-01-17 03:54:55'),(3,10,'2025-01-17 04:00:25','2025-01-17 04:00:25'),(5,8,'2025-01-17 04:00:58','2025-01-17 04:00:58'),(8,2,'2025-01-17 04:01:49','2025-01-17 04:01:49'),(9,12,'2025-01-17 04:02:00','2025-01-17 04:02:00'),(10,13,'2025-01-17 04:02:05','2025-01-17 04:02:05'),(11,15,'2025-01-18 03:06:26','2025-01-18 03:06:26'),(12,14,'2025-01-20 14:05:52','2025-01-20 14:05:52'),(13,21,'2025-01-20 17:27:22','2025-01-20 17:27:22'),(14,23,'2025-01-21 09:07:13','2025-01-21 09:07:13'),(15,24,'2025-01-21 09:12:17','2025-01-21 09:12:17');
/*!40000 ALTER TABLE `Cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CartItem`
--

DROP TABLE IF EXISTS `CartItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CartItem` (
  `cart_item_id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int DEFAULT NULL,
  `product_detail_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `storage` varchar(50) DEFAULT NULL,
  `colors` varchar(50) DEFAULT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`cart_item_id`),
  KEY `cart_id` (`cart_id`),
  KEY `product_detail_id` (`product_detail_id`),
  CONSTRAINT `CartItem_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `Cart` (`cart_id`),
  CONSTRAINT `CartItem_ibfk_2` FOREIGN KEY (`product_detail_id`) REFERENCES `ProductDetail` (`product_detail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CartItem`
--

LOCK TABLES `CartItem` WRITE;
/*!40000 ALTER TABLE `CartItem` DISABLE KEYS */;
INSERT INTO `CartItem` VALUES (17,9,1,1,'512GB','Blue',2000000),(18,1,1,1,'128GB','White',1000000);
/*!40000 ALTER TABLE `CartItem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Categories`
--

DROP TABLE IF EXISTS `Categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `parent_id` int DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `Categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `Categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categories`
--

LOCK TABLES `Categories` WRITE;
/*!40000 ALTER TABLE `Categories` DISABLE KEYS */;
INSERT INTO `Categories` VALUES (1,'iPhone','Apple iPhone series',NULL),(2,'Samsung','Samsung phones',NULL),(3,'Xiaomi','Xiaomi phones',NULL),(4,'Oppo','Oppo phones',NULL),(5,'iPhone 16 Series','Latest iPhone series',1),(6,'iPhone 15 Series','Previous iPhone series',1),(7,'Galaxy S','Samsung flagship series',2),(8,'Galaxy M','Samsung mid-range series',2);
/*!40000 ALTER TABLE `Categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Discounts`
--

DROP TABLE IF EXISTS `Discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Discounts` (
  `discount_id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `discount_amount` decimal(10,2) NOT NULL,
  `valid_from` timestamp NOT NULL,
  `valid_to` timestamp NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`discount_id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Discounts`
--

LOCK TABLES `Discounts` WRITE;
/*!40000 ALTER TABLE `Discounts` DISABLE KEYS */;
INSERT INTO `Discounts` VALUES (1,'SUMMER2024',1000000.00,'2024-06-01 00:00:00','2024-08-31 00:00:00',1);
/*!40000 ALTER TABLE `Discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Image`
--

DROP TABLE IF EXISTS `Image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Image` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `product_detail_id` int DEFAULT NULL,
  `image_url` text NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `product_detail_id` (`product_detail_id`),
  CONSTRAINT `Image_ibfk_1` FOREIGN KEY (`product_detail_id`) REFERENCES `ProductDetail` (`product_detail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Image`
--

LOCK TABLES `Image` WRITE;
/*!40000 ALTER TABLE `Image` DISABLE KEYS */;
INSERT INTO `Image` VALUES (1,1,'https://example.com/iphone16-black.jpg'),(2,3,'https://example.com/iphone16-gold.jpg'),(3,5,'https://example.com/iphone15-black.jpg'),(4,7,'https://example.com/iphone15-gold.jpg'),(5,9,'https://example.com/s24-ultra.jpg'),(6,10,'https://example.com/m54.jpg');
/*!40000 ALTER TABLE `Image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `status_order` int DEFAULT '0',
  `shipping_address` text NOT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status_payment` int DEFAULT NULL,
  `payment_date` timestamp NULL DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `discount_id` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `discount_id` (`discount_id`),
  CONSTRAINT `Orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `Orders_ibfk_2` FOREIGN KEY (`discount_id`) REFERENCES `Discounts` (`discount_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (1,2,-1,'456 User St','2025-01-12 22:54:03',0,NULL,'Credit Card','TN123456789',NULL),(2,3,0,'1111 Huynh Thuc Khang','2025-01-17 06:42:44',1,'2025-01-17 06:42:44','Credit Card','TN3241',NULL),(5,3,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-18 18:36:23',1,'2025-01-19 01:36:24','Thẻ nội địa Napas','TN9521',NULL),(7,3,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-18 18:57:01',0,'2025-01-19 01:57:02','Thẻ nội địa Napas','TN726',NULL),(8,2,1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-19 15:50:48',1,'2025-01-19 22:50:50','1',NULL,NULL),(9,2,1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-20 00:19:41',1,'2025-01-20 07:19:42','1',NULL,NULL),(10,2,1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-20 00:23:14',1,'2025-01-20 07:23:15','1',NULL,NULL),(11,12,1,'663 Trần Xuân Soan\nPhường Tân Hưng, Quận 7, TP. Hồ Chí Minh','2025-01-20 01:22:00',1,'2025-01-20 08:21:51','1',NULL,NULL),(12,12,1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-20 02:09:21',1,'2025-01-20 09:09:12','1',NULL,NULL),(13,12,1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-20 02:11:37',1,'2025-01-20 09:11:28','1',NULL,NULL),(14,12,1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-20 02:12:45',1,'2025-01-20 09:12:36','1',NULL,NULL),(15,12,1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-20 02:14:45',1,'2025-01-20 09:14:36','1',NULL,NULL),(16,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-20 03:20:39',1,'2025-01-20 10:20:40','1',NULL,NULL),(17,2,0,'663 Trần Xuân Soan\nPhường Tân Hưng, Quận 7, TP. Hồ Chí Minh','2025-01-21 04:40:52',1,'2025-01-21 11:42:42','1',NULL,NULL),(18,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 05:01:52',1,'2025-01-21 12:03:43','1',NULL,NULL),(19,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 05:53:28',1,'2025-01-21 12:55:19','1',NULL,NULL),(20,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 05:55:01',1,'2025-01-21 12:56:52','1',NULL,NULL),(21,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 05:56:14',1,'2025-01-21 12:58:05','1',NULL,NULL),(22,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 05:59:44',1,'2025-01-21 13:01:35','1',NULL,NULL),(23,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 06:05:15',1,'2025-01-21 13:07:06','1',NULL,NULL),(24,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 06:06:51',1,'2025-01-21 13:08:42','1',NULL,NULL),(25,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 06:08:08',1,'2025-01-21 13:09:59','1',NULL,NULL),(26,24,-1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 09:20:55',1,'2025-01-21 16:22:46','1',NULL,NULL),(27,24,1,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 09:27:47',1,'2025-01-21 16:29:38','1',NULL,NULL),(28,2,0,'Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp','2025-01-21 12:30:29',1,'2025-01-21 19:30:31','1',NULL,NULL);
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OrdersDetail`
--

DROP TABLE IF EXISTS `OrdersDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrdersDetail` (
  `order_detail_id` int NOT NULL AUTO_INCREMENT,
  `product_detail_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `storage` varchar(10) DEFAULT NULL,
  `color` varchar(10) DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  PRIMARY KEY (`order_detail_id`),
  KEY `product_deatail_id` (`product_detail_id`),
  KEY `fk_order_detail_order` (`order_id`),
  CONSTRAINT `fk_order_detail_order` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`),
  CONSTRAINT `OrdersDetail_ibfk_1` FOREIGN KEY (`product_detail_id`) REFERENCES `ProductDetail` (`product_detail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrdersDetail`
--

LOCK TABLES `OrdersDetail` WRITE;
/*!40000 ALTER TABLE `OrdersDetail` DISABLE KEYS */;
INSERT INTO `OrdersDetail` VALUES (3,1,2,32000000,'512GB','Black',1),(4,1,3,29000000,'256GB','Gold',1),(5,1,2,32000000,'512GB','Black',2),(6,3,50,29000000,'256GB','Gold',2),(11,6,1,1000000,'128GB','Black',5),(13,1,1,1000000,'128GB','Black',7),(14,1,1,1000000,'128GB','Blue',8),(15,21,1,2000000,'512GB','Blue',8),(16,26,1,1000000,'128GB','Blue',9),(17,6,1,1000000,'128GB','Blue',10),(18,1,1,2000000,'512GB','Blue',11),(19,1,1,1000000,'128GB','Blue',12),(20,1,1,1000000,'128GB','Blue',13),(21,1,1,1000000,'128GB','Blue',14),(22,1,1,1000000,'128GB','Blue',15),(23,2,1,1000000,'128GB','Blue',16),(24,19,1,25990000,'512GB','Black',17),(25,1,1,37990000,'256GB','White',18),(26,4,1,8990000,'128GB','Black',19),(27,2,1,29990000,'128GB','Blue',20),(28,2,1,39990000,'512GB','Blue',21),(29,2,1,34990000,'256GB','White',22),(30,3,1,35990000,'256GB','Black',23),(31,3,1,35990000,'256GB','White',24),(32,49,1,4990000,'128GB','White',25),(33,49,1,5990000,'256GB','Black',25),(34,49,1,6990000,'512GB','Blue',25),(35,36,1,38990000,'256GB','White',26),(36,36,1,41990000,'512GB','Blue',26),(37,3,1,35990000,'256GB','Black',26),(38,3,1,41990000,'512GB','Blue',26),(39,3,2,41990000,'512GB','White',27),(40,2,1,29990000,'128GB','Blue',28);
/*!40000 ALTER TABLE `OrdersDetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductDetail`
--

DROP TABLE IF EXISTS `ProductDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductDetail` (
  `product_detail_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `storage` json DEFAULT NULL,
  `price` json DEFAULT NULL,
  `stock_quantity` int NOT NULL,
  `image_url` text,
  `description` text,
  `colors` json DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`product_detail_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `ProductDetail_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductDetail`
--

LOCK TABLES `ProductDetail` WRITE;
/*!40000 ALTER TABLE `ProductDetail` DISABLE KEYS */;
INSERT INTO `ProductDetail` VALUES (1,1,'[\"128GB\", \"256GB\", \"512GB\"]','[33990000, 37990000, 44990000]',26,'https://th.bing.com/th/id/OIP.f0TxVuQRnOhEoQq9JCmlzwHaHa?rs=1&pid=ImgDetMain.png','iPhone 16 Pro Max là flagship mới nhất của Apple với nhiều cải tiến đột phá. Màn hình OLED 6.9 inch với ProMotion 120Hz và Dynamic Island. Camera chính 48MP nâng cấp, zoom quang 5x, quay video 4K ProRes. Chip A18 Pro mạnh mẽ với Neural Engine 18-core. Hỗ trợ 5G, WiFi 6E, sạc nhanh 20W và MagSafe 15W. Dung lượng pin lớn cho thời gian sử dụng lâu dài.','[\"Black\", \"White\", \"Blue\"]',1),(2,2,'[\"128GB\", \"256GB\", \"512GB\"]','[29990000, 34990000, 39990000]',42,'https://cdn2.cellphones.com.vn/358x/media/catalog/product/i/p/iphone15-pro-max-titan-den.jpg','iPhone 15 Pro Max nổi bật với thiết kế khung Titan chuẩn hàng không vũ trụ siêu bền, nhẹ. Màn hình OLED 6.7 inch sắc nét với Dynamic Island. Bộ vi xử lý A17 Pro 3nm đầu tiên trên smartphone. Camera 48MP với cảm biến mới, zoom quang học 5x. Cổng USB-C hỗ trợ sạc nhanh, kết nối đa phương tiện. Dung lượng pin lớn kết hợp với tối ưu hóa hiệu năng.','[\"Black\", \"White\", \"Blue\"]',1),(3,3,'[\"128GB\", \"256GB\", \"512GB\"]','[31990000, 35990000, 41990000]',20,'https://cdn2.cellphones.com.vn/358x/media/catalog/product/g/a/galaxy-s24-ultra-den-1_1_3.png','Samsung Galaxy S24 Ultra là chiếc smartphone cao cấp nhất của Samsung với nhiều đột phá. Màn hình Dynamic AMOLED 2X 6.8 inch QHD+ với độ sáng 2600 nits. Snapdragon 8 Gen 3 for Galaxy mạnh mẽ. Cụm camera được nâng cấp với camera chính 200MP, zoom quang học 10x. Bút S Pen tích hợp, khung Titan aerospace-grade bền bỉ. Pin 5000mAh, sạc nhanh 45W, chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(4,4,'[\"128GB\", \"256GB\", \"512GB\"]','[8990000, 9990000, 10990000]',25,'https://cdn2.cellphones.com.vn/358x/media/catalog/product/s/a/sam-m54-m546-5g-8gb-256gb-dn-95.png','Samsung Galaxy M54 là smartphone tầm trung với nhiều ưu điểm nổi bật. Màn hình Super AMOLED 6.7 inch FHD+ tần số quét 120Hz. Vi xử lý Exynos 1380 mạnh mẽ trong phân khúc. Camera chính 108MP cho chất lượng ảnh sắc nét. Pin dung lượng lớn 6000mAh, sạc nhanh 25W. Hỗ trợ 5G, cảm biến vân tay cạnh viền.','[\"Black\", \"White\", \"Blue\"]',1),(5,5,'[\"128GB\", \"256GB\", \"512GB\"]','[5990000, 6990000, 7990000]',30,'https://images-na.ssl-images-amazon.com/images/I/61nlT53kRKL._SL1500_.jpg','iPhone X (iPhone 10) đánh dấu một bước ngoặt trong thiết kế của Apple. Màn hình OLED 5.8 inch viền siêu mỏng, Face ID bảo mật an toàn. Camera kép 12MP với khả năng chụp chân dung xóa phông. Chip A11 Bionic mạnh mẽ, RAM 3GB. Hỗ trợ sạc không dây, chống nước IP67. iOS được cập nhật thường xuyên.','[\"Black\", \"White\", \"Blue\"]',1),(6,6,'[\"128GB\", \"256GB\", \"512GB\"]','[21990000, 24990000, 27990000]',50,'https://cdn2.cellphones.com.vn/insecure/rs:fill:358:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/p/iphone-15-plus_1_.png','iPhone 15 sở hữu thiết kế Dynamic Island, màn hình OLED 6.1 inch sắc nét. Camera chính 48MP cho khả năng chụp ảnh chuyên nghiệp. Chip A16 Bionic mạnh mẽ, cổng USB-C đa năng. Hỗ trợ sạc nhanh 20W và sạc không dây MagSafe 15W. Face ID bảo mật cao cấp, khả năng chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(7,7,'[\"128GB\", \"256GB\", \"512GB\"]','[19990000, 22990000, 25990000]',50,'https://www.apple.com/newsroom/images/product/iphone/geo/Apple-iPhone-14-Pro-iPhone-14-Pro-Max-deep-purple-220907-geo_inline.jpg.large.jpg','iPhone 14 Pro Max nổi bật với Dynamic Island độc đáo, màn hình OLED 6.7 inch ProMotion 120Hz. Camera chính 48MP, chip A16 Bionic, ram 6GB. Hỗ trợ 5G, sạc nhanh 20W và MagSafe. Tính năng phát hiện va chạm thông minh, pin dung lượng lớn cho thời gian sử dụng lâu dài.','[\"Black\", \"White\", \"Blue\"]',1),(8,8,'[\"128GB\", \"256GB\", \"512GB\"]','[16990000, 19990000, 22990000]',50,'https://m.media-amazon.com/images/I/619f09kK7tL._AC_UF1000,1000_QL80_.jpg','iPhone 14 với màn hình OLED 6.1 inch sắc nét, chip A15 Bionic mạnh mẽ. Camera kép 12MP với chế độ Action Mode mới. Hỗ trợ 5G, sạc nhanh 20W và MagSafe 15W. Face ID an toàn, khả năng chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(9,9,'[\"128GB\", \"256GB\", \"512GB\"]','[15990000, 18990000, 21990000]',50,'https://th.bing.com/th/id/R.540af3eace63949647d4202cfb56db5e?rik=ZBAAqkANz0fW9g&pid=ImgRaw&r=0','iPhone 13 Pro Max với màn hình OLED 6.7 inch ProMotion 120Hz siêu mượt. Camera chính 12MP, chip A15 Bionic mạnh mẽ. Hỗ trợ 5G, sạc nhanh 20W và MagSafe 15W. Face ID bảo mật, chống nước IP68. Pin lớn cho thời gian sử dụng kéo dài.','[\"Black\", \"White\", \"Blue\"]',1),(10,10,'[\"128GB\", \"256GB\", \"512GB\"]','[13990000, 15990000, 17990000]',50,'https://img2.cgtrader.com/items/4402346/087f324611/iphone-13-pro-max-alpine-green-3d-model-087f324611.jpg','iPhone 13 được trang bị màn hình OLED 6.1 inch sắc nét, chip A15 Bionic. Camera kép 12MP với chế độ chụp đêm tốt. Hỗ trợ 5G, sạc nhanh 20W và MagSafe. Face ID an toàn, chống nước IP68. Pin được nâng cấp cho thời gian sử dụng lâu hơn.','[\"Black\", \"White\", \"Blue\"]',1),(11,11,'[\"128GB\", \"256GB\", \"512GB\"]','[9990000, 11990000, 13990000]',50,'https://assets.thehansindia.com/h-upload/2022/10/14/1316355-iphone-se-4.jpg','iPhone SE (2020) với thiết kế nhỏ gọn, màn hình Retina HD 4.7 inch. Chip A13 Bionic mạnh mẽ, Touch ID bảo mật. Camera 12MP với Portrait mode và Smart HDR. Hỗ trợ sạc nhanh và sạc không dây, chống nước IP67.','[\"Black\", \"White\", \"Blue\"]',1),(12,12,'[\"128GB\", \"256GB\", \"512GB\"]','[16990000, 18990000, 20990000]',50,'https://th.bing.com/th/id/R.ca22d1ba23f974f3d67fa5c96d74777a?rik=FLjgVzFZkrDeVg&pid=ImgRaw&r=0','iPhone 12 Pro Max với màn hình OLED 6.7 inch Super Retina XDR. Camera chính 12MP, chip A14 Bionic 5nm. Hỗ trợ 5G, MagSafe và sạc nhanh 20W. Face ID bảo mật, khung thép không gỉ cao cấp. Chống nước IP68, pin dung lượng lớn.','[\"Black\", \"White\", \"Blue\"]',1),(13,13,'[\"128GB\", \"256GB\", \"512GB\"]','[14990000, 16990000, 18990000]',50,'https://th.bing.com/th/id/R.3d277ac3119d43b9affca9555d095bd8?rik=DIiegIPw8eTKaA&pid=ImgRaw&r=0','iPhone 12 với màn hình OLED 6.1 inch Super Retina XDR. Camera kép 12MP hỗ trợ chụp đêm Night mode. Chip A14 Bionic, hỗ trợ 5G và MagSafe. Khung nhôm bền bỉ, mặt kính Ceramic Shield. Chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(14,14,'[\"128GB\", \"256GB\", \"512GB\"]','[17990000, 19990000, 22990000]',50,'https://th.bing.com/th/id/OIP.ToG0eftU4Zu6q_rmBnyPHQHaHa?rs=1&pid=ImgDetMain','iPhone 11 Pro với màn hình OLED Super Retina XDR 5.8 inch. Hệ thống camera chuyên nghiệp ba ống kính 12MP (Ultra Wide, Wide và Telephoto). Chip A13 Bionic với Neural Engine thế hệ thứ 3. Face ID nâng cao, chống nước IP68. Pin lâu hơn 4 giờ so với iPhone XS.','[\"Black\", \"White\", \"Blue\"]',1),(15,15,'[\"128GB\", \"256GB\", \"512GB\"]','[22990000, 24990000, 27990000]',50,'https://th.bing.com/th/id/OIP.LEB56rBLSVyxzD9gY-wCnQHaE8?rs=1&pid=ImgDetMain','Samsung Galaxy S21 Ultra với màn hình Dynamic AMOLED 2X 6.8 inch WQHD+. Camera chính 108MP, zoom quang học 10x, không gian zoom 100x. Chip Exynos 2100 5nm mạnh mẽ. Hỗ trợ bút S Pen, pin 5000mAh với sạc nhanh 25W. Chống nước IP68, màn hình 120Hz.','[\"Black\", \"White\", \"Blue\"]',1),(16,16,'[\"128GB\", \"256GB\", \"512GB\"]','[26990000, 28990000, 31990000]',50,'https://th.bing.com/th/id/R.77fdfb2090ca2cf28f5226a2bd891489?rik=dXNuAaZJm9O1Vg&pid=ImgRaw&r=0','Samsung Galaxy S23 Ultra được trang bị màn hình Dynamic AMOLED 2X 6.8 inch QHD+, tần số quét 120Hz. Camera 200MP đột phá, zoom quang học 10x. Snapdragon 8 Gen 2 cho Galaxy cực mạnh. S Pen tích hợp, pin 5000mAh, sạc nhanh 45W. Chống nước IP68, khung viền Armor Aluminum.','[\"Black\", \"White\", \"Blue\"]',1),(17,17,'[\"128GB\", \"256GB\", \"512GB\"]','[23990000, 25990000, 28990000]',50,'https://th.bing.com/th/id/OIP.XwJ889hbrMie6iA452AivgHaE7?rs=1&pid=ImgDetMain','Samsung Galaxy S22 Ultra với màn hình Dynamic AMOLED 2X 6.8 inch QHD+. Camera chính 108MP, zoom quang học 10x. Snapdragon 8 Gen 1 mạnh mẽ. Bút S Pen tích hợp, pin 5000mAh với sạc nhanh 45W. Khung viền Armor Aluminum, chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(18,18,'[\"128GB\", \"256GB\", \"512GB\"]','[35990000, 37990000, 40990000]',50,'https://th.bing.com/th/id/OIP.J0Ldx8MKFWfajR-lygpOTwHaEJ?rs=1&pid=ImgDetMain','Samsung Galaxy Z Fold 5 với màn hình gập Dynamic AMOLED 2X 7.6 inch bên trong và màn hình ngoài 6.2 inch. Snapdragon 8 Gen 2, RAM 12GB. Camera sau ba ống kính 50MP. Bản lề Flex mới, mỏng hơn. Pin 4400mAh, sạc nhanh 25W. Hỗ trợ S Pen Fold Edition.','[\"Black\", \"White\", \"Blue\"]',1),(19,19,'[\"128GB\", \"256GB\", \"512GB\"]','[21990000, 23990000, 25990000]',50,'https://th.bing.com/th/id/OIP.J_QE8M_giCXhHObvar6VWQHaIC?rs=1&pid=ImgDetMain','Samsung Galaxy Z Flip 5 với thiết kế gập độc đáo, màn hình chính Dynamic AMOLED 2X 6.7 inch 120Hz và màn hình phụ 3.4 inch. Snapdragon 8 Gen 2, camera kép 12MP. Pin 3700mAh, sạc nhanh 25W. Chống nước IPX8, khung nhôm Armor Aluminum.','[\"Black\", \"White\", \"Blue\"]',1),(20,20,'[\"128GB\", \"256GB\", \"512GB\"]','[15990000, 17990000, 19990000]',50,'https://th.bing.com/th/id/OIP.lZ7nn0Vcatsp7ox5MElAlgHaHa?rs=1&pid=ImgDetMain','Xiaomi 13 với màn hình AMOLED 6.36 inch FHD+ 120Hz. Camera Leica 50MP, chip Snapdragon 8 Gen 2. Sạc nhanh 67W, pin 4500mAh. Thiết kế cao cấp với khung viền kim loại, mặt lưng kính. Chống nước IP68, hỗ trợ 5G.','[\"Black\", \"White\", \"Blue\"]',1),(21,21,'[\"128GB\", \"256GB\", \"512GB\"]','[7990000, 8990000, 9990000]',50,'https://th.bing.com/th/id/OIP.zpWblUZfFV5z0cylH98TCAHaHa?rs=1&pid=ImgDetMain','Xiaomi Redmi K40 với màn hình AMOLED E4 6.67 inch 120Hz. Chip Snapdragon 870 5G mạnh mẽ. Camera chính 48MP, pin 4520mAh hỗ trợ sạc nhanh 33W. Thiết kế premium với khung kim loại và mặt lưng kính.','[\"Black\", \"White\", \"Blue\"]',1),(22,22,'[\"128GB\", \"256GB\", \"512GB\"]','[13990000, 15990000, 17990000]',50,'https://th.bing.com/th/id/OIP.T3KcYKuETNuk6fkCRGhFVgHaHa?rs=1&pid=ImgDetMain','Xiaomi Mi 11 với màn hình AMOLED 6.81 inch WQHD+ 120Hz. Camera chính 108MP, chip Snapdragon 888. Sạc nhanh 55W có dây và 50W không dây. Pin 4600mAh, cảm biến vân tay dưới màn hình. Loa kép Harman Kardon.','[\"Black\", \"White\", \"Blue\"]',1),(23,23,'[\"128GB\", \"256GB\", \"512GB\"]','[4990000, 5990000, 6990000]',50,'https://th.bing.com/th/id/OIP.q_q278okRf-hfq1QiDE9ogHaHa?rs=1&pid=ImgDetMain','Xiaomi Redmi Note 10 với màn hình Super AMOLED 6.43 inch FHD+. Camera chính 48MP, chip Snapdragon 678. Pin 5000mAh, sạc nhanh 33W. Thiết kế hiện đại với mặt lưng gradient, cảm biến vân tay cạnh viền.','[\"Black\", \"White\", \"Blue\"]',1),(24,24,'[\"128GB\", \"256GB\", \"512GB\"]','[11990000, 13990000, 15990000]',50,'https://th.bing.com/th/id/OIP.4IHGiDbH4tKydednw6iKRgHaIh?rs=1&pid=ImgDetMain','Xiaomi Mi 10 với màn hình AMOLED 6.67 inch FHD+ 90Hz. Camera chính 108MP, chip Snapdragon 865. Pin 4780mAh với sạc nhanh 30W. Thiết kế cao cấp với khung kim loại và mặt lưng kính cong 3D.','[\"Black\", \"White\", \"Blue\"]',1),(25,25,'[\"128GB\", \"256GB\", \"512GB\"]','[4490000, 5490000, 6490000]',50,'https://th.bing.com/th/id/R.fe7e10b52655d592231e882721ac9401?rik=GgsXzZx3sWv4Hw&pid=ImgRaw&r=0','OPPO A54 với màn hình LCD 6.51 inch HD+. Camera chính 13MP, chip MediaTek Helio P35. Pin 5000mAh, sạc nhanh 18W. Thiết kế hiện đại với mặt lưng gradient, cảm biến vân tay cạnh viền.','[\"Black\", \"White\", \"Blue\"]',1),(26,26,'[\"128GB\", \"256GB\", \"512GB\"]','[5990000, 6990000, 7990000]',50,'https://th.bing.com/th/id/R.430a955a73c258ca4f8a163b4b4d5b0c?rik=EUN443OrNzm%2byg&pid=ImgRaw&r=0','OPPO F19 với màn hình AMOLED 6.43 inch FHD+. Camera chính 48MP, chip Snapdragon 662. Pin 5000mAh, sạc nhanh VOOC 4.0 33W. Thiết kế mỏng nhẹ với độ dày chỉ 7.95mm.','[\"Black\", \"White\", \"Blue\"]',1),(27,27,'[\"128GB\", \"256GB\", \"512GB\"]','[8990000, 9990000, 10990000]',50,'https://th.bing.com/th/id/R.c63346ff8ad30283b36a1025e3a91912?rik=UGHqosv22RopSg&pid=ImgRaw&r=0','OPPO Reno6 với màn hình AMOLED 6.43 inch FHD+ 90Hz. Camera chính 64MP, chip MediaTek Dimensity 900. Sạc siêu nhanh SuperVOOC 2.0 65W, pin 4300mAh. Thiết kế Reno Glow độc quyền.','[\"Black\", \"White\", \"Blue\"]',1),(28,28,'[\"128GB\", \"256GB\", \"512GB\"]','[18990000, 20990000, 22990000]',50,'https://th.bing.com/th/id/R.da6682ed3484b6399a3c842cbb9df452?rik=gZwUcWdCPqOXVA&pid=ImgRaw&r=0','OPPO Find X3 Pro với màn hình LTPO AMOLED 6.7 inch QHD+ 120Hz. Camera chính 50MP với cảm biến Sony IMX766. Chip Snapdragon 888, sạc siêu nhanh SuperVOOC 2.0 65W. Thiết kế độc đáo với cụm camera tích hợp liền mạch.','[\"Black\", \"White\", \"Blue\"]',1),(29,29,'[\"128GB\", \"256GB\", \"512GB\"]','[4990000, 5990000, 6990000]',50,'https://th.bing.com/th/id/OIP.K7zSQSmGGbDcpKm5FnB6YwHaHa?rs=1&pid=ImgDetMain','OPPO A74 với màn hình AMOLED 6.43 inch FHD+. Camera chính 48MP, chip Snapdragon 662. Pin 5000mAh với sạc nhanh VOOC 4.0 33W. Thiết kế hiện đại với cảm biến vân tay trong màn hình.','[\"Black\", \"White\", \"Blue\"]',1),(30,30,'[\"128GB\", \"256GB\", \"512GB\"]','[27990000, 30990000, 33990000]',50,'https://th.bing.com/th/id/OIP.iZL4Hsf64NGzD15MWyX2FwHaEK?rs=1&pid=ImgDetMain','iPhone 16 với màn hình OLED 6.1 inch, hỗ trợ ProMotion 120Hz. Camera kép 48MP với công nghệ xử lý hình ảnh tiên tiến. Chip A18 thế hệ mới, hỗ trợ 5G. Face ID nâng cấp, khả năng chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(31,31,'[\"128GB\", \"256GB\", \"512GB\"]','[12990000, 14990000, 16990000]',50,'https://th.bing.com/th/id/OIP.rdcYuV1EKBG6BASF6_s4TAHaIw?rs=1&pid=ImgDetMain','iPhone 11 với màn hình Liquid Retina HD 6.1 inch. Camera kép 12MP với Night mode và Deep Fusion. Chip A13 Bionic, Face ID thế hệ mới. Chống nước IP68, pin lâu hơn iPhone XR một giờ.','[\"Black\", \"White\", \"Blue\"]',1),(32,32,'[\"128GB\", \"256GB\", \"512GB\"]','[31990000, 34990000, 37990000]',50,'https://static1.xdaimages.com/wordpress/wp-content/uploads/2023/09/iphone-16-pro-hero-page.jpg','iPhone 16 Pro với màn hình OLED 6.1 inch ProMotion. Camera Pro 48MP với zoom quang học 5x. Chip A18 Pro, RAM 8GB. Face ID nâng cấp, khung Titanium aerospace. Hỗ trợ 5G, sạc nhanh 27W.','[\"Black\", \"White\", \"Blue\"]',1),(33,33,'[\"128GB\", \"256GB\", \"512GB\"]','[25990000, 28990000, 31990000]',50,'https://th.bing.com/th/id/OIP.Os0WqIDOueg1-hh--obZlgHaHa?rs=1&pid=ImgDetMain','iPhone 16 Mini với màn hình OLED 5.4 inch compact. Camera kép 48MP, chip A18. Face ID thế hệ mới, khả năng chống nước IP68. Pin được nâng cấp cho thời lượng sử dụng tốt hơn.','[\"Black\", \"White\", \"Blue\"]',1),(34,34,'[\"128GB\", \"256GB\", \"512GB\"]','[3990000, 4990000, 5990000]',50,'https://th.bing.com/th/id/OIP.sKL95beS4oNP2xuHvZPPxgHaHu?rs=1&pid=ImgDetMain','iPhone 6 với màn hình Retina HD 4.7 inch. Camera 8MP iSight với True Tone flash. Chip A8 với đồ họa M8, Touch ID thế hệ đầu. Thiết kế unibody kim loại nguyên khối.','[\"Black\", \"White\", \"Blue\"]',1),(35,35,'[\"128GB\", \"256GB\", \"512GB\"]','[24990000, 27990000, 30990000]',50,'https://static1.xdaimages.com/wordpress/wp-content/uploads/2023/09/iphone-15-plus-black.png','iPhone 15 Plus với màn hình OLED 6.7 inch. Camera kép 48MP với Photonic Engine. Chip A16 Bionic, Dynamic Island. USB-C, MagSafe, Face ID nâng cấp. Pin lớn cho thời gian sử dụng lên đến 26 giờ.','[\"Black\", \"White\", \"Blue\"]',1),(36,36,'[\"128GB\", \"256GB\", \"512GB\"]','[35990000, 38990000, 41990000]',50,'https://cdn-uploads.gameblog.fr/img/news/419501_6412f28d2c3e0.jpg','iPhone 15 Ultra với màn hình OLED 6.7 inch ProMotion. Camera Pro 48MP, zoom quang 5x. Chip A17 Pro, RAM 8GB. Khung Titanium, cổng USB-C tốc độ cao. Face ID nâng cấp, pin dung lượng lớn.','[\"Black\", \"White\", \"Blue\"]',1),(37,37,'[\"128GB\", \"256GB\", \"512GB\"]','[27990000, 30990000, 33990000]',50,'https://th.bing.com/th/id/OIP.47hlW2Nbq3iVwQlk8oCktAHaHa?rs=1&pid=ImgDetMain','iPhone 15 Pro với màn hình OLED 6.1 inch ProMotion. Camera Pro 48MP, chip A17 Pro. Khung Titanium, USB-C. Dynamic Island, Face ID nâng cấp. Hỗ trợ 5G, sạc nhanh 20W.','[\"Black\", \"White\", \"Blue\"]',1),(38,38,'[\"128GB\", \"256GB\", \"512GB\"]','[25990000, 28990000, 31990000]',50,'https://th.bing.com/th/id/OIP.f0TxVuQRnOhEoQq9JCmlzwHaHa?rs=1&pid=ImgDetMain','iPhone 15 Max với màn hình OLED 6.7 inch. Camera 48MP nâng cấp, chip A16 Bionic. Dynamic Island, Face ID thế hệ mới. Pin dung lượng lớn, sạc nhanh 20W và MagSafe 15W.','[\"Black\", \"White\", \"Blue\"]',1),(39,39,'[\"128GB\", \"256GB\", \"512GB\"]','[14990000, 16990000, 18990000]',50,'https://th.bing.com/th/id/OIP.PSd6wxGdQ7mv_KlVXQlb2AHaHa?rs=1&pid=ImgDetMain','iPhone 12 với màn hình OLED Super Retina XDR 6.1 inch. Camera kép 12MP với Night mode. Chip A14 Bionic 5nm, 5G. MagSafe, Ceramic Shield. Khung nhôm aerospace-grade.','[\"Black\", \"White\", \"Blue\"]',1),(40,40,'[\"128GB\", \"256GB\", \"512GB\"]','[3990000, 4990000, 5990000]',50,'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/5580/5580420cv11d.jpg','iPhone 7 với màn hình Retina HD 4.7 inch. Camera 12MP với OIS, chip A10 Fusion. Touch ID thế hệ 2, chống nước IP67. Loa stereo, không có jack cắm tai nghe 3.5mm.','[\"Black\", \"White\", \"Blue\"]',1),(41,41,'[\"128GB\", \"256GB\", \"512GB\"]','[4990000, 5990000, 6990000]',50,'https://bvtmobile.com/uploads/source/galaxy-s23/samsung-galaxy-s23.jpg','iPhone 8 với màn hình Retina HD 4.7 inch. Camera 12MP cải tiến, chip A11 Bionic. Touch ID, sạc không dây Qi. Mặt lưng kính, khung nhôm aerospace-grade.','[\"Black\", \"White\", \"Blue\"]',1),(42,42,'[\"128GB\", \"256GB\", \"512GB\"]','[19990000, 21990000, 23990000]',50,'https://th.bing.com/th/id/OIP.7vFBpzMCG1zVt8NLEKvLQQHaEo?rs=1&pid=ImgDetMain','Samsung Galaxy S23 với màn hình Dynamic AMOLED 2X 6.1 inch FHD+ 120Hz. Camera 50MP, Snapdragon 8 Gen 2. Pin 3900mAh, sạc nhanh 25W. Thiết kế cao cấp với khung Armor Aluminum.','[\"Black\", \"White\", \"Blue\"]',1),(43,43,'[\"128GB\", \"256GB\", \"512GB\"]','[16990000, 18990000, 20990000]',50,'https://th.bing.com/th/id/R.eef141a733021b5cd5b7c34b10abcb41?rik=NpOpeWuHJiNsNQ&pid=ImgRaw&r=0','Samsung Galaxy S22 với màn hình Dynamic AMOLED 2X 6.1 inch FHD+ 120Hz. Camera chính 50MP, chip Snapdragon 8 Gen 1. Pin 3700mAh, sạc nhanh 25W. Thiết kế cao cấp với khung Armor Aluminum, chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(44,44,'[\"128GB\", \"256GB\", \"512GB\"]','[14990000, 16990000, 18990000]',50,'https://th.bing.com/th/id/OIP.LbT09pc2hoeFts6QwQ3jugHaEK?rs=1&pid=ImgDetMain','Samsung Galaxy S21 với màn hình Dynamic AMOLED 2X 6.2 inch FHD+ 120Hz. Camera chính 64MP, chip Exynos 2100. Pin 4000mAh với sạc nhanh 25W. Thiết kế contour-cut độc đáo, chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(45,45,'[\"128GB\", \"256GB\", \"512GB\"]','[12990000, 14990000, 16990000]',50,'https://th.bing.com/th/id/OIP.ctNOCPucChyQ6Lrmx0r6ogHaE8?rs=1&pid=ImgDetMain','Samsung Galaxy S20 với màn hình Dynamic AMOLED 2X 6.2 inch QHD+ 120Hz. Camera chính 12MP, zoom quang học 3x. Chip Exynos 990, RAM 8GB. Pin 4000mAh, sạc nhanh 25W. Chống nước IP68.','[\"Black\", \"White\", \"Blue\"]',1),(46,46,'[\"128GB\", \"256GB\", \"512GB\"]','[2990000, 3490000, 3990000]',50,'https://th.bing.com/th/id/OIP.IFOC1AXjSOssw089WM5XYQHaIW?rs=1&pid=ImgDetMain','Samsung Galaxy S5 với màn hình Super AMOLED 5.1 inch Full HD. Camera 16MP với Auto Focus. Chip Snapdragon 801, RAM 2GB. Pin 2800mAh có thể tháo rời. Cảm biến vân tay, chống nước IP67.','[\"Black\", \"White\", \"Blue\"]',1),(47,47,'[\"128GB\", \"256GB\", \"512GB\"]','[6990000, 7990000, 8990000]',50,'https://th.bing.com/th/id/OIP.qPkPDRGKJ1scXrhsgRzJFAAAAA?rs=1&pid=ImgDetMain','Samsung Galaxy M34 với màn hình Super AMOLED 6.5 inch FHD+ 120Hz. Camera chính 50MP, chip Exynos 1280. Pin 6000mAh, sạc nhanh 25W. Thiết kế hiện đại với cảm biến vân tay cạnh viền.','[\"Black\", \"White\", \"Blue\"]',1),(48,48,'[\"128GB\", \"256GB\", \"512GB\"]','[7990000, 8990000, 9990000]',50,'https://th.bing.com/th/id/OIP.4P8ekB8VyWLz79uP6yhvhwHaHa?rs=1&pid=ImgDetMain','Samsung Galaxy M35 với màn hình Super AMOLED 6.6 inch FHD+ 120Hz. Camera chính 64MP, chip Exynos 1380. Pin 6000mAh với sạc nhanh 25W. Thiết kế mỏng nhẹ, hỗ trợ 5G.','[\"Black\", \"White\", \"Blue\"]',1),(49,49,'[\"128GB\", \"256GB\", \"512GB\"]','[4990000, 5990000, 6990000]',50,'https://th.bing.com/th/id/OIP.4P8ekB8VyWLz79uP6yhvhwHaHa?rs=1&pid=ImgDetMain','Samsung Galaxy M13 với màn hình LCD 6.6 inch FHD+. Camera chính 50MP, chip Exynos 850. Pin 6000mAh, sạc 15W. Thiết kế trẻ trung với nhiều màu sắc, cảm biến vân tay cạnh viền.','[\"Black\", \"White\", \"Blue\"]',1),(50,50,'[\"128GB\", \"256GB\", \"512GB\"]','[4490000, 5490000, 6490000]',50,'https://th.bing.com/th/id/OIP.eAPZM8OHR4JdlO9cFrIFzAHaH4?rs=1&pid=ImgDetMain','Samsung Galaxy M30s với màn hình Super AMOLED 6.4 inch FHD+. Camera chính 48MP, chip Exynos 9611. Pin siêu khủng 6000mAh, sạc nhanh 15W. Thiết kế gradient bắt mắt.','[\"Black\", \"White\", \"Blue\"]',1),(51,51,'[\"128GB\", \"256GB\", \"512GB\"]','[3990000, 4990000, 5990000]',50,'https://th.bing.com/th/id/R.702fdec3752f75068def81d32f04456e?rik=MoLY2HxvNgCs4g&pid=ImgRaw&r=0','Samsung Galaxy M20 với màn hình LCD 6.3 inch FHD+. Camera kép 13MP + 5MP, chip Exynos 7904. Pin 5000mAh với sạc nhanh 15W. Thiết kế Infinity-V, cảm biến vân tay mặt lưng.','[\"Black\", \"White\", \"Blue\"]',1);
/*!40000 ALTER TABLE `ProductDetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Product_Views`
--

DROP TABLE IF EXISTS `Product_Views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Product_Views` (
  `view_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `viewer_name` varchar(100) DEFAULT NULL,
  `viewed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`view_id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `Product_Views_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `Product_Views_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product_Views`
--

LOCK TABLES `Product_Views` WRITE;
/*!40000 ALTER TABLE `Product_Views` DISABLE KEYS */;
/*!40000 ALTER TABLE `Product_Views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Products`
--

DROP TABLE IF EXISTS `Products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `Products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `Categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Products`
--

LOCK TABLES `Products` WRITE;
/*!40000 ALTER TABLE `Products` DISABLE KEYS */;
INSERT INTO `Products` VALUES (1,5,'iPhone 16 Pro Max','2025-01-12 08:54:02'),(2,6,'iPhone 15 Pro Max','2025-01-12 08:54:02'),(3,7,'Samsung Galaxy S24 Ultra','2025-01-12 08:54:02'),(4,8,'Samsung Galaxy M54','2025-01-12 08:54:02'),(5,1,'iPhone 10','2023-09-22 00:00:00'),(6,1,'iPhone 15','2023-09-22 00:00:00'),(7,1,'iPhone 14 Pro Max','2022-09-14 00:00:00'),(8,1,'iPhone 14','2022-09-14 00:00:00'),(9,1,'iPhone 13 Pro Max','2021-09-14 00:00:00'),(10,1,'iPhone 13','2021-09-14 00:00:00'),(11,1,'iPhone SE','2020-04-15 00:00:00'),(12,1,'iPhone 12 Pro Max','2020-10-23 00:00:00'),(13,1,'iPhone 12','2020-10-23 00:00:00'),(14,1,'iPhone 11 Pro','2019-09-20 00:00:00'),(15,2,'Samsung Galaxy S21 Ultra','2024-01-17 00:00:00'),(16,2,'Samsung Galaxy S23 Ultra','2023-02-01 00:00:00'),(17,2,'Samsung Galaxy S22 Ultra','2022-02-09 00:00:00'),(18,2,'Samsung Galaxy Z Fold 5','2023-07-26 00:00:00'),(19,2,'Samsung Galaxy Z Flip 5','2023-07-26 00:00:00'),(20,3,'Xiaomi Mi 13','2023-02-01 00:00:00'),(21,3,'Xiaomi Redmi K40','2021-02-25 00:00:00'),(22,3,'Xiaomi Mi 11','2021-01-01 00:00:00'),(23,3,'Xiaomi Redmi Note 10','2021-03-04 00:00:00'),(24,3,'Xiaomi Mi 10','2020-02-13 00:00:00'),(25,4,'Oppo A54','2021-02-22 00:00:00'),(26,4,'Oppo F19','2021-04-08 00:00:00'),(27,4,'Oppo Reno6','2018-12-05 00:00:00'),(28,4,'Oppo Find X3 Pro','2020-09-22 00:00:00'),(29,4,'Oppo A74','2019-02-24 00:00:00'),(30,5,'iPhone 16','2024-09-22 00:00:00'),(31,5,'iPhone 11','2024-09-22 00:00:00'),(32,5,'iPhone 16 Pro','2024-09-22 00:00:00'),(33,5,'iPhone 16 Mini','2024-09-22 00:00:00'),(34,5,'iPhone 6','2024-09-22 00:00:00'),(35,6,'iPhone 15 Plus','2023-09-22 00:00:00'),(36,6,'iPhone 15 Ultra','2023-09-22 00:00:00'),(37,6,'iPhone 15 Pro','2023-09-22 00:00:00'),(38,6,'iPhone 15 Max','2023-09-22 00:00:00'),(39,6,'iPhone 12','2023-09-22 00:00:00'),(40,6,'iPhone 7','2023-09-22 00:00:00'),(41,6,'iPhone 8','2023-09-22 00:00:00'),(42,7,'Samsung Galaxy S23','2023-02-01 00:00:00'),(43,7,'Samsung Galaxy S22','2022-02-09 00:00:00'),(44,7,'Samsung Galaxy S21','2021-01-14 00:00:00'),(45,7,'Samsung Galaxy S20','2020-03-06 00:00:00'),(46,7,'Samsung Galaxy S5','2014-04-11 00:00:00'),(47,8,'Samsung Galaxy M34','2023-02-01 00:00:00'),(48,8,'Samsung Galaxy M35','2023-03-01 00:00:00'),(49,8,'Samsung Galaxy M13','2022-07-14 00:00:00'),(50,8,'Samsung Galaxy M30s','2019-09-18 00:00:00'),(51,8,'Samsung Galaxy M20','2019-02-01 00:00:00');
/*!40000 ALTER TABLE `Products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reviews`
--

DROP TABLE IF EXISTS `Reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `Reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `Reviews_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reviews`
--

LOCK TABLES `Reviews` WRITE;
/*!40000 ALTER TABLE `Reviews` DISABLE KEYS */;
INSERT INTO `Reviews` VALUES (1,2,1,5,'Amazing phone! Great camera and battery life.','2025-01-12 08:54:03');
/*!40000 ALTER TABLE `Reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `unique_email` (`email`),
  UNIQUE KEY `unique_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'admin','admin123','admin1@example.com','Admin','0123457789','123 Admin','2025-01-12 08:54:02'),(2,'user1','user123','user1@example.com','User One','0987654321','456 User St','2025-01-12 08:54:02'),(3,'user2','user456','user2@example.com','User Two','0411111111','789 Customer','2025-01-12 08:54:02'),(8,'admin2','admin789','admin2@example.com','Admin User','0123456789','123 Admin St','2025-01-12 09:41:48'),(10,'admin8','admin789','admin8@example.com','Admin User','0123456784','123 Admin St','2025-01-12 13:34:06'),(12,'DxHoang','123456','Hoang@gmail.com','Đinh Xuân Hoàng1','0382657483','Huynh Tan Phat','2025-01-17 02:39:29'),(13,'h','123456','hx@gmail.com','hoang','0847595183',NULL,'2025-01-17 03:29:06'),(14,'hau','123456','hau@gmail.com','trinh phuc hau','0164885857',NULL,'2025-01-18 01:01:14'),(15,'phuchau','123456','hau1@gmail.com','trinh phuc hau','0392567375',NULL,'2025-01-18 03:06:09'),(21,'user3','123456','user3@example.com','a','0123456222','123 Huỳnh Tấn Phát','2025-01-20 17:25:16'),(23,'qbao1','quocbao123','0306221003@caothang.edu.vn','tranquocbao','0766926067',NULL,'2025-01-21 09:03:30'),(24,'qbao2','quocbao789','0306221004@caothang.edu.vn','tranquocbaohahaha','0766926068','65 Huynh Thuc Khang','2025-01-21 09:12:01');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Wishlist`
--

DROP TABLE IF EXISTS `Wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Wishlist` (
  `wishlist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wishlist_id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `Wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `Wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Wishlist`
--

LOCK TABLES `Wishlist` WRITE;
/*!40000 ALTER TABLE `Wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `Wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-21 20:04:40
