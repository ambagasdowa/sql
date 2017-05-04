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
--go
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE integraapp SET RECOVERY SIMPLE
DBCC SHRINKFILE('integraapp_Log', 0, TRUNCATEONLY)
--dbcc shrinkfile ('templog') -- shrink log file
--ALTER DATABASE pruebasbonampak SET RECOVERY SIMPLE
--DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)

ALTER DATABASE integraapp SET RECOVERY FULL

--use integraapp
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

-- report the new file sizes
--SELECT name, size
--FROM sys.master_files
--WHERE database_id = DB_ID(N'integraapp');
--GO



-- ===================================== Truncate log for bonampakdb ================================================ --


SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'bonampakdb');
-- GO

use bonampakdb;
-- go
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE bonampakdb SET RECOVERY SIMPLE
DBCC SHRINKFILE('lis530_log', 0, TRUNCATEONLY)
DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)
--dbcc shrinkfile ('templog') -- shrink log file
--ALTER DATABASE pruebasbonampak SET RECOVERY SIMPLE
--DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)

ALTER DATABASE bonampakdb SET RECOVERY FULL;

use bonampakdb;
-- go
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

-- report the new file sizes
SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'bonampakdb');
-- GO


-- ===================================== Truncate log for NOM2001 ================================================ --

SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'NOM2001');
--GO

use NOM2001;
--go
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE NOM2001 SET RECOVERY SIMPLE
DBCC SHRINKFILE('NOM2001_log', 0, TRUNCATEONLY)
--dbcc shrinkfile ('templog') -- shrink log file
--ALTER DATABASE pruebasbonampak SET RECOVERY SIMPLE
--DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)

ALTER DATABASE NOM2001 SET RECOVERY FULL;

use NOM2001;
--go
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

-- report the new file sizes
SELECT name, size
FROM sys.master_files
WHERE database_id = DB_ID(N'NOM2001');


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

use sistemas
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

ALTER DATABASE sistemas SET RECOVERY SIMPLE
DBCC SHRINKFILE('sistemas_log', 0, TRUNCATEONLY)
--dbcc shrinkfile ('templog') -- shrink log file
--ALTER DATABASE pruebasbonampak SET RECOVERY SIMPLE
--DBCC SHRINKFILE('lis530_log1', 0, TRUNCATEONLY)

ALTER DATABASE sistemas SET RECOVERY FULL
select (size*8) as FileSizeKB,((size*8)/1024) as MB,((size*8)/1024)/1024 as GB,type_desc,name,max_size,physical_name from sys.database_files

-- report the new file sizes
--SELECT name, size
--FROM sys.master_files
--WHERE database_id = DB_ID(N'sltestapp');



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





-- =========================================== Check database storage ======================================================= --

SELECT RTRIM(name) AS [Segment Name], groupid AS [Group Id], filename AS [File Name],
            CAST(size/128.0 AS DECIMAL(10,2)) AS [Allocated Size in MB],
            CAST(FILEPROPERTY(name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)) AS [Space Used in MB],
            CAST([maxsize]/128.0 AS DECIMAL(10,2)) AS [Max in MB],
            CAST([maxsize]/128.0-(FILEPROPERTY(name, 'SpaceUsed')/128.0) AS DECIMAL(10,2)) AS [Available Space in MB],
            CAST((CAST(FILEPROPERTY(name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))/CAST([maxsize]/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) AS [Percent Used]
         FROM sysfiles
         ORDER BY groupid desc
         
         

