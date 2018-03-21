													
use bonampakdb;

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
		(order by label) as 
							 id
							,projections_corporations_id
							,id_area
							,label
	from(
			--select (select 0) as 'projections_corporations_id',(select 0) as 'id_area', (select 'SIN ASIGNAR') as 'name'
			--union all
			select
					 (select 1) as 'projections_corporations_id'
					,tbk.id_area as 'id_area'
					,ltrim(rtrim(replace(replace(replace(replace(replace(tbk.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'label'
--					,label.label
			from 
					bonampakdb.dbo.general_area as tbk
--					left join 
--								(
--									select 
--											module_data_definition,module_field_translation as 'label' 
--									from 
--											bonampakdb.dbo.projections_configs where projections_type_configs_id = 4
--								) as label 
--					on label.module_data_definition collate SQL_Latin1_General_CP1_CI_AS = (ltrim(rtrim(replace(replace(replace(replace(replace(tbk.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))))
			where 
					tbk.id_area <> 0
				union all
			select
					(select 2) as 'projections_corporations_id'
					,atm.id_area as 'id_area'
					,ltrim(rtrim(replace(replace(replace(replace(replace(atm.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'label'
--					,label.label
			from 
					macuspanadb.dbo.general_area as atm
--					left join 
--								(
--									select 
--											module_data_definition,module_field_translation as 'label' 
--									from 
--											bonampakdb.dbo.projections_configs where projections_type_configs_id = 4
--								) as label 
--					on label.module_data_definition collate SQL_Latin1_General_CP1_CI_AS = (ltrim(rtrim(replace(replace(replace(replace(replace(atm.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))))
			where 
					atm.id_area <> 0
				union all
			select
					(select 3) as 'projections_corporations_id'
					,tei.id_area as 'id_area'
					,ltrim(rtrim(replace(replace(replace(replace(replace(tei.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))) as 'label'
--					,label.label
			from 
					tespecializadadb.dbo.general_area as tei
--					left join 
--								(
--									select 
--											module_data_definition,module_field_translation as 'label' 
--									from 
--											bonampakdb.dbo.projections_configs where projections_type_configs_id = 4
--								) as label 
--					on label.module_data_definition collate SQL_Latin1_General_CP1_CI_AS = (ltrim(rtrim(replace(replace(replace(replace(replace(tei.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN'))))
			where
					tei.id_area <> 0
		) as result
)
	select 
			 "units".id
			,"units".projections_corporations_id
			,"units".id_area 
			,case 
				when "units".label = 'TIJUANA'
					then 'MEXICALI'
				else "units".label
			end as 'label'
--			,"units".label
--			,"cia".IDSL as 'tname'
	from 
			"bunits" as "units"
--	inner join 
--			(
--				select IDSL,AreaLIS from integraapp.dbo.xrefcia
--			)
--		as "cia" on substring("units".label,1,7) = substring("cia".AreaLis,1,7)
-- go
