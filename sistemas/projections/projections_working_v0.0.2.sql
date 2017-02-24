use sistemas

-- select * from projections_view_closed_period_units order by projections_closed_periods


---- ==================================================================================================================================================
----															declare variables
---- ==================================================================================================================================================
declare @tstamp as decimal(18,6)  
set @tstamp = (select cast((current_timestamp) as decimal(18,6)))
--select @tstamp
declare @periods as nvarchar(4000) 
set @periods = '01|02|03|04|05|06|07|08|09|10|11|12'
declare @period nvarchar(4000)
declare @current_month as nvarchar(2)
declare @current_year as nvarchar(4)
declare @closedYear as nvarchar(4) , @closedMonth as nvarchar(2)
--// incoming vars
set @current_month = '01'
set @current_year = '2016'

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
--select * from @tbyear
-- -------------------------------------------------------------------------------
declare @periodtl table 
						(
							period nvarchar(10)	
						)
insert into @periodtl
	select item from sistemas.dbo.fnSplit(@periods, '|')
--select * from @periodtl
-- -------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------

---- ==================================================================================================================================================
----													start the cursor
---- ==================================================================================================================================================
	

	declare closed_period_cursor cursor for
							
						select 
								projections_corporations_id,id_area,name,projections_closed_periods 
						from 
								sistemas.dbo.projections_view_closed_period_units -- check if must have a change
						order by 
								projections_closed_periods
								
	open closed_period_cursor
  
		fetch next from closed_period_cursor
		into @master_projections_corporations_id, @master_id_area, @master_name, @master_projections_closed_periods
  
		while @@FETCH_STATUS = 0  
		begin
			--select @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area
--			select 'insert'

--			insert into sistemas.dbo.projections_systems_logs values ('insert','',9,CURRENT_TIMESTAMP)
			
			--select @master_projections_corporations_id, @master_id_area, @master_name, @master_projections_closed_periods
			--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations @query_cursor
			-- ===============================================================================================================
			--	  									   start the fecthing
			-- ===============================================================================================================
--				select 'stack Query'
					if (
							cast(@current_month as int) <>  1 --AND cast(@current_month as int) <>  12
					   )
						begin
						exec sp_projections_log_lv9 'distinc of jan'
							--SET LANGUAGE spanish  
							--SET DATEFORMAT ymd

--						select 'diff 1 => current month ' + @current_month + ' and CurrentYear => ' + @current_year + ' date from closedPeriods => ' + cast(@master_projections_closed_periods as nvarchar(10))
--						select 'period from view => ' + right('00'+convert(varchar(2),MONTH(dateadd(month,1,@master_projections_closed_periods))), 2) + ' and cpny ' + @master_name 
--						select 'current => ' + cast((right( CONVERT(VARCHAR(10), ( cast((@current_year + '-' + @current_month + '-' + '01') as date) ), 105), 7)) as nvarchar(10)) + ' master => ' + cast((right( CONVERT(VARCHAR(10), ( cast(@master_projections_closed_periods as date)), 105), 7)) as nvarchar(10))
						exec sp_projections_log_lv9 @master_projections_closed_periods

--						exec sp_projections_log_lv9 'diff 1 => current month ' + cast(@current_month as nvarchar(50)) + ' and CurrentYear => ' + cast(@current_year as nvarchar(50)) + ' date from closedPeriods => ' + cast(@master_projections_closed_periods as nvarchar(10))
--						exec sp_projections_log_lv9 'period from view => ' + right('00'+convert(varchar(2),MONTH(dateadd(month,1,@master_projections_closed_periods))), 2) + ' and cpny ' + cast(@master_name as nvarchar(50))
--						exec sp_projections_log_lv9 'current => ' + cast((right( CONVERT(VARCHAR(10), ( cast((@current_year + '-' + @current_month + '-' + '01') as date) ), 105), 7)) as nvarchar(10)) + ' master => ' + cast((right( CONVERT(VARCHAR(10), ( cast(@master_projections_closed_periods as date)), 105), 7)) as nvarchar(10))

						if DATEDIFF ( mm , @master_projections_closed_periods , (@current_year + '-' + @current_month + '-' + '01') ) = 0
							begin
								--select 'area as closed for now => ' + @master_name  + ' ' + cast( (dateadd(month,1,@master_projections_closed_periods)) as nvarchar(12))
--								select 'months are same'
								exec sp_projections_log_lv9 'months are the same'
								
								declare @newDate as date  
								set @newDate = (dateadd(month,1,@master_projections_closed_periods))
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
								--select ' master isdate => ' + isdate(@master_projections_closed_periods)  + ' current isdate => ' + isdate(cast((@current_year + '-' + @current_month + '-' + '01') as date))
--								select DATEDIFF ( mm , @master_projections_closed_periods , (@current_year + '-' + @current_month + '-' + '01') ) 
--								select 'are diff <> 1 : just valid if the offset is one month --> months are diff'
								exec sp_projections_log_lv9 'are diff <> 1 : just valid if the offset is one month --> months are diff'

								insert into @tbNextDate

									select
										@master_projections_closed_periods as projections_closed_periods,
										year(@master_projections_closed_periods) as 'cyear',
										(select left(	 
											(
												select period + '|' as 'data()' 
												from @periodtl 
												where period between (select right('00'+convert(varchar(2),MONTH(dateadd(month,1,@master_projections_closed_periods))), 2)) and @current_month
												for xml path('')
											), 
										len(
											(
												select period + '|' as 'data()' 
												from @periodtl 
												where period between (select right('00'+convert(varchar(2),MONTH(dateadd(month,1,@master_projections_closed_periods))), 2)) and @current_month
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

					--select cast((right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7)) as nvarchar(10))
					--select cast(( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ) as nvarchar(20))

					-- ====================================================================================================================================================================================

					if (
						cast(@current_month as int) =  1 --OR cast(@current_month as int) =  12
					   )
						begin
							--(select right('00'+convert(varchar(2),MONTH(dateadd(month,1,cl.projections_closed_periods))), 2))
							exec sp_projections_log_lv9 'IN 1'
--							exec sp_projections_log_lv9 'IN 1 => current month ' + cast(@current_month as char(50)) + ' and CurrentYear => ' + cast(@current_year as char(50)) + ' date from closedPeriods => ' + cast(@master_projections_closed_periods as nvarchar(10))
--							exec sp_projections_log_lv9 'period from view => ' + right('00'+convert(varchar(2),MONTH(dateadd(month,1,@master_projections_closed_periods))), 2) + ' and cpny ' + cast(@master_name as nvarchar(50)) 

							--select 'current => ' + cast((right( CONVERT(VARCHAR(10), ( cast((@current_year + '-' + @current_month + '-' + '01') as date) ), 105), 7)) as nvarchar(10)) 
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
					--select cast((right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7)) as nvarchar(10))
					--select cast(( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ) as nvarchar(20))
						end

					
			-- ===============================================================================================================
			--	  									   end the fecthing closed periods
			-- ===============================================================================================================
			fetch next from closed_period_cursor
			into @master_projections_corporations_id, @master_id_area, @master_name, @master_projections_closed_periods
		end  
	close closed_period_cursor  
	deallocate closed_period_cursor  

	select * from @tbNextDate where period is not null
	

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

---- ==================================================================================================================================================
----													start the cursor
---- ==================================================================================================================================================
	
	declare @query_cursor as nvarchar(200)


	declare geminuscursor cursor for

							select --top(1) --469r 3 sec
								--'exec sistemas.dbo.sp_xd3e_getFullCompanyOperations ' +
								'"' + cast(cyear as nvarchar(10)) + '"' + ',' + 
								'"' + cast(period as nvarchar(10)) + '"' + ',' + 
								'"' + cast(projections_corporations_id as nvarchar(4000)) + '"' + ',' + 
								'"' + cast(id_area as nvarchar(10)) + '","0","0","0"'  as 'params',
								cyear,period,projections_corporations_id,id_area
							from 
								@tbNextDate
							where 
								period is not null
								
	open geminuscursor
  
		fetch next from geminuscursor
		into @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area
  
		while @@FETCH_STATUS = 0  
		begin
			--select @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area
--			select 'insert'
			--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations @query_cursor
			-- ===============================================================================================================
			--	  									   start the fecthing
			-- ===============================================================================================================
				insert into @geminusx
					exec sistemas.dbo.sp_xd3e_getFullCompanyOperations  @qry_cyear , @qry_period , @qry_projections_corporations_id , @qry_id_area , 0 , 0 , 0
			-- ===============================================================================================================
			--	  									   end the fecthing
			-- ===============================================================================================================
			fetch next from geminuscursor
			into @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area
		end  
	close geminuscursor  
	deallocate geminuscursor  

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
	
		insert into sistemas.dbo.projections_logs
			select *
			--,(select cast(@tstamp as decimal(18,6))) as 'time_identifier' 
			from @geminusx 
		print  'all is done ... '
	-- go


			
	-- select * from sistemas.dbo.projections_logs  truncate table sistemas.dbo.projections_logs

	-- select * from sistemas.dbo.projections_systems_logs
		
			
			
			
	-- 42682.743097 truncate table sistemas.dbo.projections_logs

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
		
		
