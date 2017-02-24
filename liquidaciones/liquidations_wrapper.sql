

CREATE PROCEDURE [dbo].[gst_liquidaciones_tbk_2017]
 (
	@year_liq int
 )
 with encryption
 as 

	SET NOCOUNT ON;
	--SET FMTONLY OFF;


	declare
			 @id_personal varchar (25),   
			 @nombre varchar (25),            
			 @no_viaje int,   
			 @desc_tipo_ruta varchar (25),   
			 @fecha_real_viaje datetime,   
			 @kms_operador int,   
			 @desc_plaza varchar (25),   
			 @desc_ruta varchar (25),   
			 @no_liquidacion int,   
			 @id_area varchar (25),   
			 @fecha_liquidacion datetime,   
			 @sueldo_operador float (2),   
			 @compensaciones float (2),
			 @fraccion varchar (25), 
			 @semanaLiq int, 
			 @id_unidad varchar (25),         
			 @get_liquidation float (2),
			 @get_sueldo float (2)
			;

	 declare @storeTransaction table(
			  id_personal varchar (25),   
			 nombre varchar (25),            
			 no_viaje int,   
			 desc_tipo_ruta varchar (25),   
			 fecha_real_viaje datetime,   
			 kms_operador int,   
			 desc_plaza varchar (25),   
			 desc_ruta varchar (25),   
			 no_liquidacion int,   
			 id_area varchar (25),   
			 fecha_liquidacion datetime,   
			 sueldo_operador float (2),   
			 compensaciones float (2),
			 fraccion varchar (25),
			 semanaLiq int,
			 id_unidad varchar (25)         
	  );
	 Declare @table_liq As Table (area varchar(25), liquidacion int, monto1 float (2), monto2 float (2))
	 SET datefirst 5;
	 declare cursor_liquidations cursor for
									(
                                   
											  SELECT  
			 personal_personal.id_personal,   
			 personal_personal.nombre,   
			 trafico_viaje.no_viaje,   
			 trafico_tipo_ruta.desc_tipo_ruta,   
			 trafico_viaje.fecha_real_viaje,   
			 trafico_viaje.kms_operador,   
			 trafico_plaza.desc_plaza,   
			 trafico_ruta.desc_ruta,   
			 trafico_viaje.no_liquidacion,   
			 CASE  trafico_liquidacion.id_area
					WHEN 1 THEN 'Orizaba'
					WHEN 2 THEN 'Guadalajara'
					WHEN 3 THEN 'Ramos Arizpe'
					WHEN 4 THEN 'Mexicali'
					WHEN 5 THEN 'Hermosillo'
			 END AS Area,   
			 trafico_liquidacion.fecha_liquidacion,   
			 trafico_viaje.sueldo_operador,   
			 trafico_viaje.compensaciones,
				CASE trafico_guia.id_fraccion WHEN 1 THEN 'GRANEL' WHEN 2 THEN 'ENVASADO' WHEN 3 THEN 'AGREGADOS' WHEN 4 THEN 'CAJA SECA' WHEN 5 THEN 'PRODUCTOS VARIOS' ELSE 'SIN ASIGNAR' END as Fraccion,
			 DATEPART(ww, trafico_liquidacion.fecha_liquidacion) AS SemanaLiq, trafico_viaje.id_unidad
		FROM trafico_guia,   
			 trafico_viaje,   
			 personal_personal,    
			 trafico_ruta,   
			 trafico_plaza,   
			 trafico_tipo_ruta,   
			 trafico_liquidacion  
	   WHERE ( trafico_viaje.id_area *= trafico_guia.id_area) and  
			 ( trafico_viaje.no_viaje *= trafico_guia.no_viaje) and  
			 ( trafico_viaje.id_personal = personal_personal.id_personal ) and  
			 ( trafico_viaje.id_ruta = trafico_ruta.id_ruta ) and  
			 ( trafico_plaza.id_plaza = trafico_ruta.destino_ruta ) and  
			 ( trafico_ruta.id_tipo_ruta = trafico_tipo_ruta.id_tipo_ruta ) and  
			 ( trafico_liquidacion.no_liquidacion = trafico_viaje.no_liquidacion ) and  
			 ( trafico_viaje.id_area_liq = trafico_liquidacion.id_area ) 
			 and  
				 (	
					--	( trafico_liquidacion.fecha_liquidacion >= '4-1-2016 0:0:0.000' ) 
					--AND  
					--	( trafico_liquidacion.fecha_liquidacion <= '4-28-2016 23:59:0.000' ) 
					year(trafico_liquidacion.fecha_liquidacion) = @year_liq
					AND  
						( trafico_viaje.id_personal >= 0 ) 
					AND  
						( trafico_viaje.id_personal <= 9999999 ) 
					AND  
						( trafico_liquidacion.id_area In (1,2,3,4,5)) 
					AND  
						( trafico_guia.status_guia <> 'B'  OR  trafico_guia.status_guia is NULL )
					And 
						(
							trafico_viaje.no_viaje In (Select Distinct tg.no_viaje From trafico_guia tg Where tg.no_viaje = trafico_viaje.no_viaje And tg.id_area = trafico_viaje.id_area And tg.status_guia <>'B')
						)
				 )  
			 and
			 ( trafico_liquidacion.status_liq = 'A' ) And (trafico_viaje.no_viaje In (Select Distinct tg.no_viaje From trafico_guia tg Where tg.no_viaje = trafico_viaje.no_viaje And tg.id_area = trafico_viaje.id_area And tg.status_guia <>'B'))
	   UNION   
	  SELECT   
			 personal_personal.id_personal,   
			 personal_personal.nombre,   
			 trafico_viaje.no_viaje,            
			 trafico_tipo_ruta.desc_tipo_ruta,   
			 trafico_viaje.fecha_real_viaje,   
			 trafico_viaje.kms_operador,   
			 trafico_plaza.desc_plaza,   
			 trafico_ruta.desc_ruta,   
			 trafico_viaje.liquidacion_operador2,   
			 CASE  trafico_liquidacion.id_area
					WHEN 1 THEN 'Orizaba'
					WHEN 2 THEN 'Guadalajara'
					WHEN 3 THEN 'Ramos Arizpe'
					WHEN 4 THEN 'Mexicali'
					WHEN 5 THEN 'Hermosillo'
			  END AS Area,      
			 trafico_liquidacion.fecha_liquidacion,   
			 trafico_viaje.sueldo_operador2,   
			 trafico_viaje.compensacion_operador2,
			 CASE trafico_guia.id_fraccion WHEN 1 THEN 'GRANEL' WHEN 2 THEN 'ENVASADO' WHEN 3 THEN 'AGREGADOS' WHEN 4 THEN 'CAJA SECA' WHEN 5 THEN 'PRODUCTOS VARIOS' ELSE 'SIN ASIGNAR' END as Fraccion, DATEPART(ww, trafico_liquidacion.fecha_liquidacion) AS SemanaLiq, trafico_viaje.id_unidad
		FROM trafico_guia,   
			 trafico_viaje,   
			 personal_personal,   
			 trafico_ruta,   
			 trafico_plaza,   
			 trafico_liquidacion,   
			 trafico_tipo_ruta  
	   WHERE ( trafico_viaje.id_area *= trafico_guia.id_area) and  
			 ( trafico_viaje.no_viaje *= trafico_guia.no_viaje) and  
			 ( trafico_viaje.id_operador2 = personal_personal.id_personal ) and  
			 ( trafico_viaje.id_ruta = trafico_ruta.id_ruta ) and  
			 ( trafico_plaza.id_plaza = trafico_ruta.destino_ruta ) and  
			 ( trafico_ruta.id_tipo_ruta = trafico_tipo_ruta.id_tipo_ruta ) and  
			 ( trafico_liquidacion.no_liquidacion = trafico_viaje.liquidacion_operador2 ) and  
			 ( trafico_viaje.id_area_liq2 = trafico_liquidacion.id_area ) 
			 and  
				( 
				
					--(trafico_liquidacion.fecha_liquidacion >= '4-1-2016 0:0:0.000') 
					--AND  
					--(trafico_liquidacion.fecha_liquidacion <= '4-28-2016 23:59:0.000') 
					year(trafico_liquidacion.fecha_liquidacion) = @year_liq
					AND
					( trafico_viaje.id_operador2 >= 0 ) 
					AND  
					( trafico_viaje.id_operador2 <= 9999999 ) 
					AND  
					( trafico_liquidacion.id_area In (1,2,3,4,5) ) 
					AND  
					( trafico_guia.status_guia is null OR trafico_guia.status_guia <> 'B' ) 
					And 
						(	trafico_viaje.no_viaje In (Select Distinct tg.no_viaje From trafico_guia tg Where tg.no_viaje = trafico_viaje.no_viaje And tg.id_area = trafico_viaje.id_area And tg.status_guia <>'B'))
				)   
			 and
				( 
					trafico_liquidacion.status_liq = 'A' ) And (trafico_viaje.no_viaje In (Select Distinct tg.no_viaje From trafico_guia tg Where tg.no_viaje = trafico_viaje.no_viaje And tg.id_area = trafico_viaje.id_area And tg.status_guia <>'B')
				)
  

                                       
									)
				 open cursor_liquidations;
					FETCH NEXT FROM cursor_liquidations into                      
																				 @id_personal, 
																				 @nombre,     
																				 @no_viaje,  
																				 @desc_tipo_ruta,   
																				 @fecha_real_viaje,   
																				 @kms_operador,   
																				 @desc_plaza,   
																				 @desc_ruta,   
																				 @no_liquidacion,   
																				 @id_area,   
																				 @fecha_liquidacion,   
																				 @sueldo_operador,   
																				 @compensaciones,
																				 @fraccion, 
																				 @semanaLiq,
																				 @id_unidad
						while @@FETCH_STATUS = 0
							begin
								if (select monto2 from @table_liq where area = @id_area and liquidacion = @no_liquidacion) is not null
									begin
										set @get_liquidation = 0 ;
										set @get_sueldo = 0;
									end
								else
									begin
										insert into @table_liq (area, liquidacion,monto1,monto2 )values(@id_area, @no_liquidacion, @sueldo_operador, @compensaciones);           
										set @get_liquidation = ( @compensaciones );
										set @get_sueldo = ( @sueldo_operador);
                                   
									end

									insert @storeTransaction
									select     
											 @id_personal, 
											 @nombre,     
											 @no_viaje,  
											 @desc_tipo_ruta,   
											 @fecha_real_viaje,   
											 @kms_operador,   
											 @desc_plaza,   
											 @desc_ruta,   
											 @no_liquidacion,   
											 @id_area,   
											 @fecha_liquidacion,
											 @sueldo_operador,   
											 @compensaciones,
											 @fraccion,
											 @semanaLiq,
											 @id_unidad;
								FETCH NEXT FROM cursor_liquidations into      
											 @id_personal, 
											 @nombre,   
											 @no_viaje, 
											 @desc_tipo_ruta,   
											 @fecha_real_viaje,   
											 @kms_operador,   
											 @desc_plaza,   
											 @desc_ruta,   
											 @no_liquidacion,   
											 @id_area,   
											 @fecha_liquidacion, 
											 @sueldo_operador,   
											 @compensaciones,
											 @fraccion,
											 @semanaLiq, 
											 @id_unidad;
							end
				close cursor_liquidations;
			deallocate cursor_liquidations;

	select * from @storeTransaction order by no_liquidacion,no_viaje

	go


--wrapper

IF OBJECT_ID ('gst_v_liquidaciones_tbk', 'V') IS NOT NULL
    DROP VIEW gst_v_liquidaciones_tbk;
GO

create view gst_v_liquidaciones_tbk
with encryption
as

select
			*
from openquery(local,'exec bonampakdb.dbo.gst_liquidaciones_tbk_2017 "2017"')
go


-- -- For Teisa -- --



IF OBJECT_ID ('gst_v_liquidaciones_teisa', 'V') IS NOT NULL
    DROP VIEW gst_v_liquidaciones_teisa;
GO

create view gst_v_liquidaciones_teisa
with encryption
as

select
			*
from openquery(local,'exec tespecializadadb.dbo.gst_liquidaciones_teisa "2016"')
go


	
IF OBJECT_ID ('gst_v_liquidaciones_teisa_15', 'V') IS NOT NULL
    DROP VIEW gst_v_liquidaciones_teisa_15;
GO

create view gst_v_liquidaciones_teisa_15
with encryption
as

select
			*
from openquery(local,'exec tespecializadadb.dbo.gst_liquidaciones_teisa "2015"')
go


select * from gst_v_liquidaciones_teisa_15

select * from gst_v_liquidaciones_teisa

