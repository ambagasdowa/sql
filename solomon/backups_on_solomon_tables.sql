-- =============================================================================================================================== --
-- 					Struct for tables for backups in solomon users
-- =============================================================================================================================== --
use [sistemas]
-- go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- accessdetrights_users on integrasys
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.solomon_accessdetrights_users', 'U') IS NOT NULL 
  DROP TABLE dbo.solomon_accessdetrights_users; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[solomon_accessdetrights_users](
		id									int identity(1,1),
		CompanyID 							char(10)	collate		sql_latin1_general_cp1_ci_as,
		DatabaseName 						char(30)	collate		sql_latin1_general_cp1_ci_as,
		DeleteRights 						smallint,
		InitRights 							smallint,
		InsertRights 						smallint,
		RecType 							char(1)		collate		sql_latin1_general_cp1_ci_as,
		ScreenNumber 						char(7)		collate		sql_latin1_general_cp1_ci_as,
		UpdateRights 						smallint,
		UserId 								char(47)	collate		sql_latin1_general_cp1_ci_as,
		ViewRights 							smallint,
		created								datetime,
		modified							datetime,
		solomon_control_backups_id			int,
		_status								tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

--insert into dbo.projections_global_corps values	('GST','Grupo Servicios de Transporte',CURRENT_TIMESTAMP,null,'1',null,null,1);
--use integrasys
--exec sp_desc AccessDetRights

--	"first backup"
--	insert into dbo.solomon_accessdetrights_users 
--		select 
--				CompanyID ,DatabaseName ,DeleteRights ,InitRights ,InsertRights 
--				,RecType ,ScreenNumber ,UpdateRights ,UserId ,ViewRights ,CURRENT_TIMESTAMP
--				,CURRENT_TIMESTAMP,'1','1'
--		from 
--				integrasys.dbo.AccessDetRights
				
select * from sistemas.dbo.solomon_accessdetrights_users as solusr where solusr.solomon_control_backups_id = 1 and UserId like 'ADRIAN%' and substring(ScreenNumber,1,2) = 'AP'

select * from integrasys.dbo.AccessDetRights where UserId like 'ADRIAN%' and substring(ScreenNumber,1,2) = 'AP'

select * from integrasys.dbo.AccessModule

select * from integrasys.dbo.AcctSub

select * from integrasys.dbo.Access order by UserId -- online users

select * from integrasys.dbo.AccessRights -- define users



-- =============================================================================================================================== --
-- 					Backup_controls
-- =============================================================================================================================== --
use [sistemas]
-- go

IF OBJECT_ID('dbo.solomon_control_backups', 'U') IS NOT NULL 
  DROP TABLE dbo.solomon_control_backups; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[solomon_control_backups](
		id									int identity(1,1),
		user_id								int,
		table_backing						nvarchar(350)		collate		sql_latin1_general_cp1_ci_as,
		backup_create_date					datetime,	
		backed_records						int,
		created								datetime,
		modified							datetime,
		solomon_controls_id					int,
		_status								tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go
--	insert into sistemas.dbo.solomon_control_backups values ('1','integrasys.dbo.AccessDetRights',CURRENT_TIMESTAMP,0,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1','1')
	

	
