
show databases

-- create database mssql;

use mssql

show tables;

install soname 'ha_connect.so';

-- 
-- CREATE TABLE connect_table ENGINE=CONNECT CONNECTION='DSN=MSSQLTestServer;UID=sa;PWD=passwd' table_type=odbc;
-- 
-- Can you please specify UID and PWD in the connection string on Debian, like this:
-- 
-- CREATE TABLE connect_table (
-- id int(10) NOT NULL
-- ) ENGINE=CONNECT DEFAULT CHARSET=latin1 CONNECTION='DSN=MSSQLTestServer;UID=sa;PWD=sapwd' table_type=odbc block_size=10 tabname='connect_table';

-- Note, ConnectSE supports so called discovery, so in many cases it's ok not to specify table structure,
-- it should be detected automatically. Also, if the local and the remote table names are the same,
-- then no needs to specify the tabname option. This is the minimum possible create statetent:

-- example local this is the freetds
-- [larsa]
-- host = 192.168.20.190
-- port = 1433
-- tds version = 8.0

-- and this the unixodbc

-- [odbclarsa]
-- Descriptions=MssqlServerLarsa
-- Driver=ms-sql
-- ServerName=Larsa
-- UID=sa
-- PWD=effeta
-- port=1433
-- Database=AdventureWorks2012

-- CREATE TABLE connect_table ENGINE=CONNECT table_type=odbc CONNECTION='DSN=odbclarsa';




-- Original driver of mssql
CREATE table casetas_iave_periods ENGINE=CONNECT CONNECTION='DSN=MssqlWork;Database=sistemas;Uid=zam;Pwd=lis;' table_type=odbc;
create or replace TABLE performance_trips DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=MssqlWork;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';

create or replace TABLE projections_view_indicators_periods_full_fleets DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=MssqlWork;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';

create or replace TABLE projections_view_indicators_periods_full_fleets DEFAULT CHARSET=latin1 ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';
-- 


select * from mssql.performance_trips
	
select * from portal_apps.performance_trips



select * from mssql.projections_view_indicators_periods_full_fleets






CREATE TABLE general_area ENGINE=CONNECT CONNECTION='DSN=odbclarsa;UID=sa;PWD=effeta;Database=macuspanadb;' table_type=odbc;

CREATE TABLE trafico_guia ENGINE=CONNECT CONNECTION='DSN=odbclarsa;UID=sa;PWD=effeta;Database=macuspanadb;' table_type=odbc;

CREATE TABLE trafico_renglon_guia ENGINE=CONNECT CONNECTION='DSN=odbclarsa;UID=sa;PWD=effeta;Database=macuspanadb;' table_type=odbc;

CREATE TABLE generals_month_translations ENGINE=CONNECT CONNECTION='DSN=odbclarsa;UID=sa;PWD=effeta;Database=sistemas;' table_type=odbc;

select * from mssql.generals_month_translations

select * from mssql.general_area

select * from mssql.trafico_guia as tg where tg.no_guia = '35708'

select tr.peso from mssql.trafico_renglon_guia as tr where tr.no_guia = '35708'



create view test_join as 

select sum(tg.subtotal) as 'subtotal',sum(tr.peso) as 'peso',sum(tr.peso_estimado) as 'pesoest' from mssql.trafico_guia as tg 
inner join mssql.trafico_renglon_guia as tr on tr.no_guia = tg.no_guia and tr.id_area = tg.id_area
where tg.id_area = '1' and year(tg.fecha_guia) = '2016' and month(tg.fecha_guia) = '01'




select * from mssql.test_join



select sum(tg.subtotal) as 'subtotal' from mssql.trafico_guia as tg 
where tg.id_area = '1' and year(tg.fecha_guia) = '2016' and month(tg.fecha_guia) = '01'

select * from projections_atm.areas_atm






-- CREATE TABLE PersonAddress ENGINE=CONNECT table_type=odbc CONNECTION='DSN=odbclarsa;UID=sa;PWD=effeta;Database=AdventureWorks2012';
-- 
-- select * from mssql.PersonAddress
-- 
-- drop table mssql.PersonAddress

-- 
-- I am mostly familiar with Windows ODBC (the original product) but unixODBC has probably the same features:
-- 
-- ODBC connections can be specified in two ways:
-- 1) Specifying the driver to use (via DRIVER=... in the connection string)
-- 2) Specifying a data source (via DSN=... in the connection string)
-- The first way is more complicated because all parameters required for the connection must be specified in the connection string.
-- When using the second way, ODBC uses the parameters defined for the data source and you have to add only the ones not yet defined in the data source description.
-- For unixODBC, the data source is defined as an entry in the odbc.ini configuration file. It is quite possible to define several data sources using the same driver. For instance:
-- 
-- [MSSQLTestServer]
-- Driver = ODBC Driver 11 for SQL Server
-- Server = 192.168.1.20
-- Port = 1433
-- 
-- [MyMSSQL]
-- Driver = ODBC Driver 11 for SQL Server
-- Server = 192.168.1.20
-- Port = 1433
-- UID = sa
-- PWD = sapwd
-- 
-- Doing so you should be able to create your table just saying:

 -- CREATE TABLE connect_table ENGINE=CONNECT table_type=odbc CONNECTION='DSN=MyMSSQL';

-- The equivalent works fine on Windows, I did not yet test it on Linux (I am using ubuntu)
-- 
-- Note that the parameters required for a connection depend on the ODBC connector you use. 
-- They cannot be described in the CONNECT documentation and you should refer to the used connector documentation to know what they are.

    
    

-- as we read in /etc/odbcinst.ini: with original ms driver
-- CREATE TABLE mssql_table 
-- ENGINE=CONNECT 
-- DEFAULT 
-- CHARSET=latin1 
-- CONNECTION='Driver=SQL Server Native Client 11.0;Server=ms-sql01;Database=old_version_migration_data;UID=mariadb;PWD=password'
-- TABLE_TYPE='ODBC'


