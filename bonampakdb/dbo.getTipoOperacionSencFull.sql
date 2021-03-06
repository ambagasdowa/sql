USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[getTipoOperacionSencFull]    Script Date: 12/04/2016 01:02:09 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : function that returns a string if a trip is sencillo or full 
                : whith a numerical id_tipo_operacion as parameter 
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/

-- check about dbo.desp_asignacion

  ALTER FUNCTION [dbo].[getTipoOperacionSencFull](
											@id_tipoOperacion varchar(2)
  )
  returns varchar(255)
  with encryption
  as
  BEGIN
	 DECLARE @get_tipoOperacion varchar(255);
		if @id_tipoOperacion = '1' OR @id_tipoOperacion = '2' 
				set @get_tipoOperacion = 'Sencillo';
		else if @id_tipoOperacion = '3'
				set @get_tipoOperacion = 'Full';
	return (@get_tipoOperacion);
  END;
