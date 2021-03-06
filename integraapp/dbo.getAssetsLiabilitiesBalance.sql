USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[getAssetsLiabilitiesBalance]    Script Date: 12/04/2016 01:21:45 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/** Starting Balance OK then the function
 *   the question is if the result return a table or a value ?
 *   how can insert a function table inside a select 
 */

ALTER function [dbo].[getAssetsLiabilitiesBalance](
	@acct		varchar(200),
	@beginDate	nvarchar(6),
	@Company	varchar(8000), -- this can be outer because is coming inside a in	
	@prefix		varchar(25), -- Edit at this point for grep 7 chars an do a complete filter
	@select		varchar(1),
	@empresa	varchar(2),
	@centrocosto varchar(6)
)
returns float with encryption
as
begin

	declare @setTransaction float(2);
	set @setTransaction =
		(
			select 
				case @select
					when 'D'
						then SUM(integraapp.dbo.GLTran.DrAmt)
					when 'C'
						then SUM(integraapp.dbo.GLTran.CrAmt)
					else null
				end
				--SUM(CuryDrAmt) - SUM(CuryCrAmt) as Result
			from integraapp.dbo.GLTran 
				--where integraapp.dbo.GLTran.Acct = '0101010000'
			where integraapp.dbo.GLTran.Acct = @acct --'0101040100'
					-- and integraapp.dbo.GLTran.PerPost in ('201502') -- indeed the period sum is working only per company in plural is companies XD Google says!
					-- and integraapp.dbo.GLTran.PerPost in (SELECT item from dbo.fnSplit(@Company, @Delimiter))
					and integraapp.dbo.GLTran.PerPost = @beginDate
					and integraapp.dbo.GLTran.CpnyID = @Company -- sum againts Companies is not working because the where clause split the results per company
					and integraapp.dbo.GLTran.Posted = 'P' -- Contant
					--and substring(integraapp.dbo.GLTran.Sub,1,3) = 'AAB'
					and integraapp.dbo.GLTran.Sub = @prefix -- '000'
					and integraapp.dbo.GLTran.FiscYr = SUBSTRING(@beginDate,1,4)
					and integraapp.dbo.GLTran.LedgerID = 'REAL' -- Constant
					and SUBSTRING(integraapp.dbo.GLTran.Sub , 8, 2) = @empresa
					and SUBSTRING(integraapp.dbo.GLTran.Sub , 10, 6) = @centroCosto
		)
	return @setTransaction;
end;
