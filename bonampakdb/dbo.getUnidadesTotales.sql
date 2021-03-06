USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getUnidadesTotales]    Script Date: 12/04/2016 01:03:59 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER FUNCTION [dbo].[getUnidadesTotales](@id_area varchar(255),@id_flota varchar(255))
  returns int
  with encryption
  as
  BEGIN
	 DECLARE @get_unidades int;
		SET @get_unidades = (  
								select COUNT(*) 
								from bonampakdb.dbo.mtto_unidades 
								where id_area = @id_area 
									and id_flota=@id_flota 
									and tipo_unidad in ('1','9') 
									and id_unidad <> 'TT1000' 
									and estatus = 'A'
							);
	return (@get_unidades);
  END;
