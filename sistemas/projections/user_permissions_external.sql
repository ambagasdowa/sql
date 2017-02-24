-- INSERT, UPDATE, SELECT, DELETE , EXECUTE
use sistemas
select
--	'select * from "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '" ' --+ ' TO "ambagasdowa"'
--	'REVOKE SELECT ON "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '" TO "ambagasdowa"'
  '"' + TABLE_NAME + '" '
from
	information_schema.tables
where 
	TABLE_NAME like 'projections_%'
-- and 
-- 	TABLE_TYPE = 'BASE TABLE'
-- 	TABLE_TYPE = 'VIEW'
	
	
use sistemas

SELECT
		name,type
		,case type
			when	'P' 	then 	'Stored Procedures'
			when	'FN' 	then	'Scalar Functions'
			when	'IF'	then 	'Inline Table-Value Functions'
			when	'TF'	then	'Table-Value Functions'
			when	'U'		then	'Base Table'
			when	'V'		then	'View'
		end as 'Type'
FROM
	dbo.sysobjects
WHERE
	type IN
		(
		'P', -- stored procedures
		'FN', -- scalar functions
		'IF', -- inline table-valued functions
		'TF', -- table-valued functions
		'U',
		'V'
		)
ORDER BY type, name


--- =========== WARNING use with precaution 
exec sistemas.dbo.sp_xd3e_getFullCompanyOperations 
													'2017',	-- year or years (char) ex:'2016|2017' 
													'01',	-- month or months (char) ex: '01|02|03|04|05|06|07|08|09|10'
													 0,		-- companies (int) id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
													'0',	-- bussiness unit (char) like 1 for orizaba or cuatitlan and 3 for ramos whats is true for tbk but not case of teisa or atm 0 = zero mean all bases
													 4,		-- mode 0 = queryAccepted ;1 = insert Accepted in period ; 3 = insertQueryCancel ; 4 printQueryCancel
													 0,		-- user_id when mode is set to 0 this can be empty ''
													 0      -- projections_closed_period_controls_id when mode is set to 0 this can be empty ''
--- =========== WARNING use with precaution 

--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations '2016','01',0,0,4,0,0 -- fix this

--truncate table sistemas.dbo.projections_systems_logs

--- =========== WARNING use with precaution		  
exec sistemas.dbo.sp_xd4e_fullByMonthCompanyOperations 
														'2017',
														'02',
														 1,		--@date_mode 1 means auto take date with current_timestamp , 0 means manual 2016-01 set inside of proc
														 0		--@query_mode  1 --> snaptshot mode 0 --> normal mode // query_mode
--- =========== WARNING use with precaution


-- ==================== for canceled datas in canceled months just use month string as one element  



														 
raiserror('Now at the create procedure section ....',0,1)



-- ============================================================ --
-- 						    tables								--
-- ============================================================ --
select * from "dbo"."projections_upt_indops"             		--	fetched data closed and open periods --> projections_view_indicators_periods --> current accepted
select * from "dbo"."projections_upt_cancelations"				--	current month canceled cartas portes --> projections_view_indicators_periods --> current canceled      
select * from "dbo"."projections_dissmiss_cancelations"		--	snapshot of cancelations for closed periods  --> projections_view_indicators_periods --> historical canceled
select * from "dbo"."projections_closed_period_datas"    		--	period closed-open data detail --> projections_view_indicators_periods --> historical accepted 
select * from "dbo"."projections_global_corps"					--	group owner company           
select * from "dbo"."projections_corporations"					--	enterprises of the group           
select * from "dbo"."projections_controls_users"				--	control user module -- define which users have access to projections module 
select * from "dbo"."projections_systems_logs"           		--	systems logs
select * from "dbo"."projections_accesses"						--	sub-module access by user and bussiness unit 						               
select * from "dbo"."projections_access_modules"				--	sub-modules of projections         
select * from "dbo"."projections_closed_period_controls"  		--	controls the periods with set status = 1/0 
select * from "dbo"."projections_logs"							--	transitional table
select * from "dbo"."projections_fraccion_defs"				--	group fractions catalog
select * from "dbo"."projections_fraccion_groups"				--	grouping fractions module by catalog

-- ============================================================ --
-- 						    views								--
-- ============================================================ --

select * from "dbo"."projections_view_company_fractions"		-- fractions definitions by company     
select * from "dbo"."projections_view_indicators_periods"    	--	final result to show by month
select * from "dbo"."projections_view_bussiness_units"			--	units by corporate(database) and id_area       
select * from "dbo"."projections_view_indicadores_temporal"  	--	?? with no use 
--select * from "dbo"."projections_view_closed_periods" 			-- 	don't use it        
select * from "dbo"."projections_view_closed_period_units"   	--	select the current closed period status set to true    
select * from "dbo"."projections_view_fractions"				-- 	fractions by company


-- ============================================================ --
-- 						    engine 		 						--
-- ============================================================ --

use sistemas
select 'projections_upt_indops' as 'table', count(id) as 'count' from "sistemas"."dbo"."projections_upt_indops" 				--	9324              		
union
select 'projections_upt_cancelations' as 'table', count(id) as 'count' from "sistemas"."dbo"."projections_upt_cancelations"			--	4				      
union
select 'projections_dissmiss_cancelations' as 'table', count(id) as 'count' from "sistemas"."dbo"."projections_dissmiss_cancelations"		--	44		
union
select 'projections_closed_period_datas' as 'table', count(id) as 'count' from "sistemas"."dbo"."projections_closed_period_datas"		--	91543    		
union 
select 'projections_cancelations' as 'table', count(id) as 'count' from "sistemas"."dbo"."projections_cancelations"		--	91543    		
union
select 'projections_closed_period_controls' as 'table', count(id) as 'count' from "sistemas"."dbo"."projections_closed_period_controls"

--4780 2017-feb Accepted // 64 2017-feb Canceled

select * from sistemas.dbo.projections_closed_period_datas


select * from sistemas.dbo.projections_cancelations

select * from sistemas.dbo.projections_view_indicators_periods
select * from sistemas.dbo.projections_view_closed_period_units

select * from "sistemas"."dbo"."projections_dissmiss_cancelations"		--	44
select * from "sistemas"."dbo"."projections_upt_cancelations"			--	4


-- ============================================================ --
-- 						    testing 		 					--
-- ============================================================ --

truncate table sistemas.dbo.projections_upt_indops
truncate table sistemas.dbo.projections_upt_cancelations
truncate table sistemas.dbo.projections_dissmiss_cancelations
truncate table sistemas.dbo.projections_closed_period_datas
truncate table sistemas.dbo.projections_cancelations


truncate table sistemas.dbo.projections_closed_period_controls




