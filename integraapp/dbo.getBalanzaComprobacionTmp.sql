USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[getBalanzaComprobacion]    Script Date: 12/04/2016 01:11:49 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : fetch the Balanza for accounts and sub accounts form GLTran
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.9
 ===============================================================================*/
 
ALTER FUNCTION [dbo].[getBalanzaComprobacionTmp]
 (
	@beginDate nvarchar(6),
	@endDate nvarchar(6),
	@Company varchar(8000), -- just in case
	@Delimiter varchar(10)
 )
returns  @table table --with encryption
--returns  @table table --with encryption
	(
		cuenta nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		entidades nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		empresa	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		descripcion	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		inicial	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		cargo	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		credito	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		final	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as
	)
	as 
		begin
				insert into @table
					execute dbo.sp_udsp_getBalanzaComprobacion '201603','201603','TBKORI','|';
				-- select cuenta,entidades,empresa,descripcion,inicial,cargo,credito,final from @table;
		return 
		end
go





declare @table as table
	(
		cuenta nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		entidades nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		empresa	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		descripcion	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		inicial	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		cargo	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		credito	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as,
		final	nvarchar(255)	collate	sql_latin1_general_cp1_ci_as
	)
		begin
			insert into @table
				execute dbo.sp_udsp_getBalanzaComprobacion '201603','201603','TBKORI|TBKGDL|TBKRAM','|';
			select cuenta,entidades,empresa,descripcion,inicial,cargo,credito,final from @table;
		return 
		end



	
Create Function dbo.testProc()

Returns @Result Table
(

Result Varchar(100)

)

As

Begin	

	Insert @Result

	SELECT * from OPENROWSET('SQLNCLI10', 'Server=<SERVERNAME>;UID=<LOGIN>;Pwd=<PASSWORD>;',

			'Exec dbo.Proc1') AS C 

	Return

end

Go