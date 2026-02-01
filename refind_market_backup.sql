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
INSERT INTO `django_session` VALUES ('09kei6z0givs5ug3g1kyox4ovs0i591j','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vgrro:RQd4luKITmErsDg9TM9-8s3Mzv4LIwQkRCrZhaOWJDg','2026-01-30 22:00:28'),('1o4tl448c5ff0oeb0cusslmonkfqg3y7','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vfuaa:o3KW5wroEs6pM4eOpy0LSrG201Yoh-dSB_rdp6-9f4M','2026-01-28 06:42:45'),('4pcbp8khgp6ffqm84pgphdykasqxd0tx','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vfl8h:3QmqmBT4t839T0Y7WN3T3CP_vR-2Usx6qcvWv5D6bZ0','2026-01-27 20:37:20'),('c50k1cw4rqxvm3i5tuscxq8m0gwsyl46','.eJxVjDsOwjAQBe_iGlnY8peSnjNYu-s1DiBbipMq4u4QKQW0b2beJhKsS03r4DlNWVyEEqffDYGe3HaQH9DuXVJvyzyh3BV50CFvPfPrerh_BxVG_dZIUemg2aoQYjYG0VlG64rT3mrgiJ5YnZ2Bwlis98zgHGGBQioYEu8P6tE40w:1vmILV:0sDMn1_jZtFDwuAMMT4CsiJWI1Omxfj8kD879E7of88','2026-02-14 21:17:33'),('do3c1n5sjtotcqdznx8mf18whnz503s0','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vghpG:gVk3npAoroxdBdyhzlMpim4l7qhCrGWkUrjVOCoW9HU','2026-01-30 11:17:10'),('fdq2tvkth8a0vd7w5x6yjpeyul0sgwsi','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vfXV6:YvNmAsC9f3R3_-GFRNq1R9US5elUl2SDd1ev0ZsjB5g','2026-01-27 06:03:33'),('kw79khng9rjhtnrr06rvjtel76es1l2z','.eJxVjDsOwjAQRO_iGln-xR9K-pzB8nq9OIAcKU4qxN1JpBRQjTTvzbxZTNta49bLEidkV6bZ5beDlJ-lHQAfqd1nnue2LhPwQ-En7Xycsbxup_t3UFOv-9r4YkGDDIpcSD4bqzGgA-FRl0xpkBYESfSAYvCOvCHaA9Aqo7TV7PMF8SY4Hg:1vfC1a:RG5JW1Obpf54umnmoVo_Skz5ubPRLQips7Og_iPNCak','2026-01-26 07:07:38'),('m1wnp95ak2qzc3qdcst3nkuh094qe18s','.eJxVjDsOwjAQRO_iGln-xR9K-pzB8nq9OIAcKU4qxN1JpBRQjTTvzbxZTNta49bLEidkV6bZ5beDlJ-lHQAfqd1nnue2LhPwQ-En7Xycsbxup_t3UFOv-9r4YkGDDIpcSD4bqzGgA-FRl0xpkBYESfSAYvCOvCHaA9Aqo7TV7PMF8SY4Hg:1vjkim:e3nb1JPHVCHzM-obAFFBdiXwVl59NO2ohaHtzC2tamw','2026-02-07 20:59:04'),('s84ie6m58cad7fa856q38qwicbgtvab6','.eJxVjDsOwjAQRO_iGln-xR9K-pzB8nq9OIAcKU4qxN1JpBRQjTTvzbxZTNta49bLEidkV6bZ5beDlJ-lHQAfqd1nnue2LhPwQ-En7Xycsbxup_t3UFOv-9r4YkGDDIpcSD4bqzGgA-FRl0xpkBYESfSAYvCOvCHaA9Aqo7TV7PMF8SY4Hg:1vixHW:BXUjV6rwkhelNfUuDcnrelKBfxa0PG4WMh6bTG6YAxo','2026-02-05 16:11:39'),('x2aly4z8cihfwlbeys9k9f5dcedsyf4a','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1viWPZ:5p9fROJe78WkLlMgOAtHeMD16-p1wsMhta2MI1MXROI','2026-02-04 11:30:09'),('x9una2htxu8lz51pbyxoehkziyzcmzes','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vfzQ8:v93GKbjTSoHVJBf6iseIrQMJUPjr2Hlzk1VAzM8joqs','2026-01-28 11:52:17'),('xjftlnf1kj2u5b6eyivjsu9rqydgve9q','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vdlk5:QsySghqhuGRmfshWlJDx2KE4fR1wul5on3J-WSkUMLM','2026-01-22 08:51:41'),('y6uzwc0eggcurnf4gx2iut32vxpx0ezb','.eJxVjEsOwjAMBe-SNYrctE4CS_Y9Q2U7DimgVOpnhbg7VOoCtm9m3ssMtK1l2BadhzGZi3Hm9LsxyUPrDtKd6m2yMtV1Htnuij3oYvsp6fN6uH8HhZbyrSFnbYVcDHL2EZwHxwEbQdaICIhtJIaOFCJ2GNhp8k2SyCxZA5B5fwDW9zf3:1vfuKb:2zj3W4rlH4TDjhtwcKr-9WYR7R3uu_1IGyHcvIojSBI','2026-01-28 06:26:14');
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
  `is_featured_on_profile` tinyint(1) DEFAULT '0',
  `show_on_marketplace` tinyint(1) DEFAULT '1',
  `condition` varchar(20) DEFAULT 'good',
  `negotiation_limit` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `listings_item_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_item`
--

LOCK TABLES `listings_item` WRITE;
/*!40000 ALTER TABLE `listings_item` DISABLE KEYS */;
INSERT INTO `listings_item` (`id`, `seller_id`, `title`, `description`, `price`, `category`, `is_sold`, `created_at`, `image`, `image1`, `image2`, `image3`, `image4`, `image5`, `image6`, `region`, `city`, `suburb`, `total_quantity`, `quantity_sold`, `is_featured_on_profile`, `show_on_marketplace`, `condition`, `negotiation_limit`) VALUES (1,1,'Baby Chair','A high chair for toddlers',500.00,'Other',0,'2026-01-30 18:08:47','default.jpg','item_photos/Re-Find_logo_VtWWdL1.png','item_photos/Re-Find_logo1.png','item_photos/Re-Find_logo2_uJIMXN8.png','','','','Western Cape','Cape Town','Durbanville',2,1,0,1,'good',10),(2,1,'QTY test','sgh',200.00,'Books',0,'2026-01-30 18:40:31','default.jpg','item_photos/1000443215_4.jpg','','','','','','Western Cape','Cape Town','Durbanville',3,2,0,1,'new',15);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_itemimage`
--

LOCK TABLES `listings_itemimage` WRITE;
/*!40000 ALTER TABLE `listings_itemimage` DISABLE KEYS */;
INSERT INTO `listings_itemimage` VALUES (1,'item_photos/Re-Find_logo_BuwwJlH.png',1),(2,'item_photos/Re-Find_logo1_WUpe6Jc.png',1),(3,'item_photos/Re-Find_logo2_tBCHGCv.png',1),(4,'item_photos/1000443215_4_W5kepN9.jpg',2);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_message`
--

LOCK TABLES `listings_message` WRITE;
/*!40000 ALTER TABLE `listings_message` DISABLE KEYS */;
INSERT INTO `listings_message` VALUES (1,'Hello :)','2026-01-30 20:51:00.334919',1,2,1,2);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings_review`
--

LOCK TABLES `listings_review` WRITE;
/*!40000 ALTER TABLE `listings_review` DISABLE KEYS */;
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
  `negotiated_base_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `fk_order_seller` (`seller_id`),
  CONSTRAINT `fk_order_seller` FOREIGN KEY (`seller_id`) REFERENCES `users_user` (`id`),
  CONSTRAINT `orders_order_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `listings_item` (`id`),
  CONSTRAINT `orders_order_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `users_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_order`
--

LOCK TABLES `orders_order` WRITE;
/*!40000 ALTER TABLE `orders_order` DISABLE KEYS */;
INSERT INTO `orders_order` VALUES (1,1,2,'shipped',NULL,'UASSN4C6',NULL,'2026-01-30 18:14:51',1,537.50,1,'44 Minuet Ridge','Cape Town','Durbanville','7440','WC','0A Twist Street','Cape Town','7440','GP',114.95,'ECO',20.00,12,10,20,'door_to_door','sandbox',500.00),(2,2,2,'shipped',NULL,'UASSCT89',NULL,'2026-01-30 18:41:00',1,430.00,2,'44 Minuet Ridge','Cape Town','Durbanville','7440','WC','0A Twist Street','Cape Town','7440','GP',104.36,'LOF',1.00,10,10,10,'door_to_door','sandbox',200.00);
/*!40000 ALTER TABLE `orders_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timeline_comment_likes`
--

DROP TABLE IF EXISTS `timeline_comment_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timeline_comment_likes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comment_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_comment_like` (`comment_id`,`user_id`),
  KEY `fk_user_comment_like` (`user_id`),
  CONSTRAINT `fk_comment` FOREIGN KEY (`comment_id`) REFERENCES `timeline_comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_comment_like` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timeline_comment_likes`
--

LOCK TABLES `timeline_comment_likes` WRITE;
/*!40000 ALTER TABLE `timeline_comment_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `timeline_comment_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timeline_comments`
--

DROP TABLE IF EXISTS `timeline_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timeline_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `author_id` int NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_comment_post` (`post_id`),
  KEY `fk_comment_author` (`author_id`),
  CONSTRAINT `fk_comment_author` FOREIGN KEY (`author_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comment_post` FOREIGN KEY (`post_id`) REFERENCES `timeline_posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timeline_comments`
--

LOCK TABLES `timeline_comments` WRITE;
/*!40000 ALTER TABLE `timeline_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `timeline_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timeline_post_likes`
--

DROP TABLE IF EXISTS `timeline_post_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timeline_post_likes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_like` (`post_id`,`user_id`),
  KEY `fk_like_user` (`user_id`),
  CONSTRAINT `fk_like_post` FOREIGN KEY (`post_id`) REFERENCES `timeline_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_like_user` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timeline_post_likes`
--

LOCK TABLES `timeline_post_likes` WRITE;
/*!40000 ALTER TABLE `timeline_post_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `timeline_post_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timeline_posts`
--

DROP TABLE IF EXISTS `timeline_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timeline_posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `author_id` int NOT NULL,
  `content` text NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `video` varchar(255) DEFAULT NULL,
  `tagged_item_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_post_author` (`author_id`),
  KEY `fk_post_item` (`tagged_item_id`),
  CONSTRAINT `fk_post_author` FOREIGN KEY (`author_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_post_item` FOREIGN KEY (`tagged_item_id`) REFERENCES `listings_item` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timeline_posts`
--

LOCK TABLES `timeline_posts` WRITE;
/*!40000 ALTER TABLE `timeline_posts` DISABLE KEYS */;
INSERT INTO `timeline_posts` VALUES (1,2,'Nice day','timeline_posts/image.png','',NULL,'2026-01-30 20:51:20');
/*!40000 ALTER TABLE `timeline_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_follow`
--

DROP TABLE IF EXISTS `users_follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_follow` (
  `id` int NOT NULL AUTO_INCREMENT,
  `follower_id` int NOT NULL,
  `vendor_id` int NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_follow` (`follower_id`,`vendor_id`),
  KEY `vendor_id` (`vendor_id`),
  CONSTRAINT `users_follow_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_follow_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `users_vendorprofile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_follow`
--

LOCK TABLES `users_follow` WRITE;
/*!40000 ALTER TABLE `users_follow` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_follow` ENABLE KEYS */;
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
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_user`
--

LOCK TABLES `users_user` WRITE;
/*!40000 ALTER TABLE `users_user` DISABLE KEYS */;
INSERT INTO `users_user` VALUES (1,'Omega','pbkdf2_sha256$1000000$vJgsSiDcdGm4LXv5SqOb5M$HcEK0O+2kkltN49ezGRVzyW0ByvcaJaM8gEA0VDpRaw=','luanoveck@gmail.com','Omega','Omega',1,1,1,'2026-01-31 21:17:33','2026-01-30 20:06:55','9510245212088',0,'0833803942','South Africa','Western Cape','Cape Town','Durbanville',1,'2026-01-30 20:06:56.304202','1995-10-24','Male'),(2,'Luano','pbkdf2_sha256$1000000$DJWei28Dp5bngzhBmWf6Ld$EBXotq9CG/HqQbKkL8SwZDfoXacgdrXcuG56kj35KcE=','luanoveck@gmail.com','Luano','van Eck',0,1,0,'2026-01-30 20:43:08','2026-01-30 20:13:26','6202095593089',0,'0833803942','South Africa','Western Cape','Cape Town','Paarl',1,'2026-01-30 20:13:27.440639','1962-02-09','Male');
/*!40000 ALTER TABLE `users_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_vendorprofile`
--

DROP TABLE IF EXISTS `users_vendorprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_vendorprofile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `business_name` varchar(255) NOT NULL,
  `store_slug` varchar(255) NOT NULL,
  `bio` text,
  `logo` varchar(100) DEFAULT NULL,
  `banner` varchar(100) DEFAULT NULL,
  `primary_market` varchar(255) DEFAULT NULL,
  `years_trading` int DEFAULT '0',
  `is_approved` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `business_name` (`business_name`),
  UNIQUE KEY `store_slug` (`store_slug`),
  CONSTRAINT `fk_vendor_user` FOREIGN KEY (`user_id`) REFERENCES `users_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_vendorprofile`
--

LOCK TABLES `users_vendorprofile` WRITE;
/*!40000 ALTER TABLE `users_vendorprofile` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_vendorprofile` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-01 21:02:18
