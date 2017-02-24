

--- =========== WARNING use with precaution 
--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations 
--													'2016',	-- year or years (char) ex:'2016|2017' 
--													'01',	-- month or months (char) ex: '01|02|03|04|05|06|07|08|09|10'
--													 1,		-- companies (int) id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
--													'1',	-- bussiness unit (char) like 1 for orizaba or cuatitlan and 3 for ramos whats is true for tbk but not case of teisa or atm 0 = zero mean all bases
--													 0,		-- mode 0 = queryAccepted ;1 = insert Accepted in period ; 3 = insertQueryCancel ; 4 printQueryCancel
--													 0,		-- user_id when mode is set to 0 this can be empty ''
--													 0      -- projections_closed_period_controls_id when mode is set to 0 this can be empty ''
--- =========== WARNING use with precaution 

select * from 
--update 
sistemas.dbo.projections_closed_period_controls 
--set _status = 1
where year(projections_closed_periods) = '2015' and month(projections_closed_periods) in ('12')
and projections_corporations_id = '1' and id_area = '2'

select * from sistemas.dbo.projections_view_closed_period_units order by projections_closed_periods

select area,company,year(fecha_guia) as 'year',month(fecha_guia) as 'month', _status from
--update 
sistemas.dbo.projections_closed_period_datas 
where _status = 1
--set _status = 1
group by area,company,year(fecha_guia),month(fecha_guia),_status
order by company,year(fecha_guia),month(fecha_guia),_status




--select * from sistemas.dbo.projections_periods
----select * from sistemas.dbo.projections_view_closed_periods
--	select * from projections_view_closed_period_units order by projections_closed_periods
----	select * from projections_view_closed_periods order by projections_closed_periods
--	select min(fecha_guia) as 'MIN' , max(fecha_guia) as 'MAX' from projections_closed_period_datas
----delete from projections_closed_period_datas where year(fecha_guia) = '2016' and month(fecha_guia) = '10'
----select * from sistemas.dbo.projections_cancelations --contiene las canceladas por periodo cerrado 


-- ==================================================================================================================================================
--															fetch the status of the periods
-- ==================================================================================================================================================


----/*PERIODS*/
--select * from projections_view_closed_period_units order by projections_closed_periods

declare @tbNextDate table (
							projections_closed_periods date,
							cyear nvarchar(4),
							period nvarchar(4000),
							projections_corporations_id int,
							id_area int
						  )

declare @periods as nvarchar(4000); set @periods = '01|02|03|04|05|06|07|08|09|10|11|12';
declare @period nvarchar(4000);
declare @current_month as nvarchar(2);
declare @current_year as nvarchar(4);
declare @closedYear as nvarchar(4) , @closedMonth as nvarchar(2);
--// incoming vars
set @current_month = '01';
set @current_year = '2016';

select @closedYear = '2015' , @closedMonth = '11';

-- select  right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7)
--select 
--	(select (right( CONVERT(VARCHAR(10), cl.projections_closed_periods, 105), 7) ) ) as 'fecha'
--from sistemas.dbo.projections_view_closed_period_units as cl
--	where (select (right( CONVERT(VARCHAR(10), cl.projections_closed_periods, 105), 7) ) ) = ( right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7) ) 
--select * from 
----update 
--sistemas.dbo.projections_view_closed_period_units
----set projections_closed_periods = '2016-12-05'
--where projections_corporations_id	= '1' and id_area = '2'
declare @tbyear table 
					(
						cyear nvarchar(4)
					)
insert into @tbyear
	select item from sistemas.dbo.fnSplit(@current_year,'|');
--select * from @tbyear
--select @period = COALESCE(@period + '|', '') + item from sistemas.dbo.fnSplit(@periods, '|')  where item between '03' and '10';
--select  cast( @period as nvarchar );
declare @periodtl table 
						(
							period nvarchar(10)	
						)
insert into @periodtl
	select item from sistemas.dbo.fnSplit(@periods, '|')
--select * from @periodtl
if (
		cast(@current_month as int) <>  1 --AND cast(@current_month as int) <>  12
   )
	begin
	print 'diff 1';			
--	select * from @tbyear as tbyear
--		inner join 
--(
	insert into @tbNextDate
		select 
			cl.projections_closed_periods,
			year(cl.projections_closed_periods) as 'cyear',
			(select left(	 
				(
					SELECT period + '|' AS 'data()' 
					FROM @periodtl 
					where period between (select right('00'+convert(varchar(2),MONTH(dateadd(month,1,cl.projections_closed_periods))), 2)) and @current_month
					FOR XML PATH('')
				), 
			len(
				(
					SELECT period + '|' AS 'data()' 
					FROM @periodtl 
					where period between (select right('00'+convert(varchar(2),MONTH(dateadd(month,1,cl.projections_closed_periods))), 2)) and @current_month
					FOR XML PATH('')
				)
			)-1)
			) as 'period',
			 projections_corporations_id,id_area
		from sistemas.dbo.projections_view_closed_period_units as cl;
	end
--) as query on query.cyear = tbyear.cyear

--select (right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7))
--select ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) )

-- ====================================================================================================================================================================================

if (
	cast(@current_month as int) =  1 --OR cast(@current_month as int) =  12
   )
	begin
		--(select right('00'+convert(varchar(2),MONTH(dateadd(month,1,cl.projections_closed_periods))), 2))
		print 'IN 1';
		
		declare @nextDate as nvarchar(10);
		set @nextDate = (select ( right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7) ) )

		declare @nextYear as nvarchar(4);
		set @nextYear = substring(@nextDate,4,4);
		
		insert into @tbNextDate
		select 
			cl.projections_closed_periods ,
			--year(cl.projections_closed_periods) as 'cyear',
			case
				when year(cl.projections_closed_periods) <> @current_year
					then
						(select @current_year)
				else
					year(cl.projections_closed_periods)
			end as 'cyear',
			case
				when month(cl.projections_closed_periods) <> @current_month --and @current_month = '01'
					then
						(select @current_month)
				else
					-- case when close jan 
					null
			end as 'period',
			 projections_corporations_id,id_area
		from sistemas.dbo.projections_view_closed_period_units as cl;
		--union all

		if substring(@nextDate,4,4) <> @current_year
			begin
				insert into @tbNextDate
				select 
					cl.projections_closed_periods,
					(select	substring(@nextDate,4,4)) as 'cyear',
					case
						when (month(cl.projections_closed_periods) = 12 )
							then
								null
							else
								(select '12')
					end as 'period',
					projections_corporations_id,id_area
				from sistemas.dbo.projections_view_closed_period_units as cl;
			end
	end

	select * from @tbNextDate where period is not null;

-- ==================================================================================================================================================
--															tmp 
-- ==================================================================================================================================================


	--declare @query_cursor as nvarchar(200);

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
 --							 )

	--declare 				
	--		@qry_projections_closed_periods date,
	--		@qry_cyear nvarchar(4),
	--		@qry_period nvarchar(4000),
	--		@qry_projections_corporations_id int,
	--		@qry_id_area nvarchar(1) ;


	--					select top(1)
	--						@query_cursor =
	--						--'execute sistemas.dbo.sp_xd3e_getFullCompanyOperations ' +
	--						'"' + cast(tbnd.cyear as nvarchar(10)) + '"' + ',' + 
	--						'"' + cast(tbnd.period as nvarchar(10)) + '"' + ',' + 
	--						'"' + cast(tbnd.projections_corporations_id as nvarchar(4000)) + '"' + ',' + 
	--						'"' + cast(tbnd.id_area as nvarchar(10)) + '","0","0","0"' -- as 'params'
	--						,@qry_cyear = tbnd.cyear
	--						,@qry_period = tbnd.period
	--						,@qry_projections_corporations_id = tbnd.projections_corporations_id
	--						,@qry_id_area = tbnd.id_area
	--					from 
	--						@tbNextDate as tbnd
	--					where 
	--						tbnd.period is not null;

	--		select @query_cursor ,@qry_cyear, @qry_period,@qry_projections_corporations_id,@qry_id_area;

	--		insert into @geminusx
	--			exec sp_xd3e_getFullCompanyOperations  @qry_cyear , @qry_period , @qry_projections_corporations_id , @qry_id_area , 0 , 0 , 0;

	--		select * from @geminusx

-- ==================================================================================================================================================
--															tmp 
-- ==================================================================================================================================================

			--exec sp_xd3e_getFullCompanyOperations  '2015' , '12' , '3' , '2' , 0 , 0 , 0;

			--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations @query_cursor;

			--select * 
			--from
			--openquery(local, "'" + @query_cursor + "'")

---- ==================================================================================================================================================
----															declare a tmp table for
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
	
	declare @query_cursor as nvarchar(200);

	declare 				
			@qry_projections_closed_periods date,
			@qry_cyear nvarchar(4),
			@qry_period nvarchar(4000),
			@qry_projections_corporations_id int,
			@qry_id_area int ;

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
								period is not null;
								
	open geminuscursor
  
		fetch next from geminuscursor
		into @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area
  
		while @@FETCH_STATUS = 0  
		begin
			select @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area;
			print 'insert';
			--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations @query_cursor;
			-- ===============================================================================================================
			--	  									   start the fecthing
			-- ===============================================================================================================
				insert into @geminusx
					exec sistemas.dbo.sp_xd3e_getFullCompanyOperations  @qry_cyear , @qry_period , @qry_projections_corporations_id , @qry_id_area , 0 , 0 , 0;
			-- ===============================================================================================================
			--	  									   end the fecthing
			-- ===============================================================================================================
			fetch next from geminuscursor
			into @query_cursor,@qry_cyear,@qry_period,@qry_projections_corporations_id,@qry_id_area
		end  
	close geminuscursor;  
	deallocate geminuscursor;  

	insert into @geminusx

		select 
				--id,
				--user_id, --> the user that close the period
				--projections_closed_period_controls_id,
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
				trip_count--,
				--------------------------------------------------------------------
				--created,
				--modified,
				--_status
		from 
				sistemas.dbo.projections_closed_period_datas
		where
					year(fecha_guia) <= @closedYear
				and 
					month(fecha_guia) <= @closedMonth

	select * from @geminusx

	--select
	--		--id,
	--		--user_id, --> the user that close the period
	--		--projections_closed_period_controls_id,
	--		--------------------------------------------------------------------
	--		id_area,
	--		id_unidad,
	--		id_configuracionviaje,
	--		id_tipo_operacion,
	--		id_fraccion,
	--		id_flota,
	--		no_viaje,
	--		fecha_guia,
	--		mes,
	--		f_despachado,
	--		cliente,
	--		kms_viaje,
	--		kms_real,
	--		subtotal,
	--		peso,
	--		configuracion_viaje,
	--		tipo_de_operacion,
	--		flota,
	--		area,
	--		fraccion,
	--		company,
	--		trip_count--,
	--		--------------------------------------------------------------------
	--		--created,
	--		--modified,
	--		--_status
	--from @geminusx



	go

--- =========== WARNING use with precaution 
--exec sistemas.dbo.sp_xd3e_getFullCompanyOperations 
--													'2016',	-- year or years (char) ex:'2016|2017' 
--													'10',	-- month or months (char) ex: '01|02|03|04|05|06|07|08|09|10'
--													 1,		-- companies (int) id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
--													'1',	-- bussiness unit (char) like 1 for orizaba or cuatitlan and 3 for ramos whats is true for tbk but not case of teisa or atm 0 = zero mean all bases
--													 0,		-- mode 0 = queryAccepted ;1 = insert Accepted in period ; 3 = insertQueryCancel ; 4 printQueryCancel
--													 1,		-- user_id when mode is set to 0 this can be empty ''
--													 0      -- projections_closed_period_controls_id when mode is set to 0 this can be empty ''
--- =========== WARNING use with precaution 


















--select 
--	(select (right( CONVERT(VARCHAR(10), cl.projections_closed_periods, 105), 7) ) ) as 'fecha'
--from sistemas.dbo.projections_view_closed_period_units as cl
--	where (select (right( CONVERT(VARCHAR(10), cl.projections_closed_periods, 105), 7) ) ) = ( right( CONVERT(VARCHAR(10), ( dateadd(month,-1,cast((@current_year + '-' + @current_month + '-' + '01') as date)) ), 105), 7) ) 
	

--(select (right( CONVERT(VARCHAR(10), CURRENT_TIMESTAMP, 105), 7) ) )


--select * from sistemas.dbo.projections_closed_period_controls
--select * from
---- truncate table
-- sistemas.dbo.projections_closed_period_datas

-- select (cast (2 as tinyint))


--DECLARE @datetime2 datetime2;  
--SET @datetime2 = '2007-01-01 01:01:01.1111111';  
----Statement                                 Result     
---------------------------------------------------------------------   
--SELECT DATEADD(quarter,4,@datetime2);     --2008-01-01 01:01:01.110  
--SELECT DATEADD(month,13,@datetime2);      --2008-02-01 01:01:01.110  
--SELECT DATEADD(dayofyear,365,@datetime2); --2008-01-01 01:01:01.110  
--SELECT DATEADD(day,365,@datetime2);       --2008-01-01 01:01:01.110  
--SELECT DATEADD(week,5,@datetime2);        --2007-02-05 01:01:01.110  
--SELECT DATEADD(weekday,31,@datetime2);    --2007-02-01 01:01:01.110  
--SELECT DATEADD(hour,23,@datetime2);       --2007-01-02 00:01:01.110  
--SELECT DATEADD(minute,59,@datetime2);     --2007-01-01 02:00:01.110  
--SELECT DATEADD(second,59,@datetime2);     --2007-01-01 01:02:00.110  
--SELECT DATEADD(millisecond,1,@datetime2); --2007-01-01 01:01:01.110  