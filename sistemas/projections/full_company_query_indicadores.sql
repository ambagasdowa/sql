------------------------------------------------------------------------------------------------------------------------------------------
-- Operations ind Engine build for three databases
------------------------------------------------------------------------------------------------------------------------------------------

USE sistemas;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : September 20, 2016
 Description    : Quering the operational data as kms,tons,trips,cash from lis datatables 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 0.0.9
 ===============================================================================*/
 
CREATE PROCEDURE [dbo].[sp_xd3e_getFullCompanyOperations]
 (
	@year varchar(8000),		-- year or years
	@month varchar(8000),		-- month or months
	@Company varchar(8000),		-- companies id's 
	@bunit varchar(8000)		-- the bussinessunits id's
 )
 with encryption
 as 
 SET NOCOUNT ON;

-- declare @year varchar(8000) , @month varchar(8000) , @company varchar(8000) , @bunit varchar(8000);



-- building cache 
declare @indicators table (
								id_area int,
								id_unidad varchar(10) not null,
								id_configuracionviaje int,
								id_tipo_operacion int,
								id_fraccion int,
								id_flota int,
								no_viaje int,
								fecha_guia varchar(10),
								mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
								f_despachado datetime,
								cliente varchar(60),
								kms_viaje int,
								kms_real int,
								subtotal decimal(18,6),
								--ingresos decimal(18,6),
								peso decimal(18,6),
								configuracion_viaje varchar(20),
								tipo_de_operacion varchar(20),
								flota varchar(40),
								area varchar(40),
								fraccion varchar(60),
								company int,
								trip_count tinyint
 						  )

declare @duplicates table (
								id_area int,
								id_unidad varchar(10) not null,
								id_configuracionviaje int,
								id_tipo_operacion int,
								id_fraccion int,
								id_flota int,
								no_viaje int,
								fecha_guia varchar(10),
								mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
								f_despachado datetime,
								cliente varchar(60),
								kms_viaje int,
								kms_real int,
								subtotal decimal(18,6),
								--ingresos decimal(18,6),
								peso decimal(18,6),
								configuracion_viaje varchar(20),
								tipo_de_operacion varchar(20),
								flota varchar(40),
								area varchar(40),
								fraccion varchar(60),
								company int,
								trip_count tinyint
 						  )

--set @year = YEAR(CURRENT_TIMESTAMP)
--set @month = month(CURRENT_TIMESTAMP)
select @year = '2016'
--select @month = '01|02|03|04|05|06|07|08|09|10'
select @month = '09'
select @Company = '0'
--select @bunit = ''

set language spanish;

	if (@company = 1  ) OR (@Company = 0)
		begin
		insert into @indicators
		select 
				 viaje.id_area
				,viaje.id_unidad
				,viaje.id_configuracionviaje
				,guia.id_tipo_operacion
				,guia.id_fraccion
				,manto.id_flota
				,viaje.no_viaje
				,guia.fecha_guia
				,(select datename(mm,guia.fecha_guia)) as 'mes'
				,viaje.f_despachado
				,cliente.nombre as 'cliente'
				,viaje.kms_viaje
				,viaje.kms_real
				,guia.subtotal
				--,guia.ingresos
				,(
					select 
							sum(rg.peso)
					from 
							bonampakdb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia in (
												select 
														tguia.no_guia 
												from 
														bonampakdb.dbo.trafico_guia as tguia 
												where 
														tguia.id_area = viaje.id_area 
													and tguia.no_viaje = viaje.no_viaje
													and tguia.status_guia <> 'B' 
													and tguia.prestamo <> 'P'
													and tguia.tipo_doc = 2 
													and tguia.id_fraccion = guia.id_fraccion
												)
						and rg.id_area = viaje.id_area

				 ) as 'peso'
				,(
					select 
							descripcion
					from
							bonampakdb.dbo.trafico_configuracionviaje as trviaje
					where
							trviaje.id_configuracionviaje = viaje.id_configuracionviaje
				) as 'configuracion_viaje'
				,(
					select 
							tipo_operacion
					from
							bonampakdb.dbo.desp_tipooperacion tpop
					where 
							tpop.id_tipo_operacion = guia.id_tipo_operacion
				 ) as 'tipo_de_operacion'
				,(
					select 
							nombre
					from 
							bonampakdb.dbo.desp_flotas as fleet
					where
							fleet.id_flota = manto.id_flota
						
				) as 'flota'
				,(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS S.A. DE C.V.','TULTITLAN')))
					from 
							bonampakdb.dbo.general_area as areas
					where 
							areas.id_area = viaje.id_area
				) as 'area'
			
				 ,(
					select
							desc_producto
					from
						bonampakdb.dbo.trafico_producto as producto
					where      
						(producto.id_producto = 0) 
							AND 
						(producto.id_fraccion = guia.id_fraccion)
				) as 'fraccion',

				(select 1) as 'company',
				guia.trip_count
		from 
				bonampakdb.dbo.trafico_viaje as viaje
			------------------------------------------------------------------------------------------------------------------------------
			-- hir can join trafico_renglon_guia with a select or left join
			------------------------------------------------------------------------------------------------------------------------------
			inner join (
								select --top(1)
									trg.id_area,trg.id_fraccion,trg.no_viaje
									--,trg.status_guia,trg.prestamo,trg.tipo_doc
									,min(trg.id_cliente) as 'id_cliente'
									,min(trg.id_tipo_operacion) as 'id_tipo_operacion'
									--,(select( right('00'+convert(varchar(2),DAY(trg.fecha_guia)), 2) +'-'+ right('00'+convert(varchar(2),MONTH(trg.fecha_guia)), 2) + '-' + CONVERT(nvarchar(4), YEAR(trg.fecha_guia)))) as 'fecha_guia'
									--,min(trg.fecha_guia) as 'fecha_guia'
									,(
										case 
											when min(trg.fecha_guia) <> max(trg.fecha_guia)
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select max(trg.fecha_guia))
																)
														else 
															null
													end
											else
																(
																	(select min(trg.fecha_guia))
																)
										end
									) as 'fecha_guia'
									,(
										case 
											when min(trg.fecha_guia) <> max(trg.fecha_guia)
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select '0')
																)
														else 
															null
													end
											else
																(
																	(select '1')
																)
										end
									) as 'trip_count'
									--,(
									--	case 
									--		when min(trg.fecha_guia) <> max(trg.fecha_guia)
									--			then 
									--				case 
									--					when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
									--						then (
									--								select gia.subtotal 
									--								from bonampakdb.dbo.trafico_guia as gia 
									--								where gia.no_viaje = min(trg.no_viaje)
									--									and gia.fecha_guia = max(trg.fecha_guia) 
									--									and gia.status_guia <> 'B' and gia.prestamo <> 'P' and gia.tipo_doc = 2 
									--							) 
									--					else 
									--						null
									--				end
									--		else
									--			(sum(trg.subtotal))
									--	end
									--) as 'ingresos'
									,sum(trg.subtotal) as 'subtotal'
								from bonampakdb.dbo.trafico_guia as trg
								where	
										trg.status_guia <> 'B'
										and trg.prestamo <> 'P'
										and trg.tipo_doc = 2 
								group by trg.id_area,trg.id_fraccion,trg.no_viaje
										--,trg.status_guia,trg.prestamo,trg.tipo_doc
										--,trg.id_cliente
										--,trg.id_tipo_operacion
										--,trg.fecha_guia
										 --,year(trg.fecha_guia),month(trg.fecha_guia),day(trg.fecha_guia)
			) as guia on guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
			inner join
					bonampakdb.dbo.trafico_cliente as cliente
						on cliente.id_cliente = guia.id_cliente
			inner join 
					bonampakdb.dbo.mtto_unidades as manto
						on manto.id_unidad = viaje.id_unidad
		where 
				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
			and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
			-- and viaje.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))

		--order by viaje.no_viaje
	end
	if (@Company = 3 ) OR (@Company = 0)
	
	begin

	insert into @indicators
--	union all

	select 
				 viaje.id_area
				,viaje.id_unidad
				,viaje.id_configuracionviaje
				,guia.id_tipo_operacion
				,guia.id_fraccion
				,manto.id_flota
				,viaje.no_viaje
				,guia.fecha_guia
				,(select datename(mm,guia.fecha_guia)) as 'mes'
				,viaje.f_despachado
				,cliente.nombre as 'cliente'
				,viaje.kms_viaje
				,viaje.kms_real
				,guia.subtotal
				--,guia.ingresos
				,(
					select 
							sum(rg.peso)
					from 
							tespecializadadb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia in (
												select 
														tguia.no_guia 
												from 
														tespecializadadb.dbo.trafico_guia as tguia 
												where 
														tguia.id_area = viaje.id_area 
													and tguia.no_viaje = viaje.no_viaje
													and tguia.status_guia <> 'B' 
													and tguia.prestamo <> 'P'
													and tguia.tipo_doc = 2 
													and tguia.id_fraccion = guia.id_fraccion
												)
						and rg.id_area = viaje.id_area

				 ) as 'peso'
				,(
					select 
							descripcion
					from
							tespecializadadb.dbo.trafico_configuracionviaje as trviaje
					where
							trviaje.id_configuracionviaje = viaje.id_configuracionviaje
				) as 'configuracion_viaje'
				,(
					select 
							tipo_operacion
					from
							tespecializadadb.dbo.desp_tipooperacion tpop
					where 
							tpop.id_tipo_operacion = guia.id_tipo_operacion
				 ) as 'tipo_de_operacion'
				,(
					select 
							nombre
					from 
							tespecializadadb.dbo.desp_flotas as fleet
					where
							fleet.id_flota = manto.id_flota
						
				) as 'flota'
				,(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS S.A. DE C.V.','TULTITLAN')))
					from 
							tespecializadadb.dbo.general_area as areas
					where 
							areas.id_area = viaje.id_area
				) as 'area'

				 ,(
					select
							desc_producto
					from
						tespecializadadb.dbo.trafico_producto as producto
					where      
						(producto.id_producto = 0) 
							AND 
						(producto.id_fraccion = guia.id_fraccion)
				) as 'fraccion',

				(select 3) as 'company',
				guia.trip_count
		from 
				tespecializadadb.dbo.trafico_viaje as viaje
			------------------------------------------------------------------------------------------------------------------------------
			-- hir can join trafico_renglon_guia with a select or left join
			------------------------------------------------------------------------------------------------------------------------------
			inner join (
								select --top(1)
									trg.id_area,trg.id_fraccion,trg.no_viaje
									--,trg.status_guia,trg.prestamo,trg.tipo_doc
									,min(trg.id_cliente) as 'id_cliente'
									,min(trg.id_tipo_operacion) as 'id_tipo_operacion'
									--,(select( right('00'+convert(varchar(2),DAY(trg.fecha_guia)), 2) +'-'+ right('00'+convert(varchar(2),MONTH(trg.fecha_guia)), 2) + '-' + CONVERT(nvarchar(4), YEAR(trg.fecha_guia)))) as 'fecha_guia'
									--,min(trg.fecha_guia) as 'fecha_guia'
									,(
										case 
											when min(trg.fecha_guia) <> max(trg.fecha_guia)
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select max(trg.fecha_guia))
																)
														else 
															null
													end
											else
																(
																	(select min(trg.fecha_guia))
																)
										end
									) as 'fecha_guia'
									,(
										case 
											when min(trg.fecha_guia) <> max(trg.fecha_guia)
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select '0')
																)
														else 
															null
													end
											else
																(
																	(select '1')
																)
										end
									) as 'trip_count'
									--,(
									--	case 
									--		when min(trg.fecha_guia) <> max(trg.fecha_guia)
									--			then 
									--				case 
									--					when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
									--						then (
									--								select gia.subtotal 
									--								from tespecializadadb.dbo.trafico_guia as gia 
									--								where gia.no_viaje = min(trg.no_viaje)
									--									and gia.fecha_guia = max(trg.fecha_guia) 
									--									and gia.status_guia <> 'B' and gia.prestamo <> 'P' and gia.tipo_doc = 2 
									--							) 
									--					else 
									--						null
									--				end
									--		else
									--			(sum(trg.subtotal))
									--	end
									--) as 'ingresos'
									,sum(trg.subtotal) as 'subtotal'
								from tespecializadadb.dbo.trafico_guia as trg
								where	
										trg.status_guia <> 'B'
										and trg.prestamo <> 'P'
										and trg.tipo_doc = 2 
								group by trg.id_area,trg.id_fraccion,trg.no_viaje
										--,trg.status_guia,trg.prestamo,trg.tipo_doc
										--,trg.id_cliente
										--,trg.id_tipo_operacion
										--,trg.fecha_guia
										 --,year(trg.fecha_guia),month(trg.fecha_guia),day(trg.fecha_guia)
			) as guia on guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
			inner join
					tespecializadadb.dbo.trafico_cliente as cliente
						on cliente.id_cliente = guia.id_cliente
			inner join 
					tespecializadadb.dbo.mtto_unidades as manto
						on manto.id_unidad = viaje.id_unidad
		where 
				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
			and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
			--and viaje.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
		--order by viaje.no_viaje
		end
	--union all
	if (@Company = 2) OR (@Company = 0)
	begin
		insert into @indicators
	select 
				 viaje.id_area
				,viaje.id_unidad
				,viaje.id_configuracionviaje
				,guia.id_tipo_operacion
				,guia.id_fraccion
				,manto.id_flota
				,viaje.no_viaje
				,guia.fecha_guia
				,(select datename(mm,guia.fecha_guia)) as 'mes'
				,viaje.f_despachado
				,cliente.nombre as 'cliente'
				,viaje.kms_viaje
				,viaje.kms_real
				,guia.subtotal
				--,guia.ingresos
				,(
					select 
							sum(rg.peso)
					from 
							macuspanadb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia in (
												select 
														tguia.no_guia 
												from 
														macuspanadb.dbo.trafico_guia as tguia 
												where 
														tguia.id_area = viaje.id_area 
													and tguia.no_viaje = viaje.no_viaje
													and tguia.status_guia <> 'B' 
													and tguia.prestamo <> 'P'
													and tguia.tipo_doc = 2 
													and tguia.id_fraccion = guia.id_fraccion
												)
						and rg.id_area = viaje.id_area

				 ) as 'peso'
				,(
					select 
							descripcion
					from
							macuspanadb.dbo.trafico_configuracionviaje as trviaje
					where
							trviaje.id_configuracionviaje = viaje.id_configuracionviaje
				) as 'configuracion_viaje'
				,(
					select 
							tipo_operacion
					from
							macuspanadb.dbo.desp_tipooperacion tpop
					where 
							tpop.id_tipo_operacion = guia.id_tipo_operacion
				 ) as 'tipo_de_operacion'
				,(
					select 
							nombre
					from 
							macuspanadb.dbo.desp_flotas as fleet
					where
							fleet.id_flota = manto.id_flota
						
				) as 'flota'
				,(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS S.A. DE C.V.','TULTITLAN')))
					from 
							macuspanadb.dbo.general_area as areas
					where 
							areas.id_area = viaje.id_area
				) as 'area'

				 ,(
					select
							desc_producto
					from
						macuspanadb.dbo.trafico_producto as producto
					where      
						(producto.id_producto = 0) 
							AND 
						(producto.id_fraccion = guia.id_fraccion)
				) as 'fraccion',

				(select 2) as 'company',
				guia.trip_count
		from 
				macuspanadb.dbo.trafico_viaje as viaje
			------------------------------------------------------------------------------------------------------------------------------
			-- hir can join trafico_renglon_guia with a select or left join
			------------------------------------------------------------------------------------------------------------------------------
			inner join (
								select --top(1)
									 trg.id_area
									,trg.id_fraccion
									,trg.no_viaje
									--,trg.status_guia,trg.prestamo,trg.tipo_doc
									--,min(trg.no_guia) as 'no_guia', 
									,min(trg.id_cliente) as 'id_cliente'
									,min(trg.id_tipo_operacion) as 'id_tipo_operacion'
									--,(select( right('00'+convert(varchar(2),DAY(trg.fecha_guia)), 2) +'-'+ right('00'+convert(varchar(2),MONTH(trg.fecha_guia)), 2) + '-' + CONVERT(nvarchar(4), YEAR(trg.fecha_guia)))) as 'fecha_guia'
									--,min(trg.fecha_guia) as 'fecha_guia'
									,(
										case 
											when min(trg.fecha_guia) <> max(trg.fecha_guia)
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select max(trg.fecha_guia))
																)
														else 
															null
													end
											else
																(
																	(select min(trg.fecha_guia))
																)
										end
									) as 'fecha_guia'
									,(
										case 
											when min(trg.fecha_guia) <> max(trg.fecha_guia)
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select '0')
																)
														else 
															null
													end
											else
																(
																	(select '1')
																)
										end
									) as 'trip_count'
									--,(
									--	case 
									--		when min(trg.fecha_guia) <> max(trg.fecha_guia)
									--			then 
									--				case 
									--					when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
									--						then (
									--								select gia.subtotal 
									--								from macuspanadb.dbo.trafico_guia as gia 
									--								where gia.no_viaje = min(trg.no_viaje)
									--									and gia.fecha_guia = max(trg.fecha_guia) 
									--									and gia.status_guia <> 'B' and gia.prestamo <> 'P' and gia.tipo_doc = 2 
									--							) 
									--					else 
									--						null
									--				end
									--		else
									--			(sum(trg.subtotal))
									--	end
									--) as 'ingresos'
									,sum(trg.subtotal) as 'subtotal'
								from macuspanadb.dbo.trafico_guia as trg
								where	
										trg.status_guia <> 'B'
										and trg.prestamo <> 'P'
										and trg.tipo_doc = 2 
								group by trg.id_area,trg.id_fraccion,trg.no_viaje
										--,trg.status_guia,trg.prestamo,trg.tipo_doc
										--,trg.id_cliente
										--,trg.id_tipo_operacion
										--,trg.fecha_guia
										 --,year(trg.fecha_guia),month(trg.fecha_guia) ,day(trg.fecha_guia)
			) as guia on guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
			inner join
					macuspanadb.dbo.trafico_cliente as cliente
						on cliente.id_cliente = guia.id_cliente
			inner join 
					macuspanadb.dbo.mtto_unidades as manto
						on manto.id_unidad = viaje.id_unidad
		where 
				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
			and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
			--and viaje.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
		end

--	order by viaje.no_viaje



select * from @indicators;

go






--SELECT * 
--FROM Account 
--WHERE (type <>100000002 ? Id='something': Id=null)
--For SQLSERVER-2012.but IIF is not working in SQLSERVER-2008 or less version.

-- SELECT * 
--    FROM Account 
--    WHERE 
--    Id=IIF(type<> 100000002,"something",null )

--If you use SQLSERVER-2008 or less version. Please try this.Sorry buddy no better way for you.

--  SELECT * 
--    FROM Account 
--    WHERE (Id= CASE WHEN type <>100000002 THEN 'something'  ELSE null END)

--select * from sistemas.dbo.casetas_units
--		where (casetas_units_name = case when casetas_corporations_id <> 1 then 'ATMMAC' else null end ) and user_id = '1' and _status = 0




--select convert(datetime , '11-03-2016',103)
--select datename(mm,(select convert(datetime , '11-03-2016',103)))


-- search for 24093 tbk
-- viaje teisa 106202


--SELECT @SomeValue = SomeValue FROM SomeTable

--IF @SomeValue IS NULL
--    INSERT INTO OtherTable VALUES (1, 2, 3)
--    SELECT NewlyInsertedValue FROM OtherTable;
--ELSE
--    INSERT INTO OtherTable VALUES (1, 2, 3)
--    SELECT SomeOtherValue FROM WeirdTable;
--END IF;




declare @tmp_table table
					(
						subtotal decimal(8,2)
					)




declare @viaje as int, @fecha as datetime;
set @viaje = 105844; --95153
set @fecha = CURRENT_TIMESTAMP
--set @fecha = '2016-10-07 09:25:21.703'
--set @fecha = '2016-04-22 16:11:29.000'


					select 
							rg.peso,*
					from 
							tespecializadadb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia in (
												select 
														tguia.no_guia 
												from 
														tespecializadadb.dbo.trafico_guia as tguia 
												where 
														tguia.no_viaje = @viaje
													and tguia.status_guia <> 'B' 
													and tguia.prestamo <> 'P'
													and tguia.tipo_doc = 2 
													
												)
						



select subtotal,no_guia,fecha_guia,no_viaje,id_fraccion from tespecializadadb.dbo.trafico_guia where no_viaje = @viaje and status_guia <> 'B' and prestamo <> 'P' and tipo_doc = 2 


select 
--		no_guia, kms, ingresos, tonelajes , trips

		

		(
			case 
				when min(guia.fecha_guia) <> max(guia.fecha_guia)
					then 
						case 
							when  @fecha > min(guia.fecha_guia) and @fecha >= max(guia.fecha_guia)
								then 
									(
										(select max(guia.fecha_guia))
									)
							else 
								null
						end
				else
									(
										(select min(guia.fecha_guia))
									)
			end
		) as 'fecha_guia',
		-- Case Ingresos
		(
			case 
				when min(guia.fecha_guia) <> max(guia.fecha_guia)
					then 
						case 
							when  @fecha > min(guia.fecha_guia) and @fecha >= max(guia.fecha_guia)
								then (
										select gia.subtotal 
										from tespecializadadb.dbo.trafico_guia gia 
										where gia.no_viaje = @viaje 
											and gia.fecha_guia = max(guia.fecha_guia) 
											and gia.status_guia <> 'B' and gia.prestamo <> 'P' and gia.tipo_doc = 2 
									) 
								--then (select '0')
							else 
								null
						end
				else
					(sum(guia.subtotal))
			end
		) as 'Ingresos',

		--- Case Tons 
		(
			case 
				--when min(guia.fecha_guia) <> max(guia.fecha_guia)
				when (select( CONVERT(nvarchar(4), YEAR(trg.fecha_guia))) + '-' + right('00'+convert(varchar(2),MONTH(trg.fecha_guia)), 2)  ) 
					then 
						-- translate
						case 
							when  @fecha > min(guia.fecha_guia) and @fecha >= max(guia.fecha_guia)
								then 
									(
										select 
												sum(rg.peso)
										from 
												tespecializadadb.dbo.trafico_renglon_guia as rg
										where 
												rg.no_guia in (
																	select 
																			tguia.no_guia 
																	from 
																			tespecializadadb.dbo.trafico_guia as tguia 
																	where 
																			tguia.no_viaje = @viaje
																		and tguia.status_guia <> 'B' 
																		and tguia.prestamo <> 'P'
																		and tguia.tipo_doc = 2 
																		and tguia.fecha_guia = max(guia.fecha_guia)
													
																	)
									) 
							
							else 
								null
						end




				else
									(
										select 
												sum(rg.peso)
										from 
												tespecializadadb.dbo.trafico_renglon_guia as rg
										where 
												rg.no_guia in (
																	select 
																			tguia.no_guia 
																	from 
																			tespecializadadb.dbo.trafico_guia as tguia 
																	where 
																			tguia.no_viaje = @viaje
																		and tguia.status_guia <> 'B' 
																		and tguia.prestamo <> 'P'
																		and tguia.tipo_doc = 2 
																	)
									) 
			end
		) as 'Weight',
		guia.no_viaje,

		(
			case 
				when min(guia.fecha_guia) <> max(guia.fecha_guia)
					then (select max(guia.fecha_guia) as 'date')
					else (select min(guia.fecha_guia) as 'date')
				end
		) as 'case',

		(
			case 
				when min(guia.fecha_guia) <> max(guia.fecha_guia)
					then 
						case 
							when  @fecha > min(guia.fecha_guia) and @fecha >= max(guia.fecha_guia)
								then 
									(
										select '0'
									)
							else 
								null
						end
				else
									(
										select '1'
									)
			end
		) as 'trip_count'
from
		tespecializadadb.dbo.trafico_guia guia
where guia.no_viaje = @viaje and guia.status_guia <> 'B' and guia.prestamo <> 'P' and guia.tipo_doc = 2 
group by guia.no_viaje

select * from @tmp_table
go



select kms_viaje,f_despachado,* from tespecializadadb.dbo.trafico_viaje where no_viaje = @viaje

select no_guia,subtotal,no_viaje,* from tespecializadadb.dbo.trafico_guia where no_viaje = 95153 and status_guia <> 'B' and prestamo <> 'P' and tipo_doc = 2 

select peso,* from tespecializadadb.dbo.trafico_renglon_guia where no_guia in (select no_guia from tespecializadadb.dbo.trafico_guia where no_viaje = @viaje
																				and status_guia <> 'B'
																				and prestamo <> 'P'
																				and tipo_doc = 2 
																			   )


-- declare @viaje as int;
set @viaje = 24093;

select kms_viaje,f_despachado,* from bonampakdb.dbo.trafico_viaje where no_viaje = @viaje and id_area = '1'

select no_guia,subtotal,no_viaje,id_tipo_operacion,* from bonampakdb.dbo.trafico_guia where no_viaje = @viaje and status_guia <> 'B' and prestamo <> 'P' and tipo_doc = 2  and id_area = '1'

select peso,* from bonampakdb.dbo.trafico_renglon_guia where no_guia in (select no_guia from bonampakdb.dbo.trafico_guia where no_viaje = @viaje
																				and status_guia <> 'B'
																				and prestamo <> 'P'
																				and tipo_doc = 2 
																				and id_area = '1'
																			   )
																	and id_area = '1'
																	







select subtotal,no_viaje,* from tespecializadadb.dbo.trafico_guia 
				where year(fecha_guia) = '2016' and month(fecha_guia) = '09' and id_area = '1' and id_fraccion = '1'
										and status_guia <> 'B'
										and prestamo <> 'P'
										and tipo_doc = 2 


select
			id_area,id_fraccion,no_viaje
			--,status_guia,prestamo,tipo_doc
			,id_cliente,id_tipo_operacion
			--,num_guia
			--,no_guia
			,min(fecha_guia)
			,sum(subtotal)
		from tespecializadadb.dbo.trafico_guia where no_viaje = '106202'
										and status_guia <> 'B'
										and prestamo <> 'P'
										and tipo_doc = 2 
		group by id_area,id_fraccion,no_viaje,id_cliente,id_tipo_operacion--,no_guia
				--,status_guia,prestamo,tipo_doc

select 
			sum(subtotal) as 'total'
			--,min(year(fecha_guia))
			--,min(month(fecha_guia))
			--,min(day(fecha_guia))
			,(select ( right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) + '-' + right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) + '-' + CONVERT(nvarchar(4), min(YEAR(fecha_guia))) )) as 'date'
			, right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) as dy
			,right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) as mt
			,CONVERT(nvarchar(4), min(YEAR(fecha_guia))) as yr
			,no_viaje
			,tipo_doc 

		from tespecializadadb.dbo.trafico_guia 
		where no_viaje = '106202'
										and status_guia <> 'B'
										and prestamo <> 'P'
										and tipo_doc = 2 
		group by year(fecha_guia),month(fecha_guia),no_viaje,tipo_doc


set language spanish;
select 
		sum(subtotal) as 'total'
		--,(select( right('00'+convert(varchar(2),min(DAY(fecha_guia))), 2) +'-'+ right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) + '-' + CONVERT(nvarchar(4), min(YEAR(fecha_guia))))) as 'fecha_guia'
		,(select( right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) + '-' + CONVERT(nvarchar(4), min(YEAR(fecha_guia))))) as 'fecha_guia'
		,(select datename(mm,fecha_guia)) as 'mes'
		,no_viaje
		,tipo_doc 
						from tespecializadadb.dbo.trafico_guia 
						where no_viaje = '106066'
										and status_guia <> 'B'
										and prestamo <> 'P'
										and tipo_doc = 2 
						group by year(fecha_guia),month(fecha_guia),no_viaje,tipo_doc,day(fecha_guia)



select peso,* from tespecializadadb.dbo.trafico_renglon_guia where no_guia in ('115408','115673')
