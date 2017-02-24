-- LIS to IAVE  This is the working one

declare @ctrfile nvarchar(4000), @ctrhist int;

declare @viaje as int ; set @viaje =  '112537'
declare @iav as nvarchar(25) ; set @iav = 'IMDM21337804..';

set @ctrfile = '137' ; ---set the file in dbo.casetas 134


-- Engine trips Zam
 -- --- --- --- --
--- End Of the Engine trips Zam



	declare @conciliation_table as table 
	(
					 period_iave_id							int
					,fecha_ini								date
					,fecha_fin								date
					,no_viaje								int
					,f_despachado							date
					,id_area								int
					,name									nvarchar(25) collate	sql_latin1_general_cp1_ci_as
					,cia									nvarchar(15) collate	sql_latin1_general_cp1_ci_as
					,company_id								int
					,id_unidad								nvarchar(10) collate	sql_latin1_general_cp1_ci_as
					,iave_catalogo							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
					,iave_viaje								nvarchar(25) collate	sql_latin1_general_cp1_ci_as
					,id_ruta								int
					,desc_ruta								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
					,id_caseta								int
					,fecha_real_viaje						datetime
					,fecha_real_fin_viaje					datetime
					,diff_length_hours						int
					,no_ejes_viaje							int
					,no_tarjeta_llave						nvarchar(25) collate	sql_latin1_general_cp1_ci_as
					,orden									int
					,consecutivo							int
					,desc_caseta							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
					,no_de_ejes								int
					,monto_iave								decimal(18,6)
					,tarifas								decimal(18,6)
					,liq_tipo_pago							int
					,liq_paso								nvarchar(1)
					,liq_id_caseta							int
					,liq_monto_caseta						decimal(18,6)
					,liq_monto_iave							decimal(18,6)
					,liq_no_liquidacion						int
					,trliq_fecha_ingreso					datetime
					,_filename								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
					,iave_period							int
					,casetas_controls_files_id				int
					,casetas_historical_conciliations_id	int
					,fecha_conciliacion						datetime
					,_modified								datetime default current_timestamp
					,_status								tinyint default 1 null			
	)

	declare @conciliations_dup_table as table 
	(
		--lis
		  company_id							int 
		 ,id_area								int
		 ,no_viaje								int
		 ,iave_catalogo							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		 ,fecha_ini								date
		 ,fecha_fin								date
		 ,fecha_real_viaje						datetime
		 ,fecha_real_fin_viaje					datetime
		 ,desc_caseta							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		 ,liq_id_caseta							int
		 ,orden									int
		 ,id_unidad								nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		  --iave
		 ,unit									nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		 ,key_num_5								nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS	
		 ,alpha_location						nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
		 ,alpha_num_code						nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
		 ,fecha_a								date
		 ,time_a								time
		 ,iave_cruce_id							int
		 ,float_data							decimal(18,6)
		 ,key_num_4								int
		 ,float_data_1							int
		 ,_filename								nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
		 ,_area									nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
		 ,_date									datetime
		 ,casetas_controls_files_id				int
		 ,casetas_historical_conciliations_id	int
		 ,RN									int
		 ,CTE									int
	)

	declare @conciliations_sin_table as table 
	(
		  company_id							int
		 ,id_area								int
		 ,no_viaje								int
		 ,iave_catalogo							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		 ,fecha_ini								date
		 ,fecha_fin								date
		 ,fecha_real_viaje						datetime
		 ,fecha_real_fin_viaje					datetime
		 ,desc_caseta							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		 ,liq_id_caseta							int
		 ,orden									int
		 ,id_unidad								nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		  --iave
		 ,unit									nvarchar(25) collate	sql_latin1_general_cp1_ci_as
		 ,key_num_5								nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS	
		 ,alpha_location						nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
		 ,alpha_num_code						nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
		 ,fecha_a								date
		 ,time_a								time
		 ,iave_cruce_id							int
		 ,float_data							decimal(18,6)
		 ,key_num_4								int
		 ,float_data_1							int
		 ,_filename								nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
		 ,_area									nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
		 ,_date									datetime
		 --control
		 ,casetas_controls_files_id				int
		 ,casetas_historical_conciliations_id	int
		 ,RN									int
		 ,CTE									int
	)

	declare @percents as table
	(
	  company_id			int
	 ,id_area				int
	 ,no_viaje				int
	 ,no_tarjeta_iave		nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	 --iave_period
	 ,fecha_inicio			date
	 ,fecha_fin				date
	 --lis
	 ,fecha_real_viaje		datetime
	 ,fecha_real_fin_viaje	datetime
	 ,id_unidad				nvarchar(25) collate	sql_latin1_general_cp1_ci_as
	 ,id_ruta				int
	 ,orden					int
	 ,description_casetas	nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	 ,diff_length_hours		int
	 ,monto_caseta			decimal(18,6)
	 ,lis_ejes				int
	 ,liq_monto_iave		decimal(18,6)
	 --iave
	 ,alpha_location		nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	 ,unit					nvarchar(25) collate	sql_latin1_general_cp1_ci_as
	 ,key_num_5				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	 ,date_cruce			datetime
	 ,fecha_cruce			date
	 ,hora_cruce			time
	 ,iave_cruce_id			int
	 ,_monto_archivo			decimal(18,4)
	 ,iave_ejes				int
	 ,iave_iave				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	 ,iave_caseta_id		int
	 ,name					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	 ,period_iave_id		int
	 ,_filename				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	 -- input user 
	 ,cia					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	 --control
 	 ,casetas_controls_files_id				int
	 ,casetas_historical_conciliations_id	int
	 ,casetas_standings_id					int
	 ,casetas_parents_id					int
	)


declare @casetas_conciliation as table
                                    (
										--- ========= OLD TB MODULE ======== ---
                                        --id						int,
                                         id_unidad				nvarchar(25)
                                        ,unit					nvarchar(25)
                                        ,no_tarjeta_iave		nvarchar(100)
                                        ,alpha_num_code			nvarchar(25)
                                        ,alpha_location			nvarchar(250)
                                        ,alpha_location_1		nvarchar(60) -- do not have a use yet 
                                        ,_filename				nvarchar(150)
                                        ,no_viaje				int
                                        ,fecha_cruce			date
                                        ,f_despachado			datetime
                                        ,fecha_fin_viaje		datetime
                                        ,float_data				decimal(18,4) --monto again and comes from iave
                                        ,hora_cruce				time(7)
                                        ,cia					nvarchar(25)
                                        ,Monto_archivo			decimal(18,4) --this come from iave
										,_next					date
										-- === Period Section ==== ---
                                        ,fecha_inicio			date -- ref to period in new mod
                                        ,fecha_fin				date -- ref to period in new mod
										-- === Period Section ==== ---
										,description_casetas	nvarchar(300) -- refer to a description of liquidation in zam
										-- === Control Section ==== ---
										,casetas_historical_conciliations_id	int
 										,casetas_controls_files_id				int
										,created								datetime
										,modified								datetime
										,casetas_standings_id					int
										,casetas_parents_id					int
										,_status					tinyint default 1 null
										-- ===== START THE NEW MODULE ======= ---
										,company_id				int
										,id_area				int
										-- === ZAM Section ==== ---
										,fecha_real_viaje		datetime
										,fecha_real_fin_viaje	datetime
										,id_ruta				int
										,orden					int
										,diff_length_hours		int
										,monto_caseta			decimal(18,6)
										,lis_ejes				int
										,liq_monto_iave			decimal(18,6)
										-- === Iave Section ==== ---
										,key_num_5				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										,date_cruce				datetime
										,iave_cruce_id			int
										,_monto_archivo			decimal(18,4)
										,iave_ejes				int
										,iave_iave				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- tarjeta_iave
										,iave_caseta_id			int
										,name					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- change for cia
										,period_iave_id			int
                                    );
;with casetas_double as 
						(
							select 
									 lis.company_id,lis.id_area,lis.no_viaje,lis.iave_catalogo,lis.fecha_ini,lis.fecha_fin,lis.fecha_real_viaje,lis.fecha_real_fin_viaje,lis.desc_caseta,lis.liq_id_caseta,lis.orden,lis.id_unidad
									,_file.unit,_file.key_num_5,_file.alpha_location,_file.alpha_num_code,_file.fecha_a,_file.time_a,_file.id as 'iave_cruce_id',_file.float_data,_file.key_num_4,cast(_file.float_data_1 as int) as 'float_data_1',_file._filename,_file._area
									,(
									select (
										convert(datetime, _file.fecha_a) + ' ' + CONVERT(datetime, _file.time_a))
									 ) as '_date'
									,lis.casetas_controls_files_id
									,lis.casetas_historical_conciliations_id
									,ROW_NUMBER() OVER (PARTITION BY lis.casetas_controls_files_id,lis.company_id,lis.id_area,lis.iave_catalogo,lis.no_viaje,lis.orden,lis.desc_caseta ORDER BY lis.casetas_controls_files_id,lis.company_id,lis.id_area,lis.iave_catalogo,lis.no_viaje,lis.orden,lis.desc_caseta,_file.fecha_a,_file.time_a) AS RN
							from 
									--sistemas.dbo.casetas as _file
									sistemas.dbo.casetas_lis_full_conciliations as lis
									--@tollbooth_no_trips as lis
							full join
							--		--sistemas.dbo.casetas_lis_full_conciliations as lis
									sistemas.dbo.casetas as _file
							on 
									_file.casetas_controls_files_id = lis.casetas_controls_files_id  
								and 
									(select cast(rtrim(replace(lis.desc_caseta,'.','')) as nvarchar(50)) COLLATE SQL_Latin1_General_CP1_CI_AS) = 
																	(
																			case
																				when cast(float_data_1 as int) in (316)
																					then 
																						_file.alpha_location
																					else	
																						_file.key_num_5 
																			end
																	)
								-- Drop if don't need
								and
									(select cast(lis.iave_catalogo as nvarchar(50)) COLLATE SQL_Latin1_General_CP1_CI_AS) = _file.alpha_num_code
								-- Drop if don't need
								and
									convert
									(
										datetime, _file.fecha_a) + ' ' + CONVERT(datetime, _file.time_a
									)
								between
									lis.fecha_real_viaje 
								and
									lis.fecha_real_fin_viaje
								-- Drop if don't need
-- =========================== Drop if don't need ================================================ --
							where 
									lis.casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|'))  
							--	and
							--		lis.company_id = 1
-- =========================== Drop if don't need ================================================ --

				) --DELETE FROM casetas_double WHERE RN<>1 
		-- =============== case GST =====================
		insert into @conciliations_dup_table
		select *
			--,null as 'CTE' 
			,
			case 
				when substring(replace(desc_caseta,' ',''),(len(replace(desc_caseta,' ',''))),1) <> '.' and RN = 1 and iave_cruce_id is not null
					then (select '1')
				when substring(replace(desc_caseta,' ',''),(len(replace(desc_caseta,' ',''))),1) = '.' and RN = 2 and iave_cruce_id is not null
					then (select '1') 
				when substring(replace(desc_caseta,' ',''),(len(replace(desc_caseta,' ',''))),1) <> '.' and RN > 2 and iave_cruce_id is not null
					then (select '3')
				when substring(replace(desc_caseta,' ',''),(len(replace(desc_caseta,' ',''))),1) = '.' and RN > 2 and iave_cruce_id is not null
					then (select '3') 
				else (select '2') 
			end as 'CTE'
		from casetas_double
		order by orden;



		--select * from @conciliations_dup_table where
		----					CTE = 3
		----				and 
		--				casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|')) 
		--				--and no_viaje in (select item from sistemas.dbo.fnSplit(@viaje, '|'))  


	insert into @percents
		select 
				 _fll.company_id,_fll.id_area,_fll.no_viaje,_fll.iave_catalogo as 'no_tarjeta_iave',_fll.fecha_ini as 'fecha_inicio',_fll.fecha_fin,_fll.fecha_real_viaje,_fll.fecha_real_fin_viaje,_fll.id_unidad,_fll.id_ruta,_fll.orden,_fll.desc_caseta as 'description_casetas',_fll.diff_length_hours,_fll.monto_iave as 'monto_caseta',_fll.no_de_ejes as 'lis_ejes',_fll.liq_monto_iave
				,con.alpha_location,con.unit,con.key_num_5,con._date as 'date_cruce',con.fecha_a as 'fecha_cruce',con.time_a as 'hora_cruce',con.iave_cruce_id,con.float_data as '_monto_archivo',con.key_num_4 as 'iave_ejes',con.alpha_num_code as 'iave_iave',con.float_data_1 as 'iave_caseta_id'
				,_fll.name,_fll.period_iave_id,con._filename,con._area as 'cia'
				,_fll.casetas_controls_files_id,_fll.casetas_historical_conciliations_id
				-- =========================== Sleuth Section ===============================
				,case 
					--when (con.iave_cruce_id is null and (cast(_fll.fecha_real_fin_viaje as date) > _fll.fecha_fin ) ) -- posible in next iave
					when (con.iave_cruce_id is null and (cast(_fll.fecha_real_fin_viaje as date) > ( select fecha_fin from sistemas.dbo.casetas_iave_periods where period_iave_id = _fll.period_iave_id) ) ) -- posible in next iave
						then
							5
					when (con.iave_cruce_id is null and (cast(_fll.fecha_real_fin_viaje as date) <= _fll.fecha_fin) ) -- with liq
						then
							5
					when (con.iave_cruce_id is not null ) -- successfull cross
						then
							1
				 end as 'casetas_standings_id'
				,case 
					--when (con.iave_cruce_id is null and (cast(_fll.fecha_real_fin_viaje as date) > _fll.fecha_fin ) ) -- posible in next iave
					when (con.iave_cruce_id is null and (cast(_fll.fecha_real_fin_viaje as date) > (select fecha_fin from sistemas.dbo.casetas_iave_periods where period_iave_id = _fll.period_iave_id) ) ) -- posible in next iave
						then
							8
					when (con.iave_cruce_id is null and (cast(_fll.fecha_real_fin_viaje as date) <= _fll.fecha_fin) ) -- with liq
						then
							5
					when (con.iave_cruce_id is not null )  -- successfull cross
						then
							1
				 end as 'casetas_parents_id'
				-- =========================== Sleuth Section ===============================
				--,* 
		from 
				sistemas.dbo.casetas_lis_full_conciliations as _fll
			left join
						(
							select * from @conciliations_dup_table where CTE = 1
						) as con on _fll.no_viaje = con.no_viaje and _fll.iave_catalogo = con.iave_catalogo and _fll.orden = con.orden
							and _fll.casetas_controls_files_id = con.casetas_controls_files_id 
-- =========================== Drop if don't need ================================================ --
		--where 
		--		_fll.casetas_controls_files_id = @ctrfile 
-- =========================== Drop if don't need ================================================ --
		;


-- =========================== Trips in next Period ================================================ --
--- add logic for next trips this goes in two engines

	if ((select options.switch from sistemas.dbo.casetas_options as options where options.option_name = 'next_period') = 1)
	  begin
	-- > find and delete old periods 
		delete from sistemas.dbo.casetas_lis_next_conciliations where casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|'));

--	select * from sistemas.dbo.casetas_lis_next_conciliations where casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|'));
-- =========================== Trips in next Period ================================================ --
			
			insert into sistemas.dbo.casetas_lis_next_conciliations

			select 
					 (_full.id) as 'lis_full_id'
					,(_full.period_iave_id + 1 ) as 'period_iave_id'
					,_full.fecha_ini
					,_full.fecha_fin
					,_full.no_viaje
					,_full.f_despachado
					,_full.id_area
					,_full.name
					,_full.cia
					,_full.company_id
					,_full.id_unidad
					,_full.iave_catalogo
					,_full.iave_viaje
					,_full.id_ruta
					,_full.desc_ruta
					,_full.id_caseta
					,_full.fecha_real_viaje
					,_full.fecha_real_fin_viaje
					,_full.diff_length_hours
					,_full.no_ejes_viaje
					,_full.no_tarjeta_llave
					,_full.orden
					,_full.consecutivo
					,_full.desc_caseta
					,_full.no_de_ejes
					,_full.monto_iave
					,_full.tarifas
					,_full.liq_tipo_pago
					,_full.liq_paso
					,_full.liq_id_caseta
					,_full.liq_monto_caseta
					,_full.liq_monto_iave
					,_full.liq_no_liquidacion
					,_full.trliq_fecha_ingreso
					,_full._filename
					,(_full.iave_period + 1 ) as 'iave_period'  
					,_full.casetas_controls_files_id
					,_full.casetas_historical_conciliations_id
					,_full.fecha_conciliacion
					,_full._modified
					,_full._status
			from 
					sistemas.dbo.casetas_lis_full_conciliations as _full

					left join 

					@percents as conciliato 
						on 
							conciliato.period_iave_id = _full.period_iave_id
						and 
							conciliato.company_id = _full.company_id
						and 
							conciliato.id_area = _full.id_area
						and 
							conciliato.no_tarjeta_iave = _full.iave_catalogo
						and
							conciliato.no_viaje = _full.no_viaje
						and
							conciliato.id_ruta = _full.id_ruta
						and
							conciliato.orden = _full.orden
						and
							conciliato.casetas_controls_files_id = _full.casetas_controls_files_id
			where 
					conciliato.casetas_standings_id = 5 and conciliato.casetas_parents_id = 8
				and 
					conciliato.casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|'))
			;
		end
-- =========================== Trips in next Period ================================================ --
		  

	insert into @casetas_conciliation
		select 
				--- ========= OLD TB MODULE ======== ---
				--id						int,
				 id_unidad
				,unit
				,no_tarjeta_iave
				,iave_iave as 'alpha_num_code'
				,alpha_location
				,_monto_archivo as 'alpha_location_1' -- do not have a use yet 
				,_filename
				,no_viaje
				,fecha_cruce
				,fecha_real_viaje as 'f_despachado'
				,fecha_real_fin_viaje as 'fecha_fin_viaje'
				,_monto_archivo as 'float_data' --monto again and comes from iave
				,hora_cruce
				,cia
				,_monto_archivo as 'Monto_archivo' --this come from iave
				,(null) as '_next'
				-- === Period Section ==== ---
				,fecha_inicio -- ref to period in new mod
				,fecha_fin -- ref to period in new mod
				-- === Period Section ==== ---
				,description_casetas -- refer to a description of liquidation in zam
				-- === Control Section ==== ---
				,casetas_historical_conciliations_id
 				,casetas_controls_files_id
				,(current_timestamp) as 'created'
				,(current_timestamp) as 'modified'
				,casetas_standings_id
				,casetas_parents_id
				,(1) as '_status'
				-- ===== START THE NEW MODULE ======= ---
				,company_id
				,id_area
				--,no_viaje				int
				--,no_tarjeta_iave		nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
				-- === Period Section ==== ---
				--,fecha_ini				date
				--,fecha_fin				date
				-- === ZAM Section ==== ---
				,fecha_real_viaje
				,fecha_real_fin_viaje
				,id_ruta
				,orden
				--,desc_caseta			nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- from liquidation
				,diff_length_hours
				,monto_caseta
				,lis_ejes
				,liq_monto_iave
				-- === Iave Section ==== ---
				--,alpha_location			nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
				,key_num_5
				--,fecha_a				date
				--,time_a				time
				,date_cruce
				,iave_cruce_id
				,_monto_archivo
				,iave_ejes
				,iave_iave -- tarjeta_iave
				,iave_caseta_id
				,name -- change for cia
				,period_iave_id
				--,_filename				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
					-- input user 
				--,cia					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS

				-- ===== END OF THE NEW MODULE ====== ---

				-- ===== Control Section  =========== ---
				--casetas_historical_conciliations_id int,
				--casetas_controls_files_id  int,

				--_casetas_status_id		int,
				--_casetas_parent_id		int,	
		from @percents 
					where 
							casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|'))  
						--and 
						--	casetas_standings_id = 1
						--and
						--	casetas_parents_id = 1
							

		--insert into @casetas_conciliation
-- =========================== Drop if don't need THIS !!! ================================================ --
									--and
									--	no_tarjeta_iave = @iav
-- =========================== Drop if don't need ================================================ --
								--and 
								--	no_viaje in (select item from sistemas.dbo.fnSplit(@viaje, '|'))  
-- =========================== Drop if don't need ================================================ --
--		order by company_id,id_area,no_viaje,orden;
insert into @casetas_conciliation
	select 
			    null as 'id_unidad', --			tci.id_unidad
				cas.unit COLLATE SQL_Latin1_General_CP1_CI_AS as 'unit', --		sc.unit
				null as 'no_tarjeta_iave', --			tci.no_tarjeta_iave
				cas.alpha_num_code COLLATE SQL_Latin1_General_CP1_CI_AS as 'alpha_num_code',
				cas.alpha_location COLLATE SQL_Latin1_General_CP1_CI_AS as 'alpha_location',
				cas.alpha_location_1 as 'alpha_location_1',
				cas._filename COLLATE SQL_Latin1_General_CP1_CI_AS as '_filename',
				null as 'no_viaje', --				tv.no_viaje
				cas.fecha_a as 'fecha_cruce',
				null as 'f_despachado', --			tv.f_despachado as f_despachado
				null as 'fecha_fin_viaje', --			tv.fecha_fin_viaje
				cas.float_data as 'float_data',
				cas.time_a as 'hora_cruce',
				cas._area COLLATE SQL_Latin1_General_CP1_CI_AS as 'cia',
				cas.float_data as 'Monto_archivo',
				null as 'next', --			next
				null as 'fecha_inicio',
				null as 'fecha_fin',
				null as 'description_casetas', --			description_casetas
				(select max(id) from sistemas.dbo.casetas_historical_conciliations as hist where hist.casetas_controls_files_id = cas.casetas_controls_files_id) as 'casetas_historical_conciliations_id',
				cas.casetas_controls_files_id as 'casetas_controls_files_id',
				current_timestamp as 'created',
				current_timestamp as 'modified',
				( 7 ) as 'casetas_standings_id',
				( 1 ) as 'casetas_parents_id' , 
				( 1 ) as '_status'
				,null as 'company_id'
				,null as 'id_area'
				,null as 'fecha_real_viaje'
				,null as 'fecha_real_fin_viaje'
				,null as 'id_ruta'
				,null as 'orden'
				,null as 'diff_length_hours'
				,null as 'monto_caseta'
				,null as 'lis_ejes'
				,null as 'liq_monto_iave'
				,cas.key_num_5 COLLATE SQL_Latin1_General_CP1_CI_AS	as 'key_num_5'
				,null as 'date_cruce'
				,cas.id as 'iave_cruce_id'
				,cas.float_data as '_monto_archivo'
				,cas.key_num_4 as 'iave_ejes'
				,cas.alpha_num_code COLLATE SQL_Latin1_General_CP1_CI_AS as 'iave_iave'
				,cas.float_data_1 as 'iave_caseta_id'
				,null as 'name'
				,cas.key_num_2 as 'period_iave_id'
		from 
				sistemas.dbo.casetas as cas 
		where
				cas.casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|'))
					and 
						cas.id 
							not in 
							(
								select 
										iave_cruce_id from @percents 
								where	
										casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|')) 
									and 
										iave_cruce_id is not null
								group by 
										iave_cruce_id
							)
		;

	
	
	
	select * from @casetas_conciliation where casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|')) 
	 
-- =========================== Drop if don't need THIS !!! ================================================ --
									--and
									--	no_tarjeta_iave = @iav
-- =========================== Drop if don't need ================================================ --
								--and 
								--	no_viaje in (select item from sistemas.dbo.fnSplit(@viaje, '|'))  
-- =========================== Drop if don't need ================================================ -- 
	
-- =========================== Uncomment for Percents ================================================ --
;with
		percents
				(
	
					 counts_lis_trips
					,counts_only_liquidation
					,iave_conciliations_counter
					,casetas_controls_files_id
				)
		as
				(
					select 
							   count(pts.period_iave_id) as 'counts_lis_trips'
							   ,sum
								(
								 case
									when
										pts.liq_monto_iave is not null
									then
											1
									else
											0
								end
							    ) as 'counts_only_liquidation'
							 -- no_viaje
							 --,fecha_ini				
							 --,fecha_fin				
							 --,fecha_real_viaje		
							 --,fecha_real_fin_viaje	
							 --,orden					
							 --,desc_caseta			
							 --,diff_length_hours		
							 --,monto_caseta			
							 --,liq_monto_iave		
							 --,alpha_location		
							 --,key_num_5				
							 --,fecha_a				
							 --,time_a				
							 --,iave_cruce_id
							 --,monto_archivo			
							 --,name					
							 --,period_iave_id
							 ,sum(
								case
									when pts.iave_cruce_id is not null
										then 
												1
										else 
												0
								end
							  ) as 'iave_conciliations_counter'
							  ,pts.casetas_controls_files_id
					from 
							@percents as pts 
					--where 
					--		pts.casetas_controls_files_id = @ctrfile 
					group by pts.casetas_controls_files_id
				)
			select 
					_percents.counts_lis_trips,_percents.counts_only_liquidation,_percents.iave_conciliations_counter
					,cruces.iave_cross_counts
					,case
						when _percents.counts_lis_trips is null OR _percents.counts_lis_trips = 0
							then 
								null
							else
								((_percents.iave_conciliations_counter * 100)/_percents.counts_lis_trips)
					  end as 'percent_cross_lis_vs_iave'
					 ,case 
						when cruces.iave_cross_counts is null OR cruces.iave_cross_counts = 0
							then 
								null
							else
								((_percents.iave_conciliations_counter * 100)/cruces.iave_cross_counts) 
					 end as 'percent_cross_iave_vs_lis'
					,case
						when _percents.counts_only_liquidation is null OR _percents.counts_only_liquidation = 0
							then
								null
							else
								((_percents.iave_conciliations_counter * 100)/_percents.counts_only_liquidation)
					end as 'percent_cross_lis_vs_iave_liq'
					,case
						when cruces.iave_cross_counts is null or cruces.iave_cross_counts = 0
						then
							null
						else
							((_percents.iave_conciliations_counter * 100)/cruces.iave_cross_counts)
					end as 'percent_cross_iave_vs_lis'
					,_percents.casetas_controls_files_id
			from 
					percents _percents
				left join
							(
								select count(cas.id) as 'iave_cross_counts',cas.casetas_controls_files_id 
								from sistemas.dbo.casetas as cas
								group by casetas_controls_files_id
							)
				as cruces on cruces.casetas_controls_files_id = _percents.casetas_controls_files_id
			-- ===================== DROP THIS ==============================================================
			where cruces.casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|'))  
			-- ===================== DROP THIS ==============================================================
			group by
					 cruces.iave_cross_counts
					,_percents.counts_lis_trips
					,_percents.counts_only_liquidation
					,_percents.iave_conciliations_counter 
					,_percents.casetas_controls_files_id

-- =========================== Uncomment for Percents ================================================ --


--select *
----delete
--from sistemas.dbo.casetas where casetas_controls_files_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|'))  
---- =========================== Drop if don't need and THIS !!! ================================================ --
----and alpha_num_code = @iav
---- =========================== Drop if don't need ================================================ --
--order by fecha_a , time_a

-- exec sp_upt_tollbooth_zam_trips_records_conciliation;

go


--select iave_catalogo,id_unidad from sistemas.dbo.casetas_lis_full_conciliations where casetas_controls_files_id = '135' group by iave_catalogo,id_unidad

--select alpha_num_code,unit from sistemas.dbo.casetas	where casetas_controls_files_id = '135' group by alpha_num_code,unit

