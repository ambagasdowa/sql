
use sistemas;
IF OBJECT_ID ('mr_view_monitor_costos', 'V') IS NOT NULL
    DROP VIEW mr_view_monitor_costos;
GO

create view mr_view_monitor_costos
with encryption
as

	select 
			row_number() 
				over 
			(order by min) as 
			id,
			min,
			max,
			total,
			Real,
			Presupuesto,
			_company,
			_period,
			_key	
		from (
				select  
						MIN(id) as min , MAX(id) as max ,
						COUNT(id) as total, ROUND(sum(Cargo-Abono),2) as 'Real',
						ROUND(SUM(Presupuesto),2) as Presupuesto, _company,_period,_key
				from
						sistemas.dbo.mr_source_reports 
				--where 
				--		_period = '201604'
				--where	
				--		_company = 'TBKGDL' and SUBSTRING(_period,1,4) = '2016' and _key = 'MF'
				group by
						_company,_key,_period 
				--order by
				--		 _period,_key,_company

			) as Result 
go