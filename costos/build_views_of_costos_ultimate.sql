-- ==================================================================================================================== --	
-- ==============================    Build Views for compatibility of legacy dev ====================================== --
-- ==================================================================================================================== --
-- old squema
--	use integraapp
--	IF OBJECT_ID ('fetchCostosAdministracionGst', 'V') IS NOT NULL
--		drop view fetchCostosAdministracionGst;
--		
--	CREATE VIEW dbo.fetchCostosAdministracionGst
--	AS                                                                             
--	SELECT Mes, NoCta, NombreCta, PerEnt, Compañía, Tipo, Entidad, distinto,       
--	   tipoTransacción, Referencia, FechaTransacción, Descripción, Abono,          
--	   Cargo, UnidadNegocio, CentroCosto, NombreEntidad, Presupuesto,              
--	   SUBSTRING(_period, 1, 4) AS 'Año'                                           
--	FROM sistemas.dbo.mr_source_reports                                            
--	WHERE "_key" = 'AD'
	--AND (_company = 'TBKORI')                                  

--
	use sistemas
	exec sp_helptext reporter_view_report_accounts
	exec sp_desc reporter_view_report_accounts
--

-- ==================================================================================================================== --	
-- =======================================    Check the Costos data    ================================================ --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('reporter_costos', 'V') IS NOT NULL
	drop view reporter_costos;
	
	create view reporter_costos
	as
		select 
			 "acc"."_source_company"
			,round(sum("acc".Cargo - "acc".Abono),3) as 'Real'
			,round(sum("acc".Presupuesto),3) as 'Presupuesto'
			,"acc"."_period"
			,"acc"."_key"
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
					UnidadNegocio not in ('00')
				)
			)
		group by
			  "acc"."_period"
			 ,"acc"."_source_company"
			 ,"acc"."_key"
			
-- ==================================================================================================================== --	
-- ====================================    Check the struct of a table   ============================================== --
-- ==================================================================================================================== --
use integraapp	

SELECT
		name,type
		,case type
			when	'P' 	then 	'Stored Procedures'
			when	'FN' 	then	'Scalar Functions'
			when	'IF'	then 	'Inline Table-Value Functions'
			when	'TF'	then	'Table-Value Functions'
			when	'U'		then	'Base Table'
			when	'V'		then	'View'
		end as 'Types'
FROM
	dbo.sysobjects
WHERE
	type IN
		(
--		'P', -- stored procedures
--		'FN', -- scalar functions
--		'IF', -- inline table-valued functions
--		'TF' -- table-valued functions
		'V' 
		)
	and name like '%Adm%'
ORDER BY type, name
	

-- ==================================================================================================================== --	
-- =======================================    Costos Administracion Gst    ============================================ --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosAdministracionGstDin', 'V') IS NOT NULL
	drop view fetchCostosAdministracionGstDin;
create view fetchCostosAdministracionGstDin
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'AD' 
	and
			(
				(
					"_source_company" in ('ATMMAC','TEICUA','TCGTUL')
				)
			or
				(
					"_source_company" not in ('ATMMAC','TEICUA','TCGTUL')
				and
					UnidadNegocio not in ('00')
				)
			)


-- ==================================================================================================================== --	
-- ========================    Costos (Transportacion) Operativos Fijos Orizaba  ====================================== --
-- ==================================================================================================================== --
	
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpOrizaba', 'V') IS NOT NULL
	drop view fetchCostosFijosOpOrizaba;
create view fetchCostosFijosOpOrizaba
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'TBKORI' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Orizaba  ====================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpOrizaba', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpOrizaba;
create view fetchCostosVariablesOpOrizaba
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" = 'TBKORI' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Orizaba  ====================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoOrizaba', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoOrizaba;
create view fetchCostosFijosMttoOrizaba
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" = 'TBKORI' and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- ==================    Costos (Transportacion) Mantenimiento Variables Orizaba  ===================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoOrizaba', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoOrizaba;
create view fetchCostosVariablesMttoOrizaba
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" = 'TBKORI' and "acc".UnidadNegocio not in ('00')
		
-- ==================================================================================================================== --	
-- =====================================    Costos Administracion Orizaba  ============================================ --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosAdministracionOrizaba', 'V') IS NOT NULL
	drop view fetchCostosAdministracionOrizaba;
create view fetchCostosAdministracionOrizaba
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'AD' and "acc"."_source_company" = 'TBKORI' and "acc".UnidadNegocio not in ('00')

		
-- /** END Orizaba*/
-- ==================================================================================================================== --	
-- =====================    Costos (Transportacion) Operativos Fijos Guadalajara  ===================================== --
-- ==================================================================================================================== --
	
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpGdl', 'V') IS NOT NULL
	drop view fetchCostosFijosOpGdl;
create view fetchCostosFijosOpGdl
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" in ('TBKGDL','TBKCUL') and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Guadalajara =================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpGdl', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpGdl;
create view fetchCostosVariablesOpGdl
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" in ('TBKGDL','TBKCUL') and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Guadalajara =================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoGdl', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoGdl;
create view fetchCostosFijosMttoGdl
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" in ('TBKGDL','TBKCUL') and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- =================    Costos (Transportacion) Mantenimiento Variables Guadalajara  ================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoGdl', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoGdl;
create view fetchCostosVariablesMttoGdl
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" in ('TBKGDL','TBKCUL') and "acc".UnidadNegocio not in ('00')	
		
-- /** End Guadalajara */

-- ==================================================================================================================== --	
-- =====================    Costos (Transportacion) Operativos Fijos Hermosillo  ===================================== --
-- ==================================================================================================================== --
	
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpHermosillo', 'V') IS NOT NULL
	drop view fetchCostosFijosOpHermosillo;
create view fetchCostosFijosOpHermosillo
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'TBKHER' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Hermosillo =================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpHermosillo', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpHermosillo;
create view fetchCostosVariablesOpHermosillo
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" = 'TBKHER' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Hermosillo =================================== --
-- ==================================================================================================================== --
		
--	compability mode	fetchCostosFijosMttoHer and fetchCostosFijosMttoHerDin
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoHermosillo', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoHermosillo;
create view fetchCostosFijosMttoHermosillo
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" = 'TBKHER' and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- =================    Costos (Transportacion) Mantenimiento Variables Hermosillo  ================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoHermosillo', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoHermosillo;
create view fetchCostosVariablesMttoHermosillo
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" = 'TBKHER' and "acc".UnidadNegocio not in ('00')
		
		
-- /** End Hermosillo */
		
	
-- ==================================================================================================================== --	
-- =====================      Costos (Transportacion) Operativos Fijos La Paz     ===================================== --
-- ==================================================================================================================== --
	
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpLaPaz', 'V') IS NOT NULL
	drop view fetchCostosFijosOpLaPaz;
create view fetchCostosFijosOpLaPaz
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'TBKLAP' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables LaPaz =================================== --
-- ==================================================================================================================== --
--		fetchCostosVariablesOpLap and fetchCostosVariablesOpLaPazDin
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpLaPaz', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpLaPaz;
create view fetchCostosVariablesOpLaPaz
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" = 'TBKLAP' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables LaPaz =================================== --
-- ==================================================================================================================== --
		
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoLaPaz', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoLaPaz;
create view fetchCostosFijosMttoLaPaz
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" = 'TBKLAP' and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- =================    Costos (Transportacion) Mantenimiento Variables LaPaz  ================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoLaPaz', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoLaPaz;
create view fetchCostosVariablesMttoLaPaz
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" = 'TBKLAP' and "acc".UnidadNegocio not in ('00')
		
		
-- /** End La Paz */

		

-- ==================================================================================================================== --	
-- =====================      Costos (Transportacion) Operativos Fijos Mexicali     ===================================== --
-- ==================================================================================================================== --
	
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpMex', 'V') IS NOT NULL
	drop view fetchCostosFijosOpMex;
create view fetchCostosFijosOpMex
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'TBKTIJ' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Mex =================================== --
-- ==================================================================================================================== --
--		fetchCostosVariablesOpLap and fetchCostosVariablesOpMexDin
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpMex', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpMex;
create view fetchCostosVariablesOpMex
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" = 'TBKTIJ' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Mex =================================== --
-- ==================================================================================================================== --
		
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoMex', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoMex;
create view fetchCostosFijosMttoMex
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" = 'TBKTIJ' and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- =================    Costos (Transportacion) Mantenimiento Variables Mex  ================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoMex', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoMex;
create view fetchCostosVariablesMttoMex
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" = 'TBKTIJ' and "acc".UnidadNegocio not in ('00')
		
-- /**End Mexicali*/
		
		
		

-- ==================================================================================================================== --	
-- =====================      Costos (Transportacion) Operativos Fijos Ramos      ===================================== --
-- ==================================================================================================================== --
	
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpRamos', 'V') IS NOT NULL
	drop view fetchCostosFijosOpRamos;
create view fetchCostosFijosOpRamos
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'TBKRAM' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Ramos =================================== --
-- ==================================================================================================================== --
--		fetchCostosVariablesOpLap and fetchCostosVariablesOpRamosDin
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpRamos', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpRamos;
create view fetchCostosVariablesOpRamos
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" = 'TBKRAM' and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Ramos =================================== --
-- ==================================================================================================================== --
		
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoRamos', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoRamos;
create view fetchCostosFijosMttoRamos
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" = 'TBKRAM' and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- =================    Costos (Transportacion) Mantenimiento Variables Ramos  ================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoRamos', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoRamos;
create view fetchCostosVariablesMttoRamos
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" = 'TBKRAM' and "acc".UnidadNegocio not in ('00')
		
		
-- /* End of Ramos **/		
		
	

-- ==================================================================================================================== --	
-- =====================      Costos (Transportacion) Operativos Fijos Cuautitlan      ===================================== --
-- ==================================================================================================================== --
-- costosFijosOperativosTeisa && costosFijosOperativosTeisaDin
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpCuautitlan', 'V') IS NOT NULL
	drop view fetchCostosFijosOpCuautitlan;
create view fetchCostosFijosOpCuautitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'TEICUA' --and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Cuautitlan =================================== --
-- ==================================================================================================================== --
-- costosVariablesOperativosTeisa  &&  costosVariablesOperativosTeisaDin

use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpCuautitlan', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpCuautitlan;
create view fetchCostosVariablesOpCuautitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" = 'TEICUA' --and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Cuautitlan =================================== --
-- ==================================================================================================================== --
-- fetchGastosFijosMantenimientoTeicua && fetchGastosFijosMantenimientoTeicuaDin
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoCuautitlan', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoCuautitlan;
create view fetchCostosFijosMttoCuautitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" = 'TEICUA' --and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- =================    Costos (Transportacion) Mantenimiento Variables Cuautitlan  ================================== --
-- ==================================================================================================================== --
-- fetchGastosVariablesMantenimientoTeicua && fetchGastosVariablesMantenimientoTeicuaDin		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoCuautitlan', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoCuautitlan;
create view fetchCostosVariablesMttoCuautitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" = 'TEICUA' --and "acc".UnidadNegocio not in ('00')
		
		
-- ==================================================================================================================== --	
-- ===================================== Costos Administracion Cuautitlan  ============================================ --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosAdministracionCuautitlan', 'V') IS NOT NULL
	drop view fetchCostosAdministracionCuautitlan;
create view fetchCostosAdministracionCuautitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'AD' and "acc"."_source_company" = 'TEICUA' --and "acc".UnidadNegocio not in ('00')



--/** End of Cuatitlan */				
 
-- ==================================================================================================================== --	
-- ========================    Costos (Transportacion) Operativos Fijos Tultitlan  ====================================== --
-- ==================================================================================================================== --
	
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpTultitlan', 'V') IS NOT NULL
	drop view fetchCostosFijosOpTultitlan;
create view fetchCostosFijosOpTultitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'TCGTUL' --and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Tultitlan  ====================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpTultitlan', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpTultitlan;
create view fetchCostosVariablesOpTultitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" = 'TCGTUL' --and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Tultitlan  ====================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoTultitlan', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoTultitlan;
create view fetchCostosFijosMttoTultitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" = 'TCGTUL' --and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- ==================    Costos (Transportacion) Mantenimiento Variables Tultitlan  ===================================== --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoTultitlan', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoTultitlan;
create view fetchCostosVariablesMttoTultitlan
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" = 'TCGTUL' --and "acc".UnidadNegocio not in ('00')
		
-- /**End of Tultitlan*/		

-- ==================================================================================================================== --	
-- ========================    Costos (Transportacion) Operativos Fijos Macuspana  ====================================== --
-- ==================================================================================================================== --
-- fetchViewOperacionesFijosAtm
		
use integraapp
IF OBJECT_ID ('fetchCostosFijosOpMacuspana', 'V') IS NOT NULL
	drop view fetchCostosFijosOpMacuspana;
create view fetchCostosFijosOpMacuspana
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'ATMMAC' --and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Macuspana  ====================================== --
-- ==================================================================================================================== --
-- fetchCostosVariablesOpAtm	
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesOpMacuspana', 'V') IS NOT NULL
	drop view fetchCostosVariablesOpMacuspana;
create view fetchCostosVariablesOpMacuspana
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OV' and "acc"."_source_company" = 'ATMMAC' --and "acc".UnidadNegocio not in ('00')


-- ==================================================================================================================== --	
-- ====================    Costos (Transportacion) Operativos Variables Macuspana  ====================================== --
-- ==================================================================================================================== --
-- fetchCostosFijosMttoAtm
		
use integraapp
IF OBJECT_ID ('fetchCostosFijosMttoMacuspana', 'V') IS NOT NULL
	drop view fetchCostosFijosMttoMacuspana;
create view fetchCostosFijosMttoMacuspana
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MF' and "acc"."_source_company" = 'ATMMAC' --and "acc".UnidadNegocio not in ('00')

-- ==================================================================================================================== --	
-- ==================    Costos (Transportacion) Mantenimiento Variables Macuspana  ===================================== --
-- ==================================================================================================================== --
-- fetchCostosVariablesMttoAtm	
		
use integraapp
IF OBJECT_ID ('fetchCostosVariablesMttoMacuspana', 'V') IS NOT NULL
	drop view fetchCostosVariablesMttoMacuspana;
create view fetchCostosVariablesMttoMacuspana
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'MV' and "acc"."_source_company" = 'ATMMAC' --and "acc".UnidadNegocio not in ('00')


		
		
-- ==================================================================================================================== --	
-- ===================================== Costos Administracion Macuspana  ============================================ --
-- ==================================================================================================================== --
		
		
use integraapp
IF OBJECT_ID ('fetchCostosAdministracionMacuspana', 'V') IS NOT NULL
	drop view fetchCostosAdministracionMacuspana;
create view fetchCostosAdministracionMacuspana
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
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'AD' and "acc"."_source_company" = 'ATMMAC'-- and "acc".UnidadNegocio not in ('00')


		
		