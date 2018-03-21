-- ==================================================================================================================== --	
-- ===========================================        App ControlDesk      ============================================ --
-- ==================================================================================================================== --

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 06, 2017
 Description    : Build Tables for ControlDesk
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ===============================================================================*/

show databases;

use portal_apps;

show tables;

-- grant usage on portal_apps.* to portal_apps@localhost identified by '@portal_apps#';
-- grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_apps.* to portal_apps@localhost;
-- grant file on *.* to 'portal_apps'@'localhost';
-- flush privileges;

-- SHOW GRANTS FOR 'portal_apps'@'localhost';

-- flush privileges;

-- GRANT FILE ON *.* TO 'user'@'%';

-- Add external DB Sources

-- ==================================================================================================================== --	
-- ===================================     Performance ControlDesk         ====================================== --
-- ==================================================================================================================== --
-- Add ControlDesk

-- drop table `portal_apps`.`control_desk_user_controls`
CREATE TABLE IF NOT EXISTS `portal_apps`.`control_desk_user_controls` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `user_id`					 	int not null,
  `storage`						boolean NOT NULL default false,
  `clear_key`					varchar(255) default null ,
  `description`					text null,
  `status` 						boolean NOT NULL default true,
  `created` 					datetime default NULL,
  `modified` 					datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  CHARACTER SET utf8 COLLATE utf8_general_ci ;

-- select * from `portal_apps`.`control_desk_user_controls`
-- add controls for share
-- update `portal_apps`.`control_desk_user_controls` set storage = 1 where id = 3
-- update `portal_apps`.`control_desk_user_controls` set clear_key = '@EnumaElish#' where id = 1

-- Add database portal_nextcloud





























