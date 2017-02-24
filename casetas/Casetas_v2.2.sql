--Use sistemas;
--Go
--IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
--         WHERE TABLE_NAME = 'Teisa_v_casetas_conciliacion2')
--   DROP VIEW Teisa_v_casetas_conciliacion2
--GO

--CREATE VIEW dbo.Teisa_v_casetas_conciliacion2
--With Encryption As
--3324
--21359
SELECT 
	DISTINCT TOP (100) PERCENT 
			sc.id, 
			tci.id_unidad, 
			sc.unit, 
			tci.no_tarjeta_iave, 
			sc.alpha_num_code, 
			sc.alpha_location, 
			sc.alpha_location_1, 
			sc._filename, 
			tv.no_viaje, 
			sc.fecha_a AS fecha_cruce, 
			(
				Select CONVERT (date, tv.f_despachado)
			) As f_despachado,
			tv.fecha_fin_viaje, 
			sc.float_data, 
			sc.time_a AS hora_cruce, 
			sc._area AS cia, 
			SUM(sc.float_data) AS Monto_archivo,
			(
				SELECT TOP (1)
					CONVERT (date, f_despachado)
				FROM 
					tespecializadadb.dbo.trafico_viaje
				WHERE
				   (id_unidad = tv.id_unidad) AND (fecha_fin_viaje > tv.fecha_fin_viaje)
			) As next,

			(
				SELECT     
					MIN(sc.fecha_a) AS Expr1
			) AS fecha_inicio,

			(
				SELECT
				    MAX(sc.fecha_a) AS Expr1
			) AS fecha_fin,
			(
				(
					SELECT dbo.getCasetaName(SUBSTRING(sc.alpha_location, 1, 5), N'tei') AS Expr1
				)
			) AS DescCaseta,
			sc.casetas_controls_files_id
FROM       
		tespecializadadb.dbo.trafico_catiaveunidoper AS tci 
				INNER JOIN dbo.casetas AS sc ON sc.alpha_num_code = tci.no_tarjeta_iave
				INNER JOIN tespecializadadb.dbo.trafico_viaje AS tv ON tv.id_unidad = tci.id_unidad AND tv.id_area = tci.id_area 
				INNER JOIN tespecializadadb.dbo.trafico_ruta_caseta trc ON trc.id_ruta = tv.id_ruta
				INNER JOIN tespecializadadb.dbo.trafico_caseta tc ON tc.id_caseta = trc.id_caseta
WHERE     
		(tci.fecha_fin_mov IS NULL) 
		AND (tv.f_despachado > '2016-01-01') 
		AND (
				(
					SELECT
								CONVERT
								(
									datetime, sc.fecha_a) + ' ' + CONVERT(datetime, sc.time_a
								) AS Expr1
				) BETWEEN tv.f_despachado 
		AND
				(
					SELECT TOP (1) f_despachado
					FROM          tespecializadadb.dbo.trafico_viaje
					WHERE      (id_unidad = tv.id_unidad) AND (fecha_real_fin_viaje > tv.fecha_real_fin_viaje)
				)
			)
		and
			sc.casetas_controls_files_id = '1'
		and tv.id_unidad = 'TT1317'
GROUP BY sc.id, tci.id_unidad, sc.unit, tci.no_tarjeta_iave, sc.alpha_num_code,
		 sc.alpha_location, sc.alpha_location_1, sc._filename, tv.no_viaje, sc.fecha_a, 
		 tv.f_despachado, tv.fecha_fin_viaje,sc.float_data, sc.time_a, sc._area, sc.float_data, tv.id_unidad,
		 tv.id_ruta, tc.desc_caseta, tc.id_caseta,trc.id_ruta, trc.orden, tc.desc_caseta, trc.id_caseta, sc.casetas_controls_files_id
--ORDER BY sc.id, trca.orden asc







Use sistemas; --3490
-- trafico_ruta, trafico_casetas
	Select 
			sc.id, 
			sc.alpha_num_code as Tarjeta_Iave, 
			tci.no_tarjeta_iave as Tarjeta_iave_LIS,
			tci.id_unidad as Unidad_LIS, 
			mu.id_unidad, 
			mu.no_tarjeta_llave,
			sc.unit as Unidad_iave,
			sc.alpha_location as Caseta_Iave,
			sc._filename as Archivo_decenal, 
			sc.fecha_a AS fecha_cruce,
			sc.time_a as 'time',
			tviaje.f_despachado,
			tviaje.fecha_fin_viaje
	from 
			dbo.casetas sc
				LEFT JOIN tespecializadadb.dbo.trafico_catiaveunidoper tci 
					ON tci.no_tarjeta_iave = sc.alpha_num_code And tci.fecha_fin_mov is Null
				LEFT JOIN tespecializadadb.dbo.mtto_unidades mu 
					ON mu.no_tarjeta_llave = sc.alpha_num_code
				left join tespecializadadb.dbo.trafico_viaje AS tviaje
					ON tviaje.id_unidad = tci.id_unidad AND tviaje.id_area = tci.id_area and (CONVERT(datetime, sc.fecha_a) + ' ' + CONVERT(datetime, sc.time_a)) between tviaje.f_despachado and tviaje.fecha_fin_viaje 
	where 
			sc.unit = 'TT1318'


			

