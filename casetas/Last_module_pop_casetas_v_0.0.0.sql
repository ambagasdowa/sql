Use sistemas;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
/*=============================================================================================================
 Authors        : Jesus Baizabal (Just following Orders From Torres) and Torres Director of Teisa
 email          : baizabal.jesus@gmail.com 
 Create date    : May 16, 2016
 Description    : gst_casetas_conciliacion/gst_tollbooth
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : GST Feltes y Servicios, s.a de c.v
 @status        : Stable
 @version        : 1.0.0
 ==============================================================================================================*/

ALTER PROCEDURE sp_tollbooth_poop
(
	@bussines_unit int,
	@casetas_controls_files_id int,
	@user_id int
)
With Encryption
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @id_cursor as int;
declare @ctrfile as nvarchar(4000); set @ctrfile = cast(@casetas_controls_files_id as nvarchar(4000))
-- set declare
Declare @company_id as int,@conciliation_id as int,@casetas_historical_conciliations_id as int;
--set @bussines_unit = '8'; -- this is teisa
set @company_id = (select casetas_corporations_id from dbo.casetas_units where id = @bussines_unit)

insert into casetas_logs values ('control_id',@casetas_controls_files_id,CURRENT_TIMESTAMP),
								('bussiness_id',@bussines_unit,CURRENT_TIMESTAMP),
								('user_id',@user_id,CURRENT_TIMESTAMP),
								('company_id',@company_id,CURRENT_TIMESTAMP);
				
		
		
set @conciliation_id = (select conciliations_count from casetas_controls_conciliations where casetas_controls_files_id = @casetas_controls_files_id and _status = 1)
--select unit.casetas_units_name from dbo.casetas_units as unit inner join dbo.casetas_companies as cpny on unit.companies_id = cpny.id where cpny.id = @company_id 
--select * from dbo.casetas_units as unit inner join dbo.casetas_companies as cpny on unit.companies_id = cpny.id where unit.id = @bussines_unit

insert into casetas_logs values ('conciliation_id',@conciliation_id,CURRENT_TIMESTAMP);

declare -- Declaration of the variables for cursor
        @id as int,@id_unidad as nvarchar(25),@unit as nvarchar(25), @no_tarjeta_iave as nvarchar(100), @alpha_num_code as nvarchar(25),
        @alpha_location as nvarchar(250),@alpha_location_1 as nvarchar(250),@_filename as nvarchar(150),@no_viaje as int, @fecha_cruce as date,
        @f_despachado as nvarchar(120), @fecha_fin_viaje as nvarchar(120),@float_data as decimal(18,4),@hora_cruce as time(7), @cia as nvarchar(25),
        @Monto_archivo as decimal(18,4),
		@_next as date,
		@fecha_inicio as date , @fecha_fin as date, @description_casetas as nvarchar(300),
		--
		--@casetas_controls_files_id as int,
		@created as datetime, @modified as datetime,
		@_casetas_status_id as int, @_casetas_parent_id as int, @_status as tinyint;

		--set @casetas_controls_files = 1;
		set @created = (select CURRENT_TIMESTAMP);
		set @modified = (select CURRENT_TIMESTAMP);
		set @_casetas_status_id =1;
		set @_casetas_parent_id =1;
		set @_status = 1;


--historical exists ?? 
		insert into sistemas.dbo.casetas_historical_conciliations 
		values (@user_id,@casetas_controls_files_id,null,null,CURRENT_TIMESTAMP,null,@_casetas_status_id,@_casetas_parent_id,@_status)

		set @casetas_historical_conciliations_id = (select max(id) from sistemas.dbo.casetas_historical_conciliations as hist where hist.casetas_controls_files_id = @casetas_controls_files_id)
		
		

		insert into casetas_logs values ('casetas_historical_conciliations_id',@casetas_historical_conciliations_id,CURRENT_TIMESTAMP);
--temporal table declaration
declare @casetas_table as table
                                (
                                    id_tmp  int,
                                    alpha_num_code_tmp  nvarchar(25),
									casetas_controls_files_id_tmp int,
                                    cia_tmp  nvarchar(25)
                                );


-- =========== poop core ========== ---



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
	--declare @percents as table
	--(
	--  company_id			int
	-- ,id_area				int
	-- ,no_viaje				int
	-- ,no_tarjeta_iave		nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	-- --iave_period
	-- ,fecha_inicio			date
	-- ,fecha_fin				date
	-- --lis
	-- ,fecha_real_viaje		datetime
	-- ,fecha_real_fin_viaje	datetime
	-- ,id_unidad				nvarchar(25) collate	sql_latin1_general_cp1_ci_as
	-- ,id_ruta				int
	-- ,orden					int
	-- ,description_casetas	nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	-- ,diff_length_hours		int
	-- ,monto_caseta			decimal(18,6)
	-- ,lis_ejes				int
	-- ,liq_monto_iave		decimal(18,6)
	-- --iave
	-- ,alpha_location		nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	-- ,unit					nvarchar(25) collate	sql_latin1_general_cp1_ci_as
	-- ,key_num_5				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	-- ,date_cruce			datetime
	-- ,fecha_cruce			date
	-- ,hora_cruce			time
	-- ,iave_cruce_id			int
	-- ,_monto_archivo			decimal(18,4)
	-- ,iave_ejes				int
	-- ,iave_iave				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	-- ,iave_caseta_id		int
	-- ,name					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	-- ,period_iave_id		int
	-- ,_filename				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	-- -- input user 
	-- ,cia					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
	-- --control
 --	 ,casetas_controls_files_id				int
	-- ,casetas_historical_conciliations_id	int
	-- ,casetas_standings_id					int
	-- ,casetas_parents_id					int
	--)
		-- print @company_id;print @created;
declare @casetas_records_duplicates as table
                                    (
										--- ========= OLD TB MODULE ======== ---
                                        id						int,
                                        id_unidad				nvarchar(25)
                                        ,unit					nvarchar(25)
                                        ,no_tarjeta_iave			nvarchar(100)
                                        ,alpha_num_code			nvarchar(25)
                                        ,alpha_location			nvarchar(250)
                                        ,alpha_location_1		nvarchar(60) -- do not have a use yet 
                                        ,_filename				nvarchar(150)
                                        ,no_viaje				int
                                        ,fecha_cruce				date
                                        ,f_despachado			datetime 
                                        ,fecha_fin_viaje			datetime 
                                        ,float_data				decimal(18,4) --monto again and comes from iave
                                        ,hora_cruce				time(7)
                                        ,cia						nvarchar(25)
                                        ,Monto_archivo			decimal(18,4) --this come from iave
										,_next					date
										-- === Period Section ==== ---
                                        ,fecha_inicio			date -- ref to period in new mod
                                        ,fecha_fin				date -- ref to period in new mod
										-- === Period Section ==== ---
										,description_casetas		nvarchar(300) -- refer to a description of liquidation in zam
										-- === Control Section ==== ---
										,casetas_historical_conciliations_id	int
 										,casetas_controls_files_id				int
										,created								datetime
										,modified								datetime
										,casetas_standings_id					int
										,casetas_parents_id					int
										,_status					tinyint default 1 null
										-- ===== START THE NEW MODULE ======= ---
										,company_id			int
										,id_area				int
										--,no_viaje				int
										--,no_tarjeta_iave		nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										-- === Period Section ==== ---
										--,fecha_ini				date
										--,fecha_fin				date
										-- === ZAM Section ==== ---
										,fecha_real_viaje		datetime
										,fecha_real_fin_viaje	datetime
										,id_ruta				int
										,orden					int
										--,desc_caseta			nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- from liquidation
										,diff_length_hours		int
										,monto_caseta			decimal(18,6)
										,lis_ejes				int
										,liq_monto_iave			decimal(18,6)
										-- === Iave Section ==== ---
										--,alpha_location			nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										,key_num_5				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										--,fecha_a				date
										--,time_a				time
										,date_cruce				datetime
										,iave_cruce_id			int
										,_monto_archivo			decimal(18,4)
										,iave_ejes				int
										,iave_iave				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- tarjeta_iave
										,iave_caseta_id			int
										,name					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- change for cia
										,period_iave_id			int
										,Duplicates				int
										--,_filename				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										 -- input user 
										--,cia					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS

										-- ===== END OF THE NEW MODULE ====== ---

										-- ===== Control Section  =========== ---
										--casetas_historical_conciliations_id int,
										--casetas_controls_files_id  int,

										--_casetas_status_id		int,
										--_casetas_parent_id		int,

                                    );


declare @casetas_records as table
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
										,iave_iave				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS 
										,iave_caseta_id			int
										,name					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS 
										,period_iave_id			int
                                    );

declare @casetas_records_same_trips as table
                                    (
										--- ========= OLD TB MODULE ======== ---
                                        id						int,
                                        id_unidad				nvarchar(25)
                                        ,unit					nvarchar(25)
                                        ,no_tarjeta_iave			nvarchar(100)
                                        ,alpha_num_code			nvarchar(25)
                                        ,alpha_location			nvarchar(250)
                                        ,alpha_location_1		nvarchar(60) -- do not have a use yet 
                                        ,_filename				nvarchar(150)
                                        ,no_viaje				int
                                        ,fecha_cruce				date
                                        ,f_despachado			datetime 
                                        ,fecha_fin_viaje			datetime 
                                        ,float_data				decimal(18,4) --monto again and comes from iave
                                        ,hora_cruce				time(7)
                                        ,cia						nvarchar(25)
                                        ,Monto_archivo			decimal(18,4) --this come from iave
										,_next					date
										-- === Period Section ==== ---
                                        ,fecha_inicio			date -- ref to period in new mod
                                        ,fecha_fin				date -- ref to period in new mod
										-- === Period Section ==== ---
										,description_casetas		nvarchar(300) -- refer to a description of liquidation in zam
										-- === Control Section ==== ---
										,casetas_historical_conciliations_id	int
 										,casetas_controls_files_id				int
										,created								datetime
										,modified								datetime
										,casetas_standings_id					int
										,casetas_parents_id					int
										,_status					tinyint default 1 null
										-- ===== START THE NEW MODULE ======= ---
										,company_id			int
										,id_area				int
										--,no_viaje				int
										--,no_tarjeta_iave		nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										-- === Period Section ==== ---
										--,fecha_ini				date
										--,fecha_fin				date
										-- === ZAM Section ==== ---
										,fecha_real_viaje		datetime
										,fecha_real_fin_viaje	datetime
										,id_ruta				int
										,orden					int
										--,desc_caseta			nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- from liquidation
										,diff_length_hours		int
										,monto_caseta			decimal(18,6)
										,lis_ejes				int
										,liq_monto_iave			decimal(18,6)
										-- === Iave Section ==== ---
										--,alpha_location			nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										,key_num_5				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										--,fecha_a				date
										--,time_a				time
										,date_cruce				datetime
										,iave_cruce_id			int
										,_monto_archivo			decimal(18,4)
										,iave_ejes				int
										,iave_iave				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- tarjeta_iave
										,iave_caseta_id			int
										,name					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- change for cia
										,period_iave_id			int
										,Duplicates				int
										--,_filename				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
										 -- input user 
										--,cia					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS

										-- ===== END OF THE NEW MODULE ====== ---

										-- ===== Control Section  =========== ---
										--casetas_historical_conciliations_id int,
										--casetas_controls_files_id  int,

										--_casetas_status_id		int,
										--_casetas_parent_id		int,

                                    );
/** OK then thanks to the great and usseless sql from Mocosoft*/
/** this query must be check because the id is repeating */

        ------------------------- drop ---------------------------------------------

;with casetas_pop_concilations as 
								(
									select	
											 --lis.company_id,lis.id_area,lis.no_viaje
											 lis.iave_catalogo as 'no_tarjeta_iave'
											 ,lis.fecha_ini as 'fecha_inicio'
											 --,lis.fecha_fin,lis.fecha_real_viaje
											 --,lis.fecha_real_fin_viaje,lis.id_unidad,lis.id_ruta,lis.orden
											 ,lis.desc_caseta as 'description_casetas'
											 --,lis.diff_length_hours
											 ,lis.monto_iave as 'monto_caseta',lis.no_de_ejes as 'lis_ejes'
											 --,lis.liq_monto_iave
											 --,lis.name,lis.period_iave_id
											 --,lis.casetas_controls_files_id,lis.casetas_historical_conciliations_id
											 ,*
											 ,ROW_NUMBER() OVER 
																(
																	PARTITION BY 
																			lis.casetas_controls_files_id,lis.company_id,lis.id_area--,lis.no_viaje
																			,lis.iave_catalogo,(select cast(rtrim(replace(lis.desc_caseta,'.','')) as nvarchar(50)) COLLATE SQL_Latin1_General_CP1_CI_AS)
																	ORDER BY 
																			lis.casetas_controls_files_id,lis.company_id,lis.id_area--,lis.no_viaje
																			,lis.iave_catalogo,lis.no_viaje,lis.desc_caseta
																) AS consec
									from 
											--sistemas.dbo.casetas as _file
											sistemas.dbo.casetas_lis_full_conciliations as lis
									where 
											lis.casetas_controls_files_id 
																			in 
																			(
																				select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|')
																			)  
								)
insert into @percents
					select 
						--- ========= OLD TB MODULE ======== ---
						--id						int,
						 pop.id_unidad
						,trash.unit
						,pop.no_tarjeta_iave
						,trash.iave_iave as 'alpha_num_code'
						,trash.alpha_location
						,trash._monto_archivo as 'alpha_location_1' -- do not have a use yet 
						,trash._filename
						,pop.no_viaje
						,trash.fecha_cruce
						,pop.fecha_real_viaje as 'f_despachado'
						,pop.fecha_real_fin_viaje as 'fecha_fin_viaje'
						,trash._monto_archivo as 'float_data' --monto again and comes from iave
						,trash.hora_cruce
						,trash.cia
						,trash._monto_archivo as 'Monto_archivo' --this come from iave
						,(null) as '_next'
						-- === Period Section ==== ---
						,pop.fecha_inicio -- ref to period in new mod
						,pop.fecha_fin -- ref to period in new mod
						-- === Period Section ==== ---
						,pop.description_casetas -- refer to a description of liquidation in zam
						-- === Control Section ==== ---
						,pop.casetas_historical_conciliations_id
 						,pop.casetas_controls_files_id
						,(current_timestamp) as 'created'
						,(current_timestamp) as 'modified'
						,case 
							when (trash.iave_cruce_id is null and (cast(pop.fecha_real_fin_viaje as date) > (select fecha_fin from sistemas.dbo.casetas_iave_periods where period_iave_id = pop.period_iave_id) ) ) -- posible in next iave
								then
									5
							when (trash.iave_cruce_id is null and (cast(pop.fecha_real_fin_viaje as date) <= pop.fecha_fin) ) -- with liq
								then
									5
							when (trash.iave_cruce_id is not null ) -- successfull cross
								then
									1
						 end as 'casetas_standings_id'
						,case 
							when (trash.iave_cruce_id is null and (cast(pop.fecha_real_fin_viaje as date) > (select fecha_fin from sistemas.dbo.casetas_iave_periods where period_iave_id = pop.period_iave_id) ) ) -- posible in next iave
								then
									8
							when (trash.iave_cruce_id is null and (cast(pop.fecha_real_fin_viaje as date) <= pop.fecha_fin) ) -- with liq
								then
									5
							when (trash.iave_cruce_id is not null )  -- successfull cross
								then
									1
						 end as 'casetas_parents_id'
						,(1) as '_status'
						-- ===== START THE NEW MODULE ======= ---
						,pop.company_id
						,pop.id_area
						--,no_viaje				int
						--,no_tarjeta_iave		nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
						-- === Period Section ==== ---
						--,fecha_ini				date
						--,fecha_fin				date
						-- === ZAM Section ==== ---
						,pop.fecha_real_viaje
						,pop.fecha_real_fin_viaje
						,pop.id_ruta
						,pop.orden
						--,desc_caseta			nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS -- from liquidation
						,pop.diff_length_hours
						,pop.monto_caseta
						,pop.lis_ejes
						,pop.liq_monto_iave
						-- === Iave Section ==== ---
						--,alpha_location			nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
						,trash.key_num_5
						--,fecha_a				date
						--,time_a				time
						,trash.date_cruce
						,trash.iave_cruce_id
						,trash._monto_archivo
						,trash.iave_ejes
						,trash.iave_iave -- tarjeta_iave
						,trash.iave_caseta_id
						,pop.name -- change for cia
						,pop.period_iave_id
						--,_filename				nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS
							-- input user 
						--,cia					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS

						-- ===== END OF THE NEW MODULE ====== ---

						-- ===== Control Section  =========== ---
						--casetas_historical_conciliations_id int,
						--casetas_controls_files_id  int,

						--_casetas_status_id		int,
						--_casetas_parent_id		int,	
					from 
							casetas_pop_concilations as pop

							left join 
										(

											select 
													 shit.unit
													,(select ( convert(datetime, shit.fecha_a) + ' ' + CONVERT(datetime, shit.time_a))) as 'date_cruce'
													,shit.float_data as '_monto_archivo',shit.key_num_4 as 'iave_ejes'
													,shit.alpha_num_code as 'iave_iave'
													,shit._area as 'cia'
													,(
															case
																when cast(shit.float_data_1 as int) 
																				in 
																					(
																						select 
																								id_iave.casetas_iave_id 
																						from 
																								sistemas.dbo.casetas_iave_caseta_descriptions as id_iave 
																						where 
																								id_iave._status = 1
																					)
																	then 
																		shit.alpha_location
																	else	
																		shit.key_num_5 
															end
													 ) as 'key_num_5'
													,shit.alpha_location,shit.alpha_num_code
													,shit.fecha_a as 'fecha_cruce',shit.time_a as 'hora_cruce',shit.id as 'iave_cruce_id',shit.float_data
													,shit.key_num_4,cast(shit.float_data_1 as int) as 'float_data_1',cast(shit.float_data_1 as int) as 'iave_caseta_id'
													,shit._filename,shit._area
													,ROW_NUMBER() OVER 
																		(
																			PARTITION BY 
																					shit.casetas_controls_files_id,shit._area
																					,shit.alpha_num_code
																					,(
																							case
																								when cast(shit.float_data_1 as int) 
																									in 
																										(
																											select 
																													id_iave.casetas_iave_id 
																											from 
																													sistemas.dbo.casetas_iave_caseta_descriptions as id_iave 
																											where 
																													id_iave._status = 1
																										)
																									then 
																										shit.alpha_location
																									else	
																										shit.key_num_5 
																							end
																					 )
																			ORDER BY 
																					 shit.casetas_controls_files_id,shit._area
																					,shit.alpha_num_code
																		) AS consec
											from 
													sistemas.dbo.casetas as shit
											where 
													casetas_controls_files_id 
																				in 
																				(
																					select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@ctrfile, '|')
																				)  

										) as trash 
											on 
												trash.alpha_num_code = (cast(pop.iave_catalogo as nvarchar(50)) COLLATE SQL_Latin1_General_CP1_CI_AS) 
											and 
												trash.consec = pop.consec
											and
												cast(replace(trash.key_num_5,'.','') as nvarchar(50)) COLLATE SQL_Latin1_General_CP1_CI_AS = (cast(replace(pop.desc_caseta,'.','') as nvarchar(50)) COLLATE SQL_Latin1_General_CP1_CI_AS)
											and 
												(month(trash.fecha_cruce) = month(pop.fecha_ini)) 
											and
												(year(trash.fecha_cruce) = year(pop.fecha_ini))
					order by 
							pop.iave_catalogo,pop.desc_caseta
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
							conciliato.no_tarjeta_iave = cast(_full.iave_catalogo as nvarchar(255)) COLLATE SQL_Latin1_General_CP1_CI_AS
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
		  


	insert into @casetas_records
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
				,(select @casetas_historical_conciliations_id) as 'casetas_historical_conciliations_id'
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
							;

		--insert into @casetas_conciliation
-- =========================== Drop if don't need THIS !!! ================================================ --
									--and
									--	no_tarjeta_iave = @iav
-- =========================== Drop if don't need ================================================ --
								--and 
								--	no_viaje in (select item from sistemas.dbo.fnSplit(@viaje, '|'))  
-- =========================== Drop if don't need ================================================ --
--		order by company_id,id_area,no_viaje,orden;
insert into @casetas_records
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
				(select @casetas_historical_conciliations_id) as 'casetas_historical_conciliations_id',
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
-- ====== poop core ============ ---

insert into sistemas.dbo.casetas_views
	select * from @casetas_records;
		------------------------- drop ---------------------------------------------


		--Update the status of the file in casetas_controls_files
		update sistemas.dbo.casetas_controls_files set casetas_standings_id = 11 where id = @casetas_controls_files_id ;
		update sistemas.dbo.casetas_controls_conciliations set conciliations_count = (isnull(conciliations_count,0) + 1) where casetas_controls_files_id = @casetas_controls_files_id
		
		insert into casetas_logs values ('historica_id',(select conciliations_count from sistemas.dbo.casetas_controls_conciliations where casetas_controls_files_id = @casetas_controls_files_id),CURRENT_TIMESTAMP);

		------------------------- drop ---------------------------------------------


		------------------------- drop ---------------------------------------------			



		insert into casetas_logs values ('a_control_id',@casetas_controls_files_id,CURRENT_TIMESTAMP),
										('a_bussiness_id',@bussines_unit,CURRENT_TIMESTAMP),
										('a_user_id',@user_id,CURRENT_TIMESTAMP),
										('a_company_id',@company_id,CURRENT_TIMESTAMP);
		--unidades sin viaje WORK FROM HIR
		update notcasetas 
			set notcasetas.casetas_standings_id = 6 
			from sistemas.dbo.casetas_views  as notcasetas 
			where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
				and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
				and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null and substring(notcasetas.unit, 1,2) = 'TT'
				and notcasetas.casetas_standings_id not in (5,3);
		
		-- > Fail for iave if checks for cross in distinc month or year
		update notcasetas 
			set notcasetas.casetas_parents_id = 11 -- for months 
			from sistemas.dbo.casetas_views  as notcasetas 
			where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
				and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
				and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null and substring(notcasetas.unit, 1,2) = 'TT'
				and notcasetas.casetas_standings_id not in (5,3)
				and month(notcasetas.fecha_cruce) <> (select month(fecha_ini) from sistemas.dbo.casetas_iave_periods where period_iave_id = (select _fraction from sistemas.dbo.casetas_controls_files where id = @casetas_controls_files_id))
			;
		update notcasetas 
			set notcasetas.casetas_parents_id = 12 -- for year
			from sistemas.dbo.casetas_views  as notcasetas 
			where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
				and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
				and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null and substring(notcasetas.unit, 1,2) = 'TT'
				and notcasetas.casetas_standings_id not in (5,3)
				and year(notcasetas.fecha_cruce) <> (select year(fecha_ini) from sistemas.dbo.casetas_iave_periods where period_iave_id = (select _fraction from sistemas.dbo.casetas_controls_files where id = @casetas_controls_files_id))
			;			
		-- > Fail for iave if checks for cross in distinc month or year
			
		--update notcasetas 
		--	set notcasetas.casetas_standings_id = 7 
		--	from sistemas.dbo.casetas_views  as notcasetas 
		--	where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
		--		and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
		--		and notcasetas._next is null and notcasetas.id_unidad is null and substring(notcasetas.unit, 1,2) = 'UT' 
		--		OR substring(notcasetas.unit, 1,4) = 'LOBO'


		update notcasetas 
			set notcasetas.casetas_standings_id = 9
			from sistemas.dbo.casetas_views  as notcasetas 
			where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
			and casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
			and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null and substring(notcasetas.unit, 1,2) <> 'TT' 
			and substring(notcasetas.unit, 1,2) <> '00'
			and notcasetas.casetas_standings_id not in (5,3);



			insert into @casetas_records_duplicates
			select 
					*
					,ROW_NUMBER() OVER 
					(
						PARTITION BY 
							casetas_controls_files_id
							,company_id
							,id_area
							,no_tarjeta_iave
							,no_viaje
							,iave_cruce_id
							,date_cruce 
						ORDER BY 
							casetas_controls_files_id
							,company_id
							,id_area
							,no_tarjeta_iave
							,no_viaje
							,iave_cruce_id
							,date_cruce
					) AS Duplicate 
			from 
				sistemas.dbo.casetas_views 
			where 
					casetas_controls_files_id = @casetas_controls_files_id  
				and casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
				and iave_cruce_id is not null
				and casetas_standings_id in (1);

			update notcasetas 
			set notcasetas.casetas_parents_id = 7
			from sistemas.dbo.casetas_views  as notcasetas 
			where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
			and casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
			and notcasetas.id in 
			(
				select dupl.id from @casetas_records_duplicates as dupl where 
					dupl.casetas_controls_files_id = @casetas_controls_files_id  
				and
					dupl.casetas_historical_conciliations_id = @casetas_historical_conciliations_id
				and Duplicates > 1
			)
			and notcasetas.casetas_standings_id not in (5,3);

			-- ===================== MUAHAHAHAHAH DOLORES ! Date Ranks With inconsistences ====================== --

			;with  duplicates
				as (
				select 
						*
						,ROW_NUMBER() OVER (
												PARTITION BY 
													casetas_controls_files_id
													,company_id
													,id_area
													,no_tarjeta_iave
													--,no_viaje
													,iave_cruce_id
													,date_cruce 
												ORDER BY 
													casetas_controls_files_id
													,company_id
													,id_area
													,no_tarjeta_iave
													--,no_viaje
													,iave_cruce_id
													,date_cruce
											)
					  AS Duplicate 
				from sistemas.dbo.casetas_views where 
												casetas_controls_files_id = @casetas_controls_files_id  
												and casetas_historical_conciliations_id = @casetas_historical_conciliations_id
												and iave_cruce_id is not null
												and casetas_standings_id in (1)
				)
				insert into @casetas_records_same_trips
						select 
							*
						from duplicates as casDup
						where 
								casDup.casetas_controls_files_id = @casetas_controls_files_id  
							and 
								casDup.casetas_historical_conciliations_id = @casetas_historical_conciliations_id
							--and 
							--	Duplicate > 1
						;

				
				update notcasetas 
				set notcasetas.casetas_parents_id = 9
				from sistemas.dbo.casetas_views  as notcasetas 
				where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
				and casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
				and notcasetas.casetas_standings_id not in (5,3)
				and notcasetas.id in
					(
						select 
							Dup.id
						from @casetas_records_same_trips as Dup
						where 
								Dup.casetas_controls_files_id = @casetas_controls_files_id  
							and 
								Dup.casetas_historical_conciliations_id = @casetas_historical_conciliations_id
							and 
								Dup.Duplicates > 1
					)
			 ;
			-- ===================== Rango de Fechas With inconsistences ====================== --

				update notcasetas 
				set notcasetas.casetas_parents_id = 5
				from sistemas.dbo.casetas_views  as notcasetas 
				where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
				and casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
				and notcasetas.casetas_standings_id not in (5,3)
				and notcasetas.id in
					(
						select 
							Dup.id
						from @casetas_records_same_trips as Dup
						where 
								Dup.casetas_controls_files_id = @casetas_controls_files_id  
							and 
								Dup.casetas_historical_conciliations_id = @casetas_historical_conciliations_id
							and 
								Dup.Duplicates = 1
					);

	
----------------------------------------------------------------------------------------------------------------------------------------------
	-- 00000 from i+d clasification
----------------------------------------------------------------------------------------------------------------------------------------------

		if @company_id = 1
			begin 
				update notcasetas 
					set 
						notcasetas.casetas_standings_id = 6 ,
						notcasetas.id_unidad = (
															select 
																(select cast(id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																bonampakdb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  = 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
												)
					from sistemas.dbo.casetas_views  as notcasetas 
					where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
						and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
						and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null  and substring(notcasetas.unit, 1,2) = '00'
						and notcasetas.alpha_num_code = (
															select (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from bonampakdb.dbo.trafico_catiaveunidoper 
															where ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  = 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
														 )
						and notcasetas.casetas_standings_id not in (5,3);

				update notcasetas 
					set 
						notcasetas.casetas_standings_id = 9,
						notcasetas.id_unidad = (
															select 
																(select cast(id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																bonampakdb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  <> 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
												)
					from sistemas.dbo.casetas_views  as notcasetas 
					where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
						and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
						and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null  and substring(notcasetas.unit, 1,2) = '00'
						and notcasetas.alpha_num_code = (
															select 
																(select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																bonampakdb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  <> 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
														 )
						and notcasetas.casetas_standings_id not in (5,3);
			end

		if @company_id = 2
			begin 
				update notcasetas 
					set 
						notcasetas.casetas_standings_id = 6 ,
						notcasetas.id_unidad = (
															select 
																(select cast(id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																macuspanadb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  = 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
												)
					from sistemas.dbo.casetas_views  as notcasetas 
					where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
						and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
						and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null  and substring(notcasetas.unit, 1,2) = '00'
						and notcasetas.alpha_num_code = (
															select (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from macuspanadb.dbo.trafico_catiaveunidoper 
															where ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  = 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
														 )
						and notcasetas.casetas_standings_id not in (5,3);
				update notcasetas 
					set 
						notcasetas.casetas_standings_id = 9,
						notcasetas.id_unidad = (
															select 
																(select cast(id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																macuspanadb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  <> 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
												)
					from sistemas.dbo.casetas_views  as notcasetas 
					where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
						and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
						and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null  and substring(notcasetas.unit, 1,2) = '00'
						and notcasetas.alpha_num_code = (
															select 
																(select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																macuspanadb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  <> 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
														 )
						and notcasetas.casetas_standings_id not in (5,3);
			end

		if @company_id = 3
			begin 
				update notcasetas 
					set 
						notcasetas.casetas_standings_id = 6 ,
						notcasetas.id_unidad = (
															select 
																(select cast(id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																tespecializadadb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  = 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
												)
					from sistemas.dbo.casetas_views  as notcasetas 
					where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
						and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
						and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null  and substring(notcasetas.unit, 1,2) = '00'
						and notcasetas.alpha_num_code = (
															select (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from tespecializadadb.dbo.trafico_catiaveunidoper 
															where ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  = 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
														 )
						and notcasetas.casetas_standings_id not in (5,3);
				update notcasetas 
					set 
						notcasetas.casetas_standings_id = 9,
						notcasetas.id_unidad = (
															select 
																(select cast(id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																tespecializadadb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  <> 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
												)
					from sistemas.dbo.casetas_views  as notcasetas 
					where notcasetas.casetas_controls_files_id = @casetas_controls_files_id  
						and notcasetas.casetas_historical_conciliations_id = @casetas_historical_conciliations_id 
						and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null  and substring(notcasetas.unit, 1,2) = '00'
						and notcasetas.alpha_num_code = (
															select 
																(select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) as 'no_tarjeta_iave'
															from 
																tespecializadadb.dbo.trafico_catiaveunidoper 
															where 
																ultimo_mov = 1 
																	and SUBSTRING( (select cast( id_unidad collate sql_latin1_general_cp1_ci_as as nvarchar(50)))  ,1,2)  <> 'TT'
																	and (select cast(no_tarjeta_iave collate sql_latin1_general_cp1_ci_as as nvarchar(50))) = notcasetas.alpha_num_code
														 )
						and notcasetas.casetas_standings_id not in (5,3);
			end

----------------------------------------------------------------------------------------------------------------------------------------------
	-- 00000 from i+d clasification
----------------------------------------------------------------------------------------------------------------------------------------------

-- - =============================================================================================================
-- - Update info in dashboard
-- - =============================================================================================================
	
		update sistemas.dbo.casetas_historical_conciliations 
				set monto_conciliado = (
											select sum(Monto_archivo) 
											from sistemas.dbo.casetas_views 
											where	
													casetas_controls_files_id = @casetas_controls_files_id 
												and 
													casetas_historical_conciliations_id = @casetas_historical_conciliations_id
												and
													casetas_standings_id in (1)
										) 
				where 
					casetas_controls_files_id = @casetas_controls_files_id and id = @casetas_historical_conciliations_id;

		update sistemas.dbo.casetas_historical_conciliations 
				set cruces_conciliados = (
											select count(id) 
											from sistemas.dbo.casetas_views 
											where	
													casetas_controls_files_id = @casetas_controls_files_id 
												and 
													casetas_historical_conciliations_id = @casetas_historical_conciliations_id
												and
													casetas_standings_id in (1)
										)
				where 
					casetas_controls_files_id = @casetas_controls_files_id and id = @casetas_historical_conciliations_id;

END
GO

--exec sp_upt_tollbooth_zam_trips_records_conciliation

--3:15
-- exec sistemas.dbo.sp_tollbooth_net 4,134,1


 --truncate table sistemas.dbo.casetas_tiger_runs
 --truncate table sistemas.dbo.casetas_logs
 --truncate table sistemas.dbo.casetas_views
 --truncate table sistemas.dbo.casetas_controls_files
 --truncate table sistemas.dbo.casetas_controls_conciliations
 --truncate table sistemas.dbo.casetas_historical_conciliations
 --truncate table sistemas.dbo.casetas










