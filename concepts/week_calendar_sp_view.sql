-- ======================================================================================================================================= --
-- 												build a week-calendar
-- ======================================================================================================================================= --

USE sistemas
 
ALTER PROCEDURE spview_report_xr2z_getWeekDateRangesCalendars
 (
	 @cyear 			varchar(4)		-- the year
	,@datefirst 		int				-- set firts day in server 
 )
 with encryption
 as 
 	SET NOCOUNT ON
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER on

/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : September 20, 2016
 Description    : Quering the operational data as kms,tons,trips,cash from lis datatables 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/
 
 
-- ============================================= start the prog  =========================================== --

    -- declare the vars to use 
    -- internal
    declare @num				int
    declare @lim				int
    declare @first_day			date
    declare @last_day			date
   	declare @dateFirstValue		int
/*-- ========== parameters =============== --    
	declare @dateFirstValue		int
	declare @cyear				varchar(4)
	declare @datefirst 			int    
	-- set the year
	set @cyear = '2017'
	-- set the server first day
	set @datefirst = 4
    -- set the first day 
	set @dateFirstValue = 4
-- ========== parameters =============== --*/

    if ( (@cyear is null) OR (@cyear = '') )
    	begin
	    	set @cyear = cast(year(CURRENT_TIMESTAMP) as varchar(4))
    	end 
    	
    set @dateFirstValue = @datefirst
    --  set the needed enviorement parameter to server
    set DATEFIRST @datefirst -- for set the correct number of week
	-- microsoft rules ?
	set @dateFirstValue = 7 - @dateFirstValue - 1 -- set the init day
    -- how many weeks have this year
	set @lim = ( select datepart(week,cast( (@cyear + '-12-31') as date)) )
    -- build a table that content the weeks in this and y the previous year
    
    declare @num_weeks as table (
    	 "cyear" 			int
    	,"num_week"			int
    	,"startOfWeek"		date
    	,"endOfWeek"		date
    )
    -- set the loop 
		set @first_day = cast( (@cyear + '-01-01') as date)
    	set @num = 1
    	
    	while @num <= @lim
	    	begin   	
				print 'weekNum : ' + cast(datepart(week,@first_day) as varchar(10))
				print 'startOfWeek : ' + cast(DATEADD(day, 0 - (@@DATEFIRST + @dateFirstValue + DATEPART(dw,@first_day)) % 7, @first_day) as varchar(12))
		 		print 'endOfWeek : ' + cast(DATEADD(day, 6 - (@@DATEFIRST + @dateFirstValue + DATEPART(dw,@first_day)) % 7, @first_day) as varchar(12))
		 		set @last_day = (DATEADD(day, 6 - (@@DATEFIRST + @dateFirstValue + DATEPART(dw,@first_day)) % 7, @first_day)) -- maybe omit this and set directly
		 		
		 		insert into @num_weeks
		 			select 
		 					 @cyear as 'cyear'
		 					,datepart(week,@first_day) as 'num_week'
		 					,DATEADD(day, 0 - (@@DATEFIRST + @dateFirstValue + DATEPART(dw,@first_day)) % 7, @first_day) as 'startOfWeek'
		 					,DATEADD(day, 6 - (@@DATEFIRST + @dateFirstValue + DATEPART(dw,@first_day)) % 7, @first_day) as 'endOfWeek'
		 					
		 		set @first_day = dateadd(day,1,@last_day)
				set @num = @num + 1
	    	end

	select * from @num_weeks
	
-- ======================================================================================================================================= --
-- 												build a view week-calendar
-- ======================================================================================================================================= --
	use sistemas;

	IF OBJECT_ID ('report_view_calendar_weeks', 'V') IS NOT NULL
	    DROP VIEW report_view_calendar_weeks;
	
	create view report_view_calendar_weeks
	as
	select 
			 "cyear"
			,"num_week"
			,"startOfWeek"
			,"endOfWeek"
	from 
			openquery(local,'exec sistemas.dbo.spview_report_xr2z_getWeekDateRangesCalendars null,4')

			
	select * from sistemas.dbo.report_view_calendar_weeks
