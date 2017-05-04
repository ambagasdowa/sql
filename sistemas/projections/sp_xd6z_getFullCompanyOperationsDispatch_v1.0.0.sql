
-- USE sistemas
 
ALTER PROCEDURE [dbo].[sp_xd6z_getFullCompanyOperationsDispatch]
 (
	@year varchar(8000),		-- year or years ex:'2016|2017'
	@month varchar(8000),		-- month or months ex: '01|02|03|04|05|06|07|08|09|10'
	@mode tinyint				-- mode 0 = queryAccepted 1 = insert Accepted in period  3 = queryCancelInsert  4 = queryCancelView  5 = insertAcceptedUpt
 )

 with encryption
 as 
 	SET NOCOUNT ON
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER on
	
/*===============================================================================
 Author         : Jesus Baizabal
 email			: baizabal.jesus@gmail.com
 Create date    : March 03, 2017
 Description    : Quering the operational data as kms,tons,trips,cash from lis datatables for dispatched (this must be fecha_de_inicio but is the requeriment)
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.6
 ===============================================================================*/

-- ======================================================================================================== --
-- 										Building Dispatch
-- ======================================================================================================== --		


--	declare @year as nvarchar(4000)	
--	declare @month as nvarchar(4000)
--	declare @mode as int
--	
--	set @year = '0'
--	set @month = '0'
--	set @mode = 1


-- set the vars
		
	if @month = '0'
		begin
			set @month = '01|02|03|04|05|06|07|08|09|10|11|12'
		end
		
	if @year = '0'
		begin
			set @year = year(current_timestamp)
		end 
	
		
-- build the tables

	
-- ====================================== TODO ========================================================
-- build query , that brings , all dispatched trips of month and not acepted in any month counterpart
-- brings all trips and set if have a aceptation , cancelations or only dispatch
-- ====================================== CANCELATIONS ================================================
--status_guia
--A=> Abierta o pendiente
--C=> Confirmada o Transferidas
--T=> Transito
--R=> Regreso
--B=> Cancelada
declare @doc_type as varchar(4000)
	if (@mode = 0 or @mode = 1 or @mode = 2 or @mode = 5 or @mode = 8)
		begin
			set @doc_type = 'R|T|C|A' -- ?? acepted
		end 
	if (@mode = 3 )
		begin
			set @doc_type = 'B' --Cancelations
		end 
		--in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
-- 1 = 'R|T|C|A'
-- 2 = 'B'
-- ====================================== CANCELATIONS ================================================
		
set language spanish
--declare the tables
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
								peso decimal(18,6),
								configuracion_viaje varchar(20),
								tipo_de_operacion varchar(20),
								flota varchar(40),
								area varchar(40),
								fraccion varchar(60),
								company int
								,trip_count tinyint
 						  )

declare @geminus table (
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
								peso decimal(18,6),
								configuracion_viaje varchar(20),
								tipo_de_operacion varchar(20),
								flota varchar(40),
								area varchar(40),
								fraccion varchar(60),
								company int
								,trip_count tinyint
 						  )
declare @cownter table (
								no_viaje int,
								id_area int,
								fecha_guia varchar(10),
								mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
								subtotal decimal(18,6),
								peso decimal(18,6),
								tipo_de_operacion varchar(20),
								area varchar(40),
								fraccion varchar(60),
								company int
								,trip_count tinyint
 						  )
		
		
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
				,(select datename(mm,viaje.f_despachado)) as 'mes'
				,viaje.f_despachado
				,cliente.nombre as 'cliente'
				,viaje.kms_viaje
				,viaje.kms_real
				,guia.subtotal
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
													--and tguia.status_guia <> 'B'
													and tguia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|')) 
													and tguia.prestamo <> 'P'
													and tguia.tipo_doc = 2 
													and tguia.id_fraccion = guia.id_fraccion
													and (right(CONVERT(VARCHAR(10), tguia.fecha_guia, 105), 7)) = (right(CONVERT(VARCHAR(10), guia.fecha_guia, 105), 7))
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
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
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

				(select 1) as 'company'
				,guia.trip_count
		from 
				bonampakdb.dbo.trafico_viaje as viaje
			------------------------------------------------------------------------------------------------------------------------------
			-- hir can join trafico_renglon_guia with a select or left join
			------------------------------------------------------------------------------------------------------------------------------
			left join (
								select 
									trg.id_area,trg.id_fraccion,trg.no_viaje
									,min(trg.id_cliente) as 'id_cliente'
									,min(trg.id_tipo_operacion) as 'id_tipo_operacion'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select(CAST(max(trg.fecha_guia) as DATE)))
																)
														else 
															null
													end
											else
																(
																	(select(CAST(min(trg.fecha_guia) as DATE)))
																)
										end
									) as 'fecha_guia'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then (
																	select top(1) gia.subtotal 
																	from bonampakdb.dbo.trafico_guia as gia 
																	where gia.no_viaje = min(trg.no_viaje)
																		and gia.fecha_guia = max(trg.fecha_guia) 
																		--and gia.status_guia <> 'B' 
																		and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
																		and gia.prestamo <> 'P' and gia.tipo_doc = 2 
																		and gia.id_area = min(trg.id_area ) and gia.id_fraccion = min(trg.id_fraccion)
																) 
														else 
															null
													end
											else
												(sum(trg.subtotal))
										end
									 ) as 'subtotal'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
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
								from bonampakdb.dbo.trafico_guia as trg
								where	
										--trg.status_guia <> 'B'
										trg.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
										and trg.prestamo <> 'P'
										and trg.tipo_doc = 2 
								group by trg.id_area,trg.id_fraccion,trg.no_viaje

			) as guia on guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
			left join
					bonampakdb.dbo.trafico_cliente as cliente
						on cliente.id_cliente = guia.id_cliente
			inner join 
					bonampakdb.dbo.mtto_unidades as manto
						on manto.id_unidad = viaje.id_unidad
		where
					(
						1 = (
						case 
							when @mode = 8
									then 1
								else 0
							end
					    )
					    or 
						    year(viaje.f_despachado) in (select item from sistemas.dbo.fnSplit(@year, '|'))
					 )
				and
					(
						1 = (
						case 
							when @mode = 8
									then 1
								else 0
							end
					    )
					    or 
						    month(viaje.f_despachado) in (select item from sistemas.dbo.fnSplit(@month, '|'))
					 )
				and
					(
						1 = (
						case 
							when @mode != 8
									then 1
								else 0
							end
					    )
					    or 
						   year(viaje.f_despachado) between year(dateadd(year,-1,cast((current_timestamp) as date))) and year(current_timestamp)
					 )

					 
		insert into @cownter
		select
					rail.no_viaje,rail.id_area 
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then 
									case 
										when  CURRENT_TIMESTAMP > min(rail.fecha_guia) and CURRENT_TIMESTAMP >= max(rail.fecha_guia)
											then 
												(
													(select(CAST(min(rail.fecha_guia) as DATE)))
												)
										else 
											null
									end
							else
												(
													(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'fecha_guia'
					,(select datename(mm,min(rail.fecha_guia))) as 'mes'
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then (
										select top(1) gia.subtotal 
										from bonampakdb.dbo.trafico_guia as gia 
										where gia.no_viaje = min(rail.no_viaje)
											and gia.fecha_guia = min(rail.fecha_guia) 
											--and gia.status_guia <> 'B'
											and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
											and gia.prestamo <> 'P' and gia.tipo_doc = 2 
											and gia.id_area = min(rail.id_area ) and gia.id_fraccion = min(rail.id_fraccion)
									) 
								else
												(
													null--(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'subtotal'
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then (
									select sum(rg.peso) from bonampakdb.dbo.trafico_renglon_guia as rg where 
									rg.no_guia in
										(
										select top(1) gia.no_guia
										from bonampakdb.dbo.trafico_guia as gia 
										where gia.no_viaje = min(rail.no_viaje)
											and gia.fecha_guia = min(rail.fecha_guia) 
											--and gia.status_guia <> 'B'
											and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
											and gia.prestamo <> 'P' and gia.tipo_doc = 2 
											and gia.id_area = min(rail.id_area ) and gia.id_fraccion = min(rail.id_fraccion)
										)
									and rg.id_area = min(rail.id_area)

									) 
								else
												(
													null--(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'peso'
					,(
						select 
								tipo_operacion
						from
								bonampakdb.dbo.desp_tipooperacion tpop
						where 
								tpop.id_tipo_operacion = min(rail.id_tipo_operacion)
						) as 'tipo_de_operacion'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								bonampakdb.dbo.general_area as areas
						where 
								areas.id_area = min(rail.id_area)
					) as 'area'

						,(
						select
								desc_producto
						from
							bonampakdb.dbo.trafico_producto as producto
						where      
							producto.id_producto = 0
								and
							producto.id_fraccion = min(rail.id_fraccion)
					) as 'fraccion',
					logs.company as 'company',
					(select '1' ) as 'trip_count'
		from 
				@indicators as logs 
			inner join bonampakdb.dbo.trafico_guia as rail on logs.id_area = rail.id_area and logs.no_viaje = rail.no_viaje 
				--and rail.status_guia <> 'B'
				and rail.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
				and rail.prestamo <> 'P' and rail.tipo_doc = 2 
		where logs.company = '1' and logs.trip_count = 0
		group by rail.no_viaje,rail.id_area,rail.id_fraccion,logs.company
					 
-- union all 

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
				,(select datename(mm,viaje.f_despachado)) as 'mes'
				,viaje.f_despachado
				,cliente.nombre as 'cliente'
				,viaje.kms_viaje
				,viaje.kms_real
				,guia.subtotal
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
													--and tguia.status_guia <> 'B'
													and tguia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|')) 
													and tguia.prestamo <> 'P'
													and tguia.tipo_doc = 2 
													and tguia.id_fraccion = guia.id_fraccion
													and (right(CONVERT(VARCHAR(10), tguia.fecha_guia, 105), 7)) = (right(CONVERT(VARCHAR(10), guia.fecha_guia, 105), 7))
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
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
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

				(select 2) as 'company'
				,guia.trip_count
		from 
				macuspanadb.dbo.trafico_viaje as viaje
			------------------------------------------------------------------------------------------------------------------------------
			-- hir can join trafico_renglon_guia with a select or left join
			------------------------------------------------------------------------------------------------------------------------------
			left join (
								select 
									trg.id_area,trg.id_fraccion,trg.no_viaje
									,min(trg.id_cliente) as 'id_cliente'
									,min(trg.id_tipo_operacion) as 'id_tipo_operacion'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select(CAST(max(trg.fecha_guia) as DATE)))
																)
														else 
															null
													end
											else
																(
																	(select(CAST(min(trg.fecha_guia) as DATE)))
																)
										end
									) as 'fecha_guia'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then (
																	select top(1) gia.subtotal 
																	from macuspanadb.dbo.trafico_guia as gia 
																	where gia.no_viaje = min(trg.no_viaje)
																		and gia.fecha_guia = max(trg.fecha_guia) 
																		--and gia.status_guia <> 'B' 
																		and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
																		and gia.prestamo <> 'P' and gia.tipo_doc = 2 
																		and gia.id_area = min(trg.id_area ) and gia.id_fraccion = min(trg.id_fraccion)
																) 
														else 
															null
													end
											else
												(sum(trg.subtotal))
										end
									 ) as 'subtotal'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
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
								from macuspanadb.dbo.trafico_guia as trg
								where	
										--trg.status_guia <> 'B'
										trg.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
										and trg.prestamo <> 'P'
										and trg.tipo_doc = 2 
								group by trg.id_area,trg.id_fraccion,trg.no_viaje

			) as guia on guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
			left join
					macuspanadb.dbo.trafico_cliente as cliente
						on cliente.id_cliente = guia.id_cliente
			inner join 
					macuspanadb.dbo.mtto_unidades as manto
						on manto.id_unidad = viaje.id_unidad
		where 
					(
						1 = (
						case 
							when @mode = 8
									then 1
								else 0
							end
					    )
					    or 
						    year(viaje.f_despachado) in (select item from sistemas.dbo.fnSplit(@year, '|'))
					 )
				and
					(
						1 = (
						case 
							when @mode = 8
									then 1
								else 0
							end
					    )
					    or 
						    month(viaje.f_despachado) in (select item from sistemas.dbo.fnSplit(@month, '|'))
					 )
				and
					(
						1 = (
						case 
							when @mode != 8
									then 1
								else 0
							end
					    )
					    or 
						   year(viaje.f_despachado) between year(dateadd(year,-1,cast((current_timestamp) as date))) and year(current_timestamp)
					 )
					 
					 
		insert into @cownter
		select
					rail.no_viaje,rail.id_area 
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then 
									case 
										when  CURRENT_TIMESTAMP > min(rail.fecha_guia) and CURRENT_TIMESTAMP >= max(rail.fecha_guia)
											then 
												(
													(select(CAST(min(rail.fecha_guia) as DATE)))
												)
										else 
											null
									end
							else
												(
													(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'fecha_guia'
					,(select datename(mm,min(rail.fecha_guia))) as 'mes'
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then (
										select top(1) gia.subtotal 
										from macuspanadb.dbo.trafico_guia as gia 
										where gia.no_viaje = min(rail.no_viaje)
											and gia.fecha_guia = min(rail.fecha_guia) 
											--and gia.status_guia <> 'B' 
											and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
											and gia.prestamo <> 'P' and gia.tipo_doc = 2 
											and gia.id_area = min(rail.id_area ) and gia.id_fraccion = min(rail.id_fraccion)
									) 
								else
												(
													null--(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'subtotal'
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then (
									select sum(rg.peso) from macuspanadb.dbo.trafico_renglon_guia as rg where 
									rg.no_guia in
										(
										select top(1) gia.no_guia
										from macuspanadb.dbo.trafico_guia as gia 
										where gia.no_viaje = min(rail.no_viaje)
											and gia.fecha_guia = min(rail.fecha_guia) 
											--and gia.status_guia <> 'B' 
											and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
											and gia.prestamo <> 'P' and gia.tipo_doc = 2 
											and gia.id_area = min(rail.id_area ) and gia.id_fraccion = min(rail.id_fraccion)
										)
									and rg.id_area = min(rail.id_area)

									) 
								else
												(
													null--(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'peso'
					,(
						select 
								tipo_operacion
						from
								macuspanadb.dbo.desp_tipooperacion tpop
						where 
								tpop.id_tipo_operacion = min(rail.id_tipo_operacion)
						) as 'tipo_de_operacion'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								macuspanadb.dbo.general_area as areas
						where 
								areas.id_area = min(rail.id_area)
					) as 'area'

						,(
						select
								desc_producto
						from
							macuspanadb.dbo.trafico_producto as producto
						where      
							producto.id_producto = 0
								and
							producto.id_fraccion = min(rail.id_fraccion)
					) as 'fraccion',
					logs.company as 'company',
					(select '1' ) as 'trip_count'
		from 
				@indicators as logs 
			inner join macuspanadb.dbo.trafico_guia as rail on logs.id_area = rail.id_area and logs.no_viaje = rail.no_viaje 
				--and rail.status_guia <> 'B' 
				and rail.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
				and rail.prestamo <> 'P' and rail.tipo_doc = 2 
		where logs.company = '2' and logs.trip_count = 0
		group by rail.no_viaje,rail.id_area,rail.id_fraccion,logs.company
		
		
			
--union all


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
				,(select datename(mm,viaje.f_despachado)) as 'mes'
				,viaje.f_despachado
				,cliente.nombre as 'cliente'
				,viaje.kms_viaje
				,viaje.kms_real
				,guia.subtotal
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
													--and tguia.status_guia <> 'B'
													and tguia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|')) 
													and tguia.prestamo <> 'P'
													and tguia.tipo_doc = 2 
													and tguia.id_fraccion = guia.id_fraccion
													and (right(CONVERT(VARCHAR(10), tguia.fecha_guia, 105), 7)) = (right(CONVERT(VARCHAR(10), guia.fecha_guia, 105), 7))
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
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
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

				(select 3) as 'company'
				,guia.trip_count
		from 
				tespecializadadb.dbo.trafico_viaje as viaje
			------------------------------------------------------------------------------------------------------------------------------
			-- hir can join trafico_renglon_guia with a select or left join
			------------------------------------------------------------------------------------------------------------------------------
			left join (
								select 
									trg.id_area,trg.id_fraccion,trg.no_viaje
									,min(trg.id_cliente) as 'id_cliente'
									,min(trg.id_tipo_operacion) as 'id_tipo_operacion'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then 
																(
																	(select(CAST(max(trg.fecha_guia) as DATE)))
																)
														else 
															null
													end
											else
																(
																	(select(CAST(min(trg.fecha_guia) as DATE)))
																)
										end
									) as 'fecha_guia'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
												then 
													case 
														when  CURRENT_TIMESTAMP > min(trg.fecha_guia) and CURRENT_TIMESTAMP >= max(trg.fecha_guia)
															then (
																	select top(1) gia.subtotal 
																	from tespecializadadb.dbo.trafico_guia as gia 
																	where gia.no_viaje = min(trg.no_viaje)
																		and gia.fecha_guia = max(trg.fecha_guia) 
																		--and gia.status_guia <> 'B' 
																		and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
																		and gia.prestamo <> 'P' and gia.tipo_doc = 2 
																		and gia.id_area = min(trg.id_area ) and gia.id_fraccion = min(trg.id_fraccion)
																) 
														else 
															null
													end
											else
												(sum(trg.subtotal))
										end
									 ) as 'subtotal'
									,(
										case 
											when (select (right(CONVERT(VARCHAR(10), min(trg.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(trg.fecha_guia), 105), 7)))
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
								from tespecializadadb.dbo.trafico_guia as trg
								where	
										--trg.status_guia <> 'B'
										trg.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
										and trg.prestamo <> 'P'
										and trg.tipo_doc = 2 
								group by trg.id_area,trg.id_fraccion,trg.no_viaje

			) as guia on guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
			left join
					tespecializadadb.dbo.trafico_cliente as cliente
						on cliente.id_cliente = guia.id_cliente
			inner join 
					tespecializadadb.dbo.mtto_unidades as manto
						on manto.id_unidad = viaje.id_unidad
		where 
					(
						1 = (
						case 
							when @mode = 8
									then 1
								else 0
							end
					    )
					    or 
						    year(viaje.f_despachado) in (select item from sistemas.dbo.fnSplit(@year, '|'))
					 )
				and
					(
						1 = (
						case 
							when @mode = 8
									then 1
								else 0
							end
					    )
					    or 
						    month(viaje.f_despachado) in (select item from sistemas.dbo.fnSplit(@month, '|'))
					 )
				and
					(
						1 = (
						case 
							when @mode != 8
									then 1
								else 0
							end
					    )
					    or 
						   year(viaje.f_despachado) between year(dateadd(year,-1,cast((current_timestamp) as date))) and year(current_timestamp)
					)

					 
insert into @cownter
		select
					rail.no_viaje,rail.id_area 
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then 
									case 
										when  CURRENT_TIMESTAMP > min(rail.fecha_guia) and CURRENT_TIMESTAMP >= max(rail.fecha_guia)
											then 
												(
													(select(CAST(min(rail.fecha_guia) as DATE)))
												)
										else 
											null
									end
							else
												(
													(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'fecha_guia'
					,(select datename(mm,min(rail.fecha_guia))) as 'mes'
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then (
										select top(1) gia.subtotal 
										from tespecializadadb.dbo.trafico_guia as gia 
										where gia.no_viaje = min(rail.no_viaje)
											and gia.fecha_guia = min(rail.fecha_guia) 
											--and gia.status_guia <> 'B' 
											and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
											and gia.prestamo <> 'P' and gia.tipo_doc = 2 
											and gia.id_area = min(rail.id_area ) and gia.id_fraccion = min(rail.id_fraccion)
									) 
								else
												(
													null--(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'subtotal'
					,(
						case 
							when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
								then (
									select sum(rg.peso) from tespecializadadb.dbo.trafico_renglon_guia as rg where 
									rg.no_guia in
										(
										select top(1) gia.no_guia
										from tespecializadadb.dbo.trafico_guia as gia 
										where gia.no_viaje = min(rail.no_viaje)
											and gia.fecha_guia = min(rail.fecha_guia) 
											--and gia.status_guia <> 'B' 
											and gia.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
											and gia.prestamo <> 'P' and gia.tipo_doc = 2 
											and gia.id_area = min(rail.id_area ) and gia.id_fraccion = min(rail.id_fraccion)
										)
									and rg.id_area = min(rail.id_area)

									) 
								else
												(
													null--(select(CAST(min(rail.fecha_guia) as DATE)))
												)
						end
					) as 'peso'
					,(
						select 
								tipo_operacion
						from
								tespecializadadb.dbo.desp_tipooperacion tpop
						where 
								tpop.id_tipo_operacion = min(rail.id_tipo_operacion)
						) as 'tipo_de_operacion'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								tespecializadadb.dbo.general_area as areas
						where 
								areas.id_area = min(rail.id_area)
					) as 'area'

						,(
						select
								desc_producto
						from
							tespecializadadb.dbo.trafico_producto as producto
						where      
							producto.id_producto = 0
								and
							producto.id_fraccion = min(rail.id_fraccion)
					) as 'fraccion',
					logs.company as 'company',
					(select '1' ) as 'trip_count'
		from 
				@indicators as logs 
			inner join tespecializadadb.dbo.trafico_guia as rail on logs.id_area = rail.id_area and logs.no_viaje = rail.no_viaje 
				--and rail.status_guia <> 'B' 
				and rail.status_guia in (select item from sistemas.dbo.fnSplit(@doc_type, '|'))
				and rail.prestamo <> 'P' and rail.tipo_doc = 2 
		where logs.company = '3' and logs.trip_count = 0
		group by rail.no_viaje,rail.id_area,rail.id_fraccion,logs.company



	select * from @indicators		


