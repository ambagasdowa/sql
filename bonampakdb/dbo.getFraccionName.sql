USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getFraccionName]    Script Date: 12/04/2016 12:59:31 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================
 Author         : @Author Jesus Baizabal
 Create date    : May 2, 2015
 Description    : get ID_FRACCION_NAME
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/
  ALTER FUNCTION [dbo].[getFraccionName](
	@id_fraccion int
  )
  returns char(255)
  with encryption
  as
  BEGIN
	 DECLARE @get_name varchar(255);
		SET @get_name = (  
								select top(1)
									bonampakdb.dbo.trafico_producto.desc_producto
								from 
									bonampakdb.dbo.trafico_producto
								where 
									bonampakdb.dbo.trafico_producto.id_producto = 0
									and
									bonampakdb.dbo.trafico_producto.id_fraccion = @id_fraccion
							);
	return (@get_name);
  END;
