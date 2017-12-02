
show databases

use mssql_integradb

show tables

select * from mssql_integradb.general_view_bussiness_units
-- show engines;
-- SELECT * FROM `information_schema`.`plugins`;
-- SELECT * FROM mysql.plugin;
-- create database mssql_integradb
-- use mssql_integradb
-- show tables;
-- install soname 'ha_connect.so';



CREATE TABLE generals_month_translations ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';

CREATE TABLE general_view_bussiness_units ENGINE=CONNECT CONNECTION='DSN=odbcintegradb;UID=zam;PWD=lis;Database=sistemas;' table_type='ODBC';




select * from mssql_integradb.generals_month_translations

select * from mssql_integradb.general_view_bussiness_units



-- Cloud Solution

use portal_users

select * from portal_users.posts


show databases;

use portal_nextcloud

show tables;


select * from portal_nextcloud.oc_users

select * from portal_nextcloud.oc_share

select * from portal_nextcloud.oc_filecache

select * from portal_nextcloud.oc_dav_shares

select * from portal_nextcloud.oc_mounts

select * from portal_nextcloud.oc_storages

select * from portal_nextcloud.oc_accounts

select * from portal_nextcloud.oc_mimetypes




-- get the share objects

select 
		 ocusers.uid
		,ocshare.uid_owner
		,ocshare.uid_initiator
		,ocshare.file_target
		,ocshare.accepted 
		,ocshare.expiration
		,ocshare.item_source
		,ocshare.share_name
		,ocshare.item_type
-- 		,ocshare.*
-- 		,ocdirs.name
from portal_nextcloud.oc_users as ocusers
	inner join 
			portal_nextcloud.oc_share as ocshare
	on ocusers.uid = ocshare.uid_owner
-- 	left join 
-- 			portal_nextcloud.oc_filecache as ocdirs
-- 	on ocshare.item_source = ocdirs.parent


