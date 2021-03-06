USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[getGhostCargoAbono]    Script Date: 12/04/2016 01:17:19 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author				: Jesus Baizabal
 email				: ambagasdowa@gmail.com
 Create date		: April 20, 2015
 Description		: function that returns the presupuesto of a non-existent record
						in GLTran and adds period loop to original 
						dbo.fetchGhostAccountPresupuesto
						with limitation to now(@period)
						from AcctHist table takes, the name is inspired from the 2nd game 
						of ghost recon saga for the playstation platform.
						In other words this is a workaround for the Presupuesto
					: parameters from fields of GLTran
 Database owner	: gst
 ===============================================================================*/

  ALTER FUNCTION [dbo].[getGhostCargoAbono]
  (
	@account varchar(8000),@empresa varchar(255),@year varchar(255),@centro varchar(2),@unidad varchar(2),@period varchar(8000),@sub varchar(255),@null bit
  )
  returns @ghost table
						(
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

	declare @acct as varchar(50); -- for inner cursor
	declare @Mes varchar (255), @NoCta varchar (255), @NombreCta varchar (255), @PerEnt varchar (255), @Compañía varchar (255), @Tipo varchar (255), @Entidad varchar (255), @distinto varchar (255), @tipoTransacción varchar (255), @Referencia varchar (255), @FechaTransacción varchar (255), @Descripción varchar (255), @Abono float (2), @cargo float (2), @UnidadNegocio varchar (255), @CentroCosto varchar (255), @NombreEntidad varchar (255), @Presupuesto float(2);
	declare @acc varchar(25);
	declare period_cursor cursor for	(
											select item 
											from dbo.fnSplit(@period, '|')
										);
		open period_cursor;
		
		FETCH NEXT FROM period_cursor into	@period;
		
			while substring(@period,1,4) <= datepart(YEAR ,CURRENT_TIMESTAMP) and substring(@period,5,2) <= datepart(MONTH ,CURRENT_TIMESTAMP)
			begin
			
					declare acc_cursor cursor for (
													select item from dbo.fnSplit(@account, '|')
												  );
					open acc_cursor;
							fetch next from acc_cursor into @acct;
						while @@FETCH_STATUS = 0
						begin
					
					
							insert @ghost
							   select   Mes,
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
							   from dbo.fetchGhostAccountPresupuesto(
																		 @empresa,
																		 @year,
																		 @centro, --'AF', --substring(dbo.GLTran.Sub, 10, 6), centro
																		 @unidad, --'AA', --substring(dbo.GLTran.Sub, 8, 2), unidad
																		 @period, --integraapp.dbo.GLTran.PerPost
																		 @acct,
																		 @sub, --substring(integraapp.dbo.GLTran.Sub,1,11)
																		 @null
																	);
					
							fetch next from acc_cursor into @acct;
						end
					close acc_cursor;
					deallocate acc_cursor;
				FETCH NEXT FROM period_cursor into	@period;
			end
		close period_cursor;
		deallocate period_cursor;
	return;
  END;