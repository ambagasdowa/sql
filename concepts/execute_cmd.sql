use test_integraapp

SELECT
		"sys".name,"sys"."type"
		,case "sys".type
			when	'P' 	then 	'Stored Procedures'
			when	'FN' 	then	'Scalar Functions'
			when	'IF'	then 	'Inline Table-Value Functions'
			when	'TF'	then	'Table-Value Functions'
			when	'TR'	then 	'Trigger'
			when	'U'		then	'Base Table'
			when	'V'		then	'View'
		end as 'Type'
FROM
	dbo.sysobjects as "sys"
WHERE
	"sys"."type" IN
		(
		'P' 	-- stored procedures
--		'FN', 	-- scalar functions
--		'IF', 	-- inline table-valued functions
--		'TF', 	-- table-valued functions
--		'TR',   -- trigger
--		'U',  	-- Base table
--		'V'		-- View
		)
and "sys".name like 'xIN%'

ORDER BY "sys"."type", "sys".name

-- ================================================================================================================== --
-- The xp_cmdshell option is a SQL Server server configuration option that enables 
-- system administrators to control whether the xp_cmdshell extended stored procedure 
-- can be executed on a system. By default, the xp_cmdshell option is disabled on 
-- new installations and can be enabled by using the Policy-Based Management or by running the sp_configure 
-- system stored procedure as shown in the following code example:

-- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1  
--GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE  
--GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1
--GO  
-- To update the currently configured value for this feature.  
RECONFIGURE
--GO  

-- ================================================================================================================== --




EXECUTE AS LOGIN = '<other_login>' ;  
--GO  
xp_cmdshell 'whoami.exe' ;  
REVERT ;  



EXEC xp_cmdshell 'dir *.exe'; 


DECLARE @command VARCHAR(1000) 

SET @command = 'BCP "SELECT * from sys.objects" queryout "E:\MSSQL\extract\myfile_' + CONVERT(VARCHAR, YEAR(GETDATE())) + RIGHT('00' + CONVERT(VARCHAR, MONTH(GETDATE())), 2) + RIGHT('00' + CONVERT(VARCHAR, DAY(GETDATE())), 2) + '.txt" -c -T -t "|" '

EXEC xp_cmdshell @command



