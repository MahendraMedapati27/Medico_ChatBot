CREATE DATABASE IF NOT EXISTS `PharmaCare` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `PharmaCare`;

-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
-- Host: localhost    Database: PharmaCare
-- ------------------------------------------------------
-- Server version 8.0.31

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

-- Table structure for table `Medicines_List`
DROP TABLE IF EXISTS `Medicines_List`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Medicines_List` (
  `Medicine_Id` int NOT NULL,
  `Medicine_Name` varchar(255) DEFAULT NULL,
  `Medicine_Price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Medicine_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dumping data for table `Medicines_List`
LOCK TABLES `Medicines_List` WRITE;
/*!40000 ALTER TABLE `Medicines_List` DISABLE KEYS */;
INSERT INTO `Medicines_List` VALUES (1,'Paracetamol',30.00),(2,'Ibuprofen',20.00),(3,'Amoxicillin',105.00),(4,'Loratadine',115.00),(5,'Omeprazole',65.00),(6,'Simvastatin',190.00),(7,'Metformin',45.00),(8,'Salbutamol',10.00);
/*!40000 ALTER TABLE `Medicines_List` ENABLE KEYS */;
UNLOCK TABLES;

-- Table structure for table `Order_Tracking`
DROP TABLE IF EXISTS `Order_Tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Order_Tracking` (
  `Order_Id` int NOT NULL,
  `Status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Order_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dumping data for table `Order_Tracking`
LOCK TABLES `Order_Tracking` WRITE;
/*!40000 ALTER TABLE `Order_Tracking` DISABLE KEYS */;
INSERT INTO `Order_Tracking` VALUES (20,'delivered'),(21,'in transit');
/*!40000 ALTER TABLE `Order_Tracking` ENABLE KEYS */;
UNLOCK TABLES;

-- Table structure for table `Orders`
DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `Order_Id` int NOT NULL,
  `Medicine_Id` int NOT NULL,
  `Quantity` int DEFAULT NULL,
  `Total_Price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Order_Id`, `Medicine_Id`),
  KEY `orders_ibfk_1` (`Medicine_Id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`Medicine_Id`) REFERENCES `Medicines_List` (`Medicine_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dumping data for table `Orders`
LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (20,1,2,60.00),(20,3,1,105.00),(21,4,3,345.00),(21,6,2,380.00),(21,8,4,40.00);
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;

-- Dumping routines for database 'PharmaCare'
/*!50003 DROP FUNCTION IF EXISTS `Get_Price_For_Medicine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `Get_Price_For_Medicine`(P_Medicine_Name VARCHAR(255)) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE V_Price DECIMAL(10, 2);
    
    -- Check if the Medicine_Name exists in the Medicines_List table
    IF (SELECT COUNT(*) FROM Medicines_List WHERE Medicine_Name = P_Medicine_Name) > 0 THEN
        -- Retrieve the price for the medicine
        SELECT Medicine_Price INTO V_Price
        FROM Medicines_List
        WHERE Medicine_Name = P_Medicine_Name;
        
        RETURN V_Price;
    ELSE
        -- Invalid Medicine_Name, return -1
        RETURN -1;
    END IF;
END ;;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `Get_Total_order_Price`(P_Order_Id INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE V_Total_Price DECIMAL(10, 2);
    
    -- Check if the order_id exists in the orders table
    IF (SELECT COUNT(*) FROM Orders WHERE Order_Id = P_Order_Id) > 0 THEN
        -- Calculate the total price
        SELECT SUM(Total_Price) INTO V_Total_Price
        FROM Orders
        WHERE Order_Id = P_Order_Id;
        
        RETURN V_Total_Price;
    ELSE
        -- Invalid order_id, return -1
        RETURN -1;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

-- Procedure to insert an order item
/*!50003 DROP PROCEDURE IF EXISTS `Insert_Order_Item` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;

CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Order_Item`(
  IN P_Medicine_Name VARCHAR(255),
  IN P_Quantity INT,
  IN P_Order_Id INT
)
BEGIN
    DECLARE V_Medicine_Id INT;
    DECLARE V_Price DECIMAL(10, 2);
    DECLARE V_Total_Price DECIMAL(10, 2);

    -- Retrieve the Medicine_Id for the given Medicine_Name
    SELECT Medicine_Id INTO V_Medicine_Id FROM Medicines_List WHERE Medicine_Name = P_Medicine_Name;
    
    -- Check if Medicine_Id is NULL or not found
    IF V_Medicine_Id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medicine not found for the given name';
    END IF;

    -- Get the price for the medicine
    SELECT Get_Price_For_Medicine(P_Medicine_Name) INTO V_Price;

    -- Calculate the total price for the order item
    SET V_Total_Price = V_Price * P_Quantity;

    -- Insert the order item into the Orders table
    INSERT INTO Orders (Order_Id, Medicine_Id, Quantity, Total_Price)
    VALUES (P_Order_Id, V_Medicine_Id, P_Quantity, V_Total_Price);
END ;;

DELIMITER ;

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-14 17:55:58
