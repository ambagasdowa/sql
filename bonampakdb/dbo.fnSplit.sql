USE [bonampakdb]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplit]    Script Date: 12/04/2016 01:06:28 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fnSplit](
    @sInputList VARCHAR(8000), -- List of delimited items
	@sDelimiter VARCHAR(8000) -- delimiter that separates items
) RETURNS @List TABLE (item VARCHAR(8000))
with encryption
BEGIN
DECLARE @sItem VARCHAR(8000)
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT
  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))

 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END
