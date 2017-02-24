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
 
ALTER FUNCTION [dbo].[getBalanzaComprobacion]
 (
	@beginDate nvarchar(6),
	@endDate nvarchar(6),
	@Company varchar(8000), -- just in case
	@Delimiter varchar(10)
 )
returns table with encryption
as 
return
(

	SELECT	
		h.Acct AS 'Cuenta',
		h.Sub AS 'ENTIDADES', 
		--h.BalanceType AS AcctHist_BalanceType,
		SUBSTRING(h.sub , 8, 2) as 'empresa',
--		SUBSTRING(h.sub , 10, 6) as CentroCosto,
		a.Descr as 'Descripción', 
--		h.CpnyID AS EmpresaDesc,
		CASE SUBSTRING(@beginDate, 5, 2) 
			WHEN '01'
				THEN h.BegBal 
			WHEN '02' 
				THEN h.YTDBal00
			WHEN '03' 
				THEN h.YTDBal01 
			WHEN '04' 
				THEN h.YTDBal02 
			WHEN '05' 
				THEN h.YTDBal03
			WHEN '06' 
				THEN h.YTDBal04 
			WHEN '07' 
				THEN h.YTDBal05 
			WHEN '08' 
				THEN h.YTDBal06 
			WHEN '09' 
				THEN h.YTDBal07 
			WHEN '10' 
				THEN h.YTDBal08 
			WHEN '11' 
				THEN h.YTDBal09 
			WHEN '12' 
				THEN h.YTDBal10
			WHEN '13' 
				THEN h.YTDBal11 
			ELSE 0 
			END AS 'Inicial',
--			
		(select dbo.getAssetsLiabilitiesBalance(
													h.Acct,
													@beginDate,
													h.CpnyID,
													h.Sub,
													'D',
													SUBSTRING(h.Sub,8,2),
													SUBSTRING(h.Sub,10,6)
												)
		) as 'Cargo',
		(select dbo.getAssetsLiabilitiesBalance(
													h.Acct,
													@beginDate,
													h.CpnyID,
													h.Sub,
													'C',
													SUBSTRING(h.Sub,8,2),
													SUBSTRING(h.Sub,10,6)
												)
		) as 'Crédito',
--
		CASE SUBSTRING(@endDate, 5, 2) 
			WHEN '01' 
				THEN h.YTDBal00 
			WHEN '02' 
				THEN h.YTDBal01 
			WHEN '03' 
				THEN h.YTDBal02 
			WHEN '04' 
				THEN h.YTDBal03 
			WHEN '05' 
				THEN h.YTDBal04 
			WHEN '06' 
				THEN h.YTDBal05 
			WHEN '07' 
				THEN h.YTDBal06 
			WHEN '08' 
				THEN h.YTDBal07 
			WHEN '09' 
				THEN h.YTDBal08 
			WHEN '10' 
				THEN h.YTDBal09
			WHEN '11' 
				THEN h.YTDBal10 
			WHEN '12'
				THEN h.YTDBal11
			WHEN '13' 
				THEN h.YTDBal12
			ELSE 0 
		END AS 'Final'
	FROM integraapp.dbo.AcctHist as h 
		INNER JOIN dbo.Account AS a 
			ON h.Acct = a.Acct
	where 
		h.CpnyID in (SELECT item from dbo.fnSplit(@Company, @Delimiter))
		and h.FiscYr = SUBSTRING(@beginDate, 1, 4)
		and h.LedgerID = 'REAL'
		and h.Acct <> '0304000000'
)

