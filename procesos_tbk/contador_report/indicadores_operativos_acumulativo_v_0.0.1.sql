-- =================================================================================================================== --
-- Consulta Indicadores Acumulados para la Direccion 
-- Noviembre 2017 
-- archivo : tonelaje_despachado_grupo.xlsx
-- ==================================================================================================================== --	
-- =============================      full query indicators for all company    ======================================== --
-- ==================================================================================================================== --


use sistemas;
IF OBJECT_ID ('projections_view_dispatch_group_granel_details', 'V') IS NOT NULL
    DROP VIEW projections_view_dispatch_group_granel_details;

create view projections_view_dispatch_group_granel_details
--with encryption
as
select 
		 id_area,id_unidad
		,id_configuracionviaje
		,id_tipo_operacion
		,id_fraccion
		,id_flota
		,no_viaje,fecha_guia
		,mes
		,f_despachado
		,year(f_despachado) as 'cyear'
		,day(f_despachado) as 'dia'
		,cliente
		,( kms_viaje * 2 ) as 'kms_viaje'
		,kms_real
		,subtotal
		,peso
		,configuracion_viaje
		,tipo_de_operacion
		,flota
		,case
			when id_tipo_operacion = '12'
				then 'LA PAZ'
			else
				area
		end as 'area'
		,fraccion
		,company
		,cast(trip_count as int) as viajes
		,'' as 'diasOperativos'
from sistemas.dbo.projections_view_full_company_dispatched_indicators as "disp"
where 
		year(f_despachado) >= year(current_timestamp)
	and 
		id_fraccion in (
	                    select prfrt.projections_id_fraccion
						from sistemas.dbo.projections_view_company_fractions as prfrt
						where prfrt.projections_corporations_id = "disp".company and prfrt.projections_rp_fraction_id = 1
					   ) -- means granel
					   

					   
-- ==================================================================================================================== --	
-- =========================      full query holidays acumulative for all company    ================================== --
-- ==================================================================================================================== --

					   
use sistemas;
IF OBJECT_ID ('projections_view_dispatch_group_holidays', 'V') IS NOT NULL
    DROP VIEW projections_view_dispatch_group_holidays;

create view projections_view_dispatch_group_holidays
--with encryption
as
select 		
	     null as 'id_area'
	    ,'' as 'id_unidad'
		,null as 'id_configuracionviaje'
		,null as 'id_tipo_operacion'
		,null as 'id_fraccion'
		,null as 'id_flota'
		,null as 'no_viaje'
		,'' as 'fecha_guia'
		,"month" as 'mes'
		,'' as 'f_despachado'
		,cyear
		,'' as 'dia'
		,'' as 'cliente'
		,null as 'kms_viaje'
		,null as 'kms_real'
		,null as 'subtotal'
		,null as 'peso'
		,'' as 'configuracion_viaje'
		,'' as 'tipo_de_operacion'
		,'' as 'flota'
		,'diasOperativos' as 'area'
		,'' as 'fraccion'
		,'' as 'company'
		,null as 'viajes'
		,sum(labDays) as 'diasOperativos'
from 
		sistemas.dbo.ingresos_costos_gst_holidays 
where 
		cyear >= year(current_timestamp)
group by 
		cyear,"month"	
		
-- ==================================================================================================================== --	
-- =====================      full query holidays acumulative with indicators for all company    ====================== --
-- ==================================================================================================================== --		   
		
use sistemas;
IF OBJECT_ID ('projections_view_dispatch_group_ind_details', 'V') IS NOT NULL
    DROP VIEW projections_view_dispatch_group_ind_details;
create view projections_view_dispatch_group_ind_details
--with encryption
as
with ind as (
select * from projections_view_dispatch_group_granel_details
union all		
select * from projections_view_dispatch_group_holidays	
)
select * from ind 


