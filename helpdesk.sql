-- MySQL dump 10.15  Distrib 10.0.19-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: helpdesk
-- ------------------------------------------------------
-- Server version	10.0.19-MariaDB-1

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


drop database if exists `helpdesk`; 
create database `helpdesk`;
use `helpdesk`;

grant usage on helpdesk.* to helpdesk@localhost identified by '@helpdesk#';
grant select, insert, update, delete, drop, alter, create, index,create temporary tables on helpdesk.* to helpdesk@localhost;
flush privileges;

--
-- Table structure for table `hesk_attachments`
--

DROP TABLE IF EXISTS `hesk_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_attachments` (
  `att_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` varchar(13) COLLATE utf8_unicode_ci DEFAULT NULL,
  `saved_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `real_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `size` int(10) unsigned NOT NULL DEFAULT '0',
  `type` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `download_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`att_id`),
  KEY `ticket_id` (`ticket_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_attachments`
--

LOCK TABLES `hesk_attachments` WRITE;
/*!40000 ALTER TABLE `hesk_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_banned_emails`
--

DROP TABLE IF EXISTS `hesk_banned_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_banned_emails` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `banned_by` smallint(5) unsigned NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_banned_emails`
--

LOCK TABLES `hesk_banned_emails` WRITE;
/*!40000 ALTER TABLE `hesk_banned_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_banned_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_banned_ips`
--

DROP TABLE IF EXISTS `hesk_banned_ips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_banned_ips` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `ip_from` int(10) unsigned NOT NULL DEFAULT '0',
  `ip_to` int(10) unsigned NOT NULL DEFAULT '0',
  `ip_display` varchar(100) NOT NULL,
  `banned_by` smallint(5) unsigned NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_banned_ips`
--

LOCK TABLES `hesk_banned_ips` WRITE;
/*!40000 ALTER TABLE `hesk_banned_ips` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_banned_ips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_calendar_event`
--

DROP TABLE IF EXISTS `hesk_calendar_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_calendar_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `all_day` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comments` mediumtext COLLATE utf8_unicode_ci,
  `category` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_calendar_event`
--

LOCK TABLES `hesk_calendar_event` WRITE;
/*!40000 ALTER TABLE `hesk_calendar_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_calendar_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_calendar_event_reminder`
--

DROP TABLE IF EXISTS `hesk_calendar_event_reminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_calendar_event_reminder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `unit` int(11) NOT NULL,
  `email_sent` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_calendar_event_reminder`
--

LOCK TABLES `hesk_calendar_event_reminder` WRITE;
/*!40000 ALTER TABLE `hesk_calendar_event_reminder` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_calendar_event_reminder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_categories`
--

DROP TABLE IF EXISTS `hesk_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_categories` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `cat_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  `autoassign` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `type` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `priority` enum('0','1','2','3') COLLATE utf8_unicode_ci NOT NULL DEFAULT '3',
  `manager` int(11) NOT NULL DEFAULT '0',
  `color` varchar(7) COLLATE utf8_unicode_ci DEFAULT NULL,
  `usage` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_categories`
--

LOCK TABLES `hesk_categories` WRITE;
/*!40000 ALTER TABLE `hesk_categories` DISABLE KEYS */;
INSERT INTO `hesk_categories` VALUES (1,'General',10,'1','0','3',0,NULL,0);
/*!40000 ALTER TABLE `hesk_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_kb_articles`
--

DROP TABLE IF EXISTS `hesk_kb_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_kb_articles` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `catid` smallint(5) unsigned NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `author` smallint(5) unsigned NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `content` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `keywords` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `rating` float NOT NULL DEFAULT '0',
  `votes` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `views` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `type` enum('0','1','2') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `html` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `sticky` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `art_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  `history` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `attachments` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `catid` (`catid`),
  KEY `sticky` (`sticky`),
  KEY `type` (`type`),
  FULLTEXT KEY `subject` (`subject`,`content`,`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_kb_articles`
--

LOCK TABLES `hesk_kb_articles` WRITE;
/*!40000 ALTER TABLE `hesk_kb_articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_kb_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_kb_attachments`
--

DROP TABLE IF EXISTS `hesk_kb_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_kb_attachments` (
  `att_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `saved_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `real_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `size` int(10) unsigned NOT NULL DEFAULT '0',
  `download_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`att_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_kb_attachments`
--

LOCK TABLES `hesk_kb_attachments` WRITE;
/*!40000 ALTER TABLE `hesk_kb_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_kb_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_kb_categories`
--

DROP TABLE IF EXISTS `hesk_kb_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_kb_categories` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `parent` smallint(5) unsigned NOT NULL,
  `articles` smallint(5) unsigned NOT NULL DEFAULT '0',
  `articles_private` smallint(5) unsigned NOT NULL DEFAULT '0',
  `articles_draft` smallint(5) unsigned NOT NULL DEFAULT '0',
  `cat_order` smallint(5) unsigned NOT NULL,
  `type` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `parent` (`parent`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_kb_categories`
--

LOCK TABLES `hesk_kb_categories` WRITE;
/*!40000 ALTER TABLE `hesk_kb_categories` DISABLE KEYS */;
INSERT INTO `hesk_kb_categories` VALUES (1,'Knowledgebase',0,0,0,0,10,'0');
/*!40000 ALTER TABLE `hesk_kb_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_logging`
--

DROP TABLE IF EXISTS `hesk_logging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_logging` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `severity` int(11) NOT NULL,
  `location` mediumtext COLLATE utf8_unicode_ci,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_logging`
--

LOCK TABLES `hesk_logging` WRITE;
/*!40000 ALTER TABLE `hesk_logging` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_logging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_logins`
--

DROP TABLE IF EXISTS `hesk_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_logins` (
  `ip` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `number` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `last_attempt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_logins`
--

LOCK TABLES `hesk_logins` WRITE;
/*!40000 ALTER TABLE `hesk_logins` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_mail`
--

DROP TABLE IF EXISTS `hesk_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_mail` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from` smallint(5) unsigned NOT NULL,
  `to` smallint(5) unsigned NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `read` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `deletedby` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `from` (`from`),
  KEY `to` (`to`,`read`,`deletedby`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_mail`
--

LOCK TABLES `hesk_mail` WRITE;
/*!40000 ALTER TABLE `hesk_mail` DISABLE KEYS */;
INSERT INTO `hesk_mail` VALUES (1,9999,1,'Rate this script','<div style=\"text-align:justify;padding:3px\">\r\n\r\n<p style=\"color:green;font-weight:bold\">Enjoy using HESK? Please let others know!</p>\r\n\r\n<p>You are invited to rate and review HESK here:<br />&nbsp;<br /><img src=\"../img/link.png\" width=\"16\" height=\"16\" border=\"0\" alt=\"\" style=\"vertical-align:text-bottom\" /> <a href=\"http://www.hotscripts.com/listing/free-helpdesk-software-hesk/\" target=\"_blank\">Rate this script @ Hot Scripts</a><br />&nbsp;<br /><img src=\"../img/link.png\" width=\"16\" height=\"16\" border=\"0\" alt=\"\" style=\"vertical-align:text-bottom\" /> <a href=\"http://php.resourceindex.com/programs_and_scripts/customer_support/hesk.html\" target=\"_blank\">Rate this script @ The PHP Resource Index</a></p>\r\n\r\n<p>Thank you,<br />&nbsp;<br />Klemen,<br />\r\n<a href=\"http://www.hesk.com/\" target=\"_blank\">www.hesk.com</a>\r\n\r\n<p>&nbsp;</p>','2016-06-28 21:29:12','0',9999),(2,9999,1,'Welcome to HESK! Here are some quick tips...','<p style=\"color:green;font-weight:bold\">HESK quick &quot;Getting Started&quot; tips:<br />&nbsp;</p>\r\n\r\n<ol style=\"padding-left:20px;padding-right:10px;text-align:justify\">\r\n<li>Click &quot;Profile&quot; to set your name, email, signature, and password.<br />&nbsp;</li>\r\n<li>Click &quot;Settings&quot; in the top menu to view all settings. For information about each setting, click the [?] link.<br />&nbsp;</li>\r\n<li>Click &quot;Categories&quot; to add new categories (departments). The default category cannot be deleted, but it can be renamed.<br />&nbsp;</li>\r\n<li>Click &quot;Users&quot; to create new accounts. You can assign each account unlimited (Administrator) or restricted (Staff) access.<br />&nbsp;</li>\r\n<li>Click &quot;Knowledgebase&quot; to manage your integrated knowledgebase. A comprehensive and well-written knowledgebase can drastically reduce the number of support tickets you receive and save significant time and effort.<br />&nbsp;</li>\r\n<li>Click &quot;Canned&quot; to compose pre-written response to common support questions, and to create new ticket templates.<br />&nbsp;</li>\r\n<li>Subscribe to the <a href=\"http://www.hesk.com/newsletter.php\" target=\"_blank\">HESK Newsletter</a> to receive information about updates, new versions, special promotions, and more.<br />&nbsp;</li>\r\n<li>Follow HESK on Twitter <a href=\"https://twitter.com/HESKdotCOM\" target=\"_blank\">here</a>.<br />&nbsp;</li>\r\n<li>To remove the <i>Powered by Help Desk Software HESK</i> links from the bottom of your help desk <a href=\"https://www.hesk.com/buy.php\" target=\"_blank\">buy a license here</a>.<br />&nbsp;</li></ol>\r\n\r\n<p>Enjoy using HESK and please feel free to share your constructive feedback and feature suggestions.</p>\r\n\r\n<p>Klemen Stirn<br />\r\nHESK owner and author<br />\r\n<a href=\"http://www.hesk.com/\" target=\"_blank\">www.hesk.com</a>','2016-06-28 21:29:12','0',9999);
/*!40000 ALTER TABLE `hesk_mail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_notes`
--

DROP TABLE IF EXISTS `hesk_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_notes` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `ticket` mediumint(8) unsigned NOT NULL,
  `who` smallint(5) unsigned NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `attachments` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ticketid` (`ticket`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_notes`
--

LOCK TABLES `hesk_notes` WRITE;
/*!40000 ALTER TABLE `hesk_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_online`
--

DROP TABLE IF EXISTS `hesk_online`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_online` (
  `user_id` smallint(5) unsigned NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tmp` int(11) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `user_id` (`user_id`),
  KEY `dt` (`dt`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_online`
--

LOCK TABLES `hesk_online` WRITE;
/*!40000 ALTER TABLE `hesk_online` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_online` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_pending_verification_emails`
--

DROP TABLE IF EXISTS `hesk_pending_verification_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_pending_verification_emails` (
  `Email` varchar(255) NOT NULL,
  `ActivationKey` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_pending_verification_emails`
--

LOCK TABLES `hesk_pending_verification_emails` WRITE;
/*!40000 ALTER TABLE `hesk_pending_verification_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_pending_verification_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_permission_templates`
--

DROP TABLE IF EXISTS `hesk_permission_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_permission_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `heskprivileges` varchar(1000) DEFAULT NULL,
  `categories` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_permission_templates`
--

LOCK TABLES `hesk_permission_templates` WRITE;
/*!40000 ALTER TABLE `hesk_permission_templates` DISABLE KEYS */;
INSERT INTO `hesk_permission_templates` VALUES (1,'Administrator','ALL','ALL'),(2,'Staff','can_view_tickets,can_reply_tickets,can_change_cat,can_assign_self,can_view_unassigned,can_view_online','1');
/*!40000 ALTER TABLE `hesk_permission_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_pipe_loops`
--

DROP TABLE IF EXISTS `hesk_pipe_loops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_pipe_loops` (
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `hits` smallint(1) unsigned NOT NULL DEFAULT '0',
  `message_hash` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `email` (`email`,`hits`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_pipe_loops`
--

LOCK TABLES `hesk_pipe_loops` WRITE;
/*!40000 ALTER TABLE `hesk_pipe_loops` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_pipe_loops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_quick_help_sections`
--

DROP TABLE IF EXISTS `hesk_quick_help_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_quick_help_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `show` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_quick_help_sections`
--

LOCK TABLES `hesk_quick_help_sections` WRITE;
/*!40000 ALTER TABLE `hesk_quick_help_sections` DISABLE KEYS */;
INSERT INTO `hesk_quick_help_sections` VALUES (1,'create_ticket','1'),(2,'view_ticket_form','1'),(3,'view_ticket','1'),(4,'knowledgebase','1'),(5,'staff_create_ticket','1');
/*!40000 ALTER TABLE `hesk_quick_help_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_replies`
--

DROP TABLE IF EXISTS `hesk_replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_replies` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `replyto` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `attachments` mediumtext COLLATE utf8_unicode_ci,
  `staffid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `rating` enum('1','5') COLLATE utf8_unicode_ci DEFAULT NULL,
  `read` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `html` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `replyto` (`replyto`),
  KEY `dt` (`dt`),
  KEY `staffid` (`staffid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_replies`
--

LOCK TABLES `hesk_replies` WRITE;
/*!40000 ALTER TABLE `hesk_replies` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_reply_drafts`
--

DROP TABLE IF EXISTS `hesk_reply_drafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_reply_drafts` (
  `owner` smallint(5) unsigned NOT NULL,
  `ticket` mediumint(8) unsigned NOT NULL,
  `message` mediumtext CHARACTER SET utf8 NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `owner` (`owner`),
  KEY `ticket` (`ticket`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_reply_drafts`
--

LOCK TABLES `hesk_reply_drafts` WRITE;
/*!40000 ALTER TABLE `hesk_reply_drafts` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_reply_drafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_reset_password`
--

DROP TABLE IF EXISTS `hesk_reset_password`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_reset_password` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user` smallint(5) unsigned NOT NULL,
  `hash` char(40) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_reset_password`
--

LOCK TABLES `hesk_reset_password` WRITE;
/*!40000 ALTER TABLE `hesk_reset_password` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_reset_password` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_service_messages`
--

DROP TABLE IF EXISTS `hesk_service_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_service_messages` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `author` smallint(5) unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `style` enum('0','1','2','3','4') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `type` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `order` smallint(5) unsigned NOT NULL DEFAULT '0',
  `icon` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_service_messages`
--

LOCK TABLES `hesk_service_messages` WRITE;
/*!40000 ALTER TABLE `hesk_service_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_service_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_settings`
--

DROP TABLE IF EXISTS `hesk_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_settings` (
  `Key` varchar(200) NOT NULL,
  `Value` varchar(200) NOT NULL,
  PRIMARY KEY (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_settings`
--

LOCK TABLES `hesk_settings` WRITE;
/*!40000 ALTER TABLE `hesk_settings` DISABLE KEYS */;
INSERT INTO `hesk_settings` VALUES ('attachments','0'),('category_order_column','cat_order'),('customer_email_verification_required','0'),('custom_field_setting','0'),('default_calendar_view','month'),('display_user_agent_information','0'),('dropdownItemTextColor','#333333'),('dropdownItemTextHoverBackgroundColor','#f5f5f5'),('dropdownItemTextHoverColor','#262626'),('enable_calendar','1'),('first_day_of_week','0'),('html_emails','1'),('kb_attach_dir','attachments'),('mailgun_api_key',''),('mailgun_domain',''),('modsForHeskVersion','2.6.1'),('navbarBackgroundColor','#414a5c'),('navbarBrandColor','#d4dee7'),('navbarBrandHoverColor','#ffffff'),('navbarItemSelectedBackgroundColor','#2d3646'),('navbarItemTextColor','#d4dee7'),('navbarItemTextHoverColor','#ffffff'),('navbarItemTextSelectedColor','#ffffff'),('navbar_title_url','http://192.168.20.100/helpdesk'),('new_kb_article_visibility','0'),('public_api','0'),('questionMarkColor','#000000'),('request_location','0'),('rich_text_for_tickets','0'),('rich_text_for_tickets_for_customers','0'),('rtl','0'),('show_icons','0'),('show_number_merged','1'),('statuses_order_column','sort'),('use_bootstrap_theme','1'),('use_mailgun','0');
/*!40000 ALTER TABLE `hesk_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_stage_tickets`
--

DROP TABLE IF EXISTS `hesk_stage_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_stage_tickets` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `trackid` varchar(13) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(1000) NOT NULL DEFAULT '',
  `category` smallint(5) unsigned NOT NULL DEFAULT '1',
  `priority` enum('0','1','2','3') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '3',
  `subject` varchar(70) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `message` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `dt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastchange` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `firstreply` timestamp NULL DEFAULT NULL,
  `closedat` timestamp NULL DEFAULT NULL,
  `articles` varchar(255) DEFAULT NULL,
  `ip` varchar(45) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `language` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `openedby` mediumint(8) DEFAULT '0',
  `firstreplyby` smallint(5) unsigned DEFAULT NULL,
  `closedby` mediumint(8) DEFAULT NULL,
  `replies` smallint(5) unsigned NOT NULL DEFAULT '0',
  `staffreplies` smallint(5) unsigned NOT NULL DEFAULT '0',
  `owner` smallint(5) unsigned NOT NULL DEFAULT '0',
  `time_worked` time NOT NULL DEFAULT '00:00:00',
  `lastreplier` enum('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `replierid` smallint(5) unsigned DEFAULT NULL,
  `archive` enum('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `locked` enum('0','1') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `attachments` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `merged` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `history` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom1` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom2` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom3` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom4` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom5` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom6` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom7` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom8` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom9` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom10` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom11` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom12` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom13` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom14` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom15` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom16` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom17` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom18` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom19` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `custom20` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `parent` mediumint(8) DEFAULT NULL,
  `latitude` varchar(100) NOT NULL DEFAULT 'E-0',
  `longitude` varchar(100) NOT NULL DEFAULT 'E-0',
  `html` enum('0','1') NOT NULL DEFAULT '0',
  `user_agent` text,
  `screen_resolution_width` int(11) DEFAULT NULL,
  `screen_resolution_height` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `trackid` (`trackid`),
  KEY `archive` (`archive`),
  KEY `categories` (`category`),
  KEY `statuses` (`status`),
  KEY `owner` (`owner`),
  KEY `openedby` (`openedby`,`firstreplyby`,`closedby`),
  KEY `dt` (`dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_stage_tickets`
--

LOCK TABLES `hesk_stage_tickets` WRITE;
/*!40000 ALTER TABLE `hesk_stage_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_stage_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_statuses`
--

DROP TABLE IF EXISTS `hesk_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_statuses` (
  `ID` int(11) NOT NULL,
  `TextColor` text NOT NULL,
  `IsNewTicketStatus` int(1) NOT NULL DEFAULT '0',
  `IsClosed` int(1) NOT NULL DEFAULT '0',
  `IsClosedByClient` int(1) NOT NULL DEFAULT '0',
  `IsCustomerReplyStatus` int(1) NOT NULL DEFAULT '0',
  `IsStaffClosedOption` int(1) NOT NULL DEFAULT '0',
  `IsStaffReopenedStatus` int(1) NOT NULL DEFAULT '0',
  `IsDefaultStaffReplyStatus` int(1) NOT NULL DEFAULT '0',
  `LockedTicketStatus` int(1) NOT NULL DEFAULT '0',
  `IsAutocloseOption` int(11) NOT NULL DEFAULT '0',
  `Closable` varchar(10) NOT NULL,
  `Key` text,
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_statuses`
--

LOCK TABLES `hesk_statuses` WRITE;
/*!40000 ALTER TABLE `hesk_statuses` DISABLE KEYS */;
INSERT INTO `hesk_statuses` VALUES (0,'#FF0000',1,0,0,0,0,0,0,0,0,'yes','open',10),(1,'#FF9933',0,0,0,1,0,1,0,0,0,'yes','wait_reply',20),(2,'#0000FF',0,0,0,0,0,0,1,0,0,'yes','replied',30),(3,'#008000',0,1,1,0,1,0,0,1,1,'yes','resolved',40),(4,'#000000',0,0,0,0,0,0,0,0,0,'yes','in_progress',50),(5,'#000000',0,0,0,0,0,0,0,0,0,'yes','on_hold',60);
/*!40000 ALTER TABLE `hesk_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_std_replies`
--

DROP TABLE IF EXISTS `hesk_std_replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_std_replies` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `reply_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_std_replies`
--

LOCK TABLES `hesk_std_replies` WRITE;
/*!40000 ALTER TABLE `hesk_std_replies` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_std_replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_temp_attachment`
--

DROP TABLE IF EXISTS `hesk_temp_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_temp_attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `saved_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(10) unsigned NOT NULL,
  `type` enum('0','1') COLLATE utf8_unicode_ci NOT NULL,
  `date_uploaded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_temp_attachment`
--

LOCK TABLES `hesk_temp_attachment` WRITE;
/*!40000 ALTER TABLE `hesk_temp_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_temp_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_text_to_status_xref`
--

DROP TABLE IF EXISTS `hesk_text_to_status_xref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_text_to_status_xref` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `text` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `status_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_text_to_status_xref`
--

LOCK TABLES `hesk_text_to_status_xref` WRITE;
/*!40000 ALTER TABLE `hesk_text_to_status_xref` DISABLE KEYS */;
INSERT INTO `hesk_text_to_status_xref` VALUES (1,'English','New',0),(2,'English','Waiting reply',1),(3,'English','Replied',2),(4,'English','Resolved',3),(5,'English','In Progress',4),(6,'English','On Hold',5);
/*!40000 ALTER TABLE `hesk_text_to_status_xref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_ticket_templates`
--

DROP TABLE IF EXISTS `hesk_ticket_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_ticket_templates` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `tpl_order` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_ticket_templates`
--

LOCK TABLES `hesk_ticket_templates` WRITE;
/*!40000 ALTER TABLE `hesk_ticket_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_ticket_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_tickets`
--

DROP TABLE IF EXISTS `hesk_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_tickets` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `trackid` varchar(13) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(1000) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `category` smallint(5) unsigned NOT NULL DEFAULT '1',
  `priority` enum('0','1','2','3') COLLATE utf8_unicode_ci NOT NULL DEFAULT '3',
  `subject` varchar(70) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `message` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `dt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastchange` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `firstreply` timestamp NULL DEFAULT NULL,
  `closedat` timestamp NULL DEFAULT NULL,
  `articles` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `language` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) NOT NULL,
  `openedby` mediumint(8) DEFAULT '0',
  `firstreplyby` smallint(5) unsigned DEFAULT NULL,
  `closedby` mediumint(8) DEFAULT NULL,
  `replies` smallint(5) unsigned NOT NULL DEFAULT '0',
  `staffreplies` smallint(5) unsigned NOT NULL DEFAULT '0',
  `owner` smallint(5) unsigned NOT NULL DEFAULT '0',
  `time_worked` time NOT NULL DEFAULT '00:00:00',
  `lastreplier` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `replierid` smallint(5) unsigned DEFAULT NULL,
  `archive` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `locked` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `attachments` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `merged` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `history` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom1` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom2` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom3` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom4` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom5` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom6` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom7` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom8` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom9` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom10` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom11` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom12` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom13` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom14` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom15` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom16` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom17` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom18` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom19` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `custom20` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `parent` mediumint(8) DEFAULT NULL,
  `latitude` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'E-0',
  `longitude` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'E-0',
  `html` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `user_agent` text COLLATE utf8_unicode_ci,
  `screen_resolution_width` int(11) DEFAULT NULL,
  `screen_resolution_height` int(11) DEFAULT NULL,
  `due_date` datetime DEFAULT NULL,
  `overdue_email_sent` enum('0','1') COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `trackid` (`trackid`),
  KEY `archive` (`archive`),
  KEY `categories` (`category`),
  KEY `owner` (`owner`),
  KEY `openedby` (`openedby`,`firstreplyby`,`closedby`),
  KEY `dt` (`dt`),
  KEY `statuses` (`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_tickets`
--

LOCK TABLES `hesk_tickets` WRITE;
/*!40000 ALTER TABLE `hesk_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_user_api_tokens`
--

DROP TABLE IF EXISTS `hesk_user_api_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_user_api_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_user_api_tokens`
--

LOCK TABLES `hesk_user_api_tokens` WRITE;
/*!40000 ALTER TABLE `hesk_user_api_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_user_api_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_users`
--

DROP TABLE IF EXISTS `hesk_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_users` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `pass` char(40) COLLATE utf8_unicode_ci NOT NULL,
  `isadmin` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `signature` varchar(1000) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `language` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `categories` varchar(500) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `afterreply` enum('0','1','2') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `autostart` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_customer_new` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_customer_reply` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `show_suggested` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_new_unassigned` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_new_my` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_reply_unassigned` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_reply_my` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_assigned` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_pm` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_note` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `default_list` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `autoassign` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `heskprivileges` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ratingneg` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ratingpos` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `rating` float NOT NULL DEFAULT '0',
  `replies` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `autorefresh` bigint(20) NOT NULL DEFAULT '0',
  `active` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `notify_note_unassigned` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `default_calendar_view` int(11) NOT NULL DEFAULT '0',
  `notify_overdue_unassigned` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `permission_template` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `autoassign` (`autoassign`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_users`
--

LOCK TABLES `hesk_users` WRITE;
/*!40000 ALTER TABLE `hesk_users` DISABLE KEYS */;
INSERT INTO `hesk_users` VALUES (1,'Administrator','8d4f66d4ccf264d4f99414e09dacdb332622261d','1','Your name','you@me.com','',NULL,'','0','1','1','1','1','1','1','1','1','1','1','1','','1','',0,0,0,0,0,'1','0',0,'0',1),(2,'jesus.mendozab','0ec596aeecc6c5dadc8eae7c9541ebc067cda570','1','ambagasdowa','jesus.mendozab@bonampak.com.mx','',NULL,'','0','1','1','1','1','1','1','1','1','1','1','1','','0','',0,0,0,0,0,'1','1',0,'0',1),(3,'sistemas','74f1067e948362477da54846e91739f61bf24353','0','sistemas','ti.integra@bonampak.com.mx','',NULL,'1','0','1','1','1','1','1','1','1','1','1','1','1','','0','can_view_tickets,can_reply_tickets,can_change_cat,can_assign_self,can_view_unassigned,can_view_online',0,0,0,0,0,'1','1',0,'0',2);
/*!40000 ALTER TABLE `hesk_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hesk_verified_emails`
--

DROP TABLE IF EXISTS `hesk_verified_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hesk_verified_emails` (
  `Email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hesk_verified_emails`
--

LOCK TABLES `hesk_verified_emails` WRITE;
/*!40000 ALTER TABLE `hesk_verified_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `hesk_verified_emails` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-06-28 17:42:20
