-- Cierra periodos en el modulo de Projecciones instalado en el portal web GST 

-- Builder 		
-- ============================================================================================================== --
-- ====================================      CERRAR PËRIODOS          =========================================== --
-- ============================================================================================================== --
			
-- exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations '1','0','1','0','0';

-- dashboard for periods 
-- select * from sistemas.dbo.projections_view_closed_period_units

-- @route sp_xd3e_getFullCompanyOperations_v1.0.7.sql
			
-- ============================================================================================================== --
-- ====================================   Procedure usage		      =========================================== --			
-- ============================================================================================================== --			
-- exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations		
--															@company   1:tbk 2:atm 3 teisa
--															@unit	   0:all , or id_area
--															@mode      1 : Production , 9 : test 
--															@user_id   can be 0 / just for development option
--															@period	   can be 0 / just for development option
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

