SELECT 
			DISTINCT 
					sc.id, 
					tci.id_unidad, 
					sc.unit, 
					tci.no_tarjeta_iave, 
					sc.alpha_num_code, 
					sc.alpha_location, 
					sc.alpha_location_1, 
					sc._filename, 
					tv.no_viaje, 
					sc.fecha_a AS 'fecha_cruce', 
					(
						Select CONVERT (date, tv.f_despachado)
					) As 'f_despachado',
					tv.fecha_fin_viaje, 
					sc.float_data, 
					sc.time_a AS 'hora_cruce', 
					sc._area AS 'cia', 
					SUM(sc.float_data) AS 'Monto_archivo',
					(
						SELECT TOP (1)
							CONVERT (date, f_despachado)
						FROM 
							tespecializadadb.dbo.trafico_viaje
						WHERE
							(id_unidad = tv.id_unidad) 
							AND 
							(fecha_fin_viaje > tv.fecha_fin_viaje)
					) As 'next',

					(
						--SELECT     
						--	MIN(sc.fecha_a) AS Expr1
						tv.id_ruta
					) AS 'fecha_inicio',

					(
						--SELECT
						--	MAX(sc.fecha_a) AS Expr1
						tv.no_liquidacion
					) AS 'fecha_fin',
					(
						(
							SELECT dbo.getCasetaName(SUBSTRING(sc.alpha_location, 1, 5), N'tei') AS Expr1
						)
					) AS 'description_casetas',

					sc.casetas_controls_files_id
														
		FROM       
				tespecializadadb.dbo.trafico_catiaveunidoper AS tci 
						INNER JOIN dbo.casetas AS sc ON sc.alpha_num_code = tci.no_tarjeta_iave
						INNER JOIN tespecializadadb.dbo.trafico_viaje AS tv ON tv.id_unidad = tci.id_unidad AND tv.id_area = tci.id_area 
						INNER JOIN tespecializadadb.dbo.trafico_ruta_caseta trc ON trc.id_ruta = tv.id_ruta
						INNER JOIN tespecializadadb.dbo.trafico_caseta tc ON tc.id_caseta = trc.id_caseta
		WHERE     
				(tci.fecha_fin_mov IS NULL) 
				AND
					(year(tv.f_despachado) > '2015') 
				and
					tv.no_liquidacion is not null
				AND
						(
							(
								SELECT
											CONVERT
											(
												datetime, sc.fecha_a) + ' ' + CONVERT(datetime, sc.time_a
											) AS Expr1
							) BETWEEN tv.f_despachado 
				AND
						tv.fecha_real_fin_viaje
						--(
						--	SELECT TOP (1) f_despachado
						--	FROM          tespecializadadb.dbo.trafico_viaje
						--	WHERE      (id_unidad = tv.id_unidad) AND (fecha_real_fin_viaje > tv.fecha_real_fin_viaje)
						--)
					)
				--and 
				--	tv.no_liquidacion = '13406'
				and 
					tv.no_viaje = '91678'
				and
					sc.casetas_controls_files_id = '4'
		GROUP BY sc.id, tci.id_unidad, sc.unit, tci.no_tarjeta_iave, sc.alpha_num_code,
					sc.alpha_location, sc.alpha_location_1, sc._filename, tv.no_viaje, sc.fecha_a, 
					tv.f_despachado, tv.fecha_fin_viaje,sc.float_data, sc.time_a, sc._area, sc.float_data, tv.id_unidad,
					tv.id_ruta, tc.desc_caseta, tc.id_caseta,trc.id_ruta, trc.orden, tc.desc_caseta, trc.id_caseta, sc.casetas_controls_files_id,
					tv.no_liquidacion








select * from tespecializadadb.dbo.trafico_viaje where no_viaje = '91678' -- viaje despachado


select * from tespecializadadb.dbo.trafico_liquidacion_casetas where no_liquidacion = '13406' and no_viaje = '91678' -- liquidation detail
	order by consecutivo;

select * from tespecializadadb.dbo.trafico_casetaviaje where no_viaje = '91678' -- bridge
	order by id_caseta;

--
select * from tespecializadadb.dbo.trafico_ruta_caseta where id_ruta = (select id_ruta from tespecializadadb.dbo.trafico_viaje where no_viaje = '91678')

select * from tespecializadadb.dbo.trafico_caseta where id_caseta in (select id_caseta from tespecializadadb.dbo.trafico_ruta_caseta where id_ruta = (select id_ruta from tespecializadadb.dbo.trafico_viaje where no_viaje = '91678'))

select id_caseta,* from tespecializadadb.dbo.trafico_renglon_caseta where id_caseta in (select id_caseta from tespecializadadb.dbo.trafico_caseta where id_caseta in (select id_caseta from tespecializadadb.dbo.trafico_ruta_caseta where id_ruta = (select id_ruta from tespecializadadb.dbo.trafico_viaje where no_viaje = '91678'))) and no_de_ejes = 5

select id_asignacion,* from tespecializadadb.dbo.desp_asignacion where no_viaje = '91678'

select * from tespecializadadb.dbo.trafico_caseta  where desc_caseta like 'ESTACION%' 
--

--select * from tespecializadadb.dbo.trafico_casetaviaje 

--select * from tespecializadadb.dbo.trafico_archivocasetas



-- define the period
 --del 11 de mayo al 20 de mayo 374
 --yyyy mm dd
 --2016-03-08

 -- 699 all trips

 -- 683 just liquidations

 -- 615

	select 
			no_viaje,* 
	from 
			tespecializadadb.dbo.trafico_viaje 
	where
					no_liquidacion is not null
				and 
					--f_despachado between '2016-05-11' and '2016-05-20' 
					f_despachado between '2016-05-11' and '2016-05-20' 
				and 
					fecha_real_fin_viaje between '2016-05-11' and '2016-05-20'
			;