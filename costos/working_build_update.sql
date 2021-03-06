/**query for know period of updates*/
select * from sistemas.dbo.view_sp_watch_jobs_monitors where _status = '1'


-- /**generate the data*/
--======================== Updating ==========================

 

exec sistemas.dbo.sp_build_mr_accounts 'TBKGDL','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';

exec sistemas.dbo.sp_build_mr_accounts 'TBKHER','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';

exec sistemas.dbo.sp_build_mr_accounts 'TBKLAP','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';

exec sistemas.dbo.sp_build_mr_accounts 'TBKORI','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
  
exec sistemas.dbo.sp_build_mr_accounts 'TBKRAM','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
   
exec sistemas.dbo.sp_build_mr_accounts 'TBKTIJ','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';

exec sistemas.dbo.sp_build_mr_accounts 'ATMMAC','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
 
exec sistemas.dbo.sp_build_mr_accounts 'TEICUA','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';

exec sistemas.dbo.sp_build_mr_accounts 'TCGTUL','0|7|8',0,'2017','OF|OV|MF|MV|AD','|';
 
-- ================================================================================ --

--exec sistemas.dbo.sp_build_mr_accounts 'ATMMAC','0|7|8',0,'2017','AD','|';



/** FROM HIR TO UPDATE ACCOUNTS **/

select * from
--- delete 
sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where period in ('201703') --and source_company = 'TCGTUL'

-- insert into sistemas.dbo.mr_source_periods_accounts_dinamycs_temps

select distinct
		--MIN(id) as 'begin' ,MAX(id) as 'end' , COUNT (id) as 'count',
		
		SUBSTRING(SubAccount,1,10) as 'account',
		SUBSTRING(SubAccount,11,7) as 'segment',
		SUBSTRING(SubAccount,18,2) as 'unit',
		SUBSTRING(SubAccount,20,2) as 'cost_center',
		(select ('201703')) as '_period',
 		company,
		source_company,_key,(select 1 ) as _status 
from 
		sistemas.dbo.mr_source_accounts_temps
--		--mr_source_main_accounts_dinamycs_temps 
--where _key = 'OF'
	--and source_company = 'TEICUA'
--	SUBSTRING(SubAccount,1,10) = '0501151200'
--	and SUBSTRING(SubAccount,18,2) = 'AQ'
--	and SUBSTRING(SubAccount,20,2) = 'TA'
group by 
		source_company ,_key,company,SUBSTRING(SubAccount,1,10),SUBSTRING(SubAccount,18,2),SUBSTRING(SubAccount,20,2),SUBSTRING(SubAccount,11,7)
order by
		SUBSTRING(SubAccount,1,10),source_company,_key


/** update already the report */
use sistemas; -- 
	exec sistemas.dbo.sp_build_mr_view_accounts '20170','TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA|TCGTUL','OF|OV|MF|MV|AD','|';
	
  -- exec sistemas.dbo.sp_build_mr_view_accounts '20170','TCGTUL','OF|OV|MF|MV|AD','|';

/** Watch the costos */

		select * from sistemas.dbo.mr_view_monitor_costos 
		where _period in ('201702') and _company in ('TBKGDL','TBKLAP','TBKHER','TBKORI','TBKRAM','TBKTIJ','ATMMAC','TEICUA','TCGTUL') and _key in ('OF','OV','MF','MV','AD')
		order by _company,_key,_period;

/** check an account*/
   
		select * from sistemas.dbo.mr_source_reports_temps
		where _period in ('201701') and _company in ('TEICUA') and _key in ('OF')
    	and substring(distinto,8,4) = 'EAAF'

--- ==== check entitie ====== ---
  select distinct idbase 
  from [integraapp].[dbo].[xrefcia] -- where idsl in ('TBKORI')
  where idsl in (
                  'TEICUA'
                )
--- ==== check company ====== ---
  select [cpnyid]
  from [integraapp].[dbo].[frl_entity]
  where substring('TEICUA',1,3) = substring(cpnyid,1,3)
  

-- =============================== Create Views ==================================== --

/*
use integraapp;
IF OBJECT_ID ('fetchCostosAll', 'V') IS NOT NULL
    DROP VIEW fetchCostosAll;
--GO

create view fetchCostosAll
with encryption
as

select
         Mes, NoCta, NombreCta, PerEnt, Compañía, Tipo, Entidad, distinto,tipoTransacción
        ,Referencia, FechaTransacción, Descripción, Abono,Cargo,UnidadNegocio,CentroCosto
        ,NombreEntidad,(Cargo-Abono) as 'Real' , Presupuesto,SUBSTRING(_period, 1, 4) AS 'Año',_key,_company
from
        sistemas.dbo.mr_source_reports
        
where
      SUBSTRING(_period, 1, 4) >= 2017
--        _key = 'OF' AND _company = 'TCGTUL';

*/

