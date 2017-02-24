
select 
		 viaje.no_viaje,viaje.id_area,viaje.id_unidad
		,viaje.f_despachado,viaje.fecha_real_viaje,viaje.fecha_real_fin_viaje
		,guia.num_guia,guia.subtotal
		,guia.id_fraccion
		,guia.fecha_guia,guia.tipo_doc,guia.status_guia,guia.prestamo
		,case
			when guia.tipo_doc = 2  and guia.status_guia <> 'B' and guia.prestamo <> 'P'
				then
					'Aceptado'
			when guia.tipo_doc = 2  and guia.status_guia <> 'B' and guia.prestamo = 'P'
				then
					'Edicion'
			when guia.tipo_doc = 2  and guia.status_guia = 'B' and guia.prestamo <> 'P'
				then
					'Cancelado'
			else 'document'
		end as 'Status'
		--,* 
from bonampakdb.dbo.trafico_viaje as viaje 
		left join bonampakdb.dbo.trafico_guia as guia on  guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
--where year(viaje.f_despachado) = '2016' and month(viaje.f_despachado ) = '11' and viaje.id_area = 3 
where 
		year(viaje.fecha_real_viaje) = '2016' and month(viaje.fecha_real_viaje ) between '09' and '11' and viaje.id_area = 3 
		--and 
		--	guia.id_fraccion <> 1
order by 
		guia.fecha_guia,guia.tipo_doc,guia.status_guia,guia.prestamo




