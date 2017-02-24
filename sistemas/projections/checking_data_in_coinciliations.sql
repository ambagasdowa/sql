-- ====================== Analisis de nombres de Casetas ============================= ---
declare @file_id as int ; 
set @file_id = 156 ;

-- =================================================================================== ---
--							   busca Cruces de Lis y Iave 
-- =================================================================================== ---
	select 
			*
	from 
			sistemas.dbo.casetas_views 
	where 
			id in (1284954,1285603) 


	select 
			*
	from 
			sistemas.dbo.casetas_views 
	where 
			casetas_controls_files_id = @file_id
		and 
			casetas_historical_conciliations_id 
			in 
				(
					select 
							max(id) 
					from 
							sistemas.dbo.casetas_historical_conciliations where casetas_controls_files_id = @file_id
				) 
		and
			id in (1284954,1285603) 
	group by
			description_casetas,no_tarjeta_iave
--	order by no_tarjeta_iave

			
-- =================================================================================== ---
--							   simple search Lis y Iave 
-- =================================================================================== ---
	select 
			*
	from 
			sistemas.dbo.casetas_views 
	where 
			id in (1284954,1285603) 
			
--lis 1284954
--iave 1285603

--maria.leonell@tcgeminis.com.mx


