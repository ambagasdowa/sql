USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getTipoOpFlota]    Script Date: 12/04/2016 01:02:47 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**set the tipo operacion name fetched by id */

  ALTER FUNCTION [dbo].[getTipoOpFlota](@id_tipo_operacion varchar(255))
  returns varchar(255)
  with encryption
  as
  BEGIN
	 DECLARE @get_tipo_operacion varchar(255);
		SET @get_tipo_operacion = (  
							select bonampakdb.dbo.desp_tipooperacion.tipo_operacion 
							from bonampakdb.dbo.desp_tipooperacion
							where bonampakdb.dbo.desp_tipooperacion.id_tipo_operacion = @id_tipo_operacion
						  );
	return (@get_tipo_operacion);
  END;
