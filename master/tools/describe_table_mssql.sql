USE master
-- GO

IF OBJECT_ID('sp_desc', 'P') IS NOT NULL
  DROP PROCEDURE sp_desc
-- GO

CREATE PROCEDURE sp_desc (
  @tableName  nvarchar(128)
) 
-- ================== from stackoverflow ========================== --
-- user : http://stackoverflow.com/users/1128025/zsolt-hidasi
-- ================== from stackoverflow ========================== --
--To execute the procedure type:
--EXEC sp_desc 'YourDB.YourSchema.YourTable';
--If you want to get a description an object of the current database (and schema) simple type:
--EXEC sp_desc 'YourTable';
--As sp_desc is a system marked procedure, you can even leave the exec command, too (not recommended anyway):
--sp_desc 'YourTable';


with encryption
AS
BEGIN
  DECLARE @dbName       sysname
  DECLARE @schemaName   sysname
  DECLARE @objectName   sysname
  DECLARE @objectID     int
  DECLARE @tmpTableName varchar(100)
  DECLARE @sqlCmd       nvarchar(4000)

  SELECT @dbName = PARSENAME(@tableName, 3)
  IF @dbName IS NULL SELECT @dbName = DB_NAME()

  SELECT @schemaName = PARSENAME(@tableName, 2)
  IF @schemaName IS NULL SELECT @schemaName = SCHEMA_NAME()

  SELECT @objectName = PARSENAME(@tableName, 1)
  IF @objectName IS NULL
    BEGIN
      PRINT 'Object is missing from your function call!'
      RETURN
    END

  SELECT @objectID = OBJECT_ID(@dbName + '.' + @schemaName + '.' + @objectName)
  IF @objectID IS NULL
    BEGIN
      PRINT 'Object [' + @dbName + '].[' + @schemaName + '].[' + @objectName + '] does not exist!'
      RETURN
    END

  SELECT @tmpTableName = '#tmp_DESC_' + CAST(@@SPID AS VARCHAR) + REPLACE(REPLACE(REPLACE(REPLACE(CAST(CONVERT(CHAR, GETDATE(), 121) AS VARCHAR), '-', ''), ' ', ''), ':', ''), '.', '')
  --PRINT @tmpTableName
  SET @sqlCmd = '
    USE ' + @dbName + '
    CREATE TABLE ' + @tmpTableName + ' (
      [NAME]              nvarchar(128) NOT NULL
     ,[TYPE]              varchar(50)
     ,[CHARSET]           varchar(50)
     ,[COLLATION]         varchar(50)
     ,[NULLABLE]          varchar(3)
     ,[DEFAULT]           nvarchar(4000)
     ,[COMMENTS]          nvarchar(3750))

    INSERT INTO ' + @tmpTableName + '
    SELECT
      a.[NAME]
     ,a.[TYPE]
     ,a.[CHARSET]
     ,a.[COLLATION]
     ,a.[NULLABLE]
     ,a.[DEFAULT]
     ,b.[COMMENTS]
    FROM
      (
        SELECT
          COLUMN_NAME                                     AS [NAME]
         ,CASE DATA_TYPE
            WHEN ''char''      THEN DATA_TYPE + ''('' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + '')''
            WHEN ''numeric''   THEN DATA_TYPE + ''('' + CAST(NUMERIC_PRECISION AS VARCHAR) + '', '' + CAST(NUMERIC_SCALE AS VARCHAR) + '')''
            WHEN ''nvarchar''  THEN DATA_TYPE + ''('' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + '')''
            WHEN ''varbinary'' THEN DATA_TYPE + ''('' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + '')''
            WHEN ''varchar''   THEN DATA_TYPE + ''('' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + '')''
            ELSE DATA_TYPE
          END                                             AS [TYPE]
         ,CHARACTER_SET_NAME                              AS [CHARSET]
         ,COLLATION_NAME                                  AS [COLLATION]
         ,IS_NULLABLE                                     AS [NULLABLE]
         ,COLUMN_DEFAULT                                  AS [DEFAULT]
         ,ORDINAL_POSITION
        FROM   
          INFORMATION_SCHEMA.COLUMNS
        WHERE   
          TABLE_NAME = ''' + @objectName + '''
      ) a
      FULL JOIN
      (
         SELECT
           CAST(value AS NVARCHAR)                        AS [COMMENTS]
          ,CAST(objname AS NVARCHAR)                      AS [NAME]
         FROM
           ::fn_listextendedproperty (''MS_Description'', ''user'', ''' + @schemaName + ''', ''table'', ''' + @objectName + ''', ''column'', default)
      ) b
      ON a.NAME COLLATE Hungarian_CI_AS = b.NAME COLLATE Hungarian_CI_AS
    ORDER BY
      a.[ORDINAL_POSITION]

    SELECT * FROM ' + @tmpTableName + ''

    --PRINT @sqlCmd

    EXEC sp_executesql @sqlCmd
    RETURN
END
-- GO

EXEC sys.sp_MS_marksystemobject sp_desc
-- GO