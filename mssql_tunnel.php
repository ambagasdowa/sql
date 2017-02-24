<?php
/**NOTE TITLE => connect cakephp/LinuxBox To MSSQL*/
// Add MSSQL Support

Summary

install the packages

freetds-bin
tdsodbc
unixodbc
php5-sybase


=== Add the server Definition Entry in /etc/freetds/freetds.conf

# hostidentifier => the name of the server this is a wrapper for the connection

//===================================================================================//
#server at bonampak orizaba
[bonampakdb]
        host = 127.0.0.1
        port = 64500
        tds version = 8.0


//===================================================================================//

=== Add the driver configuration /etc/odbcinst.ini 
=== the routes in debian are /usr/lib/i386-linux-gnu/odbc/libtdsodbc.so
=== and /usr/lib/i386-linux-gnu/odbc/libtdsS.so

=== for x64 systems the routes are :
=== Driver = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so
=== Setup = /usr/lib/x86_64-linux-gnu/odbc/libtdsS.so

//===================================================================================//
/** ambagasdowa@vmi61089:~$ cat /etc/odbcinst.ini */
[ms-sql]
Description = TDS connection
Driver = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so
Setup = /usr/lib/x86_64-linux-gnu/odbc/libtdsS.so
UsageCount = 1
FileUsage = 1

[Virtuoso]
Driver=virtodbc.so
UsageCount=1
//===================================================================================//

=== Add the connection configuration /etc/odbc.ini

//===================================================================================//
/** ambagasdowa@vmi61089:~$ cat /etc/odbc.ini */

[odbc-integraapp]
    Description = IntegraGSTGroupDb
    Driver = ms-sql
    ServerName = bonampakdb
    UID = zam
    port = 64500
    Database= integraapp
//===================================================================================//


Driver debe de ser el nombre del driver que hemos definido en odbcinst.ini
ServerName debe de ser el identificador de host que hemos definido en freetds.conf

=== Test the connection 

# isql -v odbc-dbname TuUsuario TuPassword

isql -v odbc-integraapp zam lis

| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+—————————————+

SQL>

apt-get install libsybdb5 freetds-common php5-sybase
/etc/init.d/apache2 restart
At the end of the process, if all goes fine, you will find in the mssql section of phpinfo();


then in cakephp

I corrected the problem by adding the 'port' => '' to my database.php 
default config as in: 
        var $default = array( 
                'driver' => 'mssql', 
                'persistent' => false, 
                'host' => 'odbc-integraapp', 
                'login' => 'zam', 
                'password' => 'lis', 
                'database' => 'sistemas',
                'encoding' => 'utf8', 
                //'port' => '1433' 
                'port' => 64500
        );

  // set the tunnel 

start ssh server on mssql with bitwise

build the tunnel 
ssh -L 64500:127.0.0.1:1433 ambagasdowa@187.141.67.234

connect to mssql server with
host 127.0.0.1
port 64500


// pass @Effeta1#
// keep the connection alive 

// connect with dbeaver
// host 127.0.0.1
// port 64500
// driver Microsoft Driver jodbc for linux

?>