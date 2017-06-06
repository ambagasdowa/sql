/*
-- viajes finalizados vs viajes pendientes de liquidar 
SELECT @@DATEFIRST AS 'First Day'  
    ,DATEPART(dw, SYSDATETIME()) AS 'Today'; 
    
-- Equivalent to DATEPART(DW) with DATEFIRST 1
SELECT DATEDIFF(DAY,'20000103',CURRENT_TIMESTAMP)%7+1

-- Equivalent to DATEPART(DW) with DATEFIRST 7
SELECT DATEDIFF(DAY,'20000102',CURRENT_TIMESTAMP)%7+1

-- equivalen to datefirst 1 
SELECT (DATEPART(weekday, GETDATE()) + @@DATEFIRST - 2) % 7 + 1    
*/  

use sistemas

create view report_finalizados_vs_liquidados
as
with "antilope" as 
set 
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
				,personal_personal_a.nombre as 'personal_personal_a.nombre'
				,trafico_viaje.id_unidad
				,trafico_viaje.status_viaje
				,trafico_viaje.fecha_real_viaje
				,trafico_viaje.fecha_real_fin_viaje
				,trafico_ruta.desc_ruta
				,trafico_viaje.id_remolque1
				,trafico_viaje.id_dolly
				,trafico_viaje.id_remolque2
				,trafico_viaje.id_operador2
				,personal_personal_b.nombre as 'personal_personal_b.nombre'
				,personal_personal_a.id_personal as 'personal_personal_a.id_personal'
				,personal_personal_b.id_personal as 'personal_personal_b.id_personal'
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
		 ,"anticipo"."personal_personal_a.nombre" 
		 ,"anticipo".id_unidad 
		 ,"anticipo".status_viaje
		 ,"anticipo".fecha_real_viaje
		 ,"anticipo".desc_ruta 
		 ,"anticipo".id_remolque1 
		 ,"anticipo".id_dolly
		 ,"anticipo".id_remolque2 
		 ,"anticipo".id_operador2 
		 ,"anticipo"."personal_personal_b.nombre" 
		 ,"anticipo"."personal_personal_a.id_personal" 
		 ,"anticipo"."personal_personal_b.id_personal" 
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
		
				
select * from sistemas.dbo.report_finalizados_vs_liquidados