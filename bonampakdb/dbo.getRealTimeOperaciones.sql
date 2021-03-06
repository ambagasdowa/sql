USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getRealTimeOperaciones]    Script Date: 12/04/2016 01:07:35 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[getRealTimeOperaciones]
 (
	@id_fraccionA nvarchar(2),
	@id_fraccionB nvarchar(2),
	@id_fraccionC nvarchar(2)
 )
returns table
with encryption
as 
return
(
			select 
				distinct a.no_viaje as 'Viajes',
				(select dbo.getPeso(a.id_area,a.no_viaje)) as 'Toneladas',
				(select dbo.getOperador(e.id_operador)) as 'Operadores'
			from bonampakdb.dbo.trafico_viaje as a 
				inner join bonampakdb.dbo.trafico_renglon_viaje as b on a.no_viaje = b.no_viaje and a.id_area=b.id_area 
				inner join bonampakdb.dbo.trafico_renglon_guia as c on b.no_guia = c.no_guia and a.id_area = c.id_area 
				inner join bonampakdb.dbo.trafico_guia as d on a.id_area=d.id_area and a.no_viaje=d.no_viaje 
				inner join bonampakdb.dbo.mtto_unidades as e on a.id_area=e.id_area and a.id_unidad = e.id_unidad and a.id_area=e.id_area 
			where	YEAR(a.f_despachado) = datepart(YEAR ,CURRENT_TIMESTAMP)
					and MONTH(a.f_despachado) = datepart(MONTH ,CURRENT_TIMESTAMP) 
					and day(a.f_despachado)= datepart(DAY ,CURRENT_TIMESTAMP)
					and d.status_guia <> 'B' 
					--and d.prestamo='N' 
					and a.id_area='1'
					and d.id_fraccion in (@id_fraccionA,@id_fraccionB,@id_fraccionC)
)

