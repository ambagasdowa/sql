USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getFlota]    Script Date: 12/04/2016 12:58:47 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER FUNCTION [dbo].[getFlota](@id_flota varchar(255))
  returns varchar(255)
  with encryption
  as
  BEGIN
	 DECLARE @get_flota varchar(255);
		SET @get_flota = (  
							select bonampakdb.dbo.desp_flotas.nombre 
							from bonampakdb.dbo.desp_flotas
							where bonampakdb.dbo.desp_flotas.id_flota = @id_flota
						  );
	return (@get_flota);
  END;
