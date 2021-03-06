USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[SuperTrim]    Script Date: 12/04/2016 01:35:55 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER FUNCTION [dbo].[SuperTrim] (@fieldtotest char(255))
Returns varchar(255) with encryption
as
Begin
	declare @ReturnString varchar(255)
	select @ReturnString=rtrim(substring (@fieldtotest,patindex('%[^ 0]%',@fieldtotest),
	                 len(@fieldtotest)-patindex('%[^ 0]%',@fieldtotest)+1))
	Return (@ReturnString)
End
