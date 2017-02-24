USE [sistemas]
GO
/****** Object:  UserDefinedFunction [dbo].[sp_build_mr_dinamycs_periods_accounts]    Script Date: 04/29/2016 01:36:17 p.m. ******/
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
 
ALTER PROCEDURE [dbo].[sp_build_mr_dinamycs_periods_accounts]
 (
	@period nvarchar(4000),
	@_key nvarchar(4000),
	@truncate_table as int,
	@daylimit as int,
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
	insert into @config_period exec sistemas.dbo.sp_builder_mr_periods_accounts @period,@daylimit,@Delimiter;
	-- Set the table for keys
	declare @config_key table 
	(
		config_key	varchar(2) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into @config_key select item from integraapp.dbo.fnSplit(@_key, @Delimiter)

	set @recordsFound = (select  COUNT(period) from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where period in (select config_period from @config_period) )

	if @truncate_table = 1
	begin
			truncate table sistemas.dbo.mr_source_periods_accounts_dinamycs_temps
	end
	else
		if @recordsFound > 0 
			begin
				delete from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where period in (select config_period from @config_period)
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
								insert into sistemas.dbo.mr_source_periods_accounts_dinamycs_temps
										select 
												
												account,segment,unit,cost_center,
												(select @period_variable) as 'period',
												company,source_company,
												_key,_status
										from 
												sistemas.dbo.mr_source_main_accounts_dinamycs_temps

								fetch next from period_cursor into @period_variable;
							end
			close period_cursor;
		deallocate period_cursor;
												
go

-- exec dbo.sp_build_mr_dinamycs_periods_accounts '2016|2017', 'OF|OV|MF|MV',	1,	6,	'|'
-- select count(account),period,company,source_company,_key from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where substring(period,1,4) = '2016' group by period,company,source_company,_key,account order by period

-- select * from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps