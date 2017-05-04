------------------------------------------------------------------------------------------------------------------------------------------
-- Operations ind Engine build for three databases
------------------------------------------------------------------------------------------------------------------------------------------

USE sistemas;
-- -- go

/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : September 20, 2016
 Description    : Quering the operational data as kms,tons,trips,cash from lis datatables 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/
 
ALTER PROCEDURE [dbo].[spview_xd7e_getFullCompanyOperations]
 (
	@year varchar(8000),		-- year or years ex:'2016|2017'
	@month varchar(8000),		-- month or months ex: '01|02|03|04|05|06|07|08|09|10'
	@Company int,				-- companies id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
	@bunit varchar(8000),      -- bussiness unit
	--@doctype tinyint,			-- document type (1 = Acepted) , (2 = Cancel) , ...
	@mode tinyint,				-- mode 0 = queryAccepted 1 = insert Accepted in period  3 = queryCancelInsert  4 = queryCancelView  5 = insertAcceptedUpt ,8 = automatic_viewmode
	@user_id int,				-- user_id when mode is set to 0 this can be empty ''
	@period_id int				-- projections_closed_period_controls_id when mode is set to 0 this can be empty ''
 )

 -- modes only 
 with encryption
 as 
 	SET NOCOUNT ON
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	
	if @month = '0'
		begin
			set @month = '01|02|03|04|05|06|07|08|09|10|11|12'
		end
-- ====================================== TODO ========================================================
-- build query , that brings , all dispatched trips of month and not acepted in any month counterpart
-- brings all trips and set if have a aceptation , cancelations or only dispatch
-- ====================================== CANCELATIONS ================================================
--status_guia
--A=> Abierta o pendiente
--C=> Confirmada o Transferidas
--T=> Tr�nsito
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


-- declare @year varchar(8000) , @month varchar(8000) , @company varchar(8000) , @bunit varchar(8000)
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


declare @canceled table
						(
							projections_period_id int,
							flota nvarchar(40) collate SQL_Latin1_General_CP1_CI_AS,
							id_flota int,
							id_fraccion int,
							no_viaje int,
							id_area int,
							company int,
							num_guia nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
							no_guia int,
							subtotal decimal(18,6),
							fecha_cancelacion datetime,
							fecha_confirmacion datetime,
							mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
							peso decimal(18,6),
							Area nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
							Tmov char(1) collate SQL_Latin1_General_CP1_CI_AS,
							Cporte  nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
							id_tipo_operacion int
						)


set language spanish

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
			inner join (
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
			inner join
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
						    year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
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
						    month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
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
						    guia.fecha_guia between dateadd(month,-2,cast((current_timestamp) as date)) and dateadd(day,2,cast((current_timestamp) as date))
					 )
--				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
--			and 
--				month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
-----------------------------------------------------------------------------------------------------------------------------------------------------------
			
-----------------------------------------------------------------------------------------------------------------------------------------------------------
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
	
	end
	if (@Company = 3 ) OR (@Company = 0)
	
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
			inner join (
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
			inner join
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
						    year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
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
						    month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
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
						    guia.fecha_guia between dateadd(month,-2,cast((current_timestamp) as date)) and dateadd(day,2,cast((current_timestamp) as date))
					 )
--				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
--			and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Set o
-----------------------------------------------------------------------------------------------------------------------------------------------------------
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

		end

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
			inner join (
								select 
									 trg.id_area
									,trg.id_fraccion
									,trg.no_viaje
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
			inner join
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
						    year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
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
						    month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
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
						    guia.fecha_guia between dateadd(month,-2,cast((current_timestamp) as date)) and dateadd(day,2,cast((current_timestamp) as date))
					 )
--				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
--			and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))

-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Set o
-----------------------------------------------------------------------------------------------------------------------------------------------------------
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

		end
-----------------------------
		insert into @geminus
			select * from @indicators where trip_count = 0

	update src
	set
			src.no_viaje = upt.no_viaje,
			src.id_area = upt.id_area,
			src.fecha_guia = upt.fecha_guia,
			src.mes = upt.mes,
			src.subtotal = upt.subtotal,
			src.peso = upt.peso,
			src.tipo_de_operacion = upt.tipo_de_operacion,
			src.area = upt.area,
			src.fraccion = upt.fraccion,
			src.company = upt.company,
			src.trip_count = upt.trip_count
		from @geminus as src
			inner join @cownter as upt on src.id_area = upt.id_area and src.company = upt.company and src.no_viaje = upt.no_viaje

	insert into @indicators
		select * from @geminus
	
	if( @mode = 0) --means query
		begin
			if ( @bunit is null or @bunit ='' or @bunit = '0')
				begin
					select * from @indicators where mes in (select DateName( month , DateAdd( month , cast(item as int), -1 ) ) from sistemas.dbo.fnSplit(@month, '|'))
				end
			else if ( (@bunit is not null) )
				begin
					select * from @indicators where id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|')) and mes in (select DateName( month , DateAdd( month , cast(item as int), -1 ) ) from sistemas.dbo.fnSplit(@month, '|'))
				end

		end
-- ============================================= Add automatic View ================================ --
	else if(@mode = 8)
		begin
			select * from @indicators
		end		
-- ============================================= Add automatic View ================================ --
	else if (@mode = 1 OR @mode = 5) -- means insert because is a closed period
		begin
			print @mode
			if ( @bunit is null or @bunit ='' or @bunit = '0')
				begin
					if (@mode = 1)
						begin
						print 'inside mode1 => ' + cast(@mode as nvarchar(1))
							insert into sistemas.dbo.projections_closed_period_datas
								select 
										(select @user_id) as 'user_id', --> the user that close the period
										(select @period_id) as 'projections_closed_period_controls_id',
										--------------------------------------------------------------------
										id_area,
										id_unidad,
										id_configuracionviaje,
										id_tipo_operacion,
										id_fraccion,
										id_flota,
										no_viaje,
										fecha_guia,
										mes,
										f_despachado,
										cliente,
										kms_viaje,
										kms_real,
										subtotal,
										peso,
										configuracion_viaje,
										tipo_de_operacion,
										flota,
										area,
										fraccion,
										company,
										trip_count,
										--------------------------------------------------------------------
										(select CURRENT_TIMESTAMP) as 'created',
										(select CURRENT_TIMESTAMP) as 'modified',
										(select '1') as '_status'
								from @indicators where mes in (select DateName( month , DateAdd( month , cast(item as int), -1 ) ) from sistemas.dbo.fnSplit(@month, '|'))
						end
				end
			else if ( (@bunit is not null) )
				begin
					if (@mode = 1)
						begin
							print 'inside mode1 => ' + cast(@mode as nvarchar(1)) + '2nd'
							insert into sistemas.dbo.projections_closed_period_datas
							select 
									(select @user_id) as 'user_id', --> the user that close the period
									(select @period_id) as 'projections_closed_period_controls_id',
									--------------------------------------------------------------------
									id_area,
									id_unidad,
									id_configuracionviaje,
									id_tipo_operacion,
									id_fraccion,
									id_flota,
									no_viaje,
									fecha_guia,
									mes,
									f_despachado,
									cliente,
									kms_viaje,
									kms_real,
									subtotal,
									peso,
									configuracion_viaje,
									tipo_de_operacion,
									flota,
									area,
									fraccion,
									company,
									trip_count,
									--------------------------------------------------------------------
									(select CURRENT_TIMESTAMP) as 'created',
									(select CURRENT_TIMESTAMP) as 'modified',
									(select '1') as '_status'
							from @indicators where id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|')) and mes in (select DateName( month , DateAdd( month , cast(item as int), -1 ) ) from sistemas.dbo.fnSplit(@month, '|'))
						end
				end
		end




