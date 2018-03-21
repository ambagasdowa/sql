show databases
create database `portal_cloud`

use portal_cloud

show tables;





use `own_finances`


-- =========================================================================== --
-- ======================== create a user ==================================== --
-- =========================================================================== --

grant usage on portal_mainframe.* to portal_mainframe@localhost identified by '@portal_mainframe#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_mainframe.* to portal_mainframe@localhost;
flush privileges;


drop database if exists `own_finances`
create database `own_finances`
use `own_finances` 

-- =========================================================================== --
-- ======================== create a table =================================== --
-- =========================================================================== --
drop table if exists `own_finances`;
create table `own_finances`(
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `income` decimal(15,2) not null ,
  `expenses` decimal(15,2) not null ,
  `description` text null,
  `create` timestamp DEFAULT current_timestamp,
  `modified` DATETIME,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- insert into `own_finances` values (null,400,0,'savings',now(),now()); -- income
-- insert into `own_finances`.`own_finances` values (null,0,52.00,'snacks',now(),now()); -- expenses

select * from `own_finances`.`own_finances`


-- =========================================================================== --
-- ======================== create a view ==================================== --
-- =========================================================================== --

drop view if exists `own_view_finances`
create view `own_view_finances`
as
select 
		 sum(income) as 'income' 
		,sum(expenses) as 'expenses'
		,sum(income) - sum(expenses) as 'total' 
from `own_finances`


select * from `own_finances`.own_view_finances






