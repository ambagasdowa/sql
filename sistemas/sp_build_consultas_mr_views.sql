use sistemas;


--GRANT EXECUTE ON OBJECT::HumanResources.uspUpdateEmployeeHireInfo
--    TO Recruiting11;
--GO

-- Create Connection for the view 

exec sp_addlinkedserver
@server = 'local',
@srvproduct = '',
@provider='SQLNCLI',
@datasrc = @@SERVERNAME
go

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Set the view for "Costos Operativos"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use integraapp;
go

IF OBJECT_ID ('fetchCostosAdministracionGstDin', 'V') IS NOT NULL
    DROP VIEW fetchCostosAdministracionGstDin;
GO

create view fetchCostosAdministracionGstDin
with encryption
as

select
			Mes, NoCta, NombreCta, PerEnt, Compañía, Tipo, Entidad, distinto, tipoTransacción, Referencia, FechaTransacción, Descripción, Abono, Cargo, UnidadNegocio, 
			CentroCosto, NombreEntidad, Presupuesto, SUBSTRING(_period, 1, 4) AS Año,_company,_period,_key
from openquery(local,'exec sistemas.dbo.sp_build_mr_dinamyc_view_accounts "2016","TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA","AD","|"')
go

--select * from fetchCostosAdministracionAtmDin

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Restore views for "Costos Operativos"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

use integraapp;
go

IF OBJECT_ID ('fetchCostosVariablesOpGdl', 'V') IS NOT NULL
    DROP VIEW fetchCostosVariablesOpGdl ;
GO

create view fetchCostosVariablesOpGdl
with encryption
as


	select
			Mes, NoCta, NombreCta, PerEnt, Compañía, Tipo, Entidad, distinto, tipoTransacción, Referencia, FechaTransacción, Descripción, Abono, Cargo, UnidadNegocio, 
			CentroCosto, NombreEntidad, Presupuesto, SUBSTRING(_period, 1, 4) AS Año
	from
		    sistemas.dbo.mr_source_reports
	where
			(_key = 'OV') AND (_company = 'TBKGDL')

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Set the view for Costos Operativos 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
exec sistemas.dbo.sp_build_mr_view_accounts "2016","TBKGDL","OF|OV|MF|MV","|"; -- ETA 00:19:22 ~ 00:15:46

exec sistemas.dbo.sp_build_mr_view_accounts "2016","TBKHER","OF|OV|MF|MV","|"; -- ETA 00:03:39

exec sistemas.dbo.sp_build_mr_view_accounts "2016","TBKLAP","OF|OV|MF|MV","|"; -- ETA 00:01:36

exec sistemas.dbo.sp_build_mr_view_accounts "201604","TBKORI","OF|OV|MF|MV","|"; -- ETA 00:18:32

exec sistemas.dbo.sp_build_mr_view_accounts "201604","TBKRAM","OF|OV|MF|MV","|"; -- ETA 00:20:41

exec sistemas.dbo.sp_build_mr_view_accounts "2016","TBKTIJ","OF|OV|MF|MV","|"; -- ETA 00:04:33

exec sistemas.dbo.sp_build_mr_view_accounts "2016","ATMMAC","OF|OV|MF|MV","|"; -- ETA 00:00:21

exec sistemas.dbo.sp_build_mr_view_accounts "201604","TEICUA","OF|OV|MF|MV","|"; -- ETA 00:01:21

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Set the view for Operativos Fijos
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
exec sistemas.dbo.sp_build_mr_view_accounts "201604","TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA","OF","|"  -- by year ETA 00:12:34 ~ by period 00:02:48

exec sistemas.dbo.sp_build_mr_view_accounts "201604","TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA","OV","|"  -- by year ETA 00:23:39 ~ by period 00:05:10

exec sistemas.dbo.sp_build_mr_view_accounts "201604","TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA","MF","|"  -- by year ETA 00:00:00 ~ by period 00:00:18

exec sistemas.dbo.sp_build_mr_view_accounts "201604","TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA","MV","|"  -- by year ETA 00:00:00 ~ by period 00:05:33
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




exec sistemas.dbo.sp_build_mr_view_accounts "201608","TBKRAM","MV","|"; -- ETA 00:04:44 ~ 00:03:41

exec sistemas.dbo.sp_build_mr_view_accounts "201605","TBKGDL","OF","|"; -- ETA 00:08:49

exec sistemas.dbo.sp_build_mr_view_accounts "2016","TBKGDL","MF","|"; -- ETA 00:00:43

exec sistemas.dbo.sp_build_mr_view_accounts "201604","TEICUA","OF","|"; -- ETA 00:08:14


select * from sistemas.dbo.mr_source_reports where _company = 'ATMMAC' and _key='OV' and _period = '201604' and NoCta='0501160200'

select * from integraapp.dbo.GLTran where CpnyID = 'ATMMAC' and Acct = '0501160200' and Sub = '0000000BWTT2170TT2170' and PerPost = '201604' and Posted = 'P'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- lists activity for all jobs that the current user has permission to view.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		USE msdb ;
		GO
		EXEC dbo.sp_help_jobactivity ;
		GO

		use sistemas;
		go
		IF OBJECT_ID ('view_sp_watch_jobs', 'V') IS NOT NULL
			DROP VIEW view_sp_watch_jobs;
		GO
		create view view_sp_watch_jobs
			with encryption as
			select 
			*
			from openquery(local,'msdb.dbo.sp_help_jobactivity')

			go	

-- Going to source msdb
		use sistemas;
		go
		if OBJECT_ID('view_sp_watch_jobs_monitors','V') is not null
			drop view view_sp_watch_jobs_monitors;
		go
		create view view_sp_watch_jobs_monitors
			with encryption as 

		select
			row_number()
		over 
			(order by JobName) as 
							id,
							JobName,
							StartLastUpdate,
							AvaliableUpdate,
							NextUpdate,
							_status,
							ETA
			from
			(
					select
							j.name as 'JobName',
							--job_name as 'JobName',
							run_requested_date as 'StartLastUpdate',
							stop_execution_date as 'AvaliableUpdate',
							next_scheduled_run_date as 'NextUpdate',
							ISNULL(run_status,0) as '_status',
							(convert(varchar(25),datepart(mi,(stop_execution_date - run_requested_date))) +' mins,'+convert(varchar(25),datepart(ss,(stop_execution_date - run_requested_date))) + ' secs') as 'ETA'
					from 
							--sistemas.dbo.view_sp_watch_jobs 
							(msdb.dbo.sysjobactivity ja LEFT JOIN msdb.dbo.sysjobhistory jh ON ja.job_history_id = jh.instance_id)
							join msdb.dbo.sysjobs_view j on ja.job_id = j.job_id
					where
							 j.name like 'mr_%'
			) as Result
		go


------------------------
--nomina
declare @name as varchar(255);
set @name = 'jesus alberto';

select * from NOM2001.dbo.nomtrab where status = 'F' and nombre like '%'+ @name +'%'

select * from NOM2001.dbo.nomtrab where status = 'A' and nombre like '%'+ @name +'%'

select * from NOM2001.dbo.nomtrab where status = 'B' and nombre like '%'+ @name +'%'
------------------------

		use sistemas;
		select * from 
		--truncate table 
		sistemas.dbo.casetas

		select * from view_sp_watch_jobs_monitors where _status = '1'
		
		select * from sistemas.dbo.mr_view_monitor_costos 
				where _period = '201608' and _company in ('TBKGDL','TBKLAP','TBKHER','TBKORI','TBKRAM','TBKTIJ','ATMMAC','TEISA') and _key = 'MV'
				order by _company,_key




		select * from NOM2001.dbo.getPayroll where cvetra in ('3002061','2000433')

		select * from NOM2001.dbo.view_get_payrolls where Cvetra in ('3002061','2000433')

		select * from NOM2001.dbo.view_get_payrolls where Nombre like 'luis%'

		select * from NOM2001.dbo.getPayroll where apepat like '%castillo%'


		select * from NOM2001.dbo.nomcias

		select * from NOM2001.dbo.nomarea

		select * from NOM2001.dbo.nomtrab

		select * from NOM2001.dbo.nompues

		select * from NOM2001.dbo.nomsuel where cvetra = '4000015'
		select * from NOM2001.dbo.nomsuel where cvetra = '4000014'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- lists activity for all jobs that the current user has permission to view.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


use sistemas;
select 
		MIN(id) as min , MAX(id) as max , 
		COUNT(id) as total, sum(Cargo-Abono) as 'Real',
		SUM(Presupuesto) as Presupuesto, _company,_period,_key  
from 
		sistemas.dbo.mr_source_reports_temps group by _company,_key,_period order by _period,_key,_company;
select 
		MIN(id) as min , MAX(id) as max ,
		COUNT(id) as total, ROUND(sum(Cargo-Abono),2) as 'Real',
		SUM(Presupuesto) as Presupuesto, _company,_period,_key
from
		 sistemas.dbo.mr_source_reports_backups group by _company,_key,_period order by _period,_key,_company;





select * from sistemas.dbo.mr_source_mains

select * from sistemas.dbo.mr_source_deployment_accounts where account = '0501151200';

select * from mr_source_main_accounts_dinamycs_temps where account = '0501151200' and unit = 'AQ'

select * from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where substring(period,1,4) = '2016' and account = '0501151200' and company = 'TBKRAM' and unit='AQ' and segment = '8000000' and cost_center = '00' order by period


select * from sistemas.dbo.mr_source_reports_temps

select * from sistemas.dbo.mr_source_reports_backups


--fetchCostosVariablesOpLaPaz

SELECT     Mes, NoCta, NombreCta, PerEnt, Compañía, Tipo, Entidad, distinto, tipoTransacción, Referencia, FechaTransacción, Descripción, Abono, Cargo, UnidadNegocio, 
           CentroCosto, NombreEntidad, Presupuesto, SUBSTRING(_period, 1, 4) AS Año
FROM       sistemas.dbo.mr_source_reports
WHERE      (_key = 'OV') AND (_company = 'TBKLAP')

--fetchCostosVariablesOpLaPaz


 select * from sistemas.dbo.buildViewCostos


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE add selection of the period from given year or years
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	declare @period as nvarchar(4000),@Delimiter as nvarchar(1), @period_build as nvarchar(6) ;
	
	declare @today as int;

	--set @period = '2015|201605|201604|2017';
	--set @period = '201604';

	set @period = '20160'


	set @Delimiter = '|';

	-- build the table containing the periods
	declare @config_period table  -- this is the table 
	(
		config_period	varchar(6) collate SQL_Latin1_General_CP1_CI_AS
	)
	-- create the periods
	declare @MonthsTranslation table
							  (
								monthNumber varchar(2),
								monthName varchar(20)
							  );
	insert into @MonthsTranslation
			select '01', 'Enero'
			union select '02', 'Febrero'
			union select '03', 'Marzo'
			union select '04', 'Abril'
			union select '05', 'Mayo'
			union select '06', 'Junio'
			union select '07', 'Julio'
			union select '08', 'Agosto'
			union select '09', 'Septiembre'
			union select '10', 'Octubre'
			union select '11', 'Noviembre'
			union select '12', 'Diciembre'
	--select * from @MonthsTranslation
	declare year_cursor cursor for 
							(
								select item from integraapp.dbo.fnSplit(@period, @Delimiter)
							)


			open year_cursor;
				fetch next from year_cursor into @period_build;
						while @@fetch_status = 0
							begin
								print len(@period_build);
								if LEN(@period_build) = 4
									begin
										insert into @config_period
											select 
													@period_build + monthNumber 
											from 
													@MonthsTranslation  
											where 
													(@period_build + monthNumber) <= (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + (select right('00'+convert(varchar(2),MONTH(current_timestamp)), 2)) )
										
									end
								else if LEN(@period_build) = 6
									begin
										insert into @config_period
											select @period_build
									end
								else if LEN(@period_build) = 5
									begin
										set @today =  DAY(CURRENT_TIMESTAMP);
										if @today > 1 and @today < 15 
											begin
												if MONTH(CURRENT_TIMESTAMP) = 1
													begin
														insert into @config_period
													
															select(CONVERT(nvarchar(4), YEAR(DATEADD(YEAR,-1,CURRENT_TIMESTAMP))) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -1, current_timestamp))), 2)) 
														union all
															select(CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(current_timestamp)), 2) )
																		
													end
												else
													begin
														insert into @config_period
															select 
																	(SUBSTRING(@period_build,1,4)) + monthNumber 
															from 
																	@MonthsTranslation  
															where 
																	(SUBSTRING(@period_build,1,4) + monthNumber) in (
																										 (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -1, current_timestamp))), 2)) 
																									 --,
																										-- (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(current_timestamp)), 2) )
																									 ) 
													end
											end
										else
											begin
												insert into @config_period
													select 
															(SUBSTRING(@period_build,1,4)) + monthNumber 
													from 
															@MonthsTranslation  
													where 
															(SUBSTRING(@period_build,1,4) + monthNumber) = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(current_timestamp)), 2) )
											end
									end
							fetch next from year_cursor into @period_build;
							end
			close year_cursor;
		deallocate year_cursor;
	select * from @config_period
go

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE add selection of the period from given year or years
------------------------------------------------------------------------------------------------------------------------------------------------------------
	
SET LANGUAGE Spanish
SET LANGUAGE English

SELECT DATENAME(mm, '2016-02-01')

SELECT DATEADD(month, -1, '2016-01-30');


	select CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -1, current_timestamp))), 2) as Mes

	select CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(current_timestamp)), 2) as Mes

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE check the segment of the Company as 00
------------------------------------------------------------------------------------------------------------------------------------------------------------
	use integraapp;
	select 
			Acct,Sub,ROUND(sum(CuryCrAmt * CuryRate),2) as Abono, ROUND(sum(CuryDrAmt * CuryRate),2) as Cargo,CpnyID ,User1
	--		*
	from 
			integraapp.dbo.GLTran 
	where
			CpnyID = 'TEICUA'
				and PerPost = '201604'
				and substring(Sub,8,2) = '00'
				--and substring(Sub,8,2) = '000000000000000000000' 
				and TranType <> 'R'
				and LedgerID = 'REAL'
				and Posted = 'P'
				and Acct in ( select account from sistemas.dbo.mr_source_deployment_accounts where _key = 'OV' and _status = '1' )
	group by
			Acct,User1,Sub,CpnyID

go

	use integraapp;
	select 
			*
	from 
			integraapp.dbo.GLTran 
	where
			CpnyID = 'TEICUA'
				and PerPost = '201604'
				and substring(Sub,8,2) = '00'
				--and substring(Sub,8,2) = '000000000000000000000' 
				and LedgerID = 'REAL'
				and Posted = 'P'
				and Acct in ( select account from sistemas.dbo.mr_source_deployment_accounts where _key = 'OV' and _status = '1' )
go









--000000000000000000000   	0501140300	1900-01-01 00:00:00	A	MN  	217638    	TEICUA    	0	2016-04-26 11:48:00	03400   	DOLORES.PE	0	500	1900-01-01 00:00:00	MN  	M	1	      	500
--000000000000000000000   	0501140300	1900-01-01 00:00:00	A	MN  	217641    	TEICUA    	0	2016-04-26 11:53:00	03400   	DOLORES.PE	0	790.01	1900-01-01 00:00:00	MN  	M	1	      	790.01
	go
