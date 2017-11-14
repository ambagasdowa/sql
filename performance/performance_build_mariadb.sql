-- ==================================================================================================================== --	
-- ========================================     App Performance Client      =========================================== --
-- ==================================================================================================================== --

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 06, 2017
 Description    : Build Tables for Performance Clients App
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

-- create database portal_apps;
-- create an user to portal_apps

grant usage on portal_apps.* to portal_apps@localhost identified by '@portal_apps#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_apps.* to portal_apps@localhost;
grant file on *.* to 'portal_apps'@'localhost';
flush privileges;

SHOW GRANTS FOR 'portal_apps'@'localhost';

flush privileges;

use portal_apps
drop table performance_references

-- GRANT FILE ON *.* TO 'user'@'%';

-- Add external DB Sources
-- ==================================================================================================================== --	
-- ====================================     Performance Customers(Catalog) View    ==================================== --
-- ==================================================================================================================== --
CREATE TABLE performance_customers ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';
-- select * from portal_apps.performance_customers
-- ==================================================================================================================== --	
-- ==================================     Performance References(Facturas) View    ==================================== --
-- ==================================================================================================================== --

-- CREATE TABLE performance_references CHARACTER SET utf8 COLLATE utf8_general_ci ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';
CREATE TABLE performance_references DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';
-- select * from portal_apps.performance_references
-- OR utf8_unicode_ci
-- DEFAULT CHARSET=latin1
-- the issue for a charset conversion is in the latin1

-- ==================================================================================================================== --	
-- ===================================     Performance Control(Facturas) View    ====================================== --
-- ==================================================================================================================== --
-- Add Facturas Controls

-- drop table `portal_apps`.`performance_facturas`
CREATE TABLE IF NOT EXISTS `performance_facturas` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `performance_customers_id` 	varchar(250) not null,
  `performance_references_id`	varchar(250) not null,
  `performance_bsus_id`			varchar(250) not null,	
  `entregaFacturaCliente`		datetime default NULL,
  `aprobacionFactura`			datetime default NULL,
  `fechaPromesaPago`			datetime default NULL,
  `fechaPago`					datetime default NULL,
  `user_id` 					varchar(20) NOT NULL, 
  `status` 						boolean NOT NULL default true,
  `created` 					datetime default NULL,
  `modified` 					datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  CHARACTER SET utf8 COLLATE utf8_general_ci ;

select * from `portal_apps`.`performance_facturas`

-- truncate table `portal_apps`.`performance_facturas`

-- ==================================================================================================================== --	
-- =================================     Performance Dashboard(Facturas) View    ====================================== --
-- ==================================================================================================================== --
-- Add Facturas Dashboard

create or replace view `performance_view_facturas`
as
select 
		 `reference`.id
		,`reference`.performance_customers_id
		,`reference`.Empresa
		,`reference`.Nombre
		,`reference`.Folio
		,`reference`.Flete
		,`reference`.Referencia
		,`reference`.Lote
		,`reference`.ElaboracionFactura
		,`facturas`.id as 'performance_facturas_id'
		,`facturas`.performance_references_id
		,`facturas`.performance_bsus_id
		,`facturas`.entregaFacturaCliente
		,ifnull(timestampdiff(day,`reference`.ElaboracionFactura,`facturas`.entregaFacturaCliente), 0) as 'deliver'
		,`facturas`.aprobacionFactura
		,ifnull(timestampdiff(day,`facturas`.entregaFacturaCliente,`facturas`.aprobacionFactura),0) as 'proved'
		,`facturas`.fechaPromesaPago
		,ifnull(timestampdiff(day,`facturas`.aprobacionFactura,`facturas`.fechaPromesaPago),0) as 'promise'
		,`facturas`.fechaPago
		,ifnull(timestampdiff(day,`facturas`.fechaPromesaPago,`facturas`.fechaPago),0) as 'payment'
from
		`portal_apps`.performance_references as `reference`
	left join 
		`portal_apps`.performance_facturas as `facturas`
	on 
		`reference`.id = `facturas`.performance_references_id
	and 
		`reference`.performance_customers_id = `facturas`.performance_customers_id
	and 
		`reference`.Empresa = `facturas`.performance_bsus_id


-- select * from `portal_apps`.`performance_view_facturas`
-- where
-- 		Empresa = 'TEICUA'
-- 	and 
-- 		year(ElaboracionFactura)= '2017'
-- 	and 
-- 		month(ElaboracionFactura)= '10'
-- 	and 
-- 		day((ElaboracionFactura)) = '24'
		
-- ==================================================================================================================== --	
-- ===================================     year view selector    ====================================== --
-- ==================================================================================================================== --
create or replace view `performance_years`
as
select 
	year(`prefe`.ElaboracionFactura) as 'performance_year' 
from 
	`portal_apps`.performance_references as `prefe`
group by 
	year(`prefe`.ElaboracionFactura)

select * from portal_apps.performance_years

-- row  numbering example	
 -- SELECT @rownum:=@rownum+1 as id, performance_months.*
-- FROM (SELECT @rownum:=0) r, performance_months;
	
-- ==================================================================================================================== --	
-- ===================================     month View    ====================================== --
-- ==================================================================================================================== --
create or replace view `performance_months`
as
select 
	 `pron`.month_num
	,`pron`.month_name
from 
	mssql_integradb.generals_month_translations as `pron`

-- ==================================================================================================================== --	
-- ===================================     Bsu View    ====================================== --
-- ==================================================================================================================== --

	
create or replace view `performance_bsus`
as
select 
	 	 
	 	 `bsu`.tname as 'id'
	 	,`bsu`.id as 'idx'
		,`bsu`.projections_corporations_id
		,`bsu`.id_area
		,`bsu`.name
		,`bsu`.label
		,`bsu`.tname
from
	mssql_integradb.general_view_bussiness_units as `bsu`

	
	

	
-- =================== TEST =========================== --

-- search bsu 

select * from mssql_integradb.general_view_bussiness_units



use portal_apps
show variables like "character_set_database";
SHOW FULL COLUMNS FROM `portal_apps`.performance_references;

use portal_users
SHOW FULL COLUMNS FROM `portal_users`.users;

select
	*
from
	portal_apps.performance_references
where
		Empresa = 'TEICUA'
	and 
		year(ElaboracionFactura)= '2017'
	and 
		month(ElaboracionFactura)= '10'
	and 
		day((ElaboracionFactura)) = '24'
	
-- 	
-- 	
-- 	SELECT NULLIF(0,2);
-- 	
-- 	select ifnull(null,0);
-- 	