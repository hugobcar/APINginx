-- MySQL dump 10.13  Distrib 5.6.16, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: apinginx
-- ------------------------------------------------------
-- Server version	5.6.16-1~exp1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `apinginx`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `apinginx` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `apinginx`;

--
-- Table structure for table `grupos`
--

DROP TABLE IF EXISTS `grupos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grupos` (
  `id_grupo` int(3) NOT NULL AUTO_INCREMENT,
  `nome_grupo` varchar(60) NOT NULL,
  `descricao` varchar(300) NOT NULL,
  `datahora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mapeamentos`
--

DROP TABLE IF EXISTS `mapeamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mapeamentos` (
  `id_mapeamento` bigint(10) NOT NULL AUTO_INCREMENT,
  `location_prefix` varchar(50) NOT NULL,
  `location` varchar(50) NOT NULL,
  `proxy_pass` varchar(200) NOT NULL,
  `env` varchar(5) NOT NULL,
  `id_usuario` int(3) NOT NULL,
  `id_grupo` int(3) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `consome` varchar(200) NOT NULL,
  `owner` varchar(200) NOT NULL,
  `md5_app` varchar(50) NOT NULL,
  `md5_dmz` varchar(50) NOT NULL,
  `somente_dmz` int(1) NOT NULL DEFAULT '0',
  `aprovado` int(1) NOT NULL DEFAULT '0',
  `aplicado` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_mapeamento`),
  UNIQUE KEY `location_prefix` (`location_prefix`,`location`,`env`),
  KEY `location` (`location`),
  KEY `proxy_pass` (`proxy_pass`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_grupo` (`id_grupo`),
  KEY `aprovado` (`aprovado`),
  KEY `md5_app` (`md5_app`),
  KEY `md5_dmz` (`md5_dmz`),
  KEY `somente_dmz` (`somente_dmz`),
  KEY `aplicado` (`aplicado`)
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `servidores`
--

DROP TABLE IF EXISTS `servidores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servidores` (
  `id_servidor` int(5) NOT NULL AUTO_INCREMENT,
  `nome_servidor` varchar(30) NOT NULL,
  `IP` varchar(15) NOT NULL,
  `env` varchar(5) NOT NULL,
  `type_server` varchar(6) NOT NULL,
  `ativo` int(1) NOT NULL DEFAULT '1',
  `check_md5` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_servidor`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id_usuario` int(3) NOT NULL AUTO_INCREMENT,
  `nome_usuario` varchar(60) NOT NULL,
  `usuario` varchar(25) NOT NULL,
  `senha` varchar(15) NOT NULL,
  `id_grupo` int(3) NOT NULL,
  `datahora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ativo` int(1) NOT NULL DEFAULT '1',
  `admin` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-07 15:02:01
