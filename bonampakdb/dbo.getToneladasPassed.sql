USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getToneladasPassed]    Script Date: 12/04/2016 01:03:20 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================
 Author         : @Author Jesus Baizabal
 Create date    : May 2, 2015
 Description    : get Toneladas Accepted
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/

  ALTER FUNCTION [dbo].[getToneladasPassed](@id_area varchar(255),@no_viaje varchar(255),@date datetime)
  returns float(2)
  with encryption
  as
  BEGIN
	declare @guia varchar(25),@get_peso float(2),@suma_peso float(2);
	set @suma_peso = 0.00; 
	declare guia_cursor cursor for select no_guia from dbo.trafico_guia 
									where dbo.trafico_guia.no_viaje = @no_viaje 
										and dbo.trafico_guia.id_area = @id_area
										and dbo.trafico_guia.status_guia not in ('B')
										and dbo.trafico_guia.tipo_doc = '2'
										and dbo.trafico_guia.prestamo not in ('P')
										and YEAR(dbo.trafico_guia.fecha_guia) = YEAR(@date)
										and MONTH(dbo.trafico_guia.fecha_guia) = MONTH(@date);
										
		open guia_cursor;
		FETCH NEXT FROM guia_cursor into @guia;
			while @@FETCH_STATUS = 0
			begin
				set @get_peso = (  
									select sum(peso)
									from dbo.trafico_renglon_guia 
									where dbo.trafico_renglon_guia.no_guia = @guia 
										and dbo.trafico_renglon_guia.id_area = @id_area
								);
				select @suma_peso = (@suma_peso + @get_peso);
				FETCH NEXT FROM guia_cursor into @guia;
			end
		close guia_cursor;
		deallocate guia_cursor;
		return (@suma_peso);
  END;
