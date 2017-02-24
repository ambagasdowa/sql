SELECT name, recovery_model_desc
   FROM sys.databases
      WHERE name = 'sistemas' ;
GO

USE master ;
ALTER DATABASE sistemas SET RECOVERY SIMPLE ;

