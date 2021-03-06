USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[fetchPresupuesto]    Script Date: 12/04/2016 01:19:56 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : function that returns the presupuesto from AcctHist table takes 
                : parameters from fields of GLTran
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/
 
  ALTER FUNCTION [dbo].[fetchPresupuesto](
	@empresa	varchar(6),
	@year		varchar(4),
	@centro		varchar(2),
	@unidad		varchar(2),
	@perPost	varchar(6),
	@acct		varchar(20),
	@sub		varchar(8000)
  )
  returns float with encryption
  as
  BEGIN
	 DECLARE @get_presupuesto float,@field nvarchar(20);
		set @field = @year + convert(varchar (2),substring(@perPost,5,2))
		SET @get_presupuesto = (  
								select 
									CASE @field
										WHEN @year + '01' 
											THEN dbo.AcctHist.PtdBal00 
										WHEN @year + '02' 
											THEN dbo.AcctHist.PtdBal01 
										WHEN @year + '03' 
											THEN dbo.AcctHist.PtdBal02
										WHEN @year + '04' 
											THEN dbo.AcctHist.PtdBal03
										WHEN @year + '05' 
											THEN dbo.AcctHist.PtdBal04
										WHEN @year + '06' 
											THEN dbo.AcctHist.PtdBal05
										WHEN @year + '07' 
											THEN dbo.AcctHist.PtdBal06 
										WHEN @year + '08' 
											THEN dbo.AcctHist.PtdBal07
										WHEN @year + '09' 
											THEN dbo.AcctHist.PtdBal08
										WHEN @year + '10' 
											THEN dbo.AcctHist.PtdBal09
										WHEN @year + '11' 
											THEN dbo.AcctHist.PtdBal10
										WHEN @year + '12' 
											THEN dbo.AcctHist.PtdBal11
										ELSE '0' 
									END AS Presupuesto
								from integraapp.dbo.AcctHist
								where integraapp.dbo.AcctHist.CpnyID = @empresa				--@empresa 'ATMMAC'
									and integraapp.dbo.AcctHist.LedgerId = 'PRESUP' + @year		
									and integraapp.dbo.AcctHist.FiscYr = @year				-- @year '2015'
									and substring(integraapp.dbo.AcctHist.Sub,10,2) = @centro	-- @centro 'AG'
									and substring(integraapp.dbo.AcctHist.Sub,8,2) = @unidad	-- @unidad 'BW'
								 	and integraapp.dbo.AcctHist.Acct = @acct
								 	and substring(integraapp.dbo.AcctHist.Sub,1,11) = @sub
								 	-- and rtrim(integraapp.dbo.AcctHist.Sub) = rtrim(@sub)
							);
		return (@get_presupuesto);
  END;
