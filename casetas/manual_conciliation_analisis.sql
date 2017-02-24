select * from sistemas.dbo.casetas_standings

select * from sistemas.dbo.casetas_parents

select top (10) * from sistemas.dbo.casetas_views ;


select *from sistemas.dbo.casetas_view_not_conciliations where period_iave_id = 391 and name = 'CUAUTITLAN'

select * from sistemas.dbo.casetas_lis_not_conciliations where no_viaje  = 22847



--------------------------------------------------------------------------------------------------------------------------------------------------------


select * from sistemas.dbo.casetas_views

where id 
in 
(
 31044
,31050
,31064
) 

-- Manual set

select * from sistemas.dbo.casetas_views where casetas_standings_id = 1 and casetas_parents_id = 4

 -- update sistemas.dbo.casetas_views set no_viaje = null,no_tarjeta_iave = null ,id_unidad = null ,f_despachado = null,fecha_fin_viaje = null,casetas_standings_id = 6, casetas_parents_id = 1  where casetas_standings_id = 1 and casetas_parents_id = 4


 exec sp_upt_tollbooth_manual_conciliation 21 , 25 , 1;

 exec sp_upt_tollbooth_manual_trips_not_conciliation;

select * from casetas_historical_conciliations where casetas_controls_files_id = 21 and id = 25


select * from casetas_view_resumes where historical_id = '25' and id = 21

select * from 
				sistemas.dbo.casetas_view_resume_stands 
		where casetas_controls_files_id = 21 and casetas_historical_conciliations_id = 25


--------------------------------------------------------------------------------------------------------------------------------------------------------
select * from sistemas.dbo.casetas_view_not_conciliations where no_viaje in ( '22799')

select * from sistemas.dbo.casetas_parents

select * from sistemas.dbo.casetas_standings


select * from sistemas.dbo.casetas_views as kst where  kst.casetas_controls_files_id = 21 and kst.casetas_historical_conciliations_id = 25
