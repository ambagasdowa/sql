USE [sistemas]
GO
/****** Object:  UserDefinedFunction [dbo].[sp_build_mr_period_accounts]    Script Date: 04/29/2016 01:36:17 p.m. ******/
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
 
ALTER PROCEDURE [dbo].[sp_builder_mr_periods_accounts]
 (
	@period nvarchar(4000), -- this is ok
	@mr_range int,
	@Delimiter nvarchar(1) -- use pipeline
 )
 with encryption
 as 
-----------------------------------------------------------------------------------------------------------
--	           	                     build the request data                                              --
-----------------------------------------------------------------------------------------------------------
SET NOCOUNT ON; -- enable vba Excel access
SET FMTONLY OFF;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOTE add selection of the period from given year or years
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	declare @period_build as nvarchar(6) ;
	
	declare @today as int;

	--set @period = '2015|201605|201604|2017';
	--set @period = '2016';

	--set @period = '20160'


	--set @Delimiter = '|';

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
										if @today > 0 and @today <= @mr_range
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
																									 ,
																										 (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(current_timestamp)), 2) )
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


exec sistemas.dbo.sp_builder_mr_periods_accounts 
												'20160', -- @period 
												20,          -- @day
												'|' 
												;



-- @period define the period to consider , only year build from jan to dec until current month , year+month only that period and the magical year+0 build current month and before current month until defined day
-- @day set the maximun day to call the before of the current month ex if @day = 12 and currentday is 12 then show current month -1 until today and tomorrow show current month
-- @delimiter set the delimiter in example set @period = '2015|201605|201604|2017'; hir build all 2015 and may and apr of 2016 and all 2017 if we are in 2016 then 2017 is goin null