use tempdb
select (size*8) as FileSizeKB,type_desc,name,max_size from sys.database_files
   go

   --dbcc shrinkfile (tempdev, 'target size in MB')
   --go
   -- this command shrinks the primary data file

   dbcc shrinkfile (templog, 100000)
   go
   -- this command shrinks the log file, examine the last paragraph.




--The another option you can try is to use WITH TRUNCATE_ONLY:

BACKUP LOG  databasename  WITH TRUNCATE_ONLY
DBCC SHRINKFILE (  adventureworks_Log, 1)

--but don't try this option in live environment, the far better option is to set database in simple recovery. see the below command to do this:

ALTER DATABASE mydatabase SET RECOVERY SIMPLE
 DBCC SHRINKFILE (adventureworks_Log, 1)


--For SQL Server 2008, the command is:

ALTER DATABASE ExampleDB SET RECOVERY SIMPLE
DBCC SHRINKFILE('ExampleDB_log', 0, TRUNCATEONLY)

--This reduced my 14GB log file down to 1MB.

-- ===================================== this is the sprite for truncate logs ================================================ --


SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'integraapp');
--GO

use integraapp
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE integraapp SET RECOVERY SIMPLE
DBCC SHRINKFILE('integraapp_Log', 0, TRUNCATEONLY)
--dbcc shrinkfile ('templog') -- shrink log file
--ALTER DATABASE pruebasbonampak SET RECOVERY SIMPLE
--DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)
ALTER DATABASE integraapp SET RECOVERY FULL

use integraapp
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

-- report the new file sizes
-- SELECT name, size
-- FROM sys.master_files
-- WHERE database_id = DB_ID(N'integraapp');
-- GO


use integrapruebas
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE integrapruebas SET RECOVERY SIMPLE
DBCC SHRINKFILE('integraapp_Log', 0, TRUNCATEONLY)
ALTER DATABASE integrapruebas SET RECOVERY FULL

use integrapruebas
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files



use teisasaldossys
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


ALTER DATABASE teisasaldossys SET RECOVERY SIMPLE
	DBCC SHRINKFILE('integrasys_Log', 0, TRUNCATEONLY)
ALTER DATABASE teisasaldossys SET RECOVERY FULL;

use teisasaldossys
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files




-- ===================================== Truncate log for sltestappdata ================================================ --

--SELECT name, size
--FROM sys.master_files
--WHERE database_id = DB_ID(N'bonampakdb');
-- GO

use sltestapp;
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE sltestapp SET RECOVERY SIMPLE
DBCC SHRINKFILE('integraapp_Log', 0, TRUNCATEONLY)
ALTER DATABASE sltestapp SET RECOVERY FULL;

use sltestapp;
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
-- report the new file sizes

-- ===================================== Truncate log for sltestappdata ================================================ --

use sltestsys;
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE sltestsys SET RECOVERY SIMPLE

DBCC SHRINKFILE('integrasys_Log', 0, TRUNCATEONLY)

ALTER DATABASE sltestsys SET RECOVERY FULL;

use sltestsys;
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
-- report the new file sizes




-- ===================================== Truncate log for bonampakdb ================================================ --



use bonampakdb
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE bonampakdb SET RECOVERY SIMPLE
DBCC SHRINKFILE('lis530_log', 0, TRUNCATEONLY)
DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)
ALTER DATABASE bonampakdb SET RECOVERY FULL;

use bonampakdb
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use macuspanadb
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE macuspanadb SET RECOVERY SIMPLE
DBCC SHRINKFILE('lis530_log', 0, TRUNCATEONLY)
DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)
ALTER DATABASE macuspanadb SET RECOVERY FULL;

use macuspanadb
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use tespecializadadb
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE tespecializadadb SET RECOVERY SIMPLE
DBCC SHRINKFILE('lis530_log', 0, TRUNCATEONLY)
DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)
ALTER DATABASE tespecializadadb SET RECOVERY FULL;

use tespecializadadb
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files







-- ===================================== Truncate log for NOM2001 ================================================ --

SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'NOM2001');
--GO

use NOM2001
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE NOM2001 SET RECOVERY SIMPLE
DBCC SHRINKFILE('NOM2001_log', 0, TRUNCATEONLY)
ALTER DATABASE NOM2001 SET RECOVERY FULL

use NOM2001
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

-- report the new file sizes
SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'NOM2001');



use NODI
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE NODI SET RECOVERY SIMPLE
DBCC SHRINKFILE('NODI_log', 0, TRUNCATEONLY)
ALTER DATABASE NODI SET RECOVERY FULL

use NODI
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


-- ===================================== Truncate log for sltestapp ================================================ --

--SELECT name, size
--FROM sys.master_files
--WHERE database_id = DB_ID(N'sltestapp');
-- GO

use integrasys
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE integrasys SET RECOVERY SIMPLE
DBCC SHRINKFILE('integrasys_Log', 0, TRUNCATEONLY)
--dbcc shrinkfile ('templog') -- shrink log file
--ALTER DATABASE pruebasbonampak SET RECOVERY SIMPLE
--DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)
ALTER DATABASE integrasys SET RECOVERY FULL
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

-- report the new file sizes
--SELECT name, size
--FROM sys.master_files
--WHERE database_id = DB_ID(N'sltestapp');


-- ===================================== Truncate log for sistemas ================================================ --

--SELECT name, size
--FROM sys.master_files
--WHERE database_id = DB_ID(N'sistemas');
--GO

-- Check if have a open transactions
--
--SELECT spid
--,kpid
--,login_time
--,last_batch
--,status
--,hostname
--,nt_username
--,loginame
--,hostprocess
--,cpu
--,memusage
--,physical_io
--FROM sys.sysprocesses
--WHERE cmd = 'KILLED/ROLLBACK'
--
--DBCC CheckDB ('sistemas' , REPAIR_ALLOW_DATA_LOSS)
--
--DBCC INPUTBUFFER (460)
--
--use master
--DBCC OPENTRAN ('sistemas')
--
--use sistemas
--exec sp_who2 'active'
--
--kill 460 WITH STATUSONLY
--
--exec sp_lock 460


use sistemas
	select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
		ALTER DATABASE sistemas SET RECOVERY SIMPLE
		DBCC SHRINKFILE('sistemas_log', 0, TRUNCATEONLY)
--		ALTER DATABASE sistemas SET RECOVERY full
	select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

-- report the new file sizes
-- SELECT name, size
-- FROM sys.master_files
-- WHERE database_id = DB_ID(N'sltestapp');
	
exec sp_who2 'Active'


DBCC CheckDB ('sistemas')
-- ===================================== Truncate log for integra_fiscal ================================================ --

--SELECT name, size
--FROM sys.master_files
--WHERE database_id = DB_ID(N'sistemas');
--GO

use integra_fiscal;
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE integra_fiscal SET RECOVERY SIMPLE
DBCC SHRINKFILE('integra_fiscal_log', 0, TRUNCATEONLY)
--dbcc shrinkfile ('templog') -- shrink log file
--ALTER DATABASE pruebasbonampak SET RECOVERY SIMPLE
--DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)

ALTER DATABASE integra_fiscal SET RECOVERY FULL;
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use test_integra_fiscal
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE test_integra_fiscal SET RECOVERY SIMPLE
	DBCC SHRINKFILE('integra_fiscal_log', 0, TRUNCATEONLY)
	
	ALTER DATABASE test_integra_fiscal SET RECOVERY FULL;
use test_integra_fiscal
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use integralogin
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE integralogin SET RECOVERY SIMPLE
		DBCC SHRINKFILE('integrasys_Log', 0, TRUNCATEONLY)	
	ALTER DATABASE integralogin SET RECOVERY FULL;
use integralogin
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use SaldosInicialesSys
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE SaldosInicialesSys SET RECOVERY SIMPLE
		DBCC SHRINKFILE('integrasys_Log', 0, TRUNCATEONLY)	
	ALTER DATABASE SaldosInicialesSys SET RECOVERY FULL;
use SaldosInicialesSys
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use MR
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

	ALTER DATABASE MR SET RECOVERY SIMPLE
	DBCC SHRINKFILE('MR_log', 0, TRUNCATEONLY)
	ALTER DATABASE MR SET RECOVERY FULL;

use MR
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use ManagementReporter
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

	ALTER DATABASE ManagementReporter SET RECOVERY SIMPLE
	DBCC SHRINKFILE('ManagementReporter_log', 0, TRUNCATEONLY)
	ALTER DATABASE ManagementReporter SET RECOVERY FULL

use ManagementReporter
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files


use FiscalApp
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

	ALTER DATABASE FiscalApp SET RECOVERY SIMPLE
	DBCC SHRINKFILE('integraapp_Log', 0, TRUNCATEONLY)
	ALTER DATABASE FiscalApp SET RECOVERY full
	
use FiscalApp
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files	



use intermedia
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

	ALTER DATABASE intermedia SET RECOVERY SIMPLE
	DBCC SHRINKFILE('intermedia_log', 0, TRUNCATEONLY)
	ALTER DATABASE intermedia SET RECOVERY full
	
use intermedia
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files	



use pruebassys
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE pruebassys SET RECOVERY SIMPLE
	DBCC SHRINKFILE('integrasys_Log', 0, TRUNCATEONLY)
	ALTER DATABASE pruebassys SET RECOVERY full
use pruebassys
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files	


use SaldosInicialesApp
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
	ALTER DATABASE SaldosInicialesApp SET RECOVERY SIMPLE
	DBCC SHRINKFILE('integraapp_Log', 0, TRUNCATEONLY)
	ALTER DATABASE SaldosInicialesApp SET RECOVERY full
use SaldosInicialesApp
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files	


--use
--select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files
--
--	ALTER DATABASE SaldosInicialesApp SET RECOVERY SIMPLE
--	DBCC SHRINKFILE('integraapp_Log', 0, TRUNCATEONLY)
--	ALTER DATABASE SaldosInicialesApp SET RECOVERY full
--use SaldosInicialesApp
--select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files	

-- =========================================== Check database storage ======================================================= --
use sistemas
SELECT RTRIM(name) AS [Segment Name], groupid AS [Group Id], filename AS [File Name],
            CAST(size/128.0 AS DECIMAL(10,2)) AS [Allocated Size in MB],
            CAST(FILEPROPERTY(name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)) AS [Space Used in MB],
            CAST([maxsize]/128.0 AS DECIMAL(10,2)) AS [Max in MB],
            CAST([maxsize]/128.0-(FILEPROPERTY(name, 'SpaceUsed')/128.0) AS DECIMAL(10,2)) AS [Available Space in MB],
            CAST((CAST(FILEPROPERTY(name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))/CAST([maxsize]/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) AS [Percent Used]
         FROM sysfiles
         ORDER BY groupid desc
         
         

