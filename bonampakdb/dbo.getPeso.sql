USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getPeso]    Script Date: 12/04/2016 01:01:12 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  ALTER FUNCTION [dbo].[getPeso](@id_area varchar(255),@no_viaje varchar(255))
  returns float(2)
  with encryption
  as
  BEGIN
	declare @guia varchar(25),@get_peso float(2),@suma_peso float(2);
	set @suma_peso = 0.00; 
	declare guia_cursor cursor for select no_guia from bonampakdb.dbo.trafico_guia where no_viaje = @no_viaje and id_area = @id_area;
		open guia_cursor;
		FETCH NEXT FROM guia_cursor into @guia;
			while @@FETCH_STATUS = 0
			begin
				set @get_peso = (  
									select sum(peso + peso_estimado) 
									from bonampakdb.dbo.trafico_renglon_guia 
									where no_guia = @guia and id_area = @id_area
								);
				select @suma_peso = (@suma_peso + @get_peso);
				FETCH NEXT FROM guia_cursor into @guia;
			end
		close guia_cursor;
		deallocate guia_cursor;
	return (@suma_peso);
  END;
