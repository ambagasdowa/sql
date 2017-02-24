-- ================================= Set Permissions to a user ================================== --
use sistemas

select
	'GRANT/REVOKE INSERT, UPDATE, SELECT, DELETE , EXECUTE ON "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '" TO "ambagasdowa"'
from
	information_schema.tables
where 
	TABLE_NAME like 'projections_%'
	

--  • If the securable is a scalar function, ALL means EXECUTE and REFERENCES.
--  • If the securable is a table-valued function, ALL means DELETE, INSERT, REFERENCES, SELECT, and UPDATE.
--  • If the securable is a stored procedure, ALL means EXECUTE.
--  • If the securable is a table, ALL means DELETE, INSERT, REFERENCES, SELECT, and UPDATE.
--  • If the securable is a view, ALL means DELETE, INSERT, REFERENCES, SELECT, and UPDATE.

--  If you want to give your user all read permissions, you could use:
  EXEC sp_addrolemember N'db_datareader', N'your-user-name'
--  That adds the default db_datareader role (read permission on all tables) to that user.
--  There's also a db_datawriter role - which gives your user all WRITE permissions (INSERT, UPDATE, DELETE) on all tables:
  EXEC sp_addrolemember N'db_datawriter', N'your-user-name'
--  If you need to be more granular, you can use the GRANT command:
  GRANT SELECT, INSERT, UPDATE ON dbo.YourTable TO YourUserName
  GRANT SELECT, INSERT ON dbo.YourTable2 TO YourUserName
  GRANT SELECT, DELETE ON dbo.YourTable3 TO YourUserName
--and so forth - you can granularly give SELECT, INSERT, UPDATE, DELETE permission on specific tables.
-- If you really want them to have ALL rights:
  use YourDatabase
  exec sp_addrolemember 'db_owner', 'UserName'
 
EXEC sp_addrolemember N'db_datareader', N'User1';

GRANT INSERT, UPDATE, SELECT, EXECUTE ON MyTable TO User1 --for multiples, it's   TO User1,User2

--If the securable is a database, ALL means BACKUP DATABASE, BACKUP LOG, CREATE DATABASE, CREATE DEFAULT, CREATE FUNCTION, CREATE PROCEDURE, CREATE RULE, CREATE TABLE, and CREATE VIEW.
-- Execute the following as a database owner
--The GRANT … WITH GRANT OPTION specifies that the security principal receiving the permission is given the ability to grant the specified permission to other security accounts.
--GRANT EXECUTE ON TestProc TO TesterRole WITH GRANT OPTION;
--EXEC sp_addrolemember TesterRole, User1;
-- Execute the following as User1
-- The following fails because User1 does not have the permission as the User1
--GRANT EXECUTE ON TestMe TO User2;
-- The following succeeds because User1 invokes the TesterRole membership
--GRANT EXECUTE ON TestMe TO User2 AS TesterRole;

-- ================================= About Procedures =========================== --
use integraapp
sp_helptext fetchCostosFijosMttoTultitlan

    select *
    from sistemas.information_schema.routines
    where routine_type = 'PROCEDURE'
    
	select *
	 from sistemas.information_schema.routines
	 where routine_type = 'PROCEDURE'
	 and Left(Routine_Name, 3) NOT IN ('sp_', 'xp_', 'ms_')
	 
use sistemas
SELECT
		name,type
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
		'TF' -- table-valued functions
		)
ORDER BY type, name


-- ================================= About Permissions =========================== --
sp_helpsrvrole

sp_helpsrvrolemember

use sistemas
select
		a.*,b.name
from sys.database_permissions a
inner join sys.database_principals b on a.grantee_principal_id = b.principal_id and b.name = 'cyberio'


-- =============================== Check permissions ============================= --
declare @user_name as varchar(120)
set @user_name = 'cyberio'


   SELECT [UserName] = ulogin.[name],
           [UserType]             = CASE princ.[type]
                             WHEN 'S' THEN 'SQL User'
                             WHEN 'U' THEN 'Windows User'
                             WHEN 'G' THEN 'Windows Group'
                        END,
           [DatabaseUserName]     = princ.[name],
           [Role]                 = NULL,
           [PermissionState]      = perm.[state_desc],
           [PermissionType]       = perm.[permission_name],
           [ObjectType]           = CASE perm.[class]
                               WHEN 1 THEN obj.type_desc -- Schema-contained objects
                               ELSE perm.[class_desc] -- Higher-level objects
                          END,
           [ObjectName]           = CASE perm.[class]
                               WHEN 1 THEN OBJECT_NAME(perm.major_id) -- General objects
                               WHEN 3 THEN schem.[name] -- Schemas
                               WHEN 4 THEN imp.[name] -- Impersonations
                          END,
           [ColumnName]           = col.[name]
    FROM   --database user
           sys.database_principals princ
           LEFT JOIN --Login accounts
                sys.server_principals ulogin
                ON  princ.[sid] = ulogin.[sid]
           LEFT JOIN --Permissions
                sys.database_permissions perm
                ON  perm.[grantee_principal_id] = princ.[principal_id]
           LEFT JOIN --Table columns
                sys.columns col
                ON  col.[object_id] = perm.major_id
                AND col.[column_id] = perm.[minor_id]
           LEFT JOIN sys.objects obj
                ON  perm.[major_id] = obj.[object_id]
           LEFT JOIN sys.schemas schem
                ON  schem.[schema_id] = perm.[major_id]
           LEFT JOIN sys.database_principals imp
                ON  imp.[principal_id] = perm.[major_id]
    WHERE  princ.[type] IN ('S', 'U', 'G')
           AND -- No need for these system accounts
               princ.[name] NOT IN ('sys', 'INFORMATION_SCHEMA')
           and 
           		princ.[name] = @user_name
    ORDER BY
           ulogin.[name],
           [UserType],
           [DatabaseUserName],
           [Role],
           [PermissionState],
           [PermissionType],
           [ObjectType],
           [ObjectName],
           [ColumnName]

-- ================================================================================= --

--permission
--Specifies a permission that can be granted on a schema-contained object. For a list of the permissions, see the Remarks section later in this topic.
--
--ALL
--Granting ALL does not grant all possible permissions. Granting ALL is equivalent to granting all ANSI-92 permissions applicable to the specified object. The
--meaning of ALL varies as follows:
--
--Scalar function permissions: EXECUTE, REFERENCES.
--
--Table-valued function permissions: DELETE, INSERT, REFERENCES, SELECT, UPDATE.
--
--Stored procedure permissions: EXECUTE.
--
--Table permissions: DELETE, INSERT, REFERENCES, SELECT, UPDATE.
--
--View permissions: DELETE, INSERT, REFERENCES, SELECT, UPDATE.

--PRIVILEGES
--Included for ANSI-92 compliance. Does not change the behavior of ALL.
--
--column
--Specifies the name of a column in a table, view, or table-valued function on which the permission is being granted. The parentheses ( ) are required. Only
--SELECT, REFERENCES, and UPDATE permissions can be granted on a column. column can be specified in the permissions clause or after the securable name.

--A. Granting SELECT permission on a table
--The following example grants SELECT permission to user RosaQdM on table Person.Address in the AdventureWorks2012 database.

USE AdventureWorks2012;
GRANT SELECT ON OBJECT::Person.Address TO RosaQdM;

--B. Granting EXECUTE permission on a stored procedure
--The following example grants EXECUTE permission on stored procedure HumanResources.uspUpdateEmployeeHireInfo to an application role called Recruiting11.

USE AdventureWorks2012;
GRANT EXECUTE ON OBJECT::HumanResources.uspUpdateEmployeeHireInfo
    TO Recruiting11;

--C. Granting REFERENCES permission on a view with GRANT OPTION
--The following example grants REFERENCES permission on column BusinessEntityID in view HumanResources.vEmployee to user Wanida with GRANT OPTION.

USE AdventureWorks2012;
GRANT REFERENCES (BusinessEntityID) ON OBJECT::HumanResources.vEmployee
    TO Wanida WITH GRANT OPTION;

--D. Granting SELECT permission on a table without using the OBJECT phrase
--The following example grants SELECT permission to user RosaQdM on table Person.Address in the AdventureWorks2012 database.

USE AdventureWorks2012;
GRANT SELECT ON Person.Address TO RosaQdM;

--E. Granting SELECT permission on a table to a domain account
--The following example grants SELECT permission to user AdventureWorks2012\RosaQdM on table Person.Address in the AdventureWorks2012 database.

USE AdventureWorks2012;
GRANT SELECT ON Person.Address TO [AdventureWorks2012\RosaQdM];

--F. Granting EXECUTE permission on a procedure to a role
--The following example creates a role and then grants EXECUTE permission to the role on procedure uspGetBillOfMaterials in the AdventureWorks2012 database.

USE AdventureWorks2012;
CREATE ROLE newrole ;
GRANT EXECUTE ON dbo.uspGetBillOfMaterials TO newrole ;


 -- ==================== database permissions ========================== --

--A. Granting permission to create tables
--The following example grants CREATE TABLE permission on the AdventureWorks database to user MelanieK.

USE AdventureWorks;
GRANT CREATE TABLE TO MelanieK;

--B. Granting SHOWPLAN permission to an application role
--The following example grants SHOWPLAN permission on the AdventureWorks2012 database to application role AuditMonitor.
--Applies to: SQL Server 2008 through SQL Server 2016, SQL Database.

USE AdventureWorks2012;
GRANT SHOWPLAN TO AuditMonitor;

--C. Granting CREATE VIEW with GRANT OPTION
--The following example grants CREATE VIEW permission on the AdventureWorks2012 database to user CarmineEs with the right to grant CREATE VIEW to other
--principals.

USE AdventureWorks2012;
GRANT CREATE VIEW TO CarmineEs WITH GRANT OPTION;

-- ================================= Create Logins ================================== --
use master
ALTER LOGIN cyberio

	WITH PASSWORD = '@Cyberi0#';
 
USE sistemas  -- use integraapp
  
CREATE USER cyberio FOR LOGIN cyberio;  
 
EXEC sp_addrolemember N'db_datareader', N'cyberio'

exec sp_droprolemember 'db_datareader','cyberio'

exec sp_helplogins 'enuma'

use integraapp
-- watch the role for users
exec sp_helpuser

-- set default db
EXEC sp_defaultdb 'cyberio', 'master';

-- ==== Granularity options ======== --

use bonampakdb
select
		'GRANT SELECT ON "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '" TO "cyberio"'
from
		information_schema.tables
where 
		TABLE_NAME like 'trafico_%'
--	and 
--		TABLE_TYPE = 'VIEW'/'BASE TABLE'

use sistemas
select
		'SELECT * FROM "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '' 
from
		information_schema.tables
where 
		TABLE_NAME like 'projections_%'
-- ================== output ========================== --

		-- Create a role
		use integraapp 
		CREATE ROLE projections AUTHORIZATION enuma;  
		
		-- set permissions on tables
		use sistemas
		exec sp_helprole
		
		-- add user to a role
		use integraapp
		exec sp_addrolemember 'projections' , 'cyberio'
		
		use bonampakdb
		GRANT SELECT ON "bonampakdb"."dbo"."general_area" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."trafico_producto" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."desp_flotas" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."desp_tipooperacion" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."trafico_configuracionviaje" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."trafico_renglon_guia" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."mtto_unidades" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."trafico_viaje" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."trafico_guia" TO "projections"
		GRANT SELECT ON "bonampakdb"."dbo"."trafico_cliente" TO "projections"
		
		use macuspanadb
		GRANT SELECT ON "macuspanadb"."dbo"."general_area" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."trafico_producto" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."desp_flotas" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."desp_tipooperacion" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."trafico_configuracionviaje" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."trafico_renglon_guia" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."mtto_unidades" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."trafico_viaje" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."trafico_guia" TO "projections"
		GRANT SELECT ON "macuspanadb"."dbo"."trafico_cliente" TO "projections"
		use tespecializadadb
		GRANT SELECT ON "tespecializadadb"."dbo"."general_area" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."trafico_producto" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."desp_flotas" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."desp_tipooperacion" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."trafico_configuracionviaje" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."trafico_renglon_guia" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."mtto_unidades" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."trafico_viaje" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."trafico_guia" TO "projections"
		GRANT SELECT ON "tespecializadadb"."dbo"."trafico_cliente" TO "projections"

		use integraapp
		GRANT SELECT ON "integraapp"."dbo"."zpoling" TO "projections"
		
		
		-- set permissions on views
		use sistemas
		
		GRANT SELECT   ON "dbo"."projections_view_company_fractions" TO "projections"   
		GRANT SELECT   ON "dbo"."projections_view_indicators_periods" TO "projections"  
		GRANT SELECT   ON "dbo"."projections_view_bussiness_units" TO "projections"     
		GRANT SELECT   ON "dbo"."projections_view_indicadores_temporal" TO "projections"
		GRANT SELECT   ON "dbo"."projections_view_closed_periods" TO "projections"      
		GRANT SELECT   ON "dbo"."projections_view_closed_period_units" TO "projections" 
		GRANT SELECT   ON "dbo"."projections_view_fractions" TO "projections"           
		
		-- set rw on tables use sistemas

		GRANT INSERT, UPDATE, SELECT, DELETE, ALTER ON "dbo"."projections_upt_indops" TO "projections"             
		GRANT INSERT, UPDATE, SELECT, DELETE, ALTER ON "dbo"."projections_upt_cancelations" TO "projections"       
		GRANT INSERT, UPDATE, SELECT, DELETE, ALTER ON "dbo"."projections_dissmiss_cancelations" TO "projections"  
		GRANT INSERT, UPDATE, SELECT, DELETE, ALTER ON "dbo"."projections_cancelations" TO "projections"  
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_global_corps" TO "projections"           
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_corporations" TO "projections"           
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_controls_users" TO "projections"         
		GRANT INSERT, UPDATE, SELECT, DELETE, ALTER ON "dbo"."projections_systems_logs" TO "projections"           
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_accesses" TO "projections"               
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_access_modules" TO "projections"         
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_closed_period_controls" TO "projections" 
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_closed_period_datas" TO "projections"    
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_logs" TO "projections"                   
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_fraccion_defs" TO "projections"          
		GRANT INSERT, UPDATE, SELECT, DELETE ON "dbo"."projections_fraccion_groups" TO "projections"        
		
		-- Alter in table is the minimal for truncate it
		
		-- set execution on procedures		
		GRANT EXECUTE ON "dbo"."sp_xd3e_getFullCompanyOperations" TO "projections"
		GRANT EXECUTE ON "dbo"."sp_xd4e_fullByMonthCompanyOperations" TO "projections"
		GRANT EXECUTE ON "dbo"."sp_projections_log_lv9" TO "projections"
		-- set execution permissions on table function
		GRANT SELECT ON "dbo"."fnSplit" TO "projections"
		
		
	-- list menbers of a role
	exec sp_helprolemember 'projections'
	  

-- ================== Add role example ========================== --
use tespecializadadb 
CREATE ROLE [projections] AUTHORIZATION enuma;



-- ================================================================================== --
CREATE LOGIN enuma
--    WITH PASSWORD = '340$Uuxwp7Mcxo7Khy';
    WITH PASSWORD = '@Elish#';

use integraapp
CREATE USER enuma FOR LOGIN enuma;

EXEC sp_addrolemember 'db_owner', 'enuma'
exec sp_droprolemember 'db_owner','enuma'
    



-- ================================================================================== --
ALTER LOGIN miguelteisa
--    WITH PASSWORD = '340$Uuxwp7Mcxo7Khy';
    WITH PASSWORD = '310$Uuxwp7Mcxo7Khy';
USE sistemas;  -- use integraapp
--GO  
CREATE USER miguelteisa FOR LOGIN miguelteisa;  
--GO   

-- ================================================================================== --


-- ============================== Auditing ===================================== --

 --Script source found at :  http://stackoverflow.com/a/7059579/1387418
/*
 Security Audit Report
 1) List all access provisioned to a sql user or windows user/group directly
 2) List all access provisioned to a sql user or windows user/group through a database or application role
 3) List all access provisioned to the public role

 Columns Returned:
 UserName        : SQL or Windows/Active Directory user cccount.  This could also be an Active Directory group.
 UserType        : Value will be either 'SQL User' or 'Windows User'.  This reflects the type of user defined for the
                   SQL Server user account.
 DatabaseUserName: Name of the associated user as defined in the database user account.  The database user may not be the
                   same as the server user.
 Role            : The role name.  This will be null if the associated permissions to the object are defined at directly
                   on the user account, otherwise this will be the name of the role that the user is a member of.
 PermissionType  : Type of permissions the user/role has on an object. Examples could include CONNECT, EXECUTE, SELECT
                   DELETE, INSERT, ALTER, CONTROL, TAKE OWNERSHIP, VIEW DEFINITION, etc.
                   This value may not be populated for all roles.  Some built in roles have implicit permission
                   definitions.
 PermissionState : Reflects the state of the permission type, examples could include GRANT, DENY, etc.
                   This value may not be populated for all roles.  Some built in roles have implicit permission
                   definitions.
 ObjectType      : Type of object the user/role is assigned permissions on.  Examples could include USER_TABLE,
                   SQL_SCALAR_FUNCTION, SQL_INLINE_TABLE_VALUED_FUNCTION, SQL_STORED_PROCEDURE, VIEW, etc.
                   This value may not be populated for all roles.  Some built in roles have implicit permission
                   definitions.
 ObjectName      : Name of the object that the user/role is assigned permissions on.
                   This value may not be populated for all roles.  Some built in roles have implicit permission
                   definitions.
 ColumnName      : Name of the column of the object that the user/role is assigned permissions on. This value
                   is only populated if the object is a table, view or a table value function.
 */

   --List all access provisioned to a sql user or windows user/group directly
     SELECT
         [UserName] = CASE princ.[type]
                         WHEN 'S' THEN princ.[name]
                         WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                      END,
         [UserType] = CASE princ.[type]
                         WHEN 'S' THEN 'SQL User'
                         WHEN 'U' THEN 'Windows User'
                      END,
         [DatabaseUserName] = princ.[name],
         [Role] = null,
         [PermissionType] = perm.[permission_name],
         [PermissionState] = perm.[state_desc],
         [ObjectType] = obj.type_desc,--perm.[class_desc],
         [ObjectName] = OBJECT_NAME(perm.major_id),
         [ColumnName] = col.[name]
     FROM
         --database user
         sys.database_principals princ
     LEFT JOIN
         --Login accounts
         sys.login_token ulogin on princ.[sid] = ulogin.[sid]
     LEFT JOIN
         --Permissions
         sys.database_permissions perm ON perm.[grantee_principal_id] = princ.[principal_id]
     LEFT JOIN
         --Table columns
         sys.columns col ON col.[object_id] = perm.major_id
                         AND col.[column_id] = perm.[minor_id]
     LEFT JOIN
         sys.objects obj ON perm.[major_id] = obj.[object_id]
     WHERE
         princ.[type] in ('S','U')
     UNION
    --List all access provisioned to a sql user or windows user/group through a database or application role
     SELECT
         [UserName] = CASE memberprinc.[type]
                         WHEN 'S' THEN memberprinc.[name]
                         WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
    				  END,
         [UserType] = CASE memberprinc.[type]
                         WHEN 'S' THEN 'SQL User'
                         WHEN 'U' THEN 'Windows User'
                      END,
         [DatabaseUserName] = memberprinc.[name],
         [Role] = roleprinc.[name],
         [PermissionType] = perm.[permission_name],
         [PermissionState] = perm.[state_desc],
         [ObjectType] = obj.type_desc,--perm.[class_desc],
         [ObjectName] = OBJECT_NAME(perm.major_id),
         [ColumnName] = col.[name]
     FROM
         --Role/member associations
         sys.database_role_members members
     JOIN
         --Roles
         sys.database_principals roleprinc ON roleprinc.[principal_id] = members.[role_principal_id]
     JOIN
         --Role members (database users)
         sys.database_principals memberprinc ON memberprinc.[principal_id] = members.[member_principal_id]
     LEFT JOIN
         --Login accounts
         sys.login_token ulogin on memberprinc.[sid] = ulogin.[sid]
     LEFT JOIN
         --Permissions
         sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
     LEFT JOIN
         --Table columns
         sys.columns col on col.[object_id] = perm.major_id
                         AND col.[column_id] = perm.[minor_id]
     LEFT JOIN
         sys.objects obj ON perm.[major_id] = obj.[object_id]
     UNION
   --List all access provisioned to the public role, which everyone gets by default
     SELECT
         [UserName] = '{All Users}',
         [UserType] = '{All Users}',
         [DatabaseUserName] = '{All Users}',
         [Role] = roleprinc.[name],
         [PermissionType] = perm.[permission_name],
         [PermissionState] = perm.[state_desc],
         [ObjectType] = obj.type_desc,--perm.[class_desc],
         [ObjectName] = OBJECT_NAME(perm.major_id),
         [ColumnName] = col.[name]
     FROM
         --Roles
         sys.database_principals roleprinc
     LEFT JOIN
         --Role permissions
         sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
     LEFT JOIN
         --Table columns
         sys.columns col on col.[object_id] = perm.major_id
                         AND col.[column_id] = perm.[minor_id]
     JOIN
         --All objects
         sys.objects obj ON obj.[object_id] = perm.[major_id]
     WHERE
         --Only roles
         roleprinc.[type] = 'R' AND
         --Only public role
         roleprinc.[name] = 'public' AND
         --Only objects of ours, not the MS objects
         obj.is_ms_shipped = 0
    ORDER BY
         princ.[Name],
         OBJECT_NAME(perm.major_id),
         col.[name],
         perm.[permission_name],
         perm.[state_desc],
         obj.type_desc--perm.[class_desc]

