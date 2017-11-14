-- =========================== Almost done ========================================= --
use sistemas

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON

create procedure ingresos_costos_gerencial_indicators
--(
--	@nyear as int
--)

 with encryption
 as
-- ==================================================================================================================== --
-- =================================       Build a Holidays volatile table       ====================================== --
-- ==================================================================================================================== --

-- ==================================================================================================================== --
/*
	 Author         : Jesus Baizabal
	 email			: ambagasdowa@gmail.com
	 Create date    : April 06, 2017
	 Description    : Build Tables for constant values like months names translation to spanish names
	 TODO			: clean
	 @Last_patch	: --
	 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
	 Database owner : bonampak s.a de c.v
	 @status        : Stable
	 @version		: 1.0.0
 */
-- ==================================================================================================================== --

	set NOCOUNT ON -- enable vba Excel access
	set FMTONLY OFF
-- test --

--	if @nyear is null
--		begin
--			set @nyear = year(current_timestamp)
--		end

	declare @Holidays as table
								(
									Holiday_name VARCHAR(32),
									Holiday_date SMALLDATETIME
								)
--
	declare @hd as table
						 (
						 	 yr 					 int
						 	,Holiday_name			 nvarchar(60)
						 	,Holiday_date			 date
						 	,dw 					 int
						 	,is_sunday 				 int
						 	,is_sat_sun 			 int
						 	,_period 				 nvarchar(6)
						 	,first_day_in_month		 date
						 	,last_day_in_month		 date
						 )

	-- test --
	-- Calculate Easter Sunday
	DECLARE @g INT
	DECLARE @c INT
	DECLARE @h INT
	DECLARE @i INT
	DECLARE @j INT
	DECLARE @l INT
	DECLARE @Month INT
	DECLARE @Day INT
	DECLARE @Easter SMALLDATETIME
	DECLARE @WorkDT SMALLDATETIME


-- ====================== start the procedure ================================ --
	declare @nyear as int
	set @nyear = 0

	print 'the yearval ' + cast(@nyear as varchar(4))

	declare ind_cursor cursor for
		select cyear from sistemas.dbo.reporter_views_years group by cyear

	open ind_cursor

		fetch next	from ind_cursor into @nyear

		while @@FETCH_STATUS = 0
			begin
					print 'inside the cursor yearval ' + cast(@nyear as varchar(4))
					-- Bizarre Algorithm to determine Easter Sunday
					SET @g = @nYear % 19
					SET @c = @nYear / 100
					SET @h = ((@c - (@c / 4) - ((8 * @c + 13) / 25) + (19 * @g) + 15) % 30)
					SET @i = @h - ((@h / 28) * (1 - (@h /28) * (29 / (@h + 1)) * ((21 - @g) / 11)))
					SET @j = ((@nYear + (@nYear / 4) + @i + 2 - @c + (@c / 4)) % 7)
					SET @l = @i - @j
					SET @Month = 3 + ((@l + 40) / 44)
					SET @Day = @l + 28 - (31 * (@Month / 4))
					SET @Easter = CAST(@Month AS VARCHAR(2)) + '/' + CAST(@Day As VARCHAR(2)) + '/' + CAST(@nYear AS VARCHAR(4))

					------------------------------------------------------------------------------------------------
					-- Add Easter Sunday to holiday list, and get holidays based around Easter
--					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Easter',@Easter)
					-- Good Friday
					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Good Friday',DateAdd(d,-2,@Easter))
					-- Palm Sunday
					--INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Palm Sunday',DateAdd(ww,-1,@Easter))
					-------------------------------------------------------------------------------------------------

					-- Fixed date holidays are loaded next
					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('New Year''s Day',CONVERT(SmallDateTime,'1/1/'+CAST(@nYear AS VARCHAR(4))))
					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('LabourDay',CONVERT(SmallDateTime,'5/1/'+CAST(@nYear AS VARCHAR(4))))
					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Independence Day',CONVERT(SmallDateTime,'9/16/'+CAST(@nYear AS VARCHAR(4))))

					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('All Souls Day',CONVERT(SmallDateTime,'11/2/'+CAST(@nYear AS VARCHAR(4))))
					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Christmas',CONVERT(SmallDateTime,'12/25/'+CAST(@nYear AS VARCHAR(4))))

					-- Holidays that full on the same day of the week (based on the year they were officially established)

					-- FloatingDate({1st,2nd,3rd,...,etc},{dayOfWeek-starting inSunday as 1},{monthOfYear},{theYear})

					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('BattleOfPuebla',sistemas.dbo.FloatingDate(1,2,2,@nYear)) -- 1st Monday in February
					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('JuarezBirthday',sistemas.dbo.FloatingDate(3,2,3,@nYear)) -- 3rd Monday of March
					INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('MexicanRevolution',sistemas.dbo.FloatingDate(3,2,11,@nYear)) -- 3rd Monday of November

--					end

					insert into @hd
						select
								 year(Holiday_date) as 'yr'
								,Holiday_name,cast(Holiday_date as date) as 'Holiday_date'
								,datepart(dw,Holiday_date) as 'dw'
								,case
									when datepart(dw,Holiday_date) = 1
										then '1'
									else '0'
								end	as 'is_sunday'
								,case
									when (datepart(dw,Holiday_date) = 1 or datepart(dw,Holiday_date) = 7)
										then '1'
									else '0'
								end	as 'is_sat_sun'
								,substring( convert(nvarchar(MAX), Holiday_date, 112) , 1, 6 ) as '_period'
								,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(Holiday_date)-1),Holiday_date),23) as 'first_day_in_month'
								,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,Holiday_date))),DATEADD(mm,1,Holiday_date)),23) as 'last_day_in_month'
						from
								@Holidays
				fetch next	from ind_cursor into @nyear
			end

	close ind_cursor
	deallocate ind_cursor

select
	 	 yr
	 	,Holiday_name
	 	,Holiday_date
	 	,dw
	 	,is_sunday
	 	,is_sat_sun
	 	,"_period"
	 	,first_day_in_month
	 	,last_day_in_month
from @hd group by
			 	 yr
			 	,Holiday_name
			 	,Holiday_date
			 	,dw
			 	,is_sunday
			 	,is_sat_sun
			 	,"_period"
			 	,first_day_in_month
			 	,last_day_in_month

--Ending the Prodedure


-- =================================== view of Holidays ======================================= --



use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_holidays', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_holidays;
-- go
create view ingresos_costos_holidays
with encryption
as

	select
			 ( row_number() over(order by "holidays".Holiday_date) ) as 'id'
			,"holidays".yr
			,"holidays".Holiday_name,"holidays".Holiday_date,"holidays".dw,"holidays".is_sunday
			,"holidays".is_sat_sun,"holidays"."_period","holidays".first_day_in_month
			,"holidays".last_day_in_month
	from
			openquery(local,'SET FMTONLY OFF; SET NOCOUNT ON; exec sistemas.dbo.ingresos_costos_gerencial_indicators') as "holidays"

-- end the view


use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_his_holidays', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_his_holidays;
-- go
create view ingresos_costos_his_holidays
with encryption
as
	with "p" as
	(
		select
					"yrs".id,"yrs".cyear,"yrs".id_month,"yrs"."month","yrs".period,"yrs"."_period"
					,cast(DATEADD(month,cast("yrs".id_month as int)-1,DATEADD(year,"yrs".cyear-1900,0)) as date) as 'first_day_in_month'
					,cast(DATEADD(day,-1,DATEADD(month,cast("yrs".id_month as int),DATEADD(year,"yrs".cyear-1900,0))) as date) as 'last_day_in_month'
					,case
						when
							"yrs"."period" = substring( convert(nvarchar(MAX), current_timestamp, 112) , 1, 6 ) and day(CURRENT_TIMESTAMP) = 1
						 then
						 	cast(current_timestamp as date)
						when
							"yrs"."period" = substring( convert(nvarchar(MAX), current_timestamp, 112) , 1, 6 ) and day(CURRENT_TIMESTAMP) <> 1
						 then
						 	cast(dateadd(day,-1,current_timestamp) as date)
						else
							cast(DATEADD(day,-1,DATEADD(month,cast("yrs".id_month as int),DATEADD(year,"yrs".cyear-1900,0))) as date)
					 end as 'is_current'
		from
					sistemas.dbo.reporter_views_years as "yrs"
	)
	select
		"pers".id,"pers".cyear,"pers".id_month,"pers"."month","pers".period,"pers"."_period"
		,"pers".first_day_in_month
		,"pers".last_day_in_month
		,"pers".is_current
		,((datediff(day,"pers".first_day_in_month,"pers".is_current)-DATEPART(dw,"pers".is_current)+8)/7) as 'hasSun'
		,((datediff(day,"pers".first_day_in_month,"pers".last_day_in_month)-DATEPART(dw,"pers".last_day_in_month)+8)/7) as 'hasFullSun'
		,case
			when "hol".Holiday_date is not null
				then '1'
			else '0'
		 end as 'hasCurrentHoliday'
		,isnull("thol".holiday,0) as 'hisFullHoliday'
	from
		"p" as "pers"
	left join
			sistemas.dbo.ingresos_costos_holidays as "hol"
		on
			"pers".period = "hol"."_period" collate SQL_Latin1_General_CP1_CI_AS
		and
			"hol".is_sunday = 0
		and
			"hol".Holiday_date
				between "pers".first_day_in_month and "pers".is_current
	left join
				(
					select
							yr
							,_period
							,sum (
									case
										when is_sunday = 0
											then 1
											else 0
									end
							 ) as 'holiday'
					from sistemas.dbo.ingresos_costos_holidays
					where is_sunday = 0
					group by yr,"_period"
				) as "thol" on "pers".period = "thol"."_period" collate SQL_Latin1_General_CP1_CI_AS  and "pers".cyear = "thol".yr
-- end the view


use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_gst_holidays', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_gst_holidays;
-- go
create view ingresos_costos_gst_holidays
--with encryption
as

with "l" as (
	select
			 "diag".id
			,"diag".cyear
			,"diag".id_month
			,"diag"."month"
			,"diag".period
			,"diag"._period
			,"diag".first_day_in_month
			,"diag".last_day_in_month
			,"diag".is_current
			,"diag".hasSun
			,"diag".hasFullSun
			,sum(cast("diag".hasCurrentHoliday as int)) as 'hasCurrentHoliday'
			,"diag".hisFullHoliday
	from
			sistemas.dbo.ingresos_costos_his_holidays as "diag"
	group by
	   	     "diag".id
			,"diag".cyear
			,"diag".id_month
			,"diag"."month"
			,"diag".period
			,"diag"._period
			,"diag".first_day_in_month
			,"diag".last_day_in_month
			,"diag".is_current
			,"diag".hasSun
			,"diag".hasFullSun
			,"diag".hisFullHoliday
	)
	select
			 "labour".id
			,"labour".cyear
			,"labour".id_month
			,"labour"."month"
			,"labour".period
			,"labour"."_period"
			,"labour".first_day_in_month
			,"labour".last_day_in_month
			,"labour".is_current
			,"labour".hasSun
			,"labour".hasFullSun
			,"labour".hasCurrentHoliday
			,"labour".hisFullHoliday
			,case	
				when day("labour".is_current) = 1
					then '0'
				else
					(day("labour".is_current) - "labour".hasSun - "labour".hasCurrentHoliday) 
			end as 'labDays'
			,(day("labour".last_day_in_month ) - "labour".hasFullSun - "labour".hisFullHoliday) as 'labFullDays'
			,case 
				when day("labour".is_current) = 1
					then 
						(day("labour".last_day_in_month ) - "labour".hasFullSun - "labour".hisFullHoliday) - ("labour".hasSun - "labour".hasCurrentHoliday)
				else
					(day("labour".last_day_in_month ) - "labour".hasFullSun - "labour".hisFullHoliday) - (day("labour".is_current) - "labour".hasSun - "labour".hasCurrentHoliday) 
			end	as 'labRestDays'
	from "l" as "labour"



-- =================================== view of Presupuesto ======================================= --


--Presupuesto Ingresos Granel

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_granel_ingresos', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_granel_ingresos;
-- go
create view ingresos_costos_granel_ingresos
with encryption
as

	with "r" as (
		select
				cyear
		from
				sistemas.dbo.reporter_views_years
		group by cyear
	)
	select
			  "predate".cyear
--			 ,"acch".Acct
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID
			 ,sum("acch".PtdBal00) as 'PtdBal00'
			 ,sum("acch".PtdBal01) as 'PtdBal01'
			 ,sum("acch".PtdBal02) as 'PtdBal02'
			 ,sum("acch".PtdBal03) as 'PtdBal03'
			 ,sum("acch".PtdBal04) as 'PtdBal04'
			 ,sum("acch".PtdBal05) as 'PtdBal05'
			 ,sum("acch".PtdBal06) as 'PtdBal06'
			 ,sum("acch".PtdBal07) as 'PtdBal07'
			 ,sum("acch".PtdBal08) as 'PtdBal08'
			 ,sum("acch".PtdBal09) as 'PtdBal09'
			 ,sum("acch".PtdBal10) as 'PtdBal10'
			 ,sum("acch".PtdBal11) as 'PtdBal11'
			 ,sum("acch".PtdBal12) as 'PtdBal12'
--			 ,"acch".tstamp
			 ,'GRANEL' as 'fraction'
	from
			"r" as "predate"
	inner join
			integraapp.dbo.AcctHist as  "acch"
		on
			"predate".cyear = "acch".FiscYr
		and
			"acch".LedgerID = 'PRESUP' + cast("predate".cyear as varchar(4))
		and
			"acch".Acct in
							(
								select
										"flees".Cfact
								from
										integraapp.dbo.xctascon as "flees" where "flees".Embalaje > 0
								and "flees".Embalaje in
														( -- check the automation of this
															select
																	projections_id_fraccion
															from
																	sistemas.dbo.projections_view_company_fractions
															where
																	projections_corporations_id in (select id from sistemas.dbo.projections_corporations)
																and
																	projections_rp_fraction_id = 1
															group by
																	projections_id_fraccion
														)
							)
		group by
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID





	--	Presupuesto Ingresos Otros


use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_otros_ingresos', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_otros_ingresos;
-- go
create view ingresos_costos_otros_ingresos
with encryption
as

	with "r" as (
		select
				cyear
		from
				sistemas.dbo.reporter_views_years
		group by cyear
	)
	select
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID
			 ,sum("acch".PtdBal00) as 'PtdBal00'
			 ,sum("acch".PtdBal01) as 'PtdBal01'
			 ,sum("acch".PtdBal02) as 'PtdBal02'
			 ,sum("acch".PtdBal03) as 'PtdBal03'
			 ,sum("acch".PtdBal04) as 'PtdBal04'
			 ,sum("acch".PtdBal05) as 'PtdBal05'
			 ,sum("acch".PtdBal06) as 'PtdBal06'
			 ,sum("acch".PtdBal07) as 'PtdBal07'
			 ,sum("acch".PtdBal08) as 'PtdBal08'
			 ,sum("acch".PtdBal09) as 'PtdBal09'
			 ,sum("acch".PtdBal10) as 'PtdBal10'
			 ,sum("acch".PtdBal11) as 'PtdBal11'
			 ,sum("acch".PtdBal12) as 'PtdBal12'
			 ,'OTROS' as 'fraction'
	from
			"r" as "predate"
	inner join
			integraapp.dbo.AcctHist as  "acch"
		on
			"predate".cyear = "acch".FiscYr
		and
			"acch".LedgerID = 'PRESUP' + cast("predate".cyear as varchar(4))
		and
			"acch".Acct in
							(
								select
										"flees".Cfact
								from
										integraapp.dbo.xctascon as "flees" where "flees".Embalaje > 0
								and "flees".Embalaje not in
														( -- check the automation of this
															select
																	projections_id_fraccion
															from
																	sistemas.dbo.projections_view_company_fractions
															where
																	projections_corporations_id in (select id from sistemas.dbo.projections_corporations)
																and
																	projections_rp_fraction_id = 1
															group by
																	projections_id_fraccion
														)
							)
		group by
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID

	--
	 
			 
			 
--	Presupuesto Ingresos

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_ppto_ingresos', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_ppto_ingresos;
-- go
create view ingresos_costos_ppto_ingresos

as
select  * from sistemas.dbo.ingresos_costos_granel_ingresos
union all
select  * from sistemas.dbo.ingresos_costos_otros_ingresos

-- end of the view

-- build another join


-- > AQUI XDXDXD

-- ==================================================================================================================== --
-- =================================       Presupuesto Kilometros Granel        ====================================== --
-- ==================================================================================================================== --
			 

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_granel_kilometros', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_granel_kilometros;
-- go
create view ingresos_costos_granel_kilometros
with encryption
as
	with "r" as (
		select
				cyear
		from
				sistemas.dbo.reporter_views_years
		group by cyear
	)
	select
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID
			 ,sum("acch".PtdBal00) as 'PtdBal00'
			 ,sum("acch".PtdBal01) as 'PtdBal01'
			 ,sum("acch".PtdBal02) as 'PtdBal02'
			 ,sum("acch".PtdBal03) as 'PtdBal03'
			 ,sum("acch".PtdBal04) as 'PtdBal04'
			 ,sum("acch".PtdBal05) as 'PtdBal05'
			 ,sum("acch".PtdBal06) as 'PtdBal06'
			 ,sum("acch".PtdBal07) as 'PtdBal07'
			 ,sum("acch".PtdBal08) as 'PtdBal08'
			 ,sum("acch".PtdBal09) as 'PtdBal09'
			 ,sum("acch".PtdBal10) as 'PtdBal10'
			 ,sum("acch".PtdBal11) as 'PtdBal11'
			 ,sum("acch".PtdBal12) as 'PtdBal12'
			 ,'GRANEL' as 'fraction'
	from
			"r" as "predate"
	inner join
			integraapp.dbo.AcctHist as  "acch"
		on
			"predate".cyear = "acch".FiscYr
		and
			"acch".LedgerID = 'PRESUP' + cast("predate".cyear as varchar(4))
		and
			"acch".Acct in
						('0901010200','0901010211')  -- > Kilometros Granel
		group by
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID

-- ==================================================================================================================== --
-- =================================       Presupuesto Kilometros Otros        ====================================== --
-- ==================================================================================================================== --

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_otros_kilometros', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_otros_kilometros;
-- go
create view ingresos_costos_otros_kilometros
with encryption
as
	with "r" as (
		select
				cyear
		from
				sistemas.dbo.reporter_views_years
		group by cyear
	)
	select
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID
			 ,sum("acch".PtdBal00) as 'PtdBal00'
			 ,sum("acch".PtdBal01) as 'PtdBal01'
			 ,sum("acch".PtdBal02) as 'PtdBal02'
			 ,sum("acch".PtdBal03) as 'PtdBal03'
			 ,sum("acch".PtdBal04) as 'PtdBal04'
			 ,sum("acch".PtdBal05) as 'PtdBal05'
			 ,sum("acch".PtdBal06) as 'PtdBal06'
			 ,sum("acch".PtdBal07) as 'PtdBal07'
			 ,sum("acch".PtdBal08) as 'PtdBal08'
			 ,sum("acch".PtdBal09) as 'PtdBal09'
			 ,sum("acch".PtdBal10) as 'PtdBal10'
			 ,sum("acch".PtdBal11) as 'PtdBal11'
			 ,sum("acch".PtdBal12) as 'PtdBal12'
			 ,'OTROS' as 'fraction'
	from
			"r" as "predate"
	inner join
			integraapp.dbo.AcctHist as  "acch"
		on
			"predate".cyear = "acch".FiscYr
		and
			"acch".LedgerID = 'PRESUP' + cast("predate".cyear as varchar(4))
		and
			"acch".Acct in
						('0901010202','0901010212')  -- > Kilometros Granel
		group by
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID


			 
--	Presupuesto Kilometros

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_ppto_kilometros', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_ppto_kilometros;
-- go
create view ingresos_costos_ppto_kilometros

as
select  * from sistemas.dbo.ingresos_costos_granel_kilometros
union all
select  * from sistemas.dbo.ingresos_costos_otros_kilometros

			 
-- select * from ingresos_costos_ppto_kilometros			 


--TONELADAS PRESUPUESTO


-- ==================================================================================================================== --
-- =================================       Presupuesto Toneladas Granel        ====================================== --
-- ==================================================================================================================== --

			 

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_granel_toneladas', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_granel_toneladas;
-- go
create view ingresos_costos_granel_toneladas
with encryption
as
	with "r" as (
		select
				cyear
		from
				sistemas.dbo.reporter_views_years
		group by cyear
	)
	select
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID
			 ,sum("acch".PtdBal00) as 'PtdBal00'
			 ,sum("acch".PtdBal01) as 'PtdBal01'
			 ,sum("acch".PtdBal02) as 'PtdBal02'
			 ,sum("acch".PtdBal03) as 'PtdBal03'
			 ,sum("acch".PtdBal04) as 'PtdBal04'
			 ,sum("acch".PtdBal05) as 'PtdBal05'
			 ,sum("acch".PtdBal06) as 'PtdBal06'
			 ,sum("acch".PtdBal07) as 'PtdBal07'
			 ,sum("acch".PtdBal08) as 'PtdBal08'
			 ,sum("acch".PtdBal09) as 'PtdBal09'
			 ,sum("acch".PtdBal10) as 'PtdBal10'
			 ,sum("acch".PtdBal11) as 'PtdBal11'
			 ,sum("acch".PtdBal12) as 'PtdBal12'
			 ,'GRANEL' as 'fraction'
	from
			"r" as "predate"
	inner join
			integraapp.dbo.AcctHist as  "acch"
		on
			"predate".cyear = "acch".FiscYr
		and
			"acch".LedgerID = 'PRESUP' + cast("predate".cyear as varchar(4))
		and
			"acch".Acct in
						('0901010300','0901010400')  -- > toneladas Granel
		group by
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID

-- ==================================================================================================================== --
-- =================================       Presupuesto toneladas Otros        ====================================== --
-- ==================================================================================================================== --

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_otros_toneladas', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_otros_toneladas;
-- go
create view ingresos_costos_otros_toneladas
with encryption
as
	with "r" as (
		select
				cyear
		from
				sistemas.dbo.reporter_views_years
		group by cyear
	)
	select
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID
			 ,sum("acch".PtdBal00) as 'PtdBal00'
			 ,sum("acch".PtdBal01) as 'PtdBal01'
			 ,sum("acch".PtdBal02) as 'PtdBal02'
			 ,sum("acch".PtdBal03) as 'PtdBal03'
			 ,sum("acch".PtdBal04) as 'PtdBal04'
			 ,sum("acch".PtdBal05) as 'PtdBal05'
			 ,sum("acch".PtdBal06) as 'PtdBal06'
			 ,sum("acch".PtdBal07) as 'PtdBal07'
			 ,sum("acch".PtdBal08) as 'PtdBal08'
			 ,sum("acch".PtdBal09) as 'PtdBal09'
			 ,sum("acch".PtdBal10) as 'PtdBal10'
			 ,sum("acch".PtdBal11) as 'PtdBal11'
			 ,sum("acch".PtdBal12) as 'PtdBal12'
			 ,'OTROS' as 'fraction'
	from
			"r" as "predate"
	inner join
			integraapp.dbo.AcctHist as  "acch"
		on
			"predate".cyear = "acch".FiscYr
		and
			"acch".LedgerID = 'PRESUP' + cast("predate".cyear as varchar(4))
		and
			"acch".Acct in
						('0901010500','0901010600','0901019900')  -- > Toneladas Otros
		group by
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID


			 
--	Presupuesto Toneladas

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_ppto_toneladas', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_ppto_toneladas;
-- go
create view ingresos_costos_ppto_toneladas

as
select  cyear,CpnyID,PtdBal10 from sistemas.dbo.ingresos_costos_granel_toneladas
union all
select  * from sistemas.dbo.ingresos_costos_otros_toneladas

			 
-- select * from ingresos_costos_ppto_toneladas		



-- VIAJES PRESUPUESTO


-- ==================================================================================================================== --
-- =================================       Presupuesto Toneladas Granel        ====================================== --
-- ==================================================================================================================== --
		 

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_granel_viajes', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_granel_viajes;
-- go
create view ingresos_costos_granel_viajes
with encryption
as
	with "r" as (
		select
				cyear
		from
				sistemas.dbo.reporter_views_years
		group by cyear
	)
	select
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID
			 ,sum("acch".PtdBal00) as 'PtdBal00'
			 ,sum("acch".PtdBal01) as 'PtdBal01'
			 ,sum("acch".PtdBal02) as 'PtdBal02'
			 ,sum("acch".PtdBal03) as 'PtdBal03'
			 ,sum("acch".PtdBal04) as 'PtdBal04'
			 ,sum("acch".PtdBal05) as 'PtdBal05'
			 ,sum("acch".PtdBal06) as 'PtdBal06'
			 ,sum("acch".PtdBal07) as 'PtdBal07'
			 ,sum("acch".PtdBal08) as 'PtdBal08'
			 ,sum("acch".PtdBal09) as 'PtdBal09'
			 ,sum("acch".PtdBal10) as 'PtdBal10'
			 ,sum("acch".PtdBal11) as 'PtdBal11'
			 ,sum("acch".PtdBal12) as 'PtdBal12'
			 ,'GRANEL' as 'fraction'
	from
			"r" as "predate"
	inner join
			integraapp.dbo.AcctHist as  "acch"
		on
			"predate".cyear = "acch".FiscYr
		and
			"acch".LedgerID = 'PRESUP' + cast("predate".cyear as varchar(4))
		and
			"acch".Acct in
						('0901010100','0901010111')  -- > Viajes Granel
		group by
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID

-- ==================================================================================================================== --
-- =================================       Presupuesto toneladas Otros        ====================================== --
-- ==================================================================================================================== --

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_otros_viajes', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_otros_viajes;
-- go
create view ingresos_costos_otros_viajes
with encryption
as
	with "r" as (
		select
				cyear
		from
				sistemas.dbo.reporter_views_years
		group by cyear
	)
	select
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID
			 ,sum("acch".PtdBal00) as 'PtdBal00'
			 ,sum("acch".PtdBal01) as 'PtdBal01'
			 ,sum("acch".PtdBal02) as 'PtdBal02'
			 ,sum("acch".PtdBal03) as 'PtdBal03'
			 ,sum("acch".PtdBal04) as 'PtdBal04'
			 ,sum("acch".PtdBal05) as 'PtdBal05'
			 ,sum("acch".PtdBal06) as 'PtdBal06'
			 ,sum("acch".PtdBal07) as 'PtdBal07'
			 ,sum("acch".PtdBal08) as 'PtdBal08'
			 ,sum("acch".PtdBal09) as 'PtdBal09'
			 ,sum("acch".PtdBal10) as 'PtdBal10'
			 ,sum("acch".PtdBal11) as 'PtdBal11'
			 ,sum("acch".PtdBal12) as 'PtdBal12'
			 ,'OTROS' as 'fraction'
	from
			"r" as "predate"
	inner join
			integraapp.dbo.AcctHist as  "acch"
		on
			"predate".cyear = "acch".FiscYr
		and
			"acch".LedgerID = 'PRESUP' + cast("predate".cyear as varchar(4))
		and
			"acch".Acct in
						('0901010112')  -- > Viajes Otros
		group by
			  "predate".cyear
			 ,"acch".CpnyID
			 ,"acch".FiscYr
			 ,"acch".LedgerID


			 
--	Presupuesto Viajes

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_ppto_viajes', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_ppto_viajes;
-- go
create view ingresos_costos_ppto_viajes

as
select  * from sistemas.dbo.ingresos_costos_granel_viajes
union all
select  * from sistemas.dbo.ingresos_costos_otros_viajes

			 
-- select * from ingresos_costos_ppto_viajes

-- =================================================================== --
--	view for totals in Costos
-- =================================================================== --

-- View of Costos + Presupuesto

-- select * from sistemas.dbo.ingresos_costos_view_ppto_costos


use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_view_ppto_costos', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_view_ppto_costos;
-- go
create view ingresos_costos_view_ppto_costos
as
		select
			 "acc"."_source_company"
			,"units".label as 'area'
			,"acc".Mes as 'mes'
--			,"acc".UnidadNegocio
			,round(sum("acc".Cargo - "acc".Abono),2) as 'Real'
			,round(sum("acc".Presupuesto),2) as 'Presupuesto'
			,"acc"."_period"
			,"acc"."_key" as 'type'
			,"acc".FiscYr as 'cyear'
		from
			sistemas.dbo.reporter_view_report_accounts as "acc"
		inner join
			sistemas.dbo.projections_view_bussiness_units as "units"
			on "acc"."_source_company" = "units".tname
		where
			(
				(
					"_source_company" in ('ATMMAC','TEICUA','TCGTUL')
				)
			or
				(
					"_source_company" not in ('ATMMAC','TEICUA','TCGTUL')
				and
					"acc".Compania not in ('ATMMAC','TEICUA','TCGTUL')
				and
					UnidadNegocio not in ('00')
				)
			)
		and
			"_period" in
						(
							select period from sistemas.dbo.ingresos_costos_view_periods_controls
						)
		and
			"_key" in ('OF','OV','MF','MV')
		group by
--			  "acc".UnidadNegocio
			  "acc"."_period"
			 ,"acc".Mes
			 ,"acc"."_source_company"
			 ,"units".label
			 ,"acc"."_key"
 			 ,"acc".FiscYr



-- =================================================================== --
--	view for totals in ingresos
-- =================================================================== --

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_view_ppto_ingresos', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_view_ppto_ingresos;
-- go
create view ingresos_costos_view_ppto_ingresos
as
with "op" as (
	select
			 "fleets".company
			,"fleets".id_area
			,"fleets".area
			,"fleets".id_fraccion
			,"fleets".fraccion
			,"fleets".cyear
			,"fleets".mes
			,"fleets".subtotal
			,"pe"."period" as 'periodo'
			,case
				when "fleets".fraccion = 'GRANEL'
					then 'GRANEL'
					else 'OTROS'
			 end as 'frt'
			,"units".tname
	from
			sistemas.dbo.projections_view_indicators_dispatch_periods_full_ops as "fleets"
	inner join
			sistemas.dbo.reporter_views_years as "pe"
		on
			"fleets".cyear = "pe".cyear
		and
			"fleets".mes collate SQL_Latin1_General_CP1_CI_AS = "pe"."month"
		and
			"pe".period in 
							(
								select period from sistemas.dbo.ingresos_costos_view_periods_controls
							)
	inner join
			sistemas.dbo.projections_view_bussiness_units as "units"
		on
			"fleets".company = "units".projections_corporations_id
		and
			"fleets".id_area = "units".id_area
	where 
			"fleets".id_fraccion is not null
)
select
			 "operation".company
			,"operation".id_area
			,"operation".area
			,"operation".frt
			,"operation".cyear
			,"operation".mes
			,"operation".periodo
			,sum("operation".subtotal) as 'subtotal'
			,"operation".tname
			,(
				select
					case
						when substring("operation"."periodo",5,2) = '01' then "prein".PtdBal00
						when substring("operation"."periodo",5,2) = '02' then "prein".PtdBal01
						when substring("operation"."periodo",5,2) = '03' then "prein".PtdBal02
						when substring("operation"."periodo",5,2) = '04' then "prein".PtdBal03
						when substring("operation"."periodo",5,2) = '05' then "prein".PtdBal04
						when substring("operation"."periodo",5,2) = '06' then "prein".PtdBal05
						when substring("operation"."periodo",5,2) = '07' then "prein".PtdBal06
						when substring("operation"."periodo",5,2) = '08' then "prein".PtdBal07
						when substring("operation"."periodo",5,2) = '09' then "prein".PtdBal08
						when substring("operation"."periodo",5,2) = '10' then "prein".PtdBal09
						when substring("operation"."periodo",5,2) = '11' then "prein".PtdBal10
						when substring("operation"."periodo",5,2) = '12' then "prein".PtdBal11
					end as 'Presupuesto'
				from
						sistemas.dbo.ingresos_costos_ppto_ingresos as "prein"
				where
						"operation".frt = "prein".fraction
					and
						"operation".tname = "prein".CpnyID
					and
						"operation".cyear = "prein".FiscYr
			) as 'PresupuestoIngresos'
from
		"op" as "operation"
group by
			 "operation".company
			,"operation".id_area
			,"operation".area
			,"operation".frt
			,"operation".cyear
			,"operation".mes
			,"operation".periodo
			,"operation".tname


-- =================================================================== --
--	view for totals in ingresos same as after but without the period filter
-- =================================================================== --

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_view_ind_ppto_ingresos', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_view_ind_ppto_ingresos;
-- go
create view ingresos_costos_view_ind_ppto_ingresos
as
with "op" as (
	select
			 "fleets".company
			,"fleets".id_area
			,"fleets".area
			,"fleets".id_fraccion
			,"fleets".fraccion
			,"fleets".cyear
			,"fleets".mes
			,"fleets".subtotal
			,"pe"."period" as 'periodo'
			,case
				when "fleets".fraccion = 'GRANEL'
					then 'GRANEL'
					else 'OTROS'
			 end as 'frt'
			,"units".tname
	from
--			sistemas.dbo.projections_view_indicators_periods_fleets as "fleets"
			sistemas.dbo.projections_view_indicators_dispatch_periods_full_ops as "fleets"
	inner join
			sistemas.dbo.reporter_views_years as "pe"
		on
			"fleets".cyear = "pe".cyear
		and
			"fleets".mes collate SQL_Latin1_General_CP1_CI_AS = "pe"."month"
--		and
--			"pe".period = substring( convert(nvarchar(MAX), current_timestamp, 112) , 1, 6 )
	inner join
			sistemas.dbo.projections_view_bussiness_units as "units"
		on
			"fleets".company = "units".projections_corporations_id
		and
			"fleets".id_area = "units".id_area
	where 
			"fleets".id_fraccion is not null
)
select
			 "operation".company
			,"operation".id_area
			,"operation".area
			,"operation".frt
			,"operation".cyear
			,"operation".mes
			,"operation".periodo
			,sum("operation".subtotal) as 'subtotal'
			,"operation".tname
			,(
				select
					case
						when substring("operation"."periodo",5,2) = '01' then "prein".PtdBal00
						when substring("operation"."periodo",5,2) = '02' then "prein".PtdBal01
						when substring("operation"."periodo",5,2) = '03' then "prein".PtdBal02
						when substring("operation"."periodo",5,2) = '04' then "prein".PtdBal03
						when substring("operation"."periodo",5,2) = '05' then "prein".PtdBal04
						when substring("operation"."periodo",5,2) = '06' then "prein".PtdBal05
						when substring("operation"."periodo",5,2) = '07' then "prein".PtdBal06
						when substring("operation"."periodo",5,2) = '08' then "prein".PtdBal07
						when substring("operation"."periodo",5,2) = '09' then "prein".PtdBal08
						when substring("operation"."periodo",5,2) = '10' then "prein".PtdBal09
						when substring("operation"."periodo",5,2) = '11' then "prein".PtdBal10
						when substring("operation"."periodo",5,2) = '12' then "prein".PtdBal11
					end as 'Presupuesto'
				from
						sistemas.dbo.ingresos_costos_ppto_ingresos as "prein"
				where
						"operation".frt = "prein".fraction
					and
						"operation".tname = "prein".CpnyID
					and
						"operation".cyear = "prein".FiscYr
			) as 'PresupuestoIngresos'
			,(
				select
					case
						when substring("operation"."periodo",5,2) = '01' then "pretn".PtdBal00
						when substring("operation"."periodo",5,2) = '02' then "pretn".PtdBal01
						when substring("operation"."periodo",5,2) = '03' then "pretn".PtdBal02
						when substring("operation"."periodo",5,2) = '04' then "pretn".PtdBal03
						when substring("operation"."periodo",5,2) = '05' then "pretn".PtdBal04
						when substring("operation"."periodo",5,2) = '06' then "pretn".PtdBal05
						when substring("operation"."periodo",5,2) = '07' then "pretn".PtdBal06
						when substring("operation"."periodo",5,2) = '08' then "pretn".PtdBal07
						when substring("operation"."periodo",5,2) = '09' then "pretn".PtdBal08
						when substring("operation"."periodo",5,2) = '10' then "pretn".PtdBal09
						when substring("operation"."periodo",5,2) = '11' then "pretn".PtdBal10
						when substring("operation"."periodo",5,2) = '12' then "pretn".PtdBal11
					end as 'Presupuesto'
				from
						sistemas.dbo.ingresos_costos_ppto_toneladas as "pretn"
				where
						"operation".frt = "pretn".fraction
					and
						"operation".tname = "pretn".CpnyID
					and
						"operation".cyear = "pretn".FiscYr
			) as 'PresupuestoTon'
			,(
				select
					case
						when substring("operation"."periodo",5,2) = '01' then "prekm".PtdBal00
						when substring("operation"."periodo",5,2) = '02' then "prekm".PtdBal01
						when substring("operation"."periodo",5,2) = '03' then "prekm".PtdBal02
						when substring("operation"."periodo",5,2) = '04' then "prekm".PtdBal03
						when substring("operation"."periodo",5,2) = '05' then "prekm".PtdBal04
						when substring("operation"."periodo",5,2) = '06' then "prekm".PtdBal05
						when substring("operation"."periodo",5,2) = '07' then "prekm".PtdBal06
						when substring("operation"."periodo",5,2) = '08' then "prekm".PtdBal07
						when substring("operation"."periodo",5,2) = '09' then "prekm".PtdBal08
						when substring("operation"."periodo",5,2) = '10' then "prekm".PtdBal09
						when substring("operation"."periodo",5,2) = '11' then "prekm".PtdBal10
						when substring("operation"."periodo",5,2) = '12' then "prekm".PtdBal11
					end as 'Presupuesto'
				from
						sistemas.dbo.ingresos_costos_ppto_kilometros as "prekm"
				where
						"operation".frt = "prekm".fraction
					and
						"operation".tname = "prekm".CpnyID
					and
						"operation".cyear = "prekm".FiscYr
			 ) as 'PresupuestoKms'
			,(
				select
					case
						when substring("operation"."periodo",5,2) = '01' then "prevj".PtdBal00
						when substring("operation"."periodo",5,2) = '02' then "prevj".PtdBal01
						when substring("operation"."periodo",5,2) = '03' then "prevj".PtdBal02
						when substring("operation"."periodo",5,2) = '04' then "prevj".PtdBal03
						when substring("operation"."periodo",5,2) = '05' then "prevj".PtdBal04
						when substring("operation"."periodo",5,2) = '06' then "prevj".PtdBal05
						when substring("operation"."periodo",5,2) = '07' then "prevj".PtdBal06
						when substring("operation"."periodo",5,2) = '08' then "prevj".PtdBal07
						when substring("operation"."periodo",5,2) = '09' then "prevj".PtdBal08
						when substring("operation"."periodo",5,2) = '10' then "prevj".PtdBal09
						when substring("operation"."periodo",5,2) = '11' then "prevj".PtdBal10
						when substring("operation"."periodo",5,2) = '12' then "prevj".PtdBal11
					end as 'Presupuesto'
				from
						sistemas.dbo.ingresos_costos_ppto_viajes as "prevj"
				where
						"operation".frt = "prevj".fraction
					and
						"operation".tname = "prevj".CpnyID
					and
						"operation".cyear = "prevj".FiscYr
		    ) as 'PresupuestoViajes'
from
		"op" as "operation"
group by
			 "operation".company
			,"operation".id_area
			,"operation".area
			,"operation".frt
			,"operation".cyear
			,"operation".mes
			,"operation".periodo
			,"operation".tname
			
			
-- select * from sistemas.dbo.ingresos_costos_view_ind_ppto_ingresos


-- define fractions
-- ========================================================================= --
--	view for totals in ingresos same as after but without the period filter
-- ========================================================================= --

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_view_fractions', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_view_fractions;
-- go
create view ingresos_costos_view_fractions
as

		select
				 projections_rp_definition as 'desc_producto'
				,projections_rp_definition as 'request'
		from
				sistemas.dbo.projections_view_company_fractions
		group by 
				projections_rp_definition
				

-- ========================================================================= --
--	Period control xls
-- ========================================================================= --

use sistemas
-- go
IF OBJECT_ID ('ingresos_costos_view_periods_controls', 'V') IS NOT NULL
    DROP VIEW ingresos_costos_view_periods_controls;
-- go
create view ingresos_costos_view_periods_controls
as				
select 
		id ,cyear ,id_month ,"month" ,period ,"_period"
from sistemas.dbo.reporter_views_years
where period
	between 
		substring( convert(nvarchar(MAX), dateadd(month,-1,current_timestamp), 112) , 1, 6 )
	and
		substring( convert(nvarchar(MAX), current_timestamp, 112) , 1, 6 )








