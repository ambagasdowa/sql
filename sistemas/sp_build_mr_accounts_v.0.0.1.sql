USE sistemas
---- go
/****** Object:  UserDefinedFunction [dbo].[sp_build_mr_accounts]    Script Date: 04/29/2016 01:36:17 p.m. ******/
SET ANSI_NULLS ON
---- go
SET QUOTED_IDENTIFIER ON
---- go

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : Build and set the Accounts Ranges for Mr Clone app
 TODO			: clean
 @Last_patch	: add support for intercompanies entities
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.2.1
 ===============================================================================*/
 
ALTER PROCEDURE [dbo].[sp_build_mr_accounts]
 (
	@bunit nvarchar(6), -- for the moment only works with one company definition
	@iesegment nvarchar(4000),
	@truncate_table int,
	@prep_year nvarchar(4),
	@key nvarchar(2),
	@delimiter varchar(1) -- use pipeline
 )
 with encryption
 as 


-----------------------------------------------------------------------------------------------------------
--	           	              deploy the config subaccount                                             --
-----------------------------------------------------------------------------------------------------------
--use sistemas
-- emulating the config tables when i'm click build the data struct
      
	declare @config_accounts table	
	(
		rangeaccounta	nvarchar(10)	collate	sql_latin1_general_cp1_ci_as,
		segmenta		nvarchar(6)	collate		sql_latin1_general_cp1_ci_as,
		segmentb		nvarchar(6)	collate		sql_latin1_general_cp1_ci_as,
		_key			nvarchar(2)	collate		sql_latin1_general_cp1_ci_as
	)
	
-----------------------------------------------------------------------------------------------------------
--	           	              deploy the full subaccount                                                 --
-----------------------------------------------------------------------------------------------------------

-- emulating the config tables this must be the same as mr_sources_accounts
      
	declare @deploy_accounts table	
	(
		mr_sources_controls_id		int null,
		subaccount					nvarchar(25)	collate		sql_latin1_general_cp1_ci_as,
		company						nvarchar(6)		collate		sql_latin1_general_cp1_ci_as,
		source_company				nvarchar(6)		collate		sql_latin1_general_cp1_ci_as,
		_key						nvarchar(2)		collate		sql_latin1_general_cp1_ci_as,
		_status						int default 1 null
	)


-----------------------------------------------------------------------------------------------------------
--	           	              deploy the dinamycs accounts                                               --
-----------------------------------------------------------------------------------------------------------

	declare @dinaccount as table 
	(
		--id							int identity(1,1),
		account						nvarchar(10)		collate		sql_latin1_general_cp1_ci_as,
		segmentsub					nvarchar(4)			collate		sql_latin1_general_cp1_ci_as,
		company						nvarchar(6)			collate		sql_latin1_general_cp1_ci_as,
		source_company				nvarchar(6)			collate		sql_latin1_general_cp1_ci_as,
		_key						nvarchar(2)			collate		sql_latin1_general_cp1_ci_as,
		_status						int default 1 null
	)

-----------------------------------------------------------------------------------------------------------
--	           	              deploy the full Presupuesto                                                --
-----------------------------------------------------------------------------------------------------------
-- /*************************************************************/
-- use for insert into sistemas.dbo.mr_source_presupuestos_temps
-- /*************************************************************/
	declare @deploy_presupuesto table
	(
		Acct				nvarchar (25) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		Sub					nvarchar (25) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		CpnyID				nvarchar (15) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal00			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal01			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal02			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal03			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal04			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal05			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal06			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal07			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal08			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal09			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal10			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal11			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		PtdBal12			nvarchar (255) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		FiscYr				nvarchar (15) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		_key				nvarchar (2) collate SQL_Latin1_General_CP1_CI_AS  NULL,
		_source_company		nvarchar (25) collate SQL_Latin1_General_CP1_CI_AS  NULL
	)



-----------------------------------------------------------------------------------------------------------
--	           	              deploy the entitie and add the intercompanies segment                      --
-----------------------------------------------------------------------------------------------------------

	declare @idbase as table 
	(
		--id							int identity(1,1),
		idbase						nvarchar(2)		collate		sql_latin1_general_cp1_ci_as,
		idsl						nvarchar(6)			collate		sql_latin1_general_cp1_ci_as
		--_status						int default 1 null
	)

--select cpnyid from integraapp.dbo.frl_entity

insert into @idbase
	select 
		distinct 
		idbase,idsl from integraapp.dbo.xrefcia 
  union all
    select 'EA' as 'idbase','TEICUA' as 'idsl'
	union all
	--select distinct (select '00') as 'idbase',(select 'INTCOM') as 'idsl' --from integraapp.dbo.xrefcia 
	--select distinct (select '00') as idbase,idsl from integraapp.dbo.xrefcia
	select distinct (select '00') as idbase,idsl from integraapp.dbo.xrefcia where idsl not in  (select distinct idsl from integraapp.dbo.xrefcia where substring(idsl,1,3) = 'TBK' and idsl <> 'TBKORI')
--select * from @idbase
	declare @cpnyid as table 
	(
		cpnyid nvarchar(10)		collate		sql_latin1_general_cp1_ci_as
	)
	insert into @cpnyid
	select [cpnyid]
	from [integraapp].[dbo].[frl_entity]
	union all
	select ('TCGTUL') as cpnyid

-----------------------------------------------------------------------------------------------------------
--	           	                     build the accounts call                                             --
-----------------------------------------------------------------------------------------------------------						
-- build the struc in a table account by account

	-- declare the fields from
	-- use sistemas
	declare		@rangeaccounta varchar(10), @rangeaccountb varchar(10) ,
				@segmenta varchar(6) , @segmentb varchar(6),
				@_key varchar(2), @accounts varchar(255) ,@counter int
					
					
	declare guia_cursor cursor for	(
										select 
												rangeaccounta,
												rangeaccountb,
												segmenta,
												segmentb,
												_key
										from
												--@source_accounts as source_accounts
												sistemas.dbo.mr_source_mains as source_accounts
										where	_status = '1' and _key = @key
									)

		open guia_cursor
			fetch next from guia_cursor into		@rangeaccounta,
													@rangeaccountb,
													@segmenta,
													@segmentb,
													@_key
													
				while @@fetch_status = 0
					begin
						/** only fetch the accounts */
						--if ((@rangeaccounta is not null  and @rangeaccountb is not null ) and (@rangeaccounta <> '' and @rangeaccountb <> '') )
						--	begin
						--print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
						--	end
						
						if ((@rangeaccounta is not null  and @rangeaccountb is not null ) and (@rangeaccounta <> '' and @rangeaccountb <> '') )
							begin
							-- print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
								
								declare account_cursor cursor for (
																	select acct
																	from integraapp.dbo.account
																	where 
																		--	integraapp.dbo.account.accttype = '5e'
																		--and 
																			active = '1'
																		and 
																			acct between @rangeaccounta and @rangeaccountb
																			
																)								
																
								open account_cursor
									fetch next from account_cursor into	@accounts -- save into 
									
										while @@fetch_status = 0
											begin
												if @accounts is not null
													begin
														-- print 'acct => '+ @accounts + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
														-- INSERT INTO CONFIG ACCOUNTS
														insert @config_accounts 
															select @accounts,@segmenta,@segmentb,@_key
													end
												fetch next from account_cursor into @accounts					
											end				
								close account_cursor
								deallocate account_cursor		
							end
						else if ( ( @rangeaccounta is not null ) and ( @rangeaccountb is null or @rangeaccountb = '') )
							begin
								-- print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
								-- print 'acct => '+ @accounts + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
													-- INSERT INTO CONFIG ACCOUNTS
														insert @config_accounts 
															select @rangeaccounta,@segmenta,@segmentb,@_key
							end 
						fetch next from guia_cursor into	@rangeaccounta,
															@rangeaccountb,
															@segmenta,
															@segmentb,
															@_key
															
					
					end

	
									

		close guia_cursor
	deallocate guia_cursor
-- ===================================================================================================== --
--	           	                     insert into the deployment accounts                                 --
-- ===================================================================================================== --
	delete from mr_source_deployment_accounts where _key = @_key
	insert  mr_source_deployment_accounts
			select 
					rangeaccounta,
					_key,
					(select '1') as _status
			from @config_accounts 

-- ===================================================================================================== --
--	           	                     build the accounts                                                  --
-- ===================================================================================================== --

--use integraapp
	declare   --@drop varchar(8000) ,
			  @thirdsegment nvarchar(6) , @thirdsegment_sec nvarchar(6),
			 @acct varchar(10)--@iesegment varchar(4000)
	-- variables for inner cursor 
	declare @inner_account varchar(25),@inner_unit varchar(10),@inner_key varchar(2) , @control_key int
			 
			 
	--select @bunit = 'TBKTIJ' -- for the moment only works with one company definition
	--select @delimiter = '|'

	--select @inner_unit = 'tbkgdl'
	--select @_key = 'of'
	--select @acct = '0501010100'
	--select @thirdsegment = 'cs'
	--select @thirdsegment_sec = 'zz'
	
	select @iesegment = '0|7|8'

	if @prep_year = ''
		begin
			set @prep_year = year(current_timestamp)
		end
	--select @thirdsegment_sec = ''

	--use sistemas
	--truncate table sistemas.dbo.mr_source_accounts_temps
	--truncate table sistemas.dbo.mr_source_presupuestos_temps




-- call to table and save as table var 
-- ===================================================================================================== --
--     	                  @section build the deployed variables to replace function split                --
-- ===================================================================================================== --
	declare @bussiness_unit table	
	(
		bunit		nvarchar(6) collate sql_latin1_general_cp1_ci_as
	)
	insert into @bussiness_unit
		select item from integraapp.dbo.fnsplit(@bunit, @delimiter)

	-- select * from @bussiness_unit
							
	declare @iesimus_segment table
	(
		iesegment		nvarchar(1) collate sql_latin1_general_cp1_ci_as
	)
	insert into @iesimus_segment
		select item from integraapp.dbo.fnsplit(@iesegment,@delimiter)
	
	 --select * from @iesimus_segment 

	declare @operations table
	(
		_drop		nvarchar(2) collate sql_latin1_general_cp1_ci_as
	)
	insert into @operations
		select item from integraapp.dbo.fnsplit('ag|ab|ac|ad|ae|ai|aj|av',@delimiter)
		 --select * from @operations
	
	declare @maintenance table
	(
		_drop		nvarchar(2) collate sql_latin1_general_cp1_ci_as
	)
	insert into @maintenance
		select item from integraapp.dbo.fnsplit('af|ab|ac|ad|ae|ai|aj|av',@delimiter)
		 --select * from @maintenance

	declare @finances table
	(
		_drop		nvarchar(2) collate sql_latin1_general_cp1_ci_as
	)
	insert into @finances
		select item from integraapp.dbo.fnsplit('af|ag|ac|ad|ae|ai|aj|av',@delimiter)
		 --select * from @finances
	
	declare @drop table
	(
		_drop		nvarchar(2) collate sql_latin1_general_cp1_ci_as
	)
-- set the table for companies
	

	-- print 'the key for this query is => ' + @_key
	
	-- search the id_source_controls
	select @control_key = (select id from sistemas.dbo.mr_source_controls where source_company = @bunit and _key = @_key)
	
	-- print 'the id key for mr_control => '
	-- print @control_key

	--delete 
	--select * 
	--from sistemas.dbo.mr_source_accounts where mr_source_controls_id = @control_key
	-- were delete the rows ? 
-- ===================================================================================================== --
--     	                  @section build the deployed accounts as @config_accounts                       --
-- ===================================================================================================== --
	--select * from @config_accounts 
	
	declare accounts_deploy_cursor cursor for (
												select distinct rangeaccounta,segmenta,segmentb,_key from @config_accounts
											  )
											  
	open accounts_deploy_cursor
		fetch next from accounts_deploy_cursor into @acct,@thirdsegment,@thirdsegment_sec,@_key
			while @@fetch_status = 0
				begin
				
				-------------------------------
				
				if @thirdsegment_sec = '' and @thirdsegment = ''
					begin
						if substring(@_key,1,1) = 'o' 
							begin
								delete from  @drop
								insert into @drop select _drop from @operations -- operations => af
							end
						else if substring(@_key,1,1) = 'm' 
							begin
								delete from  @drop
								insert into @drop select _drop from @maintenance -- maintenance => ag
							end
						else if substring(@_key,1,1) = 'a'
							begin
								delete from  @drop
								insert into @drop select _drop from  @finances -- finances => ab
							end
						else
							begin
								delete from @drop  -- jejeje!
							end
						--about this af is almacen and ag is mantenimiento so only this 2 ah and finances is ab
						declare deploy_cursor cursor for (
															select distinct
																
																@acct + substring(sub,1,15) as 'subaccount'
																 
															from integraapp.dbo.subacct
															where 
																	substring(integraapp.dbo.subacct.sub,1,1) in (
																													--select item from integraapp.dbo.fnsplit(@iesegment, @delimiter)
																													select iesegment from @iesimus_segment 
																												 )
																and
																	substring(integraapp.dbo.subacct.sub,8,2) in (
																													  select 
																															idbase 
																													  from 
																															@idbase 
																													  where 
																															idsl in (
																																		select bunit from @bussiness_unit
																																	)
	       																							--				  select distinct idbase 
																													  --from [integraapp].[dbo].[xrefcia] -- where idsl in ('TBKORI')
																													  --where idsl in (
																															--			--select item from integraapp.dbo.fnsplit(@bunit, @delimiter)
																															--			select bunit from @bussiness_unit
																															--		)
																												 )
																and 
																	substring(integraapp.dbo.subacct.sub,10,2) not in (
																														--select item from integraapp.dbo.fnsplit(@drop, @delimiter)
																														select _drop from @drop -- this is the idea
																												   )
															)
						open deploy_cursor
							fetch next from deploy_cursor into @inner_account
								while @@fetch_status = 0
									begin


											declare inner_unit_cursor cursor for (--review
																					select 
																							cpnyid 
																					from 
																							@cpnyid
																					where substring(@bunit,1,3) = substring(cpnyid,1,3)
																				  )
											open inner_unit_cursor
												fetch next from inner_unit_cursor into @inner_unit
													while @@fetch_status = 0
														begin
														insert @deploy_accounts
															select @control_key,@inner_account , @inner_unit ,@bunit ,@_key, 1 
														

															-- -------------------------- --
															-- build presupuesto section  --
															-- -------------------------- --
															print 'INNERACCOUNT FOR PRESUPUESTO ONLY ACCT both segments empty=> '+ substring(@inner_account,1,10) + ' sub => ' + substring(@inner_account,11,15)
																insert into @deploy_presupuesto
																	select 
																					Acct,Sub,CpnyID,[PtdBal00],[PtdBal01],[PtdBal02],[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],[PtdBal07],[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],FiscYr,@_key as _key, @bunit as _source_company
																	from 
																					integraapp.dbo.AcctHist 
																	where 
																					Acct = substring(@inner_account,1,10)
																				and 
																					FiscYr = @prep_year
																				and 
																					LedgerID = 'PRESUP' + FiscYr 
																				and 
																					CpnyID = @inner_unit
			 																	and 
																					substring(Sub,1,15) = substring(@inner_account,11,15)

															-- -------------------------- --
															-- build presupuesto section  --
															-- -------------------------- --

														fetch next from inner_unit_cursor into @inner_unit
														end
												close inner_unit_cursor
												deallocate inner_unit_cursor
													
									fetch next from deploy_cursor into @inner_account
									end
						close deploy_cursor
						deallocate deploy_cursor
															
					end
					
				else if @thirdsegment_sec = ''
					begin
					declare deploy_cursor cursor for (
															select distinct
																@acct + substring(sub,1,15) as 'subaccount'
																 
															from integraapp.dbo.subacct
															where 
																	substring(integraapp.dbo.subacct.sub,1,1) in (
																													-- select item from integraapp.dbo.fnsplit(@iesegment, @delimiter)
																													select iesegment from @iesimus_segment  
																												 )
																and
																	substring(integraapp.dbo.subacct.sub,8,2) in (
																													  select 
																															idbase 
																													  from 
																															@idbase 
																													  where 
																															idsl in (
																																		select bunit from @bussiness_unit
																																	)
	       																							--				  select distinct idbase
																													  --from [integraapp].[dbo].[xrefcia]
																													  --where idsl in (
																															--			--select item from integraapp.dbo.fnsplit(@bunit, @delimiter) 
																															--			select bunit from @bussiness_unit
																															--		)
																												 )
																and 
																	substring(integraapp.dbo.subacct.sub,10,2) in (
																														@thirdsegment
																														--select item from integraapp.dbo.fnsplit(@thirdsegment, @delimiter)
																												   )
													  )
						open deploy_cursor
							fetch next from deploy_cursor into @inner_account
								while @@fetch_status = 0
									begin

		
											declare inner_unit_cursor cursor for (
																					select 
																							cpnyid 
																					from 
																							@cpnyid
																					where substring(@bunit,1,3) = substring(cpnyid,1,3)
																				  )
											open inner_unit_cursor
												fetch next from inner_unit_cursor into @inner_unit
													while @@fetch_status = 0
														begin
														insert @deploy_accounts
															select @control_key,@inner_account , @inner_unit ,@bunit ,@_key, 1 
														
															-- -------------------------- --
															-- build presupuesto section  --
															-- -------------------------- --
															print 'INNERACCOUNT FOR PRESUPUESTO ONLY ACCT 2nd segment void=> '+ substring(@inner_account,1,10) + ' sub => ' + substring(@inner_account,11,15)
																insert into @deploy_presupuesto
																	select 
																					Acct,Sub,CpnyID,[PtdBal00],[PtdBal01],[PtdBal02],[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],[PtdBal07],[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],FiscYr,@_key as _key, @bunit as _source_company
																	from 
																					integraapp.dbo.AcctHist 
																	where 
																					Acct = substring(@inner_account,1,10)
																				and 
																					FiscYr = @prep_year
																				and 
																					LedgerID = 'PRESUP' + FiscYr 
																				and 
																					CpnyID = @inner_unit
			 																	and 
																					substring(Sub,1,15) = substring(@inner_account,11,15)

															-- -------------------------- --
															-- build presupuesto section  --
															-- -------------------------- --
														fetch next from inner_unit_cursor into @inner_unit
														end
												close inner_unit_cursor
												deallocate inner_unit_cursor
											
										fetch next from deploy_cursor into @inner_account
									end
						close deploy_cursor
						deallocate deploy_cursor
					end
				else 
					begin
					declare deploy_cursor cursor for (
															select distinct
															
																@acct + substring(sub,1,15) as 'subaccount'
																 
															from integraapp.dbo.subacct
															where 
																	substring(integraapp.dbo.subacct.sub,1,1) in (
																													--select item from integraapp.dbo.fnsplit(@iesegment, @delimiter) 
																													select iesegment from @iesimus_segment 
																												 )
																and
																	substring(integraapp.dbo.subacct.sub,8,2) in (
																													  select 
																															idbase 
																													  from 
																															@idbase 
																													  where 
																															idsl in (
																																		select bunit from @bussiness_unit
																																	)
	       																							--				  select distinct idbase
																													  --from [integraapp].[dbo].[xrefcia]
																													  --where idsl in (
																															--			--select item from integraapp.dbo.fnsplit(@bunit, @delimiter) 
																															--			select bunit from @bussiness_unit
																															--		)
																												 )
																and
																	substring(integraapp.dbo.subacct.sub,10,2) between @thirdsegment and @thirdsegment_sec
													)
						open deploy_cursor
							fetch next from deploy_cursor into @inner_account
								while @@fetch_status = 0
									begin

											declare inner_unit_cursor cursor for (
																					select 
																							cpnyid 
																					from 
																							@cpnyid
																					where substring(@bunit,1,3) = substring(cpnyid,1,3)
																				  )
											open inner_unit_cursor
												fetch next from inner_unit_cursor into @inner_unit
													while @@fetch_status = 0
														begin
														insert @deploy_accounts
															select @control_key,@inner_account , @inner_unit ,@bunit ,@_key, 1 
														
															-- -------------------------- --
															-- build presupuesto section  --
															-- -------------------------- --
															print 'INNERACCOUNT FOR PRESUPUESTO ONLY ACCT both segment not null=> '+ substring(@inner_account,1,10) + ' sub => ' + substring(@inner_account,11,15)
																insert into @deploy_presupuesto
																	select 
																					Acct,Sub,CpnyID,[PtdBal00],[PtdBal01],[PtdBal02],[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],[PtdBal07],[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],FiscYr,@_key as _key, @bunit as _source_company
																	from 
																					integraapp.dbo.AcctHist 
																	where 
																					Acct = substring(@inner_account,1,10)
																				and 
																					FiscYr = @prep_year
																				and 
																					LedgerID = 'PRESUP' + FiscYr 
																				and 
																					CpnyID = @inner_unit
			 																	and 
																					substring(Sub,1,15) = substring(@inner_account,11,15)

															-- -------------------------- --
															-- build presupuesto section  --
															-- -------------------------- --
														fetch next from inner_unit_cursor into @inner_unit
														end
												close inner_unit_cursor
												deallocate inner_unit_cursor

										fetch next from deploy_cursor into @inner_account
									end
						close deploy_cursor
						deallocate deploy_cursor
					end
				-------------------------------
								
				fetch next from accounts_deploy_cursor into @acct,@thirdsegment,@thirdsegment_sec,@_key
				end
				
		close accounts_deploy_cursor
	deallocate accounts_deploy_cursor

	if @truncate_table = 1 
		begin
			truncate table sistemas.dbo.mr_source_accounts_temps
			truncate table sistemas.dbo.mr_source_presupuestos_temps
		end											 
	else 
		begin
			delete from sistemas.dbo.mr_source_accounts_temps where source_company = @bunit and _key = @_key
			delete from sistemas.dbo.mr_source_presupuestos_temps where _source_company = @bunit and _key = @_key and FiscYr = @prep_year
		end

	insert into sistemas.dbo.mr_source_accounts_temps
												select distinct
													mr_sources_controls_id,
													subaccount,
													company,
													source_company,
													_key,
													_status
												from @deploy_accounts

	insert into sistemas.dbo.mr_source_presupuestos_temps
												select 
													distinct 
													Acct,Sub,CpnyID,
													[PtdBal00],[PtdBal01],[PtdBal02],[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],
													[PtdBal07],[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],FiscYr, _key ,_source_company
												from 
													@deploy_presupuesto


---- go
