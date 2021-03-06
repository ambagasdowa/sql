USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getFactorKilometro]    Script Date: 12/04/2016 12:54:34 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================
 Author         : @Author Jesus Baizabal
 Create date    : May 2, 2015
 Description    : get factorKilometros Accepted
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/
  ALTER FUNCTION [dbo].[getFactorKilometro](
	@id_area int,
	@id_categoria int
  )
  returns float(2) with encryption
  as
  BEGIN
	 DECLARE @get_factor varchar(255);
		SET @get_factor = (  
								select top(1)
									bonampakdb.dbo.trafico_salario_unidkm.salario_cargado
								from 
									bonampakdb.dbo.trafico_salario
										inner join 
											bonampakdb.dbo.trafico_salario_unidkm 
										on 
											bonampakdb.dbo.trafico_salario.id_area = bonampakdb.dbo.trafico_salario_unidkm.id_area
										and
											bonampakdb.dbo.trafico_salario.id_salario = bonampakdb.dbo.trafico_salario_unidkm.id_salario
								where 
									bonampakdb.dbo.trafico_salario.id_area = @id_area
									and
									bonampakdb.dbo.trafico_salario.id_categoria = @id_categoria

							);
	return (@get_factor);
  END;
