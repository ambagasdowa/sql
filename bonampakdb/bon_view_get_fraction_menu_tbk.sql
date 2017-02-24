-- "bonampakdb"."dbo"."bon_view_get_fraction_menu_tbk"
use bonampakdb;
IF OBJECT_ID ('bon_view_get_fraction_menu_tbk', 'V') IS NOT NULL
    DROP VIEW bon_view_get_fraction_menu_tbk;
GO

create view bon_view_get_fraction_menu_tbk
with encryption
as
		select distinct desc_producto
		from bonampakdb.dbo.trafico_producto 
		where 
				bonampakdb.dbo.trafico_producto.id_producto = 0
			and 
				bonampakdb.dbo.trafico_producto.desc_producto in('GRANEL','OTROS')

