use sistemas;
-----------------------------------------------------------------------------------------------------------
--	           	              deploy the dinamycs accounts                                               --
-----------------------------------------------------------------------------------------------------------
-- select * from mr_source_main_accounts_dinamycs_temps
-- select * from mr_source_periods_accounts_dinamycs_temps

--	declare @dinamyc_account as table 
--	(
--		--id							int identity(1,1),
--		account						nvarchar(10)		collate		sql_latin1_general_cp1_ci_as,
--		segment						nvarchar(7)			collate		sql_latin1_general_cp1_ci_as,
--		unit						nvarchar(2)			collate		sql_latin1_general_cp1_ci_as,
--		cost_center					nvarchar(2)			collate		sql_latin1_general_cp1_ci_as,
--		period						nvarchar(6)			collate		sql_latin1_general_cp1_ci_as,
--		company						nvarchar(6)			collate		sql_latin1_general_cp1_ci_as,
--		source_company				nvarchar(6)			collate		sql_latin1_general_cp1_ci_as,
--		_key						nvarchar(2)			collate		sql_latin1_general_cp1_ci_as
--		--_status						int default 1 null
--	)


----insert into @dinamyc_account
--insert into mr_source_main_accounts_dinamycs_temps

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Take from hir and build an procedure for construct the mr_source_periods_accounts_dinamycs_temps table 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
use sistemas; -- 
	exec sistemas.dbo.sp_build_mr_view_accounts '20170','TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA','OV','|'
go


use sistemas; -- 
	exec sistemas.dbo.sp_build_mr_view_accounts '20170','TCGTUL','OF|OV|sMF|MV|AD','|'
go
--rebuild current period
--select * from sistemas.dbo.mr_source_accounts_temps where  SUBSTRING(SubAccount,1,10) = '0501179900' and source_company = 'TBKHER' and SUBSTRING(SubAccount,18,2) = 'AL'  and _key = 'MF' and source_company = 'TBKHER' and SUBSTRING(SubAccount,20,2) = 'AF'
--select * from sistemas.dbo.mr_source_main_accounts_dinamycs_temps where account = '0501179900' and unit in ('AL') and company = 'TBKHER' and _key='MF' and cost_center = 'TA' order by cost_center
--select * from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where period = '201604' and account = '0501179900' and company = 'TBKHER' and unit='AL' and _key = 'MF' and cost_center = 'TA'  order by period
--select * from sistemas.dbo.mr_source_presupuestos_temps where _key = 'MF' and FiscYr = '2016'

		select * from sistemas.dbo.view_sp_watch_jobs_monitors where _status = '1'
		
		select * from sistemas.dbo.mr_view_monitor_costos 
		where _period in ('201701') and _company in ('TBKGDL','TBKLAP','TBKHER','TBKORI','TBKRAM','TBKTIJ','ATMMAC','TEICUA','TCGTUL') and _key in ('OF','OV','MF','MV','AD')
		order by _company,_key

	--select * from integraapp.dbo.fetchCostosAdministracionGstDin

	--select * from integraapp.dbo.fetchCostosAdministracionGst

-- Firts execute build accounts for refreshing accounts



 exec [dbo].[sp_build_mr_accounts]
	'TEICUA', -- for the moment only works with one company definition
	'0|7|8', -- set the entitie 0 = Granel , 7 = others , 8 = others
	0, -- truncate all tables on = 1 , off = 0 , specified tables are  dbo.mr_source_presupuestos* and dbo.mr_source_accounts*
	'201701', -- fetch the presup with the fiscal year 
	'AD', -- set Key limitation update
	'|'
 go


-- as Second truncate main accounts dinamycs and insert the current accounts
-- truncate table sistemas.dbo.mr_source_main_accounts_dinamycs_temps
-- Next delete and update records in current period  (this maybe can change)


-- then insert and refresh data
-- insert into sistemas.dbo.mr_source_main_accounts_dinamycs_temps
select distinct
		--MIN(id) as 'begin' ,MAX(id) as 'end' , COUNT (id) as 'count',
		
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
order by
		SUBSTRING(SubAccount,1,10),source_company,_key


*--277345
select * from sistemas.dbo.mr_source_accounts_temps where  _key = 'AD' and substring(SubAccount,18,2) = '00' and  substring(SubAccount,20,2) = '00' and source_company not in ('TEICUA','ATMMAC','TBKORI') 

select * from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where substring(period,1,4) in ('2016') and _key = 'AD' and cost_center = '00' and unit = '00' and source_company not in ('TEICUA','ATMMAC','TBKORI') 

select source_company,_key,period from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where period = '201609' and _key in ('MF') group by source_company,_key,period order by _key

/** FROM HIR TO UPDATE ACCOUNTS **/

select * from
--- delete 
sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where period in ('201701')

-- insert into sistemas.dbo.mr_source_periods_accounts_dinamycs_temps

select distinct
		--MIN(id) as 'begin' ,MAX(id) as 'end' , COUNT (id) as 'count',
		
		SUBSTRING(SubAccount,1,10) as 'account',
		SUBSTRING(SubAccount,11,7) as 'segment',
		SUBSTRING(SubAccount,18,2) as 'unit',
		SUBSTRING(SubAccount,20,2) as 'cost_center',
		(select ('201701')) as '_period',
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


-- next rebuild accounts

--exec sistemas.dbo.sp_build_mr_view_accounts '201603','TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ|ATMMAC|TEICUA','OF','|'
exec sistemas.dbo.sp_build_mr_view_accounts '201607','TBKRAM','OV','|'

-- watch the generated view

	select * from  sistemas.dbo.mr_source_reports where NoCta = '0501070300' and _company = 'TBKRAM' and mes = 'junio' and substring(entidad,1,11) = '00000000000' 
	select PerPost,CuryDrAmt,CuryCrAmt,* from integraapp.dbo.GLTran where Acct = '0501170300' and CpnyID = 'TEICUA' and Posted = 'P' and PerPost = '201603'  and sub = '000000000000000000000'

--0501010301 7000000 AIAF    
select * from 
--delete
sistemas.dbo.mr_source_accounts_temps where substring(SubAccount,18,2) = '00' and company not in  ('TBKORI','TEICUA','ATMMAC')

--select * from sistemas.dbo.mr_source_main_accounts_dinamycs_temps where _key = 'AD'

--select * from mr_source_main_accounts_dinamycs_temps where _key = 'AD'

-- select * from sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where substring(period,1,4) = '2016' and _key = 'AD' order by period 

--select * from sistemas.dbo.mr_source_mains where _key = 'AD'

--select * from sistemas.dbo.mr_source_deployment_accounts where account = '0501151200'

--select * from sistemas.dbo.mr_source_accounts_temps where substring(SubAccount,1,10) = '0501151200' and substring(SubAccount,18,2) = 'AQ' and substring(SubAccount,20,2) = '00' and source_company = 'TBKRAM' and _key='MV' 

select distinct idbase from [integraapp].[dbo].[xrefcia]

select [cpnyid] from [integraapp].[dbo].[frl_entity]


select Acct,Sub,* from integraapp.dbo.GLTran where Acct in ('0603010003','0604010000','0601160600') and PerPost = '201608' and CpnyID = 'ATMMAC'
select Acct,Sub,* from integraapp.dbo.GLTran where PerPost = '201608' and CpnyID = 'ATMMAC' and Sub = '000000000000000000000'
			  
select Acct,Sub,* from integraapp.dbo.GLTran where CpnyID = 'TBKRAM' and PerPost = '201608' and Acct = '0501151200' and substring(Sub,1,9) = '8000000AQ'
 
select * from integraapp.dbo.Account where Acct = '0501151200'

select * from integraapp.dbo.SubAcct where Sub like '7000000AQ%'



--insert into sistemas.dbo.mr_source_periods_accounts_dinamycs_temps values ('0501151200','7000000','AQ','00','201608','TBKRAM','TBKRAM','MV','1')

--delete sistemas.dbo.mr_source_periods_accounts_dinamycs_temps where id = '1008074'













select * from sistemas.dbo.mr_source_accounts_temps


select * from sistemas.dbo.mr_source_mains

select * from sistemas.dbo.mr_source_keys

select * from sistemas.dbo.mr_source_configs_temps



--insert into sistemas.dbo.mr_source_mains  values ('0501070100',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501080100',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501080200',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501080300',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501090100',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501090300',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501090400',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501100400',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501110100',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501110200',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501130200',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501130300',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501130400',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501170200',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501170400',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501170900',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501171100',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501010800',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0500000000','0503990000','aa','AE','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501070100',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501080100',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501080200',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501080300',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501090100',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501090300',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501090400',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501100400',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501110100',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501110200',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501130200',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501130300',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501130400',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501170200',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501170400',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501170900',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501171100',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501010800',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501040202',' ','000000',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501040202',' ','CS','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501030103',' ','AB',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501110500',' ',' ',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0501090700','0501090700',' ',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0503010003',' ',' ',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0601000000','0601179900','AA','ZZ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0603010003',' ',' ',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0601010100','0601179900','A1','A2','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0601040600',' ',' ',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0601160600',' ',' ',' ','AD','1')
--insert into sistemas.dbo.mr_source_mains  values ('0604010000',' ',' ',' ','AD','1')





use integraapp;
select * from sistemas.dbo.mr_view_monitor_costos where _period = '201608'
































--select * from NOM2001.dbo.getPayroll where nombre like '%luis%' and cvetra like '1000%';

--select * from NOM2001.dbo.nomtrab where cvetra = '1000681'


--SELECT p.name, o.name, d.*
--FROM sys.database_principals AS p
--JOIN sys.database_permissions AS d ON d.grantee_principal_id = p.principal_id
--JOIN sys.objects AS o ON o.object_id = d.major_id


--USE master
--GO
 
--SELECT  p.name AS [loginname] ,
--        p.type ,
--        p.type_desc ,
--        p.is_disabled,
--        CONVERT(VARCHAR(10),p.create_date ,101) AS [created],
--        CONVERT(VARCHAR(10),p.modify_date , 101) AS [update],*
--FROM    sys.server_principals p
--        JOIN sys.syslogins s ON p.sid = s.sid
--WHERE   p.type_desc IN ('SQL_LOGIN', 'WINDOWS_LOGIN', 'WINDOWS_GROUP')
--        -- Logins that are not process logins
--        AND p.name NOT LIKE '##%'
--        -- Logins that are sysadmins
--        AND s.sysadmin = 1
--GO

--EXEC sp_helpsrvrolemember 'sysadmin'

--EXEC sp_helpsrvrole

--xp_logininfo 'DEVCOMPUTER\SQLAdmins', 'members';


