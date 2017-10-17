-- ==================================================================================================================== --	
-- =================================     General Tables for Constant Values      ====================================== --
-- ==================================================================================================================== --

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 06, 2017
 Description    : Build Tables for constant values like months names translation to spanish names
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ===============================================================================*/


-- ==================================================================================================================== --	
-- =================================     	  month translation table		     ====================================== --
-- ==================================================================================================================== --


use sistemas

IF OBJECT_ID('dbo.generals_month_translations', 'U') IS NOT NULL 
  DROP TABLE dbo.generals_month_translations; 

set ansi_nulls on

set quoted_identifier on

set ansi_padding on

 
create table dbo.generals_month_translations(
		id									int identity(1,1),
		month_num							int,
		month_name							nvarchar(60) 		collate		sql_latin1_general_cp1_ci_as,
		created								datetime,
		modified							datetime,
		_status								tinyint default 1 null
) on [primary]

set ansi_padding off

--	insert into sistemas.dbo.generals_month_translations values 	('1','enero',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('2','febrero',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('3','marzo',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('4','abril',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('5','mayo',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('6','junio',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('7','julio',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('8','agosto',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('9','septiembre',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('10','octubre',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('11','noviembre',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('12','diciembre',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1')
--																	
--	select * from sistemas.dbo.generals_month_translations
																	

-- ==================================================================================================================== --	
-- ======================================     	  bsu of GST				     ====================================== --
-- ==================================================================================================================== --
			
select * from sistemas.dbo.general_view_bussiness_units

use sistemas;

IF OBJECT_ID ('general_view_bussiness_units', 'V') IS NOT NULL
    DROP VIEW general_view_bussiness_units;
-- now build the view
create view general_view_bussiness_units
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
		
		
-- ==================================================================================================================== --	
-- ======================================     	  ???????????			     ====================================== --
-- ==================================================================================================================== --	
