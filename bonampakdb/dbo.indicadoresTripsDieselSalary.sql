USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[indicadoresTripsDieselSalary]    Script Date: 12/04/2016 01:08:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================
 Author         : @Author Jesus Baizabal
 Create date    : May 2, 2015
 Description    : get Indicadores Trips Toneladas kms and Salary
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/

ALTER FUNCTION [dbo].[indicadoresTripsDieselSalary]
 (
	@fraction varchar(8000),
	@currentYear nvarchar(4),
	@mes varchar(8000),
	@id_area varchar(8000),
	@id_categoria int
 )
returns table 
with encryption
as 
return
(
			
			select 
				distinct a.no_viaje as 'Viajes',
				(select dbo.getFraccionName(a.id_fraccion)) as 'Fraccion',
				c.kms_viaje as Kilometros,
				c.kms_real as Kilometers,
				(select dbo.getArea(a.id_area,'BONAMPAK')) as 'Area',
				c.rend_esperado as 'RendimientoEsperado',
				c.id_personal as 'NoOperador',
				d.id_unidad as 'Unidad',
				(select dbo.getFlota(d.id_flota)) as 'Flota',
				(select dbo.getTipoOpFlota(a.id_tipo_operacion)) as 'tipoOperacionName',
				a.status_guia as 'Status',
				year(a.fecha_guia) as 'Año',
				( (select right('0000'+convert(char(4),year(a.fecha_guia)), 4)) + (select right('00'+convert(varchar(2),MONTH(a.fecha_guia)), 2)) ) as 'Periodo',
				(select dbo.getFactorTonelada(a.id_area,@id_categoria)) as 'factorTonelada',
				(select dbo.getFactorKilometro(a.id_area,@id_categoria)) as 'factorKilometros',
				(select dbo.getToneladasPassed(a.id_area,a.no_viaje,a.fecha_guia)) as 'Toneladas',
				(select dbo.setMonthName( (select right('00'+convert(varchar(2),MONTH(a.fecha_guia)), 2)) )) as Mes
			FROM dbo.trafico_guia as a 
				--INNER JOIN trafico_renglon_guia as b ON a.id_area = b.id_area and a.no_guia= b.no_guia 
				INNER JOIN dbo.trafico_viaje as c ON a.id_area = c.id_area and a.no_viaje = c.no_viaje 
				INNER JOIN dbo.mtto_unidades as d ON a.id_unidad = d.id_unidad 
				--INNER JOIN trafico_ruta as e ON c.id_ruta=e.id_ruta
				--inner join personal_personal as f on c.id_personal = f.id_personal
				-- need to ask if always will be cat 21 for holcim
			where	YEAR(a.fecha_guia) = @currentYear
					and MONTH(a.fecha_guia) in (SELECT item from dbo.fnSplit(@mes, '|'))
					and a.status_guia not in ('B')
					and a.prestamo not in ('P')
					and a.tipo_doc = '2' 
					--and a.id_area=@id_area
					and a.id_area in (SELECT item from dbo.fnSplit(@id_area, '|'))
					--and c.kms_viaje > 0
					and a.id_fraccion in (SELECT item from dbo.fnSplit(@fraction, '|'))
)

