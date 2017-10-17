select * from sistemas.dbo.projections_view_closed_period_units

---- - 
-- periodo cerrado
select * from sistemas.dbo.projections_view_indicators_periods_fleets where mes in ('Agosto') and id_area = '3' and company = '1'

-- operativo
select sum(subtotal) as 'total' , company,area, fraccion  from sistemas.dbo.projections_view_full_company_indicators
where company = 1 and area = 'RAMOS ARIZPE' and mes = 'Agosto' and year(fecha_guia) = '2017'
group by company,area, fraccion

-- operativo
select sum(subtotal) as 'total' ,"Tipo Carga" , "Año", Mes  from "bonampakdb"."dbo"."bon_view_get_acepted_subtons_ramos"
where "Año" = '2017' and Mes = 'AGOSTO'
group by 
"Tipo Carga" , "Año", Mes
---- - 


select * from sistemas.dbo.projections_view_canceled_periods where mes in ('Agosto') and id_area = '1' and company = '2'

select * from sistemas.dbo.projections_view_full_company_indicators where year(fecha_guia) = year(current_timestamp);


--OG-082125
--OG-082126
--OG-082129
--OG-082130
--OG-070520
--OG-062569

--OG-083956
--OG-083957
--OG-083959
--OG-083960

select 
	case desc_producto
		when 'PRODUCTOS VARIOS' then 'OTROS'
		else desc_producto
	end as 'desc_producto'
		from macuspanadb.dbo.trafico_producto 
		where 
	macuspanadb.dbo.trafico_producto.id_producto = 0


	select fraccion,"Tipo Carga" 
	from "macuspanadb"."dbo"."v_IndicadoresOperativos" 
	where Año = '2017' 
	group by fraccion,"Tipo Carga"
	
	
	use macuspanadb
	exec sp_helptext v_IndicadoresOperativos
	
	-- ====================
select "Tipo Carga" from "bonampakdb"."dbo"."bon_view_get_acepted_subtons_orizaba" 
group by "Tipo Carga"

	-- ====================
	
	
	
with "producto" as (
select 
	case 
		when 
				desc_producto not in ('GRANEL','ENCORTINADOS','CLINKER') 
		then
				'OTROS'
		else 
				desc_producto
	end as 'desc_producto'
from 
		bonampakdb.dbo.trafico_producto 
where 
		bonampakdb.dbo.trafico_producto.id_producto = 0
)
select * 
from "producto"
group by 
		desc_producto
	
		
		
		
---------------------------------------------------------------------------------------------------------------------------------------------------

use macuspanadb
IF OBJECT_ID ('v_IndicadoresOperativos', 'V') IS NOT NULL
	drop view v_IndicadoresOperativos;
		
use macuspanadb 
create
	view dbo.v_IndicadoresOperativos  as  
	
	select
		top(100) percent 
		year(e.f_despachado) as Año,
		day(e.f_despachado) as Dia,
		case
			month(e.f_despachado)
			when 1 then 'ENERO'
			when 2 then 'FEBRERO'
			when 3 then 'MARZO'
			when 4 then 'ABRIL'
			when 5 then 'MAYO'
			when 6 then 'JUNIO'
			when 7 then 'JULIO' 
			when 8 then 'AGOSTO'
			when 9 then 'SEPTIEMBRE'
			when 10 then 'OCTUBRE'
			when 11 then 'NOVIEMBRE'
			else 'DICIEMBRE'
		end as Mes,
		 case
			a.tviaje
			when 1 then 'Sencillo'
			when 2 then 'Sencillo'
			when '3' then 'Full'
		end as SencFull,
		 case
			when a.fraccion not in ('GRANEL') then 'OTROS'
			else a.fraccion
		end as [Tipo Carga],
		a.fecha_guia,
		a.num_guia as Talon,
		b.no_viaje as Viaje,
		 case
			when a.fraccion not in ('GRANEL') then 'OTROS'
			else a.fraccion
		end as 'fraccion',
		 f.desc_ruta as Ruta,
		a.Origen,
		a.tipo_operacion as [Tipo Operacion],
		case
			a.tipo_operacion
			when 'CD MERIDA' then 'MERIDA'
			else 'MACUSPANA'
		end as Flota,
		 a.kms_viaje as KmsViaje,
		a.kms_real,
		a.peso as Tonelaje,
		a.flete,
		a.otros as Adicional,
		a.subtotal,
		a.iva_guia as IVA,
		a.monto_retencion as Retencion,
		a.Total,
		 a.num_guia_asignado as Factura,
		c.nombre,
		g.id_unidad,
		a.nomoper,
		x.pr_nombre as Alias 
	from
		dbo.v_traficogias as a inner join  dbo.trafico_guia as b on
		a.id_area = b.id_area
		and a.num_guia = b.num_guia inner join  dbo.trafico_cliente as c on
		b.id_cliente = c.id_cliente inner join  dbo.mtto_unidades as g on
		a.id_unidad = g.id_unidad inner join  dbo.trafico_plaza as d on
		b.id_destino = d.id_plaza inner join  dbo.trafico_viaje as e on
		b.id_area = e.id_area
		and b.no_viaje = e.no_viaje inner join  dbo.trafico_ruta as f on
		e.id_ruta = f.id_ruta inner join  dbo.trafico_cliente as x on
		b.id_destinatario = x.id_cliente 
	where
		(
			b.status_guia <> 'B'
		)
		and(
			e.f_despachado > '2014-12-31 23:00.000'
		)
	order by
		c.nombre 
		
		


select * from "macuspanadb"."dbo"."v_viajesdesp"		


exec sp_helptext v_viajesdesp




/*1265                                                                                                                                                                  |
   select * from trafico_producto where id_producto = 0*/                                                                                                               |
IF OBJECT_ID ('v_viajesdesp', 'V') IS NOT NULL
	drop view v_viajesdesp;
create
	view dbo.v_viajesdesp  as  select
		count( distinct dbo.trafico_viaje.no_viaje ) as NoViaje,
		day(dbo.trafico_viaje.f_despachado) as Día,
		case
			month(f_despachado)
			when 1 then 'ENERO'
			when 2 then 'FEBRERO'
			when 3 then 'MARZO'
			when 4 then 'ABRIL'
			when 5 then 'MAYO'
			when 6 then 'JUNIO'
			when 7 then 'JULIO' 
			when 8 then 'AGOSTO'
			when 9 then 'SEPTIEMBRE'
			when 10 then 'OCTUBRE'
			when 11 then 'NOVIEMBRE'
			when 12 then 'DICIEMBRE'
		end as Mes,
		 dbo.trafico_viaje.no_viaje,
		dbo.trafico_viaje.kms_viaje * 2 as KmsViaje,
		dbo.trafico_cliente.nombre,
		dbo.trafico_viaje.kms_real as KmsReal,
		(
			select
				case
					when desc_producto not in ('GRANEL') then 'OTROS'
					else desc_producto
				end as 'desc_producto' 
			from
				dbo.trafico_producto 
			where
				(
					id_producto = 0
				)
				and(
					dbo.trafico_guia.id_fraccion = id_fraccion
				)
		) as [Tipo Carga],
		year(dbo.trafico_viaje.f_despachado) as Año 
	from
		dbo.trafico_viaje inner join  dbo.trafico_guia on
		dbo.trafico_viaje.id_area = dbo.trafico_guia.id_area
		and dbo.trafico_viaje.no_viaje = dbo.trafico_guia.no_viaje inner join  dbo.trafico_cliente on
		dbo.trafico_guia.id_cliente = dbo.trafico_cliente.id_cliente 
	where
		(
			year(dbo.trafico_viaje.f_despachado) > '2014'
		)
		and(
			dbo.trafico_viaje.id_area = 1
		)
	group by
		dbo.trafico_viaje.f_despachado,
		dbo.trafico_viaje.no_viaje,
		dbo.trafico_viaje.kms_viaje,
		dbo.trafico_cliente.nombre,
		dbo.trafico_viaje.kms_real,
		 dbo.trafico_guia.id_fraccion                                                                                                                   


--Aceptados 


--tons macuspana

use bonampakdb;
IF OBJECT_ID ('bon_view_get_acepted_subtons_ramos', 'V') IS NOT NULL
    DROP VIEW bon_view_get_acepted_subtons_ramos;


create view bon_view_get_acepted_subtons_ramos
--with encryption
as --16448
select 
				a.fecha_guia,
				--a.id_area,
				(
					select
							ltrim(rtrim(replace(areas_tbk.nombre ,'BONAMPAK' , '')))
					from 
							bonampakdb.dbo.general_area as areas_tbk
					where 
							areas_tbk.id_area = a.id_area
				) as 'Area',
--				(
--					select
--							ltrim(rtrim(replace(replace(areas_atm.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.','')))
--					from 
--							macuspanadb.dbo.general_area as areas_atm
--					where 
--							areas_atm.id_area = '1'
--				) as 'Area',
				CASE MONTH(a.fecha_guia) 
					WHEN 01 THEN 'ENERO' WHEN 02 THEN 'FEBRERO' WHEN 03 THEN 'MARZO' WHEN 04 THEN 'ABRIL' WHEN 05 THEN 'MAYO' WHEN 06 THEN 'JUNIO' 
					WHEN 07 THEN 'JULIO' WHEN 08 THEN 'AGOSTO' WHEN 09 THEN 'SEPTIEMBRE' WHEN 10 THEN 'OCTUBRE' WHEN 11 THEN 'NOVIEMBRE' ELSE 'DICIEMBRE' 
				END AS Mes,
				day(a.fecha_guia) as 'Dia',
				
				--(
				--	SELECT
				--		CASE tra_product.desc_producto 
				--			WHEN 'PRODUCTOS VARIOS' THEN 'OTROS' ELSE desc_producto
				--		END AS 'desc_producto'
				--	FROM
				--		dbo.trafico_producto as tra_product
				--	WHERE      
				--		(tra_product.id_producto = 0) 
				--			AND 
				--		(tra_product.id_fraccion = a.id_fraccion)
				--) AS [Fraccion],

				a.id_tipo_operacion,--a.id_fraccion,
				a.id_unidad,
				a.personalnombre as 'nombreOperador',
				a.num_guia,a.no_remision,a.no_viaje,--a.num_guia_asignado,
				a.subtotal,
				--renglon.peso,
				(
					select
							sum(peso) as 'peso' 
					from 
							dbo.trafico_renglon_guia 
					where 
							no_guia = a.no_guia
						and 
							id_area = a.id_area
						--and 
						--	id_fraccion = a.id_fraccion
				) as 'peso',
				traclient.nombre,
				a.no_guia,
				--d.id_flota ,
				case c.id_configuracionviaje when 1 then 'Sencillo' when 2 then 'Sencillo' when '3' then 'Full' end as SencFull,
				(
					select
						case 
							when desc_producto in ('GRANEL','ENVASADO','CLINKER') then 'GRANEL'
							when desc_producto not in ('GRANEL','ENVASADO','CLINKER') then 'OTROS'
							else desc_producto
						end as 'desc_producto'
					from
						dbo.trafico_producto
					where      
						(id_producto = 0) 
							AND 
						(dbo.trafico_producto.id_fraccion = a.id_fraccion)
				) as [Tipo Carga],
				(
					select 
							nombre
					from 
							dbo.desp_flotas
					where
							id_flota = d.id_flota
						
				) as 'Flota',
				year(a.fecha_guia) as 'Año',
				YEAR(c.f_despachado) as "YearDespachado",
				Month(c.f_despachado) as "MonthDespachado",
				day(c.f_despachado) as "DayDespachado"
from
				trafico_guia as a 
		INNER JOIN 
				trafico_viaje as c 
		on 
				a.id_area = c.id_area 
			and 
				a.no_viaje = c.no_viaje 
		INNER JOIN 
				mtto_unidades as d 
		on 
				a.id_unidad = d.id_unidad 
		inner join
				dbo.trafico_cliente AS traclient 
		on 
				traclient.id_cliente = a.id_cliente
where 
				year(a.fecha_guia) > '2014' 
			and 
				a.tipo_doc = '2' 
			and 
				a.status_guia <> 'B' 
			and 
				a.prestamo <> 'P'
			and
				a.id_area = '3'

				
				
--trips

use macuspanadb
select * from "macuspanadb"."dbo"."bon_view_get_acepted_kilotrips_macuspana"

IF OBJECT_ID ('bon_view_get_acepted_kilotrips_macuspana', 'V') IS NOT NULL
    DROP VIEW bon_view_get_acepted_kilotrips_macuspana;


create view bon_view_get_acepted_kilotrips_macuspana
--with encryption
as

select distinct
				a.no_viaje as 'Viajes',
				--a.num_guia as "CartaPorte", 
				(c.kms_viaje*2) as Kilometros,
				c.kms_real as Kilometers,
				--(select dbo.getArea(a.id_area,'BONAMPAK')) as 'Area',
				(
					select
							ltrim(rtrim(replace(areas_tbk.nombre ,'BONAMPAK' , '')))
					from 
							macuspanadb.dbo.general_area as areas_tbk
					where 
							areas_tbk.id_area = a.id_area
				) as 'Area',
				--(
				--	select
				--			ltrim(rtrim(replace(replace(areas_atm.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.','')))
				--	from 
				--			macuspanadb.dbo.general_area as areas_atm
				--	where 
				--			areas_atm.id_area = '1'
				--) as 'Area',
				(select dbo.setMonthName( (select right('00'+convert(varchar(2),MONTH(a.fecha_guia)), 2)) )) as Mes,
				--day(a.fecha_guia) as 'Dia',
				(
					select 
					top(1)
							day(tra_guia.fecha_guia) as 'Dia'

						FROM trafico_guia as tra_guia
							--INNER JOIN trafico_renglon_guia as tra_renguia ON tra_guia.id_area = tra_renguia.id_area and tra_guia.no_guia= tra_renguia.no_guia 
							INNER JOIN trafico_viaje as tra_renvi ON tra_guia.id_area = tra_renvi.id_area and tra_guia.no_viaje = tra_renvi.no_viaje 
							--INNER JOIN mtto_unidades as mtto_unit ON tra_guia.id_unidad = mtto_unit.id_unidad 
							--INNER JOIN trafico_ruta as tra_rute ON tra_renvi.id_ruta=tra_rute.id_ruta 
							--inner join trafico_cliente as tra_client on tra_guia.id_cliente = tra_client.id_cliente
						where	YEAR(tra_guia.fecha_guia) = YEAR(a.fecha_guia)
								and tra_guia.status_guia <> 'B' 
								and tra_guia.prestamo <> 'P'
								and tra_guia.tipo_doc = 2 
								and tra_guia.id_area = a.id_area
								and tra_guia.id_fraccion = a.id_fraccion
								and tra_renvi.no_viaje = c.no_viaje
				) as 'Dia',
				tc.nombre as 'NombreCliente',
				(select dbo.getFlota(d.id_flota)) as 'Flota',
				(
					SELECT
						CASE
							WHEN tra_product.desc_producto  not in  ('GRANEL','ENVASADO','CLINKER') THEN 'OTROS' 
							ELSE desc_producto
						END AS 'desc_producto'
					FROM
						dbo.trafico_producto as tra_product
					WHERE      
						(tra_product.id_producto = 0) 
							AND 
						(tra_product.id_fraccion = a.id_fraccion)
				) AS [Fraccion],
--				(select dbo.getFraccionName(a.id_fraccion)) as Fraccion,
				YEAR(a.fecha_guia) as 'year',
				YEAR(c.f_despachado) as "YearDespachado",
				Month(c.f_despachado) as "MonthDespachado",
				day(c.f_despachado) as "DayDespachado",
				count(c.no_viaje) over() as 'CountAll'
			FROM trafico_guia as a 
				INNER JOIN trafico_renglon_guia as b ON a.id_area = b.id_area and a.no_guia= b.no_guia 
				INNER JOIN trafico_viaje as c ON a.id_area = c.id_area and a.no_viaje = c.no_viaje 
				INNER JOIN mtto_unidades as d ON a.id_unidad = d.id_unidad 
				INNER JOIN trafico_ruta as e ON c.id_ruta=e.id_ruta 
				inner join trafico_cliente as tc on a.id_cliente = tc.id_cliente
			where	YEAR(a.fecha_guia) > '2014' 
					--and MONTH(a.fecha_guia) in (SELECT item from dbo.fnSplit(@mes, '|'))
					--and day(a.f_despachado) = datepart(DAY ,CURRENT_TIMESTAMP)
					and a.status_guia <> 'B' 
					and a.prestamo <> 'P'
					and a.tipo_doc = 2 
					--and a.id_area = '3'
					--and month(a.fecha_guia) = '03'
					--and day(a.fecha_guia) in ('28','29')
					and c.kms_viaje > 0
					--and a.id_fraccion in ('4','5')
					--and c.no_viaje = '43628'



		
		