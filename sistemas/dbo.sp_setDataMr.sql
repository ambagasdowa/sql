USE [sistemas]
GO
/****** Object:  StoredProcedure [dbo].[setDataMr]    Script Date: 12/04/2016 01:40:42 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Jesus Alberto>
-- Create date: <Create Date,2015-12-17,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[setDataMr]
( 
	-- Add the parameters for the stored procedure here
		@period				varchar(8000),
		@Delimiter			varchar(4),
		@bunit				varchar(8000),
		@_key				varchar(8000)
) with encryption
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/* Add data to the table variable. */
	--declare @count_records as nvarchar(255);
	/*first remove old data*/
	--select @count_records = (
	--							select COUNT(_key)  from sistemas.dbo.mr_source_reports 
	--							where _company in (select item from integraapp.dbo.fnSplit(@bunit, @Delimiter) ) and _key in (select item from integraapp.dbo.fnSplit(@_key, @Delimiter) ) and _period in (select item from integraapp.dbo.fnSplit(@period, @Delimiter) )
	--						)
	--print 'records found '+ @count_records
	
	delete from sistemas.dbo.mr_source_reports
		where _company in (select item from integraapp.dbo.fnSplit(@bunit, @Delimiter) ) and _key in (select item from integraapp.dbo.fnSplit(@_key, @Delimiter) ) and _period in (select item from integraapp.dbo.fnSplit(@period, @Delimiter) )
	--print 'records '+ @count_records + ' are deleted'
	
	INSERT INTO sistemas.dbo.mr_source_reports
		select * from integraapp.dbo.getCostos(@period,@Delimiter,@bunit,@_key);
		
	--select @count_records = (
	--							select COUNT(_key)  from sistemas.dbo.mr_source_reports
	--							where _company in (select item from integraapp.dbo.fnSplit(@bunit, @Delimiter) ) and _key in (select item from integraapp.dbo.fnSplit(@_key, @Delimiter) ) and _period in (select item from integraapp.dbo.fnSplit(@period, @Delimiter) )
	--						)
	--print 'now your table is up to date with '+@count_records+' records'
	
END
