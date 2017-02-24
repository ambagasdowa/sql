USE [sistemas]
GO
/****** Object:  UserDefinedFunction [dbo].[sp_build_mr_periods_accounts]    Script Date: 04/29/2016 01:36:17 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : Build and set the Periods for build Accounts and Presupuesto of MR app
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ===============================================================================*/
 
ALTER PROCEDURE [dbo].[sp_build_mr_periods_accounts]
 (
	@period nvarchar(4000),
	@_key nvarchar(4000),
	@truncate_table as int,
	@Delimiter nvarchar(1)
 )
 with encryption
 as 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- SET the Periods 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Declare  @recordsFound as int;

--set @truncate_table = 1;

	-- Set the table for periods
	declare @config_period table 
	(
		config_period	varchar(6) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into @config_period select item from integraapp.dbo.fnSplit(@period, @Delimiter)
	-- Set the table for keys
	declare @config_key table 
	(
		config_key	varchar(2) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into @config_key select item from integraapp.dbo.fnSplit(@_key, @Delimiter)

	set @recordsFound = (select  COUNT(period) from sistemas.dbo.mr_source_configs_temps where period in (select config_period from @config_period) )

	if @truncate_table = 1
	begin
			truncate table sistemas.dbo.mr_source_configs_temps
	end
	else
		if @recordsFound > 0 
			begin
				delete from sistemas.dbo.mr_source_configs_temps where period in (select config_period from @config_period)
			end
			-- NOW go to insert the new data	
		declare @period_variable nvarchar(6);
		declare period_cursor cursor for 
										(
											select config_period from @config_period
										)
			open period_cursor;
				fetch next from period_cursor into @period_variable;
						while @@fetch_status = 0
							begin
								insert into sistemas.dbo.mr_source_configs_temps
										select 
												(select @period_variable) as 'period',
												SubAccount,company,source_company,
												_key,_status
										from 
												sistemas.dbo.mr_source_accounts_temps 

								fetch next from period_cursor into @period_variable;
							end
			close period_cursor;
		deallocate period_cursor;
												
go


						
exec sistemas.dbo.sp_build_mr_periods_accounts
 
	'201604|201605',			-- period ?
	'MV',						-- affected key
	0,							-- truncate table 1 on 0 off , truncate the table sistemas.dbo.mr_source_configs_temps 
	'|'							-- set the delimiter to use 

 -- ETA 00:00:05

--	start    end      count
-- 7546379	7735546	189168	201604	TBKORI	OV
-- 7735547	7927927	192381	201604	TBKRAM	OV
	select
			MIN(id) as 'begin' ,MAX(id) as 'end' , COUNT (id) as 'count'
			,period,source_company,_key
	from 
			sistemas.dbo.mr_source_configs_temps
	group by 
			period,source_company,_key
	order by period,_key

	select * from sistemas.dbo.mr_source_configs_temps where period = '201604' and SubAccount like '05011603018000000AATT132%'

	select * from integraapp.dbo.SubAcct where Sub like '8000000AATT132%'

	select * from sistemas.dbo.mr_source_presupuestos_temps where _source_company = 'TEICUA' and _key = 'OF' and FiscYr = '2016'

	select 
					Acct,Sub,CpnyID,[PtdBal00],[PtdBal01],[PtdBal02],
					[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],[PtdBal07],
					[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],
					FiscYr
	from 
					integraapp.dbo.AcctHist 
	where 
				--	Acct = 0501030103
				--and 
					FiscYr = '2016'
				and 
					LedgerID = 'PRESUP' + FiscYr 
				and 
					CpnyID = 'TEICUA'
				--and 
				--	substring(Sub,1,15) = substring(@inner_account,11,15);


	select distinct idbase,*
	from [integraapp].[dbo].[xrefcia]

	select [cpnyid]
	from [integraapp].[dbo].[frl_entity]
