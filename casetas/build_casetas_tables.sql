------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Struct for tables on tollbooth
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog CasetasCompanies
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.casetas_corporations', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_corporations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_corporations](
		id						int identity(1,1),
        casetas_companies_name	nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		casetas_companies_desc	nvarchar(2000)		collate		sql_latin1_general_cp1_ci_as,
		created					datetime,
		modified				datetime,
		user_id					int,
		casetas_standings_id		int,
		casetas_parents_id		int,
		_status					tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go
insert into dbo.casetas_corporations values	('TBK','Bonampak',CURRENT_TIMESTAMP,null,'1',null,null,1),
											('ATM','Macuspana',CURRENT_TIMESTAMP,null,'1',null,null,1),
											('TEISA','Teisa',CURRENT_TIMESTAMP,null,'1',null,null,1);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog CasetasUnits
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_units', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_units; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_units](
		id						int identity(1,1),
		casetas_corporations_id	int,
        casetas_units_name		nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		casetas_units_desc		nvarchar(2000)		collate		sql_latin1_general_cp1_ci_as,
		created					datetime,
		modified				datetime,
		user_id					int,
		casetas_standings_id		int,
		casetas_parents_id		int,
		_status					tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

insert into dbo.casetas_units values	('1','TBKGDL','Unidad de Negocio Guadalajara',CURRENT_TIMESTAMP,null,'1',null,null,1),
										('1','TBKHER','Unidad de Negocio Hermosillo',CURRENT_TIMESTAMP,null,'1',null,null,1),
										('1','TBKLAP','Unidad de Negocio La Paz',CURRENT_TIMESTAMP,null,'1',null,null,1),
										('1','TBKORI','Unidad de Negocio Orizaba',CURRENT_TIMESTAMP,null,'1',null,null,1),
										('1','TBKRAM','Unidad de Negocio Ramos',CURRENT_TIMESTAMP,null,'1',null,null,1),
										('1','TBKTIJ','Unidad de Negocio Tijuana',CURRENT_TIMESTAMP,null,'1',null,null,1),
										('2','ATMMAC','Unidad de Negocio Macuspana',CURRENT_TIMESTAMP,null,'1',null,null,1),
										('3','TEICUA','Unidad de Negocio Teisa',CURRENT_TIMESTAMP,null,'1',null,null,1),
										('3','TCGTUL','Unidad de Negocio Geminis',CURRENT_TIMESTAMP,null,'1',null,null,1);

--select * from casetas_units
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalogs events
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.casetas_events', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_events; 
-- go

set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go

create table [dbo].[casetas_events](
		id						int identity(1,1),
		casetas_event_name		nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		created					datetime,
		modified				datetime,
		user_id					int,
		_status					tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

--SET IDENTITY_INSERT sistemas.dbo.casetas_events ON
insert into dbo.casetas_events values ('Conciliacion',CURRENT_TIMESTAMP,null,1,1),('FileUpload',CURRENT_TIMESTAMP,null,1,1),
									  ('FileDelete',CURRENT_TIMESTAMP,null,1,1);
-- SET IDENTITY_INSERT sistemas.dbo.casetas_events OFF
-- select * from casetas_events
-- drop table sistemas.dbo.casetas_events

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog Status 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_parents', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_parents; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_parents](
		id						int identity(1,1),
		casetas_parents_name	nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		created					datetime,
		modified				datetime,
		user_id					int,
		_status					tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

insert into dbo.casetas_parents values	  
										  ('Conciliacion',CURRENT_TIMESTAMP,null,1,1)									-- 1
									     ,('File',CURRENT_TIMESTAMP,null,1,1)											-- 2
										 ,('Flags',CURRENT_TIMESTAMP,null,1,1)											-- 3
										 ,('Conciliacion Manual',CURRENT_TIMESTAMP,null,1,1)							-- 4
										 ,('Conflicto en Fechas con otro Viaje',CURRENT_TIMESTAMP,null,1,1)				-- 5
										 ,('No Conciliado',CURRENT_TIMESTAMP,null,1,1)									-- 6
										 ,('Ruta Mal Configurada',CURRENT_TIMESTAMP,null,1,1)							-- 7
										 ,('Probable Viaje en sig. periodo Iave',CURRENT_TIMESTAMP,null,1,1)			-- 8
										 ,('Inconsistencia en las Fechas del Viaje',CURRENT_TIMESTAMP,null,1,1)			-- 9
										 ,('Conciliacion Cerrada',CURRENT_TIMESTAMP,null,1,1)							-- 10
										 --,('Conflicto en Fechas con otro Viaje',CURRENT_TIMESTAMP,null,1,1)			-- 11
										 --,('Conflicto en Fechas con otro Viaje',CURRENT_TIMESTAMP,null,1,1)			-- 12
										 --,('Conflicto en Fechas con otro Viaje',CURRENT_TIMESTAMP,null,1,1)			-- 13
										;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog Status Parents
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go

IF OBJECT_ID('dbo.casetas_standings', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_standings;  
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_standings](
		id						int identity(1,1),
		casetas_parents_id		int,
		casetas_standings_name	nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		created					datetime,
		modified				datetime,
		user_id					int,
		_status					tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

insert into dbo.casetas_standings values	(1,'Conciliado',CURRENT_TIMESTAMP,null,1,1),											-- 1
											(1,'No Conciliado',CURRENT_TIMESTAMP,null,1,1),											-- 2
											(1,'Probable Viaje en sig. periodo Iave',CURRENT_TIMESTAMP,null,1,1),					-- 3
											(1,'Ruta Mal Configurada',CURRENT_TIMESTAMP,null,1,1),									-- 4
											(1,'Cruces no correspondidos de lIS en I+D',CURRENT_TIMESTAMP,null,1,1),				-- 5
											(1,'Cruces no correspondidos de I+D en lIS',CURRENT_TIMESTAMP,null,1,1),				-- 6 -- ok
											(1,'Tarjeta IAVE en I+D no Registrada en LIS',CURRENT_TIMESTAMP,null,1,1),				-- 7 -- ok
											(1,'Inconsistencia en las Fechas del Viaje',CURRENT_TIMESTAMP,null,1,1),				-- 8
											(1,'Cruce de vehículos Utilitarios',CURRENT_TIMESTAMP,null,1,1),						-- 9 -- ok
											(2,'Archivo por Conciliar',CURRENT_TIMESTAMP,null,1,1),									-- 10
											(2,'Archivo Conciliado',CURRENT_TIMESTAMP,null,1,1),									-- 11
											(1,'Viaje sin finalizar y sin caseta en LIS',CURRENT_TIMESTAMP,null,1,1)                -- 12
											;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog IavePeriods -- NEW -- DEPRECATED !!!! use casetas_iave_periods_options VIEW instead -- stand for a while /** just in case */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_iave_periods', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_iave_periods; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_iave_periods](
		id							int identity(1,1),
		user_id						int,
		period_iave_id				int,
		period_desc					nvarchar(80)	collate	sql_latin1_general_cp1_ci_as,
		fecha_ini					datetime,
		fecha_fin					datetime,
		offset_day_minus			int,
		offset_day_plus				int,
		created						datetime,
		modified					datetime,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

insert into sistemas.dbo.casetas_iave_periods values	
                ('1','375','Mayo 21 al 31','2016-05-21 00:00:00.000','2016-05-31 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','376','Junio 1 al 10','2016-06-01 00:00:00.000','2016-06-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','377','Junio 11 al 20','2016-06-11 00:00:00.000','2016-06-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','378','Junio 21 al 30','2016-06-21 00:00:00.000','2016-06-30 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','379','Julio 01 al 10','2016-07-01 00:00:00.000','2016-07-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','380','Julio 11 al 20','2016-07-11 00:00:00.000','2016-07-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','391','Noviembre 01 al 10','2016-11-01 00:00:00.000','2016-11-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','392','Noviembre 11 al 20','2016-11-11 00:00:00.000','2016-11-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','393','Noviembre 21 al 30','2016-11-21 00:00:00.000','2016-11-30 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','394','Diciembre 01 al 10','2016-12-01 00:00:00.000','2016-12-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','395','Diciembre 11 al 20','2016-12-11 00:00:00.000','2016-12-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','396','Diciembre 21 al 31','2016-12-21 00:00:00.000','2016-12-31 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','397','Enero 01 al 10','2017-01-01 00:00:00.000','2017-01-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','398','Enero 11 al 20','2017-01-11 00:00:00.000','2017-01-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','399','Enero 21 al 31','2017-01-21 00:00:00.000','2017-01-31 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','400','Febrero 01 al 10','2017-02-01 00:00:00.000','2017-02-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','401','Febrero 11 al 20','2017-02-11 00:00:00.000','2017-02-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','402','Febrero 21 al 28','2017-02-21 00:00:00.000','2017-02-28 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','403','Marzo 01 al 10','2017-03-01 00:00:00.000','2017-03-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','404','Marzo 11 al 20','2017-03-11 00:00:00.000','2017-03-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','405','Marzo 21 al 31','2017-03-21 00:00:00.000','2017-03-31 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','406','Abril 01 al 10','2017-04-01 00:00:00.000','2017-04-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','407','Abril 11 al 20','2017-04-11 00:00:00.000','2017-04-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','408','Abril 21 al 30','2017-04-21 00:00:00.000','2017-04-30 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--insert into sistemas.dbo.casetas_iave_periods values
				('1','409','Mayo 1 al 10','2017-05-01 00:00:00.000','2017-05-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','410','Mayo 11 al 10','2017-05-11 00:00:00.000','2017-05-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--insert into sistemas.dbo.casetas_iave_periods values
				('1','411','Mayo 21 al 31','2017-05-21 00:00:00.000','2017-05-31 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','412','Junio 01 al 10','2017-06-01 00:00:00.000','2017-06-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','413','Junio 11 al 20','2017-06-11 00:00:00.000','2017-06-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','414','Junio 21 al 30','2017-06-21 00:00:00.000','2017-06-30 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','415','Julio 01 al 10','2017-07-01 00:00:00.000','2017-07-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','416','Julio 11 al 20','2017-07-11 00:00:00.000','2017-07-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','417','Julio 21 al 31','2017-07-21 00:00:00.000','2017-07-31 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','418','ago 01 al 10','2017-08-01 00:00:00.000','2017-08-10 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','419','ag 11 al 20','2017-08-11 00:00:00.000','2017-08-20 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
				('1','420','ago 21 al 31','2017-08-21 00:00:00.000','2017-08-31 23:59:00.000','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1')
--select * from sistemas.dbo.casetas_iave_periods

-- ============================================================================================================== --
-- ====== 		Compability with the engines 	   ====== --
-- ============================================================================================================== --
							
use sistemas;
IF OBJECT_ID ('casetas_iave_periods', 'V') IS NOT NULL
    DROP VIEW casetas_iave_periods;

create view casetas_iave_periods
--with encryption
as
-- full compability with old table casetas_iave_periods
		select 
				 cast(row_number() over(partition by "_control" order by "_control") as int) as 'id'
				,1 as 'user_id'
				,cast(period_iave_id as int) as 'period_iave_id'
				,period_desc collate SQL_Latin1_General_CP1_CI_AS as 'period_desc'
				,cast(fecha_ini as datetime) as 'fecha_ini'
				,cast(fecha_fin as datetime) as 'fecha_fin'
				,5 as 'offset_day_minus'
				,1 as 'offset_day_plus'
				,CURRENT_TIMESTAMP as 'created'
				,CURRENT_TIMESTAMP as 'modified'
				,cast("_control" as tinyint) as '_status'
		from 
				sistemas.dbo.casetas_iave_periods_sources 
		where 
				period 
					between 
							(left(CONVERT(VARCHAR(10), (dateadd(month,-13,CURRENT_TIMESTAMP)), 112), 6))
					and 
							(left(CONVERT(VARCHAR(10), (dateadd(month,3,CURRENT_TIMESTAMP)), 112), 6))				
				

-- ============================================================================================================== --
-- =========================================== Build iave periods =============================================== --
-- ============================================================================================================== --
-- original table select * from sistemas.dbo.casetas_iave_periods
-- id,user_id,period_iave_id,period_desc,fecha_ini,fecha_fin,offset_day_minus,offset_day_plus,created,modified,_status
-- example 1  |1       |375|Mayo 21 al 31 2016-05-21 00:00:00|2016-05-31 23:59:00 |5 |1 |2017-03-16 11:01:44 |2017-03-16 11:01:44 
-- higest compability

use sistemas;
IF OBJECT_ID ('casetas_iave_periods_sources', 'V') IS NOT NULL
    DROP VIEW casetas_iave_periods_sources;

create view casetas_iave_periods_sources
with encryption
as
with "years" as	 (
					select 
							 1 as "num"
						union all
				    select 
							 "num" + 1 as "num"
					from 
				    		"years"
				    where
							"num" <= (DATEDIFF ( year , '2005-01-01' , CURRENT_TIMESTAMP ))
)
select
		row_number()
		over
			(order by cyear) as
				 "period_iave_id"
				,"cyear"
				,"id_month"
				,"month"
				,"date"
				,"period"
				,"per_id"
				,"init"
				,"end"
				,"period_desc"
				,"fecha_ini"
				,"fecha_fin"
				,"_control"
	from
		(
			select
					 year(dateadd(year,"yr"."num",'2005-01-01')) as "cyear"
					,"mts".id_month
					,"mts"."month"
					,cast(year(dateadd(year,"yr"."num",'2005-01-01')) as varchar(4)) + '-' + cast("mts".id_month as varchar(2)) + '-01' as "date"
					,cast(year(dateadd(year,"yr"."num",'2005-01-01')) as varchar(4)) + "mts".id_month as "period"
					,"per".per_id
					,"per".init as "init"
					,isnull("per"."end",day(( DATEADD(month, (((year(dateadd(year,"yr"."num",'2005-01-01'))) - 1900) * 12) + "mts".id_month, -1) ))) as "end"
					,"mts"."month" + ' ' + "per".init + ' al ' + isnull("per"."end",day(( DATEADD(month, (((year(dateadd(year,"yr"."num",'2005-01-01'))) - 1900) * 12) + "mts".id_month, -1) ))) as "period_desc"
					, cast(year(dateadd(year,"yr"."num",'2005-01-01')) as varchar(4)) + '-' + "mts".id_month + '-' + right('00'+convert(varchar(2),"per".init), 2) +' 00:00:00.000' as "fecha_ini"
					, cast(year(dateadd(year,"yr"."num",'2005-01-01')) as varchar(4)) + '-' + "mts".id_month + '-' + isnull("per"."end",day(( DATEADD(month, (((year(dateadd(year,"yr"."num",'2005-01-01'))) - 1900) * 12) + "mts".id_month, -1) ))) +' 23:59:00.000' as "fecha_fin"
					,'1' as '_control'
			from
					"years" as "yr"
				left join (
							select '01' as "id_month", 'Enero' as "month"
							union select '02' as "id_month", 'Febrero' as "month"
							union select '03' as "id_month", 'Marzo' as "month"
							union select '04' as "id_month", 'Abril' as "month"
							union select '05' as "id_month", 'Mayo' as "month"
							union select '06' as "id_month", 'Junio' as "month"
							union select '07' as "id_month", 'Julio' as "month"
							union select '08' as "id_month", 'Agosto' as "month"
							union select '09' as "id_month", 'Septiembre' as "month"
							union select '10' as "id_month", 'Octubre' as "month"
							union select '11' as "id_month", 'Noviembre' as "month"
							union select '12' as "id_month", 'Diciembre' as "month"
						   )
				as "mts" on 1 = 1
				left join (
							select '1' as 'per_id', '1' as 'init', '10' as 'end'
							union select '2' as 'per_id', '11' as 'init', '20' as 'end'
							union select '3' as 'per_id', '21' as 'init', null as 'end'
						   )
				as "per" on 1 = 1				
		)
	as result

	
-- ============================================================================================================== --
-- ====== 		Maybe need a scroll control to set the periods to minimal for save cpu in the server 	   ====== --
-- ============================================================================================================== --
/** NOTE ScrollerTime */
--controlling the offset in between clause

use sistemas;
IF OBJECT_ID ('casetas_iave_periods_options', 'V') IS NOT NULL
    DROP VIEW casetas_iave_periods_options;

create view casetas_iave_periods_options
--with encryption
as
-- full compability with old table casetas_iave_periods
		select 
				 cast(row_number() over(partition by "_control" order by "_control") as int) as 'id'
				,1 as 'user_id'
				,cast(period_iave_id as int) as 'period_iave_id'
				,period_desc collate SQL_Latin1_General_CP1_CI_AS as 'period_desc'
				,cast(fecha_ini as datetime) as 'fecha_ini'
				,cast(fecha_fin as datetime) as 'fecha_fin'
				,5 as 'offset_day_minus'
				,1 as 'offset_day_plus'
				,CURRENT_TIMESTAMP as 'created'
				,CURRENT_TIMESTAMP as 'modified'
				,cast("_control" as tinyint) as '_status'
		from 
				sistemas.dbo.casetas_iave_periods_sources 
		where 
				period 
					between 
							(left(CONVERT(VARCHAR(10), (dateadd(month,-13,CURRENT_TIMESTAMP)), 112), 6))
					and 
							(left(CONVERT(VARCHAR(10), (dateadd(month,3,CURRENT_TIMESTAMP)), 112), 6))
							
							


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Catalog IavePeriods -- NEW -- add the id in iave when change column caseta to carril
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_iave_caseta_descriptions', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_iave_caseta_descriptions; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_iave_caseta_descriptions](
		id							int identity(1,1),
		user_id						int,
		casetas_iave_id				int,
		casetas_desc				nvarchar(80)	collate	sql_latin1_general_cp1_ci_as,
		created						datetime,
		modified					datetime,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

insert into sistemas.dbo.casetas_iave_caseta_descriptions values 
										 ('1','316','Casetas del circuito Mexiquense',current_timestamp,current_timestamp,1)
										,('1','906','Casetas del circuito Ecatepec',current_timestamp,current_timestamp,1)
										,('1','908','Casetas del circuito Marquessa',current_timestamp,current_timestamp,1)
										,('1','911','Casetas del circuito Zirahuen',current_timestamp,current_timestamp,1)
										,('1','914','Casetas del circuito Texcoco',	current_timestamp,current_timestamp,1)
										,('1','915','Casetas del Cto Ext Mex-Texcoco',	current_timestamp,current_timestamp,1)
										,('1','919','Casetas del circuito Feliciano',current_timestamp,current_timestamp,1)
										,('1','924','Casetas del circuito Santa Casilda',current_timestamp,current_timestamp,1)
										,('1','925','Casetas del circuito Santa Teratan',current_timestamp,current_timestamp,1)
										,('1','825','Casetas del circuito Libramiento Puebla',current_timestamp,current_timestamp,1)
										;
--select * from casetas_iave_caseta_descriptions

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Core Casetasoptions
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_options', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_options; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_options](
		id							int identity(1,1),
		option_name					nvarchar(300)		collate		sql_latin1_general_cp1_ci_as,
		switch						tinyint default 1 null,
		data						nvarchar(3000)		collate		sql_latin1_general_cp1_ci_as,
		_description				nvarchar(255) collate		sql_latin1_general_cp1_ci_as,
		created						datetime,
		modified					datetime,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

insert into sistemas.dbo.casetas_options values ('next_period',1,null,'activate the next period mode',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);

Insert into sistemas.dbo.casetas_options ("option_name","switch","data","_description","created","modified","_status") 
                        values ('engine_selection',1,8,'Engine Teisa Unidad de Negocio Teisa',current_timestamp,current_timestamp,1);
                        

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls CasetasControlsUsers
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_controls_users', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_controls_users; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_controls_users](
		id						int identity(1,1),
		user_id					int,
		casetas_corporations_id	int,
		casetas_units_id		int default 0, -- this comes from BusinessUnits in MySql
		created					datetime,
		modified				datetime,
		_status					tinyint default 1 null
--		,constraint ak_user_id unique(user_id)
) on [primary]
-- go

set ansi_padding off
-- go

-- select * from casetas_controls_users
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls CasetasControlsEvents
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_controls_events', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_controls_events; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_controls_events](
		id						int identity(1,1),
		user_id					int,
		casetas_corporations_id	int,
		casetas_units_id		int,
		casetas_events_id		int,
		casetas_view_id			int,
		casetas_events_from		int,
		casetas_events_to		int,
		created					datetime,
		modified				datetime,
		casetas_standings_id		int,
		casetas_parents_id		int,
		_status					tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls CasetasControlsFiles
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_controls_files', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_controls_files; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_controls_files](
		id						int identity(1,1),
		casetas_events_id		int,
		user_id					int,
		casetas_corporations_id	int,
		casetas_units_id		int,
		_filename				nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		_fraction				int,
		cruces					int,
		_montos					float(2),
		_md5sum					nvarchar(4000)		collate		sql_latin1_general_cp1_ci_as,
		_file_size				nvarchar(4000)		collate		sql_latin1_general_cp1_ci_as,
	 	_atime 					nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
	 	_mtime					nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
	 	_ctime					nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
		_area					nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		_user_company			nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		_username				nvarchar(50) 		collate		sql_latin1_general_cp1_ci_as,
		_datetime_login			nvarchar(50) 		collate		sql_latin1_general_cp1_ci_as,
		_ip_remote				nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		created					datetime,
		modified				datetime,
		casetas_standings_id	int,
		casetas_parents_id		int,
		_status					tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls CasetasControlsConciliations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_controls_conciliations', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_controls_conciliations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_controls_conciliations](
		id							int identity(1,1),
		user_id						int,
		casetas_controls_files_id	int,
		conciliations_count			int,
		created						datetime,
		modified					datetime,
		casetas_standings_id		int,
		casetas_parents_id			int,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views CasetasViews This is limited by the query so need a rebuild
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_views', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_views; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_views](
		id							int identity(1,1),
        id_unidad					nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
        unit						nvarchar(25)		collate		sql_latin1_general_cp1_ci_as,
        no_tarjeta_iave				nvarchar(100)		collate		sql_latin1_general_cp1_ci_as,
        alpha_num_code				nvarchar(25)	 	collate		sql_latin1_general_cp1_ci_as,
        alpha_location				nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
        alpha_location_1			nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
        _filename					nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
        no_viaje					int,
        fecha_cruce					date,
        f_despachado				datetime,
        fecha_fin_viaje				datetime,
        float_data					decimal(18,4),
        hora_cruce					time(7),
        cia							nvarchar(25)		collate		sql_latin1_general_cp1_ci_as,
        Monto_archivo				decimal(18,4),
		_next						date,
        fecha_inicio				date,
        fecha_fin					date,
		description_casetas			nvarchar(300),
		--
		casetas_historical_conciliations_id int,
		casetas_controls_files_id	int,
		created						datetime,
		modified					datetime,
		casetas_standings_id		int,
		casetas_parents_id			int,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Core CasetasViajesLisNotConciliations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_lis_not_conciliations', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_lis_not_conciliations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_lis_not_conciliations](
		 id										int identity(1,1)
		,period_iave_id							int
		,fecha_ini								date
		,fecha_fin								date
		,no_viaje								int
		,f_despachado							date
		,id_area								int
		,name									nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,cia									nvarchar(15) collate	sql_latin1_general_cp1_ci_as
		,company_id								int
		,id_unidad								nvarchar(10) collate	sql_latin1_general_cp1_ci_as
		,iave_catalo-- go							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,iave_viaje								nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,id_ruta								int
		,desc_ruta								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
		,id_caseta								int
		,fecha_real_viaje						datetime
		,fecha_real_fin_viaje					datetime
		,diff_length_hours						int
		,no_ejes_viaje							int
		,no_tarjeta_llave						nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,orden									int
		,consecutivo							int
		,desc_caseta							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,no_de_ejes								int
		,monto_iave								decimal(18,6)
		,tarifas								decimal(18,6)
		,liq_tipo_pa-- go							int
		,liq_paso								nvarchar(1)
		,liq_id_caseta							int
		,liq_monto_caseta						decimal(18,6)
		,liq_monto_iave							decimal(18,6)
		,liq_no_liquidacion						int
		,trliq_fecha_ingreso					datetime
		,_filename								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
		,iave_period							int
		,casetas_controls_files_id				int
		,casetas_historical_conciliations_id	int
		,fecha_conciliacion						datetime
		,_modified								datetime default current_timestamp
		,_status								tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Core CasetasViajesLisFullConciliations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_lis_full_conciliations', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_lis_full_conciliations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_lis_full_conciliations](
		 id										int identity(1,1)
		,period_iave_id							int
		,fecha_ini								date
		,fecha_fin								date
		,no_viaje								int
		,f_despachado							date
		,id_area								int
		,name									nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,cia									nvarchar(15) collate	sql_latin1_general_cp1_ci_as
		,company_id								int
		,id_unidad								nvarchar(10) collate	sql_latin1_general_cp1_ci_as
		,iave_catalo-- go							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,iave_viaje								nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,id_ruta								int
		,desc_ruta								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
		,id_caseta								int
		,fecha_real_viaje						datetime
		,fecha_real_fin_viaje					datetime
		,diff_length_hours						int
		,no_ejes_viaje							int
		,no_tarjeta_llave						nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,orden									int
		,consecutivo							int
		,desc_caseta							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,no_de_ejes								int
		,monto_iave								decimal(18,6)
		,tarifas								decimal(18,6)
		,liq_tipo_pa-- go							int
		,liq_paso								nvarchar(1)
		,liq_id_caseta							int
		,liq_monto_caseta						decimal(18,6)
		,liq_monto_iave							decimal(18,6)
		,liq_no_liquidacion						int
		,trliq_fecha_ingreso					datetime
		,_filename								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
		,iave_period							int
		,casetas_controls_files_id				int
		,casetas_historical_conciliations_id	int
		,fecha_conciliacion						datetime
		,_modified								datetime default current_timestamp
		,_status								tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Core CasetasViajesLisNextConciliations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_lis_next_conciliations', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_lis_next_conciliations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_lis_next_conciliations](
		 id										int identity(1,1)
		,lis_full_id							int
		,period_iave_id							int
		,fecha_ini								date
		,fecha_fin								date
		,no_viaje								int
		,f_despachado							date
		,id_area								int
		,name									nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,cia									nvarchar(15) collate	sql_latin1_general_cp1_ci_as
		,company_id								int
		,id_unidad								nvarchar(10) collate	sql_latin1_general_cp1_ci_as
		,iave_catalo-- go							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,iave_viaje								nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,id_ruta								int
		,desc_ruta								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
		,id_caseta								int
		,fecha_real_viaje						datetime
		,fecha_real_fin_viaje					datetime
		,diff_length_hours						int
		,no_ejes_viaje							int
		,no_tarjeta_llave						nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,orden									int
		,consecutivo							int
		,desc_caseta							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		,no_de_ejes								int
		,monto_iave								decimal(18,6)
		,tarifas								decimal(18,6)
		,liq_tipo_pa-- go							int
		,liq_paso								nvarchar(1)
		,liq_id_caseta							int
		,liq_monto_caseta						decimal(18,6)
		,liq_monto_iave							decimal(18,6)
		,liq_no_liquidacion						int
		,trliq_fecha_ingreso					datetime
		,_filename								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
		,iave_period							int
		,casetas_controls_files_id				int
		,casetas_historical_conciliations_id	int
		,fecha_conciliacion						datetime
		,_modified								datetime default current_timestamp
		,_status								tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Historical CasetasHistoricalConciliations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_historical_conciliations', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_historical_conciliations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_historical_conciliations](
		id							int identity(1,1),
		user_id						int,
		casetas_controls_files_id	int,
		monto_conciliado			float(2),
		cruces_conciliados			int,
		created						datetime,
		modified					datetime,
		casetas_standings_id		int,
		casetas_parents_id			int,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Historical Views CasetasPendings
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_pendings', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_pendings; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_pendings](
		id							int identity(1,1),
        casetas_view_id				nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		casetas_controls_files_id	int,
		casetas_controls_events_id	int,
		casetas_standings_id			int,
		casetas_parents_id			int,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Historical Views CasetasConciliations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_conciliations', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_conciliations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_conciliations](
		id							int identity(1,1),
        casetas_view_id				nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		casetas_controls_files_id	int,
		casetas_controls_events_id	int,
		casetas_standings_id			int,
		casetas_parents_id			int,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Historical Views CasetasNotConciliations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_not_conciliations', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_not_conciliations; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_not_conciliations](
		id								int identity(1,1),
        casetas_view_id					nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		casetas_controls_files_id		int,
		casetas_controls_events_id		int,
		casetas_standings_id			int,
		casetas_parents_id				int,
		_status							tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Logs CasetasLogs
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_logs', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_logs; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_logs](
		id							int identity(1,1),
		data_name					nvarchar(3000)		collate		sql_latin1_general_cp1_ci_as,
		data						nvarchar(3000)		collate		sql_latin1_general_cp1_ci_as,
		created						datetime,
) on [primary]
-- go

set ansi_padding off
-- go





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views CasetasViewNotConciliations Detail
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


use sistemas;
IF OBJECT_ID ('casetas_view_not_conciliations', 'V') IS NOT NULL
    DROP VIEW casetas_view_not_conciliations;
-- go

create view casetas_view_not_conciliations
with encryption
as
	
	select 
		 notcot.id
		,notcot.period_iave_id
		,notcot.fecha_ini
		,notcot.fecha_fin
		,notcot.name
		,notcot.no_viaje
		,notcot.f_despachado
		,notcot.fecha_real_viaje
		,notcot.fecha_real_fin_viaje
		,notcot.id_unidad
		,notcot.iave_catalo-- go
		,notcot.id_ruta
		,notcot.desc_ruta
		,notcot.id_caseta
		,notcot.diff_length_hours
		,notcot.no_de_ejes
		,notcot.orden
		,notcot.desc_caseta
		,notcot.monto_iave
		,notcot.tarifas
		,notcot.trliq_fecha_ingreso
		,notcot._filename
		,notcot.casetas_controls_files_id
		,notcot.casetas_historical_conciliations_id
		,notcot.fecha_conciliacion
		,notcot._modified
	from 
		sistemas.dbo.casetas_lis_not_conciliations as notcot
	where 
		notcot.casetas_controls_files_id is not null and notcot.casetas_historical_conciliations_id is not null

 -- go


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views CasetasViewResume
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


use sistemas;
IF OBJECT_ID ('casetas_view_resumes', 'V') IS NOT NULL
    DROP VIEW casetas_view_resumes;
-- go

create view casetas_view_resumes
--with encryption
as	
select
		ctrl.id, 
		--ctrl._montos ,
		--ctrl.cruces,
		(select ( ctrl._montos - isnull((select rs.monto_total from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = hist.id and rs.casetas_controls_files_id = ctrl.id and  rs._filename = ctrl._filename),0) )) as '_montos',
		(select (ctrl.cruces - isnull((select rs.cruces_totales from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = hist.id and rs.casetas_controls_files_id = ctrl.id and rs._filename = ctrl._filename),0))) as 'cruces',

		hist.monto_conciliado as 'monto_conciliado',
		hist.cruces_conciliados as 'cruces_conciliados',

		(select (hist.monto_conciliado/ctrl._montos) * 100) as 'percent_montos_old',
		(select ( convert(float(2),hist.cruces_conciliados) / convert(float(2),ctrl.cruces) ) * 100) as 'percent_cruces_old',

		(select (hist.monto_conciliado/ ( ctrl._montos - isnull((select rs.monto_total from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = hist.id and rs.casetas_controls_files_id = ctrl.id and  rs._filename = ctrl._filename),0) )) * 100) as 'percent_montos',
		
		(select ( convert(float(2),hist.cruces_conciliados) / convert(float(2),(ctrl.cruces - isnull((select rs.cruces_totales from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = hist.id and rs.casetas_controls_files_id = ctrl.id and rs._filename = ctrl._filename),0) )) ) * 100) as 'percent_cruces',
		
		conctrl.conciliations_count as 'counter',
		ctrl._filename,
		ctrl._area,
		ctrl.casetas_units_id,
		evnt.casetas_event_name,
		parent.casetas_parents_name,
		stand.casetas_standings_name,
		hist.id as 'historical_id',
		ctrl._ctime,
		ctrl.casetas_standings_id as 'fileStatId',
		ctrl.casetas_parents_id as 'fileParentId',
		ctrl.casetas_corporations_id as '_cia_id',
		ctrl._status
	from 
			sistemas.dbo.casetas_controls_files as ctrl
		inner join 
			sistemas.dbo.casetas_events as evnt
			on ctrl.casetas_events_id = evnt.id
		inner join
			sistemas.dbo.casetas_parents as parent
			on	ctrl.casetas_parents_id = parent.id
		inner join
			sistemas.dbo.casetas_standings as stand
			on ctrl.casetas_standings_id = stand.id
		inner join
			sistemas.dbo.casetas_controls_conciliations as conctrl
			on ctrl.id = conctrl.casetas_controls_files_id
		left join
			casetas_historical_conciliations as hist
			on conctrl.casetas_controls_files_id = hist.casetas_controls_files_id and hist.id = (select max(id) from sistemas.dbo.casetas_historical_conciliations as shist where shist.casetas_controls_files_id =  hist.casetas_controls_files_id)
		left join
			sistemas.dbo.casetas_views as _view
			on _view.casetas_controls_files_id = ctrl.id

	group by 
			ctrl._montos,ctrl.cruces,ctrl._filename,ctrl._area,ctrl.casetas_units_id,ctrl.id,
			evnt.casetas_event_name,parent.casetas_parents_name,stand.casetas_standings_name,
			conctrl.conciliations_count,hist.monto_conciliado,hist.cruces_conciliados,hist.id,
			ctrl._ctime,ctrl.casetas_standings_id,ctrl.casetas_parents_id,ctrl.casetas_corporations_id,ctrl._status
 -- go


 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views CasetasViewResumeStand
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


use sistemas;
IF OBJECT_ID ('casetas_view_resume_stands', 'V') IS NOT NULL
    DROP VIEW casetas_view_resume_stands;
-- go

create view casetas_view_resume_stands
--with encryption
as
	--select 
	--		vcasetas.casetas_controls_files_id ,vcasetas.casetas_historical_conciliations_id,
	--		stand.casetas_standings_name,
	--		sum(vcasetas.float_data) as 'monto_total',
	--		(select ((sum(float_data))/ctrlfile._montos) * 100) as 'percent_montos',
	--		count(vcasetas.id) as 'cruces_totales',
	--		(select ( convert(float(2),count(vcasetas.id)) / convert(float(2),ctrlfile.cruces) ) * 100) as 'percent_cruces',
	--		vcasetas._filename,
	--		vcasetas.cia,
	--		ctrlfile._montos,
	--		ctrlfile.cruces,
	--		vcasetas.casetas_standings_id
	--from 
	--		sistemas.dbo.casetas_views as vcasetas
	--	inner join
	--		sistemas.dbo.casetas_standings as stand
	--	on	vcasetas.casetas_standings_id = stand.id
	--	left join 
	--		sistemas.dbo.casetas_controls_files as ctrlfile
	--	on
	--		vcasetas.casetas_controls_files_id = ctrlfile.id
			
	--group by
	--	vcasetas.casetas_controls_files_id , vcasetas.casetas_historical_conciliations_id , vcasetas.casetas_standings_id,
	--	vcasetas.cia,vcasetas._filename,ctrlfile._montos,ctrlfile.cruces,stand.casetas_standings_name

select 
			vcasetas.casetas_controls_files_id ,vcasetas.casetas_historical_conciliations_id,
			stand.casetas_standings_name,
			sum(vcasetas.float_data) as 'monto_total',
			(select ((sum(float_data))/ctrlfile._montos) * 100) as 'percent_montos_old',
			--case 
			--	when vcasetas.casetas_standings_id = 9
			--		then (select '100.00')
			--	else
			--		(select ((sum(float_data))/ ( ctrlfile._montos - (select rs.monto_total from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rs.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rs._filename = vcasetas._filename))) * 100)
			--end as 'percent_montos',
			case 
				when vcasetas.casetas_standings_id = 9
					then (select '100.00')
				when vcasetas.casetas_standings_id = 5
					then null
				else
					(select ((sum(float_data))/ ( ctrlfile._montos - isnull((select sum(rsv.Monto_archivo) from sistemas.dbo.casetas_views as rsv where rsv.casetas_standings_id = '9' and rsv.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rsv.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rsv._filename = vcasetas._filename),0))) * 100)
			end as 'percent_montos',
			count(vcasetas.id) as 'cruces_totales',
			(select ( convert(float(2),count(vcasetas.id)) / convert(float(2),ctrlfile.cruces) ) * 100) as 'percent_cruces_old',
			--case 
			--	when vcasetas.casetas_standings_id = 9
			--		then (select '100.00')
			--	else
			--		(select ( convert(float(2),count(vcasetas.id)) / convert(float(2),( ctrlfile.cruces - (select rs.cruces_totales from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rs.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rs._filename = vcasetas._filename))) ) * 100)
			--end as 'percent_cruces',
			case 
				when vcasetas.casetas_standings_id = 9
					then (select '100.00')
				when vcasetas.casetas_standings_id = 5
					then null
				else
					(select ( convert(float(2),count(vcasetas.id)) / convert(float(2),( ctrlfile.cruces - isnull((select count(rsv.id) from sistemas.dbo.casetas_views as rsv where rsv.casetas_standings_id = '9' and rsv.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rsv.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rsv._filename = vcasetas._filename),0))) ) * 100)
			end as 'percent_cruces',
			vcasetas._filename,
			vcasetas.cia,
			ctrlfile._montos,
			ctrlfile.cruces,
			--(select rs.monto_total from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rs.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rs._filename = vcasetas._filename) as 'new_montos',
			--(select rs.cruces_totales from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rs.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rs._filename = vcasetas._filename) as 'new_cruces',
			vcasetas.casetas_standings_id
	from 
			sistemas.dbo.casetas_views as vcasetas
		inner join
			sistemas.dbo.casetas_standings as stand
		on	vcasetas.casetas_standings_id = stand.id
		left join 
			sistemas.dbo.casetas_controls_files as ctrlfile
		on
			vcasetas.casetas_controls_files_id = ctrlfile.id
			-- drop when useless
	where   --vcasetas.casetas_historical_conciliations_id = '504'
			--and vcasetas.casetas_controls_files_id = '137'
			vcasetas._status = 1
		and 
			vcasetas.casetas_parents_id not in (9)

	group by
		vcasetas.casetas_controls_files_id , vcasetas.casetas_historical_conciliations_id , vcasetas.casetas_standings_id,
		vcasetas.cia,vcasetas._filename,ctrlfile._montos,ctrlfile.cruces,stand.casetas_standings_name

 -- go

 
------------------ Until hir -----------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views CasetasViewSpecialResumes
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


use sistemas;
IF OBJECT_ID ('casetas_view_special_views', 'V') IS NOT NULL
    DROP VIEW casetas_view_special_views;
-- go

create view casetas_view_special_views
with encryption
as


 select 
			 files.id,files._filename
			,files._fraction as 'periodo_iave'
			,files.cruces,files._montos,_views.name as 'lis_unidad_negocio'
			,resume_stands.casetas_standings_name,resume_stands.monto_total,resume_stands.percent_montos
			,resume_stands.cruces_totales,resume_stands.percent_cruces
			-- LIS
			,_views.id_unidad as 'lis_id_unidad'
			,_views.no_tarjeta_iave as 'lis_numero_tarjeta_iave'
			,_views.no_viaje as 'lis_no_viaje'
			,_views.description_casetas as 'lis_nombre_caseta'
			,_views.diff_length_hours as 'lis_hrs_viaje'
			,_views.fecha_real_viaje as 'lis_fecha_inicio_viaje'
			,_views.fecha_real_fin_viaje as 'lis_fecha_fin_viaje'
			,_views.monto_caseta as 'lis_monto_caseta'

			--IAVE
			,_views.unit as 'iave_unidad'
			,_views.alpha_num_code as 'iave_numero_tarjeta_iave'
			,_views.fecha_cruce as 'iave_fecha_cruce'
			,_views.hora_cruce as 'iave_hora_cruce'
			,_views._monto_archivo as 'iave_monto_caseta'
			,_views.key_num_5 as 'iave_caseta'
			,_views.alpha_location as 'iave_carril'
from 
		sistemas.dbo.casetas_controls_files as files
 
	left join (
				select max(id) as 'casetas_historical_conciliations_id',casetas_controls_files_id 
				from sistemas.dbo.casetas_historical_conciliations 
				group by casetas_controls_files_id
				) as historical on files.id = historical.casetas_controls_files_id
	left join 
			 sistemas.dbo.casetas_view_resume_stands	
			   as resume_stands on files.id = resume_stands.casetas_controls_files_id and historical.casetas_historical_conciliations_id = resume_stands.casetas_historical_conciliations_id
	left join 
				sistemas.dbo.casetas_views 
			  as _views on files.id = _views.casetas_controls_files_id and historical.casetas_historical_conciliations_id = _views.casetas_historical_conciliations_id 
				and resume_stands.casetas_standings_id = _views.casetas_standings_id
  where 
		--	files._fraction >= 
		--					(
		--						select 
		--								min(period_iave_id) as 'period_iave_id'
		--						from 
		--								sistemas.dbo.casetas_iave_periods
		--						where 
		--								year(fecha_ini) = year(DATEADD(mm,-1,current_timestamp))
		--							and
		--								month(fecha_ini) = month(DATEADD(mm,-1,current_timestamp))
		--					)

		--and
			files._status = 1
		and
			_views._status = 1
		--and files.id in (180,184,183)
		and files.id in (158,163,179,180,184,183)
-- go




 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views CasetasViewNotConciliations General
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


use sistemas;
IF OBJECT_ID ('casetas_view_not_conciliations_grals', 'V') IS NOT NULL
    DROP VIEW casetas_view_not_conciliations_grals;
-- go

create view casetas_view_not_conciliations_grals
with encryption
as


select 
		not_.no_viaje ,not_.casetas_controls_files_id ,not_.casetas_historical_conciliations_id
from 
		sistemas.dbo.casetas_lis_not_conciliations as not_
where  
	not_.no_viaje not in
					(
						select 
									concl.no_viaje 
							from 
									sistemas.dbo.casetas_view_conciliated_trips as concl
							where 
									concl.casetas_controls_files_id = not_.casetas_controls_files_id
								and 
									concl.casetas_historical_conciliations_id = not_.casetas_historical_conciliations_id
					)
	and
		not_.casetas_controls_files_id is not null 
	and 
		not_.casetas_historical_conciliations_id is not null
group by 
		not_.no_viaje ,not_.casetas_controls_files_id ,not_.casetas_historical_conciliations_id

-- go

-- ==========================================================================================================================================
--	view to get trips that are conciliated
-- ==========================================================================================================================================

use sistemas;
IF OBJECT_ID ('casetas_view_conciliated_trips', 'V') IS NOT NULL
    DROP VIEW casetas_view_conciliated_trips;
-- go

create view casetas_view_conciliated_trips
with encryption
as
	with historic 
					(
						 casetas_historical_conciliations_id
						,casetas_controls_files_id	
					)
		as (
				select 
						max(hist.id) as 'casetas_historical_conciliations_id',hist.casetas_controls_files_id
				from
						sistemas.dbo.casetas_historical_conciliations as hist 
				group by	
						hist.casetas_controls_files_id
			)
	select 
			 hist.casetas_historical_conciliations_id
			,hist.casetas_controls_files_id
			,iave_per._filename,iave_per.cia,iave_per.iave_period
			,rstand.casetas_standings_id,rstand.casetas_standings_name
			,vw.no_viaje
	from
			historic as hist
			left join
						(
							select 
									per.casetas_controls_files_id,con._filename,con.cia,per.key_num_2 as 'iave_period'
							from 
									sistemas.dbo.casetas_views as con
								inner join
											(
												select  sisca.casetas_controls_files_id,sisca.key_num_2 ,sisca._filename COLLATE SQL_Latin1_General_CP1_CI_AS as '_filename',sisca._area from sistemas.dbo.casetas as sisca
												group by sisca.casetas_controls_files_id,sisca.key_num_2 ,sisca._filename,sisca._area
											) 
									as per on per._filename = con._filename
							group by 
									per.casetas_controls_files_id,con._filename,con.cia,per.key_num_2
						)
				as iave_per on iave_per.casetas_controls_files_id = hist.casetas_controls_files_id
			inner join 
					sistemas.dbo.casetas_view_resume_stands as rstand
						on hist.casetas_historical_conciliations_id = rstand.casetas_historical_conciliations_id and hist.casetas_controls_files_id = rstand.casetas_controls_files_id
							and 
								rstand.casetas_standings_id = 1	
			left join
					sistemas.dbo.casetas_views as vw
						on 	vw.casetas_historical_conciliations_id = rstand.casetas_historical_conciliations_id and vw.casetas_controls_files_id = hist.casetas_controls_files_id
							and
								vw.casetas_standings_id = rstand.casetas_standings_id
	-- -
		--where hist.casetas_controls_files_id = 21 -- and vw.no_viaje = '22812'
	-- -
	group by	
				hist.casetas_controls_files_id,hist.casetas_historical_conciliations_id
				,iave_per._filename,iave_per.cia,iave_per.iave_period
				,rstand.casetas_standings_id,rstand.casetas_standings_name
				,vw.no_viaje

	--order by 
	--			hist.casetas_controls_files_id



--====================================================================================================================================================================================
-- Trigger CasetasTigerTollbooth
--====================================================================================================================================================================================

USE sistemas;
-- go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
-- go

ALTER TRIGGER [dbo].[casetas_tiger_tollbooth] 
   ON  [dbo].[casetas_tiger_runs] 
   AFTER INSERT
 AS
    declare
  		@bussines_unit				int,
		@casetas_controls_files_id	int,
		@user_id					int,
		@created					datetime,
		@_status					int
BEGIN
    SET NOCOUNT ON;

    -- Insert statements for trigger here
	
    Select @bussines_unit=bussines_unit,@casetas_controls_files_id=casetas_controls_files_id,@user_id=user_id,@created=created,@_status=_status  From Inserted;
	
	--insert into casetas_tiger_run_back values(@bussines_unit,@casetas_controls_files_id,@user_id,@created,@_status);
    EXEC sp_tollbooth @bussines_unit,@casetas_controls_files_id,@user_id;

END
-- go

--====================================================================================================================================================================================
-- Trigger-Table CasetasTigerRun
--====================================================================================================================================================================================
use [sistemas]
-- go
IF OBJECT_ID('dbo.casetas_tiger_runs', 'U') IS NOT NULL 
  DROP TABLE dbo.casetas_tiger_runs; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[casetas_tiger_runs](
		id							int identity(1,1),
		bussines_unit				int,
		casetas_controls_files_id	int,
		user_id						int,
		created						datetime,
		_status						tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

--====================================================================================================================================================================================
-- Trigger-Table CasetasTigerRunBack
--====================================================================================================================================================================================
--use [sistemas]
---- go
--IF OBJECT_ID('dbo.casetas_tiger_run_back', 'U') IS NOT NULL 
--  DROP TABLE dbo.casetas_tiger_run_back; 
---- go
--set ansi_nulls on
---- go
--set quoted_identifier on
---- go
--set ansi_padding on
---- go
 
--create table [dbo].[casetas_tiger_run_back](
--		id							int identity(1,1),
--		bussines_unit				int,
--		casetas_controls_files_id	int,
--		user_id						int,
--		created						datetime,
--		_status						tinyint default 1 null
--) on [primary]
---- go

--set ansi_padding off
---- go


--====================================================================================================================================================================================
-- Trigger CasetasTigerTollbooth
--====================================================================================================================================================================================

--USE sistemas;
---- go

--set ANSI_NULLS ON
--set QUOTED_IDENTIFIER ON
---- go

--CREATE TRIGGER [dbo].[casetas_tiger_tollbooth_back] 
--   ON  [dbo].[casetas_tiger_run_back] 
--   AFTER INSERT
-- AS
--    declare
--  		@bussines_unit				int,
--		@casetas_controls_files_id	int,
--		@user_id					int
--BEGIN
--    SET NOCOUNT ON;

--    -- Insert statements for trigger here
--    Select @bussines_unit=bussines_unit,@casetas_controls_files_id=casetas_controls_files_id,@user_id=user_id  From Inserted
--    EXEC sp_tollbooth @bussines_unit,@casetas_controls_files_id,@user_id;

--END
---- go

 --TEMPORAL *ing table

--use [sistemas]
---- go
--IF OBJECT_ID('dbo.casetas_forview', 'U') IS NOT NULL 
--  DROP TABLE dbo.casetas_forview; 
---- go
