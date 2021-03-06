USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[getRealPresupuesto]    Script Date: 12/04/2016 01:18:07 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : fetch the Presupuesto in Solomon for accounts and sub accounts
                : but filtering Presupuesot by Account only 
 Database owner : bonampak s.a de c.v 
 @params		: <company Name as defined in Solomon Catalog> 
				: <fiscal year as string example : '201501|201502|201503|201504' : this fecth a range of account with a range form january to april >
				: <centro de costo extracted from sub 10,2>
				: <unidad de negocio extracted from sub - 8,2>
				: <period of post in PerPost field>
				: <AcctType type of account in Account>
				: <delimiter for all strings in the query>
 @status        : Already working 
 @version		: 1.0.9
 ===============================================================================*/
 
  ALTER FUNCTION [dbo].[getRealPresupuesto](
		@empresa			varchar(6),
		@year				varchar(4),
		@centro				varchar(8000),
		@unidad				varchar(8000),
		@perPost			varchar(8000),
		@AcctType			varchar(8000),
		@Delimiter			varchar(1)
  )
  returns @allIsIncredible table(
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
  ) with encryption
  as
  BEGIN
--  define the variables to use for removeDuplicates
	declare @get_presupuesto float(2);
--  this section defines the variables to use for the insertion an must remove the var-fields for the insertions
	declare @Mes varchar (255), @NoCta varchar (255), @NombreCta varchar (255), @PerEnt varchar (255), @Compañía varchar (255), @Tipo varchar (255), @Entidad varchar (255), @distinto varchar (255), @tipoTransacción varchar (255), @Referencia varchar (255), @FechaTransacción varchar (255), @Descripción varchar (255), @Abono float (2), @cargo float (2), @UnidadNegocio varchar (255), @CentroCosto varchar (255), @NombreEntidad varchar (255), @Presupuesto float(2)
	
--	create a temporary table for store the presupuesto
	Declare @storedFetchPresupuesto Table (		
											acct				varchar(4000),
											sub					varchar(4000),
											mes					varchar(4000),
											company				varchar(4000),
											presuhueso			float(2) 
										   )
	-- in the beggining this was formely the function dbo.getRealPresupuesto but now this is part of itself										   
	declare guia_cursor cursor for	
	/** fetch of the presupuesto by account and sub account */
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
											--dbo.GLTran.TranDate AS FechaTransacción, 
											dbo.GLTran.TranDesc AS Descripción, 
											dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate AS Abono, 
											dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate AS Cargo, 
											SUBSTRING(dbo.GLTran.Sub, 8, 2) AS UnidadNegocio,
											SUBSTRING(dbo.GLTran.Sub, 10, 6) AS CentroCosto, 
											dbo.SubAcct.Descr AS NombreEntidad, 
											(
												select 
													isnull(dbo.fetchPresupuestoMod(
																					@empresa,
																					@year,
																					substring(dbo.GLTran.Sub, 10, 6),
																					substring(dbo.GLTran.Sub, 8, 2),
																					integraapp.dbo.GLTran.PerPost,
																					integraapp.dbo.GLTran.Acct,
																					--rtrim(integraapp.dbo.GLTran.Sub)),0
																					substring(integraapp.dbo.GLTran.Sub,1,21)),0
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
	/** fetch of the presupuesto by account and sub account */
	
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
						/* this part is solved with a variable function in first was a cursor of external tmp table but this 
						 *	soution  has a better performance, and clean code 
						 */
						if (select presuhueso from @storedFetchPresupuesto where acct = @NoCta and sub = @Entidad and mes = @Mes and company = @Compañía) is not null
							begin
								set @get_presupuesto = 0 ;
							end
						else
							begin
								insert into @storedFetchPresupuesto (acct, sub, mes, company, presuhueso)values(@NoCta,@Entidad,@Mes,@Compañía,@presupuesto );			
								set @get_presupuesto = ( @Presupuesto );
								
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
								@get_presupuesto;
						
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
   return; -- end and return the table function
  END;
