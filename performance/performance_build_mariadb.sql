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

use portal_apps
-- drop table `portal_apps`.performance_references
-- CREATE TABLE performance_references CHARACTER SET utf8 COLLATE utf8_general_ci ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';
CREATE TABLE performance_references DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC'
-- SRCDEF='select * from sistemas.dbo.performance_references where year(ElaboracionFactura) in (year(dateadd(year,-1,cast(CURRENT_TIMESTAMP as date))),year(current_timestamp))'
;
-- select * from portal_apps.performance_references
-- OR utf8_unicode_ci
-- DEFAULT CHARSET=latin1
-- the issue for a charset conversion is in the latin1

--    Testing of performance 
-- use portal_apps
-- drop table performance_references_test 
-- use portal_apps
-- CREATE TABLE performance_references_test 
-- DEFAULT CHARSET=latin1 ENGINE=CONNECT 
-- TABNAME=performance_references
-- CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' 
-- table_type='ODBC'
-- -- memory=2
-- SRCDEF='select * from sistemas.dbo.performance_references where year(ElaboracionFactura) in (year(dateadd(year,-1,cast(CURRENT_TIMESTAMP as date))),year(current_timestamp))'
-- ;


-- ==================================================================================================================== --	
-- ==================================     Performance References(Viajes) View    ==================================== --
-- ==================================================================================================================== --

-- use `portal_apps`
-- drop table `portal_apps`.performance_trips

CREATE TABLE performance_trips DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';

-- select * from `portal_apps`.performance_trips

-- ==================================================================================================================== --	
-- ==================================     Performance (Fractions) View    ==================================== --
-- ==================================================================================================================== --

-- use `portal_apps`
-- drop table `portal_apps`.performance_fractions

CREATE TABLE performance_fractions DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';

-- select * from `portal_apps`.performance_fractions

-- ==================================================================================================================== --	
-- ==================================     Performance (Clasifications) View    ==================================== --
-- ==================================================================================================================== --

-- use `portal_apps`
-- drop table `portal_apps`.performance_catalogs

CREATE TABLE performance_catalogs DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';

-- select * from `portal_apps`.performance_catalogs

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
		,`reference`.Total
		,`reference`.ElaboracionFactura
		,`facturas`.id as 'performance_facturas_id'
		,`facturas`.performance_references_id
		,`facturas`.performance_bsus_id
		,`facturas`.entregaFacturaCliente -- 1
		,ifnull(abs(datediff(`reference`.ElaboracionFactura,`facturas`.entregaFacturaCliente)), 0) as 'deliver'
		,`facturas`.aprobacionFactura     -- 2
		,ifnull(abs(datediff(`facturas`.entregaFacturaCliente,`facturas`.aprobacionFactura)),0) as 'proved'
		,ifnull(adddate(`facturas`.aprobacionFactura,`reference`.diasCredito),0) as 'fechaPromesaPago'  -- is not a editable field
		,ifnull(abs(datediff(`facturas`.aprobacionFactura, ifnull(adddate(`facturas`.aprobacionFactura,`reference`.diasCredito),0) )),0) as 'promise'
-- 		,`facturas`.fechaPago
		,ifnull(`facturas`.fechaPago,`reference`.paymentDate) as 'fechaPago' -- 3
		,ifnull(abs(datediff(ifnull(adddate(`facturas`.aprobacionFactura,`reference`.diasCredito),0),ifnull(`facturas`.fechaPago,`reference`.paymentDate))),0) as 'payment'
		,`reference`.Cuenta
		,`reference`.CuentaDesc
		,`reference`.Clasificacion
		,( -- if zero then all field is complete
			select (
				(`facturas`.entregaFacturaCliente is null) + 
				(`facturas`.aprobacionFactura is null) + 
				(ifnull(`facturas`.fechaPago,`reference`.paymentDate) is null)
		 	)
		 ) as 'dmon'
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
	and
		`facturas`.status = '1'
		
		
		select * from portal_apps.performance_facturas where id = '80'
		
	
		
		-- CHECK THIS
		select * from portal_apps.performance_viajes where performance_num_guia_id = 'OO-046636'
	
		select  id,internal_id,num_guia,recepcionEvidencias,fecha_modifico,entregaEvidenciasCliente
				,validacionEvidenciasCliente,created,modified
		from portal_apps.performance_view_viajes where num_guia = 'OO-046643'
		
		select  id,internal_id,num_guia,recepcionEvidencias,fecha_modifico,entregaEvidenciasCliente
				,validacionEvidenciasCliente,created,modified
		from portal_apps.performance_view_viajes where internal_id = 90
		
		
		select * from portal_users.users where id = 120
		
	

		
	select * from portal_apps.performance_view_facturas 
		where 
				performance_customers_id = 'DLO990908D79' 
			and
				ElaboracionFactura = '2018-01-11'
			and 
				Empresa = 'TBKGDL'




	select * from portal_apps.performance_facturas where performance_references_id in (
			select id 
			from portal_apps.performance_view_facturas 
			where 
				performance_customers_id = 'DLO990908D79' 
			and
				ElaboracionFactura = '2018-01-11'
			and 
				Empresa = 'TBKGDL'
	)
	

	
	
				
	select * from portal_apps.performance_view_facturas where id in ('058048','058054','058064')
	
	select * from portal_apps.performance_facturas where performance_references_id in ('058048','058054','058064')
	
	

			
-- ==================================================================================================================== --	
-- =================================     Performance Percent(Facturas) Year    ====================================== --
-- ==================================================================================================================== --
-- View Facturas By Year
-- use portal_apps
-- TODO : in Progress
create or replace view `performance_view_facturas_years`
as		
select 
-- 		ROW_NUMBER() OVER (PARTITION BY performance_customers_id ORDER BY Empresa DESC) AS row_index,
		performance_customers_id,Empresa,Nombre,round(sum(Total),2) as 'Monto',clasificacion 
from 
		`portal_apps`.performance_view_facturas where year(ElaboracionFactura) = year(now())
group by 
		performance_customers_id,Empresa,Nombre,clasificacion
		
-- select * from `portal_apps`.performance_view_facturas_years where facturas 

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
-- 			,`viaje`.recepcionEvidencias			-- reception
			,ifnull(`viaje`.recepcionEvidencias,`trips`.fecha_modifico) as 'recepcionEvidencias'
			,ifnull(timestampdiff(day,`trips`.fecha_guia,ifnull(`viaje`.recepcionEvidencias,`trips`.fecha_modifico)), 0) as 'reception'			
			,`trips`.fecha_modifico   				-- aceptance
			,ifnull(timestampdiff(day,ifnull(`viaje`.recepcionEvidencias,`trips`.fecha_modifico),`trips`.fecha_modifico), 0) as 'aceptance'			
			,`viaje`.entregaEvidenciasCliente		-- deliver
			,ifnull(timestampdiff(day,`trips`.fecha_modifico,`viaje`.entregaEvidenciasCliente), 0) as 'deliver'			
			,`viaje`.validacionEvidenciasCliente	-- validation
			,ifnull(timestampdiff(day,`viaje`.entregaEvidenciasCliente,`viaje`.validacionEvidenciasCliente), 0) as 'validation'
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
		and
			`viaje`.status = 1


-- ==================================================================================================================================
 
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

	
	
-- select * from `portal_apps`.performance_bsus

-- ==================================================================================================================== --	
-- ===================================     Catalog View    ====================================== --
-- ==================================================================================================================== --
	
use `portal_apps`
show tables

create or replace view `performance_view_catalogs`
as
select 
		clasification 
from 
		`portal_apps`.performance_catalogs
group by
		clasification
	
-- =================== TEST =========================== --
		
use portal_apps

	select 
			usr.name,usr.last_name,
			usr.username,ctr.clear_key
	from portal_apps.control_desk_user_controls ctr
	left join 
		portal_users.users as usr on ctr.user_id = usr.id
		

-- 	