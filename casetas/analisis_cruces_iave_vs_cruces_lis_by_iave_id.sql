
-- ====================== Analisis de nombres de Casetas ============================= ---
declare @file_id as int ; set @file_id = 156 ;

-- =================================================================================== ---
--							   cruces de iave sin conciliar 
-- =================================================================================== ---
;with cosa_maluapan as (
		select 
				(
						case
							when cast(shit.iave_caseta_id as int) in (316)
								then 
									shit.alpha_location
								else	
									shit.key_num_5 
						end
					) as 'manbo_number_5'
				 ,shit.key_num_5
				 ,shit.iave_iave
				 ,lis.description_casetas
				 ,lis.no_tarjeta_iave
		from 
				sistemas.dbo.casetas_views as shit
			left join 
						(
							select 
									count(id) as 'sin_conciliar_lis',description_casetas,no_tarjeta_iave
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
									casetas_standings_id = 5 -- > no conciliado de iave
							group by
									description_casetas,no_tarjeta_iave
						--	order by no_tarjeta_iave
						) as lis on shit.iave_iave = lis.no_tarjeta_iave
		where 
				shit.casetas_controls_files_id = @file_id
			and 
				shit.casetas_historical_conciliations_id 
				in 
					(
						select 
								max(id) 
						from 
								sistemas.dbo.casetas_historical_conciliations where casetas_controls_files_id = @file_id
					) 
			and
				shit.casetas_standings_id = 6 -- > no conciliado de lis (liquidado y los null son viajes sin liquidar)
			)
select count(manbo_number_5) as 'sin_conciliar_iave',manbo_number_5,key_num_5,iave_iave,description_casetas,no_tarjeta_iave from cosa_maluapan group by manbo_number_5,key_num_5,iave_iave,description_casetas,no_tarjeta_iave order by iave_iave
;