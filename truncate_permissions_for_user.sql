

    create database foo
    go
    create login foobar with password = 'alkdsfji9eorngv';
    go
    use foo
    go
    create user foobar from login foobar;
    go
    create table test(rowid int identity)
    go
    insert into test default values;
    go
    select * from test
    go
    create procedure dbo.truncate_test
    with execute as owner
    as
    truncate table test
    go
    grant execute on dbo.truncate_test to foobar
    go
    execute as login='foobar'
    execute dbo.truncate_test
    revert
    go
    select * from test
    go
    use master
    go

    drop database foo
    drop login foobar

--    This keeps your database safe and allows you to grant execute on the truncate procedure to allow them to truncate the table.

You can create a stored procedure with execute as owner to only one table or a store procedure to any table. In the next code is  SP to truncate any table
    without assing permission of db_owner or other:

    USE [database name]
    GO
    SET ANSI_NULLS ON
    GO
    SET QUOTED_IDENTIFIER ON
    GO

    -- =============================================
    -- Author:  Yimy Orley Asprilla
    -- Create date: Julio 16 de 2014
    -- Description: Función para hacer TRUNCATE a una tabla.
    -- =============================================
    CREATE PROCEDURE [dbo].[spTruncate]
     @nameTable varchar(60) 


    WITH EXECUTE AS OWNER
    AS

     SET NOCOUNT OFF;

        DECLARE @QUERY NVARCHAR(200);

     SET @QUERY = N'TRUNCATE TABLE ' + @nameTable + ';'

     EXECUTE sp_executesql @QUERY;

     -- =============================================

    CREATE PROCEDURE [dbo].[spTruncate]
         @nameTable varchar(60)

        WITH EXECUTE AS OWNER
        AS

         SET NOCOUNT OFF;

            DECLARE @QUERY NVARCHAR(200);

         SET @QUERY = N'TRUNCATE TABLE ' + @nameTable + ';'

         EXECUTE sp_executesql @QUERY;

--     Apparently you have never heard of SQL injection.

    EXEC spTruncate '#temp; UPDATE Employees SET Salary = 2 * Salary WHERE EmployeeID = 1232'

--     If you do something like this, you should either confine the procedure to a single statically defined table, or perform careful validation on the input
--     parameter.

    -- =============================================
