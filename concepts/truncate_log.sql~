-- In management studio:
-- 
--     Don't do this on a live environment, but to ensure you shrink your dev db as much as you can:
--         Right-click the database, choose properties, then options.
--         Make sure "Recovery model" is set to "Simple", not "Full"
--         Click Ok
--     Right-click the database again, choose tasks -> shrink files
--     Change file type to "log"
--     Click ok.
-- 
-- Alternatively, the SQL to do it:

 ALTER DATABASE mydatabase SET RECOVERY SIMPLE
 DBCC SHRINKFILE (mydatabase_Log, 1)






-- Truncating a data file
-- 
-- The following example truncates the primary data file in the AdventureWorks database. The sys.database_files catalog view is queried to obtain the file_id of the data file.

USE AdventureWorks2012;  
GO  
SELECT file_id, name  
FROM sys.database_files;  
GO  
DBCC SHRINKFILE (1, TRUNCATEONLY);  