-- Cierra periodos en el modulo de Projecciones instalado en el portal web GST 

-- Builder 		
-- ============================================================================================================== --
-- ====================================      CERRAR PËRIODOS          =========================================== --
-- ============================================================================================================== --
			
-- exec sistemas.dbo.sp_build_xd3e_getFullCompanyOperations '1','0','1','0','0';

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
