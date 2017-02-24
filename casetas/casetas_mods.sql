--/** changes from directors of gst  */
--/**	Eliminar el Filtro de Viaje -liquidado
 --*	Eliminar vehiculos Utilitarios del porcentaje General
 --*	Crear interfaz para conciliacion manual y sumar el porcentaje al procentaje general
 --*
 --*/


select * from casetas_view_resumes where historical_id = '295'

select * from 
				sistemas.dbo.casetas_view_resume_stands 
		where 
				casetas_controls_files_id = '1' and casetas_historical_conciliations_id = '295'


				select * from casetas_iave_periods
------------------- casetas_view_resume_stands

select 
			vcasetas.casetas_controls_files_id ,vcasetas.casetas_historical_conciliations_id,
			stand.casetas_standings_name,
			sum(vcasetas.float_data) as 'monto_total',
			(select ((sum(float_data))/ctrlfile._montos) * 100) as 'percent_montos_old',
			--case 
			--	when vcasetas.casetas_standings_id = 9
			--		then (select '100.00')
			--	else
			--		(select ((sum(float_data))/ ( ctrlfile._montos - (select rs.monto_total from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rs.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rs._filename = vcasetas._filename))) * 100)
			--end as 'percent_montos',
			case 
				when vcasetas.casetas_standings_id = 9
					then (select '100.00')
				else
					(select ((sum(float_data))/ ( ctrlfile._montos - (select sum(rsv.Monto_archivo) from sistemas.dbo.casetas_views as rsv where rsv.casetas_standings_id = '9' and rsv.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rsv.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rsv._filename = vcasetas._filename))) * 100)
			end as 'percent_montos',
			count(vcasetas.id) as 'cruces_totales',
			(select ( convert(float(2),count(vcasetas.id)) / convert(float(2),ctrlfile.cruces) ) * 100) as 'percent_cruces_old',
			--case 
			--	when vcasetas.casetas_standings_id = 9
			--		then (select '100.00')
			--	else
			--		(select ( convert(float(2),count(vcasetas.id)) / convert(float(2),( ctrlfile.cruces - (select rs.cruces_totales from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rs.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rs._filename = vcasetas._filename))) ) * 100)
			--end as 'percent_cruces',
			case 
				when vcasetas.casetas_standings_id = 9
					then (select '100.00')
				else
					(select ( convert(float(2),count(vcasetas.id)) / convert(float(2),( ctrlfile.cruces - (select count(rsv.id) from sistemas.dbo.casetas_views as rsv where rsv.casetas_standings_id = '9' and rsv.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rsv.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rsv._filename = vcasetas._filename))) ) * 100)
			end as 'percent_cruces',
			vcasetas._filename,
			vcasetas.cia,
			ctrlfile._montos,
			ctrlfile.cruces,
			--(select rs.monto_total from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rs.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rs._filename = vcasetas._filename) as 'new_montos',
			--(select rs.cruces_totales from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = vcasetas.casetas_historical_conciliations_id and rs.casetas_controls_files_id = vcasetas.casetas_controls_files_id and  rs._filename = vcasetas._filename) as 'new_cruces',
			vcasetas.casetas_standings_id
	from 
			sistemas.dbo.casetas_views as vcasetas
		inner join
			sistemas.dbo.casetas_standings as stand
		on	vcasetas.casetas_standings_id = stand.id
		left join 
			sistemas.dbo.casetas_controls_files as ctrlfile
		on
			vcasetas.casetas_controls_files_id = ctrlfile.id
			-- drop when useless
	--where vcasetas.casetas_historical_conciliations_id = '25'
	--		and vcasetas.casetas_controls_files_id = '21'
			--
	group by
		vcasetas.casetas_controls_files_id , vcasetas.casetas_historical_conciliations_id , vcasetas.casetas_standings_id,
		vcasetas.cia,vcasetas._filename,ctrlfile._montos,ctrlfile.cruces,stand.casetas_standings_name




--------------------- casetas_view_resumes

select
		ctrl.id, 
		--ctrl._montos ,
		--ctrl.cruces,
		(select ( ctrl._montos - (	select rs.monto_total from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = hist.id and rs.casetas_controls_files_id = ctrl.id and  rs._filename = ctrl._filename) )) as '_montos',
		(select (ctrl.cruces - ( select rs.cruces_totales from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = hist.id and rs.casetas_controls_files_id = ctrl.id and rs._filename = ctrl._filename))) as 'cruces',

		hist.monto_conciliado as 'monto_conciliado',
		hist.cruces_conciliados as 'cruces_conciliados',

		(select (hist.monto_conciliado/ctrl._montos) * 100) as 'percent_montos_old',
		(select ( convert(float(2),hist.cruces_conciliados) / convert(float(2),ctrl.cruces) ) * 100) as 'percent_cruces_old',

		(select (hist.monto_conciliado/ ( ctrl._montos - (	select rs.monto_total from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = hist.id and rs.casetas_controls_files_id = ctrl.id and  rs._filename = ctrl._filename) )) * 100) as 'percent_montos',
		
		(select ( convert(float(2),hist.cruces_conciliados) / convert(float(2),(ctrl.cruces - ( select rs.cruces_totales from sistemas.dbo.casetas_view_resume_stands as rs where rs.casetas_standings_id = '9' and rs.casetas_historical_conciliations_id = hist.id and rs.casetas_controls_files_id = ctrl.id and rs._filename = ctrl._filename))) ) * 100) as 'percent_cruces',
		
		conctrl.conciliations_count as 'counter',
		ctrl._filename,
		ctrl._area,
		ctrl.casetas_units_id,
		evnt.casetas_event_name,
		parent.casetas_parents_name,
		stand.casetas_standings_name,
		hist.id as 'historical_id',
		ctrl._ctime,
		ctrl.casetas_standings_id as 'fileStatId',
		ctrl.casetas_corporations_id as '_cia_id'
	from 
			sistemas.dbo.casetas_controls_files as ctrl
		inner join 
			sistemas.dbo.casetas_events as evnt
			on ctrl.casetas_events_id = evnt.id
		inner join
			sistemas.dbo.casetas_parents as parent
			on	ctrl.casetas_parents_id = parent.id
		inner join
			sistemas.dbo.casetas_standings as stand
			on ctrl.casetas_standings_id = stand.id
		inner join
			sistemas.dbo.casetas_controls_conciliations as conctrl
			on ctrl.id = conctrl.casetas_controls_files_id
		left join
			casetas_historical_conciliations as hist
			on conctrl.casetas_controls_files_id = hist.casetas_controls_files_id and hist.id = (select max(id) from sistemas.dbo.casetas_historical_conciliations as shist where shist.casetas_controls_files_id =  hist.casetas_controls_files_id)
		left join
			sistemas.dbo.casetas_views as _view
			on _view.casetas_controls_files_id = ctrl.id
	group by 
			ctrl._montos,ctrl.cruces,ctrl._filename,ctrl._area,ctrl.casetas_units_id,ctrl.id,
			evnt.casetas_event_name,parent.casetas_parents_name,stand.casetas_standings_name,
			conctrl.conciliations_count,hist.monto_conciliado,hist.cruces_conciliados,hist.id,
			ctrl._ctime,ctrl.casetas_standings_id,ctrl.casetas_corporations_id
	order by ctrl.id

------------------ build the manual conciliations section 

--use [sistemas]
--go
--IF OBJECT_ID('dbo.casetas_iave_periods', 'U') IS NOT NULL 
--  DROP TABLE dbo.casetas_iave_periods; 
--go
--set ansi_nulls on
--go
--set quoted_identifier on
--go
--set ansi_padding on
--go
 
--create table [dbo].[casetas_iave_periods](
--		id							int identity(1,1),
--		period_iave_id				int,
--		period						int,
--		user_id						int,
--		created						datetime,
--		_status						tinyint default 1 null
--) on [primary]
--go

--set ansi_padding off
--go



--select key_num_2 as 'iave_period',key_num_5 as 'toolboth_name',cast(float_data_1 as int) as 'iave_id',* from sistemas.dbo.casetas

--select key_num_5,cast(float_data_1 as int) as 'iave_id' from sistemas.dbo.casetas group by key_num_5,float_data_1


