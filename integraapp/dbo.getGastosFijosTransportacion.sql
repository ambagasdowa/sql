USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[getGastosFijosTransportacion]    Script Date: 12/04/2016 01:16:18 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 22, 2015
 Description    : fetch and match with a Presupuesto in Solomon consult
                : but filtering Presupuesot by Account only 
 Database owner : bonampak s.a de c.v 
 @params		: <No parameters needed beacause must a match with Solomon> 
 @status        : Already working 
 @version		: 1.0.9
 ===============================================================================*/
ALTER function [dbo].[getGastosFijosTransportacion](
	-- declare the parameters
	-- so , this going to be interesting 
		@empresa	varchar(6),
		@year		varchar(4),
		@centro		varchar(8000),
		@unidad		varchar(8000),
		@perPost	varchar(8000),
		@AcctType	varchar(8000),
		@Delimiter  varchar(1),
		@substringA	int, -- this can be unnecesarry because appears this always be 1
		@substringB	int

)  returns @transportacion table(
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
	--declare @get_presupuesto float(2);
--  this section defines the variables to use for the insertion an must remove the var-fields for the insertions
	declare @Mes varchar (255), @NoCta varchar (255), @NombreCta varchar (255), @PerEnt varchar (255), @Compañía varchar (255), @Tipo varchar (255), @Entidad varchar (255), @distinto varchar (255), @tipoTransacción varchar (255), @Referencia varchar (255), @FechaTransacción varchar (255), @Descripción varchar (255), @Abono float (2), @cargo float (2), @UnidadNegocio varchar (255), @CentroCosto varchar (255), @NombreEntidad varchar (255), @Presupuesto float(2)
	
--	create a temporary table for store the presupuesto
	Declare @storedFetchAccount Table (		
											acct				varchar(4000),
											sub					varchar(4000),
											mes					varchar(4000),
											company				varchar(4000)
										   )
	-- in the beggining this was formely the function dbo.getRealPresupuesto but now this is part of itself										   
	declare transportationCursor cursor for	
	/** fetch of the presupuesto by account and sub account */
		select	Mes ,
				NoCta ,
				NombreCta ,
				PerEnt ,
				Compañía ,
				Tipo ,
				Entidad ,
				distinto ,
				tipoTransacción ,
				Referencia ,
				FechaTransacción ,
				Descripción ,
				Abono ,
				cargo ,
				UnidadNegocio ,
				CentroCosto ,
				NombreEntidad ,
				Presupuesto
		from dbo.getRealPresupuesto(@empresa, @year,SUBSTRING( @centro,@substringA,@substringB), @unidad, @perPost, @AcctType, @Delimiter);
	/** fetch of the presupuesto by account and sub account */
	
		open transportationCursor;
			FETCH NEXT FROM transportationCursor into	@Mes ,
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
							insert into @storedFetchAccount (acct, sub, mes, company)values(@NoCta,@distinto,@Mes,@Compañía);			

						insert @transportacion
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
								@NombreEntidad,
								@Presupuesto;
						
						FETCH NEXT FROM transportationCursor into	@Mes ,
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
		close transportationCursor;
	deallocate transportationCursor;
	
	-- should be something like 
		insert @transportacion select * from dbo.getRealPresupuesto(@empresa, @year,SUBSTRING( @centro,(@substringB+2),DATALENGTH(@centro)), @unidad, @perPost, @AcctType, @Delimiter)
			where NoCta not in (select acct from @storedFetchAccount where mes = Mes and company = Compañía and acct <> '0501090200');
	--union all
	--function
	
   return; -- end and return the table function
  END;
