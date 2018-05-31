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
-- go
IF OBJECT_ID('dbo.rentabilidad_remolque_parents', 'U') IS NOT NULL 
  DROP TABLE dbo.rentabilidad_remolque_parents; 
-- go
set ansi_nulls on
-- go
set quoted_identifier on
-- go
set ansi_padding on
-- go
 
create table [dbo].[rentabilidad_remolque_parents](
		id						int identity(1,1),
		parents_name			nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		created					datetime,
		modified				datetime,
		user_id					int,
		status					tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

insert into dbo.rentabilidad_remolque_parents values	  
										  ('File',CURRENT_TIMESTAMP,null,1,1)									-- 1
										 ,('Flags',CURRENT_TIMESTAMP,null,1,1)								-- 2
										;

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           Remolques Parents Definitions 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use [sistemas]

IF OBJECT_ID('dbo.rentabilidad_remolque_standings', 'U') IS NOT NULL 
  DROP TABLE dbo.rentabilidad_remolque_standings;  

set ansi_nulls on

set quoted_identifier on

set ansi_padding on
-- go
 
create table [dbo].[rentabilidad_remolque_standings](
		id									int identity(1,1),
		rentabilidad_remolque_parents_id	int,
		standings_name						nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		created								datetime,
		modified							datetime,
		user_id								int,
		status								tinyint default 1 null
) on [primary]
-- go

set ansi_padding off
-- go

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
-- ===================================           		blocks_reports		 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
										

IF OBJECT_ID('dbo.rentabilidad_remolque_blocks_reports', 'U') IS NOT NULL 
  DROP TABLE dbo.rentabilidad_remolque_blocks_reports; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

-- FileStorage 
create table [dbo].[rentabilidad_remolque_blocks_reports](
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

IF OBJECT_ID('dbo.rentabilidad_remolque_files', 'U') IS NOT NULL 
  DROP TABLE dbo.rentabilidad_remolque_files; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

-- FileStorage 
create table [dbo].[rentabilidad_remolque_files](
		"id"					int identity(1,1),
		"user_id"				int,
		"filename"				nvarchar(150) 		collate		sql_latin1_general_cp1_ci_as,
		"md5sum"				nvarchar(255)		collate		sql_latin1_general_cp1_ci_as,
		"file_size"				nvarchar(255)		collate		sql_latin1_general_cp1_ci_as,
	 	"atime" 				nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
	 	"mtime"					nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
	 	"ctime"					nvarchar(250)		collate		sql_latin1_general_cp1_ci_as,
		"bsu_file"				nvarchar(25) 		collate		sql_latin1_general_cp1_ci_as,
		"created"				datetime,
		"modified"				datetime,
		"standing_id"			int,
		"parent_id"				int,
		"status"				tinyint default 1 null
) on [primary]

set ansi_padding off

--  file example

	insert into sistemas.dbo.rentabilidad_remolque_files values 
						 (1,'first.xls','asdxxxx455wq','xxxx','atime','mtime','ctime','bsu_fil','ori',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
						,(1,'second.xls','asdxxxx4533','xxxx','atime','mtime','ctime','bsu_fil','ori',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,1,1)
						;

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           		FilesContent   		 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------

use sistemas

IF OBJECT_ID('dbo.rentabilidad_content_files', 'U') IS NOT NULL 
  DROP TABLE dbo.rentabilidad_content_files; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

-- FileStorageControl
create table [dbo].[rentabilidad_content_files](
		"id"									int identity(1,1),
		"rentabilidad_remolque_files_id"		int,
		"block_reports_id"						int,  -- this must be [ tolva, gondola , etc this is dynamic]
		"tracto"								nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"dolly"									nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"remolque1"								nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"remolque2"								nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"operacion"								nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"cliente"								nvarchar(25) 	collate		sql_latin1_general_cp1_ci_as,
		"notes"									text,
		"created"								datetime,
		"modified"								datetime,
		"standing_id"							int,
		"parent_id"								int,
		"status"								tinyint default 1 null
) on [primary]

set ansi_padding off


--------------------------------------------------------------------------------------------------------------------------
-- ===================================           		FilesContent   		 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------





-- ==================================================================================================================== --	
-- ===================================      	  Views definitions 		  ========================================= --
-- ==================================================================================================================== --


--------------------------------------------------------------------------------------------------------------------------
-- ===================================           	RentabilidadConciliation 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
---
--- 

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
		"Año",Mes,NoCta,NombreCta,CentroCosto,Compañía,[_source_company],[_period],[_key],sum(Abono) as "Abono",sum(Cargo) as "Cargo",sum(Cargo-Abono) as "Real" from "costos"
where 
		"Año" = '2018' 
	and 
		mes = 'Abril'
	and 
		CentroCosto = 'TT1177' 
group by
		NoCta,NombreCta,Mes,"Año",CentroCosto,Compañía,[_source_company],[_period],[_key]
						
				
				
				
				
				
-- ==================================================================================================================== --	
-- ===================================      	  					 		  ========================================= --
-- ==================================================================================================================== --

--------------------------------------------------------------------------------------------------------------------------
-- ===================================           							 		 ================================== --
--------------------------------------------------------------------------------------------------------------------------
		
	






