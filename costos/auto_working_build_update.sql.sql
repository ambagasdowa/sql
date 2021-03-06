/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : September 20, 2016
 Description    : process for Update the "costos xls" files -- 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.6
 ===============================================================================*/
 
-- ====================================== NOTES ========================================================
-- execute this scripts step by step for don't mess the things
-- use sistemas
-- exec sistemas.dbo.sp_builder_mr_periods_accounts "20170", "29", "|";
-- ====================================== CANCELATIONS ================================================

/**query for know period of the job's updates*/
select * from sistemas.dbo.view_sp_watch_jobs_monitors where _status = '1'

--======================== Updating ==========================
-- execute one by one
--======================== Updating ==========================

--exec sistemas.dbo.sp_build_mr_accounts 'TBKLAP','0|7|8',0,'2017','OV','|';
--exec sistemas.dbo.sp_build_mr_accounts 'TBKLAP','0|7|8',0,'2017','MF','|';
--exec sistemas.dbo.sp_build_mr_accounts 'TBKLAP','0|7|8',0,'2017','MV','|';
--exec sistemas.dbo.sp_build_mr_accounts 'TBKLAP','0|7|8',0,'2017','OV','|';
exec sistemas.dbo.sp_build_mr_accounts 'TBKLAP','0|7|8',0,'2017','AD','|';


--exec sistemas.dbo.sp_build_mr_accounts 'TBKGDL','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
--exec sistemas.dbo.sp_build_mr_accounts 'TBKHER','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
--exec sistemas.dbo.sp_build_mr_accounts 'TBKLAP','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
--exec sistemas.dbo.sp_build_mr_accounts 'TBKORI','0|7|8',0,'2017','OF|OV|MF|MV|AD','|'; 
--exec sistemas.dbo.sp_build_mr_accounts 'TBKRAM','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';  
--exec sistemas.dbo.sp_build_mr_accounts 'TBKTIJ','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
--exec sistemas.dbo.sp_build_mr_accounts 'ATMMAC','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
--exec sistemas.dbo.sp_build_mr_accounts 'TEICUA','0|7|8',0,'2017','AD','|';
--exec sistemas.dbo.sp_build_mr_accounts 'TCGTUL','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
 

-- ===================  Delete oldest dataset =========================== --

select * from 

-- delete
sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where period in 
												(
													select * from openquery(
																				local,'exec sistemas.dbo.sp_builder_mr_periods_accounts "20170", "29", "|";'
																			  )
												) 

-- ===================  Insert the new dataset =========================== --												

-- insert into sistemas.dbo.mr_source_periods_accounts_dinamycs_temps
select 
		 per_data.account
		,per_data.segment
		,per_data.unit
		,per_data.cost_center
		,periods.config_period as '_period' 
     	,per_data.company
	    ,per_data.source_company
     	,per_data._key
		,per_data._status
from openquery(
	local,'exec sistemas.dbo.sp_builder_mr_periods_accounts "20170", "29", "|";'
  ) as periods
  left join (		
				select distinct				
						SUBSTRING(SubAccount,1,10) as 'account',
						SUBSTRING(SubAccount,11,7) as 'segment',
						SUBSTRING(SubAccount,18,2) as 'unit',
						SUBSTRING(SubAccount,20,2) as 'cost_center',
				 		company,
						source_company,_key,(select 1 ) as _status 
				from 
						sistemas.dbo.mr_source_accounts_temps
				group by 
						source_company ,_key,company,SUBSTRING(SubAccount,1,10),SUBSTRING(SubAccount,18,2),SUBSTRING(SubAccount,20,2),SUBSTRING(SubAccount,11,7)
			) as per_data on 1 = 1   -- and why one equal to one ? ... why not ? XD

-- ===================  Update the Report accounts  =========================== --
												
	exec sistemas.dbo.sp_build_mr_view_accounts '20170','TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA|TCGTUL','AD','|';
	exec sistemas.dbo.sp_build_mr_view_accounts '20170','TEICUA','AD','|';
	
-- ===================  Watch the costos resultset  =========================== --												
	
		select * from sistemas.dbo.mr_view_monitor_costos 
		where _period in 
						(
							select * from openquery(
														local,'exec sistemas.dbo.sp_builder_mr_periods_accounts "20170", "17", "|";'
													  )
						) 
			and _company in ('TBKGDL','TBKLAP','TBKHER','TBKORI','TBKRAM','TBKTIJ','ATMMAC','TEICUA','TCGTUL') 
			and _key in ('OF','OV','MF','MV','AD')
		order by _company,_key,_period;

		
-- ============================================================================== --												
-- 							search some resultset		
-- ============================================================================== --												
		

