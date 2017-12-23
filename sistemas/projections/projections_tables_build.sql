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
--select * from sistemas.dbo.projections_view_bussiness_units
													
use sistemas;

IF OBJECT_ID ('projections_view_bussiness_units', 'V') IS NOT NULL
    DROP VIEW projections_view_bussiness_units;
-- now build the view
create view projections_view_bussiness_units
with encryption
as
with "bunits" as
(
    select
		row_number()
	over 
		(order by name) as 
							 id
							,projections_corporations_id
							,id_area
							,name
							,isnull(label,name) as 'label'
	from(
			--select (select 0) as 'projections_corporations_id',(select 0) as 'id_area', (select 'SIN ASIGNAR') as 'name'
			--union all
			select
					 (select 1) as 'projections_corporations_id'
					,tbk.id_area as 'id_area'
					,ltrim(rtrim(replace(replace(replace(replace(replace(tbk.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'name'
					,label.label
			from 
					bonampakdb.dbo.general_area as tbk
					left join 
								(
									select 
											module_data_definition,module_field_translation as 'label' 
									from 
											sistemas.dbo.projections_configs where projections_type_configs_id = 4
								) as label 
					on label.module_data_definition collate SQL_Latin1_General_CP1_CI_AS = (ltrim(rtrim(replace(replace(replace(replace(replace(tbk.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))))
			where 
					tbk.id_area <> 0
				union all
			select
					(select 2) as 'projections_corporations_id'
					,atm.id_area as 'id_area'
					,ltrim(rtrim(replace(replace(replace(replace(replace(atm.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'name'
					,label.label
			from 
					macuspanadb.dbo.general_area as atm
					left join 
								(
									select 
											module_data_definition,module_field_translation as 'label' 
									from 
											sistemas.dbo.projections_configs where projections_type_configs_id = 4
								) as label 
					on label.module_data_definition collate SQL_Latin1_General_CP1_CI_AS = (ltrim(rtrim(replace(replace(replace(replace(replace(atm.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))))
			where 
					atm.id_area <> 0
				union all
			select
					(select 3) as 'projections_corporations_id'
					,tei.id_area as 'id_area'
					,ltrim(rtrim(replace(replace(replace(replace(replace(tei.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'name'
					,label.label
			from 
					tespecializadadb.dbo.general_area as tei
					left join 
								(
									select 
											module_data_definition,module_field_translation as 'label' 
									from 
											sistemas.dbo.projections_configs where projections_type_configs_id = 4
								) as label 
					on label.module_data_definition collate SQL_Latin1_General_CP1_CI_AS = (ltrim(rtrim(replace(replace(replace(replace(replace(tei.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))))
			where
					tei.id_area <> 0
		) as result
)
	select 
			 "units".id
			,"units".projections_corporations_id
			,"units".id_area 
			,"units".name
			,"units".label
			,"cia".IDSL as 'tname'
	from 
			"bunits" as "units"
	inner join 
			(
				select IDSL,AreaLIS from integraapp.dbo.xrefcia
			)
		as "cia" on substring("units".label,1,7) = substring("cia".AreaLis,1,7)
-- go




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Monitor maximun closed period by bunit
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- select * from sistemas.dbo.projections_view_closed_period_units

select * from sistemas.dbo.projections_closed_period_controls where year(projections_closed_periods) = '2017' and month(projections_closed_periods) = '03' order by id_area
select * from sistemas.dbo.projections_closed_period_controls where year(projections_closed_periods) = '2017' and month(projections_closed_periods) = '04' order by id_area


use sistemas;

IF OBJECT_ID ('projections_view_closed_period_units', 'V') IS NOT NULL
    DROP VIEW projections_view_closed_period_units;

create view projections_view_closed_period_units
with encryption
as
	select 
			 unit.id as 'id',unit.projections_corporations_id as 'projections_corporations_id'
			,unit.id_area as 'id_area'
			,unit.name as 'name'
			,closted.projections_closed_periods as 'projections_closed_periods'
			,dateadd(month,1,closted.projections_closed_periods) as 'next_period'
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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Access CatalogModules
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]

IF OBJECT_ID('dbo.projections_access_modules', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_access_modules; 

set ansi_nulls on

set quoted_identifier on

set ansi_padding on
 
create table [dbo].[projections_access_modules](
		id									int identity(1,1),
		projections_module_name				nvarchar(60) 		collate		sql_latin1_general_cp1_ci_as,
		projections_modules_description		text,
		created								datetime,
		modified							datetime,
		_status								tinyint default 1 null
--		,constraint ak_user_id unique(user_id)
) on [primary]

set ansi_padding off



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


--================================================================================================================================================================================
-- Config set the core definitions -- Define the type of data
--================================================================================================================================================================================

use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_type_configs', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_type_configs; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table dbo.projections_type_configs(
		id										int identity(1,1),
		user_id									int, --> the user is set the definition
		module									nvarchar(50),
		module_type_int							NVARCHAR(50),
		module_lenght							nvarchar(50),
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null  --and 0 must be close
) on [primary]
-- go

set ansi_padding off

	insert into sistemas.dbo.projections_type_configs values
												('1','document_type_accepted','char','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
												('1','document_type_canceled','char','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
												('1','ops','nvarchar','10',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
												('1','label_indicadores','nvarchar','25',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
												('1','divide_operation_type_area','int','255',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
												('1','divide_operation_type_num_area','int','255',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
												('1','dispatch','int','255',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1)
-- select * from sistemas.dbo.projections_type_configs
--================================================================================================================================================================================
-- Config set the core definitions
--================================================================================================================================================================================

use [sistemas]
-- go
IF OBJECT_ID('dbo.projections_configs', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_configs; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table dbo.projections_configs(
		id										int identity(1,1),
		user_id									int, --> the user is set the definition
		projections_type_configs_id				int,
		module_data_definition					nvarchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
		module_field_translation				nvarchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null  --and 0 must be close
) on [primary]


set ansi_padding off


	insert into sistemas.dbo.projections_configs values
							('1',1,'R','regreso',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',1,'T','transito',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),							
							('1',1,'C','confirmada o Transferidas',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',1,'A','abierta o pendiente',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',2,'B','cancelada',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',3,'toneladas','subpeso',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',3,'kilometros','kms',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',3,'ingresos','subsubtotal',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',3,'viajes','non_zero',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',4,'TIJUANA','MEXICALLI',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',5,'12','LA PAZ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',6,'12','6',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',7,'toneladas','peso',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',7,'kilometros','kms',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',7,'ingresos','subtotal',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
							('1',7,'viajes','non_zero',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1)
							
-- select * from sistemas.dbo.projections_configs


--================================================================================================================================================================================
-- Config set the add-core definitions -- Define the prepsupuesto
--================================================================================================================================================================================

use [sistemas]

IF OBJECT_ID('dbo.projections_bsu_presupuestos', 'U') IS NOT NULL 
  DROP TABLE dbo.projections_bsu_presupuestos; 

set ansi_nulls on

set quoted_identifier on

set ansi_padding on

 
create table dbo.projections_bsu_presupuestos(
		id										int identity(1,1),
		user_id									int, --> the user is set the definition
		cyear									int,
		cmonth									int,
		projections_corporations_id				int,
		id_area									int,
		id_fraccion								int,
		fraction								nvarchar(50),
		bsu_name								nvarchar(50),
		bsu_label								nvarchar(50),
		"data"									decimal(18,6),
		data_desc								nvarchar(200),
		created									datetime,
		modified								datetime,
		_status									tinyint default 1 null  --and 0 must be close
) on [primary]

set ansi_padding off

	insert into dbo.projections_bsu_presupuestos values
			('1','2017','1','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',55813,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','2','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',49373,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','3','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',55813 ,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','4','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',47227,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','5','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',55813,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','6','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',55813,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','7','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',55813,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','8','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',57960,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','9','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',53667,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','10','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',55813,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','11','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',51520,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','12','3','1','1','GRANEL','CUAUTITLAN','CUAUTITLAN',49373,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1)
			;

	insert into dbo.projections_bsu_presupuestos values
			('1','2017','1','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',24960,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','2','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',22080,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','3','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',24960,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','4','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',21120,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','5','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',24960,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','6','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',24960,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','7','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',24960,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','8','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',25920,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','9','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',24000,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','10','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',24960,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','11','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',23040,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1),
			('1','2017','12','1','2','1','GRANEL','GUADALAJARA','GUADALAJARA',22080,'Volumen Transportado Tons.Granel',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1)
			;
			
--select * from sistemas.dbo.projections_bsu_presupuestos
--							
--select * from sistemas.dbo.projections_view_bussiness_units
--
--select * from sistemas.dbo.projections_view_fractions
	
			
--================================================================================================================================================================================
-- View for Core Configurations
--================================================================================================================================================================================
						
use sistemas;

IF OBJECT_ID ('projections_view_configurations', 'V') IS NOT NULL
    DROP VIEW projections_view_configurations;
    
create view projections_view_configurations
with encryption
as

	select 
			 types.id
			,types.user_id
			,types.module
			,config.module_data_definition
			,config.module_field_translation
			,types.module_type_int + '(' + types.module_lenght +')' as 'type'
	from 
			sistemas.dbo.projections_configs as config
		inner join sistemas.dbo.projections_type_configs as types 
			on types.id = config.projections_type_configs_id and types."_status" = 1
	where 
			config."_status" = 1

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


	

-- ==================================================================================================================== --	
-- =============================      full query indicators for all company    ======================================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('projections_view_full_company_indicators', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_company_indicators;
    
create view projections_view_full_company_indicators
as 
(
	select 
			 id_area ,id_unidad ,id_configuracionviaje ,id_tipo_operacion ,id_fraccion ,id_flota 
			,no_viaje ,num_guia ,fecha_guia ,mes ,f_despachado ,cliente ,kms_viaje ,kms_real ,subtotal ,peso 
			,configuracion_viaje ,tipo_de_operacion ,flota ,area ,fraccion ,company ,trip_count 	
	from 
			sistemas.dbo.projections_view_full_indicators_tbk_periods
	union all
	select 
			 id_area ,id_unidad ,id_configuracionviaje ,id_tipo_operacion ,id_fraccion ,id_flota 
			,no_viaje ,num_guia ,fecha_guia ,mes ,f_despachado ,cliente ,kms_viaje ,kms_real ,subtotal ,peso 
			,configuracion_viaje ,tipo_de_operacion ,flota ,area ,fraccion ,company ,trip_count 			
	from 
			sistemas.dbo.projections_view_full_indicators_atm_periods
	union all
	select 
			 id_area ,id_unidad ,id_configuracionviaje ,id_tipo_operacion ,id_fraccion ,id_flota 
			,no_viaje ,num_guia,fecha_guia ,mes ,f_despachado ,cliente ,kms_viaje ,kms_real ,subtotal ,peso 
			,configuracion_viaje ,tipo_de_operacion ,flota ,area ,fraccion ,company ,trip_count
	from 
			sistemas.dbo.projections_view_full_indicators_tei_periods
) 

-- ==================================================================================================================== --	
-- =================================      full indicators for bonampakdb	     ====================================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('projections_view_full_indicators_tbk_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_indicators_tbk_periods;
    
create view projections_view_full_indicators_tbk_periods

with encryption
as
	with guia_tbk as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
					,guia.num_guia
					,cast(guia.fecha_guia as date) as 'fecha_guia'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,viaje.f_despachado
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
					,"trg".peso
					,(
						select 
								descripcion
						from
								bonampakdb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								bonampakdb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								bonampakdb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								bonampakdb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							bonampakdb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'1' as 'company'
			from 
						bonampakdb.dbo.trafico_viaje as "viaje"
				inner join 
						bonampakdb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
					and 
						guia.prestamo <> 'P'
					and 
						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
				inner join
						bonampakdb.dbo.trafico_renglon_guia as "trg"
					on
						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				inner join
						bonampakdb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				inner join 
						bonampakdb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(guia.fecha_guia) = "translation".month_num
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion 
				,"guia".id_flota ,"guia".no_viaje,"guia".num_guia 
				,"guia".fecha_guia
				,"guia".mes ,"guia".f_despachado ,"guia".cliente 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else '1'
				end as 'trip_count'
	from 
				guia_tbk as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion 
				,"guia".id_flota ,"guia".no_viaje,"guia".num_guia
				,"guia".fecha_guia 
				,"guia".mes ,"guia".f_despachado ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company

				
				
				
				
-- ==================================================================================================================== --	
-- =================================      full indicators for macuspanadb	     ====================================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('projections_view_full_indicators_atm_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_indicators_atm_periods;
create view projections_view_full_indicators_atm_periods

with encryption
as			
	with guia_atm as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
					,guia.num_guia
					,cast(guia.fecha_guia as date) as 'fecha_guia'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,viaje.f_despachado
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
					,"trg".peso
					,(
						select 
								descripcion
						from
								macuspanadb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								macuspanadb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								macuspanadb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								macuspanadb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							macuspanadb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'2' as 'company'
			from 
						macuspanadb.dbo.trafico_viaje as "viaje"
				inner join 
						macuspanadb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
					and 
						guia.prestamo <> 'P'
					and 
						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
				inner join
						macuspanadb.dbo.trafico_renglon_guia as "trg"
					on
						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				inner join
						macuspanadb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				inner join 
						macuspanadb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(guia.fecha_guia) = "translation".month_num
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion 
				,"guia".id_flota ,"guia".no_viaje,"guia".num_guia
				,"guia".fecha_guia
				,"guia".mes ,"guia".f_despachado ,"guia".cliente 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else '1'
				end as 'trip_count'
	from 
				guia_atm as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion 
				,"guia".id_flota ,"guia".no_viaje ,"guia".num_guia
				,"guia".fecha_guia 
				,"guia".mes ,"guia".f_despachado ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company

				
-- ==================================================================================================================== --	
-- ===============================      full indicators for tespecializadadb	  ===================================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('projections_view_full_indicators_tei_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_indicators_tei_periods;
create view projections_view_full_indicators_tei_periods

with encryption
as
	with guia_tei as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
					,guia.num_guia
					,cast(guia.fecha_guia as date) as 'fecha_guia'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,viaje.f_despachado
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
					,"trg".peso
					,(
						select 
								descripcion
						from
								tespecializadadb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								tespecializadadb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								tespecializadadb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								tespecializadadb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							tespecializadadb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'3' as 'company'
			from 
						tespecializadadb.dbo.trafico_viaje as "viaje"
				inner join 
						tespecializadadb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
					and 
						guia.prestamo <> 'P'
					and 
						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
				inner join
						tespecializadadb.dbo.trafico_renglon_guia as "trg"
					on
						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				inner join
						tespecializadadb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				inner join 
						tespecializadadb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(guia.fecha_guia) = "translation".month_num
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion 
				,"guia".id_flota ,"guia".no_viaje ,"guia".num_guia
				,"guia".fecha_guia
				,"guia".mes ,"guia".f_despachado ,"guia".cliente 
--				,avg("guia".kms_viaje) as 'kms_viaje' 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
--				,avg("guia".kms_real) as 'kms_real'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else '1'
				end as 'trip_count'
	from 
				guia_tei as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion 
				,"guia".id_flota ,"guia".no_viaje ,"guia".num_guia
				,"guia".fecha_guia 
				,"guia".mes ,"guia".f_despachado ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company
		
	
--================================================================================================================================================================================
-- Full Query for monthy opsInd
--================================================================================================================================================================================

use sistemas;
-- go
IF OBJECT_ID ('projections_view_indicators_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_indicators_periods;

create view projections_view_indicators_periods

with encryption
as

--SET	ANSI_NULLS	ON
--SET	ANSI_WARNINGS	ON
--SET QUOTED_IDENTIFIER ON


with operations_ind
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
			select -- get the after period live data
					 indupt.company,indupt.id_area,indupt.area
					,indupt.id_fraccion,indupt.fraccion
					,(year(indupt.fecha_guia)) as 'cyear'
					,indupt.mes
					,sum(indupt.kms_real) as 'kms_real'
					,sum(indupt.kms_viaje) as 'kms_viaje'
					,sum(indupt.subtotal) as 'subtotal'
					,sum(indupt.peso) as 'peso'
					,sum(cast(indupt.trip_count as int)) as 'non_zero'
			from
					sistemas.dbo.projections_view_full_company_indicators as indupt
				inner join 
					(
						select
								 projections_corporations_id
								,id_area
								,name
								,projections_closed_periods
								,(dateadd(month,1,projections_closed_periods)) as 'newdate'
								,year(dateadd(month,1,projections_closed_periods)) as 'newyear'
								,month((dateadd(month,1,projections_closed_periods))) as 'newmonth'
						from 
								sistemas.dbo.projections_view_closed_period_units
					) as closed_periods 
						on 
							indupt.company = closed_periods.projections_corporations_id 
						and 
							indupt.id_area = closed_periods.id_area
						and 
							year(indupt.fecha_guia) >= closed_periods.newyear
						and	
							month(indupt.fecha_guia) >= closed_periods.newmonth
			group by
					indupt.company,indupt.id_area,indupt.area
					,indupt.id_fraccion,indupt.fraccion
					,year(indupt.fecha_guia)
					,indupt.mes
			union all
			select -- get the before period closed data
					"closed".company,"closed".id_area,"closed".area
					,"closed".id_fraccion,"closed".fraccion
					,cast(substring("closed".fecha_guia,1,4) as int) as 'cyear'
					,"closed".mes collate Modern_Spanish_CI_AS as 'mes'
					,sum("closed".kms_real) as 'kms_real'
					,sum("closed".kms_viaje) as 'kms_viaje'
					,sum("closed".subtotal) as 'subtotal'
					,sum("closed".peso) as 'peso'
					,sum(cast("closed".trip_count as int)) as 'non_zero'
			from
					sistemas.dbo.projections_closed_period_datas as "closed"
			group by
					"closed".company,"closed".id_area,"closed".area
					,"closed".id_fraccion,"closed".fraccion
					,substring("closed".fecha_guia,1,4)
					,"closed".mes
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
				,case -- which field we have to show
					when opsind.id_fraccion in ( 
											select projections_id_fraccion 
											from sistemas.dbo.projections_view_company_fractions 
											where projections_corporations_id = opsind.company and projections_rp_fraction_id = 1) -- means granel
						then 
							(sum(opsind.kms_viaje)*2)
					when opsind.id_fraccion not in (	
											select projections_id_fraccion 
											from sistemas.dbo.projections_view_company_fractions 
											where projections_corporations_id = opsind.company and projections_rp_fraction_id = 1) -- means otros
						then 
							sum(opsind.kms_real)
					else
						null
				end as 'kms'
				,sum(opsind.subtotal) as 'subtotal'
				,sum(opsind.peso) as 'peso'
				,(uptops.subtotal) as 'dsubtotal',(uptops.peso) as 'dpeso'
				,(sum(opsind.subtotal) - isnull(uptops.subtotal,0)) as 'subsubtotal'
				,(sum(opsind.peso) - isnull(uptops.peso,0)) as 'subpeso'
				,sum(opsind.non_zero) as 'non_zero'
		from 
				operations_ind opsind
				left join
							(
								select 
										 uptc.company,uptc.id_area
										,uptc.Area as 'area'
										,uptc.id_fraccion
										,(select desc_producto from sistemas.dbo.projections_view_fractions as fr where fr.projections_corporations_id = uptc.company and fr.id_fraccion = uptc.id_fraccion) as 'fraccion'
										,year(uptc.fecha_cancelacion) as 'cyear'
										,uptc.mes
										,(select NULL) as 'kms'
										,sum(uptc.subtotal) as 'subtotal'
										,sum(uptc.peso) as 'peso'
										,(select NULL) as 'non_zero'
								from
										sistemas.dbo.projections_view_canceled_periods as uptc
										inner join 
													(
														select
																 projections_corporations_id
																,id_area
																,name
																,projections_closed_periods
																,(dateadd(month,1,projections_closed_periods)) as 'newdate'
																,year(dateadd(month,1,projections_closed_periods)) as 'newyear'
																,month((dateadd(month,1,projections_closed_periods))) as 'newmonth'
																,DateName( month , DateAdd( month , cast(month((dateadd(month,1,projections_closed_periods))) as int), -1 ) ) as 'mes'
														from 
																sistemas.dbo.projections_view_closed_period_units
													) as per 
														on 
															per.id_area = uptc.id_area 
														and 
															per.projections_corporations_id = uptc.company
														and	
															year(uptc.fecha_cancelacion) >= per.newyear 
--														and	
--															uptc.mes >= per.mes
														and 
															month(uptc.fecha_cancelacion) >= per.newmonth
								group by 
										 uptc.company
										,uptc.id_area
										,uptc.Area
										,uptc.id_fraccion
										,year(uptc.fecha_cancelacion)
										--,datename(mm,uptc.fecha_cancelacion)
										,uptc.mes
								union all 
								select 
										disstc.company,disstc.id_area
										,disstc.Area as 'area'
										,disstc.id_fraccion
										,(select desc_producto from sistemas.dbo.projections_view_fractions as fr where fr.projections_corporations_id = disstc.company and fr.id_fraccion = disstc.id_fraccion) as 'fraccion'
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
								and uptops.mes = opsind.mes --collate SQL_Latin1_General_CP1_CI_AS
						
		group by 
				opsind.company,opsind.id_area,opsind.area,opsind.id_fraccion,opsind.fraccion,opsind.cyear,opsind.mes,uptops.subtotal,uptops.peso
		) as result
				

/*
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
					indupt.company,indupt.id_area,indupt.area
					--,id_flota,flota,
					,indupt.id_fraccion,indupt.fraccion
					,year(indupt.fecha_guia) as 'cyear'
					,indupt.mes
					--,tipo_de_operacion
					,case
						when indupt.trip_count = 1
							then sum(indupt.kms_real)
						else
							cast ((select '0') as int)
					end as 'kms_real'
					--,sum(kms_real) as 'kms-real'
					,case
						when indupt.trip_count = 1
							then sum(indupt.kms_viaje)
						else
							cast ((select '0') as int)
					end as 'kms_viaje'
					--,sum(kms_viaje) as 'kms-viaje'
					,sum(indupt.subtotal) as 'subtotal',sum(indupt.peso) as 'peso'
					,case
						when indupt.trip_count = 1
							then count(indupt.trip_count)
						else
							cast ((select '0') as int)
					end as 'non_zero'
			from
--					sistemas.dbo.projections_upt_indops as indupt
					sistemas.dbo.view_xd3e_getFullCompanyOperations as indupt
				inner join 
					(
						select
								 projections_corporations_id
								,id_area
								,name
								,projections_closed_periods
								,(dateadd(month,1,projections_closed_periods)) as 'newdate'
								,year(dateadd(month,1,projections_closed_periods)) as 'newyear'
								,month((dateadd(month,1,projections_closed_periods))) as 'newmonth'
						from 
								sistemas.dbo.projections_view_closed_period_units
					) as closed_periods 
						on 
							indupt.company = closed_periods.projections_corporations_id 
						and 
							indupt.id_area = closed_periods.id_area
						and 
							year(indupt.fecha_guia) >= closed_periods.newyear
						and	
							month(indupt.fecha_guia) >= closed_periods.newmonth
							
			group by
					indupt.company,indupt.id_area,indupt.area
					,indupt.id_fraccion,indupt.fraccion
					,year(indupt.fecha_guia)
					,indupt.mes
					,indupt.trip_count
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
				,case -- which field we have to show
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
				,(sum(opsind.subtotal) - isnull(uptops.subtotal,0)) as 'subsubtotal'
				,(sum(opsind.peso) - isnull(uptops.peso,0)) as 'subpeso'
				,sum(opsind.non_zero) as 'non_zero'
		from 
				operations_ind opsind
				left join
							(
								select 
										 uptc.company,uptc.id_area
										,uptc.Area as 'area'
										,uptc.id_fraccion
										,(select desc_producto from sistemas.dbo.projections_view_fractions as fr where fr.projections_corporations_id = uptc.company and fr.id_fraccion = uptc.id_fraccion) as 'fraccion'
										,year(uptc.fecha_cancelacion) as 'cyear'
										,uptc.mes
										,(select NULL) as 'kms'
										,sum(uptc.subtotal) as 'subtotal'
										,sum(uptc.peso) as 'peso'
										,(select NULL) as 'non_zero'
								from
										sistemas.dbo.projections_view_canceled_periods as uptc
										inner join 
													(
														select
																 projections_corporations_id
																,id_area
																,name
																,projections_closed_periods
																,(dateadd(month,1,projections_closed_periods)) as 'newdate'
																,year(dateadd(month,1,projections_closed_periods)) as 'newyear'
																,month((dateadd(month,1,projections_closed_periods))) as 'newmonth'
																,DateName( month , DateAdd( month , cast(month((dateadd(month,1,projections_closed_periods))) as int), -1 ) ) as 'mes'
														from 
																sistemas.dbo.projections_view_closed_period_units
													) as per 
														on 
															per.id_area = uptc.id_area 
														and 
															per.projections_corporations_id = uptc.company
														and	
															year(uptc.fecha_cancelacion) >= per.newyear 
--														and	
--															uptc.mes >= per.mes
														and 
															month(uptc.fecha_cancelacion) >= per.newmonth
								group by 
										 uptc.company
										,uptc.id_area
										,uptc.Area
										,uptc.id_fraccion
										,year(uptc.fecha_cancelacion)
										--,datename(mm,uptc.fecha_cancelacion)
										,uptc.mes
								union all 
								select 
										disstc.company,disstc.id_area
										,disstc.Area as 'area'
										,disstc.id_fraccion
										,(select desc_producto from sistemas.dbo.projections_view_fractions as fr where fr.projections_corporations_id = disstc.company and fr.id_fraccion = disstc.id_fraccion) as 'fraccion'
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
								and uptops.mes = opsind.mes collate SQL_Latin1_General_CP1_CI_AS
						
		group by 
				opsind.company,opsind.id_area,opsind.area,opsind.id_fraccion,opsind.fraccion,opsind.cyear,opsind.mes,uptops.subtotal,uptops.peso
		) as result
*/

-- go

--select * from projections_view_indicators_periods

		
		
-- ======================================================================================================================================================================= --
--  Full Query partly Accepted
-- ====================================================================================================================================================================== --

use sistemas;

IF OBJECT_ID ('projections_view_indicators_periods_fleets_parts', 'V') IS NOT NULL		
    DROP VIEW projections_view_indicators_periods_fleets_parts;

create view projections_view_indicators_periods_fleets_parts

with encryption
as
with operations_ind
					(  
							 company,id_area,area
							,id_flota,flota
							,id_tipo_operacion
							,id_fraccion,fraccion
							,cyear,cmonth,mes
							,kms_real
							,kms_viaje
							,subtotal
							,peso
							,non_zero
					)
	as (
			select 
					 indupt.company,indupt.id_area
					 ,case
					 		when indupt.id_tipo_operacion = 12
					 			then 
					 				case
					 					when indupt.area = 'GUADALAJARA'
						 					then 'LA PAZ'
						 				else indupt.area	
						 			end
					 		else indupt.area
					 end as 'area'
					,indupt.id_flota,indupt.flota
					,indupt.id_tipo_operacion
					,indupt.id_fraccion,indupt.fraccion
					,year(indupt.fecha_guia) as 'cyear'
					,month(indupt.fecha_guia) as 'cmonth'
					,indupt.mes
					,sum(indupt.kms_real) as 'kms_real'
					,sum(indupt.kms_viaje) as 'kms_viaje'
					,sum(indupt.subtotal) as 'subtotal'
					,sum(indupt.peso) as 'peso'
					,sum(cast(indupt.trip_count as int)) as 'non_zero'
			from
					sistemas.dbo.projections_view_full_company_indicators as indupt
				inner join 
					(
						select
								 projections_corporations_id
								,id_area
								,name
								,projections_closed_periods
								,(dateadd(month,1,projections_closed_periods)) as 'newdate'
								,year(dateadd(month,1,projections_closed_periods)) as 'newyear'
								,month((dateadd(month,1,projections_closed_periods))) as 'newmonth'
						from 
								sistemas.dbo.projections_view_closed_period_units
					) as closed_periods 
						on 
							indupt.company = closed_periods.projections_corporations_id 
						and 
							indupt.id_area = closed_periods.id_area
						and 
							year(indupt.fecha_guia) >= closed_periods.newyear
						and	
							month(indupt.fecha_guia) >= closed_periods.newmonth
			group by
					 indupt.company,indupt.id_area,indupt.area
					,indupt.id_flota,indupt.flota
					,indupt.id_tipo_operacion
					,indupt.id_fraccion,indupt.fraccion				
					,year(indupt.fecha_guia)
					,month(indupt.fecha_guia)
					,indupt.mes
					,indupt.trip_count
			union all
			select 
					 perdat.company,perdat.id_area
					,case 
						when perdat.id_tipo_operacion = 12
							then 
								case 
									when perdat.area = 'GUADALAJARA'
										then 'LA PAZ'
									else perdat.area
								end
						else perdat.area
					 end as 'area'
					,perdat.id_flota,perdat.flota
					,perdat.id_tipo_operacion
					,perdat.id_fraccion,perdat.fraccion
					,substring(perdat.fecha_guia,1,4) as 'cyear'
					,substring(perdat.fecha_guia,6,2) as 'cmonth'
					,perdat.mes collate Modern_Spanish_CI_AS as 'mes'
					,sum(perdat.kms_real) as 'kms_real'
					,sum(perdat.kms_viaje) as 'kms_viaje'
					,sum(perdat.subtotal) as 'subtotal'
					,sum(perdat.peso) as 'peso'
					,sum(perdat.trip_count) as 'non_zero'
			from
					sistemas.dbo.projections_closed_period_datas as perdat
			where
					perdat._status = 1
			group by
					 perdat.company,perdat.id_area,perdat.area
					,perdat.id_flota,perdat.flota
					,perdat.id_tipo_operacion
					,perdat.id_fraccion,perdat.fraccion
					,substring(perdat.fecha_guia,1,4)
					,substring(perdat.fecha_guia,6,2)
					,perdat.mes
					,perdat.trip_count
		) 
select 
	 company,id_area,area
	,id_flota,flota
	,id_tipo_operacion
	,id_fraccion,fraccion
	,cyear,cmonth,mes
	,kms_real
	,kms_viaje
	,subtotal
	,peso
	,non_zero
from operations_ind


-- ==================================================================================================================== --	
-- =============================      full dispatched indicators for all company    =================================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('projections_view_full_company_dispatched_indicators', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_company_dispatched_indicators;
    
create view projections_view_full_company_dispatched_indicators
as 
(
	select 
			 id_area ,id_unidad ,id_configuracionviaje ,id_tipo_operacion ,id_fraccion ,id_flota 
			,no_viaje ,fecha_guia ,mes ,f_despachado ,cliente ,kms_viaje ,kms_real ,subtotal ,peso 
			,configuracion_viaje ,tipo_de_operacion ,flota ,area ,fraccion ,company ,trip_count 	
	from 
			sistemas.dbo.projections_view_full_dispatched_tbk_periods
	union all
	select 
			 id_area ,id_unidad ,id_configuracionviaje ,id_tipo_operacion ,id_fraccion ,id_flota 
			,no_viaje ,fecha_guia ,mes ,f_despachado ,cliente ,kms_viaje ,kms_real ,subtotal ,peso 
			,configuracion_viaje ,tipo_de_operacion ,flota ,area ,fraccion ,company ,trip_count 			
	from 
			sistemas.dbo.projections_view_full_dispatched_atm_periods
	union all
	select 
			 id_area ,id_unidad ,id_configuracionviaje ,id_tipo_operacion ,id_fraccion ,id_flota 
			,no_viaje ,fecha_guia ,mes ,f_despachado ,cliente ,kms_viaje ,kms_real ,subtotal ,peso 
			,configuracion_viaje ,tipo_de_operacion ,flota ,area ,fraccion ,company ,trip_count
	from 
			sistemas.dbo.projections_view_full_dispatched_tei_periods
) 

-- ==================================================================================================================== --	
-- ===============================      full indicators DISPACHT?? for bonampakdb	     ============================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('projections_view_full_dispatched_tbk_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_dispatched_tbk_periods;
create view projections_view_full_dispatched_tbk_periods
with encryption
as
	with guia_tbk as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
--
					,guia.num_guia
					,viaje.id_ruta
					,viaje.id_origen
					,ruta.desc_ruta
					,guia.monto_retencion
--
					,cast(guia.fecha_guia as date) as 'fecha_guia'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,cast(viaje.f_despachado as date) as 'f_despachado'
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
--					,(isnull("trg".peso,0) + isnull("trg".peso_estimado,0)) as 'peso'
					,(
						select 
								sum(isnull("tren".peso,0) + isnull("tren".peso_estimado,0)) 
						from 
								bonampakdb.dbo.trafico_renglon_guia as "tren"
						where	
								"tren".no_guia = guia.no_guia and "tren".id_area = viaje.id_area
								
					 ) as 'peso'
					,(
						select 
								descripcion
						from
								bonampakdb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								bonampakdb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								bonampakdb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								bonampakdb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							bonampakdb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'1' as 'company'
					,year("viaje".f_despachado) as 'cyear'
			from 
						bonampakdb.dbo.trafico_viaje as "viaje"
				left join 
						bonampakdb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
--					and 
--						guia.prestamo <> 'P'
--					and 
--						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
--				left join
--						bonampakdb.dbo.trafico_renglon_guia as "trg"
--					on
--						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				left join
						bonampakdb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				left join 
						bonampakdb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(viaje.f_despachado) = "translation".month_num
				inner join 
						bonampakdb.dbo.trafico_ruta as "ruta"
					on
						viaje.id_ruta = "ruta".id_ruta
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota 
				,"guia".no_viaje , "guia".num_guia , "guia".id_ruta ,"guia".id_origen ,"guia".desc_ruta, "guia".monto_retencion
				,"guia".fecha_guia
				,"guia".mes ,"guia".f_despachado ,"guia".cliente 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else '1'
				end as 'trip_count'
				,"guia".cyear
	from 
				guia_tbk as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota 
				,"guia".no_viaje, "guia".num_guia , "guia".id_ruta ,"guia".id_origen ,"guia".desc_ruta, "guia".monto_retencion
				,"guia".fecha_guia 
				,"guia".mes ,"guia".f_despachado ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company
				,"guia".cyear
				

-- ==================================================================================================================== --	
-- ===============================      full indicators DISPACHT?? for macuspanadb	     ============================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('projections_view_full_dispatched_atm_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_dispatched_atm_periods;
create view projections_view_full_dispatched_atm_periods
with encryption
as
	with guia_atm as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
					,cast(guia.fecha_guia as date) as 'fecha_guia'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,cast(viaje.f_despachado as date) as 'f_despachado'
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
					,(isnull("trg".peso,0) + isnull("trg".peso_estimado,0)) as 'peso'
					,(
						select 
								descripcion
						from
								macuspanadb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								macuspanadb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								macuspanadb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								macuspanadb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							macuspanadb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'2' as 'company'
					,year("viaje".f_despachado) as 'cyear'
			from 
						macuspanadb.dbo.trafico_viaje as "viaje"
				left join 
						macuspanadb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
--					and 
--						guia.prestamo <> 'P'
--					and 
--						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
				left join
						macuspanadb.dbo.trafico_renglon_guia as "trg"
					on
						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				left join
						macuspanadb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				left join 
						macuspanadb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(viaje.f_despachado) = "translation".month_num
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
				,"guia".fecha_guia
				,"guia".mes ,"guia".f_despachado ,"guia".cliente 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else '1'
				end as 'trip_count'
				,"guia".cyear
	from 
				guia_atm as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
				,"guia".fecha_guia 
				,"guia".mes ,"guia".f_despachado ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company
				,"guia".cyear
				
				
-- ==================================================================================================================== --	
-- ===============================      full indicators DISPACHT?? for tespecializadadb	 ============================== --
-- ==================================================================================================================== --
use sistemas
IF OBJECT_ID ('projections_view_full_dispatched_tei_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_dispatched_tei_periods;
create view projections_view_full_dispatched_tei_periods
with encryption
as
	with guia_tei as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
					,cast(guia.fecha_guia as date) as 'fecha_guia'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,cast(viaje.f_despachado as date) as 'f_despachado'
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
					,(isnull("trg".peso,0) + isnull("trg".peso_estimado,0)) as 'peso'
					,(
						select 
								descripcion
						from
								tespecializadadb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								tespecializadadb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								tespecializadadb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								tespecializadadb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							tespecializadadb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'3' as 'company'
					,year("viaje".f_despachado) as 'cyear'
			from 
						tespecializadadb.dbo.trafico_viaje as "viaje"
				left join 
						tespecializadadb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
--					and 
--						guia.prestamo <> 'P'
--					and 
--						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
				left join
						tespecializadadb.dbo.trafico_renglon_guia as "trg"
					on
						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				left join
						tespecializadadb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				left join 
						tespecializadadb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(viaje.f_despachado) = "translation".month_num
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
				,"guia".fecha_guia
				,"guia".mes ,"guia".f_despachado ,"guia".cliente 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".f_despachado) ) > 1 
						then '0' else '1'
				end as 'trip_count'
				,"guia".cyear
	from 
				guia_tei as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
				,"guia".fecha_guia 
				,"guia".mes ,"guia".f_despachado ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company
				,"guia".cyear

-- ======================================================================================================================================================================= --
--  Full Query for monthy opsInd
-- ====================================================================================================================================================================== --

use sistemas;

IF OBJECT_ID ('projections_view_indicators_periods_fleets', 'V') IS NOT NULL		
    DROP VIEW projections_view_indicators_periods_fleets;

create view projections_view_indicators_periods_fleets

with encryption
as
--SET ANSI_NULLS ON

--SET QUOTED_IDENTIFIER ON
with operations_ind
					(  
							 company,id_area,area
							,id_fraccion,fraccion
							,cyear,cmonth,mes
							,kms_real
							,kms_viaje
							,subtotal
							,peso
							,non_zero
					)
	as (
			select
				 company,id_area
				,area
				,id_fraccion,fraccion
				,cyear,cmonth,mes
				,sum(kms_real) as 'kms_real'
				,sum(kms_viaje) as 'kms_viaje'
				,sum(subtotal) as 'subtotal'
				,sum(peso) as 'peso'
				,sum(non_zero) as 'non_zero'				
			from 
					sistemas.dbo.projections_view_indicators_periods_fleets_parts
			group by
							 company,id_area,area
							,id_fraccion,fraccion
							,cyear,cmonth,mes			
		) 
select
		row_number()
	over 
		(order by id_area) as 
							id,
							company,
							id_area,
							area collate Modern_Spanish_CI_AS as 'area',
							id_fraccion,
							fraccion collate Modern_Spanish_CI_AS as 'fraccion',
							cyear,
							mes collate Modern_Spanish_CI_AS as 'mes',
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
				opsind.company
				,cast(opsind.id_area as int)  as 'id_area'
				,opsind.area collate Modern_Spanish_CI_AS as 'area'
				,opsind.id_fraccion
				,opsind.fraccion,opsind.cyear,opsind.mes
				,case -- which field we have to show
					when opsind.id_fraccion in ( 
											select prfrt.projections_id_fraccion
											from sistemas.dbo.projections_view_company_fractions as prfrt
											where prfrt.projections_corporations_id = opsind.company and prfrt.projections_rp_fraction_id = 1) -- means granel
						then 
							(sum(opsind.kms_viaje)*2)
					when opsind.id_fraccion not in (	
											select prtrf.projections_id_fraccion
											from sistemas.dbo.projections_view_company_fractions as prtrf
											where prtrf.projections_corporations_id = opsind.company and prtrf.projections_rp_fraction_id = 1) -- means otros
						then 
							sum(opsind.kms_real)
					else
						null
				end as 'kms'
				,sum(opsind.subtotal) as 'subtotal'
				,sum(opsind.peso) as 'peso'
				,(uptops.subtotal) as 'dsubtotal'
				,(uptops.peso) as 'dpeso'
				,(sum(opsind.subtotal) - isnull(uptops.subtotal,0)) as 'subsubtotal'
				,(sum(opsind.peso) - isnull(uptops.peso,0)) as 'subpeso'
				,sum(opsind.non_zero) as 'non_zero'
		from 
				operations_ind as "opsind"
				left join
							( -- Check the cancelations
								select 
										 uptc.company,uptc.id_area
										,uptc.Area as 'area'
										,uptc.id_fraccion
										,(select desc_producto from sistemas.dbo.projections_view_fractions as fr where fr.projections_corporations_id = uptc.company and fr.id_fraccion = uptc.id_fraccion) as 'fraccion'
										,year(uptc.fecha_cancelacion) as 'cyear'
										,month(uptc.fecha_cancelacion) as 'cmonth'
										,uptc.mes
										,(select NULL) as 'kms'
										,sum(uptc.subtotal) as 'subtotal'
										,sum(uptc.peso) as 'peso'
										,(select NULL) as 'non_zero'
								from
										sistemas.dbo.projections_view_canceled_periods as uptc
										inner join 
													(
														select
																 projections_corporations_id
																,id_area
																,name
																,projections_closed_periods
																,(dateadd(month,1,projections_closed_periods)) as 'newdate'
																,year(dateadd(month,1,projections_closed_periods)) as 'newyear'
																,month((dateadd(month,1,projections_closed_periods))) as 'newmonth'
																,DateName( month , DateAdd( month , cast(month((dateadd(month,1,projections_closed_periods))) as int), -1 ) ) as 'mes'
														from 
																sistemas.dbo.projections_view_closed_period_units
													) as per 
														on 
															per.id_area = uptc.id_area 
														and 
															per.projections_corporations_id = uptc.company
														and	
															year(uptc.fecha_cancelacion) >= per.newyear 
														and 
															month(uptc.fecha_cancelacion) >= per.newmonth
								group by 
										 uptc.company
										,uptc.id_area
										,uptc.Area
										,uptc.id_fraccion
										,year(uptc.fecha_cancelacion)
										,month(uptc.fecha_cancelacion)
										,uptc.mes
								union all 
								select 
										 disstc.company,disstc.id_area
										,disstc.Area collate Modern_Spanish_CI_AS as 'area'
										,disstc.id_fraccion
										,(select desc_producto from sistemas.dbo.projections_view_fractions as fr where fr.projections_corporations_id = disstc.company and fr.id_fraccion = disstc.id_fraccion) as 'fraccion'
										,year(disstc.fecha_cancelacion) as 'cyear'
										,month(disstc.fecha_cancelacion) as 'cmonth'
										,disstc.mes collate Modern_Spanish_CI_AS as 'mes'
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
										,month(disstc.fecha_cancelacion)
										,mes
							) as uptops on uptops.company = opsind.company 
								and uptops.id_area = opsind.id_area
								and uptops.area = opsind.area
								and uptops.cyear = opsind.cyear
								and uptops.id_fraccion = opsind.id_fraccion
								and uptops.cmonth = opsind.cmonth --collate SQL_Latin1_General_CP1_CI_AS
		group by 
				 opsind.company,opsind.id_area,opsind.area
				,opsind.id_fraccion,opsind.fraccion,opsind.cyear,opsind.mes
				,uptops.subtotal,uptops.peso
		) as result

-- ============================================= Dispacthed Trips ================================================================= --		
-- FULL view againts a store
-- ================================================================================================================================ --


		
use sistemas
	if OBJECT_ID('projections_view_indicators_dispatch_periods', 'V') is not null
		drop view projections_view_indicators_dispatch_periods
	create view projections_view_indicators_dispatch_periods
	
	with encryption
	
	as


WITH operations_ind
					(  
							 company,id_area,area
							,id_flota,flota
							,id_tipo_operacion
							,id_fraccion,fraccion
							,cyear,mes
							,kms_real
							,kms_viaje
							,subtotal
							,peso
							,non_zero
					)
	as (
			select 
					 indupt.company,indupt.id_area,indupt.area
					,indupt.id_flota,indupt.flota
					,indupt.id_tipo_operacion
					,indupt.id_fraccion,indupt.fraccion
					,year(indupt.f_despachado) as 'cyear'
					,indupt.mes
					--,tipo_de_operacion
					,case
						when indupt.trip_count = 1
							then sum(indupt.kms_real)
						when indupt.trip_count is null
							then sum(indupt.kms_real)
						else
							cast ((select '0') as int)
					end as 'kms_real'
					--,sum(kms_real) as 'kms-real'
					,case
						when indupt.trip_count = 1
							then sum(indupt.kms_viaje)
						when indupt.trip_count is null
							then sum(indupt.kms_viaje)
						else
							cast ((select '0') as int)
					end as 'kms_viaje'
					--,sum(kms_viaje) as 'kms-viaje'
					,sum(indupt.subtotal) as 'subtotal',sum(indupt.peso) as 'peso'
					,case
						when indupt.trip_count = 1
							then count(indupt.trip_count)
						when indupt.trip_count is null
							then count(indupt.id_area)
						else
							cast ((select '0') as int)
					end as 'non_zero'

			from	--sistemas.dbo.projections_view_full_company_dispatched_indicators
					sistemas.dbo.view_sp_xd6z_getFullCompanyOperationsDispatch as indupt						
			group by
					 indupt.company,indupt.id_area,indupt.area
					,indupt.id_flota,indupt.flota
					,indupt.id_tipo_operacion
					,indupt.id_fraccion,indupt.fraccion				
					,year(indupt.f_despachado)
					,indupt.mes
					,indupt.trip_count		
		)
select
		row_number()
	over 
		(order by id_flota) as 
							id,
							company,
							id_area,
							area,
							id_flota,
							flota,
							id_tipo_operacion,
							tipo_operacion,
							id_fraccion,
							fraccion,
							cyear,
							mes,
							kms,
							subtotal,
							peso,
							non_zero
	from(
		select 			
				opsind.company
				,cast(opsind.id_area as int)  as 'id_area'
				,
				case	
				 	when opsind.id_tipo_operacion in 	(
				 											select confi.module_data_definition from sistemas.dbo.projections_configs as confi
				 											where confi.projections_type_configs_id = 5
				 										)
				 		then
				 			(
			 					select module_field_translation from sistemas.dbo.projections_configs as conf 
			 					where conf.projections_type_configs_id = 5 and conf.module_data_definition = opsind.id_tipo_operacion
				 			)
				 	else
				 		opsind.area collate SQL_Latin1_General_CP1_CI_AS -- as 'area'
				  end as 'area'
				,opsind.id_flota,opsind.flota
				,opsind.id_tipo_operacion
				,isnull(tipoop.tipo_operacion,'Vacio') as 'tipo_operacion'
				,opsind.id_fraccion
				,opsind.fraccion
				,opsind.cyear
				,opsind.mes
				,case -- which field we have to show
					when opsind.id_fraccion in ( 
											select prfrt.projections_id_fraccion
											from sistemas.dbo.projections_view_company_fractions as prfrt
											where prfrt.projections_corporations_id = opsind.company and prfrt.projections_rp_fraction_id = 1) -- means granel
						then 
							(sum(opsind.kms_viaje)*2)
					when opsind.id_fraccion not in (	
											select prtrf.projections_id_fraccion
											from sistemas.dbo.projections_view_company_fractions as prtrf
											where prtrf.projections_corporations_id = opsind.company and prtrf.projections_rp_fraction_id = 1) -- means otros
						then 
							sum(opsind.kms_real)
					else
						null
				end as 'kms'
				,sum(opsind.subtotal) as 'subtotal'
				,sum(opsind.peso) as 'peso'
				,sum(opsind.non_zero) as 'non_zero'
		from 
				operations_ind opsind
				
				left join 
							sistemas.dbo.projections_view_operations_types as tipoop 
							on opsind.company = tipoop.company_id and opsind.id_tipo_operacion = tipoop.id_tipo_operacion

		group by 
				 opsind.company
				 ,opsind.id_area
				 ,opsind.area
 				 ,opsind.id_flota
 				 ,opsind.flota
 				 ,opsind.id_tipo_operacion
 				 ,tipoop.tipo_operacion
				 ,opsind.id_fraccion
				 ,opsind.fraccion
				 ,opsind.cyear
				 ,opsind.mes
		) as result
		
		
		
--================================================================================================================================================================================
-- FULL view againts a store by month
--================================================================================================================================================================================


		
use sistemas
	if OBJECT_ID('projections_view_indicators_dispatch_periods_full_ops', 'V') is not null
		drop view projections_view_indicators_dispatch_periods_full_ops
	create view projections_view_indicators_dispatch_periods_full_ops
	with encryption
	as
	with operations_ind
						(  
								 company,id_area,area
	--							,id_flota,flota
								,id_tipo_operacion
								,id_fraccion
								,fraccion
								,cyear,mes
								,kms_real
								,kms_viaje
								,subtotal
								,peso
								,non_zero
						)
		as (
				select 
						 indupt.company,indupt.id_area
						 ,--indupt.area
	--				case	
	--				 	when indupt.id_tipo_operacion in 	(
	--				 											select confi.module_data_definition from sistemas.dbo.projections_configs as confi
	--				 											where confi.projections_type_configs_id = 5
	--				 										)
	--				 		then
	--				 			(
	--			 					select module_field_translation from sistemas.dbo.projections_configs as conf 
	--			 					where conf.projections_type_configs_id = 5 and conf.module_data_definition = indupt.id_tipo_operacion
	--				 			)
	--				 	else
	--				 		indupt.area collate SQL_Latin1_General_CP1_CI_AS -- as 'area'
	--				  end as 'area'
					  
					case	
					 	when indupt.id_tipo_operacion = 12
					 		then
					 			case 
					 				when indupt.area = 'GUADALAJARA'
					 					then 'LA PAZ'
					 				else
					 					indupt.area collate SQL_Latin1_General_CP1_CI_AS -- as 'area'
					 			end
					 	else
					 		indupt.area collate SQL_Latin1_General_CP1_CI_AS -- as 'area'
					  end as 'area'
					  
	--					,indupt.id_flota,indupt.flota
						,indupt.id_tipo_operacion
						,indupt.id_fraccion
	--					,indupt.fraccion
						,case
							when indupt.id_fraccion is null
								then 'VACIO'
							else
								indupt.fraccion
						end as 'fraccion'
						,year(indupt.f_despachado) as 'cyear'
						,indupt.mes
						--,tipo_de_operacion
						,case
							when indupt.trip_count = 1
								then sum(indupt.kms_real)
							when indupt.trip_count is null
								then sum(isnull(indupt.kms_real,0))
							else
								cast ((select '0') as int)
						end as 'kms_real'
	--					,sum(kms_real) as 'kms_real'
						,case
							when indupt.trip_count = 1
								then sum(indupt.kms_viaje)
							when indupt.trip_count is null
								then sum(isnull(indupt.kms_viaje,0))
							else
								cast ((select '0') as int)
						end as 'kms_viaje'
						--,sum(kms_viaje) as 'kms-viaje'
						,sum(indupt.subtotal) as 'subtotal',sum(indupt.peso) as 'peso'
						,case
							when indupt.trip_count = 1
								then count(indupt.trip_count)
							when indupt.trip_count is null
								then count(indupt.id_area)
							else
								cast ((select '0') as int)
						end as 'non_zero'
				from	
						sistemas.dbo.projections_view_full_company_dispatched_indicators as indupt
						--sistemas.dbo.view_sp_xd6z_getFullCompanyOperationsDispatch as indupt						
				group by
						 indupt.company,indupt.id_area,indupt.area
	--					,indupt.id_flota,indupt.flota
						,indupt.id_tipo_operacion
						,indupt.id_fraccion,indupt.fraccion				
						,year(indupt.f_despachado)
						,indupt.mes
						,indupt.trip_count		
			)
	select
			row_number()
		over 
			(order by id_area) as 
								id,
								company,
								id_area,
								area,
	--							id_flota,
	--							flota,
	--							id_tipo_operacion,
	--							tipo_operacion,
								id_fraccion,
								fraccion,
								cyear,
								mes,
								kms,
								subtotal,
								peso,
								non_zero
	from(
			select 			
					opsind.company
					,cast(opsind.id_area as int)  as 'id_area'
					,
	--				case	
	--				 	when opsind.id_tipo_operacion in 	(
	--				 											select confi.module_data_definition from sistemas.dbo.projections_configs as confi
	--				 											where confi.projections_type_configs_id = 5
	--				 										)
	--				 		then
	--				 			(
	--			 					select module_field_translation from sistemas.dbo.projections_configs as conf 
	--			 					where conf.projections_type_configs_id = 5 and conf.module_data_definition = opsind.id_tipo_operacion
	--				 			)
	--				 	else
					 		opsind.area collate SQL_Latin1_General_CP1_CI_AS as 'area'
					  --end as 'area'
	--				,opsind.id_flota,opsind.flota
	--				,opsind.id_tipo_operacion
	--				,isnull(tipoop.tipo_operacion,'Vacio') as 'tipo_operacion'
					,opsind.id_fraccion
					,opsind.fraccion
					,opsind.cyear
					,opsind.mes
					,case -- which field we have to show
						when opsind.id_fraccion in ( 
												select prfrt.projections_id_fraccion
												from sistemas.dbo.projections_view_company_fractions as prfrt
												where prfrt.projections_corporations_id = opsind.company and prfrt.projections_rp_fraction_id = 1) -- means granel
							then 
								(sum(opsind.kms_viaje)*2)
						when opsind.id_fraccion not in (	
												select prtrf.projections_id_fraccion
												from sistemas.dbo.projections_view_company_fractions as prtrf
												where prtrf.projections_corporations_id = opsind.company and prtrf.projections_rp_fraction_id = 1) -- means otros
							then 
								sum(opsind.kms_real)
						else
							sum(opsind.kms_real)
					end as 'kms'
					,sum(opsind.subtotal) as 'subtotal'
					,sum(opsind.peso) as 'peso'
					,sum(opsind.non_zero) as 'non_zero'
			from 
					operations_ind opsind
	--				left join 
	--							sistemas.dbo.projections_view_operations_types as tipoop 
	--							on opsind.company = tipoop.company_id and opsind.id_tipo_operacion = tipoop.id_tipo_operacion
	
			group by 
					 opsind.company
					 ,opsind.id_area
					 ,opsind.area
	-- 				 ,opsind.id_flota
	-- 				 ,opsind.flota
	-- 				 ,opsind.id_tipo_operacion
	-- 				 ,tipoop.tipo_operacion
					 ,opsind.id_fraccion
					 ,opsind.fraccion
					 ,opsind.cyear
					 ,opsind.mes
	) as result
		
		
--		select * from sistemas.dbo.projections_view_full_company_dispatched_indicators
		
--================================================================================================================================================================================
-- Full Query Operaciones
--================================================================================================================================================================================

use sistemas;
-- go
IF OBJECT_ID ('projections_view_indicators_periods_full_fleets', 'V') IS NOT NULL		
    DROP VIEW projections_view_indicators_periods_full_fleets;

--create view projections_view_indicators_periods_full_fleets
create view projections_view_indicators_periods_full_fleets

with encryption
as
with operativos 
	as (	
		select 
				 "flr".area ,"flr".fraccion ,"flr".cyear ,"flr".mes ,sum("flr".kms) as 'kms' 
				,sum("flr".subsubtotal) as 'subsubtotal' ,sum("flr".subpeso) as 'subpeso' 
				,sum("flr".non_zero) as 'non_zero'
				,case 
					when ("flr".mes = 'Enero') then sum("prep".PtdBal00)
					when ("flr".mes = 'Febrero') then sum("prep".PtdBal01)
					when ("flr".mes = 'Marzo') then sum("prep".PtdBal02)
					when ("flr".mes = 'Abril') then sum("prep".PtdBal03)
					when ("flr".mes = 'Mayo') then sum("prep".PtdBal04)
					when ("flr".mes = 'Junio') then sum("prep".PtdBal05)
					when ("flr".mes = 'Julio') then sum("prep".PtdBal06)
					when ("flr".mes = 'Agosto') then sum("prep".PtdBal07)
					when ("flr".mes = 'Septiembre') then sum("prep".PtdBal08)
					when ("flr".mes = 'Octubre') then sum("prep".PtdBal09)
					when ("flr".mes = 'Noviembre') then sum("prep".PtdBal10)
					when ("flr".mes = 'Diciembre') then sum("prep".PtdBal11)
				end as 'presupuesto'
		from 
				sistemas.dbo.projections_view_indicators_periods_fleets as "flr"
			inner join 
				sistemas.dbo.projections_view_bussiness_units as "unit"
			on 
				"flr".area = "unit".name
			left join 
				sistemas.dbo.ingresos_costos_granel_toneladas as "prep"
			on 
				"flr".cyear = "prep".cyear and "flr".fraccion = "prep".fraction
			and 
				"unit".tname = "prep".CpnyID
		group by 
				"flr".area ,"flr".fraccion ,"flr".cyear ,"flr".mes
	)
	select
			row_number()
		over 
			(order by area) as 
								 id
								,area
								,fraccion
								,cyear
								,mes
								,kms
								,subsubtotal
								,subpeso 
								,non_zero
								,presupuesto
		from(
				select
						area ,fraccion ,cyear ,mes ,kms,subsubtotal,subpeso,non_zero,presupuesto
				from 
						operativos
			) 
	as result			
--with operativos 
--	as (	
--		select 
--				area ,fraccion ,cyear ,mes ,sum(kms) as 'kms' ,sum(subsubtotal) as 'subsubtotal' ,sum(subpeso) as 'subpeso' ,sum(non_zero) as 'non_zero'
--		from 
--				sistemas.dbo.projections_view_indicators_periods_fleets
--		group by 
--				area ,fraccion ,cyear ,mes
--	)
--	select
--			row_number()
--		over 
--			(order by area) as 
--								 id
--								,area
--								,fraccion
--								,cyear
--								,mes
--								,kms
--								,subsubtotal
--								,subpeso 
--								,non_zero 
--		from(
--				select
--						area ,fraccion ,cyear ,mes ,kms,subsubtotal,subpeso,non_zero
--				from 
--						operativos
--			) 
--	as result			

	
	

	
--	select * from sistemas.dbo.projections_view_indicators_periods_fleets where area = 'ORIZABA' --cyear = '2017' and mes = 'Marzo'
--		select * from projections_view_indicators_periods where cyear = '2017'
--		select * from projections_view_indicators_periods_full_fleets where cyear = '2017' and mes = 'Noviembre' and fraccion = 'GRANEL' order by mes
-- ================================================================================================================================================================================
--  Tipos de Operacion por Compania
-- ================================================================================================================================================================================

use sistemas;
-- go
IF OBJECT_ID ('projections_view_operations_types', 'V') IS NOT NULL		
    DROP VIEW projections_view_operations_types;

create view projections_view_operations_types

with encryption
as
	select
			row_number()
		over 
			(order by id_tipo_operacion) as 
								id,
								company_id,
								id_tipo_operacion,
								tipo_operacion
		from(
	
	select
		'1' as 'company_id',id_tipo_operacion,tipo_operacion
	from
		bonampakdb.dbo.desp_tipooperacion
	union all 
	select
		'2' as 'company_id',id_tipo_operacion,tipo_operacion
	from
		macuspanadb.dbo.desp_tipooperacion
	union all 
	select
		'3' as 'company_id',id_tipo_operacion,tipo_operacion
	from
		tespecializadadb.dbo.desp_tipooperacion
		)
	as result 
	
-- select * from sistemas.dbo.projections_view_operations_types order by company_id,id_tipo_operacion
-- ==================================================================================================================================== --
-- Core Canceled PortLetters
-- ==================================================================================================================================== --

-- ==================================================================================================================================== --
-- 														View fixed Canceled tbk
-- ==================================================================================================================================== --

use sistemas

IF OBJECT_ID ('projections_view_canceled_tbk_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_canceled_tbk_periods;

--set language English
create view projections_view_canceled_tbk_periods
with encryption
as	
/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : June 2, 2017
 Description    : 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/

with "canceled" as (
	select
		'' as 'projections_period_id'
		,(
			select 
					nombre
			from 
					bonampakdb.dbo.desp_flotas as flt
			where
					flt.id_flota = matto.id_flota
		
		) as 'flota'
		,matto.id_flota as 'id_flota' 
		,flete.id_fraccion
	    ,flete.no_viaje,flete.id_area,'1' as 'company',flete.num_guia,flete.no_guia,flete.subtotal
	    ,flete.fecha_cancelacion,flete.fecha_confirmacion,flete.fecha_guia
	    ,cast(year(flete.fecha_cancelacion) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_cancelacion)), 2) as 'cancelacion'
	    ,cast(year(flete.fecha_confirmacion) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_confirmacion)), 2) as 'confirmacion'
	    ,cast(year(flete.fecha_guia) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_guia)), 2) as 'guia'
		,case (select datename(mm,flete.fecha_cancelacion))
			when 	'January' 	then 	'Enero'
			when 	'February' 	then 	'Febrero'
			when 	'March'		then	'Marzo'
			when 	'April'		then	'Abril'
			when	'May'		then	'Mayo'
			when	'June'		then	'Junio'
			when	'July'		then	'Julio'
			when	'August'	then	'Agosto'
			when	'September'	then	'Septiembre'
			when	'October'	then	'Octubre'
			when	'November'	then	'Noviembre'
			when	'December'	then	'Diciembre'
		 end as 'mes'
		,(
			select 
					sum(rg.peso)
			from 
					bonampakdb.dbo.trafico_renglon_guia as rg
			where 
					rg.no_guia = flete.no_guia
				and rg.id_area = flete.id_area
		) as 'peso'
		,case
			when flete.id_tipo_operacion = '12'
				then 'LA PAZ'
			else
					(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								bonampakdb.dbo.general_area as areas
						where 
								areas.id_area = flete.id_area
					) 
		end as 'Area'
		,zpol.Tmov
		,zpol.Cporte
		,flete.id_tipo_operacion	
	from 
				bonampakdb.dbo.trafico_guia as flete
		inner join 
					(
						select 
							Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
						CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
						Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
					from 
						integraapp.dbo.zpoling 
					where 
						Cpny = 'bonampakdb'
						and Estatus = 1
						and Tmov = 'C'
						group by Tmov,Tmov,CPorte,Area
					) as zpol on zpol.Cporte = flete.num_guia
		inner join 
				bonampakdb.dbo.mtto_unidades as matto
					on matto.id_unidad = flete.id_unidad
	where 
				flete.status_guia = 'B' 
			and	flete.tipo_doc = 2				
			and	flete.prestamo = 'N'
		    and	flete.fecha_cancelacion between dateadd(month,-2,cast((current_timestamp) as date)) and dateadd(day,2,cast((current_timestamp) as date))
)
select
			 "cc".projections_period_id,"cc".flota,"cc".id_flota,"cc".id_fraccion,"cc".no_viaje,"cc".id_area,"cc".company,"cc".num_guia,"cc".no_guia,"cc".subtotal
	    	,"cc".fecha_cancelacion,"cc".fecha_confirmacion,"cc".fecha_guia
	    	,"cc".mes,"cc".peso,"cc".Area,"cc".Tmov,"cc".Cporte,"cc".id_tipo_operacion
from
			"canceled" as "cc"
where
			(	-- if 
				(
						"cc".fecha_confirmacion is not null 
					and -- if
						(
							"cc".cancelacion  >  "cc".confirmacion
						)
					or -- else
						(
							("cc".cancelacion = "cc".confirmacion) 
						and
							("cc".confirmacion <> "cc".guia)
						)
				)
			or -- else
				(
						"cc".fecha_confirmacion is null
					and 
						(
							("cc".cancelacion > "cc".guia)
						)
				)
			)



-- ==================================================================================================================================== --	

-- ==================================================================================================================================== --
-- 														View fixed Canceled atm
-- ==================================================================================================================================== --

use sistemas

IF OBJECT_ID ('projections_view_canceled_atm_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_canceled_atm_periods;

--set language English
create view projections_view_canceled_atm_periods
with encryption
as	
/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : June 2, 2017
 Description    : 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/

with "canceled" as (
	select
		'' as 'projections_period_id'
		,(
			select 
					nombre
			from 
					macuspanadb.dbo.desp_flotas as flt
			where
					flt.id_flota = matto.id_flota
		
		) as 'flota'
		,matto.id_flota as 'id_flota' 
		,flete.id_fraccion
	    ,flete.no_viaje,flete.id_area,'2' as 'company',flete.num_guia,flete.no_guia,flete.subtotal
	    ,flete.fecha_cancelacion,flete.fecha_confirmacion,flete.fecha_guia
	    ,cast(year(flete.fecha_cancelacion) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_cancelacion)), 2) as 'cancelacion'
	    ,cast(year(flete.fecha_confirmacion) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_confirmacion)), 2) as 'confirmacion'
	    ,cast(year(flete.fecha_guia) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_guia)), 2) as 'guia'
		,case (select datename(mm,flete.fecha_cancelacion))
			when 	'January' 	then 	'Enero'
			when 	'February' 	then 	'Febrero'
			when 	'March'		then	'Marzo'
			when 	'April'		then	'Abril'
			when	'May'		then	'Mayo'
			when	'June'		then	'Junio'
			when	'July'		then	'Julio'
			when	'August'	then	'Agosto'
			when	'September'	then	'Septiembre'
			when	'October'	then	'Octubre'
			when	'November'	then	'Noviembre'
			when	'December'	then	'Diciembre'
		 end as 'mes'
		,(
			select 
					sum(rg.peso)
			from 
					macuspanadb.dbo.trafico_renglon_guia as rg
			where 
					rg.no_guia = flete.no_guia
				and rg.id_area = flete.id_area
		) as 'peso'
		,case
			when flete.id_tipo_operacion = '12'
				then 'LA PAZ'
			else
					(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								macuspanadb.dbo.general_area as areas
						where 
								areas.id_area = flete.id_area
					) 
		end as 'Area'
		,zpol.Tmov
		,zpol.Cporte
		,flete.id_tipo_operacion	
	from 
				macuspanadb.dbo.trafico_guia as flete
		inner join 
					(
						select 
							Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
						CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
						Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
					from 
						integraapp.dbo.zpoling 
					where 
						Cpny = 'macuspanadb'
						and Estatus = 1
						and Tmov = 'C'
						group by Tmov,Tmov,CPorte,Area
					) as zpol on zpol.Cporte = flete.num_guia
		inner join 
				macuspanadb.dbo.mtto_unidades as matto
					on matto.id_unidad = flete.id_unidad
	where 
				flete.status_guia = 'B' 
			and	flete.tipo_doc = 2				
			and	flete.prestamo = 'N'
		    and	flete.fecha_cancelacion between dateadd(month,-2,cast((current_timestamp) as date)) and dateadd(day,2,cast((current_timestamp) as date))
)
select
			 "cc".projections_period_id,"cc".flota,"cc".id_flota,"cc".id_fraccion,"cc".no_viaje,"cc".id_area,"cc".company,"cc".num_guia,"cc".no_guia,"cc".subtotal
	    	,"cc".fecha_cancelacion,"cc".fecha_confirmacion,"cc".fecha_guia
	    	,"cc".mes,"cc".peso,"cc".Area,"cc".Tmov,"cc".Cporte,"cc".id_tipo_operacion
from
			"canceled" as "cc"
where
			(	-- if 
				(
						"cc".fecha_confirmacion is not null 
					and -- if
						(
							"cc".cancelacion  >  "cc".confirmacion
						)
					or -- else
						(
							("cc".cancelacion = "cc".confirmacion) 
						and
							("cc".confirmacion <> "cc".guia)
						)
				)
			or -- else
				(
						"cc".fecha_confirmacion is null
					and 
						(
							("cc".cancelacion > "cc".guia)
						)
				)
			)



-- ==================================================================================================================================== --	

-- ==================================================================================================================================== --
-- 														View fixed Canceled tei
-- ==================================================================================================================================== --

use sistemas

IF OBJECT_ID ('projections_view_canceled_tei_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_canceled_tei_periods;

--set language English
create view projections_view_canceled_tei_periods
with encryption
as	
/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : June 2, 2017
 Description    : 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/

with "canceled" as (
	select
		'' as 'projections_period_id'
		,(
			select 
					nombre
			from 
					tespecializadadb.dbo.desp_flotas as flt
			where
					flt.id_flota = matto.id_flota
		
		) as 'flota'
		,matto.id_flota as 'id_flota' 
		,flete.id_fraccion
	    ,flete.no_viaje,flete.id_area,'3' as 'company',flete.num_guia,flete.no_guia,flete.subtotal
	    ,flete.fecha_cancelacion,flete.fecha_confirmacion,flete.fecha_guia
	    ,cast(year(flete.fecha_cancelacion) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_cancelacion)), 2) as 'cancelacion'
	    ,cast(year(flete.fecha_confirmacion) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_confirmacion)), 2) as 'confirmacion'
	    ,cast(year(flete.fecha_guia) as varchar(4)) + right('00'+convert(varchar(2),MONTH(flete.fecha_guia)), 2) as 'guia'
		,case (select datename(mm,flete.fecha_cancelacion))
			when 	'January' 	then 	'Enero'
			when 	'February' 	then 	'Febrero'
			when 	'March'		then	'Marzo'
			when 	'April'		then	'Abril'
			when	'May'		then	'Mayo'
			when	'June'		then	'Junio'
			when	'July'		then	'Julio'
			when	'August'	then	'Agosto'
			when	'September'	then	'Septiembre'
			when	'October'	then	'Octubre'
			when	'November'	then	'Noviembre'
			when	'December'	then	'Diciembre'
		 end as 'mes'
		,(
			select 
					sum(rg.peso)
			from 
					tespecializadadb.dbo.trafico_renglon_guia as rg
			where 
					rg.no_guia = flete.no_guia
				and rg.id_area = flete.id_area
		) as 'peso'
		,case
			when flete.id_tipo_operacion = '12'
				then 'LA PAZ'
			else
					(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								tespecializadadb.dbo.general_area as areas
						where 
								areas.id_area = flete.id_area
					) 
		end as 'Area'
		,zpol.Tmov
		,zpol.Cporte
		,flete.id_tipo_operacion	
	from 
				tespecializadadb.dbo.trafico_guia as flete
		inner join 
					(
						select 
							Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
						CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
						Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
					from 
						integraapp.dbo.zpoling 
					where 
						Cpny = 'tespecializadadb'
						and Estatus = 1
						and Tmov = 'C'
						group by Tmov,Tmov,CPorte,Area
					) as zpol on zpol.Cporte = flete.num_guia
		inner join 
				tespecializadadb.dbo.mtto_unidades as matto
					on matto.id_unidad = flete.id_unidad
	where 
				flete.status_guia = 'B' 
			and	flete.tipo_doc = 2				
			and	flete.prestamo = 'N'
		    and	flete.fecha_cancelacion between dateadd(month,-2,cast((current_timestamp) as date)) and dateadd(day,2,cast((current_timestamp) as date))
)
select
			 "cc".projections_period_id,"cc".flota,"cc".id_flota,"cc".id_fraccion,"cc".no_viaje,"cc".id_area,"cc".company,"cc".num_guia,"cc".no_guia,"cc".subtotal
	    	,"cc".fecha_cancelacion,"cc".fecha_confirmacion,"cc".fecha_guia
	    	,"cc".mes,"cc".peso,"cc".Area,"cc".Tmov,"cc".Cporte,"cc".id_tipo_operacion
from
			"canceled" as "cc"
where
			(	-- if 
				(
						"cc".fecha_confirmacion is not null 
					and -- if
						(
							"cc".cancelacion  >  "cc".confirmacion
						)
					or -- else
						(
							("cc".cancelacion = "cc".confirmacion) 
						and
							("cc".confirmacion <> "cc".guia)
						)
				)
			or -- else
				(
						"cc".fecha_confirmacion is null
					and 
						(
							("cc".cancelacion > "cc".guia)
						)
				)
			)

-- ==================================================================================================================================== --	
		
			
			
use sistemas

IF OBJECT_ID ('projections_view_canceled_periods', 'V') IS NOT NULL		
    DROP VIEW projections_view_canceled_periods;

--set language English
create view projections_view_canceled_periods

with encryption
as
/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : September 20, 2016
 Description    : Quering the operational data as kms,tons,trips,cash from lis datatables 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/

-- ========================================= understanding Canceled ============================= --
select * from sistemas.dbo.projections_view_canceled_tbk_periods
		union all -- ========================= Macuspana ======================== --
select * from sistemas.dbo.projections_view_canceled_atm_periods
		union all -- ========================= Cuautitlan ======================== --
select * from sistemas.dbo.projections_view_canceled_tei_periods
--select
--	'' as 'projections_period_id'
--	,(
--		select 
--				nombre
--		from 
--				bonampakdb.dbo.desp_flotas as flt
--		where
--				flt.id_flota = matto.id_flota
--	
--	) as 'flota'
--	,matto.id_flota as 'id_flota' 
--	,flete.id_fraccion
--    ,flete.no_viaje,flete.id_area,'1' as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,flete.fecha_guia
--	,case (select datename(mm,flete.fecha_cancelacion))
--		when 	'January' 	then 	'Enero'
--		when 	'February' 	then 	'Febrero'
--		when 	'March'		then	'Marzo'
--		when 	'April'		then	'Abril'
--		when	'May'		then	'Mayo'
--		when	'June'		then	'Junio'
--		when	'July'		then	'Julio'
--		when	'August'	then	'Agosto'
--		when	'September'	then	'Septiembre'
--		when	'October'	then	'Octubre'
--		when	'November'	then	'Noviembre'
--		when	'December'	then	'Diciembre'
--	 end as 'mes'
--	,(
--		select 
--				sum(rg.peso)
--		from 
--				bonampakdb.dbo.trafico_renglon_guia as rg
--		where 
--				rg.no_guia = flete.no_guia
--			and rg.id_area = flete.id_area
--	) as 'peso'
--	,case
--		when flete.id_tipo_operacion = '12'
--			then 'LA PAZ'
--		else
--				(
--					select
--							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
--					from 
--							bonampakdb.dbo.general_area as areas
--					where 
--							areas.id_area = flete.id_area
--				) 
--	end as 'Area'
--	,zpol.Tmov
--	,zpol.Cporte
--	,flete.id_tipo_operacion	
--from 
--			bonampakdb.dbo.trafico_guia as flete
--	inner join 
--				(
--					select 
--						Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
--					CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
--					Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
--				from 
--					integraapp.dbo.zpoling 
--				where 
--					Cpny = 'bonampakdb'
--					and Estatus = 1
--					and Tmov = 'C'
--					--and CPorte = 'OO-039659'
--					group by Tmov,Tmov,CPorte,Area
--				) as zpol on zpol.Cporte = flete.num_guia
--	inner join 
--			bonampakdb.dbo.mtto_unidades as matto
--				on matto.id_unidad = flete.id_unidad
--where 
--			flete.status_guia = 'B' 
--		and	flete.tipo_doc = 2				
--		and	flete.prestamo = 'N'
--	    and	flete.fecha_cancelacion between dateadd(month,-2,cast((current_timestamp) as date)) and dateadd(day,2,cast((current_timestamp) as date))									
--		and	
--			(	-- if 
--				(
--						flete.fecha_confirmacion is not null 
--					and -- if
--						(
--							(right( CONVERT(VARCHAR(10), flete.fecha_cancelacion, 105), 7) )  >  (right( CONVERT(VARCHAR(10), flete.fecha_confirmacion, 105), 7) )
--						)
--					or -- else
--						(
--							((right( CONVERT(VARCHAR(10), flete.fecha_cancelacion, 105), 7) ) = (right( CONVERT(VARCHAR(10), flete.fecha_confirmacion, 105), 7) )) 
--						and
--							(right( CONVERT(VARCHAR(10), flete.fecha_confirmacion, 105), 7) ) <> (right( CONVERT(VARCHAR(10), flete.fecha_guia, 105), 7) )
--						)
--				)
--			or -- else
--				(
--						flete.fecha_confirmacion is null
--					and 
--						(
--							(right( CONVERT(VARCHAR(10), flete.fecha_cancelacion, 105), 7) ) > (right( CONVERT(VARCHAR(10), flete.fecha_guia, 105), 7) )
--						)
--				)
--			)
--		and 
--			zpol.Cporte not in 
--								(
--									'OO-040486','OO-040487','OO-040495','OO-040496','OO-040501','OO-040503','OO-040508','OO-040509','OO-040513','OO-040514' --> Orizaba <--> 2017-05 as 2017-04
--									,'OG-080192' --> La Paz <--> 2017-05 as 2017-04
--								)

-- ========================================= Understanding Canceled ============================= --

-- ==================================================================================================================================== --
-- Core Accepted PortLetters (obsolete)
-- ==================================================================================================================================== --
	
use sistemas;

IF OBJECT_ID ('view_xd3e_getFullCompanyOperations', 'V') IS NOT NULL
	DROP VIEW view_xd3e_getFullCompanyOperations;

create view view_xd3e_getFullCompanyOperations
	with encryption as
	select 
	*
	from openquery(local,'sistemas.dbo.spview_xd3e_getFullCompanyOperations "0","0","0","0","8","0","0"')

		

-- ==================================================================================================================================== --
-- Core Dispatching trips in current year (obsolete)
-- ==================================================================================================================================== --
	
use sistemas;

IF OBJECT_ID ('view_sp_xd6z_getFullCompanyOperationsDispatch', 'V') IS NOT NULL
	DROP VIEW view_sp_xd6z_getFullCompanyOperationsDispatch;

create view view_sp_xd6z_getFullCompanyOperationsDispatch
	with encryption as
	select 
	*
	from openquery(local,'sistemas.dbo.sp_xd6z_getFullCompanyOperationsDispatch "0","0","1"')

		
	
	
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
		id												int identity(1,1),
		user_id											int, 
		projections_closed_period_controls_id  			int,
		id_area 										int,
		id_unidad 										varchar(10) not null,
		id_configuracionviaje 							int,
		id_tipo_operacion 								int,
		id_fraccion 									int,
		id_flota 										int,
		no_viaje 										int,
		fecha_guia 										varchar(10),
		mes												varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
		f_despachado 									datetime,
		cliente 										varchar(60),
		kms_viaje 										int,
		kms_real 										int,
		subtotal 										decimal(18,6),
		peso 											decimal(18,6),
		configuracion_viaje 							varchar(20),
		tipo_de_operacion 								varchar(20),
		flota 											varchar(40),
		area 											varchar(40),
		fraccion 										varchar(60),
		company 										int,
		trip_count 										tinyint,
		created 										datetime,
		modified 										datetime,	
		_status											int
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
-- select * from sistemas.dbo.projections_view_closed_periods
use sistemas;
IF OBJECT_ID ('projections_view_closed_periods', 'V') IS NOT NULL
    DROP VIEW projections_view_closed_periods;

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
			Cporte									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
			id_tipo_operacion						int
) on [primary]
-- go

set ansi_padding off
-- go

-- select * from sistemas.dbo.projections_cancelations
-- select * from sistemas.dbo.projections_upt_cancelations

-- ====================================== updating with,update,set,from,join ============================================ --			
--  using this for adding id_tipo_operacion and update because is in production
-- ====================================== updating with,update,set,from,join ============================================ --			
with op as (
		select '1' as 'company',id_area,id_tipo_operacion,num_guia COLLATE SQL_Latin1_General_CP1_CI_AS as 'num_guia' from bonampakdb.dbo.trafico_guia
		union all 
		select '2' as 'company',id_area,id_tipo_operacion,num_guia COLLATE SQL_Latin1_General_CP1_CI_AS as 'num_guia' from macuspanadb.dbo.trafico_guia
		union all
		select '3' as 'company',id_area,id_tipo_operacion,num_guia COLLATE SQL_Latin1_General_CP1_CI_AS as 'num_guia' from tespecializadadb.dbo.trafico_guia
	)

--	update diss
	set	 diss.id_tipo_operacion = op.id_tipo_operacion
	from sistemas.dbo.projections_dissmiss_cancelations as diss
	inner join op as op
			on op.company = diss.company and op.id_area = diss.id_area and op.num_guia = diss.num_guia

-- ====================================== updating with,update,set,from,join ============================================ --	