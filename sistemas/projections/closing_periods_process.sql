-- Cierra periodos en el modulo de Projecciones instalado en el portal web GST 

-- ============================================================================================================== --
-- ====================================      CHECA PËRIODOS STATUS     ========================================== --
-- ============================================================================================================== --

-- dashboard for periods 
-- Check the closets periods 
-- select * from sistemas.dbo.projections_view_closed_period_units
-- select * from sistemas.dbo.monitor_closed_periods

-- ============================================================================================================== --
-- ====================================      CHECK CLOSED PERIOD          =========================================== --
-- ============================================================================================================== --
-- Check inside Zam Software if is the period already closed
use sistemas

IF OBJECT_ID ('monitor_closed_periods', 'V') IS NOT NULL
    DROP VIEW monitor_closed_periods;

create view monitor_closed_periods
with encryption
as
	with "closed" as (
 		select 
 				 projections_corporations_id
 				,substring( convert(nvarchar(MAX), projections_closed_periods, 112) , 1, 6 ) as 'period'
 		from 
 				sistemas.dbo.projections_view_closed_period_units
 		group by 
 				projections_corporations_id,substring( convert(nvarchar(MAX), projections_closed_periods, 112) , 1, 6 )
 	)
 	select 
 			 "cls".projections_corporations_id
 			,"cls".period as 'cierre_portal'
 			,"lscld".cierre_periodo as 'cierre_lis'
 			,"lscld".company
 	from 
 			"closed" as "cls"  	
 		left join(
			 		select 1 as 'id',max(cierre_periodo) as 'cierre_periodo','tbk' as 'company' from bonampakdb.dbo.cont_cierre 
			 		union all
			 		select 2 as 'id',max(cierre_periodo) as 'cierre_periodo','atm' as 'company' from macuspanadb.dbo.cont_cierre 
			 		union all
			 		select 3 as 'id',max(cierre_periodo) as 'cierre_periodo','tei' as 'company' from tespecializadadb.dbo.cont_cierre 
				 ) as "lscld"
		on 
			"cls".period = "lscld".cierre_periodo and "cls".projections_corporations_id = "lscld".id


-- Builder 		
-- ============================================================================================================== --
-- ====================================      CERRAR PËRIODOS          =========================================== --
-- ============================================================================================================== --
			
-- exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations '1','0','1','0','0';


-- @route_file sp_xd3e_getFullCompanyOperations_v1.0.7.sql
			
-- ============================================================================================================== --
-- ====================================   Procedure usage		      =========================================== --			
-- ============================================================================================================== --			
-- exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations		
--															@company   1:tbk 2:atm 3:teisa
--															@unit	   0:all Areas , or id_area
--															@mode      1 : Production , 9 : test 
--															@user_id   can be 0 / option just for development 
--															@period	   can be 0 / option just for development 

--example close all tbk :: exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations '1','0','1','0','0';
--example close all atm :: exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations '2','0','1','0','0';
--example close all tei :: exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations '3','0','1','0','0';
-- ============================================================================================================== --






-- ============================================================================================================== --
-- ===============================   In DEVELOPMENT dont'n run the scripts below    ============================= --
-- ============================================================================================================== --

select (left( CONVERT(VARCHAR(10),cast('2017-12-02 00:00:00.000' as datetime), 112), 6) ) as 'date'
union all
select (left( CONVERT(VARCHAR(10), CURRENT_TIMESTAMP, 112), 6) ) as 'date'



-- unclosing method example

-- select * from
-- delete 
sistemas.dbo.projections_closed_period_datas
where 
--	area in ('MACUSPANA','ORIZABA') 
	company in ('1')
	and year(fecha_guia) = '2017' and month(fecha_guia) = '12'

-- select * from
-- delete 
	sistemas.dbo.projections_dissmiss_cancelations 
	where 
--		area in ('TULTILAN','CUAUTITLAN')
		company in ('1')
		and 
		year(fecha_cancelacion) = '2017' and month(fecha_cancelacion) = '12'

-- select * from 
-- delete 
	sistemas.dbo.projections_closed_period_controls 
	where 
		projections_corporations_id = '1' and year(projections_closed_periods) = '2017' and month(projections_closed_periods) = '12'

select * from sistemas.dbo.projections_view_closed_period_units



select 
	* 
from 
-- delete 
	sistemas.dbo.projections_dissmiss_cancelations 
where 
	num_guia = 'OR-079384'


	
select 
	* 
from 
-- delete 
	sistemas.dbo.projections_dissmiss_cancelations 
where 
	num_guia = 'OR-079384'	
	
	
	
	
select 
	* 
from 
-- delete 
	sistemas.dbo.projections_dissmiss_cancelations 
where 
		id_area = '5'
and 
	year(fecha_cancelacion) = '2018'
	and month(fecha_cancelacion) = '07'
	
select * from
-- delete 
sistemas.dbo.projections_closed_period_datas
where 
	area in ('TIJUANA') 
and
	company in ('1')
and
	year(fecha_guia) = '2018' and month(fecha_guia) = '07'
	
	oh-017083
	
select * from sistemas.dbo.projections_view_indicators_periods_fleets
where mes = 'JULIO' and cyear = '2018' and id_area = '5'

select sum(subtotal) from sistemas.dbo.projections_view_full_company_indicators 
where mes = 'JULIO' and year(fecha_guia) = '2018' and month(fecha_guia) = '07' and fraccion = 'GRANEL'
and 
area = 'HERMOSILLO'

select 
-- *
	sum(subtotal)
from 
-- update 
--delete 
sistemas.dbo.projections_closed_period_datas
--set _status = 0
where mes = 'JULIO' and year(fecha_guia) = '2018' and id_area = '5'
and fraccion = 'GRANEL' 
--and id = 153692





select sum(subtotal) from bonampakdb.dbo.trafico_guia where year(fecha_guia) = '2018'
and month(fecha_guia) = '07' and id_area = '5' and status_guia <> 'B' and prestamo = 'N' and tipo_doc = 2
and id_fraccion in (1,2,6)
	


select * from sistemas.dbo.projections_view_full_company_indicators where  area = 'HERMOSILLO'


select * from sistemas.dbo.projections_view_indicators_periods where area = 'HERMOSILLO' and cyear = '2018' and mes = 'JULIO'

--select * from sistemas.dbo.projections_view_full_company_indicators where num_guia in ('OT-038455','OT-038456')


-- Despachado
select * from sistemas.dbo.projections_view_full_company_dispatched_indicators

select 
		*
from bonampakdb.dbo.Bon_v_tondespachado where Año = '2018' and mes = 'Julio'
and Talon = 'OT-038423'


