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


-- drop table `portal_apps`.performance_references
-- CREATE TABLE performance_references CHARACTER SET utf8 COLLATE utf8_general_ci ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';
CREATE TABLE performance_references DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';
-- select * from portal_apps.performance_references
-- OR utf8_unicode_ci
-- DEFAULT CHARSET=latin1
-- the issue for a charset conversion is in the latin1

-- ==================================================================================================================== --	
-- ==================================     Performance References(Viajes) View    ==================================== --
-- ==================================================================================================================== --

-- use `portal_apps`
-- drop table `portal_apps`.performance_trips

CREATE TABLE performance_trips DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';

-- select * from `portal_apps`.performance_trips

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
-- use portal_apps

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
		,ifnull(adddate(`facturas`.aprobacionFactura,`reference`.diasCredito),0) as 'fechaPromesaPago'
		,ifnull(timestampdiff(day,`facturas`.aprobacionFactura, ifnull(adddate(`facturas`.aprobacionFactura,`reference`.diasCredito),0) ),0) as 'promise'
		,`facturas`.fechaPago
		,ifnull(timestampdiff(day,ifnull(adddate(`facturas`.aprobacionFactura,`reference`.diasCredito),0),`facturas`.fechaPago),0) as 'payment'
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
		
-- ==================================================================================================================== --	
-- ===================================     Performance Control(Viajes) table    ====================================== --
-- ==================================================================================================================== --
-- Add Facturas Controls


use `portal_apps`
show tables
-- drop table `portal_apps`.`performance_viajes`
CREATE TABLE IF NOT EXISTS `performance_viajes` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `performance_no_guia_id` 			varchar(250) not null,
  `performance_num_guia_id`			varchar(250) not null,
  `performance_no_viaje_id`			varchar(250) not null,
  `projections_corporations_id` 	varchar(250) not null,
  `id_area`							varchar(250) not null,
  `performance_bsus_id`				varchar(250) not null,	
  `recepcionEvidencias`				datetime default NULL,
  `entregaEvidenciasCliente`		datetime default NULL,
  `validacionEvidenciasCliente`		datetime default NULL,
  `user_id` 						varchar(20) NOT NULL, 
  `status` 							boolean NOT NULL default true,
  `created` 						datetime default NULL,
  `modified` 						datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  CHARACTER SET utf8 COLLATE utf8_general_ci ;

	
-- select * from `portal_apps`.performance_viajes


-- ==================================================================================================================== --	
-- ===================================     Performance Control(Viajes) View    ====================================== --
-- ==================================================================================================================== --
-- Add Facturas Controls

use `portal_apps`
show tables

create or replace view `performance_view_viajes`
as
	select 
			 `trips`.id
			,`trips`.id_area
			,`trips`.id_unidad
			,`trips`.id_configuracionviaje
			,`trips`.id_tipo_operacion
			,`trips`.id_fraccion
			,`trips`.id_flota
			,`trips`.no_viaje
			,`trips`.num_guia
			,`trips`.no_guia
-- 
			,`trips`.f_despachado
			,`trips`.fecha_ingreso    				-- init [not prom]
			,`trips`.fecha_guia		  				-- end
			,ifnull(timestampdiff(day,`trips`.fecha_ingreso,`trips`.fecha_guia), 0) as 'end'			
			,`viaje`.recepcionEvidencias			-- reception
			,ifnull(timestampdiff(day,`trips`.fecha_guia,`viaje`.recepcionEvidencias), 0) as 'reception'			
			,`trips`.fecha_modifico   				-- aceptance
			,ifnull(timestampdiff(day,`viaje`.recepcionEvidencias,`trips`.fecha_modifico), 0) as 'aceptance'			
			,`viaje`.entregaEvidenciasCliente		-- deliver
			,ifnull(timestampdiff(day,`trips`.fecha_modifico,`viaje`.entregaEvidenciasCliente), 0) as 'deliver'			
			,`viaje`.validacionEvidenciasCliente	-- validation
			,ifnull(timestampdiff(day,`trips`.fecha_modifico,`viaje`.validacionEvidenciasCliente), 0) as 'validation'
-- 
			,`trips`.mes
			,`trips`.id_cliente
			,`trips`.cliente
			,`trips`.kms_viaje
			,`trips`.kms_real
			,`trips`.subtotal
			,`trips`.peso
			,`trips`.configuracion_viaje
			,`trips`.tipo_de_operacion
			,`trips`.flota
			,`trips`.area
			,`trips`.fraccion
			,`trips`.company
			,`trips`.trip_count
			,`viaje`.id as 'internal_id'
-- 			,`viaje`.performance_no_guia_id,`viaje`.performance_num_guia_id,`viaje`.performance_no_viaje_id,`viaje`.projections_corporations_id
			,`viaje`.id_area as 'id_area_viaje'
			,`viaje`.performance_bsus_id
			,`viaje`.user_id
			,`viaje`.status
			,`viaje`.created
			,`viaje`.modified
	from 
			`portal_apps`.performance_trips as `trips`
	left join 
			`portal_apps`.performance_viajes as `viaje`
		on 
			`trips`.num_guia = `viaje`.performance_num_guia_id
		and 
			`trips`.no_guia = `viaje`.performance_no_guia_id
		and
			`trips`.company = `viaje`.projections_corporations_id 
		and 
			`trips`.id_area = `viaje`.id_area


--  select * from `portal_apps`.`performance_view_viajes` where fecha_guia between '2017-11-21' and '2017-11-22' and area = 'GUADALAJARA'
 
--  select * from `portal_apps`.`performance_view_viajes` where no_viaje = '81765' and num_guia = 'OG-091856' and no_guia = '102259'
 -- ==================================================================================================================================
 
 select 
 		* 
 from 
 		`portal_apps`.`performance_view_viajes` 
 where 
 		fecha_guia between '2017-11-21' and '2017-11-22' 
 	and 
 		area in ('GUADALAJARA','LA PAZ')
 	and 
 		num_guia = 'OG-091856'
  
  

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

-- select * from portal_apps.performance_years

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

	
	
select * from `portal_apps`.performance_bsus
	
-- =================== TEST =========================== --

-- search bsu 

-- select * from mssql_integradb.general_view_bussiness_units



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

		
		select * from portal_users.users where username like '%mendieta%'
		
		
		

-- 	