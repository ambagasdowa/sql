USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[fetchGhostAccountPresupuesto]    Script Date: 12/04/2016 01:10:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : function that returns the presupuesto of a non-existent record
					from AcctHist table takes, the name is inspired from the 2nd game 
				    of ghost recon saga for the playstation platform.
				    In other words this is a workaround for the Presupuesto
                : parameters from fields of GLTran
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/
 
  ALTER FUNCTION [dbo].[fetchGhostAccountPresupuesto](
	@empresa	varchar(6),
	@year		varchar(4),
	@centro		varchar(2),
	@unidad		varchar(2),
	@perPost	varchar(6),
	@acct		varchar(250),
	@sub		varchar(8000),
	@null		bit
  )
  returns  @allIsIncredible table(
		Mes					varchar (255),
		NoCta				varchar (255),
		NombreCta			varchar (255),
		PerEnt				varchar (255),
		Compañía			varchar (255),
		Tipo				varchar (255),
		Entidad				varchar (255),
		distinto			varchar (255),
		tipoTransacción		varchar (255),
		Referencia			varchar (255),
		FechaTransacción	varchar (255),
		Descripción			varchar (255),
		Abono				float (2),
		Cargo				float (2),
		UnidadNegocio		varchar (255),
		CentroCosto			varchar (255),
		NombreEntidad		varchar (255),
		Presupuesto			float (2)
  )
  with encryption
  as
  BEGIN
  
--  define the variables to use for removeDuplicates
	-- declare @get_presupuesto float(2);
--  this section defines the variables to use for the insertion an must remove the var-fields for the insertions
	declare @Mes varchar (255), @NoCta varchar (255), @NombreCta varchar (255), @PerEnt varchar (255), @Compañía varchar (255), @Tipo varchar (255), @Entidad varchar (255), @distinto varchar (255), @tipoTransacción varchar (255), @Referencia varchar (255), @FechaTransacción varchar (255), @Descripción varchar (255), @Abono float (2), @cargo float (2), @UnidadNegocio varchar (255), @CentroCosto varchar (255), @NombreEntidad varchar (255), @Presupuesto float(2);
	
	
	declare @get_presupuesto float,@field nvarchar(20);
	
	-- start with the cursor
	declare guia_cursor cursor for	
	/** fetch of the presupuesto by account and sub account */
	--start to build the table
	select
		(select dbo.setMonthName(SUBSTRING(@perPost,5,2))) as Mes, 
		(select @acct) as NoCta,
		(select dbo.Account.Descr from Account where Account.Acct = @acct) as NombreCta,
		(select @perPost) as PerEnt,
		(select @empresa) as Compañía, 
		(select null) as Tipo,
		(select @sub) as Entidad,
		(select substring(@Sub,1,11)) as distinto,
		(select @tipoTransacción) as tipoTransacción,
		(select @Referencia) as Referencia,
		(select @FechaTransacción) as FechaTransacción,
		(select ISNULL(@Descripción,0)) as Descripción,
		isnull(
				(
					select sum(dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate)
					from integraapp.dbo.GLTran where dbo.GLTran.Acct = @acct
								and integraapp.dbo.GLTran.Posted = 'P' 
								--and	integraapp.dbo.Account.AcctType = '5E'
								and integraapp.dbo.GLTran.CpnyID = @empresa
								and integraapp.dbo.GLTran.FiscYr = @year
								and substring(integraapp.dbo.GLTran.Sub,10,2)  = @centro
								and substring(integraapp.dbo.GLTran.Sub,8,2) = @unidad 
								and integraapp.dbo.GLTran.PerPost = @perPost
								and substring(dbo.GLTran.Sub,1,11) = @sub
				),0
		) as Abono,
		isnull(
				(
					select sum(dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate)
					from integraapp.dbo.GLTran where dbo.GLTran.Acct = @acct
								and integraapp.dbo.GLTran.Posted = 'P' 
								--and	integraapp.dbo.Account.AcctType = '5E'
								and integraapp.dbo.GLTran.CpnyID = @empresa
								and integraapp.dbo.GLTran.FiscYr = @year
								and substring(integraapp.dbo.GLTran.Sub,10,2)  = @centro
								and substring(integraapp.dbo.GLTran.Sub,8,2) = @unidad 
								and integraapp.dbo.GLTran.PerPost = @perPost
								and substring(dbo.GLTran.Sub,1,11) = @sub
				),0
		) as Cargo,
		(select @unidad) as UnidadNegocio,
		(select @centro) as CentroCosto,
		(select @NombreEntidad) as NombreEntidad,
		--set @field = @year + convert(varchar (2),substring(@perPost,5,2))
		CASE @year + convert(varchar (2),substring(@perPost,5,2))
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
							
		open guia_cursor;
			FETCH NEXT FROM guia_cursor into	@Mes ,
												@NoCta ,
												@NombreCta ,
												@PerEnt ,
												@Compañía ,
												@Tipo ,
												@Entidad ,
												@distinto ,
												@tipoTransacción ,
												@Referencia ,
												@FechaTransacción ,
												@Descripción ,
												@Abono ,
												@cargo ,
												@UnidadNegocio ,
												@CentroCosto ,
												@NombreEntidad ,
												@Presupuesto;
		
			while @@FETCH_STATUS = 0
				begin
					if @null = 1 -- yield mssql evaluate true and false jajajaja!
					begin
						select @Abono = 0;
						select @Cargo = 0;
					end
					
					insert @allIsIncredible
							select	@Mes , 
									@NoCta , 
									@NombreCta , 
									@PerEnt , 
									@Compañía , 
									@Tipo , 
									@Entidad , 
									@distinto , 
									@tipoTransacción , 
									@Referencia , 
									@FechaTransacción , 
									@Descripción , 
									@Abono , 
									@cargo , 
									@UnidadNegocio , 
									@CentroCosto , 
									@NombreEntidad , 
									@Presupuesto;
				FETCH NEXT FROM guia_cursor into	@Mes ,
													@NoCta ,
													@NombreCta ,
													@PerEnt ,
													@Compañía ,
													@Tipo ,
													@Entidad ,
													@distinto ,
													@tipoTransacción ,
													@Referencia ,
													@FechaTransacción ,
													@Descripción ,
													@Abono ,
													@cargo ,
													@UnidadNegocio ,
													@CentroCosto ,
													@NombreEntidad ,
													@Presupuesto ;
					end
		close guia_cursor;
	deallocate guia_cursor;
	return;
  END;
