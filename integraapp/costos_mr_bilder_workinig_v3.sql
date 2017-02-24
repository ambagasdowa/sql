--declare @source_table table	
--(
--	SubAccount		varchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
--	company			varchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
--	source_company	varchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
--	period			varchar(4000) collate SQL_Latin1_General_CP1_CI_AS,
--	_key			varchar(2) collate SQL_Latin1_General_CP1_CI_AS,
--	_status			varchar(1) collate SQL_Latin1_General_CP1_CI_AS
--)

--insert into @source_table values 
--					('05011604010000000AITT','TBKGDL','TBKGDL','201601','OV','1')
--					,('05011604018000000AITT','TBKGDL','TBKGDL','201601','OV','1')
--					--('05011609000000000AAAF    000000','TBKORI','TBKORI','201511','OF','1'),('05011609008000000AAAF    000000','TBKORI','TBKORI','201511','OF','1'),
--					--('05011609000000000AAAG    000000','TBKORI','TBKORI','201510','MV','1'),('05011609008000000AAAF    000000','TBKORI','TBKORI','201510','MF','1'),
--					--('05010608510000000AATT1000TT1000','TBKORI','TBKORI','201511','OF','1'),('05010608510000000AATT1000TT1000','TBKORI','TBKORI','201510','OF','1'),
--					--('05011799000000000AAAF    000000','TBKORI','TBKORI','201511','OF','1'),('05011703000000000AAAF    000000','TBKORI','TBKORI','201511','OF','1'),
--					--('05010301000000000AIAF    000000','TBKGDL','TBKORI','201511','OF','1'),('05010301008000000AIAF    000000','TBKGDL','TBKORI','201511','OF','1'),
--					--('05011609000000000AIAF    000000','TBKGDL','TBKORI','201511','OF','1'),('05011609008000000AIAF    000000','TBKGDL','TBKORI','201511','OF','1'),
--					--('05011609000000000AIAG    000000','TBKGDL','TBKORI','201510','MV','1'),('05011609008000000AIAF    000000','TBKGDL','TBKORI','201510','MF','1'),
--					--('05010608510000000AITT1000TT1000','TBKGDL','TBKGDL','201511','OF','1'),('05010608510000000AITT1000TT1000','TBKGDL','TBKORI','201510','OF','1'),
--					--('05011799000000000AIAF    000000','TBKGDL','TBKORI','201511','OF','1'),('05011703000000000AIAF    000000','TBKGDL','TBKORI','201511','OF','1'),
--					--('05010902000000000AAAF    000000','TBKORI','TBKORI','201511','OF','1'),('05010902000000000AIAF    000000','TBKGDL','TBKORI','201511','OF','1'),
--					--('05010902008000000AAAF    000000','TBKORI','TBKGDL','201511','OF','1'),('05010902008000000AIAF    000000','TBKGDL','TBKORI','201511','OF','1')
--					;

--select * from @source_table


-----------------------------------------------------------------------------------------------------------
--	           	                     check the sources                                                 --
-----------------------------------------------------------------------------------------------------------
-- '0501040400'
--+	[0501050300]			[cs????:zz????]
--+	[0501050400]			[cs????:zz????]
--+	[0501070400]			[cs????:zz????]
--+	[0501110300]			[cs????:zz????]
--+	[0501110400]			[cs????:zz????]
--+	[0501170300]			[cs????:zz????]
--+	[0501040400]			[cs????:zz????]
--+	[0501040500]			[cs????:zz????]
--+	[0501040600]			[cs????:zz????]
--+	[0501050200]			[cs????:zz????]
--+	[0501070300]			[cs????:zz????]
--+	[0501070500]			[cs????:zz????]
--+	[0501080500]			[cs????:zz????]
--+	[0501080600]			[cs????:zz????]
--+	[0501080700]			[cs????:zz????]
--+	[0501080800]			[cs????:zz????]
--+	[0501080900]			[cs????:zz????]
--+	[0501090200]			[cs????:zz????]
--+	[0501170100]			[cs????:zz????]
--+	[0500000000:0507030000]			[af????]
--+	[0501040400]			[000000]
--+	[0501040500]			[000000]
--+	[0501040600]			[000000]
--+	[0501050200]			[000000]
--+	[0501050300]			[000000]
--+	[0501050400]			[000000]
--+	[0501070300]			[000000]
--+	[0501070400]			[000000]
--+	[0501070500]			[000000]
--+	[0501080500]			[000000]
--+	[0501080600]			[000000]
--+	[0501080700]			[000000]
--+	[0501080800]			[000000]
--+	[0501080900]			[000000]
--+	[0501090200]			[000000]
--+	[0501110300]			[000000]
--+	[0501110400]			[000000]
--+	[0501170100]			[000000]
--+	[0501170300]			[000000]
--+	[0501120100:0501120300]			[cs????:zz????]
--+	[0501060851]			
--+	[0501160900]			[cs????:zz????]
--+	[0501160900]			[000000]


-- rangeaccount or empty			segment or empty	_key of...ad...etc
-- [0501120100] [          ]		[xx    ] [xx    ] [xx]
-- [0501120100] [0501120300]		[xx    ] [xx    ] [xx]

-----------------------------------------------------------------------------------------------------------
--         	                     build the subaccount menu table                                       --
-----------------------------------------------------------------------------------------------------------

--use [sistemas]
--go
--set ansi_nulls on
--go
--set quoted_identifier on
--go
--set ansi_padding on
--go
 
--create table [dbo].[mr_source_accounts_temps](
--		id							int identity(1,1),
--		mr_sources_controls_id		int not null,
--		subaccount					nvarchar(25)	collate		sql_latin1_general_cp1_ci_as,
--		company						nvarchar(6)		collate		sql_latin1_general_cp1_ci_as,
--		source_company				nvarchar(6)		collate		sql_latin1_general_cp1_ci_as,
--		_key						nvarchar(2)		collate		sql_latin1_general_cp1_ci_as,
--		_status						int default 1 null
--) on [primary]
--go

--use [sistemas]
--go
--set ansi_nulls on
--go
--set quoted_identifier on
--go
--set ansi_padding on
--go
 
--create table [dbo].[mr_source_configs_temps](
--		id							int identity(1,1),
--		period						nvarchar(6)		collate		sql_latin1_general_cp1_ci_as,
--		subaccount					nvarchar(25)	collate		sql_latin1_general_cp1_ci_as,
--		company						nvarchar(6)		collate		sql_latin1_general_cp1_ci_as,
--		source_company				nvarchar(6)		collate		sql_latin1_general_cp1_ci_as,
--		_key						nvarchar(2)		collate		sql_latin1_general_cp1_ci_as,
--		_status						int default 1 null
--) on [primary]
--go

--set ansi_padding off
--go

--use [sistemas]
--go
--set ansi_nulls on
--go
--set quoted_identifier on
--go
--set ansi_padding on
--go
-- -- modern_spanish_ci_as
--create table [dbo].[mr_source_mains](
--	id int identity(1,1),
--	rangeaccounta	nvarchar(10) collate		sql_latin1_general_cp1_ci_as,
--	rangeaccountb	nvarchar(10) collate		sql_latin1_general_cp1_ci_as,
--	segmenta		nvarchar(6) collate		sql_latin1_general_cp1_ci_as,
--	segmentb		nvarchar(6) collate		sql_latin1_general_cp1_ci_as,
--	_key			nvarchar(2) collate		sql_latin1_general_cp1_ci_as,
--	_status int not null
--) on [primary]
--go

--set ansi_padding off
--go

--select * from sistemas.dbo.mr_source_mains
--use sistemas
--insert into sistemas.dbo.mr_source_mains values
--										('0501150100','0501153600','CS','ZZ','MV','1'),
--										('0501153700','','CS','ZZ','MV','1'),
--										('0501153800','','CS','ZZ','MV','1'),
--										('0501060700','','CS','ZZ','MV','1'),
--										('0501100300','','CS','ZZ','MV','1'),
--										('0501060100','0501060600','CS','ZZ','MV','1'),
--										('0501154000','','CS','ZZ','MV','1'),
--										('0501060800','','CS','ZZ','MV','1'),
--										('0501060900','','CS','ZZ','MV','1'),
--										('0501100200','','CS','ZZ','MV','1'),
--										('0501060100','','00','','MV','1'),
--										('0501060200','','00','','MV','1'),
--										('0501060300','','00','','MV','1'),
--										('0501060500','','00','','MV','1'),
--										('0501060600','','00','','MV','1'),
--										('0501060700','','00','','MV','1'),
--										('0501060800','','00','','MV','1'),
--										('0501060900','','00','','MV','1'),
--										('0501100200','','00','','MV','1'),
--										('0501100300','','00','','MV','1'),
--										('0501120100','','00','','MV','1'),
--										('0501120300','','00','','MV','1'),
--										('0501150100','','00','','MV','1'),
--										('0501150200','','00','','MV','1'),
--										('0501150300','','00','','MV','1'),
--										('0501150400','','00','','MV','1'),
--										('0501150500','','00','','MV','1'),
--										('0501150600','','00','','MV','1'),
--										('0501150700','','00','','MV','1'),
--										('0501150800','','00','','MV','1'),
--										('0501150900','','00','','MV','1'),
--										('0501151000','','00','','MV','1'),
--										('0501151100','','00','','MV','1'),
--										('0501151200','','00','','MV','1'),
--										('0501151300','','00','','MV','1'),
--										('0501151400','','00','','MV','1'),
--										('0501151500','','00','','MV','1'),
--										('0501151600','','00','','MV','1'),
--										('0501151700','','00','','MV','1'),
--										('0501151800','','00','','MV','1'),
--										('0501151900','','00','','MV','1'),
--										('0501152000','','00','','MV','1'),
--										('0501152100','','00','','MV','1'),
--										('0501152200','','00','','MV','1'),
--										('0501152300','','00','','MV','1'),
--										('0501152400','','00','','MV','1'),
--										('0501152500','','00','','MV','1'),
--										('0501152600','','00','','MV','1'),
--										('0501152700','','00','','MV','1'),
--										('0501152800','','00','','MV','1'),
--										('0501152900','','00','','MV','1'),
--										('0501153000','','00','','MV','1'),
--										('0501153100','','00','','MV','1'),
--										('0501153200','','00','','MV','1'),
--										('0501153300','','00','','MV','1'),
--										('0501153400','','00','','MV','1'),
--										('0501153500','','00','','MV','1'),
--										('0501153600','','00','','MV','1'),
--										('0501153700','','00','','MV','1'),
--										('0501153800','','00','','MV','1'),
--										('0501154000','','00','','MV','1'),
--										('0501120400','','','','MV','1'),
--										('0501160600','','TT','','MV','1')
-----------------------------------------------------------------------------------------------------------
	--									('0501040400','','','','of','1'),
	--									('0501050300','','cs','zz','of','1'),
	--									('0501050400','','cs','zz','of','1'),
	--									('0501070400','','cs','zz','of','1'),
	--									('0501110300','','cs','zz','of','1'),
	--									('0501110400','','cs','zz','of','1'),
	--									('0501170300','','cs','zz','of','1'),
	--									('0501040400','','cs','zz','of','1'),
	--									('0501040500','','cs','zz','of','1'),
	--									('0501040600','','cs','zz','of','1'),
	--									('0501050200','','cs','zz','of','1'),
	--									('0501070300','','cs','zz','of','1'),
	--									('0501070500','','cs','zz','of','1'),
	--									('0501080500','','cs','zz','of','1'),
	--									('0501080600','','cs','zz','of','1'),
	--									('0501080700','','','','of','1'),
	--									('0501080800','','','','of','1'),
	--									('0501080900','','','','of','1'),
	--									('0501090200','','','','of','1'),
	--									('0501170100','','','','of','1'),
	--									('0500000000','0507030000','af','','of','1'),
	--									('0501040400','','00','','of','1'),
	--									('0501040500','','00','','of','1'),
	--									('0501040600','','00','','of','1'),
	--									('0501050200','','00','','of','1'),
	--									('0501050300','','00','','of','1'),
	--									('0501050400','','00','','of','1'),
	--									('0501070300','','00','','of','1'),																				
	--									('0501070400','','00','','of','1'),
	--									('0501070500','','00','','of','1'),
	--									('0501080500','','00','','of','1'),
	--									('0501080600','','00','','of','1'),
	--									('0501080700','','00','','of','1'),
	--									('0501080800','','00','','of','1'),
	--									('0501080900','','00','','of','1'),
	--									('0501090200','','00','','of','1'),
	--									('0501110300','','00','','of','1'),
	--									('0501110400','','00','','of','1'),
	--									('0501170100','','00','','of','1'),
	--									('0501170300','','00','','of','1'),
	--									('0501120100','0501120300','cs','zz','of','1'),
	--									('0501060851','','','','of','1'),
	--									('0501160900','','00','','of','1'),
	--									('0501160900','','cs','zz','of','1')
										
	
--	select * from sistemas.dbo.mr_source_mains

-----------------------------------------------------------------------------------------------------------
--	           	                     check the subaccount                                              --
-----------------------------------------------------------------------------------------------------------

-- emulating the config tables when i'm click build the data struct
-- /*************************************************************/
-- REPLACE select * from sistemas.dbo.mr_source_mains
-- /*************************************************************/
	--declare @source_accounts table	
	--(
	--	rangeaccounta	varchar(10) collate		sql_latin1_general_cp1_ci_as,
	--	rangeaccountb	varchar(10) collate		sql_latin1_general_cp1_ci_as,
	--	segmenta		varchar(6) collate		sql_latin1_general_cp1_ci_as,
	--	segmentb		varchar(6) collate		sql_latin1_general_cp1_ci_as,
	--	_key			varchar(2) collate		sql_latin1_general_cp1_ci_as
	--)

	--insert into @source_accounts values 
	--									('0500000000','0507030000','af','','of'),
	--									('0501120100','0501120300','cs','zz','of'),
	--									('0501160900','','00','','of')
	--									--('0500000000','0501020000','af','','of')--,
	--									--('0501120100','0501120300','cs','zz','of')--,
	--									--('0501160900','','00','','of')
	--select * from @source_accounts




-----------------------------------------------------------------------------------------------------------
--	           	              deploy the config subaccount                                             --
-----------------------------------------------------------------------------------------------------------
use sistemas;
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
--	           	                     build the accounts call                                             --
-----------------------------------------------------------------------------------------------------------						
-- build the struc in a table account by account

	-- declare the fields from
	use sistemas;
	declare		@rangeaccounta varchar(10), @rangeaccountb varchar(10) ,
				@segmenta varchar(6) , @segmentb varchar(6),
				@_key varchar(2), @accounts varchar(255) ,@counter int;
					
					
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
										where	_status = '1'
									)

		open guia_cursor;
			fetch next from guia_cursor into		@rangeaccounta,
													@rangeaccountb,
													@segmenta,
													@segmentb,
													@_key
													;
				while @@fetch_status = 0
					begin
						/** only fetch the accounts */
						--if ((@rangeaccounta is not null  and @rangeaccountb is not null ) and (@rangeaccounta <> '' and @rangeaccountb <> '') )
						--	begin
						--print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key;
						--	end
						
						if ((@rangeaccounta is not null  and @rangeaccountb is not null ) and (@rangeaccounta <> '' and @rangeaccountb <> '') )
							begin
							-- print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key;
								
								declare account_cursor cursor for (
																	select acct
																	from integraapp.dbo.account
																	where 
																			integraapp.dbo.account.accttype = '5e'
																		and 
																			active = '1'
																		and 
																			acct between @rangeaccounta and @rangeaccountb
																			
																);								
																
								open account_cursor;
									fetch next from account_cursor into	@accounts; -- save into 
									
										while @@fetch_status = 0
											begin
												if @accounts is not null
													begin
														-- print 'acct => '+ @accounts + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key;
														-- INSERT INTO CONFIG ACCOUNTS
														insert @config_accounts 
															select @accounts,@segmenta,@segmentb,@_key;
													end
												fetch next from account_cursor into @accounts;					
											end				
								close account_cursor;
								deallocate account_cursor;		
							end
						else if ( ( @rangeaccounta is not null ) and ( @rangeaccountb is null or @rangeaccountb = '') )
							begin
								-- print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key;
								-- print 'acct => '+ @accounts + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key;
													-- INSERT INTO CONFIG ACCOUNTS
														insert @config_accounts 
															select @rangeaccounta,@segmenta,@segmentb,@_key;
							end 
						fetch next from guia_cursor into	@rangeaccounta,
															@rangeaccountb,
															@segmenta,
															@segmentb,
															@_key
															;
					
					end
		close guia_cursor;
	deallocate guia_cursor;




-----------------------------------------------------------------------------------------------------------
--	           	                     build the accounts                                                --
-----------------------------------------------------------------------------------------------------------

--use integraapp;
	declare  @delimiter varchar(1) , @bunit nvarchar(6) , --@_key varchar(2),
			 --@drop varchar(8000) ,
			  @thirdsegment nvarchar(6) , @thirdsegment_sec nvarchar(6),
			 @acct varchar(10),@iesegment varchar(4000);
	-- variables for inner cursor 
	declare @inner_account varchar(25),@inner_unit varchar(10),@inner_key varchar(2) , @control_key int;
			 
			 
	select @bunit = 'TBKTIJ'; -- for the moment only works with one company definition
	select @delimiter = '|';

	--select @inner_unit = 'tbkgdl';
	--select @_key = 'of';
	--select @acct = '0501010100';
	--select @thirdsegment = 'cs';
	--select @thirdsegment_sec = 'zz';
	
	select @iesegment = '0|7|8';
	--select @thirdsegment_sec = '';

	use sistemas;
	--truncate table sistemas.dbo.mr_source_accounts_temps
	--truncate table sistemas.dbo.mr_source_presupuestos_temps




-- call to table and save as table var 
-- ---------------------------------------------------------------------------------------------------------
--     	                  @section build the deployed variables to replace function split                 --
-- ---------------------------------------------------------------------------------------------------------
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


	-- print 'the key for this query is => ' + @_key;
	
	-- search the id_source_controls
	select @control_key = (select id from sistemas.dbo.mr_source_controls where source_company = @bunit and _key = @_key);
	
	-- print 'the id key for mr_control => ';
	-- print @control_key;

	--delete 
	--select * 
	--from sistemas.dbo.mr_source_accounts where mr_source_controls_id = @control_key
	-- were delete the rows ? 
-----------------------------------------------------------------------------------------------------------
--     	                  @section build the deployed accounts as @config_accounts                       --
-----------------------------------------------------------------------------------------------------------
	
	
	declare accounts_deploy_cursor cursor for (
												select distinct rangeaccounta,segmenta,segmentb,_key from @config_accounts
											  )
											  
	open accounts_deploy_cursor;
		fetch next from accounts_deploy_cursor into @acct,@thirdsegment,@thirdsegment_sec,@_key;
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
								delete from @drop ; -- jejeje!
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
	       																											  select distinct idbase 
																													  from [integraapp].[dbo].[xrefcia] -- where idsl in ('TBKORI')
																													  where idsl in (
																																		--select item from integraapp.dbo.fnsplit(@bunit, @delimiter)
																																		select bunit from @bussiness_unit
																																	)
																												 )
																and 
																	substring(integraapp.dbo.subacct.sub,10,2) not in (
																														--select item from integraapp.dbo.fnsplit(@drop, @delimiter)
																														select _drop from @drop -- this is the idea
																												   )
															)
						open deploy_cursor;
							fetch next from deploy_cursor into @inner_account;
								while @@fetch_status = 0
									begin


											declare inner_unit_cursor cursor for (
																					select [cpnyid]
																					from [integraapp].[dbo].[frl_entity]
																					where substring(@bunit,1,3) = substring(cpnyid,1,3)
																				  )
											open inner_unit_cursor;
												fetch next from inner_unit_cursor into @inner_unit
													while @@fetch_status = 0
														begin
														insert @deploy_accounts
															select @control_key,@inner_account , @inner_unit ,@bunit ,@_key, 1 ;
														

															-- -------------------------- --
															-- build presupuesto seciton  --
															-- -------------------------- --
															print 'INNERACCOUNT FOR PRESUPUESTO ONLY ACCT=> '+ substring(@inner_account,1,10) + ' sub => ' + substring(@inner_account,11,15)
																insert into @deploy_presupuesto
																	select 
																					Acct,Sub,CpnyID,[PtdBal00],[PtdBal01],[PtdBal02],[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],[PtdBal07],[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],FiscYr,@_key as _key, @bunit as _source_company
																	from 
																					integraapp.dbo.AcctHist 
																	where 
																					Acct = substring(@inner_account,1,10)
																				and 
																					FiscYr = year(CURRENT_TIMESTAMP)
																				and 
																					LedgerID = 'PRESUP' + FiscYr 
																				and 
																					CpnyID = @inner_unit
			 																	and 
																					substring(Sub,1,15) = substring(@inner_account,11,15);

															-- -------------------------- --
															-- build presupuesto seciton  --
															-- -------------------------- --

														fetch next from inner_unit_cursor into @inner_unit
														end
												close inner_unit_cursor;
												deallocate inner_unit_cursor;
													
									fetch next from deploy_cursor into @inner_account;
									end
						close deploy_cursor;
						deallocate deploy_cursor;
															
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
	       																											  select distinct idbase
																													  from [integraapp].[dbo].[xrefcia]
																													  where idsl in (
																																		--select item from integraapp.dbo.fnsplit(@bunit, @delimiter) 
																																		select bunit from @bussiness_unit
																																	)
																												 )
																and 
																	substring(integraapp.dbo.subacct.sub,10,2) in (
																														@thirdsegment
																														--select item from integraapp.dbo.fnsplit(@thirdsegment, @delimiter)
																												   )
													  )
						open deploy_cursor;
							fetch next from deploy_cursor into @inner_account;
								while @@fetch_status = 0
									begin

		
											declare inner_unit_cursor cursor for (
																					select [cpnyid]
																					from [integraapp].[dbo].[frl_entity]
																					where substring(@bunit,1,3) = substring(cpnyid,1,3)
																				  )
											open inner_unit_cursor;
												fetch next from inner_unit_cursor into @inner_unit
													while @@fetch_status = 0
														begin
														insert @deploy_accounts
															select @control_key,@inner_account , @inner_unit ,@bunit ,@_key, 1 ;
														
															-- -------------------------- --
															-- build presupuesto seciton  --
															-- -------------------------- --
															print 'INNERACCOUNT FOR PRESUPUESTO ONLY ACCT=> '+ substring(@inner_account,1,10) + ' sub => ' + substring(@inner_account,11,15)
																insert into @deploy_presupuesto
																	select 
																					Acct,Sub,CpnyID,[PtdBal00],[PtdBal01],[PtdBal02],[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],[PtdBal07],[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],FiscYr,@_key as _key, @bunit as _source_company
																	from 
																					integraapp.dbo.AcctHist 
																	where 
																					Acct = substring(@inner_account,1,10)
																				and 
																					FiscYr = year(CURRENT_TIMESTAMP)
																				and 
																					LedgerID = 'PRESUP' + FiscYr 
																				and 
																					CpnyID = @inner_unit
			 																	and 
																					substring(Sub,1,15) = substring(@inner_account,11,15);

															-- -------------------------- --
															-- build presupuesto seciton  --
															-- -------------------------- --
														fetch next from inner_unit_cursor into @inner_unit
														end
												close inner_unit_cursor;
												deallocate inner_unit_cursor;
											
										fetch next from deploy_cursor into @inner_account;
									end
						close deploy_cursor;
						deallocate deploy_cursor;
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
	       																											  select distinct idbase
																													  from [integraapp].[dbo].[xrefcia]
																													  where idsl in (
																																		--select item from integraapp.dbo.fnsplit(@bunit, @delimiter) 
																																		select bunit from @bussiness_unit
																																	)
																												 )
																and
																	substring(integraapp.dbo.subacct.sub,10,2) between @thirdsegment and @thirdsegment_sec
													)
						open deploy_cursor;
							fetch next from deploy_cursor into @inner_account;
								while @@fetch_status = 0
									begin

											declare inner_unit_cursor cursor for (
																					select [cpnyid]
																					from [integraapp].[dbo].[frl_entity]
																					where substring(@bunit,1,3) = substring(cpnyid,1,3)
																				  )
											open inner_unit_cursor;
												fetch next from inner_unit_cursor into @inner_unit
													while @@fetch_status = 0
														begin
														insert @deploy_accounts
															select @control_key,@inner_account , @inner_unit ,@bunit ,@_key, 1 ;
														
															-- -------------------------- --
															-- build presupuesto seciton  --
															-- -------------------------- --
															print 'INNERACCOUNT FOR PRESUPUESTO ONLY ACCT=> '+ substring(@inner_account,1,10) + ' sub => ' + substring(@inner_account,11,15)
																insert into @deploy_presupuesto
																	select 
																					Acct,Sub,CpnyID,[PtdBal00],[PtdBal01],[PtdBal02],[PtdBal03],[PtdBal04],[PtdBal05],[PtdBal06],[PtdBal07],[PtdBal08],[PtdBal09],[PtdBal10],[PtdBal11],[PtdBal12],FiscYr,@_key as _key, @bunit as _source_company
																	from 
																					integraapp.dbo.AcctHist 
																	where 
																					Acct = substring(@inner_account,1,10)
																				and 
																					FiscYr = year(CURRENT_TIMESTAMP)
																				and 
																					LedgerID = 'PRESUP' + FiscYr 
																				and 
																					CpnyID = @inner_unit
			 																	and 
																					substring(Sub,1,15) = substring(@inner_account,11,15);

															-- -------------------------- --
															-- build presupuesto seciton  --
															-- -------------------------- --
														fetch next from inner_unit_cursor into @inner_unit
														end
												close inner_unit_cursor;
												deallocate inner_unit_cursor;

										fetch next from deploy_cursor into @inner_account;
									end
						close deploy_cursor;
						deallocate deploy_cursor;
					end
				-------------------------------
								
				fetch next from accounts_deploy_cursor into @acct,@thirdsegment,@thirdsegment_sec,@_key;
				end
				
		close accounts_deploy_cursor;
	deallocate accounts_deploy_cursor;

												 
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




	
go



-- update bridge section
	select * from sistemas.dbo.mr_source_presupuestos_temps
--	truncate table sistemas.dbo.mr_source_presupuestos_temps
	select * from sistemas.dbo.mr_source_accounts_temps 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- SET the Periods 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Declare @setPeriod as varchar(6) , @recordsFound as int, @truncate_table as int;

set @truncate_table = 1;
set @setPeriod = '201604';


	set @recordsFound = (select  COUNT(period) from sistemas.dbo.mr_source_configs_temps where period = @setPeriod)

	if @truncate_table = 1
	begin
			truncate table sistemas.dbo.mr_source_configs_temps
	end
	else
		if @recordsFound > 0 
			begin
				delete from sistemas.dbo.mr_source_configs_temps where period = @setPeriod
			end
			-- NOW go to insert the new data
			insert into sistemas.dbo.mr_source_configs_temps 
																	select 
																			(select @setPeriod) as 'period',
																			SubAccount,company,source_company,
																			_key,_status 
																	from 
																			sistemas.dbo.mr_source_accounts_temps 
go

	select * from sistemas.dbo.mr_source_configs_temps 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- SET the Periods 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- update bridge section



--select * from sistemas.dbo.mr_source_configs_temps where company not in ('ATMMAC','TEICUA')
--insert sistemas.dbo.mr_source_configs_temps
--		select (select '201602') as 'period' , subAccount , company ,source_company,_key,_status from sistemas.dbo.mr_source_accounts_temps

--select (select '201503') as 'period',SubAccount,company,source_company,_key,_status from sistemas.dbo.mr_source_accounts_temps where SubAccount = '05010101000000000AAAF    ' and source_company = 'TBKORI' and _key = 'OF'
----
--select * from sistemas.dbo.mr_source_configs_temps where source_company = 'TBKORI' and period = '201602' and _key = 'OF'


--select  * from sistemas.dbo.mr_source_accounts_temps
--select  * from  sistemas.dbo.mr_source_configs_temps 


															--where 
															--		SubAccount = '05010101000000000AIAF    ' and 
															--		source_company = 'TBKGDL' and _key = 'OF'
--truncate table sistemas.dbo.mr_source_configs_temps 												 





-- select distinct * from sistemas.dbo.mr_source_accounts where source_company = 'TBKORI' and _key = 'OF'
-- select * from sistemas.dbo.mr_source_accounts where mr_source_controls_id = '1'


	--select Acct from integraapp.dbo.Account 
	--where 
	--		integraapp.dbo.Account.AcctType = '5E' 
	--	and 
	--		Active = 1 
	--	and 
	--		Acct between '0500000000' and '0507030000'




	--select IDSL,IDBase
	--  FROM [integraapp].[dbo].[xrefcia]
	--  where IDSL in (
	--					SELECT [cpnyid]
	--					FROM [integraapp].[dbo].[frl_entity]
	--				)
	--go

	-- 1		201603	05010404000000000AI000000	TBKCUL	TBKGDL	OF	1
	-- 92373	201603	05010404000000000AI000000	TBKCUL	TBKGDL	OF	1

-- 114184
-- select * from sistemas.dbo.mr_source_configs_temps
-- select * from sistemas.dbo.mr_source_presupuestos_temps

-----------------------------------------------------------------------------------------------------------
--	           	                     build the request data                                              --
-----------------------------------------------------------------------------------------------------------
Declare @period varchar(8000) , @Delimiter varchar(1) , @bunit varchar(4000) ,@_key varchar(4000);

select @period = '201604';
select @Delimiter = '|';
select @bunit = 'TBKGDL|TBKHER|TBKLAP|TBKORI|TBKRAM|TBKTIJ';
select @_key = 'OF'

	declare @config_bunit table 
	(
		config_bunit	varchar(6) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into @config_bunit select item from integraapp.dbo.fnSplit(@bunit, @Delimiter)
	select * from  @config_bunit

	declare @config_period table 
	(
		config_period	varchar(6) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into @config_period select item from integraapp.dbo.fnSplit(@period, @Delimiter)
	--select * from  @config_period
	declare @config_key table 
	(
		config_key	varchar(2) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into @config_key select item from integraapp.dbo.fnSplit(@_key, @Delimiter)
	--select * from  @config_key
  --call to table and save as table var 
  
	-- in the beggining this was formely the function dbo.getRealPresupuesto but now this is part of itself
	----------------------------------------------------------------------------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------------------------------------------------------------------------
select 
			(select 
				case substring(isnull(integraapp.dbo.GLTran.PerPost,source_table.period),5,2)
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
			 ) as 'Mes'
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
			--,integraapp.dbo.GLTran.CuryCrAmt * integraapp.dbo.GLTran.CuryRate as Abono
			,ISNULL(integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate,0.0) AS Cargo
			--,integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate AS Cargo
			,ISNULL(SUBSTRING(integraapp.dbo.GLTran.Sub, 8, 2),substring(source_table.SubAccount, 18, 2)) AS UnidadNegocio
			,ISNULL(SUBSTRING(integraapp.dbo.GLTran.Sub, 10, 6),substring(source_table.SubAccount, 20, 6)) AS CentroCosto 
			,integraapp.dbo.SubAcct.Descr AS NombreEntidad
			,(select '0') as 'Presupuesto'
			,source_table.company as _company
			,source_table.period as _period
			,source_table._key as _key
			,source_table.source_company as _source_company

	from sistemas.dbo.mr_source_configs_temps as source_table
	--from @source_table as source_table
	--from @deploy_accounts as source_table
	
		inner join integraapp.dbo.Account
			on substring(source_table.SubAccount,1,10) = integraapp.dbo.Account.Acct
				and '5E' = integraapp.dbo.Account.AcctType

		inner join integraapp.dbo.SubAcct
			--on substring(source_table.SubAccount,11,21) = integraapp.dbo.SubAcct.Sub 
			on substring(source_table.SubAccount,11,15) = SUBSTRING(integraapp.dbo.SubAcct.Sub,1,15)
			---------------------------------------------------------------------------------------------
			-- on substring(source_table.SubAccount,11,7) = SUBSTRING(integraapp.dbo.SubAcct.Sub,1,7)
				--and
				--	substring(source_table.SubAccount,18,2) = SUBSTRING(integraapp.dbo.SubAcct.Sub,8,2)
				--and 
				--	substring(source_table.SubAccount,20,5) = SUBSTRING(integraapp.dbo.SubAcct.Sub,10,5) -- maybe can change to 6 and improve performance
				---------------------------------------------------------------------
					--substring(source_table.SubAccount,20,2) = SUBSTRING(integraapp.dbo.SubAcct.Sub,10,2) -- original string
			---------------------------------------------------------------------------------------------
		inner join integraapp.dbo.GLTran
			on substring(source_table.SubAccount,1,10) = integraapp.dbo.GLTran.Acct
				and source_table.company = integraapp.dbo.GLTran.CpnyID
				and source_table.period = integraapp.dbo.GLTran.PerPost
				/** MOD */
				and 
					substring(integraapp.dbo.SubAcct.Sub,1,21) = SUBSTRING(integraapp.dbo.GLTran.Sub,1,21)
				--and substring(source_table.SubAccount,11,15) = SUBSTRING(integraapp.dbo.GLTran.Sub,1,15)
				--0501040400 0000000AIRD1148
				-- and substring(source_table.SubAccount,17,4) = SUBSTRING(integraapp.dbo.GLTran.Sub,7,4)
				-- and substring(source_table.SubAccount,22,4) between 1000 and 9999
				/** MOD */
				and
					 'P' = integraapp.dbo.GLTran.Posted
				and 
					integraapp.dbo.GLTran.LedgerID = 'REAL'
				-- and not
				--	( integraapp.dbo.GLTran.CuryCrAmt * integraapp.dbo.GLTran.CuryRate is null AND integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate is null )
				and 
					( integraapp.dbo.GLTran.Sub is not null and integraapp.dbo.GLTran.Acct is not null )
				--and 
					--integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate is not null
	
	where 
		-- source_table.period in (select item from integraapp.dbo.fnSplit(@period, @Delimiter) )
			source_table.period in (select config_period from @config_period)
		-- and source_table.source_company in (select item from integraapp.dbo.fnSplit(@bunit, @Delimiter) )
		and 
			source_table.source_company in (select config_bunit from @config_bunit )
		-- and source_table._key in (select item from integraapp.dbo.fnSplit(@_key, @Delimiter) )
		and 
			source_table._key in (select config_key from @config_key )
		and
			(
					(integraapp.dbo.GLTran.CuryCrAmt * integraapp.dbo.GLTran.CuryRate ) <> 0
				OR
					(integraapp.dbo.GLTran.CuryDrAmt * integraapp.dbo.GLTran.CuryRate) <> 0
			)
	----------------------------------------------------------------------------------------------------------------------------------------------------------
	union all   -- ----------- Add Presupuesto ----------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------

	select 
			(select 
				case substring(@period,5,2)
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
			 ) as 'Mes',
		presupuesto.Acct as 'NoCta'
		,cuenta.Descr AS NombreCta
		,'' as 'PerEnt'
		,CpnyID as Compañia
		,'' as 'Tipo'
		,presupuesto.Sub as 'Entidad'
		,'' as 'distinto'
		,'' as 'TipoTransacción'
		,'' as 'Referencia'
		,'' as FechaTransacción
		,'' as Descripción
		,'0' as Abono
		,'0' as Cargo
		,substring(presupuesto.Sub,8,2) as UnidadNegocio
		,substring(presupuesto.Sub,10,6) as CentroCosto
		,subcuenta.Descr as NombreEntidad
		,CASE @period
			WHEN substring(@period,1,4) + '01' 
				THEN presupuesto.PtdBal00 
			WHEN substring(@period,1,4) + '02' 
				THEN presupuesto.PtdBal01 
			WHEN substring(@period,1,4) + '03' 
				THEN presupuesto.PtdBal02
			WHEN substring(@period,1,4) + '04' 
				THEN presupuesto.PtdBal03
			WHEN substring(@period,1,4) + '05' 
				THEN presupuesto.PtdBal04
			WHEN substring(@period,1,4) + '06' 
				THEN presupuesto.PtdBal05
			WHEN substring(@period,1,4) + '07' 
				THEN presupuesto.PtdBal06 
			WHEN substring(@period,1,4) + '08' 
				THEN presupuesto.PtdBal07
			WHEN substring(@period,1,4) + '09' 
				THEN presupuesto.PtdBal08
			WHEN substring(@period,1,4) + '10' 
				THEN presupuesto.PtdBal09
			WHEN substring(@period,1,4) + '11' 
				THEN presupuesto.PtdBal10
			WHEN substring(@period,1,4) + '12' 
				THEN presupuesto.PtdBal11
			ELSE '0' 
		END AS 'Presupuesto'
		,presupuesto.CpnyID as _company
		,@period as _period
		,presupuesto._key as _key
		,presupuesto._source_company as _source_company

	from sistemas.dbo.mr_source_presupuestos_temps as presupuesto
			inner join integraapp.dbo.Account as cuenta
				on substring(presupuesto.Acct,1,10) = cuenta.Acct
					and '5E' = cuenta.AcctType
			inner join integraapp.dbo.SubAcct as subcuenta
				on substring(presupuesto.Sub,1,21) = SUBSTRING(subcuenta.Sub,1,21)
	where presupuesto._source_company in (select config_bunit from @config_bunit )	--@empresa 'ATMMAC'
		and presupuesto.FiscYr = substring(@period,1,4)				-- @year '2015'
		and presupuesto._key = @_key


