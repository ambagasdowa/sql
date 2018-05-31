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


create or replace user `ambagasdowa`@`localhost` IDENTIFIED by 'pass';
grant usage on ambagasdowa.* to ambagasdowa@localhost identified by 'pass';
grant select, insert, update, delete, drop, alter, create , create temporary tables on ambagasdowa.* to ambagasdowa@localhost;
grant file on *.* to 'ambagasdowa'@'localhost';
flush privileges;
SHOW GRANTS FOR 'ambagasdowa'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO ambagasdowa@'localhost' with grant option;
flush privileges;
