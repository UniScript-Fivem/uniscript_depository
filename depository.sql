
-- Dump della struttura di tabella es_extended.depository
CREATE TABLE IF NOT EXISTS `depository` (
  `id` int NOT NULL AUTO_INCREMENT,
  `identifier` varchar(46) DEFAULT NULL,
  `oldidentifier` varchar(60) DEFAULT NULL,
  `depositoryName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sell` int NOT NULL DEFAULT '0',
  `name` varchar(50) NOT NULL,
  `oldname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `weight` int NOT NULL DEFAULT '5000000',
  `slots` int NOT NULL DEFAULT '200',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
