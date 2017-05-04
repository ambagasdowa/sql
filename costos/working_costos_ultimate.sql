
--USE sistemas
---- go
/****** Object:  UserDefinedFunction [dbo].[sp_build_mr_accounts]    Script Date: 04/29/2016 01:36:17 p.m. ******/
--SET ANSI_NULLS ON
---- go
--SET QUOTED_IDENTIFIER ON
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
 
--ALTER PROCEDURE [dbo].[sp_build_mr_accounts]
-- (
	declare @bunit nvarchar(6) -- for the moment only works with one company definition
	declare @iesegment nvarchar(4000)
	declare @truncate_table int
	declare @prep_year nvarchar(4)
	declare @key nvarchar(2)
	declare @delimiter varchar(1) -- use pipeline
-- )
-- with encryption
-- as 
	set @bunit = 'TBKORI'
	set @iesegment = '0|7|8'
	set @truncate_table = 0
	set @prep_year = '2017'
	set @key = 'OF'
	set @delimiter = '!'

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
--	delete from mr_source_deployment_accounts where _key = @_key
--	insert  mr_source_deployment_accounts

	
			select 
					rangeaccounta,
					_key,
					(select '1') as _status
			from @config_accounts 
			
	select * from @config_accounts --until hir this can be static how often must be dinamic ? always 
-- result 452 accounts

	

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
												select rangeaccounta,segmenta,segmentb,"_key" from @config_accounts
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

--	if @truncate_table = 1 
--		begin
--			truncate table sistemas.dbo.mr_source_accounts_temps
--			truncate table sistemas.dbo.mr_source_presupuestos_temps
--		end											 
--	else 
--		begin
--			delete from sistemas.dbo.mr_source_accounts_temps where source_company = @bunit and _key = @_key
--			delete from sistemas.dbo.mr_source_presupuestos_temps where _source_company = @bunit and _key = @_key and FiscYr = @prep_year
--		end

--	insert into sistemas.dbo.mr_source_accounts_temps
												select distinct
													mr_sources_controls_id,
													subaccount,
													company,
													source_company,
													_key,
													_status
												from @deploy_accounts

--	insert into sistemas.dbo.mr_source_presupuestos_temps
												select 
													distinct 
													Acct,Sub,CpnyID,
													[PtdBal00],[PtdBal01],[PtdBal02],[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],
													[PtdBal07],[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],FiscYr, _key ,_source_company
												from 
													@deploy_presupuesto

	
	
-- ================================================================================================================================== --
-- 												Source ManagementReporter Main														  --
-- ================================================================================================================================== --

--
--select ID,* from ManagementReporter.dbo.ControlColumnMaster where Name = 'Edoresv1.1'
--
--select * from ManagementReporter.dbo.ControlColumnHeader
--
--
--
select * from ManagementReporter.dbo.ControlRowMaster 
													
select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1'



 -- check edores
 
select * from ManagementReporter.dbo.ControlRowDetail 
where RowFormatID = (select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1')
order by RowNumber,RowCode

select * from ManagementReporter.dbo.ControlRowDetail 
where RowFormatID = (select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1')
and RowCode = '220'
order by RowNumber,RowCode

--													
--select Code,Name from ManagementReporter.dbo.ControlCompany
--
--select CpnyID,CpnySub,CpnyName from integrasys.dbo.Company
--
--select * from integrasys.dbo.InterCompany
--
--select * from integrasys.dbo.AcctSub
--
--select * from integraapp.dbo.SubAcct
--
--select * from integraapp.dbo.Vendor
--
--select * from integraapp.dbo.xrefcia
--
--select * from integraapp.dbo.xrefciaant
--
--select * from integraapp.dbo.xrefciameg
--
--
--select idbase,idsl from integraapp.dbo.xrefcia group by idbase,idsl
--
--select idbase,idsl from integraapp.dbo.xrefciaant group by idbase,idsl


-- ================================================================================================================================== --
-- 												Source OF																			  --
-- ================================================================================================================================== --

select * from sistemas.dbo.mr_source_deployment_accounts

select * from sistemas.dbo.mr_source_mains where "_key" = 'OF'

-- OF 

select * from sistemas.dbo.reporter_views_acounts_costos

select * from sistemas.dbo.reporter_views_bussiness_units

--select 24*238

-- ================================================================================================================================== --

-----------------------------------------------------------------------------------------------------------
--	           	                     build the accounts call                                             --
-----------------------------------------------------------------------------------------------------------						

-- ===================================================================================================== --
--	           	                     insert into the deployment accounts                                 --
-- ===================================================================================================== --

with costos as (
					select 
								 bsu.idbase as 'segmentx' , bsu.idsl as 'bsu'
								,costs.rangeaccounta,costs.segmenta,costs.segmentb,costs."_key"
					from 
								sistemas.dbo.reporter_views_bussiness_units as bsu
					inner join 
								sistemas.dbo.reporter_view_sp_xs4z_accounts as costs
								on  1 = 1
				)
select 
			 cost.segmentx ,cost.bsu
			,cost.rangeaccounta,cost.segmenta,cost.segmentb,cost."_key"
			,gl.Acct, gl.Sub, gl.CpnyID
			,ISNULL(gl.CuryCrAmt * gl.CuryRate,0.0) as 'Abono'
			,ISNULL(gl.CuryDrAmt * gl.CuryRate,0.0) as 'Cargo'
			,gl.PerPost
			,gl.FiscYr
from
			costos as cost
	inner join 
			integraapp.dbo.GLTran as gl
		on 
			substring(gl.Sub,8,2) = cost.segmentx
		and
			gl.Posted = 'P' and gl.LedgerID = 'REAL'
		and 
			gl.Acct = cost.rangeaccounta
		and	-- start the logic for all the segments
			(
			--condition 1
				( 
						cost.segmentb is not null and cost.segmenta is not null -- when mode is equal then omit this and use the next case else use the limit defined in the or clause
			    	and 
					   	substring(gl.Sub,10,6)  between replace(cost.segmenta,'?',' ') and replace(cost.segmentb,'?',' ')
				)
--			--condition 2
				or
				(
						(cost.segmentb is null or cost.segmentb = '' ) and cost.segmenta is not null
					and
						substring(gl.Sub,10,6)  = replace(cost.segmenta,'?',' ')
				)
				or
				(
						(cost.segmentb is null or cost.segmentb = '' ) and (cost.segmenta is null or cost.segmenta = '' )
					and
						substring(gl.Sub,10,6) like '%'
				)
			 )
where
			gl.FiscYr in ( year(CURRENT_TIMESTAMP), year(dateadd(year,-1,CURRENT_TIMESTAMP)) )



-- ================================================================================================================================== --			

			
select * from sistemas.dbo.mr_source_reports as rp where rp._company= 'ATMMAC' and rp."_key" = 'MV' and rp."_period" = '201703'

select 
		 gl.Acct, gl.Sub, gl.CpnyID
		,ISNULL(gl.CuryCrAmt * gl.CuryRate,0.0) as 'Abono'
		,ISNULL(gl.CuryDrAmt * gl.CuryRate,0.0) as 'Cargo'		
from integraapp.dbo.GLTran as gl 
where gl.PerPost = '201703' 
	and CpnyID = 'TBKORI' 
	and gl.Acct = '0501010100'
	and	gl.Posted = 'P' and gl.LedgerID = 'REAL' 
	and substring(gl.Sub,8,2) in ('AI')
	and
	    	
-- ==================================================================================================================== --	
-- =====================   building account report compatible with as mr_* tables   =================================== --
-- ==================================================================================================================== --
-- select * from sistemas.dbo.reporter_view_gltran_account_rows			
select -- Get Acoounts
			case substring("rows".PerPost,5,2)
						when '01' then 'Enero'
						when '02' then 'Febrero'
						when '03' then 'Marzo'
						when '04' then 'Abril'
						when '05' then 'Mayo'
						when '06' then 'Junio'
						when '07' then 'Julio'
						when '08' then 'Agosto'
						when '09' then 'Septiembre'
						when '10' then 'Octubre'
						when '11' then 'Noviembre'
						when '12' then 'Diciembre'
						else 'other'
				 end as 'Mes'
			,"rows".Acct as 'NoCta'
			,"account".Descr as 'NombreCta'
			,"rows".PerEnt as 'PerEnt'
			,"rows".CpnyID as 'Compania'
			,"rows".JrnlType as 'Tipo'
			,"rows".Sub as 'Entidad'
			,"rows".TranType as 'TipoTransaccion'
			,"rows".RefNbr as 'Referencia'
			,"rows".ExtRefNbr as 'ReferenciaExterna'
			,"rows".TranDesc as 'Descripcion'
			,"rows".Abono as 'Abono'
			,"rows".Cargo as 'Cargo'
			,"rows".Cargo -"rows".Abono as 'Real'
			,'' as 'Percent'
			,"rows".segmentx as 'UnidadNegocio'
			,substring("rows".Sub,10,6) as 'CentroCosto'
			,"sub".Descr as 'NombreEntidad'
			,"rows".bsu as '_source_company'
			,"rows".PerPost as '_period'
			,"rows"."_key" as '_key'
			,' ' as 'Presupuesto'
			,"rows".FiscYr
from 
			sistemas.dbo.reporter_view_gltran_account_rows as "rows"
	inner join 
			integraapp.dbo.Account as "account"
		on "rows".rangeaccounta = account.Acct
	inner join 
			integraapp.dbo.SubAcct as "sub"
		on "rows".Sub = sub.Sub
		
union all

select -- Get Presupuesto
		 "per"."month" as 'Mes'
		,"bug".Acct as 'NoCta'
		,"bug".Descr as 'NombreCta'
		,'' as 'PerEnt'
		,"bug".CpnyID as 'Compania'
		,'' as 'Tipo'
		,"bug".Sub as 'Entidad'
		,'' as 'TipoTransaccion'
		,'' as 'Referencia'
		,'' as 'ReferenciaExterna'
		,'' as 'Descripcion'
		,'' as 'Abono'
		,'' as 'Cargo'
		,'' as 'Real'
		,'' as 'Percent'
		,"bug".segmentx as 'UnidadNegocio'
		,substring("bug".Sub,10,6) as 'CentroCosto'
		,"bug".subdesc as 'NombreEntidad'
		,"bug"."_source_company" '_source_company'
 		,"per".period as "_period"
 		,"bug"."_key" as '_key'
		,case
			when "per".id_month = '01' then "bug".PtdBal00
			when "per".id_month = '02' then "bug".PtdBal01
			when "per".id_month = '03' then "bug".PtdBal02
			when "per".id_month = '04' then "bug".PtdBal03
			when "per".id_month = '05' then "bug".PtdBal04
			when "per".id_month = '06' then "bug".PtdBal05
			when "per".id_month = '07' then "bug".PtdBal06
			when "per".id_month = '08' then "bug".PtdBal07
			when "per".id_month = '09' then "bug".PtdBal08
			when "per".id_month = '10' then "bug".PtdBal09
			when "per".id_month = '11' then "bug".PtdBal10
			when "per".id_month = '12' then "bug".PtdBal11
		end as 'Presupuesto'
		,"bug".FiscYr
from 
		sistemas.dbo.reporter_views_years as "per"
left join 
		sistemas.dbo.reporter_view_account_hist_bugs as "bug"
	on
		substring("per".period,1,4) = "bug".FiscYr


-- ==================================================================================================================== --	
-- =====================    building budget report compatible with as mr_* tables   =================================== --
-- ==================================================================================================================== --
-- 4751	
with presupuesto as 
				(
					select 
								 bsu.idbase as 'segmentx' , bsu.idsl as '_source_company'
								,costs.rangeaccounta as "Acct",costs.segmenta,costs.segmentb,costs."_key"
					from 
								sistemas.dbo.reporter_views_bussiness_units as bsu
					inner join 
								sistemas.dbo.reporter_view_sp_xs4z_accounts as costs
								on  1 = 1
				)
select 
			 "prep".segmentx
			,"prep".Acct
			,"hist".Sub,"hist".CpnyID
			,"hist".PtdBal00 ,"hist".PtdBal01 ,"hist".PtdBal02 ,"hist".PtdBal03 ,"hist".PtdBal04 
			,"hist".PtdBal05 ,"hist".PtdBal06 ,"hist".PtdBal07 ,"hist".PtdBal08 ,"hist".PtdBal09 
			,"hist".PtdBal10 ,"hist".PtdBal11 ,"hist".PtdBal12 ,"hist".FiscYr
			,"prep"."_key" 
			,"prep"."_source_company"
			,"account".Descr
			,"sub".Descr
from 
			presupuesto as "prep"
inner join 
			integraapp.dbo.Account as "account"
	on	
			"account".Acct = "prep".Acct
inner join
			integraapp.dbo.AcctHist as "hist"
	on
			"hist".Acct = "prep".Acct and "hist".FiscYr in ( year(CURRENT_TIMESTAMP), year(dateadd(year,-1,CURRENT_TIMESTAMP)) )
		and
			"hist".LedgerID = 'PRESUP' + "hist".FiscYr --and "hist".CpnyID = "prep"."_company"
		and
			substring("hist".Sub,8,2) = "prep".segmentx
		and	-- start the logic for all the segments
			(
			--condition 1
				( 
						"prep".segmentb is not null and "prep".segmenta is not null -- when mode is equal then omit this and use the next case else use the limit defined in the or clause
			    	and 
					   	substring("hist".Sub,10,6)  between replace("prep".segmenta,'?',' ') and replace("prep".segmentb,'?',' ')
				)
--			--condition 2
				or
				(
						("prep".segmentb is null or "prep".segmentb = '' ) and "prep".segmenta is not null
					and
						substring("hist".Sub,10,6)  = replace("prep".segmenta,'?',' ')
				)
				or
				(
						("prep".segmentb is null or "prep".segmentb = '' ) and ("prep".segmenta is null or "prep".segmenta = '' )
					and
						substring("hist".Sub,10,6) like '%'
				)
			 )
inner join
			integraapp.dbo.SubAcct as "sub"
	on
			"hist".Sub = "sub".Sub
--			
			
-- ==================================================================================================================== --	
-- =====================    building budget report view for union with data         =================================== --
-- ==================================================================================================================== --
-- 4751		

select * from sistemas.dbo.reporter_view_account_hist_bugs

select * from sistemas.dbo.reporter_views_years 

-- ==================================================================================================================== --

select * from sistemas.dbo.reporter_view_account_hist_bugs where "_key" = 'AD'



select 
		 "per"."month" as 'Mes'
		,"bug".Acct as 'NoCta'
		,"bug".Descr as 'NombreCta'
		,'' as 'PerEnt'
		,"bug".CpnyID as 'Compania'
		,'' as 'Tipo'
		,"bug".Sub as 'Entidad'
		,'' as 'TipoTransaccion'
		,'' as 'Referencia'
		,'' as 'ReferenciaExterna'
		,'' as 'Descripcion'
		,'' as 'Abono'
		,'' as 'Cargo'
		,'' as 'Real'
		,'' as 'Percent'
		,"bug".segmentx as 'UnidadNegocio'
		,substring("bug".Sub,10,6) as 'CentroCosto'
		,"bug".subdesc as 'NombreEntidad'
		,"bug"."_source_company" '_source_company'
 		,"per".period as "_period"
 		,"bug"."_key" as '_key'
		,case
			when "per".id_month = '01' then "bug".PtdBal00
			when "per".id_month = '02' then "bug".PtdBal01
			when "per".id_month = '03' then "bug".PtdBal02
			when "per".id_month = '04' then "bug".PtdBal03
			when "per".id_month = '05' then "bug".PtdBal04
			when "per".id_month = '06' then "bug".PtdBal05
			when "per".id_month = '07' then "bug".PtdBal06
			when "per".id_month = '08' then "bug".PtdBal07
			when "per".id_month = '09' then "bug".PtdBal08
			when "per".id_month = '10' then "bug".PtdBal09
			when "per".id_month = '11' then "bug".PtdBal10
			when "per".id_month = '12' then "bug".PtdBal11
		end as 'Presupuesto'
		,"bug".FiscYr
from 
		sistemas.dbo.reporter_views_years as "per"
left join 
		sistemas.dbo.reporter_view_account_hist_bugs as "bug"
	on
		substring("per".period,1,4) = "bug".FiscYr
		
where
		"bug".Acct = '0501010100'
	and 
		"bug".CpnyID = 'ATMMAC'
	and
		"bug"."_key" = 'OF'

		


exec sp_desc reporter_views_years

exec sp_desc reporter_view_account_hist_bugs
-- ===============


use integraapp
IF OBJECT_ID ('fetchCostosFijosOpOrizaba', 'V') IS NOT NULL
	drop view fetchCostosFijosOpOrizaba;
create view fetchCostosFijosOpOrizaba
as                                                                             
select 
		 "acc".Mes
		,"acc".NoCta
		,"acc".NombreCta
		,"acc".PerEnt
		,"acc".Compania as 'Compañía'
		,"acc".Tipo
		,"acc".Entidad
		,'' as 'distinto'
		,"acc".TipoTransaccion as 'tipoTransacción'
		,"acc".Referencia
		,"acc".ReferenciaExterna as 'FechaTransacción'
		,"acc".Descripcion as 'Descripción'
		,"acc".Abono
		,"acc".Cargo
		,"acc".UnidadNegocio
		,"acc".CentroCosto
		,"acc".NombreEntidad
		,"acc".Presupuesto
		,"acc".FiscYr as 'Año'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_key" = 'OF' and "acc"."_source_company" = 'TBKORI' and "acc".UnidadNegocio not in ('00')




exec sp_helptext reporter_view_report_accounts
exec sp_desc reporter_view_report_accounts




select * from integraapp.dbo.fetchCostosFijosOpOrizaba


use integraapp
IF OBJECT_ID ('fetchCostosFijosOpOrizaba', 'V') IS NOT NULL
	drop view fetchCostosFijosOpOrizaba;
	
CREATE VIEW dbo.fetchCostosFijosOpOrizaba
AS                                                                             
SELECT Mes, NoCta, NombreCta, PerEnt, Compañía, Tipo, Entidad, distinto,       
   tipoTransacción, Referencia, FechaTransacción, Descripción, Abono,          
   Cargo, UnidadNegocio, CentroCosto, NombreEntidad, Presupuesto,              
   SUBSTRING(_period, 1, 4) AS 'Año'                                           
FROM sistemas.dbo.mr_source_reports                                            
WHERE (_key = 'OF') AND (_company = 'TBKORI')                                  

use integraapp
exec sp_helptext fetchCostosAdministracionGst



create
	view fetchCostosAdministracionGst --with encryption                                                                                                                                                     
	as select
		Mes,
		NoCta,
		NombreCta,
		PerEnt,
		Compañía,
		Tipo,
		Entidad,
		distinto,
		tipoTransacción,
		Referencia,
		FechaTransacción,
		Descripción,
		Abono,
		Cargo,
		UnidadNegocio,
		CentroCosto,
		NombreEntidad,
		Presupuesto,
		substring( _period, 1, 4 ) as Año
	from
		sistemas.dbo.mr_source_reports
	where
		(
			_key = 'AD'
		)

select * from "integraapp"."dbo"."fetchCostosAdministracionGstDin"

select * from "integraapp"."dbo"."fetchCostosAdministracionGst" where 0 = 1

select UnidadNegocio,count(UnidadNegocio), 'old' as 'query' from "integraapp"."dbo"."fetchCostosAdministracionGst" where Año = '2017' 
group by UnidadNegocio
union all
select UnidadNegocio,count(UnidadNegocio), 'ultimate' as 'query' from sistemas.dbo.reporter_view_report_accounts where FiscYr = '2017' and "_key" = 'AD' 
group by UnidadNegocio
-- ===============

-- ================================ original Presupuesto ============================================= --

--		select * from sistemas.dbo.mr_source_presupuestos_temps as "prep" where 1=0
--		where "prep".FiscYr = '2017' and "prep".Acct = '0501010100' and "prep".CpnyID = 'TBKORI'
--		and "prep"."_key" = 'OF'


with acc as (
select  NoCta
		,sum(Cargo-Abono) as 'Real'
		,sum(Presupuesto) as 'Presupuesto'
		,"_source_company"
		,Compania
		,'report_split' as 'query'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_period" = '201704' and "acc"."_source_company" = 'TCGTUL' and "acc".UnidadNegocio not in ('00') and "_key"= 'OF'
group by "_source_company",Compania,NoCta

union all

select  NoCta
		,sum(Cargo-Abono) as 'Real'
		,sum(Presupuesto) as 'Presupuesto'
		,"_source_company"
		,Compania
		,'report_split' as 'query'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_period" = '201704' and "acc"."_source_company" = 'TEICUA' and Compania = 'TCGTUL' and "acc".UnidadNegocio not in ('00') and "_key"= 'OF'
group by "_source_company",Compania,NoCta
) select * from acc order by "_source_company"




select 
		 sum(Cargo-Abono) as 'Real'
		,sum(Presupuesto) as 'Presupuesto'
		,"_source_company"
		,'' as 'Compania'
		,'report' as 'query'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_period" = '201704' and "acc"."_source_company" = 'TEICUA' and "acc".UnidadNegocio not in ('00') and = 'OF'
group by "_source_company"

union all		

select  
		 sum(Cargo-Abono) as 'Real'
		,sum(Presupuesto) as 'Presupuesto'
		,"_source_company"
		,Compania
		,'report_split' as 'query'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_period" = '201704' and "acc"."_source_company" = 'TEICUA' and "acc".UnidadNegocio not in ('00') and "_key"= 'OF'
group by "_source_company",Compania

union all
		
select 
		 sum(Cargo-Abono) as 'Real'
		,sum(Presupuesto) as 'Presupuesto'
		,'' as "_source_company"
		,Compañía
		,'mr' as 'query'
from 
		sistemas.dbo.mr_source_reports where "_period" = '201704' and "_company" = 'TEICUA' and UnidadNegocio not in ('00') and "_key" = 'OF'
group by
		Compañía



							------
							
		
select 
		 NoCta
		,sum(Cargo-Abono) as 'Real'
		,sum(Presupuesto) as 'Presupuesto'
		,"_source_company"
		,'' as 'Compania'
		,"_key" as 'key'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_period" = '201704' and "acc"."_source_company" = 'TEICUA' and "_key" = 'OV'
--		and "acc".UnidadNegocio not in ('00')
group by "_source_company","_key",NoCta
order by NoCta


select * from sistemas.dbo.reporter_view_report_accounts where "_source_company" = 'TEICUA' and "_key" = 'OV' and "_period" = '201704' and NoCta = '0501040700'

select * from sistemas.dbo.reporter_view_report_accounts where "_source_company" = 'TEICUA' and "_key" = 'OV' and "_period" = '201704' and UnidadNegocio in ('00')

select * from sistemas.dbo.reporter_view_sp_xs4z_accounts where rangeaccounta in ('0501040700','0501160401','0501170700') and "_key" = 'OV'

select * from sistemas.dbo.reporter_view_sp_xs4z_accounts where "_key" = 'OV'

select 
		 sum(Cargo-Abono) as 'Real'
		,sum(Presupuesto) as 'Presupuesto'
		,"_source_company"
		,'' as 'Compania'
		,'report' as 'query'
from 
		sistemas.dbo.reporter_view_report_accounts as "acc"
where 
		"acc"."_period" = '201704' and "acc"."_source_company" = 'TEICUA' and "acc".UnidadNegocio not in ('00') and "_key" = 'MF'
group by "_source_company"




select
			 sum("acc".Cargo-"acc".Abono) as 'Real'
			,sum("acc".Presupuesto) as 'Presupuesto'
			,"acc"."_source_company"
			,"acc"."_key"
			,"acc"."_period"
from 
			sistemas.dbo.reporter_view_report_accounts as "acc"
where 
			"acc"."_period" = '201704' and "acc".UnidadNegocio not in ('00') --and "acc".NoCta = '0501040700'
group by 
			"acc"."_source_company","acc"."_period","acc"."_key"
order by 
			"acc"."_source_company"
			
			
select
			 sum("acc".Cargo-"acc".Abono) as 'Real'
			,sum("acc".Presupuesto) as 'Presupuesto'
			,"acc"."_source_company"
			,"acc"."_key"
			,"acc"."_period"
from 
			sistemas.dbo.reporter_view_report_accounts as "acc"
where 
			"acc"."_period" = '201704' and "acc".UnidadNegocio not in ('00') and "acc"."_key" = 'AD' --and "acc".NoCta = '0501040700'
group by 
			"acc"."_source_company","acc"."_period","acc"."_key"
order by 
			"acc"."_source_company"

