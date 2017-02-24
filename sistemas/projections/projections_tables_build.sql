------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Struct for tables on projections v 3.0 unfortunally this -- going to be in mssql
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog ProjectionsGlobalCorp
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.projections_global_corps', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_global_corps; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[projections_global_corps](
		id									int identity(1,1),
        projections_global_companies_name	nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		projections_global_companies_desc	nvarchar(2000)		collate		sql_latin1_general_cp1_ci_as,
		created								datetime,
		modified							datetime,
		user_id								int,
		projections_standings_id			int,
		projections_parents_id				int,
		_status								tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

insert into dbo.projections_global_corps values	('GST','Grupo Servicios de Transporte',CURRENT_TIMESTAMP,null,'1',null,null,1);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog ProjectionsCompanies --issue with cake
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.projections_corporations', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_corporations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[projections_corporations](
		id							int identity(1,1),
		id_projections_global_corps	int,
        projections_companies_name	nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		projections_companies_desc	nvarchar(2000)		collate		sql_latin1_general_cp1_ci_as,
		created						datetime,
		modified					datetime,
		user_id						int,
		projections_standings_id	int,
		projections_parents_id		int,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go
insert into dbo.projections_corporations values	(1,'TBK','Bonampak',CURRENT_TIMESTAMP,null,'1',null,null,1),
												(1,'ATM','Macuspana',CURRENT_TIMESTAMP,null,'1',null,null,1),
												(1,'TEI','Teisa',CURRENT_TIMESTAMP,null,'1',null,null,1);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog ProjectionsUnits
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

use sistemas;
-- go
IF OBJECT_ID ('projections_view_bussiness_units', 'V') IS NOT NULL
    DROP VIEW projections_view_bussiness_units;
-- go

create view projections_view_bussiness_units
with encryption
as
select
		row_number()
	over 
		(order by name) as 
							id,
							projections_corporations_id,
							id_area,
							name
	from(

			--select (select 0) as 'projections_corporations_id',(select 0) as 'id_area', (select 'SIN ASIGNAR') as 'name'
			--union all
			select
					(select 1) as 'projections_corporations_id',tbk.id_area as 'id_area',ltrim(rtrim(replace(replace(replace(replace(replace(tbk.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'name'
			from 
					bonampakdb.dbo.general_area as tbk
			where 
					tbk.id_area <> 0
				union all
			select
					(select 2) as 'projections_corporations_id',atm.id_area as 'id_area',ltrim(rtrim(replace(replace(replace(replace(replace(atm.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'name'
			from 
					macuspanadb.dbo.general_area as atm
			where 
					atm.id_area <> 0
				union all
			select
					(select 3) as 'projections_corporations_id',tei.id_area as 'id_area',ltrim(rtrim(replace(replace(replace(replace(replace(tei.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'name'
			from 
					tespecializadadb.dbo.general_area as tei
			where
					tei.id_area <> 0
		) as result
-- go




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Monitor maximun closed period by bunit
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

use sistemas;
-- go
IF OBJECT_ID ('projections_view_closed_period_units', 'V') IS NOT NULL
    DROP VIEW projections_view_closed_period_units;
-- go

create view projections_view_closed_period_units
with encryption
as
	select 
			unit.id as 'id',unit.projections_corporations_id as 'projections_corporations_id',
			unit.id_area as 'id_area',
			unit.name as 'name',closted.projections_closed_periods as 'projections_closed_periods'
	from sistemas.dbo.projections_view_bussiness_units as unit
		left join 
					(
						select 
								closed.id_area as 'id_area',
								max(closed.projections_closed_periods) as 'projections_closed_periods',
								units.projections_corporations_id as 'projections_corporations_id',
								units.name as 'name'
						from 
								sistemas.dbo.projections_closed_period_controls as closed
							inner join sistemas.dbo.projections_view_bussiness_units as units
								on closed.projections_corporations_id = units.projections_corporations_id and closed.id_area = units.id_area and closed._status = 1
						group by closed.id_area,units.name, units.projections_corporations_id
					) as closted
		on closted.projections_corporations_id = unit.projections_corporations_id and closted.id_area = unit.id_area
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Access CatalogModules
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_access_modules', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_access_modules; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[projections_access_modules](
		id									int identity(1,1),
		projections_module_name				nvarchar(60) 		collate		sql_latin1_general_cp1_ci_as,
		projections_modules_description		text,
		created								datetime,
		modified							datetime,
		_status								tinyint default 1 null
--		,constraint ak_user_id unique(user_id)
) on [primary]
-- go

set ansi_padding off
-- go


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls projectionsControlsUsers
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_controls_users', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_controls_users; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[projections_controls_users](
		id										int identity(1,1),
		user_id									int,
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null
--		,constraint ak_user_id unique(user_id)
) on [primary]
-- go

set ansi_padding off
-- go

-- select * from projections_controls_users

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Access projectionsBussinesUnitModulesAccess
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_accesses', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_accesses;
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[projections_accesses](
		id										int identity(1,1),
		projections_controls_users_id			int,
		projections_access_modules_id			int,
		projections_view_bussiness_units_id		int,
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null
--		,constraint ak_user_id unique(user_id)
) on [primary]
-- go

set ansi_padding off
-- go





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls ProjectionsClosedPeriodControls /* Core */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_closed_period_controls', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_closed_period_controls; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table dbo.projections_closed_period_controls(
		id										int identity(1,1),
		user_id									int, --> the user that close the period
		projections_closed_periods				date, --> this must be better !! this -- going to be and update or secuencial data ?? XDXDXD! this is bk-shit!
		projections_view_bussiness_units_id		int,
		projections_corporations_id				int,
		id_area									int,
		projections_status_period				tinyint default 1 null, -- and '0' must be close in theory only closed periods must be appear
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null  --and 0 must be close
) on [primary]
-- go

set ansi_padding off
-- go


/* TESTING */

	--> SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP), 0) AS 'year_month_date_field' <-- selected

	--select ( CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + (select right('00'+convert(nvarchar(2),MONTH(current_timestamp)), 2)) )

	--exec sistemas.dbo.sp_builder_mr_periods_accounts 
	--											'2016', -- @period 
	--											0,          -- @day
	--											'|' 
	--											;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Data ProjectionsClosedPeriodDatas /* CoreData */  hir -- goes all extracted data from the views
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_closed_period_datas', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_closed_period_datas; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table dbo.projections_closed_period_datas(
		id											int identity(1,1),
		user_id										int, --> the user that close the period
		projections_closed_period_controls_id		int,
		--------------------------------------------------------------------
		id_area										int,
		id_unidad									varchar(10) not null,
		id_configuracionviaje						int,
		id_tipo_operacion							int,
		id_fraccion									int,
		id_flota									int,
		no_viaje									int,
		fecha_guia									varchar(10),
		mes											varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
		f_despachado								datetime,
		cliente										varchar(60),
		kms_viaje									int,
		kms_real									int,
		subtotal									decimal(18,6),
		peso										decimal(18,6),
		configuracion_viaje							varchar(20),
		tipo_de_operacion							varchar(20),
		flota										varchar(40),
		area										varchar(40),
		fraccion									varchar(60),
		company										int,
		trip_count									tinyint,
		--------------------------------------------------------------------
		created										datetime,
		modified									datetime,
		_status										tinyint default 1 null  --and 0 must be close
) on [primary]
-- go

set ansi_padding off
-- go


--================================================================================================================================================================================
-- Config set the fracction definitions
--================================================================================================================================================================================

use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_fraccion_defs', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_fraccion_defs; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table dbo.projections_fraccion_defs(
		id										int identity(1,1),
		user_id									int, --> the user that close the period
		projections_rp_definition				nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null  --and 0 must be close
) on [primary]
-- go

set ansi_padding off
-- go

insert into dbo.projections_fraccion_defs values (1,'GRANEL',CURRENT_TIMESTAMP,null,1),(1,'OTROS',CURRENT_TIMESTAMP,null,1);
-- select * from dbo.projections_fraccion_defs
--================================================================================================================================================================================
-- Config set the fracction definitions
--================================================================================================================================================================================

use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_fraccion_groups', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_fraccion_groups; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table dbo.projections_fraccion_groups(
		id										int identity(1,1),
		user_id									int, --> the user that close the period
		projections_corporations_id				int,
		projections_rp_fraction_id				int,
		projections_id_fraccion					int,
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null  --and 0 must be close
) on [primary]
-- go

set ansi_padding off
-- go
--truncate table sistemas.dbo.projections_fraccion_groups
--insert into sistemas.dbo.projections_fraccion_groups values	
--													 (1,1,1,1,CURRENT_TIMESTAMP,null,1),(1,1,1,6,CURRENT_TIMESTAMP,null,1),(1,1,1,2,CURRENT_TIMESTAMP,null,1)
--													,(1,1,2,3,CURRENT_TIMESTAMP,null,1),(1,1,2,4,CURRENT_TIMESTAMP,null,1),(1,1,2,5,CURRENT_TIMESTAMP,null,1)
--													,(1,1,2,7,CURRENT_TIMESTAMP,null,1),(1,1,2,8,CURRENT_TIMESTAMP,null,1); -- tbk
--insert into sistemas.dbo.projections_fraccion_groups values	
--													 (1,2,1,1,CURRENT_TIMESTAMP,null,1),(1,2,1,6,CURRENT_TIMESTAMP,null,1),(1,2,1,2,CURRENT_TIMESTAMP,null,1)
--													,(1,2,2,3,CURRENT_TIMESTAMP,null,1),(1,2,2,4,CURRENT_TIMESTAMP,null,1),(1,2,2,5,CURRENT_TIMESTAMP,null,1)
--													,(1,2,2,7,CURRENT_TIMESTAMP,null,1); -- atm
--insert into sistemas.dbo.projections_fraccion_groups values	
--													 (1,3,1,1,CURRENT_TIMESTAMP,null,1),(1,3,1,6,CURRENT_TIMESTAMP,null,1),(1,3,1,2,CURRENT_TIMESTAMP,null,1)
--													,(1,3,2,3,CURRENT_TIMESTAMP,null,1),(1,3,2,4,CURRENT_TIMESTAMP,null,1),(1,3,2,5,CURRENT_TIMESTAMP,null,1)
--													; -- tei

--select * from sistemas.dbo.projections_fraccion_groups
--select * from sistemas.dbo.projections_view_fractions

--================================================================================================================================================================================
-- Catalog of the fracction definitions
--================================================================================================================================================================================

use sistemas;
-- go
IF OBJECT_ID ('projections_view_fractions', 'V') IS NOT NULL
    DROP VIEW projections_view_fractions;
-- go

create view projections_view_fractions
with encryption
as

select
		row_number()
	over 
		(order by projections_corporations_id) as 
							id,
							projections_corporations_id,
							id_fraccion,
							desc_producto
	from(

		select
				(select '1') as 'projections_corporations_id',id_fraccion,desc_producto
		from
			bonampakdb.dbo.trafico_producto as producto
		where      
				(producto.id_producto = 0) 
			and 
				producto.id_fraccion <> 0
			union all
		select
				(select '2') as 'projections_corporations_id',id_fraccion,desc_producto
		from
			macuspanadb.dbo.trafico_producto as producto
		where      
				(producto.id_producto = 0) 
			and 
				producto.id_fraccion <> 0
			union all
		select
				(select '3') as 'projections_corporations_id',id_fraccion,desc_producto
		from
			tespecializadadb.dbo.trafico_producto as producto
		where      
			(producto.id_producto = 0)
			and 
				producto.id_fraccion <> 0
		) as result
-- go
--================================================================================================================================================================================
-- View watch al id_fractions as one
--================================================================================================================================================================================

use sistemas;
-- go
IF OBJECT_ID ('projections_view_company_fractions', 'V') IS NOT NULL
    DROP VIEW projections_view_company_fractions;
-- go

create view projections_view_company_fractions
with encryption
as
select
		row_number()
	over 
		(order by projections_corporations_id) as 
							id,
							projections_corporations_id,
							projections_rp_definition,
							projections_rp_fraction_id,
							projections_id_fraccion
	from(
			select 
					groups.projections_corporations_id as 'projections_corporations_id',
					groups.projections_rp_fraction_id as 'projections_rp_fraction_id',
					def.projections_rp_definition as 'projections_rp_definition',
					groups.projections_id_fraccion as 'projections_id_fraccion'
					--corp.projections_companies_desc,
					--fr.desc_producto
					--* 
			from 
					sistemas.dbo.projections_fraccion_groups as groups  
				inner join 
					sistemas.dbo.projections_fraccion_defs as def 
						on def.id = groups.projections_rp_fraction_id
				inner join
					sistemas.dbo.projections_corporations as corp 
						on groups.projections_corporations_id = corp.id
				inner join 
					sistemas.dbo.projections_view_fractions as fr 
						on fr.id_fraccion = groups.projections_id_fraccion 
						and 
							fr.projections_corporations_id = groups.projections_corporations_id
			group by	groups.projections_corporations_id,
						groups.projections_rp_fraction_id,
						def.projections_rp_definition,
						groups.projections_id_fraccion
	) as result


--================================================================================================================================================================================
-- Full Query for monthy opsInd
--================================================================================================================================================================================

use sistemas;
-- go
IF OBJECT_ID ('projections_view_indicators_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_indicators_periods;
-- go
SET ANSI_NULLS ON
-- go
SET QUOTED_IDENTIFIER ON
-- go
create view projections_view_indicators_periods

with encryption
as

WITH operations_ind
					(  
							company,id_area,area,id_fraccion
							,fraccion,cyear,mes
							,kms_real
							,kms_viaje
							,subtotal
							,peso
							,non_zero
					)
	as (
			select 
					company,id_area,area
					--,id_flota,flota,
					,id_fraccion,fraccion
					,year(fecha_guia) as 'cyear'
					,mes
					--,tipo_de_operacion
					,case
						when trip_count = 1
							then sum(kms_real)
						else
							cast ((select '0') as int)
					end as 'kms_real'
					--,sum(kms_real) as 'kms-real'
					,case
						when trip_count = 1
							then sum(kms_viaje)
						else
							cast ((select '0') as int)
					end as 'kms_viaje'
					--,sum(kms_viaje) as 'kms-viaje'
					,sum(subtotal) as 'subtotal',sum(peso) as 'peso'
					,case
						when trip_count = 1
							then count(trip_count)
						else
							cast ((select '0') as int)
					end as 'non_zero'
			from
					sistemas.dbo.projections_upt_indops as indupt
					--left join	
					--	sistemas.dbo.projections_upt_cancelations as uptc
					--openquery(local, 'exec sistemas.dbo.sp_xd4e_fullByMonthCompanyOperations "xxxx","xx",0')
			group by
					company,id_area,area
					,id_fraccion,fraccion
					,year(fecha_guia)
					,mes
					,trip_count
			union all
			select 
					company,id_area,area
					--,id_flota,flota,
					,id_fraccion,fraccion
					,year(fecha_guia) as 'cyear'
					,mes
					--,tipo_de_operacion
					,case
						when trip_count = 1
							then sum(kms_real)
						else
							cast ((select '0') as int)
					end as 'kms_real'
					,case
						when trip_count = 1
							then sum(kms_viaje)
						else
							cast ((select '0') as int)
					end as 'kms_viaje'
					,sum(subtotal) as 'subtotal',sum(peso) as 'peso'
					,case
						when trip_count = 1
							then count(trip_count)
						else
							cast ((select '0') as int)
					end as 'non_zero'
			from
					sistemas.dbo.projections_closed_period_datas
			where
					_status = 1
			group by
					company,id_area,area
					,id_fraccion,fraccion
					,year(fecha_guia)
					,mes
					,trip_count
		)

select
		row_number()
	over 
		(order by id_area) as 
							id,
							company,
							id_area,
							area,
							id_fraccion,
							fraccion,
							cyear,
							mes,
							kms,
							subtotal,
							peso,
							dsubtotal,
							dpeso,
							subsubtotal,
							subpeso,
							non_zero
	from(
		select 			
				opsind.company,opsind.id_area,opsind.area,opsind.id_fraccion
				,opsind.fraccion,opsind.cyear,opsind.mes
				,case
					when opsind.id_fraccion in ( 
											select projections_id_fraccion 
											from sistemas.dbo.projections_view_company_fractions 
											where projections_corporations_id = opsind.company and projections_rp_fraction_id = 1) -- means granel
						then 
							(sum(opsind.kms_viaje)*2)
					when opsind.id_fraccion in (	
											select projections_id_fraccion 
											from sistemas.dbo.projections_view_company_fractions 
											where projections_corporations_id = opsind.company and projections_rp_fraction_id = 2) -- means otros
						then 
							sum(opsind.kms_real)
					else
						null
				end as 'kms'
				,sum(opsind.subtotal) as 'subtotal'
				,sum(opsind.peso) as 'peso'
				,(uptops.subtotal) as 'dsubtotal',(uptops.peso) as 'dpeso'
				, (sum(opsind.subtotal) - isnull(uptops.subtotal,0)) as 'subsubtotal'
				, (sum(opsind.peso) - isnull(uptops.peso,0)) as 'subpeso'
				,sum(opsind.non_zero) as 'non_zero'
		from 
				operations_ind opsind
				left join
							(
								select 
										uptc.company,uptc.id_area
										,uptc.Area as 'area'
										,uptc.id_fraccion
										,(select desc_producto from dbo.projections_view_fractions as fr where fr.projections_corporations_id = uptc.company and fr.id_fraccion = uptc.id_fraccion) as 'fraccion'
										,year(uptc.fecha_cancelacion) as 'cyear'
										,uptc.mes
										,(select NULL) as 'kms'
										,sum(uptc.subtotal) as 'subtotal'
										,sum(uptc.peso) as 'peso'
										,(select NULL) as 'non_zero'
								from
										sistemas.dbo.projections_upt_cancelations as uptc
								group by 
											uptc.company
										,uptc.id_area
										,uptc.Area
										,uptc.id_fraccion
										,year(uptc.fecha_cancelacion)
										--,datename(mm,uptc.fecha_cancelacion)
										,mes
								union all 
								select 
										disstc.company,disstc.id_area
										,disstc.Area as 'area'
										,disstc.id_fraccion
										,(select desc_producto from dbo.projections_view_fractions as fr where fr.projections_corporations_id = disstc.company and fr.id_fraccion = disstc.id_fraccion) as 'fraccion'
										,year(disstc.fecha_cancelacion) as 'cyear'
										,disstc.mes
										,(select NULL) as 'kms'
										,sum(disstc.subtotal) as 'subtotal'
										,sum(disstc.peso) as 'peso'
										,(select NULL) as 'non_zero'
								from
										sistemas.dbo.projections_dissmiss_cancelations as disstc
								group by 
											disstc.company
										,disstc.id_area
										,disstc.Area
										,disstc.id_fraccion
										,year(disstc.fecha_cancelacion)
										--,datename(mm,disstc.fecha_cancelacion)
										,mes
							) as uptops on uptops.company = opsind.company 
								and uptops.id_area = opsind.id_area
								and uptops.cyear = opsind.cyear
								and uptops.id_fraccion = opsind.id_fraccion
								and uptops.mes = opsind.mes
						
		group by 
				opsind.company,opsind.id_area,opsind.area,opsind.id_fraccion,opsind.fraccion,opsind.cyear,opsind.mes,uptops.subtotal,uptops.peso
		) as result
-- go

--select * from projections_view_indicators_periods

--================================================================================================================================================================================
-- Core set table update every accepted Porte Letter
--================================================================================================================================================================================

use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_upt_indops', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_upt_indops; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table dbo.projections_upt_indops(
		id											int identity(1,1),
		user_id										int, --> the user that close the period
		projections_closed_period_controls_id		int,
		--------------------------------------------------------------------
		id_area										int,
		id_unidad									varchar(10) not null,
		id_configuracionviaje						int,
		id_tipo_operacion							int,
		id_fraccion									int,
		id_flota									int,
		no_viaje									int,
		fecha_guia									varchar(10),
		mes											varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
		f_despachado								datetime,
		cliente										varchar(60),
		kms_viaje									int,
		kms_real									int,
		subtotal									decimal(18,6),
		peso										decimal(18,6),
		configuracion_viaje							varchar(20),
		tipo_de_operacion							varchar(20),
		flota										varchar(40),
		area										varchar(40),
		fraccion									varchar(60),
		company										int,
		trip_count									tinyint,
		--------------------------------------------------------------------
		created										datetime,
		modified									datetime,
		_status										tinyint default 1 null  --and 0 must be close
) on [primary]
-- go

set ansi_padding off
-- go


--================================================================================================================================================================================
-- Core cancel query sets row
--================================================================================================================================================================================


use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_upt_cancelations', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_upt_cancelations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go

create table projections_upt_cancelations (
			id										int identity(1,1),
			projections_period_id					int,
			flota									nvarchar(40) collate SQL_Latin1_General_CP1_CI_AS,
			id_flota								int,
			id_fraccion								int,
			no_viaje								int,
			id_area									int,
			company									int,
			num_guia								nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
			no_guia									int,
			subtotal								decimal(18,6),
			fecha_cancelacion						datetime,
			fecha_confirmacion						datetime,
			mes										nvarchar(30) collate SQL_Latin1_General_CP1_CI_AS,
			peso									decimal(18,6),
			Area									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
			Tmov									char(1) collate SQL_Latin1_General_CP1_CI_AS,
			Cporte									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS
) on [primary]
-- go

set ansi_padding off
-- go


--================================================================================================================================================================================
-- Build Dismiss static cancel query sets
--================================================================================================================================================================================


use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_dissmiss_cancelations', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_dissmiss_cancelations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go

create table projections_dissmiss_cancelations (
			id										int identity(1,1),
			projections_period_id					int,
			flota									nvarchar(40) collate SQL_Latin1_General_CP1_CI_AS,
			id_flota								int,
			id_fraccion								int,
			no_viaje								int,
			id_area									int,
			company									int,
			num_guia								nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
			no_guia									int,
			subtotal								decimal(18,6),
			fecha_cancelacion						datetime,
			fecha_confirmacion						datetime,
			mes										nvarchar(30) collate SQL_Latin1_General_CP1_CI_AS,
			peso									decimal(18,6),
			Area									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
			Tmov									char(1) collate SQL_Latin1_General_CP1_CI_AS,
			Cporte									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS
) on [primary]
-- go

set ansi_padding off
-- go
--================================================================================================================================================================================
-- Build cancel query sets
--================================================================================================================================================================================

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Logs projectionsLogs
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_logs', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_logs; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[projections_logs](
		--id							int identity(1,1),
		id_area int,
		id_unidad varchar(10) not null,
		id_configuracionviaje int,
		id_tipo_operacion int,
		id_fraccion int,
		id_flota int,
		no_viaje int,
		fecha_guia varchar(10),
		mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
		f_despachado datetime,
		cliente varchar(60),
		kms_viaje int,
		kms_real int,
		subtotal decimal(18,6),
		peso decimal(18,6),
		configuracion_viaje varchar(20),
		tipo_de_operacion varchar(20),
		flota varchar(40),
		area varchar(40),
		fraccion varchar(60),
		company int
		,trip_count tinyint
		--,time_identifier decimal(18,2)
) on [primary]
-- go

set ansi_padding off
-- go



--========================================================================================================================================= --
-- 											Projections_Systems_Logs																		--
--========================================================================================================================================= --
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_systems_logs', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_systems_logs 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
create table [dbo].[projections_systems_logs](
		id							int identity(1,1),
		data_name					nvarchar(3000)		collate		sql_latin1_general_cp1_ci_as,
		data						nvarchar(3000)		collate		sql_latin1_general_cp1_ci_as,
		verbose_level				int,
		created						datetime,
) on [primary]
-- go
set ansi_padding off
-- go


--====================================================================================================================================================================================
-- Procedure projectionsViewResume /** Core */
--====================================================================================================================================================================================
--exec sp_xd3e_getFullCompanyOperations '2016' , '09','0'



--======================================================================= TEMPORAL ==============================================================================================
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls ProjectionsTemporalClosedPeriod /* Core */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_periods', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_periods; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table dbo.projections_periods(
		id										int identity(1,1),
		projections_closed_periods				date, --> this must be better !! this -- going to be and update or secuencial data ?? XDXDXD! this is bk-shit!
		projections_corporations_id				int,
		projections_status_period				tinyint default 1 null, -- and '0' must be close in theory only closed periods must be appear
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null  --and 0 must be close
) on [primary]
-- go

set ansi_padding off
-- go


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls ProjectionsTemporalViewClosedPeriod /* Core */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use sistemas;
-- go
IF OBJECT_ID ('projections_view_closed_periods', 'V') IS NOT NULL
    DROP VIEW projections_view_closed_periods;
-- go

create view projections_view_closed_periods
with encryption
as
select
		row_number()
	over 
		(order by projections_corporations_id) as 
							id,
							projections_closed_periods,
							projections_corporations_id,
							projections_status_period
	from(
			select 
					(select (right( CONVERT(VARCHAR(10),max(projections_closed_periods), 105), 7) ) ) as 'projections_closed_periods',
					projections_corporations_id,
					projections_status_period
			from 
					projections_periods
			where
					projections_status_period = 1
			group by 
					projections_corporations_id,
					projections_status_period
		) as result
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls ProjectionsTemporalCancelations /* Core */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_cancelations', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_cancelations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go

create table projections_cancelations (
			id										int identity(1,1),
			projections_period_id					int,
			flota									nvarchar(40) collate SQL_Latin1_General_CP1_CI_AS,
			id_flota								int,
			id_fraccion								int,
			no_viaje								int,
			id_area									int,
			company									int,
			num_guia								nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
			no_guia									int,
			subtotal								decimal(18,6),
			fecha_cancelacion						datetime,
			fecha_confirmacion						datetime,
			mes										nvarchar(30) collate SQL_Latin1_General_CP1_CI_AS,
			peso									decimal(18,6),
			Area									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
			Tmov									char(1) collate SQL_Latin1_General_CP1_CI_AS,
			Cporte									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS
) on [primary]
-- go

set ansi_padding off
-- go