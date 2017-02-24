
; with viajes_liq as 
(
		select
				 liq.id_area
				,unit.name
				,liq.no_liquidacion
				,liq.cant_viajes
				,year(liq.fecha_liquidacion) as 'year'
				,month(liq.fecha_liquidacion) as 'mes'
		from 
				bonampakdb.dbo.trafico_liquidacion as liq
			inner join
				sistemas.dbo.projections_view_bussiness_units as unit on unit.id_area = liq.id_area and unit.projections_corporations_id = 1
		where	
				liq.status_liq = 'A' 
			and
			   ( liq.fecha_liquidacion between '2016-01-07 00:00:00.000' and '2016-01-28 23:59:00.000' )
			or
			   ( liq.fecha_liquidacion between '2016-06-03 00:00:00.000' and '2016-06-30 23:59:00.000' )
			or
			   ( liq.fecha_liquidacion between '2016-12-02 00:00:00.000' and '2016-12-29 23:59:00.000' )
)
	select 
			 trliq.id_area
			,trliq.name
			--,trliq.no_liquidacion
			,sum(trliq.cant_viajes) as 'viajes'
			,trliq.year
			,trliq.mes
			,red.id_fraccion
	from 
			viajes_liq trliq
		inner join
			(
				select 
						 rail.id_area,rail.id_fraccion
						,trip.no_liquidacion
						,rail.no_viaje
				from 
						bonampakdb.dbo.trafico_guia as rail
					inner join
						bonampakdb.dbo.trafico_viaje as trip on trip.no_viaje = rail.no_viaje and trip.id_area = rail.id_area
				group by
						 rail.id_area,rail.id_fraccion
						,trip.no_liquidacion
						,rail.no_viaje
									
			) as red on red.id_area = trliq.id_area and red.no_liquidacion = trliq.no_liquidacion 
	--where 
	--		trliq.no_liquidacion = '8689'
	group by
			 trliq.id_area
			,trliq.name
			--,trliq.no_liquidacion
			--,trliq.cant_viajes
			,trliq.year
			,trliq.mes
			,red.id_fraccion
	order by
			 trliq.id_area
			,trliq.mes
			,red.id_fraccion


-- ==== MACUSPANA ======


; with viajes_liq as 
(
		select
				 liq.id_area
				,unit.name
				,liq.no_liquidacion
				,liq.cant_viajes
				,year(liq.fecha_liquidacion) as 'year'
				,month(liq.fecha_liquidacion) as 'mes'
		from 
				macuspanadb.dbo.trafico_liquidacion as liq
			inner join
				sistemas.dbo.projections_view_bussiness_units as unit on unit.id_area = liq.id_area and unit.projections_corporations_id = 2
		where	
				liq.status_liq = 'A' 
			and
			   ( liq.fecha_liquidacion between '2016-01-07 00:00:00.000' and '2016-01-28 23:59:00.000' )
			or
			   ( liq.fecha_liquidacion between '2016-06-03 00:00:00.000' and '2016-06-30 23:59:00.000' )
			or
			   ( liq.fecha_liquidacion between '2016-12-02 00:00:00.000' and '2016-12-29 23:59:00.000' )
)
	select 
			 trliq.id_area
			,trliq.name
			--,trliq.no_liquidacion
			,sum(trliq.cant_viajes) as 'viajes'
			,trliq.year
			,trliq.mes
			,red.id_fraccion
	from 
			viajes_liq trliq
		inner join
			(
				select 
						 rail.id_area,rail.id_fraccion
						,trip.no_liquidacion
						,rail.no_viaje
				from 
						macuspanadb.dbo.trafico_guia as rail
					inner join
						macuspanadb.dbo.trafico_viaje as trip on trip.no_viaje = rail.no_viaje and trip.id_area = rail.id_area
				group by
						 rail.id_area,rail.id_fraccion
						,trip.no_liquidacion
						,rail.no_viaje
									
			) as red on red.id_area = trliq.id_area and red.no_liquidacion = trliq.no_liquidacion 
	--where 
	--		trliq.no_liquidacion = '8689'
	group by
			 trliq.id_area
			,trliq.name
			--,trliq.no_liquidacion
			--,trliq.cant_viajes
			,trliq.year
			,trliq.mes
			,red.id_fraccion
	order by
			 trliq.id_area
			,trliq.mes
			,red.id_fraccion