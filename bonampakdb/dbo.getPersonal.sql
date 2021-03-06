USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getPersonal]    Script Date: 12/04/2016 01:00:40 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  ALTER FUNCTION [dbo].[getPersonal](@id_area varchar(255),@id_flota varchar(255))
  returns int
  with encryption
  as
  BEGIN
	 declare @get_personal int;
		SET @get_personal = (  
								select count(b.id_personal)
									from bonampakdb.dbo.mtto_unidades as a 
										inner join bonampakdb.dbo.personal_personal as b 
									on a.id_operador = b.id_personal and a.id_area = b.id_area
									where	a.id_area = @id_area
											and a.tipo_unidad in ('1','9') 
											and a.id_unidad != 'TT1000' 
											and a.estatus = 'A'
											and a.id_flota = @id_flota
											and b.estado = 'A'
											and b.id_categoria = '21'
							);
	RETURN (@get_personal);
  END;
