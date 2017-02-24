
-- ====================== Analisis de nombres de Casetas ============================= ---
declare @file_id as int ; set @file_id = 137 --156 ;

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
									shit.alpha_location
								else	
									shit.key_num_5 
						end
					) as 'manbo_number_5'
				 ,shit.key_num_5
				 ,shit.iave_iave
		from 
				sistemas.dbo.casetas_views as shit
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
				shit.casetas_standings_id = 6
			)
select count(manbo_number_5) as 'sin_conciliar_iave',manbo_number_5,key_num_5,iave_iave from cosa_maluapan group by manbo_number_5,key_num_5,iave_iave order by iave_iave
;

-- =================================================================================== ---
--							   cruces de lis sin conciliar 
-- =================================================================================== ---
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
		casetas_standings_id = 5
group by
		description_casetas,no_tarjeta_iave
order by no_tarjeta_iave
		;


-- =================================================================================== ---
--							   cruces de lis conciliados
-- =================================================================================== ---
select 
		count(id) as 'conciliados_lis',description_casetas,no_tarjeta_iave
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
		casetas_standings_id = 1
group by
		description_casetas,no_tarjeta_iave
order by no_tarjeta_iave;

-- =================================================================================== ---
--							   cruces de iave conciliados
-- =================================================================================== ---
;with iave_con as (
select 
		(
				case
					when cast(iave_caseta_id as int) 
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
							alpha_location
						else	
							key_num_5 
				end
			) as 'manbo_number_5'
		,key_num_5,iave_iave
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
		casetas_standings_id = 1
group by
		alpha_location,key_num_5,iave_caseta_id,iave_iave
)
select count(key_num_5) as 'conciliados_iave',manbo_number_5,key_num_5,iave_iave from iave_con group by manbo_number_5,key_num_5,iave_iave order by iave_iave;



-- =================================================================================== ---
-- 				   cruces de lis liquidados sin casetas y sin conciliar
-- =================================================================================== ---

select 
		count(id) as 'liquidados_sin_casetas_sin_conciliar',no_tarjeta_iave
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
		casetas_standings_id = 5
	and 
		liq_monto_iave is null
	and 
		no_viaje is not null
group by
		rollup (
					no_tarjeta_iave
			   )	
order by 
		no_tarjeta_iave desc;

-- =================================================================================== ---
--	   				   cruces de lis NO liquidados
-- =================================================================================== ---
	select 
			count(desc_ruta ) as 'viajes_no_liquidados',desc_ruta 
	from 
			sistemas.dbo.casetas_lis_full_conciliations 
	where 
			casetas_controls_files_id = @file_id 
		and 
			casetas_historical_conciliations_id 
			in 
				(
					select max(id) from sistemas.dbo.casetas_historical_conciliations where casetas_controls_files_id = @file_id
				) 
		and 
			liq_id_caseta is null 
		and 
			liq_no_liquidacion is null
		and
			no_viaje is not null
	group by
			rollup
					(
						desc_ruta
					)
			

-- =================================================================================== ---
--	   			    cruces de lis liquidados sin casetas
-- =================================================================================== ---
	select 
			count(desc_ruta ) as 'viajes_liquidados_sin_casetas',desc_ruta
	from 
			sistemas.dbo.casetas_lis_full_conciliations 
	where 
			casetas_controls_files_id = @file_id 
		and 
			casetas_historical_conciliations_id 
			in 
				(
					select max(id) from sistemas.dbo.casetas_historical_conciliations where casetas_controls_files_id = @file_id
				) 
		and 
			liq_id_caseta is null 
		and 
			liq_no_liquidacion is not null
		and
			no_viaje is not null
	group by 
			rollup	(
						desc_ruta
					)
	