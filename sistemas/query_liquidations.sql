 declare
		 @Area				varchar (10),
		@no_viaje			varchar(25),
		@Flota				varchar(25),
		@no_liquidacion		varchar(25),
		@SemanaLiq			varchar(25),
		@sueldo				varchar(25),
		@compensaciones		float(2),
		@fecha				datetime,
		@get_liquidation    float(2),
		@get_sueldo			float(2)
		;

 declare @storeTransaction table(
		Area				varchar (10),
		no_viaje			varchar(25),
		Flota				varchar(25),
		no_liquidacion		varchar(25),
		SemanaLiq			varchar(25),
		sueldo				varchar(25),
		compensaciones		float(2),
		fecha				datetime
  );
 Declare @table_liq As Table (area varchar(10), liquidacion int, monto1 float (2), monto2 float (2))
 --SET datefirst 5;
 declare cursor_liquidations cursor for 
								(
									
										SELECT  
												CASE 
														tl.id_area
															WHEN 1 THEN 'Orizaba' 
															WHEN 2 THEN 'Guadalajara' 
															WHEN 3 THEN 'Ramos Arizpe' 
															WHEN 4 THEN 'Mexicali' 
															WHEN 5 THEN 'Hermosillo' 
												END AS Area,
												tv.no_viaje,
												CASE 
														mu.id_flota 
															WHEN 1 THEN 'Orizaba' WHEN 2 THEN 'Orizaba' WHEN 3 THEN 'Ramos Arizpe' 
															WHEN 4 THEN 'Escobedo' WHEN 5 THEN 'San Luis Potosí' WHEN 6 THEN 'Altamira' 
															WHEN 7 THEN 'Chihuahua' WHEN 8 THEN 'Cd. Juárez' WHEN 9 THEN 'Guadalajara' 
															WHEN 10 THEN 'Guadalajara' WHEN 11 THEN 'Guadalajara' WHEN 12 THEN 'La Paz' 
															WHEN 13 THEN 'Hermosillo' WHEN 14 THEN 'Culiacán' WHEN 15 THEN 'Hermosillo' 
															WHEN 16 THEN 'Mexicali' WHEN 17 THEN 'Guadalajara' WHEN 18 THEN 'Orizaba' 
															WHEN 19 THEN 'Orizaba' WHEN 20 THEN 'Orizaba' WHEN 21 THEN 'Orizaba' 
															WHEN 22 THEN 'Orizaba' WHEN 23 THEN 'Orizaba' WHEN 24 THEN 'Orizaba' 
															WHEN 25 THEN 'Guadalajara' WHEN 26 THEN 'Orizaba' WHEN 27 THEN 'Orizaba' 
															WHEN 28 THEN 'Orizaba' WHEN 29 THEN 'Guadalajara' WHEN 30 THEN 'Guadalajara' 
															WHEN 31 THEN 'Orizaba' ELSE 'Sin Asignar' 
												END AS Flota, 
												tv.no_liquidacion,
												DATEPART(ww, tl.fecha_liquidacion) AS SemanaLiq,
												tl.monto_sueldo AS sueldo,
												sum(liquidacion.monto_concepto) As compensaciones,
												tl.fecha_liquidacion as fecha

										FROM   
												trafico_viaje tv
												LEFT JOIN mtto_unidades mu ON mu.id_unidad = tv.id_unidad
												LEFT JOIN trafico_liquidacion tl ON tl.no_liquidacion = tv.no_liquidacion And tl.id_area = tv.id_area
												inner join
													trafico_renglon_liquidacion as liquidacion
													on	liquidacion.no_liquidacion = tl.no_liquidacion and liquidacion.id_area = tl.id_area
										WHERE    (tl.fecha_liquidacion > '2016-03-29')
										group by tl.id_area,tv.no_viaje,mu.id_flota,tv.no_liquidacion,tl.monto_sueldo,DATEPART(ww, tl.fecha_liquidacion),tl.fecha_liquidacion
										-- order by tv.no_viaje
										
								)
 			open cursor_liquidations;
				FETCH NEXT FROM cursor_liquidations into			@Area,
																	@no_viaje,
																	@Flota,
																	@no_liquidacion,
																	@SemanaLiq,
																	@sueldo,
																	@compensaciones,
																	@fecha
					while @@FETCH_STATUS = 0
						begin
							if (select monto2 from @table_liq where area = @Area and liquidacion = @no_liquidacion) is not null
								begin
									set @get_liquidation = 0 ;
									set @get_sueldo = 0;
								end
							else
								begin
									insert into @table_liq (area, liquidacion,monto1,monto2 )values(@Area, @no_liquidacion, @sueldo, @compensaciones);			
									set @get_liquidation = ( @compensaciones );
									set @get_sueldo = ( @sueldo);
									
								end

								insert @storeTransaction
								select	@Area,
										@no_viaje,
										@Flota,
										@no_liquidacion,
										@SemanaLiq,
										@get_sueldo,
										@get_liquidation,
										@fecha;
							FETCH NEXT FROM cursor_liquidations into	@Area,
																@no_viaje,
																@Flota,
																@no_liquidacion,
																@SemanaLiq,
																@sueldo,
																@compensaciones,
																@fecha;
						end
			close cursor_liquidations;
		deallocate cursor_liquidations;

select * from @storeTransaction order by no_liquidacion,no_viaje;