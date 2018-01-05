-- Get how many triggers have a table 
use NOM2001
SELECT 
     "obj".name AS trigger_name 
    ,USER_NAME("obj".uid) AS trigger_owner 
    ,s.name AS table_schema 
    ,OBJECT_NAME("obj".parent_obj) AS table_name 
    ,OBJECTPROPERTY( "obj".id, 'ExecIsUpdateTrigger') AS isupdate
    ,OBJECTPROPERTY( "obj".id, 'ExecIsDeleteTrigger') AS isdelete
    ,OBJECTPROPERTY( "obj".id, 'ExecIsInsertTrigger') AS isinsert
    ,OBJECTPROPERTY( "obj".id, 'ExecIsAfterTrigger') AS isafter
    ,OBJECTPROPERTY( "obj".id, 'ExecIsInsteadOfTrigger') AS isinsteadof
    ,OBJECTPROPERTY("obj".id, 'ExecIsTriggerDisabled') AS [disabled]
    ,"comment".[text] AS 'SqlContent'
FROM sysobjects as "obj"
INNER JOIN sysusers
    ON "obj".uid = sysusers.uid
INNER JOIN sys.syscomments as "comment"
	ON "obj".id = "comment".id
INNER JOIN sys.tables t
    ON "obj".parent_obj = t.object_id
INNER JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE "obj".[type] = 'TR'
	and OBJECT_NAME("obj".parent_obj) in ('trabajador')


use intermedia
SELECT
	name,"type"
	,case "type"
		when	'P' 	then 	'Stored Procedures'
		when	'FN' 	then	'Scalar Functions'
		when	'IF'	then 	'Inline Table-Value Functions'
		when	'TF'	then	'Table-Value Functions'
		when	'TR'	then 	'Trigger'
		when	'U'		then	'Base Table'
		when	'V'		then	'View'
	end as 'Type'
FROM
	dbo.sysobjects
WHERE
	type IN
		(
		'P', 	-- stored procedures
--		'FN', 	-- scalar functions
--		'IF', 	-- inline table-valued functions
--		'TF', 	-- table-valued functions
		'TR'   -- trigger
--		'U',  	-- Base table
--		'V'		-- View
		)
ORDER BY type, name
	

use bonampakdb
exec sp_helptext sp_interfase_personal

