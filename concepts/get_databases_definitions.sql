
use bonampakdb;
  
select TABLE_NAME ,TABLE_TYPE,TABLE_CATALOG from INFORMATION_SCHEMA.TABLES where table_name like '%use%' order by TABLE_TYPE;


select top(100) * from bonampakdb.dbo.trafico_ruta

select top(100) * from bonampakdb.dbo.trafico_ruta_georeferencia

select top(100) * from bonampakdb.dbo.trafico_ruta_caseta

-- ====================================================================================================================================

select * from bonampakdb.dbo.seguridad_usuarios

select top(100) * from tespecializadadb.dbo.trafico_ruta_georeferencia

select top(100) * from macuspanadb.dbo.trafico_ruta_georeferencia