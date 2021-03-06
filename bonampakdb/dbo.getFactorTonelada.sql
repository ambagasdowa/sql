USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getFactorTonelada]    Script Date: 12/04/2016 12:58:12 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================
 Author         : @Author Jesus Baizabal
 Create date    : May 2, 2015
 Description    : get factorToneladas Accepted
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/
  ALTER FUNCTION [dbo].[getFactorTonelada](
	@id_area int,
	@id_categoria int
  )
  returns float(2) with encryption
  as
  BEGIN
	 DECLARE @get_factor varchar(255);
		SET @get_factor = (  
								select top(1)
									bonampakdb.dbo.trafico_salario.factor_tonelada
								from 
									bonampakdb.dbo.trafico_salario
								where 
									bonampakdb.dbo.trafico_salario.id_area = @id_area
									and
									bonampakdb.dbo.trafico_salario.id_categoria = @id_categoria
							);
	return (@get_factor);
  END;
