USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[countAcceptedViajes]    Script Date: 12/04/2016 01:05:31 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================
 Author         : @Author Jesus Baizabal
 Create date    : May 2, 2015
 Description    : get Accepted counted Trips and kms
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/

ALTER FUNCTION [dbo].[countAcceptedViajes]
 (
	@fraction varchar(8000),
	@currentYear nvarchar(4),
	@mes varchar(8000),
	@id_area int
 )
returns table
with encryption 
as 
return
(
			select 
				distinct a.no_viaje as 'Viajes',
				c.kms_viaje as Kilometros,
				c.kms_real as Kilometers,
				(select dbo.getArea(a.id_area,'BONAMPAK')) as 'Area',
				--(select setMonthName( cast(varchar(2),MONTH(a.fecha_guia)) ) ) as 'Mes'
				(select dbo.setMonthName( (select right('00'+convert(varchar(2),MONTH(a.fecha_guia)), 2)) )) as Mes,
				day(a.fecha_guia) as 'Dia',
				tc.nombre as 'NombreCliente',
				(select dbo.getFlota(d.id_flota)) as 'Flota',
				(select dbo.getFraccionName(a.id_fraccion)) as Fraccion,
				YEAR(a.fecha_guia) as 'year'
			FROM trafico_guia as a 
				INNER JOIN trafico_renglon_guia as b ON a.id_area = b.id_area and a.no_guia= b.no_guia 
				INNER JOIN trafico_viaje as c ON a.id_area = c.id_area and a.no_viaje = c.no_viaje 
				INNER JOIN mtto_unidades as d ON a.id_unidad = d.id_unidad 
				INNER JOIN trafico_ruta as e ON c.id_ruta=e.id_ruta 
				inner join trafico_cliente as tc on a.id_cliente = tc.id_cliente
			where	YEAR(a.fecha_guia) = @currentYear
					and MONTH(a.fecha_guia) in (SELECT item from dbo.fnSplit(@mes, '|'))
					--and day(a.f_despachado) = datepart(DAY ,CURRENT_TIMESTAMP)
					and a.status_guia <> 'B' 
					and a.prestamo <> 'P'
					and a.tipo_doc = 2 
					and a.id_area=@id_area
					--and c.kms_viaje > 0
					and a.id_fraccion in (SELECT convert(int,item) from dbo.fnSplit(@fraction, '|'))
)


