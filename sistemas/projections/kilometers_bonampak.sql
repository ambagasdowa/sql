use bonampakdb;

declare @year as nvarchar(4)
set @year = YEAR(CURRENT_TIMESTAMP)
-- 28624, 28636 : 5537107754 alejandro jimenez MG3 : 5558851524
-- serial g.cortina pc0c07s2 thinkpad

select distinct
				a.no_viaje as 'no_viaje',
				--a.num_guia as "CartaPorte", 
				(c.kms_viaje*2) as Kilometros, -- Granel stuff
				c.kms_real as Kilometers, -- Terceros stuff
				(
					select
							ltrim(rtrim(replace(areas_tbk.nombre ,'BONAMPAK' , '')))
					from 
							bonampakdb.dbo.general_area as areas_tbk
					where 
							areas_tbk.id_area = a.id_area
				) as 'Area',
				--(
				--	select
				--			ltrim(rtrim(replace(replace(areas_atm.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.','')))
				--	from 
				--			macuspanadb.dbo.general_area as areas_atm
				--	where 
				--			areas_atm.id_area = '1'
				--) as 'Area',
				(select dbo.setMonthName( (select right('00'+convert(varchar(2),MONTH(a.fecha_guia)), 2)) )) as Mes,
				(
					select 
					top(1)
							tra_guia.fecha_guia as 'fecha_guia'

						FROM trafico_guia as tra_guia
							--INNER JOIN trafico_renglon_guia as tra_renguia ON tra_guia.id_area = tra_renguia.id_area and tra_guia.no_guia= tra_renguia.no_guia 
							INNER JOIN trafico_viaje as tra_renvi ON tra_guia.id_area = tra_renvi.id_area and tra_guia.no_viaje = tra_renvi.no_viaje 
							--INNER JOIN mtto_unidades as mtto_unit ON tra_guia.id_unidad = mtto_unit.id_unidad 
							--INNER JOIN trafico_ruta as tra_rute ON tra_renvi.id_ruta=tra_rute.id_ruta 
							--inner join trafico_cliente as tra_client on tra_guia.id_cliente = tra_client.id_cliente
						where	YEAR(tra_guia.fecha_guia) = YEAR(a.fecha_guia)
								and tra_guia.status_guia <> 'B' 
								and tra_guia.prestamo <> 'P'
								and tra_guia.tipo_doc = 2 
								and tra_guia.id_area = a.id_area
								and tra_guia.id_fraccion = a.id_fraccion
								and tra_renvi.no_viaje = c.no_viaje
				) as 'fecha_guia',

				tc.nombre as 'NombreCliente',

				--(select dbo.getFlota(d.id_flota)) as 'Flotas',

				(
					select
							desp_flotas.nombre 
					from
							desp_flotas
					where
							desp_flotas.id_flota = d.id_flota
				) as 'Flota',

				(
					SELECT desc_producto
						--CASE tra_product.desc_producto 
						--	WHEN 'PRODUCTOS VARIOS' THEN 'OTROS' 
						--	when 'GRADO ALIMENTICIO' THEN 'OTROS'
						--	ELSE desc_producto
						--END AS 'desc_producto'
					FROM
						dbo.trafico_producto as tra_product
					WHERE      
						(tra_product.id_producto = 0) 
							AND 
						(tra_product.id_fraccion = a.id_fraccion)
				) AS 'Fraccion',
				a.id_area,
				a.id_fraccion,
				d.id_flota,
				c.id_unidad,
				(
					select 
					top(1)
							trajico_guia.id_tipo_operacion as 'tipop'
						FROM trafico_guia as trajico_guia
							--INNER JOIN trafico_renglon_guia as tra_renguia ON tra_guia.id_area = tra_renguia.id_area and tra_guia.no_guia= tra_renguia.no_guia 
							INNER JOIN trafico_viaje as trajico_renvi ON trajico_guia.id_area = trajico_renvi.id_area and trajico_guia.no_viaje = trajico_renvi.no_viaje 
							--INNER JOIN mtto_unidades as mtto_unit ON trajico_guia.id_unidad = mtto_unit.id_unidad 
							--INNER JOIN trafico_ruta as tra_rute ON trajico_renvi.id_ruta=tra_rute.id_ruta 
							--inner join trafico_cliente as tra_client on trajico_guia.id_cliente = tra_client.id_cliente
						where	YEAR(trajico_guia.fecha_guia) = YEAR(a.fecha_guia)
								and trajico_guia.status_guia <> 'B' 
								and trajico_guia.prestamo <> 'P'
								and trajico_guia.tipo_doc = 2 
								and trajico_guia.id_area = a.id_area
								and trajico_guia.id_fraccion = a.id_fraccion
								and trajico_renvi.no_viaje = c.no_viaje
				) as 'id_tipo_operacion',
				YEAR(a.fecha_guia) as 'year',
				YEAR(c.f_despachado) as "YearDespachado",
				Month(c.f_despachado) as "MonthDespachado",
				day(c.f_despachado) as "DayDespachado"
				--,count(c.no_viaje) over() as 'CountAll'
			FROM trafico_guia as a 
				INNER JOIN trafico_renglon_guia as b ON a.id_area = b.id_area and a.no_guia= b.no_guia 
				INNER JOIN trafico_viaje as c ON a.id_area = c.id_area and a.no_viaje = c.no_viaje 
				INNER JOIN mtto_unidades as d ON a.id_unidad = d.id_unidad 
				INNER JOIN trafico_ruta as e ON c.id_ruta=e.id_ruta 
				inner join trafico_cliente as tc on a.id_cliente = tc.id_cliente
			where	YEAR(a.fecha_guia) = @year
					--and MONTH(a.fecha_guia) in (SELECT item from dbo.fnSplit(@mes, '|'))
					--and day(a.f_despachado) = datepart(DAY ,CURRENT_TIMESTAMP)
					and a.status_guia <> 'B' 
					and a.prestamo <> 'P'
					and a.tipo_doc = 2 
					--and a.id_area = '3'
					--and month(a.fecha_guia) = '03'
					--and day(a.fecha_guia) in ('28','29')
					and c.kms_viaje > 0
					--and a.id_fraccion in ('4','5')
					--and c.no_viaje = '43628'
go



select top(10) 
				g.no_viaje,v.no_viaje
				,g.id_area,v.id_area
				,* 
from 
				trafico_guia as g 
	inner join trafico_viaje as v on g.id_area = v.id_area and g.no_viaje = v.no_viaje

select
		 top(15)
				 guia.no_viaje,guia.id_area,guia.id_fraccion,vo.tipo_operacion,vo.id_area,vo.id_fraccion,vo.no_viaje
		from trafico_guia as guia 
			left join (
						select 
						--top(1)
								trajico_guia.id_area,trajico_guia.id_fraccion,trajico_guia.no_viaje,
								trajico_guia.id_tipo_operacion as 'tipo_operacion'
							FROM trafico_guia as trajico_guia
								INNER JOIN trafico_viaje as trajico_renvi ON trajico_guia.id_area = trajico_renvi.id_area and trajico_guia.no_viaje = trajico_renvi.no_viaje 
							where	
									--YEAR(trajico_guia.fecha_guia) = YEAR(a.fecha_guia)
									--and 
									trajico_guia.status_guia <> 'B' 
									and trajico_guia.prestamo <> 'P'
									and trajico_guia.tipo_doc = 2 
									--and trajico_guia.id_area = a.id_area
									--and trajico_guia.id_fraccion = a.id_fraccion
									--and trajico_renvi.no_viaje = c.no_viaje
					  ) as vo on vo.id_area = guia.id_area
			INNER JOIN trafico_viaje as viaje ON guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje 
		where guia.id_area = '2' 



--(select area.id_area,area.nombre from general_area as area where area.id_area = 1) 
--select id_area,nombre from general_area

			--FROM trafico_guia as a 
				--INNER JOIN trafico_renglon_guia as b ON a.id_area = b.id_area and a.no_guia= b.no_guia 
				--INNER JOIN trafico_viaje as c ON a.id_area = c.id_area and a.no_viaje = c.no_viaje 
				--INNER JOIN mtto_unidades as d ON a.id_unidad = d.id_unidad 
				--INNER JOIN trafico_ruta as e ON c.id_ruta=e.id_ruta 
				--inner join trafico_cliente as tc on a.id_cliente = tc.id_cliente






