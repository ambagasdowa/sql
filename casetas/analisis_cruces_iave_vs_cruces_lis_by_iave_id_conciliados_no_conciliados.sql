
-- ====================== Analisis de nombres de Casetas ============================= ---
declare @file_id as int ; set @file_id = 156 ;

declare @iav as nvarchar(200); set @iav = 'IMDM22147914..'-- 'IMDM21337804..' ;

-- =================================================================================== ---
--							   cruces de iave sin conciliar 
-- =================================================================================== ---
;with cosa_maluapan as (
		select 
				(
						case
							when cast(shit.iave_caseta_id as int) 
																	in 
																		(
																			select 
																					id_iave.casetas_iave_id 
																			from 
																					sistemas.dbo.casetas_iave_caseta_descriptions as id_iave 
																			where 
																					id_iave._status = 1
																		)
								then 
									cast(shit.alpha_location as nvarchar(200)) COLLATE Modern_Spanish_CI_AS
								else	
									cast(shit.key_num_5 as nvarchar(200)) COLLATE Modern_Spanish_CI_AS
						end
					) as 'manbo_number_5'
				 ,shit.key_num_5
				 ,shit.iave_iave
				 ,case
					when casetas_standings_id = 6
						then 'no_conciliado'
					when casetas_standings_id = 1
						then 'conciliado'
				 end as 'Estado_iave'
				 ,lis.description_casetas
				 ,lis.no_tarjeta_iave
				 ,lis.no_viaje
				 ,lis.Estado_lis
		from 
				sistemas.dbo.casetas_views as shit
			left join 
						(
							select 
									count(id) as 'sin_conciliar_lis',description_casetas,no_tarjeta_iave,no_viaje
									,case
										when casetas_standings_id = 5
											then null
										when casetas_standings_id = 1
											then 'conciliado'
									end as 'Estado_lis'
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
									casetas_standings_id in (5,1) -- > no conciliado de iave
							group by
									description_casetas,no_tarjeta_iave,no_viaje,casetas_standings_id
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
				shit.casetas_standings_id in (6,1) -- > no conciliado de lis (liquidado y los null son viajes sin liquidar)
			)
select 
		count(manbo_number_5) as 'sin_conciliar_iave',manbo_number_5 as 'NombreIave',key_num_5,iave_iave,Estado_iave,description_casetas,no_tarjeta_iave,no_viaje,Estado_lis
from 
		cosa_maluapan 
--where 
--		no_tarjeta_iave = @iav
group by 
		manbo_number_5,key_num_5,iave_iave,description_casetas,no_tarjeta_iave,no_viaje,Estado_iave,Estado_lis
order by 
		iave_iave
;
