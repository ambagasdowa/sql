	-- ============================================================= --
	select * from sistemas.dbo.reporter_costos
	where _period = '201705' and _source_company = 'ATMMAC'
	-- ============================================================= --
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
--		and 
--			"_key" = 'OV'
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

-- 3977
select
		 "UnidadNegocio"
		,round((sum(Cargo) - sum(Abono)),3) as 'Real'
		,round(sum(Presupuesto),3) as 'Prep'
		,"Mes"
from integraapp.dbo.fetchCostosAdministracionBonampak where Año = '2017'	and Mes = 'Abril'
group by 
		"UnidadNegocio"
		,"Mes"
		

		
		
select
		 "UnidadNegocio"
		,round((sum(Cargo) - sum(Abono)),3) as 'Real'
		,round(sum(Presupuesto),3) as 'Prep'
		,"Mes"
from integraapp.dbo.fetchCostosFijosOpOrizaba where Año = '2017'	and Mes = 'Abril'
group by 
		"UnidadNegocio"
		,"Mes"

-- select Acct,Sub,* from integraapp.dbo.GLTran where Acct = '0601070100' and CpnyID = 'ATMMAC' and PerPost = '201704' and Posted = 'P' 


