--use pruebastbk
--SELECT
--		name,type
--		,case type
--			when	'P' 	then 	'Stored Procedures'
--			when	'FN' 	then	'Scalar Functions'
--			when	'IF'	then 	'Inline Table-Value Functions'
--			when	'TF'	then	'Table-Value Functions'
--			when	'TR'	then 	'Trigger'
--			when	'U'		then	'Base Table'
--			when	'V'		then	'View'
--		end as 'Type'
--FROM
--	dbo.sysobjects
--WHERE
--	type IN
--		(
--		'P', -- stored procedures
--		'FN', -- scalar functions
--		'IF', -- inline table-valued functions
--		'TF', -- table-valued functions
--		'TR',
--		'U',
--		'V'
--		)
--ORDER BY type, name

--exec sp_helptext tbk_calcula_sueldo_por_base2

--pruebastbk , trafico_guia_liquidacion , tbk_calcula_sueldo_por_base2
/*
use bonampakdb
SELECT name, is_disabled FROM sys.triggers
SELECT OBJECT_NAME(parent_id) [table_name],[name] [trigger_name],is_disabled
FROM sys.triggers
where OBJECT_NAME(parent_id) in ('trafico_guia_liquidacion','trafico_liquidacion')
*/

-- DISABLE TRIGGER tbk_calcula_sueldo_por_base ON trafico_liquidacion;
-- DISABLE TRIGGER tbk_calcula_sueldo_por_base2 ON trafico_guia_liquidacion;

--disable trigers 
--Para deshabilitar un desencadenador DDL con ámbito de servidor (ON ALL SERVER) o un desencadenador de inicio de sesión, el usuario debe tener el permiso
--CONTROL SERVER en el servidor. Para deshabilitar un desencadenador DDL con ámbito en la base de datos (ON DATABASE) el usuario debe contar, como mínimo, con
--un permiso ALTER ANY DATABASE DDL TRIGGER en la base de datos actual.
--
--Ejemplos
-- 
--━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--
--A. Deshabilitar un desencadenador DML en una tabla
--
--En el ejemplo siguiente se deshabilita el desencadenador uAddress, que se creó en la tabla Address.

USE AdventureWorks2012;
GO
DISABLE TRIGGER Person.uAddress ON Person.Address;
go


--B. Deshabilitar un desencadenador DDL
--
--En el ejemplo siguiente se crea un desencadenador DDL safety, con ámbito en la base de datos, y después se deshabilita.


IF EXISTS (SELECT * FROM sys.triggers
    WHERE parent_class = 0 AND name = 'safety')
DROP TRIGGER safety ON DATABASE;
GO
CREATE TRIGGER safety
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
   PRINT 'You must disable Trigger "safety" to drop or alter tables!'
   ROLLBACK;
GO
DISABLE TRIGGER safety ON DATABASE;
GO

--C. Deshabilitar todos los desencadenadores que se definieron con el mismo ámbito
--
--En el ejemplo siguiente se deshabilitan todos los desencadenadores DDL creados en el ámbito de servidor.

USE AdventureWorks2012;
GO
DISABLE Trigger ALL ON ALL SERVER;
GO
