------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Struct for tables on providers v 3.0 unfortunally this going to be in mssql
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
go


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ViewBussinessUnitsDatabasesGet
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use sistemas;
go
IF OBJECT_ID ('providers_view_bussiness_units', 'V') IS NOT NULL
    DROP VIEW providers_view_bussiness_units;
GO

create view providers_view_bussiness_units
with encryption
as
	select
		row_number()
	over 
		(order by base) as 
							id,
							company_id,
							company,
							base
	from(
			select 
				distinct 
				frl.entity_num as 'company_id',xref.idsl as 'company',xref.AreaLIS as 'base' from integraapp.dbo.xrefcia as xref
				inner join
					integraapp.dbo.frl_entity as frl on xref.idsl = frl.cpnyid
				where xref.Activo = 0
		) as result
go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ViewBussinessCompaniesDatabasesGet
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use sistemas;
go
IF OBJECT_ID ('providers_view_companies_units', 'V') IS NOT NULL
    DROP VIEW providers_view_companies_units;
GO

create view providers_view_companies_units
with encryption
as
	select entity_num as 'id',cpnyid as 'company' from integraapp.dbo.frl_entity
go

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls ProvidersControlsUsers
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
use [sistemas]
go
IF OBJECT_ID('dbo.providers_controls_users', 'U') IS NOT NULL 
  DROP TABLE dbo.providers_controls_users; 
go
set ansi_nulls on
go
set quoted_identifier on
go
set ansi_padding on
go
 
create table [dbo].[providers_controls_users](
		id									int identity(1,1),
		user_id								int,
		providers_view_companies_units_id	int,
		created								datetime,
		modified							datetime,
		_status								tinyint default 1 null
--		,constraint ak_user_id unique(user_id)
) on [primary]
go

set ansi_padding off
go
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--select * from integraapp.dbo.xrefcia
--select * from sistemas.dbo.providers_view_bussiness_units order by company_id,id

 --select * from providers_imported_files_controls
 --select * from providers_imported_databases where providers_imported_files_controls_id = '7'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Controls providersControlsUsers
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.providers_controls_users', 'U') IS NOT NULL 
  DROP TABLE dbo.providers_controls_users; 
go
set ansi_nulls on
go
set quoted_identifier on
go
set ansi_padding on
go
 
create table [dbo].[providers_controls_users](
		id											int identity(1,1),
		user_id										int,
		providers_view_companies_units_id			int,
		providers_view_bussiness_units_id			int default 0, -- this comes from BusinessUnits in MySql
		created										datetime,
		modified									datetime,
		_status										tinyint default 1 null
--		,constraint ak_user_id unique(user_id)
) on [primary]
go

set ansi_padding off
go


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FileimportedDatabasesControls
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.providers_imported_files_controls', 'U') IS NOT NULL 
  DROP TABLE dbo.providers_imported_files_controls; 
go
set ansi_nulls on
go
set quoted_identifier on
go
set ansi_padding on
go
 
create table [dbo].[providers_imported_files_controls](
		id							int identity(1,1),
		user_id						int,
        providers_file_name			nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
		providers_file_name_desc	text 		collate		sql_latin1_general_cp1_ci_as,
		providers_md5sum_check		nvarchar(4000) collate		sql_latin1_general_cp1_ci_as,
		created						datetime,
		modified					datetime,
		providers_standings_id		int,
		providers_parents_id		int,
		_status						tinyint default 1 null
) on [primary]
go

set ansi_padding off
go
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FileimportedDatabases
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- this is a 

IF OBJECT_ID('dbo.providers_imported_databases', 'U') IS NOT NULL 
  DROP TABLE dbo.providers_imported_databases; 
go
set ansi_nulls on
go
set quoted_identifier on
go
set ansi_padding on
go
 
create table [dbo].[providers_imported_databases](
		id										int identity(1,1),
		providers_imported_files_controls_id	int,
		--fields in xlsx file
		keypri									int,
		id_file									nvarchar(255) 		collate		sql_latin1_general_cp1_ci_as,
		ZCpnyId									nvarchar(6)			collate		sql_latin1_general_cp1_ci_as,
		ZBatNbr									int,
		ZRcptDate								int,--nvarchar(55)		collate		sql_latin1_general_cp1_ci_as,
		ZVendId									nvarchar(255)		collate		sql_latin1_general_cp1_ci_as,
		ZCuryRcptCtrlAmt						decimal(18,2),
		ZAPBatNbr								int,
		ZAPRefno								int,
		ZAPDocDate								int, --nvarchar(55)		collate		sql_latin1_general_cp1_ci_as,
		ZEstatus								tinyint,
		ZInvcNbr								nvarchar(255)		collate		sql_latin1_general_cp1_ci_as,
		ZInvcDate								int,--nvarchar(55)		collate		sql_latin1_general_cp1_ci_as,
		ZPerPost								nvarchar(6)			collate		sql_latin1_general_cp1_ci_as,
		ZPayDate								int,--nvarchar(55)		collate		sql_latin1_general_cp1_ci_as,
		ZUUID									nvarchar(4000)		collate		sql_latin1_general_cp1_ci_as,
		ZAcct									nvarchar(10)		collate		sql_latin1_general_cp1_ci_as,
		ZFechaPago								int,--nvarchar(55)		collate		sql_latin1_general_cp1_ci_as,
		ZMontoPago								decimal(18,2),
		ZRefPago								nvarchar(255),
		tstamp									nvarchar(255),
		Ztbknbr									int,
		exportado								tinyint,
		florensia								tinyint,
		tipocomprobante							nvarchar(70),
		--fields in xlsx file
		created									datetime,
		modified								datetime,
		user_id									int,
		_status									tinyint default 1 null
) on [primary]
go

set ansi_padding off
go

--select convert( decimal(18,10) ,CURRENT_TIMESTAMP)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SearchQuery
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

use sistemas;
go
IF OBJECT_ID ('providers_view_search_editions', 'V') IS NOT NULL
    DROP VIEW providers_view_search_editions;
GO

create view providers_view_search_editions
with encryption
as

	select 
			zfile.id as 'id'
			,zfile.providers_imported_files_controls_id as 'providers_imported_files_controls_id'
			,zfile.user_id as 'user_id'
			,zfile.ZAPBatNbr as 'ZAPBatNbr'
			,zfile.ZCpnyId as 'ZCnpyId'
			--,(Select Cast(zfile.ZInvcDate as DateTime)) as 'ZInvcDate.old'
			,(select dateadd(day,-2, zfile.ZInvcDate)) as 'ZInvcDate'
			,zfile.ZPerPost as 'ZPerPost'
			,zfile.ZCuryRcptCtrlAmt as 'ZCuryRcptCtrlAmt'
			,zfile.ZInvcNbr as 'ZInvcNbr'
			,zfile.ZUUID as 'ZUUID'
			,prov.BatNbr as 'BatNbr'
			,zfile.ZEstatus as 'ZEstatus'
	from
			sistemas.dbo.providers_imported_databases as zfile 
		inner join
			integraapp.dbo.Batch as prov on prov.BatNbr = zfile.ZAPBatNbr and prov.CpnyID = zfile.ZCpnyId
	where 
			prov.Module = 'AP' 
		and
			prov.Status = 'H'
			
go




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- updateQuery
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--select ZInvcDate,* from providers_imported_databases where providers_imported_files_controls_id = '7'

--select * from sistemas.dbo.providers_view_search_editions where providers_imported_files_controls_id = '2' 

--you can join both tables even on UPDATE statements,

--UPDATE  a
--SET     a.marks = b.marks
--FROM    tempDataView a
--        INNER JOIN tempData b
--            ON a.Name = b.Name

--    SQLFiddle Demo

--for faster performance, define an INDEX on column marks on both tables.

--using SUBQUERY

--UPDATE  tempDataView 
--SET     marks = 
--        (
--          SELECT marks 
--          FROM tempData b 
--          WHERE tempDataView.Name = b.Name
--        )


--select 
--		portal.ZEstatus ,search.ZEstatus,
--		portal.ZInvcNbr ,search.ZInvcNbr,
--		portal.ZInvcDate,search.ZInvcDate,
--		--portal.ZPerPost,search.ZPerPost,
--		portal.ZPerPost ,search.ZPerPost,
--		portal.ZUUID,search.ZUUID,
--		search.BatNbr
--	from
--		integraapp.dbo.ZPortalProv as portal
--	inner join
--		sistemas.dbo.providers_view_search_editions as search on portal.ZAPBatNbr = search.BatNbr


--update portal
--	set	portal.ZEstatus = search.ZEstatus,
--		portal.ZInvcNbr = search.ZInvcNbr,
--		portal.ZInvcDate = search.ZInvcDate,
--		portal.ZPerPost = '201610',
--		portal.ZUUID = search.ZUUID
--	from
--		integraapp.dbo.ZPortalProv as portal
--	inner join
--		sistemas.dbo.providers_view_search_editions as search on portal.ZAPBatNbr = search.BatNbr





--$UNIX_DATE = ($EXCEL_DATE - 25569) * 86400;
--echo gmdate("d-m-Y H:i:s", $UNIX_DATE);


--2016-02-10 15:44

--Select Cast(42410 as DateTime)

--select dateadd(day,-2, 42410)

--select * from integraapp.dbo.ZPortalProv

--select
--			prov.CpnyID, prov.BatNbr
--from	
--			integraapp.dbo.Batch as prov
--where
--			prov.Module = 'AP' 
--		and
--			prov.Status = 'H'
--order by
--			CpnyID

