Use sistemas;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
/*======================================================================================================
 Authors        : Jesus Baizabal (ProcedureProgramation&TableSquemaDesign as Core) and Adrian (Query)
 email          : baizabal.jesus@gmail.com and adrian.turru@gmail.com
 Create date    : May 16, 2016
 Description    : gst_casetas_conciliacion/gst_tollbooth
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : GST Feltes y Servicios, s.a de c.v
 @status        : Stable
 @version        : 1.0.0
 ======================================================================================================*/

ALTER PROCEDURE sp_tollbooth
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
                                )

		-- print @company_id;print @created;
declare @casetas_records as table
                                    (
                                        --id						int,
                                        id_unidad				nvarchar(25),
                                        unit					nvarchar(25),
                                        no_tarjeta_iave			nvarchar(100),
                                        alpha_num_code			nvarchar(25),
                                        alpha_location			nvarchar(250),
                                        alpha_location_1		nvarchar(60),
                                        _filename				nvarchar(150),
                                        no_viaje				int,
                                        fecha_cruce				date,
                                        f_despachado			datetime,
                                        fecha_fin_viaje			datetime,
                                        float_data				decimal(18,4),
                                        hora_cruce				time(7),
                                        cia						nvarchar(25),
                                        Monto_archivo			decimal(18,4),
										_next					date,
                                        fecha_inicio			date,
                                        fecha_fin				date,
										description_casetas		nvarchar(300),
										--
										casetas_historical_conciliations_id int,
										casetas_controls_files_id  int,
										created					datetime,
										modified				datetime,
										_casetas_status_id		int,
										_casetas_parent_id		int,
										_status					tinyint default 1 null
                                    );
declare @casetas_records_not as table
                                    (
                                        --id						int,
                                        id_unidad				nvarchar(25),
                                        unit					nvarchar(25),
                                        no_tarjeta_iave			nvarchar(100),
                                        alpha_num_code			nvarchar(25),
                                        alpha_location			nvarchar(250),
                                        alpha_location_1		nvarchar(60),
                                        _filename				nvarchar(150),
                                        no_viaje				int,
                                        fecha_cruce				date,
                                        f_despachado			datetime,
                                        fecha_fin_viaje			datetime,
                                        float_data				decimal(18,4),
                                        hora_cruce				time(7),
                                        cia						nvarchar(25),
                                        Monto_archivo			decimal(18,4),
										_next					date,
                                        fecha_inicio			date,
                                        fecha_fin				date,
										description_casetas		nvarchar(300),
										--
										casetas_historical_conciliations_id int,
										casetas_controls_files_id  int,
										created					datetime,
										modified				datetime,
										_casetas_status_id		int,
										_casetas_parent_id		int,
										_status					tinyint default 1 null
                                    );
--declare @casetas_concilations as table
--                                    (
--                                        id  int,
--                                        id_unidad  nvarchar(25),
--                                        unit  nvarchar(25),
--                                        no_tarjeta_iave  nvarchar(100),
--                                        alpha_num_code  nvarchar(25),
--                                        alpha_location  nvarchar(250),
--                                        alpha_location_1  nvarchar(250),
--                                        _filename  nvarchar(150),
--                                        no_viaje  int,
--                                        fecha_cruce  date,
--                                        f_despachado  datetime,
--                                        fecha_fin_viaje  datetime,
--                                        float_data  decimal(18,4),
--                                        hora_cruce  time(7),
--                                        cia  nvarchar(25),
--                                        Monto_archivo  decimal(18,4),
--                                        fecha_inicio  date ,
--                                        fecha_fin  date
--                                    )

--declare @casetas_not_concilations as table
--                                    (
--                                        id  int,
--                                        id_unidad  nvarchar(25),
--                                        unit  nvarchar(25),
--                                        no_tarjeta_iave  nvarchar(100),
--                                        alpha_num_code  nvarchar(25),
--                                        alpha_location  nvarchar(250),
--                                        alpha_location_1  nvarchar(250),
--                                        _filename  nvarchar(150),
--                                        no_viaje  int,
--                                        fecha_cruce  date,
--                                        f_despachado  datetime,
--                                        fecha_fin_viaje  datetime,
--                                        float_data  decimal(18,4),
--                                        hora_cruce  time(7),
--                                        cia  nvarchar(25),
--                                        Monto_archivo  decimal(18,4),
--                                        fecha_inicio  date ,
--                                        fecha_fin  date
--                                    )

--declare @casetas_pendings_concilations as table
--                                    (
--                                        id  int,
--                                        id_unidad  nvarchar(25),
--                                        unit  nvarchar(25),
--                                        no_tarjeta_iave  nvarchar(100),
--                                        alpha_num_code  nvarchar(25),
--                                        alpha_location  nvarchar(250),
--                                        alpha_location_1  nvarchar(250),
--                                        _filename  nvarchar(150),
--                                        no_viaje  int,
--                                        fecha_cruce  date,
--                                        f_despachado  datetime,
--                                        fecha_fin_viaje  datetime,
--                                        float_data  decimal(18,4),
--                                        hora_cruce  time(7),
--                                        cia  nvarchar(25),
--                                        Monto_archivo  decimal(18,4),
--                                        fecha_inicio  date ,
--                                        fecha_fin  date
--                                    )
/** OK then thanks to the great and usseless sql from Mocosoft*/
/** this query must be check because the id is repeating */
if @company_id = 1 
	begin
		--print 'bonampak';
        declare casetas_cursor cursor for(
                                          SELECT 
												DISTINCT 
														sc.id, 
														tci.id_unidad, 
														sc.unit, 
														tci.no_tarjeta_iave, 
														sc.alpha_num_code, 
														sc.alpha_location, 
														sc.alpha_location_1, 
														sc._filename, 
														tv.no_viaje, 
														sc.fecha_a AS 'fecha_cruce', 
														(
															Select CONVERT (date, tv.f_despachado)
														) As 'f_despachado',
														tv.fecha_fin_viaje, 
														sc.float_data, 
														sc.time_a AS 'hora_cruce', 
														sc._area AS 'cia', 
														SUM(sc.float_data) AS 'Monto_archivo',
														(
															SELECT TOP (1)
																CONVERT (date, f_despachado)
															FROM 
																bonampakdb.dbo.trafico_viaje
															WHERE
																(id_unidad = tv.id_unidad) 
															   AND 
																(fecha_fin_viaje > tv.fecha_fin_viaje)
														) As 'next',

														(
															SELECT     
																MIN(sc.fecha_a) AS Expr1
														) AS 'fecha_inicio',

														(
															SELECT
																MAX(sc.fecha_a) AS Expr1
														) AS 'fecha_fin',
														(
															(
																SELECT dbo.getCasetaName(SUBSTRING(sc.alpha_location, 1, 5), N'tbk') AS Expr1
															)
														) AS 'description_casetas',
														sc.casetas_controls_files_id
											FROM       
													bonampakdb.dbo.trafico_catiaveunidoper AS tci 
															INNER JOIN dbo.casetas AS sc ON sc.alpha_num_code = tci.no_tarjeta_iave
															INNER JOIN bonampakdb.dbo.trafico_viaje AS tv ON tv.id_unidad = tci.id_unidad AND tv.id_area = tci.id_area 
															INNER JOIN bonampakdb.dbo.trafico_ruta_caseta trc ON trc.id_ruta = tv.id_ruta
															INNER JOIN bonampakdb.dbo.trafico_caseta tc ON tc.id_caseta = trc.id_caseta
											WHERE     
													(tci.fecha_fin_mov IS NULL) 
													AND
														(year(tv.f_despachado) > '2015') 
													and
														tv.no_liquidacion is not null
													AND
														 (
															(
																SELECT
																			CONVERT
																			(
																				datetime, sc.fecha_a) + ' ' + CONVERT(datetime, sc.time_a
																			) AS Expr1
															) BETWEEN.tv.fecha_real_viaje
													AND
														tv.fecha_real_fin_viaje
															--(
															--	SELECT TOP (1) f_despachado
															--	FROM          bonampakdb.dbo.trafico_viaje
															--	WHERE      (id_unidad = tv.id_unidad) AND (fecha_real_fin_viaje > tv.fecha_real_fin_viaje)
															--)
														)
													and
														sc.casetas_controls_files_id = @casetas_controls_files_id
											GROUP BY sc.id, tci.id_unidad, sc.unit, tci.no_tarjeta_iave, sc.alpha_num_code,
													 sc.alpha_location, sc.alpha_location_1, sc._filename, tv.no_viaje, sc.fecha_a, 
													 tv.f_despachado, tv.fecha_fin_viaje,sc.float_data, sc.time_a, sc._area, sc.float_data, tv.id_unidad,
													 tv.id_ruta, tc.desc_caseta, tc.id_caseta,trc.id_ruta, trc.orden, tc.desc_caseta, trc.id_caseta, sc.casetas_controls_files_id
                                               
										)
	end
if @company_id = 2
	begin
	--print 'macuspana';                                    
        declare casetas_cursor cursor for(
                                          SELECT 
												DISTINCT 
														sc.id, 
														tci.id_unidad, 
														sc.unit, 
														tci.no_tarjeta_iave, 
														sc.alpha_num_code, 
														sc.alpha_location, 
														sc.alpha_location_1, 
														sc._filename, 
														tv.no_viaje, 
														sc.fecha_a AS 'fecha_cruce', 
														(
															Select CONVERT (date, tv.f_despachado)
														) As 'f_despachado',
														tv.fecha_fin_viaje, 
														sc.float_data, 
														sc.time_a AS 'hora_cruce', 
														sc._area AS 'cia', 
														SUM(sc.float_data) AS 'Monto_archivo',
														(
															SELECT TOP (1)
																CONVERT (date, f_despachado)
															FROM 
																macuspanadb.dbo.trafico_viaje
															WHERE
																(id_unidad = tv.id_unidad) 
															   AND 
																(fecha_fin_viaje > tv.fecha_fin_viaje)
														) As 'next',

														(
															SELECT     
																MIN(sc.fecha_a) AS Expr1
														) AS 'fecha_inicio',

														(
															SELECT
																MAX(sc.fecha_a) AS Expr1
														) AS 'fecha_fin',
														(
															(
																SELECT dbo.getCasetaName(SUBSTRING(sc.alpha_location, 1, 5), N'atm') AS Expr1
															)
														) AS 'description_casetas',
														sc.casetas_controls_files_id
											FROM       
													macuspanadb.dbo.trafico_catiaveunidoper AS tci 
															INNER JOIN dbo.casetas AS sc ON sc.alpha_num_code = tci.no_tarjeta_iave
															INNER JOIN macuspanadb.dbo.trafico_viaje AS tv ON tv.id_unidad = tci.id_unidad AND tv.id_area = tci.id_area 
															INNER JOIN macuspanadb.dbo.trafico_ruta_caseta trc ON trc.id_ruta = tv.id_ruta
															INNER JOIN macuspanadb.dbo.trafico_caseta tc ON tc.id_caseta = trc.id_caseta
											WHERE     
													(tci.fecha_fin_mov IS NULL) 
													AND
														(year(tv.f_despachado) > '2015') 
													and
														tv.no_liquidacion is not null
													AND
														 (
															(
																SELECT
																			CONVERT
																			(
																				datetime, sc.fecha_a) + ' ' + CONVERT(datetime, sc.time_a
																			) AS Expr1
															) BETWEEN.tv.fecha_real_viaje
													AND
														tv.fecha_real_fin_viaje
															--(
															--	SELECT TOP (1) f_despachado
															--	FROM          macuspanadb.dbo.trafico_viaje
															--	WHERE      (id_unidad = tv.id_unidad) AND (fecha_real_fin_viaje > tv.fecha_real_fin_viaje)
															--)
														)
													and
														sc.casetas_controls_files_id = @casetas_controls_files_id
											GROUP BY sc.id, tci.id_unidad, sc.unit, tci.no_tarjeta_iave, sc.alpha_num_code,
													 sc.alpha_location, sc.alpha_location_1, sc._filename, tv.no_viaje, sc.fecha_a, 
													 tv.f_despachado, tv.fecha_fin_viaje,sc.float_data, sc.time_a, sc._area, sc.float_data, tv.id_unidad,
													 tv.id_ruta, tc.desc_caseta, tc.id_caseta,trc.id_ruta, trc.orden, tc.desc_caseta, trc.id_caseta, sc.casetas_controls_files_id
                                               
										)
	end
if @company_id = 3
	begin
	--print 'tiesa';	                                               	                                               
        declare casetas_cursor cursor for(
											SELECT 
												DISTINCT 
														sc.id, 
														tci.id_unidad, 
														sc.unit, 
														tci.no_tarjeta_iave, 
														sc.alpha_num_code, 
														sc.alpha_location, 
														sc.alpha_location_1, 
														sc._filename, 
														tv.no_viaje, 
														sc.fecha_a AS 'fecha_cruce', 
														(
															Select CONVERT (date, tv.f_despachado)
														) As 'f_despachado',
														tv.fecha_fin_viaje, 
														sc.float_data, 
														sc.time_a AS 'hora_cruce', 
														sc._area AS 'cia', 
														SUM(sc.float_data) AS 'Monto_archivo',
														(
															SELECT TOP (1)
																CONVERT (date, f_despachado)
															FROM 
																tespecializadadb.dbo.trafico_viaje
															WHERE
																(id_unidad = tv.id_unidad) 
															   AND 
																(fecha_fin_viaje > tv.fecha_fin_viaje)
														) As 'next',

														(
															SELECT     
																MIN(sc.fecha_a)		AS Expr1
														) AS 'fecha_inicio',

														(
															SELECT
																MAX(sc.fecha_a) AS Expr1
														) AS 'fecha_fin',
														(
															(
																SELECT dbo.getCasetaName(SUBSTRING(sc.alpha_location, 1, 5), N'tei') AS Expr1
															)
														) AS 'description_casetas',
														sc.casetas_controls_files_id
											FROM       
													tespecializadadb.dbo.trafico_catiaveunidoper AS tci 
															INNER JOIN dbo.casetas AS sc ON sc.alpha_num_code = tci.no_tarjeta_iave
															INNER JOIN tespecializadadb.dbo.trafico_viaje AS tv ON tv.id_unidad = tci.id_unidad AND tv.id_area = tci.id_area 
															INNER JOIN tespecializadadb.dbo.trafico_ruta_caseta trc ON trc.id_ruta = tv.id_ruta
															INNER JOIN tespecializadadb.dbo.trafico_caseta tc ON tc.id_caseta = trc.id_caseta
											WHERE     
													(tci.fecha_fin_mov IS NULL) 
													AND
														(year(tv.f_despachado) > '2015') 
													--and
													--	tv.no_liquidacion is not null
													AND
														 (
															(
																SELECT
																			CONVERT
																			(
																				datetime, sc.fecha_a) + ' ' + CONVERT(datetime, sc.time_a
																			) AS Expr1
															) BETWEEN.tv.fecha_real_viaje
													AND
															tv.fecha_real_fin_viaje
															--(
															--	SELECT TOP (1) f_despachado
															--	FROM          tespecializadadb.dbo.trafico_viaje
															--	WHERE      (id_unidad = tv.id_unidad) AND (fecha_real_fin_viaje > tv.fecha_real_fin_viaje)
															--)
														)
													and
														sc.casetas_controls_files_id = @casetas_controls_files_id
											GROUP BY sc.id, tci.id_unidad, sc.unit, tci.no_tarjeta_iave, sc.alpha_num_code,
													 sc.alpha_location, sc.alpha_location_1, sc._filename, tv.no_viaje, sc.fecha_a, 
													 tv.f_despachado, tv.fecha_fin_viaje,sc.float_data, sc.time_a, sc._area, sc.float_data, tv.id_unidad,
													 tv.id_ruta, tc.desc_caseta, tc.id_caseta,trc.id_ruta, trc.orden, tc.desc_caseta, trc.id_caseta, sc.casetas_controls_files_id
										)
	end
			set @_casetas_status_id =1; -- reset the standing status
            open casetas_cursor;
                fetch next from casetas_cursor into @id,
													@id_unidad ,@unit , @no_tarjeta_iave, @alpha_num_code,
                                                    @alpha_location ,@alpha_location_1 ,@_filename ,@no_viaje , @fecha_cruce,
                                                    @f_despachado, @fecha_fin_viaje ,@float_data ,@hora_cruce , @cia ,
                                                    @Monto_archivo,@_next,@fecha_inicio , @fecha_fin, @description_casetas ,
													--
													@casetas_controls_files_id
													--,@created , @modified ,
													--@_casetas_status_id , @_casetas_parent_id , @_status;
                        while @@fetch_status = 0
                            begin
                            /* this part is solved with a variable function in first was a cursor of external tmp table but this
                             *    soution  has a better performance, and clean code
                             */
                           if (select id_tmp from @casetas_table where id_tmp = @id
                                    and alpha_num_code_tmp = @alpha_num_code  and cia_tmp = @cia and casetas_controls_files_id_tmp = @casetas_controls_files_id
                                ) is not null
                                begin
                                    set @id_cursor = 0 ;
                                end
                            else
                                begin
                                    insert into @casetas_table (id_tmp
                                            ,alpha_num_code_tmp,casetas_controls_files_id_tmp,cia_tmp
                                            )
                                                values( @id, @alpha_num_code, @casetas_controls_files_id , @cia
                                             );           
                                    set @id_cursor = ( @id );                       
                                end
                          if @id_cursor <> 0
                                begin
								--if @fecha_fin_viaje is null and @description_casetas is null and @id_unidad is not null
								--	begin
								--		set @_casetas_status_id = 5;
								--	end

								--if @fecha_fin_viaje is null and @description_casetas is not null and @id_unidad is not null
								--	begin
								--		set @_casetas_status_id = 4
								--	end
								--else
								--	begin
								--		set @_casetas_status_id = 1
								--	end

								insert into @casetas_records
                                        select --@id,
													@id_unidad ,@unit , @no_tarjeta_iave, @alpha_num_code,
                                                    @alpha_location ,@alpha_location_1 ,@_filename ,@no_viaje , @fecha_cruce,
                                                    @f_despachado, @fecha_fin_viaje ,@float_data ,@hora_cruce , @cia ,
                                                    @Monto_archivo,@_next,@fecha_inicio , @fecha_fin, @description_casetas,
													--
													@casetas_historical_conciliations_id,
													@casetas_controls_files_id,@created , @modified ,
													@_casetas_status_id , @_casetas_parent_id , @_status;
                                end


										fetch next from casetas_cursor into @id,
													@id_unidad ,@unit , @no_tarjeta_iave, @alpha_num_code,
                                                    @alpha_location ,@alpha_location_1 ,@_filename ,@no_viaje , @fecha_cruce,
                                                    @f_despachado, @fecha_fin_viaje ,@float_data ,@hora_cruce , @cia ,
                                                    @Monto_archivo,@_next,@fecha_inicio , @fecha_fin, @description_casetas ,@casetas_controls_files_id
                            end
            close casetas_cursor;
        deallocate casetas_cursor;

		--Update the status of the file in casetas_controls_files
		update sistemas.dbo.casetas_controls_files set casetas_standings_id = 11 where id = @casetas_controls_files_id ;
		update sistemas.dbo.casetas_controls_conciliations set conciliations_count = (isnull(conciliations_count,0) + 1) where casetas_controls_files_id = @casetas_controls_files_id
		
		insert into casetas_logs values ('historica_id',(select conciliations_count from sistemas.dbo.casetas_controls_conciliations where casetas_controls_files_id = @casetas_controls_files_id),CURRENT_TIMESTAMP);

		insert into @casetas_records_not
		select 
				(select null) as 'id_unidad', --			tci.id_unidad
				cas.unit as 'unit', --		sc.unit
				(select  null) as 'no_tarjeta_iave', --			tci.no_tarjeta_iave
				cas.alpha_num_code,
				cas.alpha_location,
				cas.alpha_location_1,
				cas._filename,
				null,--				tv.no_viaje
				cas.fecha_a as 'fecha_cruce',
				null, --			tv.f_despachado as f_despachado
				null, --			tv.fecha_fin_viaje
				cas.float_data,
				cas.time_a as 'hora_cruce',
				cas._area as 'cia',
				cas.float_data as 'Monto_archivo',
				null, --			next
				cas.fecha_a as 'fecha_inicio',
				cas.fecha_a as 'fecha_fin',
				null, --			description_casetas
				(select @casetas_historical_conciliations_id) as 'casetas_historical_conciliations_id',
				(select @casetas_controls_files_id) as 'casetas_controls_files_id',
				(select @created) as 'created' , (select @modified) as 'modified' ,

				( select 7 ) as 'casetas_status_id',

				( select 1 ) as 'casetas_parent_id' , ( select 1 ) as 'status'
		from 
				sistemas.dbo.casetas as cas 
		where
				cas.casetas_controls_files_id = @casetas_controls_files_id and cas.id not in (select id_tmp from @casetas_table);

					
		insert into sistemas.dbo.casetas_views 
					select * from @casetas_records
					union all
					select * from @casetas_records_not;

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
				and notcasetas.fecha_fin_viaje is null and notcasetas.id_unidad is null and substring(notcasetas.unit, 1,2) = 'TT';

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
			end

----------------------------------------------------------------------------------------------------------------------------------------------
	-- 00000 from i+d clasification
----------------------------------------------------------------------------------------------------------------------------------------------

		
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

-- - =============================================================================================================
-- - Update info in dashboard
-- - =============================================================================================================

Use sistemas;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
/*======================================================================================================
 Authors        : Jesus Baizabal (ProcedureProgramation&TableSquemaDesign as Core) and Adrian (Query)
 email          : baizabal.jesus@gmail.com and adrian.turru@gmail.com
 Create date    : Dec 05, 2016
 Description    : gst_casetas_conciliacion/gst_tollbooth/update cruces and montos 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : GST Feltes y Servicios, s.a de c.v
 @status        : Stable
 @version        : 1.0.0
 ======================================================================================================*/

ALTER PROCEDURE sp_upt_tollbooth_manual_conciliation
(
	@casetas_controls_files_id  int,
	@casetas_historical_conciliations_id int,
	@user_id int
)
With Encryption
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
go


--3:15
-- exec sistemas.dbo.sp_tollbooth 4,118,1


 --truncate table sistemas.dbo.casetas_tiger_runs
 --truncate table sistemas.dbo.casetas_logs
 --truncate table sistemas.dbo.casetas_views
 --truncate table sistemas.dbo.casetas_controls_files
 --truncate table sistemas.dbo.casetas_controls_conciliations
 --truncate table sistemas.dbo.casetas_historical_conciliations
 --truncate table sistemas.dbo.casetas










