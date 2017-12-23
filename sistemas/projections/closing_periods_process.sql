-- Cierra periodos en el modulo de Projecciones instalado en el portal web GST 

-- Builder 		
-- ============================================================================================================== --
-- ====================================      CERRAR PËRIODOS          =========================================== --
-- ============================================================================================================== --
			
-- exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations '3','0','1','0','0';

-- dashboard for periods 
-- select * from sistemas.dbo.projections_view_closed_period_units

			
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


-- unclosing method example

--select count(id) from
delete sistemas.dbo.projections_closed_period_datas
where area in ('TULTILAN','CUAUTITLAN') and year(fecha_guia) = '2017' and month(fecha_guia) = '11'

--select * from
delete sistemas.dbo.projections_dissmiss_cancelations 
where area in ('TULTILAN','CUAUTITLAN') and year(fecha_cancelacion) = '2017' and month(fecha_cancelacion) = '11'

--select * from 
delete sistemas.dbo.projections_closed_period_controls 
where projections_corporations_id = '3' and year(projections_closed_periods) = '2017' and month(projections_closed_periods) = '11'

select * from sistemas.dbo.projections_view_closed_period_units

