/*===========================================================================================
 Authors        : Jesus Baizabal (Cursor) and Gaydrian (Query)
 email			: baizabal.jesus@gmail.com
 Create date    : May 16, 2016
 Description    : ?
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ETA			: 00:01:35
 ===========================================================================================*/

Declare @id_cursor as int;

declare -- Decalration of the variables for cursor
		@id as int,@id_unidad as nvarchar(25),@unit as nvarchar(25), @no_tarjeta_iave as nvarchar(100), @alpha_num_code as nvarchar(25),
		@alpha_location as nvarchar(250),@alpha_location_1 as nvarchar(250),@_filename as nvarchar(150),@no_viaje as int, @fecha_cruce as date,
		@f_despachado as nvarchar(120), @fecha_fin_viaje as nvarchar(120),@float_data as decimal(18,4),@hora_cruce as time(7), @cia as nvarchar(25),
		@Monto_archivo as decimal(18,4),@fecha_inicio as date , @fecha_fin as date;

declare @casetas_records as table 
									(
										id  int,
										id_unidad  nvarchar(25),
										unit  nvarchar(25), 
										no_tarjeta_iave  nvarchar(100),
										alpha_num_code  nvarchar(25),
										alpha_location  nvarchar(250),
										alpha_location_1  nvarchar(250),
										_filename  nvarchar(150),
										no_viaje  int,
										fecha_cruce  date,
										f_despachado  datetime,
										fecha_fin_viaje  datetime,
										float_data  decimal(18,4),
										hora_cruce  time(7),
										cia  nvarchar(25),
										Monto_archivo  decimal(18,4),
										fecha_inicio  date , 
										fecha_fin  date
									)
--temporal table declaration
declare @casetas_table as table 
								(
									id_tmp  int,
									alpha_num_code_tmp  nvarchar(25),
									_filename_tmp  nvarchar(150),
									cia_tmp  nvarchar(25)
								)
												  
		declare casetas_cursor cursor for(
												SELECT DISTINCT 
																	  sc.id,
																	  tci.id_unidad, 
																	  sc.unit, 
																	  tci.no_tarjeta_iave,
																	  sc.alpha_num_code, 
																	  sc.alpha_location, 
																	  sc.alpha_location_1, 
																	  sc._filename, 
																	  tv.no_viaje, 
																	  sc.fecha_a AS fecha_cruce, 
																	  tv.f_despachado, 
																	  tv.fecha_fin_viaje, 
																	  sc.float_data,
																	  sc.time_a AS hora_cruce, 
																	  sc._area AS cia, 
																	  SUM(sc.float_data) AS Monto_archivo,
																	  (SELECT     MIN(sc.fecha_a) AS Expr1) AS fecha_inicio,
																	  (SELECT     MAX(sc.fecha_a) AS Expr1) AS fecha_fin
												FROM 
																	  tespecializadadb.dbo.trafico_catiaveunidoper AS tci
																		INNER JOIN dbo.casetas AS sc ON sc.alpha_num_code = tci.no_tarjeta_iave 
																		INNER JOIN tespecializadadb.dbo.trafico_viaje AS tv ON tv.id_unidad = tci.id_unidad 
																			AND tv.id_area = tci.id_area 
												WHERE
																	(tci.fecha_fin_mov IS NULL) 
																			AND (year(tv.f_despachado) > '2015') 
																			AND	(
																					(
																						SELECT     CONVERT(datetime, sc.fecha_a) + ' ' + CONVERT(datetime, sc.time_a) AS Expr1) 
																							BETWEEN tv.f_despachado AND (
																															SELECT TOP (1) f_despachado
																															FROM          tespecializadadb.dbo.trafico_viaje
																															WHERE      (id_unidad = tv.id_unidad) AND (fecha_real_fin_viaje > tv.fecha_real_fin_viaje)
																														)
																				) 
												GROUP BY 
																	sc.id, tci.id_unidad, sc.unit, tci.no_tarjeta_iave, sc.alpha_num_code, sc.alpha_location, sc.alpha_location_1,
																	sc._filename, tv.no_viaje, sc.fecha_a, tv.f_despachado, tv.fecha_fin_viaje,sc.float_data, sc.time_a, sc._area,sc.float_data
											)
			open casetas_cursor;
				fetch next from casetas_cursor into @id ,@id_unidad ,@unit , @no_tarjeta_iave, @alpha_num_code,
													@alpha_location ,@alpha_location_1 ,@_filename ,@no_viaje , @fecha_cruce,
													@f_despachado, @fecha_fin_viaje ,@float_data ,@hora_cruce , @cia ,
													@Monto_archivo,@fecha_inicio , @fecha_fin;
						while @@fetch_status = 0
							begin
							/* this part is solved with a variable function in first was a cursor of external tmp table but this 
							 *	soution  has a better performance, and clean code 
							 */
							if (select id_tmp from @casetas_table where id_tmp = @id 
									and alpha_num_code_tmp = @alpha_num_code and _filename_tmp = @_filename and cia_tmp = @cia
								) is not null
								begin
									set @id_cursor = 0 ;
								end
							else
								begin
									insert into @casetas_table (id_tmp
											,alpha_num_code_tmp, _filename_tmp,cia_tmp
											)
												values( @id
												, @alpha_num_code, @_filename, @cia 
											 );			
									set @id_cursor = ( @id );						
								end
							
							if @id_cursor <> 0
								begin
									insert into @casetas_records
										select @id ,@id_unidad ,@unit , @no_tarjeta_iave, @alpha_num_code,
													@alpha_location ,@alpha_location_1 ,@_filename ,@no_viaje , @fecha_cruce,
													@f_despachado, @fecha_fin_viaje ,@float_data ,@hora_cruce , @cia ,
													@Monto_archivo,@fecha_inicio , @fecha_fin;
										
								end

								fetch next from casetas_cursor into @id ,@id_unidad ,@unit , @no_tarjeta_iave, @alpha_num_code,
													@alpha_location ,@alpha_location_1 ,@_filename ,@no_viaje , @fecha_cruce,
													@f_despachado, @fecha_fin_viaje ,@float_data ,@hora_cruce , @cia ,
													@Monto_archivo,@fecha_inicio , @fecha_fin;
							end
			close casetas_cursor;
		deallocate casetas_cursor;

		

		select * from @casetas_records;
