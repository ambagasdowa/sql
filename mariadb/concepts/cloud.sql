-- ==================================================================================================================== --	
-- ===========================================        App CloudSystem      ============================================ --
-- ==================================================================================================================== --

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 06, 2017
 Description    : Build Tables for CloudSystem
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database engine owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ===============================================================================*/

drop user portal_cloud@localhost

grant usage on portal_nextcloud.* to portal_nextcloud@localhost identified by '@portal_nextcloud#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_nextcloud.* to portal_nextcloud@localhost;
flush privileges;

-- grant usage on portal_apps.* to portal_apps@localhost identified by '@portal_apps#';
-- grant select, insert, update, delete, drop, alter, create , create temporary tables on portal_apps.* to portal_apps@localhost;
-- grant file on *.* to 'portal_apps'@'localhost';
-- flush privileges;

-- SHOW GRANTS FOR 'portal_apps'@'localhost';

-- flush privileges;

-- GRANT FILE ON *.* TO 'user'@'%';

-- Add external DB Sources

show databases;

use portal_nextcloud

show tables;

select * from portal_nextcloud.oc_users







