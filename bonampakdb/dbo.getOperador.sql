USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getOperador]    Script Date: 12/04/2016 01:00:10 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER FUNCTION [dbo].[getOperador](@id_operador varchar(255))
  returns varchar(255)
  with encryption
  as
  BEGIN
	 DECLARE @get_operador varchar(255);
		SET @get_operador = (  
								select 
									bonampakdb.dbo.personal_personal.nombre
								from 
									bonampakdb.dbo.personal_personal
								where 
									bonampakdb.dbo.personal_personal.id_personal = @id_operador
							);
	return (@get_operador);
  END;
