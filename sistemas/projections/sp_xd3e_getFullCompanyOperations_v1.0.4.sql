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
 
ALTER PROCEDURE [dbo].[sp_xd3e_getFullCompanyOperations]
 (
	@year varchar(8000),		-- year or years ex:'2016|2017'
	@month varchar(8000),		-- month or months ex: '01|02|03|04|05|06|07|08|09|10'
	@Company int,				-- companies id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
	@bunit varchar(8000),      -- bussiness unit
	--@doctype tinyint,			-- document type (1 = Acepted) , (2 = Cancel) , ...
	@mode tinyint,				-- mode 0 = queryAccepted 1 = insert Accepted in period  3 = queryCancelInsert  4 = queryCancelView  5 = insertAcceptedUpt
	@user_id int,				-- user_id when mode is set to 0 this can be empty ''
	@period_id int				-- projections_closed_period_controls_id when mode is set to 0 this can be empty ''
 )

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
	if (@mode = 0 or @mode = 1 or @mode = 2 or @mode = 5)
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

--declare @geminusx table (
--								id_area int,
--								id_unidad varchar(10) not null,
--								id_configuracionviaje int,
--								id_tipo_operacion int,
--								id_fraccion int,
--								id_flota int,
--								no_viaje int,
--								fecha_guia varchar(10),
--								mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
--								f_despachado datetime,
--								cliente varchar(60),
--								kms_viaje int,
--								kms_real int,
--								subtotal decimal(18,6),
--								peso decimal(18,6),
--								configuracion_viaje varchar(20),
--								tipo_de_operacion varchar(20),
--								flota varchar(40),
--								area varchar(40),
--								fraccion varchar(60),
--								company int
--								,trip_count tinyint
-- 						  )

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
							Cporte  nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS
						)

--set @year = YEAR(CURRENT_TIMESTAMP)
--set @month = month(CURRENT_TIMESTAMP)
--select @year = '2016'
----select @month = '01|02|03|04|05|06|07|08|09|10'
----select @month = '08|09'
--select @month = '09'
--select @Company = '3'
--select @bunit = ''

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
				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
			and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
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
				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
			and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))
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
				year(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@year, '|'))
			and month(guia.fecha_guia) in (select item from sistemas.dbo.fnSplit(@month, '|'))

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
					else if (@mode = 5)
						begin
							print 'inside mode5 start insert => ' + cast(@mode as nvarchar(1))
							insert into sistemas.dbo.projections_upt_indops
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
							print 'end '
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
					else if (@mode = 5)
						begin
							print 'inside mode5 => ' + cast(@mode as nvarchar(1)) + '2nd'
							insert into sistemas.dbo.projections_upt_indops
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

	else if( @mode = 2) --means query whith all data
		begin
			if ( @bunit is null or @bunit ='' or @bunit = '0')
				begin
					select * from @indicators
				end
			else if ( (@bunit is not null) )
				begin
					select * from @indicators where id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|')) 
				end
		end
	if( @mode = 3 OR @mode = 4) --means insert-query or just-query
		begin
			--truncate table sistemas.dbo.projections_logs

			if ( @bunit is null or @bunit ='' or @bunit = '0')
				begin
					--insert into @geminusx
					--	select * from @indicators where mes in (select DateName( month , DateAdd( month , cast(item as int), -1 ) ) from sistemas.dbo.fnSplit(@month, '|'))

					insert into @canceled
						--======================== BONAMPAK ====================================
							select
								(select @period_id) as 'projections_period_id',
								(
									select 
											nombre
									from 
											bonampakdb.dbo.desp_flotas as flt
									where
											flt.id_flota = matto.id_flota
						
								) as 'flota',
								matto.id_flota as 'id_flota', 
								flete.id_fraccion,
									 flete.no_viaje,flete.id_area,(select 1) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
								(select datename(mm,flete.fecha_cancelacion)) as 'mes',
								(
									select 
											sum(rg.peso)
									from 
											bonampakdb.dbo.trafico_renglon_guia as rg
									where 
											rg.no_guia = flete.no_guia
										and rg.id_area = flete.id_area
								) as 'peso',
								(
									select
											ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
									from 
											bonampakdb.dbo.general_area as areas
									where 
											areas.id_area = flete.id_area
								) as 'Area',
								zpol.Tmov,
								zpol.Cporte
							from 
									bonampakdb.dbo.trafico_guia as flete
							inner join 
										(
											select 
												Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
												CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
												Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
											from 
												integraapp.dbo.zpoling 
											where 
												Cpny = 'bonampakdb'
												and Estatus = 1
												and Tmov = 'C'
											group by Tmov,Tmov,CPorte,Area
										) as zpol on zpol.Cporte = flete.num_guia
							inner join 
									bonampakdb.dbo.mtto_unidades as matto
										on matto.id_unidad = flete.id_unidad
							where 
									flete.status_guia = 'B' 
									--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
									--and year(flete.fecha_cancelacion) = '2016' --
									--and month(flete.fecha_cancelacion) = '08'  --
									and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
									and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and month(flete.fecha_confirmacion) not in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and flete.fecha_confirmacion is not null 
									--and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
									and flete.tipo_doc = 2
				union all --======================== MACUSPANA ====================================
							select
								(select @period_id) as 'projections_period_id',
								(
									select 
											nombre
									from 
											macuspanadb.dbo.desp_flotas as flt
									where
											flt.id_flota = matto.id_flota
						
								) as 'flota',
								matto.id_flota as 'id_flota', 
								flete.id_fraccion,
									 flete.no_viaje,flete.id_area,(select 2) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
								(select datename(mm,flete.fecha_cancelacion)) as 'mes',
								(
									select 
											sum(rg.peso)
									from 
											macuspanadb.dbo.trafico_renglon_guia as rg
									where 
											rg.no_guia = flete.no_guia
										and rg.id_area = flete.id_area
								) as 'peso',
								(
									select
											ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
									from 
											macuspanadb.dbo.general_area as areas
									where 
											areas.id_area = flete.id_area
								) as 'Area',
								zpol.Tmov,
								zpol.Cporte
							from 
									macuspanadb.dbo.trafico_guia as flete
							inner join 
										(
											select 
												Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
												CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
												Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
											from 
												integraapp.dbo.zpoling 
											where 
												Cpny = 'macuspanadb'
												and Estatus = 1
												and Tmov = 'C'
											group by Tmov,Tmov,CPorte,Area
										) as zpol on zpol.Cporte = flete.num_guia
							inner join 
									macuspanadb.dbo.mtto_unidades as matto
										on matto.id_unidad = flete.id_unidad
							where 
									flete.status_guia = 'B' 
									--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
									--and year(flete.fecha_cancelacion) = '2016' --
									--and month(flete.fecha_cancelacion) = '08'  --
									and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
									and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and month(flete.fecha_confirmacion) not in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and flete.fecha_confirmacion is not null 
									--and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
									and flete.tipo_doc = 2
				union all --======================== TEISA ====================================
							select
								(select @period_id) as 'projections_period_id',
								(
									select 
											nombre
									from 
											tespecializadadb.dbo.desp_flotas as flt
									where
											flt.id_flota = matto.id_flota
						
								) as 'flota',
								matto.id_flota as 'id_flota', 
								flete.id_fraccion,
									 flete.no_viaje,flete.id_area,(select 3) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
								(select datename(mm,flete.fecha_cancelacion)) as 'mes',
								(
									select 
											sum(rg.peso)
									from 
											tespecializadadb.dbo.trafico_renglon_guia as rg
									where 
											rg.no_guia = flete.no_guia
										and rg.id_area = flete.id_area
								) as 'peso',
								(
									select
											ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
									from 
											tespecializadadb.dbo.general_area as areas
									where 
											areas.id_area = flete.id_area
								) as 'Area',
								zpol.Tmov,
								zpol.Cporte
							from 
									tespecializadadb.dbo.trafico_guia as flete
							inner join 
										(
											select 
												Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
												CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
												Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
											from 
												integraapp.dbo.zpoling 
											where 
												Cpny = 'tespecializadadb'
												and Estatus = 1
												and Tmov = 'C'
											group by Tmov,Tmov,CPorte,Area
										) as zpol on zpol.Cporte = flete.num_guia
							inner join 
									tespecializadadb.dbo.mtto_unidades as matto
										on matto.id_unidad = flete.id_unidad
							where 
									flete.status_guia = 'B' 
									--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
									--and year(flete.fecha_cancelacion) = '2016' --
									--and month(flete.fecha_cancelacion) = '08'  --
									and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
									and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and month(flete.fecha_confirmacion) not in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and flete.fecha_confirmacion is not null 
									--and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
									and flete.tipo_doc = 2
							
					--===================================
					if @Company = 0
					begin
						if @mode = 3
							begin
--								delete from sistemas.dbo.projections_dissmiss_cancelations 
--									where 
--											year(fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|')) 
--										and 
--											month(fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))

								insert into sistemas.dbo.projections_dissmiss_cancelations
									select * from @canceled
							end
						else if @mode = 4
							begin
								select * from @canceled
							end
					end
					else if @Company <> 0
					begin
						if @mode = 3
							begin
--								delete from sistemas.dbo.projections_dissmiss_cancelations 
--									where company = @Company 
--										and 
--											year(fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|')) 
--										and 
--											month(fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))

								insert into sistemas.dbo.projections_dissmiss_cancelations
									select * from @canceled where company = @Company
							end
						else if @mode = 4
							begin
								select * from @canceled where company = @Company
							end
					end
				end
			else if ( (@bunit is not null) )
				begin
					--insert into @geminusx
					--	select * from @indicators where id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|')) and mes in (select DateName( month , DateAdd( month , cast(item as int), -1 ) ) from sistemas.dbo.fnSplit(@month, '|'))

					insert into @canceled
						--======================== BONAMPAK ====================================
							select
								(select @period_id) as 'projections_period_id',
								(
									select 
											nombre
									from 
											bonampakdb.dbo.desp_flotas as flt
									where
											flt.id_flota = matto.id_flota
						
								) as 'flota',
								matto.id_flota as 'id_flota', 
							    flete.id_fraccion,flete.no_viaje,flete.id_area,(select 1) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
								(select datename(mm,flete.fecha_cancelacion)) as 'mes',
								(
									select 
											sum(rg.peso)
									from 
											bonampakdb.dbo.trafico_renglon_guia as rg
									where 
											rg.no_guia = flete.no_guia
										and rg.id_area = flete.id_area
								) as 'peso',
								(
									select
											ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
									from 
											bonampakdb.dbo.general_area as areas
									where 
											areas.id_area = flete.id_area
								) as 'Area',
								zpol.Tmov,
								zpol.Cporte
							from 
									bonampakdb.dbo.trafico_guia as flete
							inner join 
										(
											select 
												Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
												CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
												Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
											from 
												integraapp.dbo.zpoling 
											where 
												Cpny = 'bonampakdb'
												and Estatus = 1
												and Tmov = 'C'
											group by Tmov,Tmov,CPorte,Area
										) as zpol on zpol.Cporte = flete.num_guia
							inner join 
									bonampakdb.dbo.mtto_unidades as matto
										on matto.id_unidad = flete.id_unidad
							where 
									flete.status_guia = 'B' 
									--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
									--and year(flete.fecha_cancelacion) = '2016' --
									--and month(flete.fecha_cancelacion) = '08'  --
									and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
									and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and month(flete.fecha_confirmacion) not in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and flete.fecha_confirmacion is not null 
									and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
									and flete.tipo_doc = 2
				union all --======================== MACUSPANA ====================================
							select
							    (select @period_id) as 'projections_period_id',
								(
									select 
											nombre
									from 
											macuspanadb.dbo.desp_flotas as flt
									where
											flt.id_flota = matto.id_flota
						
								) as 'flota',
								matto.id_flota as 'id_flota', 
								flete.id_fraccion,
									 flete.no_viaje,flete.id_area,(select 2) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
								(select datename(mm,flete.fecha_cancelacion)) as 'mes',
								(
									select 
											sum(rg.peso)
									from 
											macuspanadb.dbo.trafico_renglon_guia as rg
									where 
											rg.no_guia = flete.no_guia
										and rg.id_area = flete.id_area
								) as 'peso',
								(
									select
											ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
									from 
											macuspanadb.dbo.general_area as areas
									where 
											areas.id_area = flete.id_area
								) as 'Area',
								zpol.Tmov,
								zpol.Cporte
							from 
									macuspanadb.dbo.trafico_guia as flete
							inner join 
										(
											select 
												Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
												CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
												Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
											from 
												integraapp.dbo.zpoling 
											where 
												Cpny = 'macuspanadb'
												and Estatus = 1
												and Tmov = 'C'
											group by Tmov,Tmov,CPorte,Area
										) as zpol on zpol.Cporte = flete.num_guia
							inner join 
									macuspanadb.dbo.mtto_unidades as matto
										on matto.id_unidad = flete.id_unidad
							where 
									flete.status_guia = 'B' 
									--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
									--and year(flete.fecha_cancelacion) = '2016' --
									--and month(flete.fecha_cancelacion) = '08'  --
									and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
									and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and month(flete.fecha_confirmacion) not in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and flete.fecha_confirmacion is not null 
									and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
									and flete.tipo_doc = 2
				union all -- ======================== TEISA ====================================
							select
							    (select @period_id) as 'projections_period_id',
								(
									select 
											nombre
									from 
											tespecializadadb.dbo.desp_flotas as flt
									where
											flt.id_flota = matto.id_flota
						
								) as 'flota',
								matto.id_flota as 'id_flota', 
								flete.id_fraccion,
									 flete.no_viaje,flete.id_area,(select 3) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
								(select datename(mm,flete.fecha_cancelacion)) as 'mes',
								(
									select 
											sum(rg.peso)
									from 
											tespecializadadb.dbo.trafico_renglon_guia as rg
									where 
											rg.no_guia = flete.no_guia
										and rg.id_area = flete.id_area
								) as 'peso',
								(
									select
											ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
									from 
											tespecializadadb.dbo.general_area as areas
									where 
											areas.id_area = flete.id_area
								) as 'Area',
								zpol.Tmov,
								zpol.Cporte
							from 
									tespecializadadb.dbo.trafico_guia as flete
							inner join 
										(
											select 
												Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
												CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
												Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
											from 
												integraapp.dbo.zpoling 
											where 
												Cpny = 'tespecializadadb'
												and Estatus = 1
												and Tmov = 'C'
											group by Tmov,Tmov,CPorte,Area
										) as zpol on zpol.Cporte = flete.num_guia
							inner join 
									tespecializadadb.dbo.mtto_unidades as matto
										on matto.id_unidad = flete.id_unidad
							where 
									flete.status_guia = 'B' 
									--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
									--and year(flete.fecha_cancelacion) = '2016' --
									--and month(flete.fecha_cancelacion) = '08'  --
									and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
									and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and month(flete.fecha_confirmacion) not in (select item from sistemas.dbo.fnSplit(@month, '|'))
									and flete.fecha_confirmacion is not null 
									and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
									and flete.tipo_doc = 2
							
					--===================================
					if @Company = 0
					begin 
						if @mode = 3
							begin
--								delete from sistemas.dbo.projections_dissmiss_cancelations 
--									where 
--											year(fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|')) 
--										and 
--											month(fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))

								insert into sistemas.dbo.projections_dissmiss_cancelations
									select * from @canceled
							end
						else if @mode = 4
							begin
								select * from @canceled
							end
					end
					else if @Company <> 0
					begin
						if @mode = 3
							begin
--								delete from sistemas.dbo.projections_dissmiss_cancelations 
--									where company = @Company 
--										and 
--											year(fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|')) 
--										and 
--											month(fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
								insert into sistemas.dbo.projections_dissmiss_cancelations
									select * from @canceled where company = @Company
							end
						else if @mode = 4
							begin
								select * from @canceled where company = @Company
							end

					end
				end

		end
-- go

--usage
--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations 
--													'2016',	-- year or years (char) ex:'2016|2017' 
--													'09',	-- month or months (char) ex: '01|02|03|04|05|06|07|08|09|10'
--													 0,		-- companies (int) id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
--													'0',	-- bussiness unit (char) like 1 for orizaba or cuatitlan and 3 for ramos whats is true for tbk but not case of teisa or atm
--													 0,		-- mode 0 = query 1 = insert period
--													 1,		-- user_id when mode is set to 0 this can be empty ''
--													 1      -- projections_closed_period_controls_id when mode is set to 0 this can be empty ''




--declare @geminus_cow table (
--								id_area int,
--								id_unidad varchar(10) not null,
--								id_configuracionviaje int,
--								id_tipo_operacion int,
--								id_fraccion int,
--								id_flota int,
--								no_viaje int,
--								fecha_guia varchar(10),
--								mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
--								f_despachado datetime,
--								cliente varchar(60),
--								kms_viaje int,
--								kms_real int,
--								subtotal decimal(18,6),
--								peso decimal(18,6),
--								configuracion_viaje varchar(20),
--								tipo_de_operacion varchar(20),
--								flota varchar(40),
--								area varchar(40),
--								fraccion varchar(60),
--								company int
--								,trip_count tinyint
-- 						  )
--declare @cow table (
--								no_viaje int,
--								id_area int,
--								fecha_guia varchar(10),
--								mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
--								subtotal decimal(18,6),
--								peso decimal(18,6),
--								tipo_de_operacion varchar(20),
--								area varchar(40),
--								fraccion varchar(60),
--								company int
--								,trip_count tinyint
-- 						  )

--insert into @geminus_cow 
--	select * from sistemas.dbo.projections_logs

--insert into @cow
--	select
--			 rail.no_viaje,rail.id_area 
--				,(
--					case 
--						when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
--							then 
--								case 
--									when  CURRENT_TIMESTAMP > min(rail.fecha_guia) and CURRENT_TIMESTAMP >= max(rail.fecha_guia)
--										then 
--											(
--												(select(CAST(min(rail.fecha_guia) as DATE)))
--											)
--									else 
--										null
--								end
--						else
--											(
--												(select(CAST(min(rail.fecha_guia) as DATE)))
--											)
--					end
--				) as 'fecha_guia'
--				,(select datename(mm,min(rail.fecha_guia))) as 'mes'
--				,(
--					case 
--						when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
--							then (
--									select top(1) gia.subtotal 
--									from trafico_guia as gia 
--									where gia.no_viaje = min(rail.no_viaje)
--										and gia.fecha_guia = min(rail.fecha_guia) 
--										and gia.status_guia <> 'B' and gia.prestamo <> 'P' and gia.tipo_doc = 2 
--										and gia.id_area = min(rail.id_area ) and gia.id_fraccion = min(rail.id_fraccion)
--								) 
--							else
--											(
--												null--(select(CAST(min(rail.fecha_guia) as DATE)))
--											)
--					end
--				) as 'subtotal'
--				,(
--					case 
--						when (select (right(CONVERT(VARCHAR(10), min(rail.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(rail.fecha_guia), 105), 7)))
--							then (
--								select sum(rg.peso) from trafico_renglon_guia as rg where 
--								rg.no_guia in
--									(
--									select top(1) gia.no_guia
--									from trafico_guia as gia 
--									where gia.no_viaje = min(rail.no_viaje)
--										and gia.fecha_guia = min(rail.fecha_guia) 
--										and gia.status_guia <> 'B' and gia.prestamo <> 'P' and gia.tipo_doc = 2 
--										and gia.id_area = min(rail.id_area ) and gia.id_fraccion = min(rail.id_fraccion)
--									)
--								and rg.id_area = min(rail.id_area)

--								) 
--							else
--											(
--												null--(select(CAST(min(rail.fecha_guia) as DATE)))
--											)
--					end
--				) as 'peso'
--				,(
--					select 
--							tipo_operacion
--					from
--							desp_tipooperacion tpop
--					where 
--							tpop.id_tipo_operacion = min(rail.id_tipo_operacion)
--					) as 'tipo_de_operacion'
--				,(
--					select
--							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
--					from 
--							general_area as areas
--					where 
--							areas.id_area = min(rail.id_area)
--				) as 'area'

--					,(
--					select
--							desc_producto
--					from
--						trafico_producto as producto
--					where      
--						producto.id_producto = 0
--							and
--						producto.id_fraccion = min(rail.id_fraccion)
--				) as 'fraccion',
--				logs.company as 'company',
--				(select '1' ) as 'trip_count'
--	from 
--			sistemas.dbo.projections_logs as logs 
--		inner join trafico_guia as rail on logs.id_area = rail.id_area and logs.no_viaje = rail.no_viaje and rail.status_guia <> 'B' and rail.prestamo <> 'P' and rail.tipo_doc = 2 
--	where logs.company = '1' 
--	group by rail.no_viaje,rail.id_area,rail.id_fraccion,logs.company


--select * from @geminus_cow

--	update src
--	set
--			src.no_viaje = upt.no_viaje,
--			src.id_area = upt.id_area,
--			src.fecha_guia = upt.fecha_guia,
--			src.mes = upt.mes,
--			src.subtotal = upt.subtotal,
--			src.peso = upt.peso,
--			src.tipo_de_operacion = upt.tipo_de_operacion,
--			src.area = upt.area,
--			src.fraccion = upt.fraccion,
--			src.company = upt.company,
--			src.trip_count = upt.trip_count
--		from @geminus_cow as src
--			inner join @cow as upt on src.id_area = upt.id_area and src.company = upt.company and src.no_viaje = upt.no_viaje

--select * from @geminus_cow
---- go
























--declare @trip as int set @trip = 21349

--select id_area,subtotal,no_guia,
--		*
--from trafico_guia where no_viaje = @trip and status_guia <> 'B' and prestamo <> 'P' and tipo_doc = 2 
--	 and id_area = (select id_area from sistemas.dbo.projections_logs as logs where no_viaje = @trip)





--					select rg.peso,* from trafico_renglon_guia as rg where 
--							rg.no_guia in (
--												select tguia.no_guia 
--												from  trafico_guia as tguia 
--												where tguia.no_viaje = (select no_viaje from sistemas.dbo.projections_logs as logs where no_viaje = @trip)
--													and tguia.status_guia <> 'B' 
--													and tguia.prestamo <> 'P'
--													and tguia.tipo_doc = 2 
--												)
--						and id_area = (select id_area from sistemas.dbo.projections_logs as logs where no_viaje = @trip)

---- go

----SELECT * 
----FROM Account 
----WHERE (type <>100000002 ? Id='something': Id=null)
----For SQLSERVER-2012.but IIF is not working in SQLSERVER-2008 or less version.

---- SELECT * 
----    FROM Account 
----    WHERE 
----    Id=IIF(type<> 100000002,"something",null )

----If you use SQLSERVER-2008 or less version. Please try this.Sorry buddy no better way for you.

----  SELECT * 
----    FROM Account 
----    WHERE (Id= CASE WHEN type <>100000002 THEN 'something'  ELSE null END)

----select * from sistemas.dbo.casetas_units
----		where (casetas_units_name = case when casetas_corporations_id <> 1 then 'ATMMAC' else null end ) and user_id = '1' and _status = 0




----select convert(datetime , '11-03-2016',103)
----select datename(mm,(select convert(datetime , '11-03-2016',103)))


---- search for 24093 tbk
---- viaje teisa 106202


----SELECT @SomeValue = SomeValue FROM SomeTable

----IF @SomeValue IS NULL
----    INSERT INTO OtherTable VALUES (1, 2, 3)
----    SELECT NewlyInsertedValue FROM OtherTable
----ELSE
----    INSERT INTO OtherTable VALUES (1, 2, 3)
----    SELECT SomeOtherValue FROM WeirdTable
----END IF



--use bonampakdb
----use tespecializadadb
--declare @tmp_table table
--					(
--						subtotal decimal(8,2)
--					)




--declare @viaje as int, @fecha as datetime
--set @viaje = 48007 --95153
--set @fecha = CURRENT_TIMESTAMP
----set @fecha = '2016-10-07 09:25:21.703'
----set @fecha = '2016-04-22 16:11:29.000'


--					select 
--							rg.peso,*
--					from 
--							trafico_renglon_guia as rg
--					where 
--							rg.no_guia in (
--												select 
--														tguia.no_guia 
--												from 
--														trafico_guia as tguia 
--												where 
--														tguia.no_viaje = @viaje
--													and tguia.status_guia <> 'B' 
--													and tguia.prestamo <> 'P'
--													and tguia.tipo_doc = 2 
													
--												)
						



--select id_area,subtotal,no_guia,fecha_guia,no_viaje,id_fraccion,fecha_modifico,fecha_confirmacion from trafico_guia where no_viaje = @viaje and status_guia <> 'B' and prestamo <> 'P' and tipo_doc = 2 


--select 
----		no_guia, kms, ingresos, tonelajes , trips
--		guia.id_area,guia.id_fraccion,
--		(select (right(CONVERT(VARCHAR(10), guia.fecha_guia, 105), 7)))as 'date_guia',
--		(
--			case 
--				--when min(guia.fecha_guia) <> max(guia.fecha_guia)
--				--when min(CAST(guia.fecha_guia as DATE)) <> max(CAST(guia.fecha_guia as DATE))
--				when (select (right(CONVERT(VARCHAR(10), min(guia.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(guia.fecha_guia), 105), 7)))
--					then 
--						case 
--							when  @fecha > min(guia.fecha_guia) and @fecha >= max(guia.fecha_guia)
--								then 
--									(
--										(select max(guia.fecha_guia))
--									)
--							else 
--								null
--						end
--				else
--									(
--										(select min(guia.fecha_guia))
--									)
--			end
--		) as 'fecha_guia',
--		-- Case Ingresos
--		(
--			case 
--				--when min(guia.fecha_guia) <> max(guia.fecha_guia)
--				--when min(CAST(guia.fecha_guia as DATE)) <> max(CAST(guia.fecha_guia as DATE))
--				when (select (right(CONVERT(VARCHAR(10), min(guia.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(guia.fecha_guia), 105), 7)))
--					then 
--						case 
--							when  @fecha > min(guia.fecha_guia) and @fecha >= max(guia.fecha_guia)
--								then (
--										select gia.subtotal 
--										from trafico_guia gia 
--										where gia.no_viaje = @viaje 
--											and gia.fecha_guia = max(guia.fecha_guia) 
--											and gia.status_guia <> 'B' and gia.prestamo <> 'P' and gia.tipo_doc = 2 
--									) 
--								--then (select '0')
--							else 
--								null
--						end
--				else
--					(sum(guia.subtotal))
--			end
--		) as 'Ingresos',

--		--- Case Tons 
--		(
--			case 
--				--when min(guia.fecha_guia) <> max(guia.fecha_guia)
--				--when min(CAST(guia.fecha_guia as DATE)) <> max(CAST(guia.fecha_guia as DATE))
--				when (select (right(CONVERT(VARCHAR(10), min(guia.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(guia.fecha_guia), 105), 7)))
--					then 
--						-- translate
--						case 
--							when  @fecha > min(guia.fecha_guia) and @fecha >= max(guia.fecha_guia)
--								then 
--									(
--										select 
--												sum(rg.peso)
--										from 
--												trafico_renglon_guia as rg
--										where 
--												rg.no_guia in (
--																	select 
--																			tguia.no_guia 
--																	from 
--																			trafico_guia as tguia 
--																	where 
--																			tguia.no_viaje = @viaje
--																		and tguia.status_guia <> 'B' 
--																		and tguia.prestamo <> 'P'
--																		and tguia.tipo_doc = 2 
--																		and tguia.fecha_guia = max(guia.fecha_guia)
													
--																	)
--									) 
							
--							else 
--								null
--						end




--				else
--									(
--										select 
--												sum(rg.peso)
--										from 
--												trafico_renglon_guia as rg
--										where 
--												rg.no_guia in (
--																	select 
--																			tguia.no_guia 
--																	from 
--																			trafico_guia as tguia 
--																	where 
--																			tguia.no_viaje = @viaje
--																		and tguia.status_guia <> 'B' 
--																		and tguia.prestamo <> 'P'
--																		and tguia.tipo_doc = 2 
--																	)
--									) 
--			end
--		) as 'Weight',
--		guia.no_viaje,

--		(
--			case 
--				--when min(guia.fecha_guia) <> max(guia.fecha_guia)
--				--when min(CAST(guia.fecha_guia as DATE)) <> max(CAST(guia.fecha_guia as DATE))
--				when (select (right(CONVERT(VARCHAR(10), min(guia.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(guia.fecha_guia), 105), 7)))
--					then (select max(guia.fecha_guia) as 'date')
--					else (select guia.fecha_guia as 'date')
--				end
--		) as 'case',

--		(
--			case 
--				--when min(guia.fecha_guia) <> max(guia.fecha_guia)
--				--when min(CAST(guia.fecha_guia as DATE)) <> max(CAST(guia.fecha_guia as DATE))
--				when (select (right(CONVERT(VARCHAR(10), min(guia.fecha_guia), 105), 7))) <> (select (right(CONVERT(VARCHAR(10), max(guia.fecha_guia), 105), 7)))
--					then 
--						case 
--							when ((right(CONVERT(VARCHAR(10), guia.fecha_guia, 105), 7)) = (right(CONVERT(VARCHAR(10), min(guia.fecha_guia), 105), 7)))
--								then
--									(
--										--select '1'
--										(right(CONVERT(VARCHAR(10), guia.fecha_guia, 105), 7))
--									)
--							when ((right(CONVERT(VARCHAR(10), guia.fecha_guia, 105), 7)) = (right(CONVERT(VARCHAR(10), max(guia.fecha_guia), 105), 7)))
--								then
--									(
--										--select '0'
--										(right(CONVERT(VARCHAR(10), guia.fecha_guia, 105), 7))
--									)
--						else 
--								null
--						end
--				else
--									(
--										select 'aa'
--									)
--			end
--		) as 'trip_count'
--from
--		trafico_guia guia
--where guia.no_viaje = @viaje and guia.status_guia <> 'B' and guia.prestamo <> 'P' and guia.tipo_doc = 2 
--group by guia.no_viaje , guia.fecha_guia, guia.id_area,guia.id_fraccion
--select * from @tmp_table
---- go



--SELECT CAST(u.created as DATE) as 'date',*
--FROM sistemas.dbo.providers_imported_files_controls u
--WHERE CAST(u.created as DATE) = '2016-10-19'


-- select right(CONVERT(VARCHAR(10), current_timestamp, 105), 7) 


--select kms_viaje,f_despachado,* from tespecializadadb.dbo.trafico_viaje where no_viaje = @viaje

--select no_guia,subtotal,no_viaje,* from tespecializadadb.dbo.trafico_guia where no_viaje = 95153 and status_guia <> 'B' and prestamo <> 'P' and tipo_doc = 2 

--select peso,* from tespecializadadb.dbo.trafico_renglon_guia where no_guia in (select no_guia from tespecializadadb.dbo.trafico_guia where no_viaje = @viaje
--																				and status_guia <> 'B'
--																				and prestamo <> 'P'
--																				and tipo_doc = 2 
--																			   )


---- declare @viaje as int
--set @viaje = 24093

--select kms_viaje,f_despachado,* from bonampakdb.dbo.trafico_viaje where no_viaje = @viaje and id_area = '1'

--select no_guia,subtotal,no_viaje,id_tipo_operacion,* from bonampakdb.dbo.trafico_guia where no_viaje = @viaje and status_guia <> 'B' and prestamo <> 'P' and tipo_doc = 2  and id_area = '1'

--select peso,* from bonampakdb.dbo.trafico_renglon_guia where no_guia in (select no_guia from bonampakdb.dbo.trafico_guia where no_viaje = @viaje
--																				and status_guia <> 'B'
--																				and prestamo <> 'P'
--																				and tipo_doc = 2 
--																				and id_area = '1'
--																			   )
--																	and id_area = '1'
																	







--select subtotal,no_viaje,* from tespecializadadb.dbo.trafico_guia 
--				where year(fecha_guia) = '2016' and month(fecha_guia) = '09' and id_area = '1' and id_fraccion = '1'
--										and status_guia <> 'B'
--										and prestamo <> 'P'
--										and tipo_doc = 2 


--select
--			id_area,id_fraccion,no_viaje
--			--,status_guia,prestamo,tipo_doc
--			,id_cliente,id_tipo_operacion
--			--,num_guia
--			--,no_guia
--			,min(fecha_guia)
--			,sum(subtotal)
--		from tespecializadadb.dbo.trafico_guia where no_viaje = '106202'
--										and status_guia <> 'B'
--										and prestamo <> 'P'
--										and tipo_doc = 2 
--		group by id_area,id_fraccion,no_viaje,id_cliente,id_tipo_operacion--,no_guia
--				--,status_guia,prestamo,tipo_doc

--select 
--			sum(subtotal) as 'total'
--			--,min(year(fecha_guia))
--			--,min(month(fecha_guia))
--			--,min(day(fecha_guia))
--			,(select ( right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) + '-' + right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) + '-' + CONVERT(nvarchar(4), min(YEAR(fecha_guia))) )) as 'date'
--			, right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) as dy
--			,right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) as mt
--			,CONVERT(nvarchar(4), min(YEAR(fecha_guia))) as yr
--			,no_viaje
--			,tipo_doc 

--		from tespecializadadb.dbo.trafico_guia 
--		where no_viaje = '106202'
--										and status_guia <> 'B'
--										and prestamo <> 'P'
--										and tipo_doc = 2 
--		group by year(fecha_guia),month(fecha_guia),no_viaje,tipo_doc


--set language spanish
--select 
--		sum(subtotal) as 'total'
--		--,(select( right('00'+convert(varchar(2),min(DAY(fecha_guia))), 2) +'-'+ right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) + '-' + CONVERT(nvarchar(4), min(YEAR(fecha_guia))))) as 'fecha_guia'
--		,(select( right('00'+convert(varchar(2),min(MONTH(fecha_guia))), 2) + '-' + CONVERT(nvarchar(4), min(YEAR(fecha_guia))))) as 'fecha_guia'
--		,(select datename(mm,fecha_guia)) as 'mes'
--		,no_viaje
--		,tipo_doc 
--						from tespecializadadb.dbo.trafico_guia 
--						where no_viaje = '106066'
--										and status_guia <> 'B'
--										and prestamo <> 'P'
--										and tipo_doc = 2 
--						group by year(fecha_guia),month(fecha_guia),no_viaje,tipo_doc,day(fecha_guia)



