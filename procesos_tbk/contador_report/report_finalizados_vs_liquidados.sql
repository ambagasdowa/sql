-- ==================================================================================================================== --	
-- ==================================    add permissions to a user "integra"   ======================================== --
-- ==================================================================================================================== --
use bonampakdb
	grant select on "bonampakdb"."dbo"."trafico_producto" to "integra"		
	grant select on "bonampakdb"."dbo"."desp_flotas" to "integra"
	grant select on "bonampakdb"."dbo"."desp_tipooperacion" to "integra"
	grant select on "bonampakdb"."dbo"."trafico_configuracionviaje" to "integra"
	grant select on "bonampakdb"."dbo"."trafico_cliente" to "integra"
	grant select on "bonampakdb"."dbo"."trafico_renglon_guia" to "integra"
	grant select on "bonampakdb"."dbo"."trafico_guia" to "integra"
-- Create a role to view tables and views 
	use macuspanadb
	CREATE ROLE [report] AUTHORIZATION enuma;
-- watch the role for users
	exec sp_helpuser 'integra' --check the user in db
	exec sp_helprole -- check roles
	exec sp_helplogins 'integra' -- check login user has a login ?
	
-- Add user to a role
	use macuspanadb
	exec sp_addrolemember 'report' , 'integra'
		
-- Grant View Permission on tables of db
	use macuspanadb
	grant select on "macuspanadb"."dbo"."general_area" to "report"
	grant select on "macuspanadb"."dbo"."trafico_viaje" to "report"
	grant select on "macuspanadb"."dbo"."personal_personal" to "report"
	grant select on "macuspanadb"."dbo"."trafico_ruta" to "report"
	grant select on "macuspanadb"."dbo"."trafico_plaza" to "report"
	grant select on "macuspanadb"."dbo"."mtto_unidades" to "report"
	grant select on "macuspanadb"."dbo"."trafico_liquidacion" to "report"
	grant select on "macuspanadb"."dbo"."atm_view_anticipos_conv_gto" to "report"
	grant select on "macuspanadb"."dbo"."trafico_producto" to "report"	
	grant select on "macuspanadb"."dbo"."desp_flotas" to "report"
	grant select on "macuspanadb"."dbo"."desp_tipooperacion" to "report"
	grant select on "macuspanadb"."dbo"."trafico_configuracionviaje" to "report"
	grant select on "macuspanadb"."dbo"."trafico_cliente" to "report"
	grant select on "macuspanadb"."dbo"."trafico_renglon_guia" to "report"
	grant select on "macuspanadb"."dbo"."trafico_guia" to "report"

-- For teisa	
-- Create a role to view tables and views 
	use tespecializadadb
	CREATE ROLE [report] AUTHORIZATION enuma;
-- watch the role for users
	exec sp_helpuser 'integra' --check the user in db
	exec sp_helprole -- check roles
	exec sp_helplogins 'integra' -- check login user has a login ?
	
-- Add user to a role
	use tespecializadadb
	exec sp_addrolemember 'report' , 'integra'
		
-- Grant View Permission on tables of MR         
	use tespecializadadb
	grant select on "tespecializadadb"."dbo"."general_area" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_viaje" to "report"
	grant select on "tespecializadadb"."dbo"."personal_personal" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_ruta" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_plaza" to "report"
	grant select on "tespecializadadb"."dbo"."mtto_unidades" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_liquidacion" to "report"
	grant select on "tespecializadadb"."dbo"."tei_view_anticipos_conv_gto" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_producto" to "report"
	grant select on "tespecializadadb"."dbo"."desp_flotas" to "report"
	grant select on "tespecializadadb"."dbo"."desp_tipooperacion" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_configuracionviaje" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_cliente" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_renglon_guia" to "report"
	grant select on "tespecializadadb"."dbo"."trafico_guia" to "report"
	


-- ==================================================================================================================== --	
-- ==================================    set the data to a user "integra"   ======================================== --
-- ==================================================================================================================== --
select * from sistemas.dbo.report_finalizados_vs_liquidados
-- =============================================================================================================== --
-- 								View
-- =============================================================================================================== --

use sistemas;

IF OBJECT_ID ('report_finalizados_vs_liquidados', 'V') IS NOT NULL
	DROP VIEW report_finalizados_vs_liquidados;

create view report_finalizados_vs_liquidados
	as
	select 
			 id_company,no_viaje ,id_area ,area ,desc_plaza 
			,personal_personal_a_nombre as 'personal_personal_a.nombre' ,id_unidad ,status_viaje 
			,fecha_real_viaje ,desc_ruta ,id_remolque1 ,id_dolly ,id_remolque2 ,id_operador2 
			,personal_personal_b_nombre as 'personal_personal_b.nombre '
			,personal_personal_a_id_personal as 'personal_personal_a.id_personal'
			,personal_personal_b_id_personal as 'personal_personal_b.id_personal'
			,tercero ,fecha_real_fin_viaje ,ant_week ,ant_year 
			,ant_month ,liq_week ,liq_year ,liq_month ,fecha_liquidacion   ,viajes_liquidados ,viajes_pendientes
	from openquery(local,'sistemas.dbo.sp_zd1x_getEndingTripsVsLiq')

-- =============================================================================================================== --
-- 								Store
-- =============================================================================================================== --
use sistemas;

/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : September 20, 2016
 Description    : Quering some kind of report for something ???
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/
 
ALTER PROCEDURE sp_zd1x_getEndingTripsVsLiq
 with encryption
 as 
 	SET NOCOUNT ON
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

set datefirst 5 -- change the start of week to thursday

select
			 '1' as "id_company",no_viaje ,id_area ,area ,desc_plaza 
			,personal_personal_a_nombre,id_unidad ,status_viaje 
			,fecha_real_viaje ,desc_ruta ,id_remolque1 ,id_dolly ,id_remolque2 ,id_operador2 
			,personal_personal_b_nombre
			,personal_personal_a_id_personal
			,personal_personal_b_id_personal
			,tercero ,fecha_real_fin_viaje ,ant_week ,ant_year 
			,ant_month ,liq_week ,liq_year ,liq_month ,fecha_liquidacion   ,viajes_liquidados ,viajes_pendientes
from 
			reporter_trips_liqs_tbks
union all
select
			 '2' as "id_company",no_viaje ,id_area ,area ,desc_plaza 
			,personal_personal_a_nombre,id_unidad ,status_viaje 
			,fecha_real_viaje ,desc_ruta ,id_remolque1 ,id_dolly ,id_remolque2 ,id_operador2 
			,personal_personal_b_nombre
			,personal_personal_a_id_personal
			,personal_personal_b_id_personal
			,tercero ,fecha_real_fin_viaje ,ant_week ,ant_year 
			,ant_month ,liq_week ,liq_year ,liq_month ,fecha_liquidacion   ,viajes_liquidados ,viajes_pendientes
from 
			reporter_trips_liqs_atms
union all
select
			 '3' as "id_company",no_viaje ,id_area ,area ,desc_plaza 
			,personal_personal_a_nombre,id_unidad ,status_viaje 
			,fecha_real_viaje ,desc_ruta ,id_remolque1 ,id_dolly ,id_remolque2 ,id_operador2 
			,personal_personal_b_nombre
			,personal_personal_a_id_personal
			,personal_personal_b_id_personal
			,tercero ,fecha_real_fin_viaje ,ant_week ,ant_year 
			,ant_month ,liq_week ,liq_year ,liq_month ,fecha_liquidacion   ,viajes_liquidados ,viajes_pendientes
from 
			reporter_trips_liqs_teis
			
			
-- =============================================================================================================== --
-- 								Source Views
-- =============================================================================================================== --		

-- TBK			
use sistemas
-- go
IF OBJECT_ID ('reporter_trips_liqs_tbks', 'V') IS NOT NULL
    DROP VIEW reporter_trips_liqs_tbks;
-- go

create view reporter_trips_liqs_tbks
with encryption
as

with "antilope" as 
	(
		select
				 trafico_viaje.no_viaje
	    		,"trafico_viaje".id_area
				,(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
					from
							bonampakdb.dbo.general_area as "areas"
					where
							areas.id_area = "trafico_viaje".id_area
				 ) as 'area'
				,trafico_plaza_a.desc_plaza
				,personal_personal_a.nombre as 'personal_personal_a_nombre'
				,trafico_viaje.id_unidad
				,trafico_viaje.status_viaje
				,trafico_viaje.fecha_real_viaje
				,trafico_viaje.fecha_real_fin_viaje
				,trafico_ruta.desc_ruta
				,trafico_viaje.id_remolque1
				,trafico_viaje.id_dolly
				,trafico_viaje.id_remolque2
				,trafico_viaje.id_operador2
				,personal_personal_b.nombre as 'personal_personal_b_nombre'
				,personal_personal_a.id_personal as 'personal_personal_a_id_personal'
				,personal_personal_b.id_personal as 'personal_personal_b_id_personal'
				,mtto_unidades.tercero
				,datepart(week,trafico_viaje.fecha_real_fin_viaje) as 'week'
				,datepart(year,trafico_viaje.fecha_real_fin_viaje) as 'year'
				,datepart(month,trafico_viaje.fecha_real_fin_viaje) as 'month'
		from
				bonampakdb.dbo.trafico_viaje as "trafico_viaje"
		inner join 
				bonampakdb.dbo.personal_personal as "personal_personal_a" on trafico_viaje.id_personal = personal_personal_a.id_personal
		inner join
				bonampakdb.dbo.trafico_ruta as "trafico_ruta" on trafico_ruta.id_ruta = trafico_viaje.id_ruta
		inner join
				bonampakdb.dbo.trafico_plaza as "trafico_plaza_a" on trafico_ruta.destino_ruta = trafico_plaza_a.id_plaza
		inner join
				bonampakdb.dbo.trafico_plaza as "trafico_plaza_b" on trafico_plaza_b.id_plaza = trafico_ruta.origen_ruta
		inner join
				bonampakdb.dbo.mtto_unidades as "mtto_unidades" on mtto_unidades.id_unidad = trafico_viaje.id_unidad
		left join
		 		bonampakdb.dbo.personal_personal as "personal_personal_b" on trafico_viaje.id_operador2 = personal_personal_b.id_personal
		where
				( -- Apparently this mean pending of liquidation
					(
							trafico_viaje.fecha_real_viaje is not null
						and
							trafico_viaje.no_liquidacion is null
						and
							trafico_viaje.status_viaje =('R')
					)
					or -- otherwise, this is the counterpart ? mmm, maybe
					(
							trafico_viaje.fecha_real_viaje is not null
						and
							trafico_viaje.no_liquidacion is not null
						and
							trafico_viaje.status_viaje =('C')
					)
				)
			and
					year(trafico_viaje.fecha_real_fin_viaje) = year(CURRENT_TIMESTAMP)
	)
	select 
		  "anticipo".no_viaje 
		 ,"anticipo".id_area
		 ,"anticipo".area 
		 ,"anticipo".desc_plaza 
		 ,"anticipo"."personal_personal_a_nombre" 
		 ,"anticipo".id_unidad 
		 ,"anticipo".status_viaje
		 ,"anticipo".fecha_real_viaje
		 ,"anticipo".desc_ruta 
		 ,"anticipo".id_remolque1 
		 ,"anticipo".id_dolly
		 ,"anticipo".id_remolque2 
		 ,"anticipo".id_operador2 
		 ,"anticipo"."personal_personal_b_nombre" 
		 ,"anticipo"."personal_personal_a_id_personal" 
		 ,"anticipo"."personal_personal_b_id_personal" 
		 ,"anticipo".tercero
		 ,"anticipo".fecha_real_fin_viaje
		 ,"anticipo"."week" as 'ant_week'
		 ,"anticipo"."year" as 'ant_year'
		 ,"anticipo"."month" as 'ant_month'
		 ,"liquidacion"."week" as 'liq_week'
		 ,"liquidacion"."year" as 'liq_year'
		 ,"liquidacion"."month" as 'liq_month'
		 ,"liquidacion".fecha_liquidacion
		,case 
			when "anticipo"."week" = "liquidacion"."week"
				then 1
			when "liquidacion"."week" is null
				then 0
			else 
				null
		end as 'viajes_liquidados'
		,case 
			when "anticipo"."week" = "liquidacion"."week"
				then 0
			when "liquidacion"."week" is null
				then 1
			else 
				null
		end as 'viajes_pendientes'
	from 
			"antilope" as "anticipo"
	left join
				(
					select
						"liquidacion".id_area
						,(
							select
									ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
							from 
									bonampakdb.dbo.general_area as "areas"
							where 
									areas.id_area = "liquidacion".id_area
						) as 'area'
						,"liquidacion".no_liquidacion
						,"viaje".no_viaje
						,"viaje".id_personal
						,"viaje".fecha_viaje
						,"viaje".fecha_fin_viaje
						,"viaje".fecha_real_viaje
						,"viaje".fecha_real_fin_viaje
						,"viaje".id_unidad
						,"liquidacion".fecha_liquidacion
						,datepart(week,"liquidacion".fecha_liquidacion) as 'week'
						,datepart(year,"liquidacion".fecha_liquidacion) as 'year'
						,datepart(month,"liquidacion".fecha_liquidacion) as 'month'
					from
							bonampakdb.dbo.trafico_liquidacion as "liquidacion" 
						inner join 
									bonampakdb.dbo.trafico_viaje  as "viaje" 
							on
									"liquidacion".id_area = "viaje".id_area_liq
							and 
									"liquidacion".no_liquidacion = "viaje".no_liquidacion
							and
									"liquidacion".status_liq = 'A'
					where					
							year("liquidacion".fecha_liquidacion) = year(CURRENT_TIMESTAMP)
				)
		as "liquidacion" on "liquidacion".id_area = "anticipo".id_area and "liquidacion".no_viaje = "anticipo".no_viaje 
			and
				"anticipo"."year" = "liquidacion"."year"
				
-- ATM 
		
use sistemas
-- go
IF OBJECT_ID ('reporter_trips_liqs_atms', 'V') IS NOT NULL
    DROP VIEW reporter_trips_liqs_atms;
-- go

create view reporter_trips_liqs_atms
with encryption
as

with "antilope" as 
	(
		select
				 trafico_viaje.no_viaje
	    		,"trafico_viaje".id_area
				,(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
					from
							macuspanadb.dbo.general_area as "areas"
					where
							areas.id_area = "trafico_viaje".id_area
				 ) as 'area'
				,trafico_plaza_a.desc_plaza
				,personal_personal_a.nombre as 'personal_personal_a_nombre'
				,trafico_viaje.id_unidad
				,trafico_viaje.status_viaje
				,trafico_viaje.fecha_real_viaje
				,trafico_viaje.fecha_real_fin_viaje
				,trafico_ruta.desc_ruta
				,trafico_viaje.id_remolque1
				,trafico_viaje.id_dolly
				,trafico_viaje.id_remolque2
				,trafico_viaje.id_operador2
				,personal_personal_b.nombre as 'personal_personal_b_nombre'
				,personal_personal_a.id_personal as 'personal_personal_a_id_personal'
				,personal_personal_b.id_personal as 'personal_personal_b_id_personal'
				,mtto_unidades.tercero
				,datepart(week,trafico_viaje.fecha_real_fin_viaje) as 'week'
				,datepart(year,trafico_viaje.fecha_real_fin_viaje) as 'year'
				,datepart(month,trafico_viaje.fecha_real_fin_viaje) as 'month'
		from
				macuspanadb.dbo.trafico_viaje as "trafico_viaje"
		inner join 
				macuspanadb.dbo.personal_personal as "personal_personal_a" on trafico_viaje.id_personal = personal_personal_a.id_personal
		inner join
				macuspanadb.dbo.trafico_ruta as "trafico_ruta" on trafico_ruta.id_ruta = trafico_viaje.id_ruta
		inner join
				macuspanadb.dbo.trafico_plaza as "trafico_plaza_a" on trafico_ruta.destino_ruta = trafico_plaza_a.id_plaza
		inner join
				macuspanadb.dbo.trafico_plaza as "trafico_plaza_b" on trafico_plaza_b.id_plaza = trafico_ruta.origen_ruta
		inner join
				macuspanadb.dbo.mtto_unidades as "mtto_unidades" on mtto_unidades.id_unidad = trafico_viaje.id_unidad
		left join
		 		macuspanadb.dbo.personal_personal as "personal_personal_b" on trafico_viaje.id_operador2 = personal_personal_b.id_personal
		where
				( -- Apparently this mean pending of liquidation
					(
							trafico_viaje.fecha_real_viaje is not null
						and
							trafico_viaje.no_liquidacion is null
						and
							trafico_viaje.status_viaje =('R')
					)
					or -- otherwise, this is the counterpart ? mmm, maybe
					(
							trafico_viaje.fecha_real_viaje is not null
						and
							trafico_viaje.no_liquidacion is not null
						and
							trafico_viaje.status_viaje =('C')
					)
				)
			and
					year(trafico_viaje.fecha_real_fin_viaje) = year(CURRENT_TIMESTAMP)
	)
	select 
		  "anticipo".no_viaje 
		 ,"anticipo".id_area
		 ,"anticipo".area 
		 ,"anticipo".desc_plaza 
		 ,"anticipo"."personal_personal_a_nombre" 
		 ,"anticipo".id_unidad 
		 ,"anticipo".status_viaje
		 ,"anticipo".fecha_real_viaje
		 ,"anticipo".desc_ruta 
		 ,"anticipo".id_remolque1 
		 ,"anticipo".id_dolly
		 ,"anticipo".id_remolque2 
		 ,"anticipo".id_operador2 
		 ,"anticipo"."personal_personal_b_nombre" 
		 ,"anticipo"."personal_personal_a_id_personal" 
		 ,"anticipo"."personal_personal_b_id_personal" 
		 ,"anticipo".tercero
		 ,"anticipo".fecha_real_fin_viaje
		 ,"anticipo"."week" as 'ant_week'
		 ,"anticipo"."year" as 'ant_year'
		 ,"anticipo"."month" as 'ant_month'
		 ,"liquidacion"."week" as 'liq_week'
		 ,"liquidacion"."year" as 'liq_year'
		 ,"liquidacion"."month" as 'liq_month'
		 ,"liquidacion".fecha_liquidacion
		,case 
			when "anticipo"."week" = "liquidacion"."week"
				then 1
			when "liquidacion"."week" is null
				then 0
			else 
				null
		end as 'viajes_liquidados'
		,case 
			when "anticipo"."week" = "liquidacion"."week"
				then 0
			when "liquidacion"."week" is null
				then 1
			else 
				null
		end as 'viajes_pendientes'
	from 
			"antilope" as "anticipo"
	left join
				(
					select
						"liquidacion".id_area
						,(
							select
									ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
							from 
									macuspanadb.dbo.general_area as "areas"
							where 
									areas.id_area = "liquidacion".id_area
						) as 'area'
						,"liquidacion".no_liquidacion
						,"viaje".no_viaje
						,"viaje".id_personal
						,"viaje".fecha_viaje
						,"viaje".fecha_fin_viaje
						,"viaje".fecha_real_viaje
						,"viaje".fecha_real_fin_viaje
						,"viaje".id_unidad
						,"liquidacion".fecha_liquidacion
						,datepart(week,"liquidacion".fecha_liquidacion) as 'week'
						,datepart(year,"liquidacion".fecha_liquidacion) as 'year'
						,datepart(month,"liquidacion".fecha_liquidacion) as 'month'
					from
							macuspanadb.dbo.trafico_liquidacion as "liquidacion" 
						inner join 
									macuspanadb.dbo.trafico_viaje  as "viaje" 
							on
									"liquidacion".id_area = "viaje".id_area_liq
							and 
									"liquidacion".no_liquidacion = "viaje".no_liquidacion
							and
									"liquidacion".status_liq = 'A'
					where					
							year("liquidacion".fecha_liquidacion) = year(CURRENT_TIMESTAMP)
				)
		as "liquidacion" on "liquidacion".id_area = "anticipo".id_area and "liquidacion".no_viaje = "anticipo".no_viaje 
			and
				"anticipo"."year" = "liquidacion"."year"
				
-- TEISA
				
use sistemas
-- go
IF OBJECT_ID ('reporter_trips_liqs_teis', 'V') IS NOT NULL
    DROP VIEW reporter_trips_liqs_teis;
-- go

create view reporter_trips_liqs_teis
with encryption
as

with "antilope" as 
	(
		select
				 trafico_viaje.no_viaje
	    		,"trafico_viaje".id_area
				,(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
					from
							tespecializadadb.dbo.general_area as "areas"
					where
							areas.id_area = "trafico_viaje".id_area
				 ) as 'area'
				,trafico_plaza_a.desc_plaza
				,personal_personal_a.nombre as 'personal_personal_a_nombre'
				,trafico_viaje.id_unidad
				,trafico_viaje.status_viaje
				,trafico_viaje.fecha_real_viaje
				,trafico_viaje.fecha_real_fin_viaje
				,trafico_ruta.desc_ruta
				,trafico_viaje.id_remolque1
				,trafico_viaje.id_dolly
				,trafico_viaje.id_remolque2
				,trafico_viaje.id_operador2
				,personal_personal_b.nombre as 'personal_personal_b_nombre'
				,personal_personal_a.id_personal as 'personal_personal_a_id_personal'
				,personal_personal_b.id_personal as 'personal_personal_b_id_personal'
				,mtto_unidades.tercero
				,datepart(week,trafico_viaje.fecha_real_fin_viaje) as 'week'
				,datepart(year,trafico_viaje.fecha_real_fin_viaje) as 'year'
				,datepart(month,trafico_viaje.fecha_real_fin_viaje) as 'month'
		from
				tespecializadadb.dbo.trafico_viaje as "trafico_viaje"
		inner join 
				tespecializadadb.dbo.personal_personal as "personal_personal_a" on trafico_viaje.id_personal = personal_personal_a.id_personal
		inner join
				tespecializadadb.dbo.trafico_ruta as "trafico_ruta" on trafico_ruta.id_ruta = trafico_viaje.id_ruta
		inner join
				tespecializadadb.dbo.trafico_plaza as "trafico_plaza_a" on trafico_ruta.destino_ruta = trafico_plaza_a.id_plaza
		inner join
				tespecializadadb.dbo.trafico_plaza as "trafico_plaza_b" on trafico_plaza_b.id_plaza = trafico_ruta.origen_ruta
		inner join
				tespecializadadb.dbo.mtto_unidades as "mtto_unidades" on mtto_unidades.id_unidad = trafico_viaje.id_unidad
		left join
		 		tespecializadadb.dbo.personal_personal as "personal_personal_b" on trafico_viaje.id_operador2 = personal_personal_b.id_personal
		where
				( -- Apparently this mean pending of liquidation
					(
							trafico_viaje.fecha_real_viaje is not null
						and
							trafico_viaje.no_liquidacion is null
						and
							trafico_viaje.status_viaje =('R')
					)
					or -- otherwise, this is the counterpart ? mmm, maybe
					(
							trafico_viaje.fecha_real_viaje is not null
						and
							trafico_viaje.no_liquidacion is not null
						and
							trafico_viaje.status_viaje =('C')
					)
				)
			and
					year(trafico_viaje.fecha_real_fin_viaje) = year(CURRENT_TIMESTAMP)
	)
	select 
		  "anticipo".no_viaje 
		 ,"anticipo".id_area
		 ,"anticipo".area 
		 ,"anticipo".desc_plaza 
		 ,"anticipo"."personal_personal_a_nombre" 
		 ,"anticipo".id_unidad 
		 ,"anticipo".status_viaje
		 ,"anticipo".fecha_real_viaje
		 ,"anticipo".desc_ruta 
		 ,"anticipo".id_remolque1 
		 ,"anticipo".id_dolly
		 ,"anticipo".id_remolque2 
		 ,"anticipo".id_operador2 
		 ,"anticipo"."personal_personal_b_nombre" 
		 ,"anticipo"."personal_personal_a_id_personal" 
		 ,"anticipo"."personal_personal_b_id_personal" 
		 ,"anticipo".tercero
		 ,"anticipo".fecha_real_fin_viaje
		 ,"anticipo"."week" as 'ant_week'
		 ,"anticipo"."year" as 'ant_year'
		 ,"anticipo"."month" as 'ant_month'
		 ,"liquidacion"."week" as 'liq_week'
		 ,"liquidacion"."year" as 'liq_year'
		 ,"liquidacion"."month" as 'liq_month'
		 ,"liquidacion".fecha_liquidacion
		,case 
			when "anticipo"."week" = "liquidacion"."week"
				then 1
			when "liquidacion"."week" is null
				then 0
			else 
				null
		end as 'viajes_liquidados'
		,case 
			when "anticipo"."week" = "liquidacion"."week"
				then 0
			when "liquidacion"."week" is null
				then 1
			else 
				null
		end as 'viajes_pendientes'
	from 
			"antilope" as "anticipo"
	left join
				(
					select
						"liquidacion".id_area
						,(
							select
									ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
							from 
									tespecializadadb.dbo.general_area as "areas"
							where 
									areas.id_area = "liquidacion".id_area
						) as 'area'
						,"liquidacion".no_liquidacion
						,"viaje".no_viaje
						,"viaje".id_personal
						,"viaje".fecha_viaje
						,"viaje".fecha_fin_viaje
						,"viaje".fecha_real_viaje
						,"viaje".fecha_real_fin_viaje
						,"viaje".id_unidad
						,"liquidacion".fecha_liquidacion
						,datepart(week,"liquidacion".fecha_liquidacion) as 'week'
						,datepart(year,"liquidacion".fecha_liquidacion) as 'year'
						,datepart(month,"liquidacion".fecha_liquidacion) as 'month'
					from
							tespecializadadb.dbo.trafico_liquidacion as "liquidacion" 
						inner join 
									tespecializadadb.dbo.trafico_viaje  as "viaje" 
							on
									"liquidacion".id_area = "viaje".id_area_liq
							and 
									"liquidacion".no_liquidacion = "viaje".no_liquidacion
							and
									"liquidacion".status_liq = 'A'
					where					
							year("liquidacion".fecha_liquidacion) = year(CURRENT_TIMESTAMP)
				)
		as "liquidacion" on "liquidacion".id_area = "anticipo".id_area and "liquidacion".no_viaje = "anticipo".no_viaje 
			and
				"anticipo"."year" = "liquidacion"."year"
				
				
				
-- =============================================================================================================== --
-- 								last View
-- =============================================================================================================== --

use sistemas;

IF OBJECT_ID ('report_aceptados_vs_liquidados', 'V') IS NOT NULL
	DROP VIEW report_aceptados_vs_liquidados;

create view report_aceptados_vs_liquidados
as
	with "snake" as (
			select 
					company,no_viaje,id_area,fecha_guia,f_despachado 
			from 
					sistemas.dbo.projections_view_full_indicators_tbk_periods
			where 
					trip_count = 1
			union all
			select 
					company,no_viaje,id_area,fecha_guia,f_despachado 
			from 
					sistemas.dbo.projections_view_full_indicators_atm_periods
			where 
					trip_count = 1
			union all
			select 
					company,no_viaje,id_area,fecha_guia,f_despachado 
			from 
					sistemas.dbo.projections_view_full_indicators_tei_periods
			where 
					trip_count = 1		
	)
	select
--				 "liquid".id_company as "solid_id_company"
--				,"solid".company as "liquid_id_company"
--				,"liquid".no_viaje as "liquid_no_viaje"
--	   		    ,"solid".no_viaje as "solid_no_viaje"
--	   		    ,"liquid".id_area as "liquid_ud_area"
--				,"solid".id_area as "solid_id_area" 
--				,"liquid".fecha_real_viaje
--				,"liquid".fecha_real_fin_viaje
--				,"liquid".fecha_liquidacion
--				,"solid".fecha_guia
--				,"solid".f_despachado
--				,"liquid".ant_week
--				,"liquid".liq_week
--				,"liquid".viajes_liquidados
--				,"liquid".viajes_pendientes
				 "liquid".*
				,"solid".fecha_guia
				,"solid".f_despachado
	from 
				sistemas.dbo.report_finalizados_vs_liquidados as "liquid"
		inner join
				"snake" as "solid"
			on
				"liquid".id_company = "solid".company
			and
				"liquid".id_area = "solid".id_area
			and
				"liquid".no_viaje = "solid".no_viaje