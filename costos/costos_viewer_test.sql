	-- ============================================================= --
    -- 15 secs
	
	select * from sistemas.dbo.reporter_costos
	where  
	cyear = '2017' 
	--and 
--	_period in ('201706') 
--	 and _source_company = 'TEICUA'
--	 and type = 'OF'
	order by "type","_period","_source_company"


	
	
	select
			 "_source_company"
			,area
			,mes
			,sum("Real") as 'Real'
			,sum(Presupuesto) as 'Presupuesto'
			,"_period"
			,"type"
			,cyear
	from
			sistemas.dbo.reporter_costos
	where
			_period
				between
						(left(CONVERT(VARCHAR(10), (dateadd(month,-6,CURRENT_TIMESTAMP)), 112), 6))
				and
						(left(CONVERT(VARCHAR(10), (dateadd(month,1,CURRENT_TIMESTAMP)), 112), 6))
				and
					(
						(
							"_source_company" in ('ATMMAC','TEICUA','TCGTUL')
						)
					or
						(
							"_source_company" not in ('ATMMAC','TEICUA','TCGTUL')
						and
							UnidadNegocio not in ('00')
						)
					)									
	group by
			 "_source_company"
			,area
			,mes
			,"_period"
			,"type"
			,cyear
	
	-- ============================================================= --
	-- 54.569 secs 
	select 
			 "_source_company"
			,"UnidadNegocio"
			,round(sum("Real"),3) as "Real"
			,round(sum(Presupuesto),3) as "Presupeusto"
			,"_period"
			,"_key"
	from 
			sistemas.dbo.reporter_view_report_accounts	
	where 
			"_period" in 
						(
							select * from openquery(
														local,'exec sistemas.dbo.sp_builder_mr_periods_accounts "20170", "20", "|";'
													  )
						) 
		and
			(
				(
					"_source_company" in ('ATMMAC','TEICUA','TCGTUL')
				)
			or
				(
					"_source_company" not in ('ATMMAC','TEICUA','TCGTUL')
				and
					"Compania" not in ('ATMMAC','TEICUA','TCGTUL')
--				and
--					UnidadNegocio not in ('00')
				)
			)
	group by	
			 "_source_company"
			,"UnidadNegocio"
			,"_period"
			,"_key"
	order by 
			"_key","_source_company","_period"

 -- ====================================================== --


 			 
 			 
 			 
--get the accounts
 			 
select "_key","_description" from sistemas.dbo.reporter_table_keys
 			
-- view for accounts  			 
-- build

select 
--			id,
			"_key" ,rangeaccounta --,segmenta ,segmentb
from 
			sistemas.dbo.reporter_view_sp_xs4z_accounts -- where "_key" = 'OF'
group by 
--			id,
			"_key",rangeaccounta
			


			
--get the areas

			select * from sistemas.dbo.projections_corporations
			
			select * from sistemas.dbo.projections_global_corps
			
			select * from sistemas.dbo.projections_view_bussiness_units
			
-- This are importants !!

			select * from sistemas.dbo.reporter_views_bussiness_units
			
			select * from sistemas.dbo.reporter_views_years
			
-- from solomon
			select * from integraapp.dbo.xrefcia
			

			
			
			
			
-- 3977

select
		 "UnidadNegocio"
		,round((sum(Cargo) - sum(Abono)),3) as 'Real'
		,round(sum(Presupuesto),3) as 'Prep'
		,"Mes"
from 
		integraapp.dbo.fetchCostosAdministracionBonampak where Año = '2017'	and Mes = 'Abril'
group by 
		"UnidadNegocio"
		,"Mes"
		

		
		
select
		 "UnidadNegocio"
		,round((sum(Cargo) - sum(Abono)),3) as 'Real'
		,round(sum(Presupuesto),3) as 'Prep'
		,"Mes"
from integraapp.dbo.fetchCostosFijosOpOrizaba where Año = '2017'	and Mes = 'Junio'
group by 
		"UnidadNegocio"
		,"Mes"

-- select Acct,Sub,* from integraapp.dbo.GLTran where Acct = '0601070100' and CpnyID = 'ATMMAC' and PerPost = '201704' and Posted = 'P' 


		
		
-- select * from sistemas.dbo.projections_view_full_company_indicators
		
		
		
select * from sistemas.dbo.reporter_costos_accounts



select * from sistemas.dbo.reporter_view_sp_xs4z_accounts



			
			
			
			
			
			
			
			
			
			
			
			
			
			


