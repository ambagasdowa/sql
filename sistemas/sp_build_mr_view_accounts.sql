USE [sistemas]
GO
/****** Object:  UserDefinedFunction [dbo].[sp_build_mr_view_accounts]    Script Date: 04/29/2016 01:36:17 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : Build and set the Records Accounts for view of MR app
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ===============================================================================*/
 
ALTER PROCEDURE [dbo].[sp_build_mr_view_accounts]
 (
	@period nvarchar(4000), -- this is ok
	@bunit nvarchar(4000),
	@_key nvarchar(4000),
	@Delimiter varchar(1) -- use pipeline
 )
 with encryption
 as 
-----------------------------------------------------------------------------------------------------------
--	           	                     build the request data                                              --
-----------------------------------------------------------------------------------------------------------
-- Declare @period varchar(8000) , @Delimiter varchar(1) , @bunit varchar(4000) ,@_key varchar(4000);
SET NOCOUNT ON; -- enable vba Excel access
SET FMTONLY OFF;
--select @period = '201604';
--select @Delimiter = '|';
--select @bunit = 'TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ';
--select @_key = 'OF'

	declare @config_bunit table 
	(
		config_bunit	varchar(6) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into @config_bunit select item from integraapp.dbo.fnSplit(@bunit, @Delimiter)
--	select * from  @config_bunit

	--declare @config_period table 
	--(
	--	config_period	varchar(6) collate SQL_Latin1_General_CP1_CI_AS
	--)
	--insert into @config_period select item from integraapp.dbo.fnSplit(@period, @Delimiter)
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE add selection of the period from given year or years
------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- build the table containing the periods
	declare @period_build as nvarchar(6),@today as int ;
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
												if MONTH(CURRENT_TIMESTAMP) = 1 -- Special Case NOTE in January of 2017
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
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE add selection of the period from given year or years
------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @config_key table 
	(
		config_key	varchar(2) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into @config_key select item from integraapp.dbo.fnSplit(@_key, @Delimiter)
	--select * from  @config_key
  --call to table and save as table var 
	declare @storeTransaction table(
			Mes					nvarchar (25) collate SQL_Latin1_General_CP1_CI_AS,
			NoCta				nvarchar (25) collate SQL_Latin1_General_CP1_CI_AS,
			NombreCta			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS,
			PerEnt				nvarchar(255)  collate SQL_Latin1_General_CP1_CI_AS,
			Compañía			nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			Tipo				nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			Entidad				nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			distinto			nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			tipoTransacción		nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			Referencia			nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			FechaTransacción	nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			Descripción			nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			Abono				nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			Cargo				nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			UnidadNegocio		nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			CentroCosto			nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			NombreEntidad		nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			_company			nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			_period				nvarchar(255) collate SQL_Latin1_General_CP1_CI_AS,
			_key				nvarchar (255)  collate SQL_Latin1_General_CP1_CI_AS,
			Presupuesto			float(2)
			--_source_company		nvarchar(255) collate SQL_Latin1_General_CP1_CI_AS
	  );


------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE add selection of the period from given year or years
------------------------------------------------------------------------------------------------------------------------------------------------------------
  	declare @period_source varchar(6);

	declare period_cursor cursor for 
									(
										select config_period from @config_period
									)
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE search and destroy records
------------------------------------------------------------------------------------------------------------------------------------------------------------
	delete from
			 sistemas.dbo.mr_source_reports_temps
	where 
				_period in (select config_period from @config_period)
			and 
				_company in (select config_bunit from @config_bunit )
			and 
				_key in (select config_key from @config_key )
------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- in the beggining this was formely the function dbo.getRealPresupuesto but now this is part of itself
	----------------------------------------------------------------------------------------------------------------------------------------------------------
	-- get The presupuesto
	----------------------------------------------------------------------------------------------------------------------------------------------------------
			open period_cursor;
				fetch next from period_cursor into @period_source;
						while @@fetch_status = 0
							begin
								--print @period_source
								insert into @storeTransaction
									select 
											(select 
												case substring(@period_source,5,2)
													when '01' then 'Enero'
													when '02' then 'Febrero'
													when '03' then 'Marzo'
													when '04' then 'Abril'
													when '05' then 'Mayo'
													when '06' then 'Junio'
													when '07' then 'Julio'
													when '08' then 'Agosto'
													when '09' then 'Septiembre'
													when '10' then 'Octubre'
													when '11' then 'Noviembre'
													when '12' then 'Diciembre'
													else 'other'
											 end as 'Mes'
											 ) as 'Mes',
										presupuesto.Acct as 'NoCta'
										,cuenta.Descr AS NombreCta
										,'' as 'PerEnt'
										,CpnyID as Compañia
										,'' as 'Tipo'
										,presupuesto.Sub as 'Entidad'
										,'' as 'distinto'
										,'' as 'TipoTransacción'
										,'' as 'Referencia'
										,'' as FechaTransacción
										,'' as Descripción
										,'0' as Abono
										,'0' as Cargo
										,substring(presupuesto.Sub,8,2) as UnidadNegocio
										,substring(presupuesto.Sub,10,6) as CentroCosto
										,subcuenta.Descr as NombreEntidad
										,presupuesto._source_company as _company
										,@period_source as _period
										,presupuesto._key as _key
										--,presupuesto._source_company as _source_company
										,CASE @period_source
											WHEN substring(@period_source,1,4) + '01' 
												THEN presupuesto.PtdBal00 
											WHEN substring(@period_source,1,4) + '02' 
												THEN presupuesto.PtdBal01 
											WHEN substring(@period_source,1,4) + '03' 
												THEN presupuesto.PtdBal02
											WHEN substring(@period_source,1,4) + '04' 
												THEN presupuesto.PtdBal03
											WHEN substring(@period_source,1,4) + '05' 
												THEN presupuesto.PtdBal04
											WHEN substring(@period_source,1,4) + '06' 
												THEN presupuesto.PtdBal05
											WHEN substring(@period_source,1,4) + '07' 
												THEN presupuesto.PtdBal06 
											WHEN substring(@period_source,1,4) + '08' 
												THEN presupuesto.PtdBal07
											WHEN substring(@period_source,1,4) + '09' 
												THEN presupuesto.PtdBal08
											WHEN substring(@period_source,1,4) + '10' 
												THEN presupuesto.PtdBal09
											WHEN substring(@period_source,1,4) + '11' 
												THEN presupuesto.PtdBal10
											WHEN substring(@period_source,1,4) + '12' 
												THEN presupuesto.PtdBal11
											ELSE '0' 
										END AS 'Presupuesto'
									from sistemas.dbo.mr_source_presupuestos_temps as presupuesto
											inner join integraapp.dbo.Account as cuenta
												on substring(presupuesto.Acct,1,10) = cuenta.Acct
													-- and '5E' = cuenta.AcctType
											inner join integraapp.dbo.SubAcct as subcuenta
												on substring(presupuesto.Sub,1,21) = SUBSTRING(subcuenta.Sub,1,21)
									where presupuesto._source_company in (select config_bunit from @config_bunit )	--@empresa 'ATMMAC'
										and presupuesto.FiscYr = substring(@period_source,1,4)
										and presupuesto._key in (select config_key from @config_key )
								fetch next from period_cursor into @period_source;
							end
			close period_cursor;
		deallocate period_cursor;

	----------------------------------------------------------------------------------------------------------------------------------------------------------
	-- build the setrecords
	----------------------------------------------------------------------------------------------------------------------------------------------------------
	insert into sistemas.dbo.mr_source_reports_temps
							select 
									(select 
										case substring(isnull(integraapp.dbo.GLTran.PerPost,source_table.period),5,2)
											when '01' then 'Enero'
											when '02' then 'Febrero'
											when '03' then 'Marzo'
											when '04' then 'Abril'
											when '05' then 'Mayo'
											when '06' then 'Junio'
											when '07' then 'Julio'
											when '08' then 'Agosto'
											when '09' then 'Septiembre'
											when '10' then 'Octubre'
											when '11' then 'Noviembre'
											when '12' then 'Diciembre'
											else 'other'
									 end as 'Mes'
									 ) as 'Mes'
									,substring(source_table.SubAccount,1,10) as NoCta
									,integraapp.dbo.Account.Descr AS NombreCta
									,(select ISNULL(integraapp.dbo.GLTran.PerEnt,source_table.period)) as 'PerEnt'
									,(select ISNULL(integraapp.dbo.GLTran.CpnyID,source_table.company)) AS Compañía
									,integraapp.dbo.GLTran.JrnlType AS Tipo
									--,ISNULL(integraapp.dbo.GLTran.Sub,substring(source_table.SubAccount,11,21)) AS Entidad
									,ISNULL(integraapp.dbo.GLTran.Sub,substring(integraapp.dbo.SubAcct.Sub,1,21)) AS Entidad
									,substring(integraapp.dbo.GLTran.Sub,1,11) AS 'distinto'
									,integraapp.dbo.GLTran.TranType AS TipoTransacción
									,integraapp.dbo.GLTran.RefNbr AS Referencia
									--,dbo.GLTran.ExtRefNbr AS RefExterna
									,integraapp.dbo.GLTran.ExtRefNbr AS FechaTransacción
									--,integraapp.dbo.GLTran.TranDate AS FechaTransacción
									,integraapp.dbo.GLTran.TranDesc AS Descripción
									,ISNULL(integraapp.dbo.GLTran.CuryCrAmt * integraapp.dbo.GLTran.CuryRate,0.0)as Abono
									--,integraapp.dbo.GLTran.CuryCrAmt * integraapp.dbo.GLTran.CuryRate as Abono
									,ISNULL(integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate,0.0) AS Cargo
									--,integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate AS Cargo
									,ISNULL(SUBSTRING(integraapp.dbo.GLTran.Sub, 8, 2),substring(source_table.SubAccount, 18, 2)) AS UnidadNegocio
									,ISNULL(SUBSTRING(integraapp.dbo.GLTran.Sub, 10, 6),substring(source_table.SubAccount, 20, 6)) AS CentroCosto 
									,integraapp.dbo.SubAcct.Descr AS NombreEntidad
									,source_table.source_company as _company
									,source_table.period as _period
									,source_table._key as _key
									,(select 0) as 'Presupuesto'
									--,source_table.source_company as _source_company

							from sistemas.dbo.mr_source_configs_temps as source_table
							--from @source_table as source_table
							--from @deploy_accounts as source_table
	
								inner join integraapp.dbo.Account
									on substring(source_table.SubAccount,1,10) = integraapp.dbo.Account.Acct
										--and '5E' = integraapp.dbo.Account.AcctType

								inner join integraapp.dbo.SubAcct
									--on substring(source_table.SubAccount,11,21) = integraapp.dbo.SubAcct.Sub 
									on substring(source_table.SubAccount,11,15) = SUBSTRING(integraapp.dbo.SubAcct.Sub,1,15)
									---------------------------------------------------------------------------------------------
									-- on substring(source_table.SubAccount,11,7) = SUBSTRING(integraapp.dbo.SubAcct.Sub,1,7)
										--and
										--	substring(source_table.SubAccount,18,2) = SUBSTRING(integraapp.dbo.SubAcct.Sub,8,2)
										--and 
										--	substring(source_table.SubAccount,20,5) = SUBSTRING(integraapp.dbo.SubAcct.Sub,10,5) -- maybe can change to 6 and improve performance
										---------------------------------------------------------------------
											--substring(source_table.SubAccount,20,2) = SUBSTRING(integraapp.dbo.SubAcct.Sub,10,2) -- original string
									---------------------------------------------------------------------------------------------
								inner join integraapp.dbo.GLTran
									on substring(source_table.SubAccount,1,10) = integraapp.dbo.GLTran.Acct
										and source_table.company = integraapp.dbo.GLTran.CpnyID
										and source_table.period = integraapp.dbo.GLTran.PerPost
										/** MOD */
										and 
											substring(integraapp.dbo.SubAcct.Sub,1,21) = SUBSTRING(integraapp.dbo.GLTran.Sub,1,21)
										--and substring(source_table.SubAccount,11,15) = SUBSTRING(integraapp.dbo.GLTran.Sub,1,15)
										--0501040400 0000000AIRD1148
										-- and substring(source_table.SubAccount,17,4) = SUBSTRING(integraapp.dbo.GLTran.Sub,7,4)
										-- and substring(source_table.SubAccount,22,4) between 1000 and 9999
										/** MOD */
										and
											 'P' = integraapp.dbo.GLTran.Posted
										and 
											integraapp.dbo.GLTran.LedgerID = 'REAL'
										-- and not
										--	( integraapp.dbo.GLTran.CuryCrAmt * integraapp.dbo.GLTran.CuryRate is null AND integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate is null )
										and 
											( integraapp.dbo.GLTran.Sub is not null and integraapp.dbo.GLTran.Acct is not null )
										--and 
											--integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate is not null
	
							where 
								-- source_table.period in (select item from integraapp.dbo.fnSplit(@period, @Delimiter) )
									source_table.period in (select config_period from @config_period)
								-- and source_table.source_company in (select item from integraapp.dbo.fnSplit(@bunit, @Delimiter) )
								and 
									source_table.source_company in (select config_bunit from @config_bunit )
								-- and source_table._key in (select item from integraapp.dbo.fnSplit(@_key, @Delimiter) )
								and 
									source_table._key in (select config_key from @config_key )
								and
									(
											(integraapp.dbo.GLTran.CuryCrAmt * integraapp.dbo.GLTran.CuryRate ) <> 0
										OR
											(integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate) <> 0
									)
							------------------------------------------------------------------------------------------------------------------------------------------------------------
							union all   -- ----------- Add Presupuesto ----------------------
							------------------------------------------------------------------------------------------------------------------------------------------------------------
								select
									Mes,
									NoCta,
									NombreCta,
									PerEnt,
									Compañía,
									Tipo,
									Entidad,
									distinto,
									tipoTransacción,
									Referencia,
									FechaTransacción,
									Descripción,
									Abono,
									Cargo,
									UnidadNegocio,
									CentroCosto,
									NombreEntidad,
									_company,
									_period,
									_key,
									Presupuesto
						--			_source_company
								from @storeTransaction;

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE search and destroy records in reports table
------------------------------------------------------------------------------------------------------------------------------------------------------------

if @@rowcount = (
					select 
						COUNT(id) from sistemas.dbo.mr_source_reports_temps 
					where
						_period in (select config_period from @config_period)
					and 
						_company in (select config_bunit from @config_bunit )
					and 
						_key in (select config_key from @config_key )
				)
begin

--print @@rowcount;

	delete from
			 sistemas.dbo.mr_source_reports
	where 
				_period in (select config_period from @config_period)
			and 
				_company in (select config_bunit from @config_bunit )
			and 
				_key in (select config_key from @config_key );
				
	insert into sistemas.dbo.mr_source_reports
								select
											Mes,
											NoCta,
											NombreCta,
											PerEnt,
											Compañía,
											Tipo,
											Entidad,
											distinto,
											tipoTransacción,
											Referencia,
											FechaTransacción,
											Descripción,
											Abono,
											Cargo,
											UnidadNegocio,
											CentroCosto,
											NombreEntidad,
											_company,
											_period,
											_key,
											Presupuesto
								from
											sistemas.dbo.mr_source_reports_temps
								where 
											_period in (select config_period from @config_period)
										and 
											_company in (select config_bunit from @config_bunit )
										and 
											_key in (select config_key from @config_key );
end
				
						
go


-- select * from sistemas.dbo.mr_source_presupuestos_temps

exec sistemas.dbo.sp_build_mr_view_accounts
 
	'2016',								-- define the period or periods
	'TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA',	-- define the companies
	'OF',														-- define the type of cost
	'|'															-- most common are pipeline
 go


 exec sistemas.dbo.sp_build_mr_view_accounts
 
	'2016',								-- define the period or periods
	'TEICUA',	-- define the companies
	'OF',														-- define the type of cost
	'|'															-- most common are pipeline
 go



