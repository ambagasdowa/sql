USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[getCostos]    Script Date: 12/04/2016 01:14:51 p.m. ******/
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

-- sed -e '1,3d' costosFijosOpOri_viewl.csv | sed '$d' | sed '$d' | sed 's/^"//g' | cut -c 1-35 | sed 's/-//g'

  ALTER FUNCTION [dbo].[getCostos](
		@period				varchar(8000),
		@Delimiter			varchar(4),
		@bunit				varchar(8000),
		@_key				varchar(8000)
  )
  returns @storeTransaction table(
		Mes					varchar (60),
		NoCta				varchar (10),
		NombreCta			varchar (100),
		PerEnt				int,
		Compañía			varchar (10),
		Tipo				varchar (255),
		Entidad				varchar (80),
		distinto			varchar (255),
		tipoTransacción		varchar (255),
		Referencia			varchar (255),
		FechaTransacción	varchar (255),
		Descripción			varchar (120),
		Abono				float (2),
		Cargo				float (2),
		UnidadNegocio		varchar (10),
		CentroCosto			varchar (10),
		NombreEntidad		varchar (25),
		_company			varchar (10),
		_period				int,
		_key				varchar (2),
		Presupuesto			float (2)
		--_period_year		varchar(4)
  ) with encryption
  as
  BEGIN
  
  --call to table and save as table var 
	
	declare @source_table table	
	(
		SubAccount		varchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
		company			varchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
		source_company	varchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
		period			varchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
		_key			varchar(2) collate SQL_Latin1_General_CP1_CI_AS,
		_status			varchar(1) collate SQL_Latin1_General_CP1_CI_AS
	)


	insert into @source_table 
						select SubAccount,company,source_company,period,_key,_status 
						from sistemas.dbo.mr_source_configs
						where 
								period in (select item from integraapp.dbo.fnSplit(@period, @Delimiter) )
							and
								source_company in (select item from integraapp.dbo.fnSplit(@bunit, @Delimiter) )
							and
								_key in (select item from integraapp.dbo.fnSplit(@_key, @Delimiter) ) ;
							
  --call to table and save as table var 
  
	Declare @Mes varchar (60), @NoCta varchar (10), @NombreCta varchar (100), @PerEnt int, 
			@Compañía varchar (10), @Tipo varchar (255), @Entidad varchar (80), @distinto varchar (255), 
			@tipoTransacción varchar (255), @Referencia varchar (255), @FechaTransacción varchar (255),
			@Descripción varchar (120), @Abono float (2), @cargo float (2), @UnidadNegocio varchar (10), 
			@CentroCosto varchar (10), @NombreEntidad varchar (10), @Presupuesto float(2), @_company varchar(10),
			@_period int,@_key_ varchar(2) --,@_period_year varchar(4)
			
	--  define the variables to use for removeDuplicates
		declare @get_presupuesto float(2);
	--	create a temporary table for store the presupuesto
	Declare @storedFetchPresupuesto Table (		
											acct				varchar(10),
											sub					varchar(60),
											mes					varchar(60),
											company				varchar(40),
											_key				varchar(2),
											presuhueso			float(2) 
										   )
	-- in the beggining this was formely the function dbo.getRealPresupuesto but now this is part of itself

	declare guia_cursor cursor for	
	/** fetch of the presupuesto by account and sub account */
	select 
			( select ISNULL((select integraapp.dbo.setMonthName(SUBSTRING(integraapp.dbo.GLTran.PerPost,5,2))),(select integraapp.dbo.setMonthName(SUBSTRING(source_table.period,5,2))))) as Mes
			,substring(source_table.SubAccount,1,10) as NoCta
			,integraapp.dbo.Account.Descr AS NombreCta
			,(select ISNULL(integraapp.dbo.GLTran.PerEnt,source_table.period)) as 'PerEnt'
			,(select ISNULL(integraapp.dbo.GLTran.CpnyID,source_table.company)) AS Compañía
			,integraapp.dbo.GLTran.JrnlType AS Tipo
			--,ISNULL(integraapp.dbo.GLTran.Sub,substring(source_table.SubAccount,11,21)) AS Entidad
			,ISNULL(integraapp.dbo.GLTran.Sub,substring(integraapp.dbo.SubAcct.Sub,1,21)) AS Entidad
			,substring(integraapp.dbo.GLTran.Sub,1,11) AS 'distinto'
			,integraapp.dbo.GLTran.TranType AS TipoTransacción
			,integraapp.dbo.GLTran.RefNbr AS Referencia
			--,dbo.GLTran.ExtRefNbr AS RefExterna
			,integraapp.dbo.GLTran.ExtRefNbr AS FechaTransacción
			--,integraapp.dbo.GLTran.TranDate AS FechaTransacción
			,integraapp.dbo.GLTran.TranDesc AS Descripción
			,ISNULL(integraapp.dbo.GLTran.CuryCrAmt * integraapp.dbo.GLTran.CuryRate,0.0)as Abono
			,ISNULL(integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate,0.0) AS Cargo
			,ISNULL(SUBSTRING(integraapp.dbo.GLTran.Sub, 8, 2),substring(source_table.SubAccount, 18, 2)) AS UnidadNegocio
			,ISNULL(SUBSTRING(integraapp.dbo.GLTran.Sub, 10, 6),substring(source_table.SubAccount, 20, 6)) AS CentroCosto 
			,integraapp.dbo.SubAcct.Descr AS NombreEntidad
			,source_table.source_company as _company
			,source_table.period as _period
			,source_table._key as _key
			--,substring(source_table.SubAccount, 20, 6) as _entitie
			--,substring(source_table.SubAccount, 18, 2) as _other
			--,source_table.period as _period
			--,substring(source_table.SubAccount,11,11) as _sub
			,(
			select
				isnull
				(
					integraapp.dbo.fetchPresupuestoMod(
											source_table.company,
											SUBSTRING(source_table.period,1,4),
											substring(integraapp.dbo.SubAcct.Sub, 20, 6),
											substring(integraapp.dbo.SubAcct.Sub, 18, 2),
											source_table.period,
											substring(source_table.SubAccount,1,10),
											substring(integraapp.dbo.SubAcct.Sub,1,21)
										),0
				)
			) as 'Presupuesto'
			--SUBSTRING(source_table.period,1,4) as _period_year
	--from sistemas.dbo.mr_source_configs as source_table
	from @source_table as source_table
	
	
		inner join integraapp.dbo.Account
			on substring(source_table.SubAccount,1,10) = integraapp.dbo.Account.Acct
			
		inner join integraapp.dbo.SubAcct
			--on substring(source_table.SubAccount,11,21) = integraapp.dbo.SubAcct.Sub
			on substring(source_table.SubAccount,11,7) = SUBSTRING(integraapp.dbo.SubAcct.Sub,1,7)
				and
					substring(source_table.SubAccount,18,2) = SUBSTRING(integraapp.dbo.SubAcct.Sub,8,2)
				and 
					substring(source_table.SubAccount,20,2) = SUBSTRING(integraapp.dbo.SubAcct.Sub,10,2)
			--	and 
			--		substring(source_table.SubAccount,22,4) between '0000' and '9999'
				--and substring(source_table.SubAccount,22,4) between 1000 and 9999
		left join integraapp.dbo.GLTran
			on substring(source_table.SubAccount,1,10) = integraapp.dbo.GLTran.Acct
				and source_table.company = integraapp.dbo.GLTran.CpnyID
				and source_table.period = integraapp.dbo.GLTran.PerPost
				/** MOD */
				and substring(integraapp.dbo.SubAcct.Sub,1,21) = SUBSTRING(integraapp.dbo.GLTran.Sub,1,21)
				--and substring(source_table.SubAccount,17,4) = SUBSTRING(integraapp.dbo.GLTran.Sub,7,4)
				--and substring(source_table.SubAccount,22,4) between 1000 and 9999
				/** MOD */
				and 'P' = integraapp.dbo.GLTran.Posted
	where 
		source_table.period in (select item from integraapp.dbo.fnSplit(@period, @Delimiter) )
		and source_table.source_company in (select item from integraapp.dbo.fnSplit(@bunit, @Delimiter) )
		and source_table._key in (select item from integraapp.dbo.fnSplit(@_key, @Delimiter) )
		

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
													@_company,
													@_period,
													@_key_,
													@Presupuesto
													;
					while @@FETCH_STATUS = 0
						begin
							/* this part is solved with a variable function in first was a cursor of external tmp table but this 
							 *	soution  has a better performance, and clean code 
							 */
							if (select presuhueso from @storedFetchPresupuesto where acct = @NoCta and sub = @Entidad and mes = @Mes and _key = @_key_ and company = @Compañía) is not null
								begin
									set @get_presupuesto = 0 ;
								end
							else
								begin
									insert into @storedFetchPresupuesto (acct, sub, mes, _key, company, presuhueso)values(@NoCta, @Entidad, @Mes, @_key_ , @Compañía, @presupuesto );			
									set @get_presupuesto = ( @Presupuesto );
									
								end
								
							if (@Abono <> 0 OR @cargo <> 0 OR @Presupuesto <> 0)
							begin
												
								insert @storeTransaction
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
										@_company,
										@_period,
										@_key_,
										@get_presupuesto;
							end
							
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
																@_company,
																@_period,
																@_key_,
																@Presupuesto;
						end
			close guia_cursor;
		deallocate guia_cursor;
	
	
	--select * from @storeTransaction;
	
   return; -- end and return the table function
  END;
