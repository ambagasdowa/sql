-- ==================================================================================================================== --	
-- =================================     DEVOPS :: Cakephp base dev        ============================================ --
-- ==================================================================================================================== --

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : May 23, 2018
 Description    : Build reporter finances
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : Jesus Baizabal
 @status        : Stable
 @version		: 0.0.1
 ===============================================================================*/

-- use blackops;

-- ==================================================================================================================== --	
-- ===================================      	  Shared Tables definitions 		 ================================== --
-- ==================================================================================================================== --


--------------------------------------------------------------------------------------------------------------------------
-- ===================================           Remolques Parents Definitions 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
use [sistemas]

IF OBJECT_ID('rentabilidad_remolque_parents', 'U') IS NOT NULL 
  DROP TABLE rentabilidad_remolque_parents; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on
 
create table [rentabilidad_remolque_parents](
		id						int identity(1,1),
		parents_name			nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		created					datetime,
		modified				datetime,
		user_id					int,
		status					tinyint default 1 null
) on [primary]

set ansi_padding off

insert into rentabilidad_remolque_parents values	  
										  ('File',CURRENT_TIMESTAMP,null,1,1)									-- 1
										 ,('Flags',CURRENT_TIMESTAMP,null,1,1)								-- 2
										;

									
select * from sistemas.dbo.rentabilidad_remolque_parents
--------------------------------------------------------------------------------------------------------------------------
-- ===================================           Remolques Parents Definitions 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use [sistemas]

IF OBJECT_ID('rentabilidad_remolque_standings', 'U') IS NOT NULL 
  DROP TABLE rentabilidad_remolque_standings;  

set ansi_nulls on
set quoted_identifier on
set ansi_padding on
 
create table [rentabilidad_remolque_standings](
		id									int identity(1,1),
		rentabilidad_remolque_parents_id	int,
		standings_name						nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		created								datetime,
		modified							datetime,
		user_id								int,
		status								tinyint default 1 null
) on [primary]

set ansi_padding off

insert into dbo.rentabilidad_remolque_standings values	
											 (1,'Uploaded',CURRENT_TIMESTAMP,null,1,1)											-- 1
											,(1,'Modified',CURRENT_TIMESTAMP,null,1,1)											-- 2
											,(1,'Deleted',CURRENT_TIMESTAMP,null,1,1)					-- 3
											,(1,'locked',CURRENT_TIMESTAMP,null,1,1)									-- 4
											,(1,'Unlocked',CURRENT_TIMESTAMP,null,1,1)				-- 5
											,(1,'Moved',CURRENT_TIMESTAMP,null,1,1)				-- 6 -- ok
											,(2,'xls',CURRENT_TIMESTAMP,null,1,1)									-- 10
											,(2,'xlsx',CURRENT_TIMESTAMP,null,1,1)									-- 11
											,(2,'csv',CURRENT_TIMESTAMP,null,1,1)								-- 11
											,(2,'input',CURRENT_TIMESTAMP,null,1,1)									-- 11
											;


-- ==================================================================================================================== --	
-- ===================================      	  table definitions 		  ========================================= --
-- ==================================================================================================================== --

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           		Docks Containers	 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use sistemas

IF OBJECT_ID('rentabilidad_remolque_docks', 'U') IS NOT NULL 
  DROP TABLE rentabilidad_remolque_docks; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

-- FileStorage 
create table [rentabilidad_remolque_docks](
		"id"					int identity(1,1),
		"user_id"				int,
		"company_id"			int,
		"id_area"				int,
		"bussiness_units"		nvarchar(15)		collate		sql_latin1_general_cp1_ci_as,
		"period"				nvarchar(6)			collate		sql_latin1_general_cp1_ci_as,
		"descriptions"			text,
		"created"				datetime,
		"modified"				datetime,
		"standing_id"			int,
		"parent_id"				int,
		"status"				tinyint default 1 null
) on [primary]

set ansi_padding off

insert into sistemas.dbo.rentabilidad_remolque_docks values 
		 (1,1,1,'TBKORI','201804','first container',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0,0,1)
		;

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           		blocks_reports		 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
-- select * from sistemas.dbo.rentabilidad_remolque_blocks_reports								
-- use sistemas

IF OBJECT_ID('rentabilidad_remolque_blocks_reports', 'U') IS NOT NULL 
  DROP TABLE rentabilidad_remolque_blocks_reports; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

-- FileStorage 
create table [rentabilidad_remolque_blocks_reports](
		"id"					int identity(1,1),
		"user_id"				int,
		"codename"				nvarchar(55) 		collate		sql_latin1_general_cp1_ci_as,
		"created"				datetime,
		"modified"				datetime,
		"standing_id"			int,
		"parent_id"				int,
		"status"				tinyint default 1 null
) on [primary]

set ansi_padding off								
						
insert into sistemas.dbo.rentabilidad_remolque_blocks_reports values
		(1,'tolva',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,null,null,1)
	   ,(2,'gondola',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,null,null,1)
	   ,(3,'otros',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,null,null,1)
	   ;

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           		Files				 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use sistemas

IF OBJECT_ID('rentabilidad_remolque_files', 'U') IS NOT NULL 
  DROP TABLE rentabilidad_remolque_files; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

-- FileStorage 
create table [rentabilidad_remolque_files](
		"id"								int identity(1,1),
		"user_id"							int,
		"rentabilidad_remolque_docks_id" 	int,
		"filename"							nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		"md5sum"							nvarchar(255)		collate		sql_latin1_general_cp1_ci_as,
		"file_size"							nvarchar(255)		collate		sql_latin1_general_cp1_ci_as,
	 	"atime" 							nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
	 	"mtime"								nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
	 	"ctime"								nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
		"bsu_file"							nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		"bussiness_units"					nvarchar(15)		collate		sql_latin1_general_cp1_ci_as,
		"created"							datetime,
		"modified"							datetime,
		"standing_id"						int,
		"parent_id"							int,
		"status"							tinyint default 1 null
) on [primary]

set ansi_padding off

--  file example

	insert into sistemas.dbo.rentabilidad_remolque_files values 
						 (1,1,'first.xls','asdxxxx455wq','xxxx','atime','mtime','ctime','bsu_fil','TBKORI',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
						,(1,1,'second.xls','asdxxxx4533','xxxx','atime','mtime','ctime','bsu_fil','TBKORI',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
						;

select * from sistemas.dbo.rentabilidad_remolque_files
--------------------------------------------------------------------------------------------------------------------------
-- ===================================           		FilesContent   		 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use sistemas

IF OBJECT_ID('rentabilidad_content_files', 'U') IS NOT NULL 
  DROP TABLE rentabilidad_content_files; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

-- FileStorageControl
create table [rentabilidad_content_files](
		"id"									int identity(1,1),
		"rentabilidad_remolque_files_id"		int,
		"block_reports_id"						int,  -- this must be [ tolva, gondola , etc this is dynamic]
		"tracto"								nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"dolly"									nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"remolque1"								nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"remolque2"								nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"operacion"								nvarchar(120) 	collate		sql_latin1_general_cp1_ci_as,
		"cliente"								nvarchar(120) 	collate		sql_latin1_general_cp1_ci_as,
		"notes"									text,
		"created"								datetime,
		"modified"								datetime,
		"standing_id"							int,
		"parent_id"								int,
		"status"								tinyint default 1 null
) on [primary]

set ansi_padding off

insert into sistemas.dbo.rentabilidad_content_files values 
	(1,1,'TT2168','RD1521','RT1939','RT1940','Tolva Acero','MODELO','some-notes',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
   ,(1,1,'TT2169','RD2034','RT2101','RT2102','Tolva Acero','MODELO','some-notes',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
   ,(2,2,'TT1151','RD1538','RV1468','RV1469','Gondola','SISA-SIVESA','some-notes',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
   ,(1,1,'TT1177','','RT2173','','Tolva Acero','MODELO','some-notes',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
   ;
  

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           		FilesContent   		 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use sistemas

IF OBJECT_ID('rentabilidad_remolque_logs', 'U') IS NOT NULL 
  DROP TABLE rentabilidad_remolque_logs; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

-- FileStorageControl
create table [rentabilidad_remolque_logs](
		"id"									int identity(1,1),
		"user_id"								int,
		"controller"							nvarchar(255) 	collate		sql_latin1_general_cp1_ci_as,						
		"description"							text,
		"created"								datetime,
		"modified"								datetime,
		"standing_id"							int,
		"parent_id"								int,
		"status"								tinyint default 1 null
) on [primary]

set ansi_padding off




insert into sistemas.dbo.rentabilidad_content_files values 
	(1,1,'TT2168','RD1521','RT1939','RT1940','Tolva Acero','MODELO','some-notes',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
   ,(1,1,'TT2169','RD2034','RT2101','RT2102','Tolva Acero','MODELO','some-notes',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
   ,(1,2,'TT1151','RD1538','RV1468','RV1469','Gondola','SISA-SIVESA','some-notes',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
   ;
 
-- ==================================================================================================================== --	
-- ===================================      	  Views definitions 		  ========================================= --
-- ==================================================================================================================== --


--------------------------------------------------------------------------------------------------------------------------
-- ===================================           	RentabilidadConciliation 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
---
--- emulate the excel file 

  select 
  		 "files".id
--  		,"files".user_id,"files".rentabilidad_remolque_docks_id
		,"slot".company_id
		,"slot".id_area
		,"slot".period
  		,"slot".descriptions as 'SlotDescriptions'
  		,"bsu".name
  		,"bsu".label
  		,"bsu".tname
  		,"files".filename
--  		,"files".md5sum,"files".file_size,"files".atime,"files".mtime,"files".ctime
--  		,"files".bsu_file
--  		,"files".bussiness_units
--  		,"files".created,"files".modified,"files".standing_id,"files".parent_id,"files".status
--   		,"content".block_reports_id
  		,"content".tracto
  		,"content".dolly
  		,"content".remolque1
  		,"content".remolque2
  		,"content".operacion
  		,"content".cliente
  		,"content".notes
  		,"blocks".codename
  from 
  		sistemas.dbo.rentabilidad_remolque_files as "files"
  	inner join 
  		sistemas.dbo.rentabilidad_remolque_docks as "slot"
  	on 
  		"files".rentabilidad_remolque_docks_id = "slot".id and "slot".status = 1
  	inner join 
  		sistemas.dbo.general_view_bussiness_units as "bsu"
  	on 
  		"slot".company_id = "bsu".projections_corporations_id and "slot".id_area = "bsu".id_area
  	inner join 
  		sistemas.dbo.rentabilidad_content_files as "content"
  	on
  		"files".id = "content".rentabilidad_remolque_files_id and "content".status = 1
  	inner join 
  		sistemas.dbo.rentabilidad_remolque_blocks_reports as "blocks"
  	on
  		"content".block_reports_id = "blocks".id and "blocks".status = 1
  		
  		
 --- //
--------------------------------------------------------------------------------------------------------------------------
-- ===================================           	RentabilidadDashView 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
--- Detailed View
   select 
  		 "files".id
--  		,"files".user_id,"files".rentabilidad_remolque_docks_id
		,"slot".company_id
		,"slot".id_area
		,"slot".period
  		,"slot".descriptions as 'SlotDescriptions'
  		,"bsu".name
  		,"bsu".label
  		,"bsu".tname
  		,"files".filename
--  		,"files".md5sum,"files".file_size,"files".atime,"files".mtime,"files".ctime
--  		,"files".bsu_file
--  		,"files".bussiness_units
--  		,"files".created,"files".modified,"files".standing_id,"files".parent_id,"files".status
--   		,"content".block_reports_id
  		,"content".tracto
  		,"content".dolly
  		,"content".remolque1
  		,"content".remolque2
  		,"content".operacion
  		,"content".cliente
  		,"content".notes
  		,"blocks".codename
  		,"cost".Mes,"cost".NoCta,"cost".NombreCta,"cost".PerEnt,"cost".Compañía,"cost".Tipo
  		,"cost".Entidad,"cost".tipoTransacción,"cost".Referencia,"cost".FechaTransacción
  		,"cost".Descripción,"cost".Abono,"cost".Cargo,"cost".UnidadNegocio,"cost".CentroCosto
  		,"cost".NombreEntidad,"cost".Presupuesto,"cost".[_source_company],"cost".[_period],"cost".[_key],"cost".[Año]
  from 
  		sistemas.dbo.rentabilidad_remolque_files as "files"
  	inner join 
  		sistemas.dbo.rentabilidad_remolque_docks as "slot"
  	on 
  		"files".rentabilidad_remolque_docks_id = "slot".id and "slot".status = 1
  	inner join 
  		sistemas.dbo.general_view_bussiness_units as "bsu"
  	on 
  		"slot".company_id = "bsu".projections_corporations_id and "slot".id_area = "bsu".id_area
  	inner join 
  		sistemas.dbo.rentabilidad_content_files as "content"
  	on
  		"files".id = "content".rentabilidad_remolque_files_id and "content".status = 1
  	inner join 
  		sistemas.dbo.rentabilidad_remolque_blocks_reports as "blocks"
  	on
  		"content".block_reports_id = "blocks".id and "blocks".status = 1
  	--
  	left join 
  		sistemas.dbo.rentabilidad_remolque_bsu_costos as "cost"
  	on
  		"bsu".tname = "cost"."Compañía" and "slot".period = "cost".[_period]
	and 
		"content".tracto = "cost".CentroCosto 	
  
		
--------------------------------------------------------------------------------------------------------------------------
-- ===================================           	RentabilidadDashView 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
--- Compact View

with "costs" as 
(
   select 
  		 "files".id
		,"slot".company_id
		,"slot".id_area
		,"slot".period
  		,"slot".descriptions as 'SlotDescriptions'
  		,"bsu".name
  		,"bsu".label
  		,"bsu".tname
  		,"files".filename
  		,"content".tracto
  		,"content".dolly
  		,"content".remolque1
  		,"content".remolque2
  		,"content".operacion
  		,"content".cliente
  		,"content".notes
  		,"blocks".codename
  		,"cost".Mes,"cost".NoCta,"cost".NombreCta,"cost".PerEnt,"cost".Compañía,"cost".Tipo
  		,"cost".Entidad,"cost".tipoTransacción,"cost".Referencia,"cost".FechaTransacción
  		,"cost".Descripción,"cost".Abono,"cost".Cargo,"cost".UnidadNegocio,"cost".CentroCosto
  		,"cost".NombreEntidad,"cost".Presupuesto,"cost".[_source_company],"cost".[_period],"cost".[_key],"cost".[Año]
  from 
  		sistemas.dbo.rentabilidad_remolque_files as "files"
  	inner join 
  		sistemas.dbo.rentabilidad_remolque_docks as "slot"
  	on 
  		"files".rentabilidad_remolque_docks_id = "slot".id and "slot".status = 1
  	inner join 
  		sistemas.dbo.general_view_bussiness_units as "bsu"
  	on 
  		"slot".company_id = "bsu".projections_corporations_id and "slot".id_area = "bsu".id_area
  	inner join 
  		sistemas.dbo.rentabilidad_content_files as "content"
  	on
  		"files".id = "content".rentabilidad_remolque_files_id and "content".status = 1
  	inner join 
  		sistemas.dbo.rentabilidad_remolque_blocks_reports as "blocks"
  	on
  		"content".block_reports_id = "blocks".id and "blocks".status = 1
  	--
  	left join 
  		sistemas.dbo.rentabilidad_remolque_bsu_costos as "cost"
  	on
  		"bsu".tname = "cost"."Compañía" and "slot".period = "cost".[_period]
	and 
		"content".tracto = "cost".CentroCosto 	
 )
 select 
-- 		"costs".id
-- 		,"costs".company_id
-- 		,"costs".id_area
 		 "costs".period
-- 		,"costs".SlotDescriptions
-- 		,"costs".name
 		,"costs".label
 		,"costs".tname
-- 		,"costs".filename
-- 		,"costs".tracto
-- 		,"costs".dolly
-- 		,"costs".remolque1
-- 		,"costs".remolque2
-- 		,"costs".operacion
-- 		,"costs".cliente
-- 		,"costs".notes
 		,"costs".codename
 		,"costs".Mes
 		,"costs".NoCta
 		,"costs".NombreCta
-- 		,"costs".PerEnt
 		,"costs"."Compañía"
-- 		,"costs".Tipo
-- 		,"costs".Entidad
-- 		,"costs"."tipoTransacción"
-- 		,"costs".Referencia
-- 		,"costs"."FechaTransacción"
-- 		,"costs"."Descripción"
 		,sum("costs".Abono) as 'Abono'
 		,sum("costs".Cargo) as 'Cargo'
-- 		,"costs".UnidadNegocio
-- 		,"costs".CentroCosto
-- 		,"costs".NombreEntidad
-- 		,"costs".Presupuesto
-- 		,"costs"."_source_company"
-- 		,"costs"."_period"
-- 		,"costs"."_key"
 		,"costs"."Año"
 from "costs"
 group by
 		 "costs".period
-- 		,"costs".SlotDescriptions
 		,"costs".label,"costs".tname,"costs".codename,"costs".Mes,"costs".NoCta
 		,"costs".NombreCta,"costs"."Compañía"
-- 		,"costs".Abono,"costs".Cargo
 		,"costs"."Año"
--------------------------------------------------------------------------------------------------------------------------
-- ===================================           	Bsu units				 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

select * from sistemas.dbo.general_view_bussiness_units 

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           View rel-Units with BSU  	 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use sistemas;

IF OBJECT_ID ('rentabilidad_remolque_bsu_units', 'V') IS NOT NULL
    DROP VIEW rentabilidad_remolque_bsu_units;
-- now build the view
create view rentabilidad_remolque_bsu_units
with encryption
as
		select 
				1 as "company_id"
				,"unit".id_unidad
				,"unit".id_tipo_motor
				,"unit".id_tipo_unidad
				,"unit".tipo_unidad
				,"unit".estatus
				,"unit".id_area
				,"typeunit".descripcion
				,"bsunit".label
				,"bsunit".name
				,"bsunit".tname
		from 
				"bonampakdb".dbo."mtto_unidades" as "unit"
		inner join 
				"bonampakdb".dbo.mtto_tipos_unidades as "typeunit"
			on
				"unit".id_tipo_unidad = "typeunit".id_tipo_unidad
		inner join 
				"sistemas".dbo.general_view_bussiness_units as "bsunit"
			on 
				"unit".id_area = "bsunit".id_area and "bsunit".projections_corporations_id = 1
		where 
				tipo_unidad = 1 -- and estatus  = 'A'

union all 
		
		select 
				2 as "company_id"
				,"unit".id_unidad
				,"unit".id_tipo_motor
				,"unit".id_tipo_unidad
				,"unit".tipo_unidad
				,"unit".estatus
				,"unit".id_area
				,"typeunit".descripcion
				,"bsunit".label
				,"bsunit".name
				,"bsunit".tname
		from 
				"macuspanadb".dbo."mtto_unidades" as "unit"
		inner join 
				"macuspanadb".dbo.mtto_tipos_unidades as "typeunit"
			on
				"unit".id_tipo_unidad = "typeunit".id_tipo_unidad
		inner join 
				"sistemas".dbo.general_view_bussiness_units as "bsunit"
			on 
				"unit".id_area = "bsunit".id_area and "bsunit".projections_corporations_id = 2
		where 
				tipo_unidad = 1 -- and estatus  = 'A'

union all
		
		select 
				3 as "company_id"
				,"unit".id_unidad
				,"unit".id_tipo_motor
				,"unit".id_tipo_unidad
				,"unit".tipo_unidad
				,"unit".estatus
				,"unit".id_area
				,"typeunit".descripcion
				,"bsunit".label
				,"bsunit".name
				,"bsunit".tname
		from 
				"tespecializadadb".dbo."mtto_unidades" as "unit"
		inner join 
				"tespecializadadb".dbo.mtto_tipos_unidades as "typeunit"
			on
				"unit".id_tipo_unidad = "typeunit".id_tipo_unidad
		inner join 
				"sistemas".dbo.general_view_bussiness_units as "bsunit"
			on 
				"unit".id_area = "bsunit".id_area and "bsunit".projections_corporations_id = 3
		where 
				tipo_unidad = 1 -- and estatus  = 'A'

				
				
--------------------------------------------------------------------------------------------------------------------------
-- ===================================          Dynamic SL Query			 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use sistemas;

IF OBJECT_ID ('rentabilidad_remolque_bsu_costos', 'V') IS NOT NULL
    DROP VIEW rentabilidad_remolque_bsu_costos;
-- now build the view
create view rentabilidad_remolque_bsu_costos
with encryption
as
		select 
				 "acc".Mes
				,"acc".NoCta
				,"acc".NombreCta
				,"acc".PerEnt
				,"acc".Compania as 'Compañía'
				,"acc".Tipo
				,"acc".Entidad
				,'' as 'distinto'
				,"acc".TipoTransaccion as 'tipoTransacción'
				,"acc".Referencia
				,"acc".ReferenciaExterna as 'FechaTransacción'
				,"acc".Descripcion as 'Descripción'
				,"acc".Abono
				,"acc".Cargo
				,"acc".UnidadNegocio
				,"acc".CentroCosto
				,"acc".NombreEntidad
				,"acc".Presupuesto
				,"acc".[_source_company]
				,"acc".[_period]
				,"acc".[_key]
				,"acc".FiscYr as 'Año'
		from 
				sistemas.dbo.reporter_view_report_accounts as "acc"
		where 
			   (
					(
						"_source_company" in ('ATMMAC','TEICUA','TCGTUL')
					)
				or
					(
						"_source_company" not in ('ATMMAC','TEICUA','TCGTUL')
					and
						"acc".Compania not in ('ATMMAC','TEICUA','TCGTUL')
					and
						UnidadNegocio not in ('00')
					)
				)

--------------------------------------------------------------------------------------------------------------------------
-- ===================================                  Testing 			  		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
				
with "costos" as (		
		select 
				 "acc".Mes
				,"acc".NoCta
				,"acc".NombreCta
				,"acc".PerEnt
				,"acc".Compania as 'Compañía'
				,"acc".Tipo
				,"acc".Entidad
				,'' as 'distinto'
				,"acc".TipoTransaccion as 'tipoTransacción'
				,"acc".Referencia
				,"acc".ReferenciaExterna as 'FechaTransacción'
				,"acc".Descripcion as 'Descripción'
				,"acc".Abono
				,"acc".Cargo
				,"acc".UnidadNegocio
				,"acc".CentroCosto
				,"acc".NombreEntidad
				,"acc".Presupuesto
				,"acc".[_source_company]
				,"acc".[_period]
				,"acc".[_key]
				,"acc".FiscYr as 'Año'
		from 
				sistemas.dbo.reporter_view_report_accounts as "acc"
		where 
			   (
					(
						"_source_company" in ('ATMMAC','TEICUA','TCGTUL')
					)
				or
					(
						"_source_company" not in ('ATMMAC','TEICUA','TCGTUL')
					and
						"acc".Compania not in ('ATMMAC','TEICUA','TCGTUL')
					and
						UnidadNegocio not in ('00')
					)
				)
)
select 
		"Año"
		,Mes,NoCta,NombreCta,CentroCosto,Compañía
		,[_source_company],[_period],[_key]
		,sum(Abono) as "Abono",sum(Cargo) as "Cargo",sum(Cargo-Abono) as "Real" 
from 
		"costos"
where 
		"Año" = '2018' 
	and 
		mes = 'Abril'
	and 
		CentroCosto = 'TT1151'  and NoCta = '0501070300'
group by
		NoCta,NombreCta,Mes,"Año",CentroCosto,Compañía,[_source_company],[_period],[_key]
						
with "sum" as (		
select * from integraapp.dbo.fetchCostosFijosOpOrizaba
where 
	NoCta = '0501070300' and CentroCosto = 'TT1151' and Mes = 'Abril' and Año = '2018' 		
union all 		
select * from integraapp.dbo.fetchCostosVariablesOpOrizaba
where 
	NoCta = '0501070300' and CentroCosto = 'TT1151' and Mes = 'Abril' and Año = '2018' 		
union all		
select * from integraapp.dbo.fetchCostosVariablesMttoOrizaba 
where 
	NoCta = '0501070300' and CentroCosto = 'TT1151' and Mes = 'Abril' and Año = '2018' 
union all				
select * from integraapp.dbo.fetchCostosFijosMttoOrizaba 
where 
	NoCta = '0501070300' and CentroCosto = 'TT1151' and Mes = 'Abril' and Año = '2018' 
)
select
		"Año"
		,Mes,NoCta,NombreCta,CentroCosto,Compañía
		,[_source_company],[_period],[_key]
		,sum(Abono) as "Abono",sum(Cargo) as "Cargo",sum(Cargo-Abono) as "Real" 
from "sum"
	where
		 "Año" = '2018'
	and 
		mes = 'Abril'
	and 
		CentroCosto = 'TT1151'  and NoCta = '0501070300'
group by
		NoCta,NombreCta,Mes,"Año",CentroCosto,Compañía,[_source_company],[_period],[_key]	
		
		
		
--  Testing area for conciliation match 

with "xls" as (
  select 
  		 "files".id
--  		,"files".user_id,"files".rentabilidad_remolque_docks_id
		,"slot".company_id
		,"slot".id_area
		,"slot".period
  		,"slot".descriptions as 'SlotDescriptions'
  		,"bsu".name
  		,"bsu".label
  		,"bsu".tname
  		,"files".filename
--  		,"files".md5sum,"files".file_size,"files".atime,"files".mtime,"files".ctime
--  		,"files".bsu_file
--  		,"files".bussiness_units
--  		,"files".created,"files".modified,"files".standing_id,"files".parent_id,"files".status
--   		,"content".block_reports_id
  		,"content".tracto
  		,"content".dolly
  		,"content".remolque1
  		,"content".remolque2
  		,"content".operacion
  		,"content".cliente
  		,"content".notes
  		,"blocks".codename
  		,"cost".Mes,"cost".NoCta,"cost".NombreCta,"cost".PerEnt,"cost".Compañía,"cost".Tipo
  		,"cost".Entidad,"cost".tipoTransacción,"cost".Referencia,"cost".FechaTransacción
  		,"cost".Descripción,"cost".Abono,"cost".Cargo,"cost".UnidadNegocio,"cost".CentroCosto
  		,"cost".NombreEntidad,"cost".Presupuesto,"cost".[_source_company],"cost".[_period],"cost".[_key],"cost".[Año]
  from 
  		sistemas.dbo.rentabilidad_remolque_files as "files"
  	inner join 
  		sistemas.dbo.rentabilidad_remolque_docks as "slot"
  	on 
  		"files".rentabilidad_remolque_docks_id = "slot".id and "slot".status = 1
  	inner join 
  		sistemas.dbo.general_view_bussiness_units as "bsu"
  	on 
  		"slot".company_id = "bsu".projections_corporations_id and "slot".id_area = "bsu".id_area
  	inner join 
  		sistemas.dbo.rentabilidad_content_files as "content"
  	on
  		"files".id = "content".rentabilidad_remolque_files_id and "content".status = 1
  	inner join 
  		sistemas.dbo.rentabilidad_remolque_blocks_reports as "blocks"
  	on
  		"content".block_reports_id = "blocks".id and "blocks".status = 1
  	--
  	left join 
  		sistemas.dbo.rentabilidad_remolque_bsu_costos as "cost"
  	on
  		"bsu".tname = "cost"."Compañía" and "slot".period = "cost".[_period]
	and 
		"content".tracto = "cost".CentroCosto 	
)
select * from "xls" 
--where 
--	"xls".CentroCosto = 'TT1177' 
--	and 
--	"xls".period = '201804'
			
	-- irma 1305
	
--	select * from sistemas.dbo.rentabilidad_remolque_bsu_costos
--	
	
-- ==================================================================================================================== --	
-- ===================================      	  					 		  ========================================= --
-- ==================================================================================================================== --

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           							 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
		
	






