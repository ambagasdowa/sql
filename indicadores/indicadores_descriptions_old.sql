--ORIZABA worksheet
select * from "bonampakdb"."dbo"."bon_view_get_acepted_kilotrips_orizaba"		-- DynamicViajesAcept, direct query

select * from "bonampakdb"."dbo"."bon_view_get_acepted_subtons_orizaba"			-- DynamicIngTonAcept, direct query

select * from "bonampakdb"."dbo"."bon_view_get_desp_acept_trips_ramos"			-- DinamycDespAceptTrips , ToDrop

select * from "sistemas"."dbo"."ingresos_costos_view_fractions"					-- Source

select * from "sistemas"."dbo"."ingresos_costos_gst_holidays"					-- holidays

select * from "sistemas"."dbo"."ingresos_costos_view_ind_ppto_ingresos"			-- ingresos

select * from "bonampakdb"."dbo"."Bon_v_IndOperativosOZ" 						-- FLETES Y TONELADAS , TonelajeBD

select * from "bonampakdb"."dbo"."Bon_v_ViajesOz"								-- VIAJES Y KILOMETROS , ViajesBD

--MAcuspana worksheet

select * from "macuspanadb"."dbo"."bon_view_get_acepted_kilotrips_macuspana"	-- ViajesAceptados

select * from "macuspanadb"."dbo"."bon_view_get_acepted_subtons_macuspana"		-- TonelajesAceptados

select * from "sistemas"."dbo"."ingresos_costos_view_fractions"					-- Source

select * from "sistemas"."dbo"."ingresos_costos_gst_holidays"					-- holidays

select * from "sistemas"."dbo"."ingresos_costos_view_ind_ppto_ingresos"			-- Ingresos

select * from "macuspanadb"."dbo"."v_IndicadoresOperativos"						-- FLETES Y TONELADAS , TonelajeBD

select * from "macuspanadb"."dbo"."v_viajesdesp"								-- VIAJES Y KILOMETROS , ViajesBD



--Acepted TEI

use sistemas
IF OBJECT_ID ('projections_view_full_indicators_tei_periods_test', 'V') IS NOT NULL		
    DROP VIEW projections_view_full_indicators_tei_periods_test;
create view projections_view_full_indicators_tei_periods_test

with encryption
as
	with guia_tei as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
--					
					,guia.num_guia
					,viaje.id_ruta
					,viaje.id_origen
					,ruta.desc_ruta
					,guia.monto_retencion
--					
					,cast(guia.fecha_guia as date) as 'fecha_guia'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,viaje.f_despachado
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
--					,"trg".peso
					,(
						select 
								sum(isnull("tren".peso,0)) 
						from 
								tespecializadadb.dbo.trafico_renglon_guia as "tren"
						where	
								"tren".no_guia = guia.no_guia and "tren".id_area = viaje.id_area
					 ) as 'peso'
					,(
						select 
								descripcion
						from
								tespecializadadb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								tespecializadadb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								tespecializadadb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								tespecializadadb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							tespecializadadb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'3' as 'company'
			from 
						tespecializadadb.dbo.trafico_viaje as "viaje"
				inner join 
						tespecializadadb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
					and 
						guia.prestamo <> 'P'
					and 
						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
--				inner join
--						tespecializadadb.dbo.trafico_renglon_guia as "trg"
--					on
--						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				inner join
						tespecializadadb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				inner join 
						tespecializadadb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(guia.fecha_guia) = "translation".month_num
				inner join 
						tespecializadadb.dbo.trafico_ruta as "ruta"
					on
						viaje.id_ruta = "ruta".id_ruta
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota
				,"guia".no_viaje ,"guia".num_guia , "guia".id_ruta ,"guia".id_origen ,"guia".desc_ruta, "guia".monto_retencion
				,"guia".fecha_guia
				,"guia".mes ,"guia".f_despachado ,"guia".cliente 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else '1'
				end as 'trip_count'
	from 
				guia_tei as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota 
				,"guia".no_viaje ,"guia".num_guia , "guia".id_ruta ,"guia".id_origen ,"guia".desc_ruta, "guia".monto_retencion
				,"guia".fecha_guia 
				,"guia".mes ,"guia".f_despachado ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company
		
	