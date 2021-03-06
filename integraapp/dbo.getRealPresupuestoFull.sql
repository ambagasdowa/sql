USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[getRealPresupuestoFull]    Script Date: 12/04/2016 01:18:48 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : This is just for testing issues 
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/


ALTER FUNCTION [dbo].[getRealPresupuestoFull](

	--@Account	varchar(8000),
	@empresa	varchar(6),
	@year		varchar(4),
	@centro		varchar(8000),
	@unidad		varchar(8000),
	@perPost	varchar(8000),
	@AcctType	varchar(8000),
	@Delimiter  varchar(1)
	
 )
returns table with encryption
as 
return
(		
		select	
				--integraapp.dbo.Account.AcctType,
				(select dbo.setMonthName(SUBSTRING(dbo.GLTran.PerPost,5,2))) as Mes, 
				dbo.GLTran.Acct AS NoCta,
				dbo.Account.Descr AS NombreCta,
				dbo.GLTran.PerEnt,
				dbo.GLTran.CpnyID AS Compañía,
				dbo.GLTran.JrnlType AS Tipo,
				dbo.GLTran.Sub AS Entidad, 
				substring(dbo.GLTran.Sub,1,11) AS 'distinto',
				dbo.GLTran.TranType AS TipoTransacción,
				dbo.GLTran.RefNbr AS Referencia, 
				dbo.GLTran.ExtRefNbr AS RefExterna, 
				dbo.GLTran.TranDate AS FechaTransacción, 
				dbo.GLTran.TranDesc AS Descripción, 
				dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate AS Abono, 
				dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate AS Cargo, 
				SUBSTRING(dbo.GLTran.Sub, 8, 2) AS UnidadNegocio,
				SUBSTRING(dbo.GLTran.Sub, 10, 6) AS CentroCosto, 
				dbo.SubAcct.Descr AS NombreEntidad, 
				(
					select 
						isnull(dbo.fetchPresupuesto(
														@empresa,
														@year,
														substring(dbo.GLTran.Sub, 10, 6),
														substring(dbo.GLTran.Sub, 8, 2),
														integraapp.dbo.GLTran.PerPost,
														integraapp.dbo.GLTran.Acct,
														--rtrim(integraapp.dbo.GLTran.Sub)),0
														substring(integraapp.dbo.GLTran.Sub,1,11)),0
						)
				) as Presupuesto
		from integraapp.dbo.GLTran 
			inner join integraapp.dbo.Account 
				on integraapp.dbo.GLTran.Acct = integraapp.dbo.Account.Acct
--		from integraapp.dbo.Account
--			inner join integraapp.dbo.GLTran 
--				on integraapp.dbo.Account.Acct = integraapp.dbo.GLTran.Acct
			inner join integraapp.dbo.SubAcct
				on integraapp.dbo.GLTran.Sub = integraapp.dbo.SubAcct.Sub
		where integraapp.dbo.GLTran.Posted = 'P'
			and	integraapp.dbo.Account.AcctType in (select item from integraapp.dbo.fnSplit(@AcctType, @Delimiter))
			and integraapp.dbo.GLTran.CpnyID = @empresa
			and integraapp.dbo.GLTran.FiscYr = @year
			and substring(integraapp.dbo.GLTran.Sub,10,2) in (select item from integraapp.dbo.fnSplit(@centro, @Delimiter))
			and substring(integraapp.dbo.GLTran.Sub,8,2) in (select item from integraapp.dbo.fnSplit(@unidad, @Delimiter))
			and integraapp.dbo.GLTran.PerPost in (select item from integraapp.dbo.fnSplit(@perPost, @Delimiter))
	--		and integraapp.dbo.GLTran.Acct in (select item from integraapp.dbo.fnSplit(@Account, @Delimiter))
)
