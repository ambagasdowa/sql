USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getFactorX]    Script Date: 12/04/2016 01:07:08 p.m. ******/
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
  ALTER FUNCTION [dbo].[getFactorX](
	@id_area int,
	@id_categoria int
  )
  returns table
  with encryption
  as return
  (
 								select top(1)
									bonampakdb.dbo.trafico_salario.factor_tonelada,
									bonampakdb.dbo.trafico_salario.id_salario
								from 
									bonampakdb.dbo.trafico_salario
								where 
									bonampakdb.dbo.trafico_salario.id_area = @id_area
									and
									bonampakdb.dbo.trafico_salario.id_categoria = @id_categoria
  )
