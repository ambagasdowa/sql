-- install adventureswork db
-- CREATE DATABASE AdventureWorks2012 ON (FILENAME = 'C:\Data\AdventureWorks2008R2_Data.mdf'), (FILENAME = 'C:\Data\AdventureWorks2008R2_log.LDF') FOR ATTACH;

use AdventureWorks2012

SELECT
		name
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
		'U',  -- base table
		'V' -- view
		)
ORDER BY type, name

select * from Person.Address