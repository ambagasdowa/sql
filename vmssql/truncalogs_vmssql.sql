use integraapp
-- Case rounded
-- NOTE test this


select Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryDrAmt,TranDesc,* from integraapp.dbo.GLTran where BatNbr = '064735' and Module = 'AR'
union all
select Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryDrAmt,TranDesc,* from integraapp.dbo.GLTran where BatNbr = '086253' and Module = 'GL'

--
--  187994
--  select PerPost,FiscYr,Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryDrAmt,TranDesc,* from integraapp.dbo.GLTran where BatNbr = '187994'
--	balanza porky --
--	may 2015
--  187994 teisa
--  junio 2017
--
--  use integraapp
--  exec sp_helptext sp_udsp_getBalanzaComprobacion



use integraapp
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE integraapp SET RECOVERY SIMPLE
		DBCC SHRINKFILE('integraapp_Log', 0, TRUNCATEONLY)
	ALTER DATABASE integraapp SET RECOVERY FULL
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

use integrasys
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE integrasys SET RECOVERY SIMPLE
		DBCC SHRINKFILE('integrasys_Log', 0, TRUNCATEONLY)
	ALTER DATABASE integrasys SET RECOVERY FULL
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files



use sistemas
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE sistemas SET RECOVERY SIMPLE
DBCC SHRINKFILE('sistemas_log', 0, TRUNCATEONLY)

ALTER DATABASE sistemas SET RECOVERY FULL
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files



use ManagementReporter
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE ManagementReporter SET RECOVERY SIMPLE
		DBCC SHRINKFILE('ManagementReporter_log', 0, TRUNCATEONLY)
	ALTER DATABASE ManagementReporter SET RECOVERY FULL
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

use macuspanadb
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE macuspanadb SET RECOVERY SIMPLE
		DBCC SHRINKFILE('lis530_log', 0, TRUNCATEONLY)
		DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)
	ALTER DATABASE macuspanadb SET RECOVERY FULL
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use bonampakdb
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE bonampakdb SET RECOVERY SIMPLE
		DBCC SHRINKFILE('lis530_log', 0, TRUNCATEONLY)
		DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)
	ALTER DATABASE bonampakdb SET RECOVERY FULL
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


