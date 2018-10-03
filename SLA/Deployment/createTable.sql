--create script

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `sla_address`;
CREATE TABLE `sla_address` (
  `id_address` int(11) NOT NULL AUTO_INCREMENT,
  `street` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `city` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `postal_code` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `id_customer` int(11) NOT NULL,
  PRIMARY KEY (`id_address`),
  KEY `sla_address_sla_customer_fk` (`id_customer`),
  CONSTRAINT `sla_address_sla_customer_fk` FOREIGN KEY (`id_customer`) REFERENCES `sla_customer` (`id_customer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;


DROP TABLE IF EXISTS `sla_chip_card`;
CREATE TABLE `sla_chip_card` (
  `id_chip_card` int(11) NOT NULL AUTO_INCREMENT,
  `rfid_id` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `registered_timestamp` datetime(6) NOT NULL,
  `removed` decimal(38,0) DEFAULT NULL,
  `removed_timestamp` datetime(6) DEFAULT NULL,
  `deposit_price` int(11) DEFAULT NULL,
  `card_rented` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_chip_card`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;


DROP TABLE IF EXISTS `sla_customer`;
CREATE TABLE `sla_customer` (
  `id_customer` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `surname` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `registered` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id_customer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;


DROP TABLE IF EXISTS `sla_employee`;
CREATE TABLE `sla_employee` (
  `id_employee` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `surname` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `id_number` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `foreign_languages` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `id_job` int(11) NOT NULL,
  PRIMARY KEY (`id_employee`),
  KEY `sla_emolyee_sla_job_fk` (`id_job`),
  CONSTRAINT `sla_emolyee_sla_job_fk` FOREIGN KEY (`id_job`) REFERENCES `sla_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;


DROP TABLE IF EXISTS `sla_job`;
CREATE TABLE `sla_job` (
  `id_job` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `sla_order`;
CREATE TABLE `sla_order` (
  `id_order` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime(6) DEFAULT NULL,
  `paid` tinyint(4) NOT NULL DEFAULT '0',
  `paid_datetime` datetime(6) DEFAULT NULL,
  `id_customer` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_order`),
  KEY `sla_customer_fk` (`id_customer`),
  CONSTRAINT `sla_customer_fk` FOREIGN KEY (`id_customer`) REFERENCES `sla_customer` (`id_customer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `sla_order_skipass_article`;
CREATE TABLE `sla_order_skipass_article` (
  `id_order_skipass_article` int(11) NOT NULL AUTO_INCREMENT,
  `sla_order_id_order` int(11) NOT NULL,
  `card_rented` tinyint(4) NOT NULL DEFAULT '0',
  `card_returned` tinyint(4) NOT NULL DEFAULT '0',
  `id_skipass` int(11) NOT NULL,
  PRIMARY KEY (`id_order_skipass_article`),
  KEY `sla_order_fk` (`sla_order_id_order`),
  KEY `sla_skipass_fk` (`id_skipass`),
  CONSTRAINT `sla_order_fk` FOREIGN KEY (`sla_order_id_order`) REFERENCES `sla_order` (`id_order`),
  CONSTRAINT `sla_skipass_fk` FOREIGN KEY (`id_skipass`) REFERENCES `sla_skipass` (`id_skipass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `sla_rent`;
CREATE TABLE `sla_rent` (
  `id_rent` int(11) NOT NULL AUTO_INCREMENT,
  `from_date` datetime NOT NULL,
  `TO_DATE` datetime NOT NULL,
  `deposit_paid` tinyint(4) NOT NULL,
  `deposit_returned` tinyint(4) NOT NULL,
  `id_order_skipass_article` int(11) NOT NULL,
  `id_chip_card` int(11) NOT NULL,
  `id_employee` int(11) NOT NULL,
  PRIMARY KEY (`id_rent`),
  KEY `sla_chip_card_fk` (`id_chip_card`),
  KEY `sla_emolyee_fk` (`id_employee`),
  KEY `sla_o_skipas_article_fk` (`id_order_skipass_article`),
  CONSTRAINT `sla_chip_card_fk` FOREIGN KEY (`id_chip_card`) REFERENCES `sla_chip_card` (`id_chip_card`),
  CONSTRAINT `sla_emolyee_fk` FOREIGN KEY (`id_employee`) REFERENCES `sla_employee` (`id_employee`),
  CONSTRAINT `sla_o_skipas_article_fk` FOREIGN KEY (`id_order_skipass_article`) REFERENCES `sla_order_skipass_article` (`id_order_skipass_article`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `sla_role`;
CREATE TABLE `sla_role` (
  `id_role` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `sla_salaries`;
CREATE TABLE `sla_salaries` (
  `id_salaries` int(11) NOT NULL AUTO_INCREMENT,
  `salary` int(11) NOT NULL,
  `from_date` datetime NOT NULL,
  `TO_DATE` datetime DEFAULT NULL,
  `id_employee` int(11) NOT NULL,
  PRIMARY KEY (`id_salaries`),
  KEY `salaries_sla_emolyee_fk` (`id_employee`),
  CONSTRAINT `salaries_sla_emolyee_fk` FOREIGN KEY (`id_employee`) REFERENCES `sla_employee` (`id_employee`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;


DROP TABLE IF EXISTS `sla_skipass`;
CREATE TABLE `sla_skipass` (
  `id_skipass` int(11) NOT NULL AUTO_INCREMENT,
  `price` int(11) NOT NULL,
  `number_of_days` int(11) NOT NULL,
  PRIMARY KEY (`id_skipass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `sla_user`;
CREATE TABLE `sla_user` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `id_customer` int(11) DEFAULT NULL,
  `id_employee` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_user`),
  KEY `sla_user_sla_customer_fk` (`id_customer`),
  KEY `sla_user_sla_employee_fk` (`id_employee`),
  CONSTRAINT `sla_user_sla_customer_fk` FOREIGN KEY (`id_customer`) REFERENCES `sla_customer` (`id_customer`),
  CONSTRAINT `sla_user_sla_employee_fk` FOREIGN KEY (`id_employee`) REFERENCES `sla_employee` (`id_employee`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

DROP TABLE IF EXISTS `sla_user_role`;
CREATE TABLE `sla_user_role` (
  `id_user_role` int(11) NOT NULL AUTO_INCREMENT,
  `id_role` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  PRIMARY KEY (`id_user_role`),
  KEY `sla_user_role_sla_role_fk` (`id_role`),
  KEY `sla_user_role_sla_user_fk` (`id_user`),
  CONSTRAINT `sla_user_role_sla_role_fk` FOREIGN KEY (`id_role`) REFERENCES `sla_role` (`id_role`),
  CONSTRAINT `sla_user_role_sla_user_fk` FOREIGN KEY (`id_user`) REFERENCES `sla_user` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

