-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: refind_market
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  CONSTRAINT `fk_permission_content_type` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add user',6,'add_user'),(22,'Can change user',6,'change_user'),(23,'Can delete user',6,'delete_user'),(24,'Can view user',6,'view_user'),(25,'Can add item',7,'add_item'),(26,'Can change item',7,'change_item'),(27,'Can delete item',7,'delete_item'),(28,'Can view item',7,'view_item'),(29,'Can add order',8,'add_order'),(30,'Can change order',8,'change_order'),(31,'Can delete order',8,'delete_order'),(32,'Can view order',8,'view_order');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_admin_log_content_type` (`content_type_id`),
  KEY `fk_admin_log_user` (`user_id`),
  CONSTRAINT `fk_admin_log_content_type` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `fk_admin_log_user` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'contenttypes','contenttype'),(7,'listings','item'),(8,'orders','order'),(5,'sessions','session'),(6,'users','user');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'users','0001_initial','2026-01-07 06:35:08.267558'),(2,'contenttypes','0001_initial','2026-01-07 06:35:08.296809'),(3,'admin','0001_initial','2026-01-07 06:35:08.302369'),(4,'admin','0002_logentry_remove_auto_add','2026-01-07 06:35:08.306812'),(5,'admin','0003_logentry_add_action_flag_choices','2026-01-07 06:35:08.310698'),(6,'contenttypes','0002_remove_content_type_name','2026-01-07 06:35:08.314873'),(7,'auth','0001_initial','2026-01-07 06:35:08.318166'),(8,'auth','0002_alter_permission_name_max_length','2026-01-07 06:35:08.322473'),(9,'auth','0003_alter_user_email_max_length','2026-01-07 06:35:08.325656'),(10,'auth','0004_alter_user_username_opts','2026-01-07 06:35:08.330339'),(11,'auth','0005_alter_user_last_login_null','2026-01-07 06:35:08.333742'),(12,'auth','0006_require_contenttypes_0002','2026-01-07 06:35:08.337694'),(13,'auth','0007_alter_validators_add_error_messages','2026-01-07 06:35:08.341373'),(14,'auth','0008_alter_user_username_max_length','2026-01-07 06:35:08.350436'),(15,'auth','0009_alter_user_last_name_max_length','2026-01-07 06:35:08.353997'),(16,'auth','0010_alter_group_name_max_length','2026-01-07 06:35:08.358729'),(17,'auth','0011_update_proxy_permissions','2026-01-07 06:35:08.362693'),(18,'auth','0012_alter_user_first_name_max_length','2026-01-07 06:35:08.369768'),(19,'listings','0001_initial','2026-01-07 06:35:08.373859'),(20,'orders','0001_initial','2026-01-07 06:35:08.381218'),(21,'sessions','0001_initial','2026-01-07 06:35:08.386054');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` text NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('xjftlnf1kj2u5b6eyivjsu9rqydgve9q','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vdlk5:QsySghqhuGRmfshWlJDx2KE4fR1wul5on3J-WSkUMLM','2026-01-22 08:51:41');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings_item`
--

DROP TABLE IF EXISTS `listings_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seller_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `is_sold` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(255) DEFAULT NULL,
  `display_price` decimal(10,2) GENERATED ALWAYS AS ((`price` * 1.075)) STORED,
  `image1` varchar(100) DEFAULT NULL,
  `image2` varchar(100) DEFAULT NULL,
  `image3` varchar(100) DEFAULT NULL,
  `image4` varchar(100) DEFAULT NULL,
  `image5` varchar(100) DEFAULT NULL,
  `image6` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `suburb` varchar(100) DEFAULT NULL,
  `total_quantity` int DEFAULT '1',
  `quantity_sold` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `listings_item_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_item`
--

LOCK TABLES `listings_item` WRITE;
/*!40000 ALTER TABLE `listings_item` DISABLE KEYS */;
INSERT INTO `listings_item` (`id`, `seller_id`, `title`, `description`, `price`, `category`, `is_sold`, `created_at`, `image`, `image1`, `image2`, `image3`, `image4`, `image5`, `image6`, `region`, `city`, `suburb`, `total_quantity`, `quantity_sold`) VALUES (1,2,'Test','Test',10.00,'Fuun',1,'2026-01-07 05:36:17','default.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(2,2,'test3','',30.00,NULL,1,'2026-01-07 05:58:08','item_pics/8886ea17-f722-4957-b1e0-51b0bb76b422.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(4,2,'Test4','Test4',40.00,'Fun',1,'2026-01-07 08:19:12','item_pics/image_1.png','','','','','','',NULL,NULL,NULL,1,1),(5,2,'Test5','Test5',50.00,'Fun',1,'2026-01-07 08:23:23','default.jpg','','','','','','',NULL,NULL,NULL,1,1),(6,2,'test7','test',10.00,'Books',0,'2026-01-07 11:38:42','item_pics/Re-Find_logo2.png',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(7,2,'test8','Test8',100.00,'Sporting',0,'2026-01-07 11:40:04','item_pics/image001_zrL9e2q.png',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(8,2,'Test10','Test10',400.00,'Computing',0,'2026-01-07 11:45:24','item_pics/1000443214_1.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(9,2,'sf','sds',100.00,'Books',1,'2026-01-07 17:19:21','item_pics/Re-Find_logo.png','','','','','','',NULL,NULL,NULL,1,1),(10,2,'ddff','ddff',2.00,'Collectibles',1,'2026-01-07 17:20:04','item_pics/1000443215.jpg','','','','','','',NULL,NULL,NULL,1,1),(11,3,'Final Test','Final Test',300.00,'Collectibles',0,'2026-01-07 18:02:21','default.jpg','item_photos/image001_GZGECHn.png','item_photos/Re-Find_logo2_5ZBWgvP.png','','','','',NULL,NULL,NULL,1,0),(12,3,'Final Test2','Final Test2',3.00,'Books',1,'2026-01-07 18:03:19','default.jpg','item_photos/image001_jJxHpBz.png','item_photos/Screenshot_20250623_160941_0AQLFsH.jpg','item_photos/IMG_4892.jpeg','','','',NULL,NULL,NULL,1,1),(13,3,'gfd','gf',1.00,'Tools',1,'2026-01-07 18:16:54','default.jpg','item_photos/Screenshot_20250623_160941_ziT5llA.jpg','','','','','',NULL,NULL,NULL,1,1),(14,3,'asd','jhgf',4.00,'Collectibles',1,'2026-01-07 18:17:37','default.jpg','item_photos/Screenshot_2025-09-30_084634_1.png','item_photos/Screenshot_20251001_173153_com.google.android.apps.docs.jpg','','','','',NULL,NULL,NULL,1,1),(15,2,'WHAT','WHAT',50.00,'Appliances',1,'2026-01-08 11:13:33','default.jpg','item_photos/image001.jpg','item_photos/Screenshot_2025-09-30_084634_1_JwZO1Et.png','item_photos/Screenshot_20251001_173153_com_oBoqztH.google.android.apps.docs.jpg','','','',NULL,NULL,NULL,1,1),(16,2,'TEST QTY','TEST QTY',20.00,'Computing',1,'2026-01-08 17:22:01','default.jpg','item_photos/image.jpg','','','','','',NULL,NULL,NULL,2,2),(17,3,'CONTAINER LOOK','Check out Containers',200.00,'Collectibles',0,'2026-01-08 18:04:37','default.jpg','item_photos/8886ea17-f722-4957-b1e0-51b0bb76b422.jpg','','','','','','Western Cape','Cape Town','Durbanville',1,0),(18,3,'Rates 1','Rates 1',200.00,'Books',1,'2026-01-09 08:30:09','default.jpg','item_photos/8886ea17-f722-4957-b1e0-51b0bb76b422_jK3QreN.jpg','','','','','','Western Cape','Cape Town','Durbanville',1,1),(19,3,'Rates 2','Rates 2',200.00,'Books',0,'2026-01-09 08:30:41','default.jpg','item_photos/8886ea17-f722-4957-b1e0-51b0bb76b422_jmJHlMe.jpg','','','','','','Western Cape','Cape Town','Durbanville',1,0),(20,2,'Rates 3','Rates 3',200.00,'Computing',1,'2026-01-09 08:40:58','default.jpg','item_photos/Screenshot_2025-09-30_084634_1_ZvHAJkK.png','','','','','','Western Cape','Cape Town','Durbanville',1,1),(21,2,'Waybill test','Waybill test',1.00,'Tools',1,'2026-01-09 10:25:04','default.jpg','item_photos/Re-Find_logo2_tEDcfAN.png','','','','','','Western Cape','Cape Town','Durbanville',1,1),(22,2,'Waybill Test 2','Waybill Test 2',1.00,'Tools',1,'2026-01-09 10:31:11','default.jpg','item_photos/image_1.png','','','','','','Western Cape','Cape Town','Durbanville',1,1),(23,3,'WayBill Test 3','WayBill Test 3',1.00,'Tools',1,'2026-01-09 10:37:20','default.jpg','item_photos/image001_hd5yp6U.png','','','','','','Western Cape','Cape Town','Durbanville',1,1);
/*!40000 ALTER TABLE `listings_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings_itemimage`
--

DROP TABLE IF EXISTS `listings_itemimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings_itemimage` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_listings_itemimage_item` (`item_id`),
  CONSTRAINT `fk_listings_itemimage_item` FOREIGN KEY (`item_id`) REFERENCES `listings_item` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_itemimage`
--

LOCK TABLES `listings_itemimage` WRITE;
/*!40000 ALTER TABLE `listings_itemimage` DISABLE KEYS */;
INSERT INTO `listings_itemimage` VALUES (1,'item_photos/Re-Find_logo2.png',6),(2,'item_photos/image001.png',7),(3,'item_photos/1000443214_1.jpg',8),(4,'item_photos/Re-Find_logo.png',9),(5,'item_photos/1000443215.jpg',10),(6,'item_photos/Screenshot_20250623_160941_emwG4ob.jpg',13),(7,'item_photos/Screenshot_2025-09-30_084634_1_S1QCcgt.png',14),(8,'item_photos/Screenshot_20251001_173153_com_NMvkVd8.google.android.apps.docs.jpg',14),(9,'item_photos/image001_1RSOmpV.jpg',15),(10,'item_photos/Screenshot_2025-09-30_084634_1_rHtlHUI.png',15),(11,'item_photos/Screenshot_20251001_173153_com_GHZAtr7.google.android.apps.docs.jpg',15),(12,'item_photos/image_ivqUBF1.jpg',16),(13,'item_photos/8886ea17-f722-4957-b1e0-51b0bb76b422_dpOMQae.jpg',17),(14,'item_photos/8886ea17-f722-4957-b1e0-51b0bb76b422_0ok6DFC.jpg',18),(15,'item_photos/8886ea17-f722-4957-b1e0-51b0bb76b422_ACnrmjN.jpg',19),(16,'item_photos/Screenshot_2025-09-30_084634_1_35stl1r.png',20),(17,'item_photos/Re-Find_logo2_Bbr54hp.png',21),(18,'item_photos/image_1_MdPMASb.png',22),(19,'item_photos/image001_GKJSNqo.png',23);
/*!40000 ALTER TABLE `listings_itemimage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings_message`
--

DROP TABLE IF EXISTS `listings_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `item_id` int NOT NULL,
  `recipient_id` int NOT NULL,
  `sender_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_message_item` (`item_id`),
  KEY `fk_message_recipient` (`recipient_id`),
  KEY `fk_message_sender` (`sender_id`),
  CONSTRAINT `fk_message_item` FOREIGN KEY (`item_id`) REFERENCES `listings_item` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_message_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_message_sender` FOREIGN KEY (`sender_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_message`
--

LOCK TABLES `listings_message` WRITE;
/*!40000 ALTER TABLE `listings_message` DISABLE KEYS */;
INSERT INTO `listings_message` VALUES (1,'Good Day i like this item do you have more than 1?','2026-01-07 10:23:58.409589',1,5,2,3),(2,'Good Day','2026-01-08 05:59:18.617471',1,14,3,2),(3,'hi','2026-01-08 06:26:43.277960',1,14,3,2),(4,'hi','2026-01-08 08:17:45.887623',1,14,3,2);
/*!40000 ALTER TABLE `listings_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings_report`
--

DROP TABLE IF EXISTS `listings_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings_report` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reason` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `item_id` int NOT NULL,
  `reporter_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_report_item` (`item_id`),
  KEY `fk_report_reporter` (`reporter_id`),
  CONSTRAINT `fk_report_item` FOREIGN KEY (`item_id`) REFERENCES `listings_item` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_report_reporter` FOREIGN KEY (`reporter_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_report`
--

LOCK TABLES `listings_report` WRITE;
/*!40000 ALTER TABLE `listings_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `listings_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings_review`
--

DROP TABLE IF EXISTS `listings_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rating` int NOT NULL,
  `comment` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `order_id` int NOT NULL,
  `reviewer_id` int NOT NULL,
  `target_user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_review_order` (`order_id`),
  KEY `fk_review_reviewer` (`reviewer_id`),
  KEY `fk_review_target` (`target_user_id`),
  CONSTRAINT `fk_review_order` FOREIGN KEY (`order_id`) REFERENCES `orders_order` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_review_reviewer` FOREIGN KEY (`reviewer_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_review_target` FOREIGN KEY (`target_user_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_review`
--

LOCK TABLES `listings_review` WRITE;
/*!40000 ALTER TABLE `listings_review` DISABLE KEYS */;
INSERT INTO `listings_review` VALUES (1,5,'it was working','2026-01-07 10:07:41.714544',2,3,2),(2,2,'Working','2026-01-07 10:07:54.425635',1,3,2);
/*!40000 ALTER TABLE `listings_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings_supportchat`
--

DROP TABLE IF EXISTS `listings_supportchat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings_supportchat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_key` varchar(40) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_resolved` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_support_user` (`user_id`),
  CONSTRAINT `fk_support_user` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_supportchat`
--

LOCK TABLES `listings_supportchat` WRITE;
/*!40000 ALTER TABLE `listings_supportchat` DISABLE KEYS */;
/*!40000 ALTER TABLE `listings_supportchat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings_supportmessage`
--

DROP TABLE IF EXISTS `listings_supportmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings_supportmessage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_id` int NOT NULL,
  `sender_name` varchar(100) NOT NULL,
  `text` text NOT NULL,
  `is_admin_reply` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_message_chat` (`chat_id`),
  CONSTRAINT `fk_message_chat` FOREIGN KEY (`chat_id`) REFERENCES `listings_supportchat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_supportmessage`
--

LOCK TABLES `listings_supportmessage` WRITE;
/*!40000 ALTER TABLE `listings_supportmessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `listings_supportmessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_order`
--

DROP TABLE IF EXISTS `orders_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `buyer_id` int NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `bobgo_waybill` varchar(500) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `payment_ref` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `seller_id` int DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `quantity` int DEFAULT '1',
  `collection_street` varchar(255) DEFAULT NULL,
  `collection_city` varchar(100) DEFAULT NULL,
  `collection_suburb` varchar(100) DEFAULT NULL,
  `collection_postcode` varchar(10) DEFAULT NULL,
  `collection_province_code` varchar(10) DEFAULT 'GP',
  `delivery_street` varchar(255) DEFAULT NULL,
  `delivery_city` varchar(100) DEFAULT NULL,
  `delivery_postcode` varchar(10) DEFAULT NULL,
  `delivery_province_code` varchar(10) DEFAULT 'GP',
  `shipping_cost` decimal(10,2) DEFAULT '0.00',
  `bobgo_service_code` varchar(100) DEFAULT NULL,
  `parcel_weight` decimal(5,2) DEFAULT '1.00',
  `parcel_length` int DEFAULT '10',
  `parcel_width` int DEFAULT '10',
  `parcel_height` int DEFAULT '10',
  `preferred_method` varchar(50) DEFAULT 'any',
  `bobgo_provider_slug` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `fk_order_seller` (`seller_id`),
  CONSTRAINT `fk_order_seller` FOREIGN KEY (`seller_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `orders_order_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `listings_item` (`id`),
  CONSTRAINT `orders_order_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_order`
--

LOCK TABLES `orders_order` WRITE;
/*!40000 ALTER TABLE `orders_order` DISABLE KEYS */;
INSERT INTO `orders_order` VALUES (1,2,3,'paid',NULL,NULL,NULL,'2026-01-07 06:50:03',2,30.00,1,NULL,NULL,NULL,NULL,'GP',NULL,NULL,NULL,'GP',0.00,NULL,1.00,10,10,10,'any',NULL),(2,1,3,'paid',NULL,NULL,NULL,'2026-01-07 07:02:25',2,10.00,1,NULL,NULL,NULL,NULL,'GP',NULL,NULL,NULL,'GP',0.00,NULL,1.00,10,10,10,'any',NULL),(3,14,2,'paid',NULL,NULL,NULL,'2026-01-08 03:58:16',3,4.30,1,NULL,NULL,NULL,NULL,'GP',NULL,NULL,NULL,'GP',0.00,NULL,1.00,10,10,10,'any',NULL),(4,13,2,'paid',NULL,NULL,NULL,'2026-01-08 06:11:38',3,1.07,1,NULL,NULL,NULL,NULL,'GP',NULL,NULL,NULL,'GP',0.00,NULL,1.00,10,10,10,'any',NULL),(5,10,3,'paid',NULL,NULL,NULL,'2026-01-08 06:17:09',2,2.15,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',261.60,'ECO',20.00,30,40,20,'any',NULL),(6,4,3,'shipped',NULL,'UASS3QFP',NULL,'2026-01-08 06:46:17',2,43.00,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',104.36,'LOF',1.00,10,10,10,'door_to_door','sandbox'),(7,12,2,'paid',NULL,NULL,NULL,'2026-01-08 06:47:20',3,3.22,1,NULL,NULL,NULL,NULL,'GP',NULL,NULL,NULL,'GP',0.00,NULL,1.00,10,10,10,'any',NULL),(8,16,3,'paid',NULL,NULL,NULL,'2026-01-08 17:57:44',2,43.00,2,NULL,NULL,NULL,NULL,'GP',NULL,NULL,NULL,'GP',0.00,NULL,1.00,10,10,10,'any',NULL),(9,17,2,'shipping_set',NULL,NULL,NULL,'2026-01-08 18:16:31',3,215.00,1,'44 Minuet Ridge','C','Durbanville','7440','GP','0A Twist Street','Cape Town','7440','GP',86.27,'ECO',1.00,10,10,10,'any',NULL),(10,11,2,'pending_approval',NULL,NULL,NULL,'2026-01-09 07:35:38',3,322.50,1,NULL,NULL,NULL,NULL,'GP',NULL,NULL,NULL,'GP',0.00,NULL,1.00,10,10,10,'any',NULL),(11,17,2,'shipping_set',NULL,NULL,NULL,'2026-01-09 08:11:52',3,215.00,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',114.95,'ECO',20.00,30,40,20,'any',NULL),(12,15,3,'paid',NULL,NULL,NULL,'2026-01-09 08:23:46',2,53.75,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',114.95,'ECO',20.00,30,40,20,'any',NULL),(13,19,2,'accepted',NULL,NULL,NULL,'2026-01-09 08:30:54',3,215.00,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC',NULL,NULL,NULL,'GP',0.00,NULL,20.00,30,40,20,'any',NULL),(14,18,2,'paid',NULL,NULL,NULL,'2026-01-09 08:30:57',3,215.00,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',261.60,'ECO',20.00,30,40,20,'any',NULL),(15,20,3,'paid',NULL,NULL,NULL,'2026-01-09 08:41:13',2,215.00,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',86.27,'ECO',1.00,10,10,10,'any',NULL),(16,6,3,'accepted',NULL,NULL,NULL,'2026-01-09 08:56:18',2,10.75,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC',NULL,NULL,NULL,'GP',0.00,NULL,1.00,10,10,10,'pickup_point',NULL),(17,5,3,'paid',NULL,NULL,NULL,'2026-01-09 09:14:54',2,53.75,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',104.36,'LOF',1.00,10,10,10,'door_to_door',NULL),(18,9,3,'shipped',NULL,'UASD3NLJ',NULL,'2026-01-09 09:35:07',2,107.50,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',86.27,'ECO',1.00,10,10,10,'door_to_door','demo'),(19,21,3,'shipped',NULL,'UASS9GHS',NULL,'2026-01-09 10:25:21',2,1.07,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',114.95,'ECO',10.00,30,40,20,'door_to_door','sandbox'),(20,22,3,'shipped',NULL,'UASSSXW8',NULL,'2026-01-09 10:31:19',2,1.07,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',677.60,'LSX',10.00,20,30,20,'door_to_door','sandbox'),(21,23,2,'shipped',NULL,'UASSK8BN',NULL,'2026-01-09 10:37:25',3,1.07,1,'44 Minuet Ridge','Cape Town','Cape Town','7440','WC','0A Twist Street','Cape Town','7440','GP',114.95,'ECO',10.00,30,20,30,'door_to_door','sandbox');
/*!40000 ALTER TABLE `orders_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_user`
--

DROP TABLE IF EXISTS `users_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `password` varchar(128) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `first_name` varchar(150) DEFAULT NULL,
  `last_name` varchar(150) DEFAULT NULL,
  `is_staff` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `is_superuser` tinyint(1) DEFAULT '0',
  `last_login` datetime DEFAULT NULL,
  `date_joined` datetime DEFAULT NULL,
  `id_number` varchar(13) DEFAULT NULL,
  `is_dha_verified` tinyint(1) DEFAULT '0',
  `phone_number` varchar(15) DEFAULT NULL,
  `country` varchar(100) DEFAULT 'South Africa',
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `suburb` varchar(100) DEFAULT NULL,
  `terms_accepted` tinyint(1) NOT NULL DEFAULT '0',
  `terms_accepted_date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_user`
--

LOCK TABLES `users_user` WRITE;
/*!40000 ALTER TABLE `users_user` DISABLE KEYS */;
INSERT INTO `users_user` VALUES (2,'omega','pbkdf2_sha256$1000000$htwFVmgdGZtavaWVtMKn9T$T5hzR+hyB99u1s0OCNhntJwBI+dJR5/V8mO/tIshNP8=','','','',1,1,1,'2026-01-09 12:56:18','2026-01-07 06:59:06',NULL,0,NULL,'South Africa',NULL,NULL,NULL,0,NULL),(3,'Luano','pbkdf2_sha256$1000000$HcX2eNY9jziurxiaDEABcL$NgEy4gDUoQ471wzAObfiEZw8qKjUDz40SJSS+l3jrjA=','luanoveck@gmail.com','Luano','van Eck',0,1,0,'2026-01-09 12:55:13','2026-01-07 08:13:28','1234566789000',0,'0833803942','South Africa',NULL,NULL,NULL,0,NULL),(4,'Alpha','pbkdf2_sha256$1000000$VAzamjVXCDLUHIC1KMa0WY$31gq+FUyuuYoRf3D5x8zGST5A3VaxlZadlAOsqQv/gE=','luanoveck@gmail.com','Alpha','Alpha',0,1,0,'2026-01-09 08:28:25','2026-01-09 08:28:14','9876543210123',0,'0833803942','South Africa','Western Cape','Cape Town','Paarl',1,'2026-01-09 08:28:14.727578');
/*!40000 ALTER TABLE `users_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-09 15:54:29
