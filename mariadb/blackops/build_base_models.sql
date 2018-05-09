-- ==================================================================================================================== --	
-- =================================     DEVOPS :: Cakephp base dev        ============================================ --
-- ==================================================================================================================== --

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : May 02, 2018
 Description    : Build a devops base php app
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : Jesus Baizabal
 @status        : Stable
 @version		: 0.0.1
 ===============================================================================*/

-- use blackops;

-- ==================================================================================================================== --	
-- ===================================      	  table definitions 		  ========================================= --
-- ==================================================================================================================== --

-- Core definitions

create or replace table `dev_users` (
  `id` 						int unsigned not null auto_increment primary key,
  `username`				varchar not null , 
  `email`					varchar not null , 
  `password`				varchar not null , 
  `created`         	   	datetime,
  `modified`           		datetime,
  `status`					bool not null default true
)engine=InnoDB default charset=utf8mb4;


create or replace table `dev_groups` (
  `id` 						int unsigned not null auto_increment primary key,
  `name`					varchar not null , 
  `description`				text,
  `created`         	   	datetime,
  `modified`           		datetime,
  `status`					bool not null default true
)engine=InnoDB default charset=utf8mb4;


create or replace table `dev_usergroups` (
  `id` 						int unsigned not null auto_increment primary key,
  `dev_users_id`			int unsigned null , 
  `dev_groups_id`			int unsigned null , 
  `description`				text,
  `created`         	   	datetime,
  `modified`           		datetime,
  `status`					bool not null default true
)engine=InnoDB default charset=utf8mb4;


create or replace table `dev_cleanpass` (
  `id` 						int unsigned not null auto_increment primary key,
  `dev_users_id`			int unsigned null , 
  `created`         	   	datetime,
  `modified`           		datetime,
  `status`					bool not null default true
)engine=InnoDB default charset=utf8mb4;

create or replace table `dev_logs` (
  `id` 						int unsigned not null auto_increment primary key,
  `name`					text,
  `description`				text,
  `log`						text,
  `created`         	   	datetime,
  `modified`           		datetime,
  `status`					bool not null default true
)engine=InnoDB default charset=utf8mb4;



-- ==================================================================================================================== --
-- ===================================      	  Apptable definitions 		  ========================================= --
-- ==================================================================================================================== --
-- Per App Definitions




