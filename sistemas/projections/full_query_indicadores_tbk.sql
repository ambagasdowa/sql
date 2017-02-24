------------------------------------------------------------------------------------------------------------------------------------------
-- Operations ind Engine build for three databases
------------------------------------------------------------------------------------------------------------------------------------------

USE bonampakdb;

declare @year int , @month int;

set @year = YEAR(CURRENT_TIMESTAMP)
set @month = month(CURRENT_TIMESTAMP)

set language spanish

	select 
			 viaje.id_area
			,viaje.id_unidad
			,viaje.id_configuracionviaje
			,guia.id_tipo_operacion
			,guia.id_fraccion
			,manto.id_flota
			,viaje.no_viaje
			,guia.fecha_guia
			,(select datename(mm,guia.fecha_guia)) as 'mes'
			,viaje.f_despachado
			,cliente.nombre as 'cliente'
			,viaje.kms_viaje
			,viaje.kms_real
			,guia.subtotal
			,(
				select 
						sum(rg.peso)
				from 
						bonampakdb.dbo.trafico_renglon_guia as rg
				where 
						rg.no_guia in (
											select 
													tguia.no_guia 
											from 
													bonampakdb.dbo.trafico_guia as tguia 
											where 
													tguia.id_area = viaje.id_area 
												and tguia.no_viaje = viaje.no_viaje
												and tguia.status_guia <> 'B' 
												and tguia.prestamo <> 'P'
												and tguia.tipo_doc = 2 
												and tguia.id_fraccion = guia.id_fraccion
											)
					and rg.id_area = viaje.id_area

			 ) as 'peso'
			,(
				select 
						descripcion
				from
						bonampakdb.dbo.trafico_configuracionviaje as trviaje
				where
						trviaje.id_configuracionviaje = viaje.id_configuracionviaje
			) as 'configuracion_viaje'
			,(
				select 
						tipo_operacion
				from
						bonampakdb.dbo.desp_tipooperacion tpop
				where 
						tpop.id_tipo_operacion = guia.id_tipo_operacion
			 ) as 'tipo_de_operacion'
			,(
				select 
						nombre
				from 
						bonampakdb.dbo.desp_flotas as fleet
				where
						fleet.id_flota = manto.id_flota
						
			) as 'flota'
			,(
				select
						ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS S.A. DE C.V.','TULTITLAN')))
				from 
						bonampakdb.dbo.general_area as areas
				where 
						areas.id_area = viaje.id_area
			) as 'area'

			 ,(
				select
						desc_producto
				from
					bonampakdb.dbo.trafico_producto as producto
				where      
					(producto.id_producto = 0) 
						AND 
					(producto.id_fraccion = guia.id_fraccion)
			) as 'fraccion'
	from 
			bonampakdb.dbo.trafico_viaje as viaje
		------------------------------------------------------------------------------------------------------------------------------
		-- hir can join trafico_renglon_guia with a select or left join
		------------------------------------------------------------------------------------------------------------------------------
		inner join (
							select --top(1)
								trg.id_area,trg.id_fraccion,trg.no_viaje
								,trg.status_guia,trg.prestamo,trg.tipo_doc
								,trg.id_cliente,trg.id_tipo_operacion
								,(select( right('00'+convert(varchar(2),DAY(trg.fecha_guia)), 2) +'-'+ right('00'+convert(varchar(2),MONTH(trg.fecha_guia)), 2) + '-' + CONVERT(nvarchar(4), YEAR(trg.fecha_guia)))) as 'fecha_guia'
								,sum(trg.subtotal) as 'subtotal'
							from bonampakdb.dbo.trafico_guia as trg
							where	
									trg.status_guia <> 'B'
									and trg.prestamo <> 'P'
									and trg.tipo_doc = 2 
							group by trg.id_area,trg.id_fraccion,trg.no_viaje,trg.status_guia,trg.prestamo,trg.tipo_doc,trg.id_cliente
									,trg.id_tipo_operacion
									 ,year(trg.fecha_guia),month(trg.fecha_guia),day(trg.fecha_guia)
		) as guia on guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
		inner join
				bonampakdb.dbo.trafico_cliente as cliente
					on cliente.id_cliente = guia.id_cliente
		inner join 
				bonampakdb.dbo.mtto_unidades as manto
					on manto.id_unidad = viaje.id_unidad
	where 
			year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
		and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))

	order by viaje.no_viaje














--select convert(datetime , '11-03-2016',103)
--select datename(mm,(select convert(datetime , '11-03-2016',103)))