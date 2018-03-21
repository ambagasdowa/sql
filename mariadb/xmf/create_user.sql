show databases;


use cakephp;

show tables;

select * from cakephp.users

drop database cakephp


show databases;

create database cakephp;

grant usage on cakephp.* to cakephp@localhost identified by '@cakephp#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on cakephp.* to cakephp@localhost;
grant file on *.* to 'cakephp'@'localhost';
flush privileges;
SHOW GRANTS FOR 'cakephp'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO cakephp@'localhost' -- with grant options;
flush privileges;


