--

use sistemas

SELECT
		name,"type"
		,case "type"
			when	'P' 	then 	'Stored Procedures'
			when	'FN' 	then	'Scalar Functions'
			when	'IF'	then 	'Inline Table-Value Functions'
			when	'TF'	then	'Table-Value Functions'
			when	'TF'	then	'Tigger Functions'
			when	'U'		then	'Base Table'
			when	'V'		then	'View'
		end as 'Types'
FROM
	dbo.sysobjects
WHERE
	"type" IN
		(
		'P', -- stored procedures
		'FN', -- scalar functions
		'IF', -- inline table-valued functions
		'TF', -- table-valued functions
		'TR', -- tigerUppercut
		'U',
		'V'
		)
	and 
		name like '%contraloria%'
ORDER BY "type", name




-- ============================================================================================================== --
-- =========================================== Build iave periods =============================================== --
-- ============================================================================================================== --
-- original table select * from sistemas.dbo.casetas_iave_periods
-- id,user_id,period_iave_id,period_desc,fecha_ini,fecha_fin,offset_day_minus,offset_day_plus,created,modified,_status
-- example 1  |1       |375|Mayo 21 al 31 2016-05-21 00:00:00|2016-05-31 23:59:00 |5 |1 |2017-03-16 11:01:44 |2017-03-16 11:01:44 
-- higest compability


with "years" as	 (
					select 
							 1 as "num"
						union all
				    select 
							 "num" + 1 as "num"
					from 
				    		"years"
				    where
							"num" <= (DATEDIFF ( year , '2005-01-01' , CURRENT_TIMESTAMP ))
)
select
		row_number()
		over
			(order by cyear) as
				 "period_iave_id"
				,"cyear"
				,"id_month"
				,"month"
				,"date"
				,"period"
				,"per_id"
				,"init"
				,"end"
				,"period_desc"
				,"fecha_ini"
				,"fecha_fin"
				,"_control"
	from
		(
			select
					 year(dateadd(year,"yr"."num",'2005-01-01')) as "cyear"
					,"mts".id_month
					,"mts"."month"
					,cast(year(dateadd(year,"yr"."num",'2005-01-01')) as varchar(4)) + '-' + cast("mts".id_month as varchar(2)) + '-01' as "date"
					,cast(year(dateadd(year,"yr"."num",'2005-01-01')) as varchar(4)) + "mts".id_month as "period"
					,"per".per_id
					,"per".init as "init"
					,isnull("per"."end",day(( DATEADD(month, (((year(dateadd(year,"yr"."num",'2005-01-01'))) - 1900) * 12) + "mts".id_month, -1) ))) as "end"
					,"mts"."month" + ' ' + "per".init + ' al ' + isnull("per"."end",day(( DATEADD(month, (((year(dateadd(year,"yr"."num",'2005-01-01'))) - 1900) * 12) + "mts".id_month, -1) ))) as "period_desc"
					, cast(year(dateadd(year,"yr"."num",'2005-01-01')) as varchar(4)) + '-' + "mts".id_month + '-' + right('00'+convert(varchar(2),"per".init), 2) +' 00:00:00.000' as "fecha_ini"
					, cast(year(dateadd(year,"yr"."num",'2005-01-01')) as varchar(4)) + '-' + "mts".id_month + '-' + isnull("per"."end",day(( DATEADD(month, (((year(dateadd(year,"yr"."num",'2005-01-01'))) - 1900) * 12) + "mts".id_month, -1) ))) +' 23:59:59.000' as "fecha_fin"
					,'1' as '_control'
			from
					"years" as "yr"
				left join (
							select '01' as "id_month", 'Enero' as "month"
							union select '02' as "id_month", 'Febrero' as "month"
							union select '03' as "id_month", 'Marzo' as "month"
							union select '04' as "id_month", 'Abril' as "month"
							union select '05' as "id_month", 'Mayo' as "month"
							union select '06' as "id_month", 'Junio' as "month"
							union select '07' as "id_month", 'Julio' as "month"
							union select '08' as "id_month", 'Agosto' as "month"
							union select '09' as "id_month", 'Septiembre' as "month"
							union select '10' as "id_month", 'Octubre' as "month"
							union select '11' as "id_month", 'Noviembre' as "month"
							union select '12' as "id_month", 'Diciembre' as "month"
						   )
				as "mts" on 1 = 1
				left join (
							select '1' as 'per_id', '1' as 'init', '10' as 'end'
							union select '2' as 'per_id', '11' as 'init', '20' as 'end'
							union select '3' as 'per_id', '21' as 'init', null as 'end'
						   )
				as "per" on 1 = 1			
		)
	as result


-- =========================================== years =============================================== --
	
	
with "counter" as (

	select 
			 1 as "num"
		union all
    select 
			 "num" + 1 as "num"
	from 
    		"counter"
    where
			"num" <= (DATEDIFF ( year , '2005-01-01' , CURRENT_TIMESTAMP ))
)
select 
		"num" as "num_year" 
		,year(dateadd(year,"num",'2004-01-01')) as "cyear"
from
		"counter"


-- ================================================================================== --
--given the table

--id,user_id,period_iave_id,period_desc,fecha_ini ,fecha_fin ,offset_day_minus ,offset_day_plus ,created ,modified ,_status

-- full compability
		select 
				 cast(row_number() over(partition by "_control" order by "_control") as int) as 'id'
				,1 as 'user_id'
				,cast(period_iave_id as int)
				,period_desc collate SQL_Latin1_General_CP1_CI_AS as 'period_desc'
				,cast(fecha_ini as datetime) as 'fecha_ini'
				,cast(fecha_fin as datetime) as 'fecha_fin'
				,5 as 'offset_day_minus'
				,1 as 'offset_day_plus'
				,CURRENT_TIMESTAMP as 'created'
				,CURRENT_TIMESTAMP as 'modified'
				,cast("_control" as tinyint) as '_status'
		from 
				sistemas.dbo.casetas_iave_periods_sources 
		where 
				period 
					between 
							(left(CONVERT(VARCHAR(10), (dateadd(month,-15,CURRENT_TIMESTAMP)), 112), 6))
					and 
							(left(CONVERT(VARCHAR(10), (dateadd(month,3,CURRENT_TIMESTAMP)), 112), 6))
							
							
-- ================================================================================== --							


-- ========================== Stackoverflow ==================================== --
-- https://stackoverflow.com/questions/12391472/looping-in-select-statement-in-ms-sqlserver


declare @startDate datetime , @endDate datetime
set @startDate='09/01/2012'
set @endDate='09/30/2012'

;with T(day) as
(
    select @startDate as day
        union all
    select day + 1
        from T
        where day < @endDate
)
select day as [Date] from T



-- ================================ Get the last day in a given month =================================== -- 	

DECLARE @test DATETIME
SET @test = GETDATE()  -- or any other date
SELECT DATEADD(month, ((YEAR(@test) - 1900) * 12) + MONTH(@test), -1)



select * from sistemas.dbo.generals_month_translations


-- 375 |  Mayo 21 al 31 | 2016-05-21 00:00:00 |  2016-05-31 23:59:00


select * from sistemas.dbo.casetas_iave_periods


