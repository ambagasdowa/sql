------------------------------------------------------------------------------------------------------------------------------------------
-- Operations ind Engine build for three databases
------------------------------------------------------------------------------------------------------------------------------------------

USE sistemas;
-- go

/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : September 20, 2016
 Description    : Quering the operational data by month as kms,tons,trips,cash from lis datatables 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/
 
ALTER PROCEDURE [dbo].[sp_xd4e_fullByMonthCompanyOperations] 
															(
																@cyear nvarchar(4),
																@cmonth nvarchar(2),
																@date_mode int,
																@query_mode int
															)

 with encryption
 as 

 	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	SET NOCOUNT ON
-- temporal
--	declare @mode as int  set @mode = 0
---- ==================================================================================================================================================
----															declare variables
---- ==================================================================================================================================================
	
declare @tstamp as decimal(18,6)  set @tstamp = (select cast((current_timestamp) as decimal(18,6)))
--print @tstamp
declare @periods as nvarchar(4000) set @periods = '01|02|03|04|05|06|07|08|09|10|11|12'
declare @period nvarchar(4000)
declare @current_month as nvarchar(2)
declare @current_year as nvarchar(4)
declare @closedYear as nvarchar(4) , @closedMonth as nvarchar(2)
---- ==================================================================================================================================================
----															debug mode
---- ==================================================================================================================================================

declare @debug as int 
set @debug = 1 -- set debug on

--// incoming vars
if @date_mode = 1 -- means auto
	begin
		set @current_month = month(CURRENT_TIMESTAMP)
		set @current_year = year(CURRENT_TIMESTAMP)
	end 
else if @date_mode = 0 -- means manual
	begin
		set @current_month = @cmonth
		set @current_year = @cyear
	end 
--select @closedYear = '2015' , @closedMonth = '11'

-- vars for last closed period
	declare @master_projections_corporations_id int,@master_id_area int,@master_name nvarchar(200),@master_projections_closed_periods date

-- var for master quan query
	declare 				
			@qry_projections_closed_periods date,
			@qry_cyear nvarchar(4),
			@qry_period nvarchar(4000),
			@qry_projections_corporations_id int,
			@qry_id_area nvarchar(1) 

---- ==================================================================================================================================================
----															declare tables
---- ==================================================================================================================================================

-- -------------------------------------------------------------------------------
declare @tbNextDate table (
							projections_closed_periods date,
							cyear nvarchar(4),
							period nvarchar(4000),
							projections_corporations_id int,
							id_area int
						  )

-- ------------------------------------------------------------------------------- 
declare @tbyear table 
					(
						cyear nvarchar(4)
					)
insert into @tbyear
	select item from sistemas.dbo.fnSplit(@current_year,'|')
-- watch the data
--if @debug = 1
--	begin
--		select * from @tbyear
--	end
-- -------------------------------------------------------------------------------
declare @periodtl table 
						(
							period nvarchar(10)	
						)
insert into @periodtl
	select item from sistemas.dbo.fnSplit(@periods, '|')
-- watch period	
if @debug = 1
	begin
		select * from @periodtl
 	end
 	
exec sp_projections_log_lv9 'End of definition'
-- -------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------

---- ==================================================================================================================================================
----													start the cursor
---- ==================================================================================================================================================
	
exec sp_projections_log_lv9 'start the cursor'

	declare closed_period_cursor cursor for
							
						select 
								projections_corporations_id,id_area,name,projections_closed_periods 
						from 
								sistemas.dbo.projections_view_closed_period_units 
						order by 
								projections_closed_periods
								
	open closed_period_cursor
  
		fetch next from closed_period_cursor
		into @master_projections_corporations_id, @master_id_area, @master_name, @master_projections_closed_periods
  
		while @@FETCH_STATUS = 0  
		begin
			--select @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area
			--print 'insert'
			--select @master_projections_corporations_id, @master_id_area, @master_name, @master_projections_closed_periods
			--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations @query_cursor
			-- ===============================================================================================================
			--	  									   start the fecthing
			-- ===============================================================================================================
				exec sp_projections_log_lv9 'start stack Query'
					if (
							cast(@current_month as int) <>  1 --AND cast(@current_month as int) <>  12
					   )
						begin

						if @debug = 1
							begin
								exec sp_projections_log_lv9 'distinc of jan'
							end
							
							--SET LANGUAGE spanish  
							--SET DATEFORMAT ymd

						--print 'diff 1 => current month ' + @current_month + ' and CurrentYear => ' + @current_year + ' date from closedPeriods => ' + cast(@master_projections_closed_periods as nvarchar(10))
						--print 'period from view => ' + right('00'+convert(varchar(2),MONTH(dateadd(month,1,@master_projections_closed_periods))), 2) + ' and cpny ' + @master_name 
						--print 'current => ' + cast((right( CONVERT(VARCHAR(10), ( cast((@current_year + '-' + @current_month + '-' + '01') as date) ), 105), 7)) as nvarchar(10)) 
						--	+ ' master => ' + cast((right( CONVERT(VARCHAR(10), ( cast(@master_projections_closed_periods as date)), 105), 7)) as nvarchar(10))
						exec sp_projections_log_lv9 'master_projections_closed_periods'
						exec sp_projections_log_lv9 @master_projections_closed_periods	

						if DATEDIFF ( mm , @master_projections_closed_periods , (@current_year + '-' + @current_month + '-' + '01') ) = 0
							begin
								--print 'area as closed for now => ' + @master_name  + ' ' + cast( (dateadd(month,1,@master_projections_closed_periods)) as nvarchar(12))
								exec sp_projections_log_lv9 'months are same'
								
								declare @newDate as date  set @newDate = (dateadd(month,1,@master_projections_closed_periods))
								insert into @tbNextDate

									select
										@master_projections_closed_periods as projections_closed_periods,
										year(@newDate) as 'cyear',
										month(@newDate) as 'period',
										@master_projections_corporations_id as 'projections_corporations_id',
										@master_id_area as 'id_area'
							end
						else
							begin
								--print ' master isdate => ' + isdate(@master_projections_closed_periods)  + ' current isdate => ' + isdate(cast((@current_year + '-' + @current_month + '-' + '01') as date))
								--print DATEDIFF ( mm , @master_projections_closed_periods , (@current_year + '-' + @current_month + '-' + '01') ) 
								exec sp_projections_log_lv9 'are diff <> 1 : just valid if the offset is one month'
								select @master_projections_closed_periods = dateadd(month,1,@master_projections_closed_periods)
								exec sp_projections_log_lv9 @master_projections_closed_periods	
								
								if @debug = 1 
									begin
										exec sp_projections_log_lv9 'months are diff'
									end
								insert into @tbNextDate

									select
										@master_projections_closed_periods as projections_closed_periods,
										year(@master_projections_closed_periods) as 'cyear',
										(select left(	 
											(
												select period + '|' as 'data()' 
												from @periodtl 
												where period between (select right('00'+convert(varchar(2),MONTH(@master_projections_closed_periods)), 2)) and @current_month
												for xml path('')
											), 
										len(
											(
												select period + '|' as 'data()' 
												from @periodtl 
												where period between (select right('00'+convert(varchar(2),MONTH(@master_projections_closed_periods)), 2)) and @current_month
												for xml path('')
											)
										)-1)
										) as 'period',
										@master_projections_corporations_id as 'projections_corporations_id',
										@master_id_area as 'id_area'
							end 
					--	select * from @tbyear as tbyear
					--		inner join 
					--(

						end
					--) as query on query.cyear = tbyear.cyear

					--print cast((right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7)) as nvarchar(10))
					--print cast(( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ) as nvarchar(20))

					-- ====================================================================================================================================================================================

					if (
						cast(@current_month as int) =  1 --OR cast(@current_month as int) =  12
					   )
						begin
							--(select right('00'+convert(varchar(2),MONTH(dateadd(month,1,cl.projections_closed_periods))), 2))
							if @debug = 1
								begin
									print 'IN 1 current month is 1 '
									select @master_projections_corporations_id, @master_id_area, @master_name, @master_projections_closed_periods
								end
							--print 'IN 1 => current month ' + @current_month + ' and CurrentYear => ' + @current_year + ' date from closedPeriods => ' + cast(@master_projections_closed_periods as nvarchar(10))
							--print 'period from view => ' + right('00'+convert(varchar(2),MONTH(dateadd(month,1,@master_projections_closed_periods))), 2) + ' and cpny ' + @master_name 

							--print 'current => ' + cast((right( CONVERT(VARCHAR(10), ( cast((@current_year + '-' + @current_month + '-' + '01') as date) ), 105), 7)) as nvarchar(10)) 
							--	+ ' master => ' + cast((right( CONVERT(VARCHAR(10), ( cast(@master_projections_closed_periods as date)), 105), 7)) as nvarchar(10))

							declare @nextDate as nvarchar(10)
							set @nextDate = (select ( right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7) ) )

							declare @nextYear as nvarchar(4)
							set @nextYear = substring(@nextDate,4,4)


							insert into @tbNextDate
							select 
								@master_projections_closed_periods as 'projections_closed_periods',
								--year(cl.projections_closed_periods) as 'cyear',
								case
									when year(@master_projections_closed_periods) <> @current_year
										then
											(select @current_year)
									else
										year(@master_projections_closed_periods)
								end as 'cyear',
								case
									when month(@master_projections_closed_periods) <> @current_month --and @current_month = '01'
										then
											(select @current_month)
									else
										-- case when close jan 
										null
								end as 'period',
								 @master_projections_corporations_id as 'projections_corporations_id',@master_id_area as 'id_area'
							--from sistemas.dbo.projections_view_closed_period_units as cl
							--union all

							if substring(@nextDate,4,4) <> @current_year
								begin
									insert into @tbNextDate
									select 
										@master_projections_closed_periods as 'projections_closed_periods',
										(select	substring(@nextDate,4,4)) as 'cyear',
										case
											when (month(@master_projections_closed_periods) = 12 )
												then
													null
												else
													(select '12')
										end as 'period',
										@master_projections_corporations_id as 'projections_corporations_id',@master_id_area as 'id_area'
									--from sistemas.dbo.projections_view_closed_period_units as cl
								end
					--print cast((right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7)) as nvarchar(10))
					--print cast(( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ) as nvarchar(20))
						end

			-- ===============================================================================================================
			--	  									   end the fecthing closed periods
			-- ===============================================================================================================
			fetch next from closed_period_cursor
			into @master_projections_corporations_id, @master_id_area, @master_name, @master_projections_closed_periods
		end  
	close closed_period_cursor  
	deallocate closed_period_cursor  

	--// debuging
	if @debug = 1
	exec sp_projections_log_lv9 'the table of periods is created @tbNext'
	begin
		select * from @tbNextDate where period is not null
 	end

---- ==================================================================================================================================================
----													declare a tmp table for fetch all records
---- ==================================================================================================================================================


	declare @geminusx table (
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

	declare @cancelationsx table (
									projections_period_id					int,
									flota									nvarchar(40) collate SQL_Latin1_General_CP1_CI_AS,
									id_flota								int,
									id_fraccion								int,
									no_viaje								int,
									id_area									int,
									company									int,
									num_guia								nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
									no_guia									int,
									subtotal								decimal(18,6),
									fecha_cancelacion						datetime,
									fecha_confirmacion						datetime,
									mes										nvarchar(30) collate SQL_Latin1_General_CP1_CI_AS,
									peso									decimal(18,6),
									Area									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
									Tmov									char(1) collate SQL_Latin1_General_CP1_CI_AS,
									Cporte									nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS
								 )

				--select --top(1) --469r 3 sec
				--	'exec sistemas.dbo.sp_xd3e_getFullCompanyOperations ' +
				--	'"' + cast(cyear as nvarchar(10)) + '"' + ',' + 
				--	'"' + cast(period as nvarchar(10)) + '"' + ',' + 
				--	'"' + cast(projections_corporations_id as nvarchar(4000)) + '"' + ',' + 
				--	'"' + cast(id_area as nvarchar(10)) + '","0","0","0"'  as 'params',
				--	cyear,period
				--from 
				--	@tbNextDate
				--where 
				--	period is not null
				
								 
-- check the geminus_cursor
			select 'checking the geminus_cursor data'
							select
								cyear,period
							from 
								@tbNextDate
							where 
								period is not null
							group by cyear,period

---- ==================================================================================================================================================
----													start the cursor
---- ==================================================================================================================================================
	-- this can be changed
	declare @query_cursor as nvarchar(200)


	declare geminuscursor cursor for

							select --top(1) --469r 3 sec
								cyear,period
							from 
								@tbNextDate
							where 
								period is not null
							group by cyear,period
								
	open geminuscursor
  
		fetch next from geminuscursor
		into @qry_cyear,@qry_period --,@qry_projections_corporations_id,@qry_id_area
  
		while @@FETCH_STATUS = 0  
		begin
			
			if @debug = 1
				begin 
					exec sp_projections_log_lv9 'start the cursor for get data'
--					exec sp_projections_log_lv9 (select cast(@query_cursor as nvarchar(50)) + cast(@qry_cyear as nvarchar(10)) + cast(@qry_period as nvarchar(50)) + cast(@qry_projections_corporations_id as nvarchar(50)) + cast(@qry_id_area as nvarchar(200)))
					select @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area
				end
			--print 'insert'
			--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations @query_cursor
			-- ===============================================================================================================
			--	  									   start the fecthing
			-- ===============================================================================================================
			
	--			@year varchar(8000),		-- year or years ex:'2016|2017'
	--			@month varchar(8000),		-- month or months ex: '01|02|03|04|05|06|07|08|09|10'
	--			@Company int,				-- companies id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
	--			@bunit varchar(8000),       -- bussiness unit
	--			@mode tinyint,				-- mode 0 = queryAccepted 1 = insert Accepted in period  3 = queryCancelInsert  4 = queryCancelView  5 = insertAcceptedUpt
	--			@user_id int,				-- user_id when mode is set to 0 this can be empty ''
	--			@period_id int				-- projections_closed_period_controls_id when mode is set to 0 this can be empty ''
			if @query_mode = 1 
				begin
						delete from 
								sistemas.dbo.projections_dissmiss_cancelations  
						where 
								year(fecha_cancelacion) = @qry_cyear 
						and 
								month(fecha_cancelacion) in (select cast(item as int) from sistemas.dbo.fnSplit(@qry_period,'|'))
--						print 'data from sistemas.dbo.projections_dissmiss_cancelations with year ' + @qry_cyear + ' and period ' + @qry_period + ' are deleted '
						exec sp_projections_log_lv9 select('data from sistemas.dbo.projections_dissmiss_cancelations with year ' + (cast(@qry_cyear as nvarchar(10))) + ' and period ' + (cast(@qry_period as nvarchar(100))) + ' are deleted ')

						delete from 
								sistemas.dbo.projections_closed_period_datas  
						where 
								year(fecha_guia) = @qry_cyear 
						and 
								month(fecha_guia) in (select cast(item as int) from sistemas.dbo.fnSplit(@qry_period,'|'))
--						print 'data from sistemas.dbo.projections_closed_period_datas ' + @qry_cyear + ' and period ' + @qry_period + ' are deleted '  
						exec sp_projections_log_lv9 (select 'data from sistemas.dbo.projections_closed_period_datas ' + (cast(@qry_cyear as nvarchar(10))) + ' and period ' + (cast(@qry_period as nvarchar(100))) + ' are deleted ' )
				end
			if @debug = 1
				begin
					exec sp_projections_log_lv9 'periods for procedure'
--					print @qry_cyear
--					print @qry_period
					exec sp_projections_log_lv9 'start insert of the canceled and accepted'
					exec sp_projections_log_lv9 @qry_period
				end
			
				insert into @geminusx
					exec sistemas.dbo.sp_xd3e_getFullCompanyOperations  @qry_cyear , @qry_period , 0 , 0 , 0 , 0 , 0 ---> TODO this must change

				insert into @cancelationsx
					exec sistemas.dbo.sp_xd3e_getFullCompanyOperations  @qry_cyear , @qry_period , 0 , 0 , 4 , 0 , 0 ---> TODO this must change
			-- ===============================================================================================================
			--	  									   end the fecthing
			-- ===============================================================================================================
			fetch next from geminuscursor
			into -- @query_cursor,
				@qry_cyear,@qry_period --,@qry_projections_corporations_id,@qry_id_area
		end  
	close geminuscursor  
	deallocate geminuscursor  

	exec sp_projections_log_lv9 'are you getting over hir ?'
	-- ========================================================================================== --
	-- 									query modes
	-- ========================================================================================== --
	--> 0 = get current defined date datas , accepted and cancelation for open periods
	--> 1 = set a snapshot in dissmiss data from current defined data , this must be set with manual (date_mode = 0) mode for closed periods but not necessary (maintenance)
	--> 2 = view current defined date accepted
	--> 3 = view current defined date canceled
	
	select * from @cancelationsx
	
	select * from @geminusx
	
	
	
	if @query_mode = 0 
		begin

			truncate table sistemas.dbo.projections_upt_cancelations
		
			insert into sistemas.dbo.projections_upt_cancelations
				select * from @cancelationsx
		
			truncate table sistemas.dbo.projections_upt_indops

			exec sp_projections_log_lv9 'start insert the to upt_indops and upt_cancelations --> @query_mode 0'
			
			insert into sistemas.dbo.projections_upt_indops
				select 
						--id,
						(select 0) as 'user_id', --> the user that close the period
						(select 0) as 'projections_closed_period_controls_id',
						--------------------------------------------------------------------
						gx.id_area,
						gx.id_unidad,
						gx.id_configuracionviaje,
						gx.id_tipo_operacion,
						gx.id_fraccion,
						gx.id_flota,
						gx.no_viaje,
						gx.fecha_guia,
						gx.mes,
						gx.f_despachado,
						gx.cliente,
						gx.kms_viaje,
						gx.kms_real,
						gx.subtotal,
						gx.peso,
						gx.configuracion_viaje,
						gx.tipo_de_operacion,
						gx.flota,
						gx.area,
						gx.fraccion,
						gx.company,
						gx.trip_count,
						--------------------------------------------------------------------
						(select CURRENT_TIMESTAMP) as 'created',
						(select CURRENT_TIMESTAMP) as 'modified',
						(select '1') as '_status'
		
				from @geminusx gx
					inner join @tbNextDate nd 
							on nd.cyear = year(gx.fecha_guia)
							and nd.period = month(gx.fecha_guia)
							and nd.projections_corporations_id = gx.company
							and nd.id_area = gx.id_area
					
		end
	
	if @query_mode = 1 -- use with caution snaptshot mode
		begin
			
--			delete from sistemas.dbo.projections_dissmiss_cancelations  
--			where year(fecha_cancelacion) = @current_year and month(fecha_cancelacion) = @current_month
			
			insert into sistemas.dbo.projections_dissmiss_cancelations
				select * from @cancelationsx
			exec sp_projections_log_lv9 'start insert the to dissmiss_cancelations and closed_period_datas --> @query_mode 1'
--			delete from sistemas.dbo.projections_closed_period_datas  
--			where year(fecha_guia) = @current_year and month(fecha_guia) = @current_month
			
			insert into sistemas.dbo.projections_closed_period_datas
				select 
						--id,
						(select 0) as 'user_id', --> the user that close the period
						(select 0) as 'projections_closed_period_controls_id',
						--------------------------------------------------------------------
						gx.id_area,
						gx.id_unidad,
						gx.id_configuracionviaje,
						gx.id_tipo_operacion,
						gx.id_fraccion,
						gx.id_flota,
						gx.no_viaje,
						gx.fecha_guia,
						gx.mes,
						gx.f_despachado,
						gx.cliente,
						gx.kms_viaje,
						gx.kms_real,
						gx.subtotal,
						gx.peso,
						gx.configuracion_viaje,
						gx.tipo_de_operacion,
						gx.flota,
						gx.area,
						gx.fraccion,
						gx.company,
						gx.trip_count,
						--------------------------------------------------------------------
						(select CURRENT_TIMESTAMP) as 'created',
						(select CURRENT_TIMESTAMP) as 'modified',
						(select '1') as '_status'
		
				from @geminusx gx
					inner join @tbNextDate nd 
							on nd.cyear = year(gx.fecha_guia)
							and nd.period = month(gx.fecha_guia)
							and nd.projections_corporations_id = gx.company
							and nd.id_area = gx.id_area
			exec sp_projections_log_lv9 'data from sistemas.dbo.projections_closed_period_datas are inserted '
		end
	-- ========================== use with @date_mode = 0 (set to manual) ================================= --
	if @query_mode = 2
		begin
				select 
						--id,
						(select 0) as 'user_id', --> the user that close the period
						(select 0) as 'projections_closed_period_controls_id',
						--------------------------------------------------------------------
						gx.id_area,
						gx.id_unidad,
						gx.id_configuracionviaje,
						gx.id_tipo_operacion,
						gx.id_fraccion,
						gx.id_flota,
						gx.no_viaje,
						gx.fecha_guia,
						gx.mes,
						gx.f_despachado,
						gx.cliente,
						gx.kms_viaje,
						gx.kms_real,
						gx.subtotal,
						gx.peso,
						gx.configuracion_viaje,
						gx.tipo_de_operacion,
						gx.flota,
						gx.area,
						gx.fraccion,
						gx.company,
						gx.trip_count,
						--------------------------------------------------------------------
						(select CURRENT_TIMESTAMP) as 'created',
						(select CURRENT_TIMESTAMP) as 'modified',
						(select '1') as '_status'
		
				from @geminusx gx
					inner join @tbNextDate nd 
							on nd.cyear = year(gx.fecha_guia)
							and nd.period = month(gx.fecha_guia)
							and nd.projections_corporations_id = gx.company
							and nd.id_area = gx.id_area
			exec sp_projections_log_lv9 'print data of geminuszx '
		end
	if @query_mode = 3 
		begin
			select * from @cancelationsx
		end 

		--select --top(1) --469r 3 sec
		--	cyear,period,projections_corporations_id,id_area
		--from 
		--	@tbNextDate
		--where 
		--	period is not null

	--insert into @geminusx

	--	select 
	--			--id,
	--			--user_id, --> the user that close the period
	--			--projections_closed_period_controls_id,
	--			--------------------------------------------------------------------
	--			id_area,
	--			id_unidad,
	--			id_configuracionviaje,
	--			id_tipo_operacion,
	--			id_fraccion,
	--			id_flota,
	--			no_viaje,
	--			fecha_guia,
	--			mes,
	--			f_despachado,
	--			cliente,
	--			kms_viaje,
	--			kms_real,
	--			subtotal,
	--			peso,
	--			configuracion_viaje,
	--			tipo_de_operacion,
	--			flota,
	--			area,
	--			fraccion,
	--			company,
	--			trip_count--,
	--			--------------------------------------------------------------------
	--			--created,
	--			--modified,
	--			--_status
	--	from 
	--			sistemas.dbo.projections_closed_period_datas
	--	where
	--			_status = 1
	
		--insert into sistemas.dbo.projections_logs
			--select *
			----,(select cast(@tstamp as decimal(18,6))) as 'time_identifier' 
			--from @geminusx 
	--	select @tstamp
	-- go


	--select * from sistemas.dbo.projections_logs


	--42682.743097 truncate table sistemas.dbo.projections_logs

	--select 
	--		company,id_area,area,id_flota,flota,id_fraccion,fraccion
	--		,year(fecha_guia) as 'cyear'
	--		,mes,tipo_de_operacion
	--		,kms_real,kms_viaje
	--		,subtotal,peso,trip_count,* 
	--from
	--		sistemas.dbo.projections_logs
	--where
	--		time_identifier = '42682.749389'


	--select cast((current_timestamp) as decimal(18,6))



	--select * from sistemas.dbo.projections_closed_period_datas where no_viaje = '19113'

	--select * from sistemas.dbo.projections_closed_period_controls where id in ('53','54')



	--delete from sistemas.dbo.projections_closed_period_datas where projections_closed_period_controls_id in (

	--select ctrId from sistemas.dbo.projections_closed_period_controls as ctr
	--	right join 
	--	(
	--		select projections_closed_period_controls_id as 'ctrId' from sistemas.dbo.projections_closed_period_datas 
	--		group by projections_closed_period_controls_id
	--	) as data on ctr.id = data.ctrId
	--where id is null
	--)