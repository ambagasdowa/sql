Use sistemas;

--Select DISTINCT sc.id, sc.alpha_num_code as Tarjeta_Iave, tci.no_tarjeta_iave as Tarjeta_iave_LIS, tci.id_unidad as Unidad_LIS, 
--mu.id_unidad, mu.no_tarjeta_llave, sc.unit as Unidad_iave, sc.alpha_location as Caseta_Iave, sc._filename as Archivo_decenal, 
--sc.fecha_a AS fecha_cruce
--FROM dbo.casetas sc
--LEFT JOIN tespecializadadb.dbo.trafico_catiaveunidoper tci 
--ON tci.no_tarjeta_iave = sc.alpha_num_code And tci.fecha_fin_mov is Null
--LEFT JOIN tespecializadadb.dbo.mtto_unidades mu ON mu.no_tarjeta_llave = sc.alpha_num_code



--select id_area,id_flota,* from tespecializadadb.dbo.mtto_unidades
--select id_area,id_flota,* from macuspanadb.dbo.mtto_unidades
--select id_area,id_flota,* from bonampakdb.dbo.mtto_unidades

--select count(id) from sistemas.dbo.casetas where _area = 'TEICUA'

-- 26008

--file g00I1549.370-1 = 3490



	select 
			casetas.id,
			casetas.alpha_num_code as 'tarjetaIaveProv',
			casetas.unit as 'unidadIaveProv',
			casetas.alpha_location as 'casetaIaveProv',
			(select cast(casetas.float_data_1 as int)) as 'iave_id',
			casetas._filename as 'fileIaveProv', 
			-- casetas.fecha_a AS 'fechaCruceIaveProv',
			(casetas.fecha_a + (select (cast( ' ' as datetime))) + casetas.time_a ) as 'datetimeCruceIaveProv',
			catia.no_tarjeta_iave as 'tarjetaIaveLis',
			catia.fecha_fin_mov as 'fechaFinMovLis', 
			--catia.ultimo_mov as 'ultimoMovLis',
			unit.id_unidad as 'idUnidadLis',
			unit.no_tarjeta_llave as 'noTarjetaIaveLis',
			(select (DATEDIFF(second,{d '1970-01-01'},(casetas.fecha_a + (select (cast( ' ' as datetime))) + casetas.time_a )))) as 'unixTime',
			viaje.no_viaje as 'noViajeLis'
	from 
			dbo.casetas as casetas
			left join 
						tespecializadadb.dbo.trafico_catiaveunidoper as catia 
					on 
						catia.no_tarjeta_iave = casetas.alpha_num_code and catia.fecha_fin_mov is null
			left join 
						tespecializadadb.dbo.mtto_unidades unit 
					on 
						unit.no_tarjeta_llave = casetas.alpha_num_code
			left join
						tespecializadadb.dbo.trafico_viaje viaje
					on
						casetas.unit = viaje.id_unidad and unit.id_area = viaje.id_area 
	where 
			casetas._area = 'TEICUA'
			and casetas._filename = 'g00I1549.370-1'
--			and catia.fecha_fin_mov is not null
	
	
	select * from tespecializadadb.dbo.trafico_ruta_caseta

	
--	select (DATEDIFF(second,{d '1970-01-01'},'2016-03-08 13:33:21.000'))
	


	select 
			no_viaje,* 
	from 
			tespecializadadb.dbo.trafico_viaje 
	where
					no_liquidacion is not null
				and
					no_viaje = '91678'
				and 
					--f_despachado between '2016-05-11' and '2016-05-20' 
					f_despachado between '2016-04-01' and '2016-04-10' 
				and 
					fecha_real_fin_viaje between '2016-04-01' and '2016-04-10'
			;

