	
use sistemas

-- wacth my work-area

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


-- ================================================================================================================================= --
-- 													store-procedures																 --
-- ================================================================================================================================= --


--- =========== WARNING use with precaution 
exec sistemas.dbo.sp_xd3e_getFullCompanyOperations 
													'2017',	-- year or years (char) ex:'2016|2017' 
													'02',	-- month or months (char) ex: '01|02|03|04|05|06|07|08|09|10'
													 1,		-- companies (int) id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
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
														 1,		-- 1 means auto take date with current_timestamp , 0 means manual and take the defined values
														 0		-- 1 --> (risk) snaptshot mode 0  --> normal mode
--- =========== WARNING use with precaution


-- ==================== for canceled datas in canceled months just use month string as one element  
														 

-- ================================================================================================================================= --
-- 													tables and views																 --
-- ================================================================================================================================= --
use sistemas

-- ============================================================ --
-- 						    tables								--
-- ============================================================ --
select * from "sistemas"."dbo"."projections_upt_indops"             		--	fetched data closed and open periods --> projections_view_indicators_periods --> current accepted
select * from "sistemas"."dbo"."projections_upt_cancelations"				--	current month canceled cartas portes --> projections_view_indicators_periods --> current canceled      
select * from "sistemas"."dbo"."projections_dissmiss_cancelations"		--	snapshot of cancelations for closed periods  --> projections_view_indicators_periods --> historical canceled
select * from "sistemas"."dbo"."projections_closed_period_datas"    		--	period closed-open data detail --> projections_view_indicators_periods --> historical accepted 
select * from "sistemas"."dbo"."projections_global_corps"					--	group owner company           
select * from "sistemas"."dbo"."projections_corporations"					--	enterprises of the group           
select * from "sistemas"."dbo"."projections_controls_users"				--	control user module -- define which users have access to projections module 
select * from "sistemas"."dbo"."projections_systems_logs"           		--	systems logs
select * from "sistemas"."dbo"."projections_accesses"						--	sub-module access by user and bussiness unit 						               
select * from "sistemas"."dbo"."projections_access_modules"				--	sub-modules of projections         
select * from "sistemas"."dbo"."projections_closed_period_controls"  		--	controls the periods with set status = 1/0 
select * from "sistemas"."dbo"."projections_logs"							--	transitional table
-- ========================= for develop ================================ --
select * from "sistemas"."dbo"."projections_fraccion_defs"					--	group fractions catalog
select * from "sistemas"."dbo"."projections_fraccion_groups"				--	grouping fractions module by catalog -- this must to change to a view

select * from "sistemas"."dbo"."projections_type_configs"

select * from sistemas.dbo.projections_configs

|


select * from sistemas.dbo.projections_view_configurations



-- ============================================================ --
-- 						    views								--
-- ============================================================ --

select * from "sistemas"."dbo"."projections_view_company_fractions"		--  fractions definitions by company     
select * from "sistemas"."dbo"."projections_view_indicators_periods"    	--	final result to show by month
select * from "sistemas"."dbo"."projections_view_bussiness_units"			--	units by corporate(database) and id_area       
select * from "sistemas"."dbo"."projections_view_indicadores_temporal"  	--	?? with no use 
--select * from "dbo"."projections_view_closed_periods" 			-- 	don't use it        
select * from "sistemas"."dbo"."projections_view_closed_period_units"   	--	select the currents and closed period with status set to true
select * from "sistemas"."dbo"."projections_view_fractions"				-- 	fractions by company


select * from sistemas.dbo.projections_view_closed_period_units --closed periods



select * from sistemas.dbo.projections_view_indicators_periods

where cyear ='2017' and mes = 'enero' and area = 'CUAUTITLAN' and fraccion = 'GRANEL'

select * from sistemas.dbo.projections_view_indicators_periods
where cyear ='2017' and mes = 'enero' and  area = 'ORIZABA' and fraccion = 'GRANEL'

select * from sistemas.dbo.projections_view_bussiness_units





-- ====================================== Detail ======================================= --

select * from sistemas.dbo.projections_view_indicators_periods 
where  cyear ='2017' and mes = 'Febrero' and  area = 'GUADALAJARA' --and dat.fraccion = 'PRODUCTOS VARIOS'

select * from 
		sistemas.dbo.projections_view_canceled_periods 
where 
		year(fecha_cancelacion) = '2017' and month(fecha_cancelacion) = '02'
	and	
		area = 'GUADALAJARA' and mes = 'Febrero' and id_fraccion = 5

select no_viaje,no_guia,fecha_guia,fecha_confirmacion,num_guia,id_unidad,personalnombre,sustituye_documento,status_guia,kms_guia,subtotal from bonampakdb.dbo.trafico_guia 
	where id_area = 2 
	and id_fraccion = 5 
	and year(fecha_guia) = '2017' 
	and month(fecha_guia) = '02'
	and status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|')) 
	and prestamo <> 'P'
	and tipo_doc = 2 





-- fecth thge 
--select
--	top 0 *
--from
--	sistemas.dbo.projections_configs


select * from sistemas.dbo.projections_view_indicators_periods_fleets
















