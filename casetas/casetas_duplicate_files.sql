use sistemas;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- when upload a file the system create a record in casetas_controls_files and in casetas_controls_conciliations
-- when the conciliation process is execute the systems creates records in dbo.casetas_historical_conciliations and dbo.casetas_views
-- so you must search by casetas_controls_files_id in all this tables
-- this is until md5 file checksum is in develop
-- you can track files with diferent names by is md5 sum at _md5sum in casetas_controls_files
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

declare @file as nvarchar(255);

-- the name of the file ??
set @file =  '382i'
-- resume 
select
		ctrl.id, 
		ctrl._montos ,
		ctrl.cruces,
		hist.monto_conciliado as 'monto_conciliado',
		hist.cruces_conciliados as 'cruces_conciliados',
		(select (hist.monto_conciliado/ctrl._montos) * 100) as 'percent_montos',
		(select ( convert(float(2),hist.cruces_conciliados) / convert(float(2),ctrl.cruces) ) * 100) as 'percent_cruces',
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
		where 
			ctrl._filename = @file
	group by 
			ctrl._montos,ctrl.cruces,ctrl._filename,ctrl._area,ctrl.casetas_units_id,ctrl.id,
			evnt.casetas_event_name,parent.casetas_parents_name,stand.casetas_standings_name,
			conctrl.conciliations_count,hist.monto_conciliado,hist.cruces_conciliados,hist.id,
			ctrl._ctime,ctrl.casetas_standings_id,ctrl.casetas_corporations_id

------------- Have conciliations -----------------------
-- resume by stand
select 
			vcasetas.casetas_controls_files_id ,vcasetas.casetas_historical_conciliations_id,
			stand.casetas_standings_name,
			sum(vcasetas.float_data) as 'monto_total',
			(select ((sum(float_data))/ctrlfile._montos) * 100) as 'percent_montos',
			count(vcasetas.id) as 'cruces_totales',
			(select ( convert(float(2),count(vcasetas.id)) / convert(float(2),ctrlfile.cruces) ) * 100) as 'percent_cruces',
			vcasetas._filename,
			vcasetas.cia,
			ctrlfile._montos,
			ctrlfile.cruces,
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
			
	where 
		vcasetas._filename = @file
	group by
		vcasetas.casetas_controls_files_id , vcasetas.casetas_historical_conciliations_id , vcasetas.casetas_standings_id,
		vcasetas.cia,vcasetas._filename,ctrlfile._montos,ctrlfile.cruces,stand.casetas_standings_name
 


 --select * from 
	---- delete
	--casetas_controls_files where id in ('43','44','45')

 --select * from 
	---- delete 
	--dbo.casetas_controls_conciliations where casetas_controls_files_id in ('43','44','45')

 --select * from dbo.casetas_historical_conciliations where casetas_controls_files_id in ('43','44','45')

 --select * from dbo.casetas_views where casetas_controls_files_id in ('43','44','45')



 --select * from casetas_controls_files where id in ('46')

 --select * from dbo.casetas_controls_conciliations where casetas_controls_files_id in ('46')

 -- select * from dbo.casetas_historical_conciliations where casetas_controls_files_id in ('46')

 --  select * from dbo.casetas_views  where casetas_controls_files_id in ('46')