Use sistemas;
Go
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'Teisa_v_casetas_conciliacion2')
   DROP VIEW Teisa_v_casetas_conciliacion2
GO

CREATE VIEW dbo.Teisa_v_casetas_conciliacion2
With Encryption As

SELECT DISTINCT 
                      TOP (100) PERCENT sc.id, tci.id_unidad, sc.unit, tci.no_tarjeta_iave, sc.alpha_num_code, sc.alpha_location, sc.alpha_location_1, sc._filename, tv.no_viaje, sc.fecha_a AS fecha_cruce, 
                      tv.f_despachado, tv.fecha_fin_viaje, sc.float_data, sc.time_a AS hora_cruce, sc._area AS cia, SUM(sc.float_data) 
                      AS Monto_archivo,
                          (SELECT     MIN(sc.fecha_a) AS Expr1) AS fecha_inicio,
                          (SELECT     MAX(sc.fecha_a) AS Expr1) AS fecha_fin
FROM         tespecializadadb.dbo.trafico_catiaveunidoper AS tci INNER JOIN
dbo.casetas AS sc ON sc.alpha_num_code = tci.no_tarjeta_iave INNER JOIN
tespecializadadb.dbo.trafico_viaje AS tv ON tv.id_unidad = tci.id_unidad AND tv.id_area = tci.id_area 
WHERE     (tci.fecha_fin_mov IS NULL) AND (tv.f_despachado > '2016-01-01') AND
                          ((SELECT     CONVERT(datetime, sc.fecha_a) + ' ' + CONVERT(datetime, sc.time_a) AS Expr1) BETWEEN tv.f_despachado AND
                          (SELECT     TOP (1) f_despachado
                            FROM          tespecializadadb.dbo.trafico_viaje
                            WHERE      (id_unidad = tv.id_unidad) AND (fecha_real_fin_viaje > tv.fecha_real_fin_viaje)))
GROUP BY sc.id, tci.id_unidad, sc.unit, tci.no_tarjeta_iave, sc.alpha_num_code, sc.alpha_location, sc.alpha_location_1, sc._filename, tv.no_viaje, sc.fecha_a, tv.f_despachado, tv.fecha_fin_viaje, 
                       sc.float_data, sc.time_a, sc._area, sc.float_data
ORDER BY sc.id


--Powered by AdrianTurru

