show databases

create database portal_nextcloud

-- drop database policies
-- 
-- drop database portal_company
-- 
-- drop database portal_secure
-- 
-- drop database portal_user_info
-- 
-- drop database portal_users
-- 
-- drop database portal_nextcloud


-- select * from portal_users.groups


-- =========================================================================== --
-- ======================== create a user ==================================== --
-- =========================================================================== --


grant usage on portal_mainframe.* to portal_mainframe@localhost identified by '@portal_mainframe#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_mainframe.* to portal_mainframe@localhost;
flush privileges;

grant usage on portal_users.* to portal_users@localhost identified by '@portal_users#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_users.* to portal_users@localhost;
flush privileges;


grant usage on portal_user_info.* to portal_user_info@localhost identified by '@portal_user_info#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_user_info.* to portal_user_info@localhost;
flush privileges;


grant usage on policies.* to policies@localhost identified by '@policies#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on policies.* to policies@localhost;
flush privileges;

grant usage on portal_company.* to portal_company@localhost identified by '@portal_company#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_company.* to portal_company@localhost;
flush privileges;


grant usage on portal_secure.* to portal_secure@localhost identified by '@portal_secure#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_secure.* to portal_secure@localhost;
flush privileges;

grant usage on portal_nextcloud.* to portal_nextcloud@localhost identified by '@portal_nextcloud#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_nextcloud.* to portal_nextcloud@localhost;
flush privileges;




use portal_nextcloud

show tables;


