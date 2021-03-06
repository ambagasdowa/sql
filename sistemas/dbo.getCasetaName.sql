USE [sistemas]
GO
/****** Object:  UserDefinedFunction [dbo].[getCasetaName]    Script Date: 12/04/2016 01:41:14 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================
 Author         : @Author Jesus Baizabal
 Create date    : Sep 14, 2015
 Description    : get Compare_CASETA_NAME
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/
  ALTER FUNCTION [dbo].[getCasetaName]
  (
	@id_string nvarchar(100),@company nvarchar(3)
  )
  returns nchar(255) with encryption
  as
  BEGIN
	 DECLARE @get_name nvarchar(255),@return_name nvarchar(255);
		if @company = 'tei'
		begin
			SET @get_name = (  
									select top(1)
										tespecializadadb.dbo.trafico_caseta.desc_caseta
									from 
										tespecializadadb.dbo.trafico_caseta
									where 
										tespecializadadb.dbo.trafico_caseta.desc_caseta like '%'+@id_string+'%'
										--tespecializadadb.dbo.trafico_caseta.desc_caseta = @id_string
							);
		end
		if @company = 'atm'
		begin
			SET @get_name = (  
									select top(1)
										macuspanadb.dbo.trafico_caseta.desc_caseta
									from 
										macuspanadb.dbo.trafico_caseta
									where 
										macuspanadb.dbo.trafico_caseta.desc_caseta like '%'+@id_string+'%'
										--tespecializadadb.dbo.trafico_caseta.desc_caseta = @id_string
							);
		end
		if @company = 'tbk'
		begin
			SET @get_name = (  
									select top(1)
										bonampakdb.dbo.trafico_caseta.desc_caseta
									from 
										bonampakdb.dbo.trafico_caseta
									where 
										bonampakdb.dbo.trafico_caseta.desc_caseta like '%'+@id_string+'%'
										--tespecializadadb.dbo.trafico_caseta.desc_caseta = @id_string
							);
		end
		
		select @return_name = isnull(@get_name,null);
		return (@return_name);
  END;