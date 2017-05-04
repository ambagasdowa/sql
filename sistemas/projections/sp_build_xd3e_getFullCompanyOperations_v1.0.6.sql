-- ==================================================================================================================== --	
-- =================================     Store to set a snapshot for devops      ====================================== --
-- ==================================================================================================================== --

-- ==================================================================================================================== --
/*
	 Author         : Jesus Baizabal
	 email			: ambagasdowa@gmail.com
	 Create date    : April 06, 2017
	 Description    : Build Tables for constant values like months names translation to spanish names
	 TODO			: clean
	 @Last_patch	: --
	 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
	 Database owner : bonampak s.a de c.v 
	 @status        : Stable
	 @version		: 1.0.0
 */
-- ==================================================================================================================== --



/** TODO review the field definitions */

	declare @year as varchar(8000)		-- year or years ex:'2016,"com".2017'
	declare @month as varchar(8000)		-- month or months ex: '01,"com".02,"com".03,"com".04,"com".05,"com".06,"com".07,"com".08,"com".09,"com".10'
	declare @Company as varchar(8000)		-- companies id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
	declare @bunit as varchar(8000)      	-- bussiness unit
	--@doctype tinyint,"com".				-- document type (1 = Acepted) ,"com". (2 = Cancel) ,"com". ...
	declare @mode as tinyint				-- mode 0 = queryAccepted 1 = insert Accepted in period  3 = queryCancelInsert  4 = queryCancelView  5 = insertAcceptedUpt ,"com".8 = automatic_viewmode ,mode = 9 => test
	declare @user_id as int				-- user_id when mode is set to 0 this can be empty ''
	declare @period_id  as int				-- projections_closed_period_controls_id when mode is set to 0 this can be empty ''

	
	
 	set @year = '0'		-- year or years ex:'2016,"com".2017'
	set @month = '0'		-- month or months ex: '01|02|03|04|05|06|07|08|09|10'
	set @Company = '3'		-- companies id's ex: 1(tbk) or 2(amt) or 3(tei) or 0 (zero means all companies)
	set @bunit = '0' 		-- bussiness unit
	set @mode = 9			-- mode 0 = queryAccepted 1 = insert Accepted in period  3 = queryCancelInsert  4 = queryCancelView  5 = insertAcceptedUpt ,"com".8 = automatic_viewmode
	set @user_id = 0		-- user_id when mode is set to 0 this can be empty ''
	set @period_id = 0		-- projections_closed_period_controls_id when mode is set to 0 this can be empty ''
 
	
 	SET NOCOUNT ON
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	
	
	
	--	select * from sistemas.dbo.projections_view_closed_period_units	
	--	build tables 

	declare @comp as table 
								(
									company int
								)
								
	declare @bunits as table
								(
									units int
								)

								
	if @Company = '0'
		begin
			insert into @comp
				select id from sistemas.dbo.projections_corporations where "_status" = '1'
		end
	else
		begin
			insert into @comp
				select cast(item as int) from sistemas.dbo.fnSplit(@Company, '|') 
		end

--	select * from @comp
	
	if @bunit = '0'
		begin
			insert into @bunits
				select 
						id_area
				from 
						sistemas.dbo.projections_view_closed_period_units 
				group by
						id_area
				order by
						id_area
		end
	else
		begin
			insert into @bunits
				select cast(item as int) from sistemas.dbo.fnSplit(@bunit, '|') 
		end
		
--	select units from @bunits	

	if @month = '0'
		begin
			set @month = '01|02|03|04|05|06|07|08|09|10|11|12'
		end

-- ====================================== TODO ========================================================
-- build query ,"com". that brings ,"com". all dispatched trips of month and not acepted in any month counterpart
-- brings all trips and set if have a aceptation ,"com". cancelations or only dispatch
-- ====================================== CANCELATIONS ================================================
-- status_guia
-- A => Abierta o pendiente
-- C => Confirmada o Transferidas
-- T => Transito
-- R => Regreso
-- B => Cancelada

if @mode <> 9
	begin
	-- building cache 
	declare @indicators table (
									 user_id int
									,projections_closed_period_controls_id int
									,id_area int
									,id_unidad varchar(10) not null
									,id_configuracionviaje int
									,id_tipo_operacion int
									,id_fraccion int
									,id_flota int
									,no_viaje int
									,fecha_guia varchar(10)
									,mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS
									,f_despachado datetime
									,cliente varchar(60)
									,kms_viaje int
									,kms_real int
									,subtotal decimal(18,6)
									,peso decimal(18,6)
									,configuracion_viaje varchar(20)
									,tipo_de_operacion varchar(20)
									,flota varchar(40)
									,area varchar(40)
									,fraccion varchar(60)
									,company int
									,trip_count tinyint
									,created datetime
									,modified datetime
									,"_status" tinyint
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
								fecha_guia	datetime,
								mes varchar(30) collate SQL_Latin1_General_CP1_CI_AS,
								peso decimal(18,6),
								Area nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
								Tmov char(1) collate SQL_Latin1_General_CP1_CI_AS,
								Cporte  nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
								id_tipo_operacion  int
							)
							
	declare @time_tbl table 
							(
								 projections_corporations_id int
								,id_area int 
								,name nvarchar(80)
								,projections_closed_periods date 
								,next_period date
							)

--		
-- ==================================================================================================================== --	
-- ==================================        setting the closed period        ========================================= --
-- ==================================================================================================================== --						  				
		insert into @time_tbl			
		select 
				 "un".projections_corporations_id
				,"un".id_area
				,"un".name
				,"un".projections_closed_periods
				,"un".next_period
		from 
				sistemas.dbo.projections_view_closed_period_units as "un"
		where 
				(right( CONVERT(VARCHAR(10),"un".next_period, 105), 7) ) < (right( CONVERT(VARCHAR(10), CURRENT_TIMESTAMP, 105), 7) )
			and 
				"un".projections_corporations_id in (select company from @comp)
		
-- ==================================================================================================================== --	
-- ====================================    fetching the rows of accepted      ========================================= --
-- ==================================================================================================================== --						  
 		insert into @indicators
		select 
					 @user_id as 'user_id',@period_id as 'projections_closed_period_controls_id'
				 	,"com".id_area ,"com".id_unidad ,"com".id_configuracionviaje ,"com".id_tipo_operacion ,"com".id_fraccion
					,"com".id_flota ,"com".no_viaje ,"com".fecha_guia ,"com".mes   ,"com".f_despachado,"com".cliente,"com".kms_viaje ,"com".kms_real 
					,"com".subtotal,"com".peso,"com".configuracion_viaje ,"com".tipo_de_operacion,"com".flota,"com".area,"com".fraccion,"com".company
					,"com".trip_count
					,CURRENT_TIMESTAMP as 'created' , CURRENT_TIMESTAMP as 'modified' , '1' as '_status'
		from 
					sistemas.dbo.projections_view_full_company_indicators as "com"
			inner join
					@time_tbl as "table_time" on "com".company = "table_time".projections_corporations_id and "com".id_area = "table_time".id_area
		where 
					"com".company in (select company from @comp)
			and 
					"com".id_area in (select units from @bunits)
			and
					(right( CONVERT(VARCHAR(10),"com".fecha_guia, 105), 7) ) = (right( CONVERT(VARCHAR(10),"table_time".next_period, 105), 7) )

-- ==================================================================================================================== --	
-- ====================================    fetching the rows of canceled       ======================================= --
-- ==================================================================================================================== --

	insert into @canceled				
	select 
				 "cnc".projections_period_id ,"cnc".flota ,"cnc".id_flota ,"cnc".id_fraccion ,"cnc".no_viaje ,"cnc".id_area ,"cnc".company
				,"cnc".num_guia ,"cnc".no_guia ,"cnc".subtotal ,"cnc".fecha_cancelacion ,"cnc".fecha_confirmacion ,"cnc".fecha_guia
				,"cnc".mes ,"cnc".peso ,"cnc".Area ,"cnc".Tmov ,"cnc".Cporte ,"cnc".id_tipo_operacion
	from 
				sistemas.dbo.projections_view_canceled_periods as "cnc"
		inner join
				@time_tbl as "tbl_time" on "cnc".company = "tbl_time".projections_corporations_id and "cnc".id_area = "tbl_time".id_area
	where 
				"cnc".company in (select company from @comp)
			and
				"cnc".id_area in (select units from @bunits)
			and
					(right( CONVERT(VARCHAR(10),"cnc".fecha_cancelacion, 105), 7) ) = (right( CONVERT(VARCHAR(10),"tbl_time".next_period, 105), 7) )
	
-- ==================================================================================================================== --	
-- ================================        where to go ??? Quering Accepted	   ===================================== --
-- ==================================================================================================================== --
--

	if (@mode = 0)
		begin
			select 
					 user_id ,projections_closed_period_controls_id 
					 -- ================ --
					,id_area ,id_unidad ,id_configuracionviaje 
					,id_tipo_operacion ,id_fraccion ,id_flota
					,no_viaje ,fecha_guia ,mes ,f_despachado
					,cliente ,kms_viaje ,kms_real ,subtotal
					,peso ,configuracion_viaje ,tipo_de_operacion 
					,flota ,area ,fraccion ,company ,trip_count
					 -- ================ --
					,created ,modified ,_status
			from
					@indicators
					
		end
		
-- ================================================================================================================================== --
-- ===============================       Insert Acepted into table closed period datas       ======================================== --
-- ================================================================================================================================== --
	if (@mode = 1)
		begin
--			truncate table sistemas.dbo.projections_logs			
--			insert into sistemas.dbo.projections_logs
			insert into sistemas.dbo.projections_closed_period_datas
				select 
						user_id ,projections_closed_period_controls_id ,
						 -- ================ --
						id_area ,id_unidad ,id_configuracionviaje 
						,id_tipo_operacion ,id_fraccion ,id_flota
						,no_viaje ,fecha_guia ,mes ,f_despachado
						,cliente ,kms_viaje ,kms_real ,subtotal
						,peso ,configuracion_viaje ,tipo_de_operacion 
						,flota ,area ,fraccion ,company ,trip_count
						 -- ================ --
						,created ,modified ,_status
				from
						@indicators				
		end
-- ================================================================================================================================== --
-- ============================================== Insert snapshot into dissmis table ================================================ --
-- ================================================================================================================================== --
	if (@mode = 1)
		begin
--			truncate table sistemas.dbo.projections_cancelations		
--			insert into sistemas.dbo.projections_cancelations( "projections_period_id","flota" ,"id_flota" ,"id_fraccion" ,"no_viaje" ,"id_area" ,"company"
--				,"num_guia" ,"no_guia" ,"subtotal" ,"fecha_cancelacion" ,"fecha_confirmacion" ,"mes" ,"peso" ,"Area" ,"Tmov" ,"Cporte")
			insert into sistemas.dbo.projections_dissmiss_cancelations( "projections_period_id","flota" ,"id_flota" ,"id_fraccion" ,"no_viaje" ,"id_area" ,"company"
				,"num_guia" ,"no_guia" ,"subtotal" ,"fecha_cancelacion" ,"fecha_confirmacion" ,"mes" ,"peso" ,"Area" ,"Tmov" ,"Cporte","id_tipo_operacion")
			select 
				 @period_id as 'projections_period_id' ,flota ,id_flota ,id_fraccion ,no_viaje ,id_area ,company
				,num_guia ,no_guia ,subtotal ,fecha_cancelacion ,fecha_confirmacion --,fecha_guia
				,mes ,peso ,Area ,Tmov ,Cporte 
				,id_tipo_operacion
			from 
				@canceled
		end

-- ================================================================================================================================== --
-- ===========================================       Just Quering the canceled       ================================================ --
-- ================================================================================================================================== --
	if(@mode = 4)
		begin
				
			select
				 @period_id as 'projections_period_id' ,flota ,id_flota ,id_fraccion ,no_viaje ,id_area ,company
				,num_guia ,no_guia ,subtotal ,fecha_cancelacion ,fecha_confirmacion ,fecha_guia
				,mes ,peso ,Area ,Tmov ,Cporte ,id_tipo_operacion
			from 
				@canceled
		end
		
-- ================================================================================================================================== --
-- =============================================== Update the periods control table ================================================= --
-- ================================================================================================================================== --
-- Close Mechanish

	if @mode = 1
		begin
			insert into sistemas.dbo.projections_closed_period_controls
			select 
					@user_id as 'user_id',"timeun".next_period as 'projections_closed_periods',
					"timeun".id as 'projections_view_bussiness_units_id'
					,"timeun".projections_corporations_id ,"timeun".id_area 
					,'1' as 'projections_status_period'
					,CURRENT_TIMESTAMP as 'created'
					,CURRENT_TIMESTAMP as 'modified'
					,'1' as "_status"
			from 
					sistemas.dbo.projections_view_closed_period_units as "timeun"
			where 
					(right( CONVERT(VARCHAR(10),"timeun".next_period, 105), 7) ) < (right( CONVERT(VARCHAR(10), CURRENT_TIMESTAMP, 105), 7) )
				and 
					"timeun".projections_corporations_id in (select company from @comp)
				and	
					"timeun".id_area in (select units from @bunits)			
		end
		
-- Testing the result
	/*
		select 
				Area,mes,id_fraccion,sum(subtotal) as 'subtotal' ,sum(peso) as 'peso'  
		from 
				sistemas.dbo.projections_cancelations --7
		group by
				Area, mes ,id_fraccion
		
		select 
				 area,mes,fraccion,sum(kms_viaje) as 'kms_viaje',sum(kms_real) as 'kms_real' 
				,sum(subtotal) as 'subtotal',sum(peso) as 'peso' ,sum(trip_count) as 'viajes' 
		from 
				sistemas.dbo.projections_logs --3949
		group by
				area,mes,fraccion
 
 		select * from projections_view_indicators_periods_fleets
		where cyear = '2017' and mes = 'Abril'
		and company in (select company from @comp)
		and id_area in (select units from @bunits)
	*/
	end -- end of mode <> 9
-- ================================================================================================================================== --
-- =============================================== Testing mode of vars ================================================= --
-- ================================================================================================================================== --
-- Close Mechanish	
		
		if @mode = 9
			begin
				select @year as 'year',@month as 'month',@Company as 'company',@bunit as 'bunit',@mode as 'mode',@user_id as 'user_id',@period_id as 'perid_unit'
			end 
		