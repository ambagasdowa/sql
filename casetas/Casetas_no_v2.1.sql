Use sistemas;
Go
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'Teisa_v_casetas_no_conciliacion2')
   DROP VIEW Teisa_v_casetas_no_conciliacion2
GO

CREATE VIEW dbo.Teisa_v_casetas_no_conciliacion2
With Encryption As

SELECT     id, _filename, key_num, key_num_1, key_num_2, alpha_code, key_num_3, alpha_num_code, unit, fecha_a, time_a, key_num_4, key_num_5, alpha_location_1, 
                      alpha_location, float_data, float_data_1, float_data_2, float_data_3, float_data_4, float_data_5, float_data_6, _user_company, _username, _datetime_login, 
                      _ip_remote, _area
FROM         dbo.casetas
WHERE     (id NOT IN (
SELECT DISTINCT sc.id
FROM         tespecializadadb.dbo.trafico_catiaveunidoper AS tci INNER JOIN
dbo.casetas AS sc ON sc.alpha_num_code = tci.no_tarjeta_iave INNER JOIN
tespecializadadb.dbo.trafico_viaje AS tv ON tv.id_unidad = tci.id_unidad AND tv.id_area = tci.id_area 
INNER JOIN tespecializadadb.dbo.trafico_ruta_caseta trc ON trc.id_ruta = tv.id_ruta
WHERE     (tci.fecha_fin_mov IS NULL) AND (tv.f_despachado > '2016-01-01') AND
                          ((SELECT     CAST (sc.fecha_a As Datetime) + CAST (sc.time_a as Time) AS Expr1) BETWEEN (Select CONVERT (date, tv.f_despachado)) AND
                          (SELECT     TOP (1)CONVERT (date, f_despachado)
                            FROM          tespecializadadb.dbo.trafico_viaje
                            WHERE      (id_unidad = tv.id_unidad) AND (fecha_fin_viaje > tv.fecha_fin_viaje))) 
GROUP BY sc.id
))
AND (_area = 'TEICUA')

--Powered by AdrianTurru & Gaysus Baizabal

