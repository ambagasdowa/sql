USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getStatus]    Script Date: 12/04/2016 01:01:38 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  ALTER FUNCTION [dbo].[getStatus](@id_area varchar(255),@id_flota varchar(255),@id_status varchar(255))
  returns int
  with encryption
  as
  BEGIN
	 DECLARE @get_status int;
		SET @get_status = (  
								select 
									count(bonampakdb.dbo.mtto_unidades.id_status)
								from 
									bonampakdb.dbo.mtto_unidades
								where 
									bonampakdb.dbo.mtto_unidades.id_area = @id_area
									and
									bonampakdb.dbo.mtto_unidades.id_flota = @id_flota
									and 
									bonampakdb.dbo.mtto_unidades.id_status = @id_status
									and 
									bonampakdb.dbo.mtto_unidades.tipo_unidad in ('1','9')
									and
									bonampakdb.dbo.mtto_unidades.id_unidad <> 'TT1000' 
									and 
									bonampakdb.dbo.mtto_unidades.estatus = 'A'
							);
	return (@get_status);
  END;
