-- Tue, 02 Feb 2016
-- MariaDB & External Data
/*
MariaDB is a MySQL fork, which was initially derived from the 5.1 release of MySQL. Unlike MySQL, 
MariaDB can use external data stored in non-MariaDB databases as though the data was stored in a standard MariaDB table. 
The data is not loaded into MariaDB. To work with external data, MariaDB uses the CONNECT storage engine. 
This storage engine was introduced in MariaDB 10.0.The CONNECT storage engine is included with both the Windows and Linux version of the database,
although it is not loaded by default. The CONNECT storage engine can use ODBC to work with external data. ODBC is a database-neutral 
interface that allows ODBC compliant applications such as the CONNECT storage engine to work with any database for which an ODBC driver is available. 
ODBC translates the application's data queries into something the target database understands. 
ODBC has two components: 
			the ODBC driver and the ODBC Driver Manager. 
			The ODBC driver is database-specific, i.e. a Microsoft Access ODBC driver will only talk to a Microsoft Access database. 
			The ODBC Driver Manager is the interface between the CONNECT storage engine and the ODBC driver. 
			The Driver Manager is responsible for loading the ODBC driver, 
			insulating the application (i.e. the storage engine) from the component that interacts with the database. 
			This architecture enables MariaDB to connect to different databases without any changes being made to MariaDB.
			On Windows, Microsoft provide an ODBC Driver Manager with the operating system, and this is the one that the CONNECT storage engine uses on this platform.

On Linux, the CONNECT storage engine uses the unixODBC Driver Manager. This Driver Manager is usually available with the operating system,
			although may not be installed by default. All Easysoft ODBC drivers for non-Windows platforms include the unixODBC Driver Manager.
			To summarise, the components required to connect MariaDB to external data by using ODBC are:
			MariaDB > CONNECT Storage Engine > ODBC Driver Manager > ODBC Driver > ODBC Database
			To try out the CONNECT storage engine, we used our SQL Server and Access ODBC drivers 
			on with MariaDB on Linux and our Salesforce ODBC driver with MariaDB on Windows.
Note If you are using a 64-bit version MariaDB you must use a 64-bit ODBC driver. If you are using a 32-bit version MariaDB you must use a 32-bit ODBC driver.
Loading the Connect Storage Engine

Regardless of whether you're running MariaDB on Linux or Windows, the same command is required to load the CONNECT storage engine. In a MySQL client shell, type:
*/

INSTALL SONAME 'ha_connect';

-- Assuming you have the appropriate ODBC driver for your target database installed and have configured an ODBC data source, 
-- you can now integrate external data with MariaDB.

-- On Linux, we were using a copy of the unixODBC Driver Manager that was included with our drivers, 
-- and so we had to set the environment so that those Driver Manager libraries would be loaded.

-- # /etc/init.d/mariadb stop
-- # export LD_LIBRARY_PATH=/usr/local/easysoft/unixODBC/lib:$LD_LIBRARY_PATH
-- # ldd /opt/mariadb/lib/plugin/ha_connect.so | grep odbc
--        libodbc.so.1 => /usr/local/easysoft/unixODBC/lib/libodbc.so.1
--        (0x00007f2a06ce8000)
-- # /etc/init.d/mariadb start

-- Example: Connect MariaDB on Linux to Microsoft Access

-- The CONNECT storage engine enables you to create a CONNECT table in MariaDB. 
-- The CONNECT table type specifies how the external data will be accessed. 
-- We're using an ODBC driver to connect to Access and so the correct table type to use is "ODBC". 
-- We've created an ODBC data source that connects to the Northwind database, and that's the data we'll be accessing from MariaDB. 
-- The data source is called "Northwind" and we need to include that in our CONNECT table definition:

$ /opt/mariadb/bin/mysql --socket=/opt/mariadb-data/mariadb.sock
MariaDB [(none)]> CREATE DATABASE MDB;
MariaDB [MDB]> USE MDB;
MariaDB [MDB]> INSTALL SONAME 'ha_connect';
MariaDB [MDB]> CREATE TABLE Customers engine=connect
                                      table_type=ODBC
                                      Connection='DSN=ACCESS_NORTHWIND;';
MariaDB [MDB]> SELECT CompanyName FROM Customers WHERE CustomerID = 'VICTE';
+----------------------+
| CompanyName          |
+----------------------+
| Victuailles en stock |
+----------------------+
1 row in set (0.02 sec)

The storage engine can auto detect the target table structure and so specifying the column names / data types in the CREATE TABLE statement is not mandatory.
Example: Connect MariaDB on Linux to Microsoft SQL Server

This example uses the tabname option to work around a difference between MariaDB and SQL Server. We want to retrieve some AdventureWorks data stored 
in the Person.Address table. However, MariaDB does not have the idea of a table schema, and so we will change the name of the table to "PersonAddress" 
in MariaDB. We specify the actual table name with the tabname, so the SQL Server ODBC driver can pass on the table name that SQL Server recognises.

$ /opt/mariadb/bin/mysql --socket=/opt/mariadb-data/mariadb.sock
MariaDB [(none)]> CREATE DATABASE MSSQL;
MariaDB [(none)]> USE MSSQL;
MariaDB [MSSQL]> INSTALL SONAME 'ha_connect';
MariaDB [MSSQL]> CREATE TABLE PersonAddress engine=connect
                                            table_type=ODBC
                                            tabname='Person.Address'
                                            Connection='DSN=SQLSERVER_ADVENTUREWORKS;';
ERROR 1105 (HY000): Unsupported SQL type -11
MariaDB [MSSQL]> \! grep -- -11 /usr/local/easysoft/unixODBC/include/sqlext.h 
#define SQL_GUID				(-11)
MariaDB [MSSQL]> CREATE TABLE PersonAddress (  AddressID int,  
                                                AddressLine1 varchar(60),  
                                                AddressLine2 varchar(60),
                                                City varchar(30),
                                                StateProvinceID int,
                                                PostalCode varchar(15),
                                                rowguid varchar(64),
                                                ModifiedDate datetime )
                                 engine=connect
                                 table_type=ODBC 
                                 tabname='Person.Address'
                                 Connection='DSN=SQLSERVER_SAMPLE;';
MariaDB [MSSQL]> SELECT City FROM PersonAddress WHERE AddressID = 32521;
+-----------+
| City      |
+-----------+
| Sammamish |
+-----------+

-- Because there's no direct equivalent for the SQL Server data type uniqueidentifier. We have to map this type in the rowguid column to a MariaDB VARCHAR type.
-- Even though this is the only problematic column, we need to include the others in the CREATE TABLE statement.
-- Otherwise, the table would only contain the rowguid column.

-- Example: Connect MariaDB on Windows to Salesforce

-- We're using a 64-bit version of MariaDB and we therefore needed to configure a 64-bit ODBC data source for our target Salesforce instance.
-- (Otherwise our attempt to create a CONNECT table type will fail with an "Architecture mismatch" error.) To do this, 
-- we used the 64-bit version of Microsoft ODBC Data Source Administrator, which is located in Control Panel.
-- (On some versions of Windows, there is both a 32-bit and a 64-bit version of ODBC Data Source Administrator located in Control Panel,
-- however their architecture is clearly labelled if this is the case.)

-- Our target Salesforce "table" contains NVARCHAR columns, which the CONNECT storage engine handles as VARCHARs.
-- The CREATE TABLE statement generates warnings to this effect. ("Column ID is wide characters", and so on.)

CREATE DATABASE SALESFORCE;
USE SALESFORCE;
INSTALL SONAME 'ha_connect';
CREATE TABLE Product2 engine=connect
                      table_type=ODBC
                      Connection='DSN=64-bit Salesforce System ODBC DSN;';
SELECT Description FROM Product2
/*
ODBC Driver for SQL Server, SQL Azure
ODBC Driver for Salesforce.com, Force.com, Database.com

Other MySQL/MariaDB Connectivity Options
Name	Description
MariaDB Connector/ODBC	This is an ODBC driver for MariaDB and is available for both Windows and Linux platforms. 
						It enables ODBC compliant applications such as Microsoft Excel to access data stored in MariaDB.
MySQL Connector/ODBC	This is an ODBC driver for MySQL and is available for Windows, Linux, UNIX and OS X platforms. 
						It enables ODBC compliant applications such as Microsoft Excel to access data stored in MySQL.
MySQL Federated Engine	This is similar to the CONNECT storage engine, however it only supports data stored in external MySQL databases.
*/