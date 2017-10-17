use integraapp
-- procedire name : xINVERTIR_POLIZA
-- is IN or a CM ? 
	declare @batnbr as char(10)
	declare @module as char(2) 
	declare @period as char(6)

	
	
--	temporal sets
	declare @lastnb as char(10) , @lastmod as char(2)
-- set @batch comes from orignal police  IN type acct 0101040400
	set @batnbr = '064293' 
	set @module = 'AR' 
	set @period = '201707'
	-- this test counter
	set @lastnb = '086105'
	set @lastmod = 'GL' 
	

--	second exmaple CM type and acct
--	set @batnbr = '064423' 
--	set @module = 'AR' 
--	set @period = '201707'
--	-- and his counter
--	set @lastnb = '086729'
--	set @lastmod = 'GL' 	
	

--	064392 - 085613
	
	set @batnbr = '062601' 
	set @module = 'AR' 
	set @period = '201707'
	-- and his counter
	set @lastnb = '082987'
	set @lastmod = 'GL' 	



	--	inner declares
-- ===================== Come from Original xINVERTIR_POLIZA =========================================================================== --

	DECLARE @LASTGLBATNBR Char(10), @GL_BATNBR Char(10)
	set @GL_BATNBR = @batnbr
	-- Obtener Ultimo Número de Póliza GL y actualizar Control de Contabilidad
	SELECT @LASTGLBATNBR=ISNULL(LastBatNbr,'000000') FROM GLSetup
	SET @GL_BATNBR = RIGHT(RTRIM('00000000000000000000' + CONVERT (Char,(CONVERT(Int, @LASTGLBATNBR) + 1))), LEN(@LASTGLBATNBR))
--	UPDATE GLSetup SET LastBatNbr=@GL_BATNBR
--	select @GL_BATNBR,@batnbr,@LASTGLBATNBR
-- ===================== Come from Original xINVERTIR_POLIZA =========================================================================== --	
	
-- ===================== INNER tables--declares  =========================================================================== --		
	declare @polizas as table (
		 Acct			char(10)
		,tmpcnfact		char(10)
		,BatNbr			char(10)
		,CrAmt			decimal(16,2)
		,DrAmt			decimal(16,2)
		,CuryCrAmt		decimal(16,2)
		,CuryDrAmt		decimal(16,2)
		,TranDesc		char(30)
		,CpnyID			char(10)
		,isLis			smallint
		,fact			varchar(25)
		,doctype		varchar(25)
		,user_			varchar(25)
		,trunstomp		VARBINARY(60)
	)

	declare @flete as table (
		 Acct			char(10)
		,tmpcnfact		char(10)
		,BatNbr			char(10)
		,CrAmt			decimal(16,2)
		,DrAmt			decimal(16,2)
		,CuryCrAmt		decimal(16,2)
		,CuryDrAmt		decimal(16,2)
		,TranDesc		char(30)
		,CpnyID			char(10)
		,isLis			smallint
		,fact			varchar(25)
		,doctype		varchar(25)
		,user_			varchar(25)
		,trunstomp		VARBINARY(60)
	)
--	use integraapp
--	exec sp_desc GLTran	

-- ===================== INNER tables--declares  =========================================================================== --		

-- ===================== INNER variables--declares  =========================================================================== --		
	declare @subtotal as decimal(16,2)
	declare @tax	   as decimal(16,2)
	declare @ret	   as decimal(16,2)
	
	declare @isLis	   as smallint
	declare @fact	   as varchar(25)
	declare @doctype  as varchar(25)
	declare @user_    as varchar(25)
	declare @checker  as SMALLINT
	
-- ===================== INNER variables--declares  =========================================================================== --		
/*				
	select 
			"fletes".ConcepLIS,"fletes".Embalaje,"fletes".ConcenSL,"fletes".Descrip,"fletes".CNFACT,"fletes".Cfact 
	from 
			integraapp.dbo.xctascon as "fletes" where "fletes".Embalaje = 0 order by "fletes".Embalaje
	
	select 
			"fletes".ConcepLIS,"fletes".Embalaje,"fletes".ConcenSL,"fletes".Descrip,"fletes".CNFACT,"fletes".Cfact 
	from 
			integraapp.dbo.xctascon as "fletes" where "fletes".Embalaje > 0 order by "fletes".Embalaje
*/
		
-- ===================== get case from is ?  =========================================================================== --		
	select 
			 @fact = "ardoc".User6 -- 'Fact__User6'
			,@isLis = ( case "ardoc".User2 when 'LIS' then 1 else 0 end)
			,@doctype = "ardoc".DocType
			,@user_ = "ardoc".Crtd_User
	from 
			integraapp.dbo.ARDoc as "ardoc" 
 	where 
 			"ardoc".BatNbr = @batnbr
 			
-- ===================== INNER SET variables_tables--declares  =========================================================================== --
--		IN type have cr not null and dr to zero 
--		CM type have cr to zero and dr not null
	insert into @polizas	
	select 
			 "gltran".Acct,"rev".cnfact
			,"gltran".BatNbr
			,"gltran".DrAmt as 'CrAmt' 
			,"gltran".CrAmt as 'DrAmt'
			,"gltran".CuryDrAmt as 'CuryCrAmt'
			,"gltran".CuryCrAmt as 'CuryDrAmt'
			,"gltran".TranDesc
			,"gltran".CpnyID
			,@isLis,@fact,@doctype,@user_,"gltran".tstamp
	from 
			integraapp.dbo.GLTran as "gltran"
		inner join 
					(
						select 
								"fletes".Cfact , "fletes".CNFACT as 'cnfact'
						from 
								integraapp.dbo.xctascon as "fletes" where "fletes".Embalaje > 0
							or
								"fletes".ConcenSL in ('900','901')
					)
			as "rev" on "gltran".Acct = "rev".Cfact
	where 
			BatNbr = @batnbr
			
			
	insert into @flete
	select 
			 "flet".Acct,"flet".tmpcnfact
			,"flet".BatNbr
			,"flet".DrAmt as 'CrAmt' 
			,"flet".CrAmt as 'DrAmt'
			,"flet".CuryDrAmt as 'CuryCrAmt'
			,"flet".CuryCrAmt as 'CuryDrAmt'
			,"flet".TranDesc
			,"flet".CpnyID
			,@isLis,@fact,@doctype,@user_,"flet".trunstomp
	from 
			@polizas as "flet"
		inner join 
					(
						select 
								"fletes".Cfact
						from 
								integraapp.dbo.xctascon as "fletes" where "fletes".Embalaje > 0
					)
			as "revo" on "flet".Acct = "revo".Cfact
	where 
			BatNbr = @batnbr
			
	---
			
 	set @subtotal = ( 
 						select 
 							case 
 								when @doctype = 'IN' 
 									then sum("poliza".CuryDrAmt) 
 								when @doctype = 'CM' 
 									then sum("poliza".CuryCrAmt) 
 								end as 'total' 
 						from
 							@polizas as "poliza"
						inner join 
									(
										select 
												"flees".Cfact
										from 
												integraapp.dbo.xctascon as "flees" where "flees".Embalaje > 0
									) as "ftl"
						on "poliza".Acct = "ftl".Cfact
 					)
 					
 	set @tax = (@subtotal * 0.16)
 	set @ret = (@subtotal * 0.04)
 	
 	-- ======== check if need recalculate or not  ======================= --
 	
 	set @checker = (
						select 
									count("gltran".Acct)
							from 
									integraapp.dbo.GLTran as "gltran"
							where 
									BatNbr = '064423' --@batnbr
								and
									Module = 'CM'
								and  
									"gltran".Acct not in 
											(
												select 
														"fletes".Cfact
												from 
														integraapp.dbo.xctascon as "fletes" 
												where 
														"fletes".Embalaje > 0 
													or
														"fletes".ConcenSL in ('900','901')
											)
 	)

-- ===================== INNER SET variables_tables--declares  =========================================================================== --

 	select * from @polizas		
 	select * from @flete
 		
 	select  @subtotal as 'subtotal'	, @tax as 'iva' ,  @ret as 'ret' , (@subtotal + @tax - @ret) as 'lastTotal'
 			,@fact as 'factura',@isLis as 'isLis' ,@doctype as 'doctype',@batnbr as 'oldNBR' , @GL_BATNBR as 'newNBR'
 			,@checker as 'checker'
		
-- ===================== get Total from GLTRAN  =========================================================================== --		
	
 	--- ORIGINAL ---	
 	
	select Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryDrAmt,TranDesc,* from integraapp.dbo.GLTran where BatNbr = @batnbr and Module = @module
		union all 
	select Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryDrAmt,TranDesc,* from integraapp.dbo.GLTran where BatNbr = @lastnb and Module = @lastmod			
			
	---	ORIGINAL ---
	
	-- =================================================================================================================== --
	-- =============================  Data needed is header , iva and retencion  ========================================= --
	-- =================================================================================================================== --	
	-- this is the transaction
	--- NEW --- Work from hir   IN tran=total=iva=ret | CM
	
	select 
			 "fut".tmpcnfact as 'FuttampFact'
			,"pol".tmpcnfact as 'PoltampFact'
			,"tran".Acct as 'theTran'
			,coalesce (
			 				"pol".tmpcnfact
			 				,(	
			 					select 
										"fletes".CNFACT
								from 
										integraapp.dbo.xctascon as "fletes" 
								where 
										"fletes".Embalaje = 0 
									and
										"fletes".Cfact = "tran".Acct
							) 
							,"tran".Acct
						) as 'Acct'
--			,"tran".Acct -- set the inversions with @polizas 
			,"tran".AppliedDate ,"tran".BalanceType ,"tran".BaseCuryID 
			,@GL_BATNBR as 'BatNbr' -- newatnbr
			,"tran".CpnyID 
			,case 
				when ("pol".tmpcnfact is not null and @checker = 0) -- set fletes and iva , ret
					then 
						"pol".CrAmt 
				when ("pol".tmpcnfact is null and "tran".Acct = '0101040400' or "tran".Acct = '0101040100') --and @checker > 0 -- this goint to be total , tax or ret and others-concepts -- can check if is IN or CM
					then 
						case 
							when ("tran".CrAmt is not null and @checker = 0) -- because iva and ret are in cramt and need to change with IN this fields are not null
								then 
									coalesce( "tran".DrAmt , 0.00 )
							when ("tran".CrAmt is not null and @checker > 0) --> appears that always when this is IN then this field is the total
								then 
									(@subtotal + @tax - @ret)
							end
-- check if has other concepts
				when ("fut".tmpcnfact is not null and @checker > 0 ) --set fletes
					then 
						"fut".CrAmt
				when ("fut".tmpcnfact is null and @checker > 0 ) --set fletes
					then
						case 
							when 
								("tran".Acct = (
						 					select 
													"fletes".cfact
											from 
													integraapp.dbo.xctascon as "fletes" 
											where 
													"fletes".Embalaje = 0 
												and
													"fletes".Cfact = "tran".Acct
												and 
													"fletes".ConcenSL = '900'
										 )
								and 
									"tran".CrAmt is null or "tran".CrAmt = 0  -- check ?
						 	   )
								then @tax
							when 
								("tran".Acct = (
						 					select 
													"fletes".cfact
											from 
													integraapp.dbo.xctascon as "fletes" 
											where 
													"fletes".Embalaje = 0 
												and
													"fletes".Cfact = "tran".Acct
												and 
													"fletes".ConcenSL = '901'
										 )
								and 
									"tran".CrAmt is null or "tran".CrAmt = 0
						 	   )
								then ( @ret*(-1) )
						end
				end as 'CrAmt' --> pass the CuryDrAmt = Total = iva = ret |
--			,current_timestamp as 'Crtd_DateTime' -- set the newtime getdate or timestamp
--			,case when @doctype = 'IN' then 'AR010' else "tran".Crtd_Prog end as 'Crtd_Prog' -- set 'AR010' ??
--			,case when @doctype = 'IN' then @user_ else "tran".Crtd_User end as 'Crtd_User' -- set the user from ARDoc.Crtd_User
-----			,"pol".CuryCrAmt -- invert or set with the inversion zero (CuryDrAmt)  = Total = iva = ret |
			,case 
				when ("pol".tmpcnfact is not null and @checker = 0) -- set fletes and iva , ret
					then 
						"pol".CuryCrAmt 
				when ("pol".tmpcnfact is null and "tran".Acct = '0101040400' or "tran".Acct = '0101040100') --and @checker > 0 -- this goint to be total , tax or ret and others-concepts -- can check if is IN or CM
					then 
						case 
							when ("tran".CuryCrAmt is not null and @checker = 0) -- because iva and ret are in cramt and need to change with IN this fields are not null
								then 
									coalesce( "tran".CuryDrAmt , 0.00 )
							when ("tran".CuryCrAmt is not null and @checker > 0) --> appears that always when this is IN then this field is the total
								then 
									(@subtotal + @tax - @ret)
							end
-- check if has other concepts
				when ("fut".tmpcnfact is not null and @checker > 0 ) --set fletes
					then 
						"fut".CuryCrAmt
				when ("fut".tmpcnfact is null and @checker > 0 ) --set fletes
					then
						case 
							when 
								("tran".Acct = (
						 					select 
													"fletes".cfact
											from 
													integraapp.dbo.xctascon as "fletes" 
											where 
													"fletes".Embalaje = 0 
												and
													"fletes".Cfact = "tran".Acct
												and 
													"fletes".ConcenSL = '900'
										 )
								and 
									"tran".CuryCrAmt is null or "tran".CuryCrAmt = 0
						 	   )
								then @tax
							when 
								("tran".Acct = (
						 					select 
													"fletes".cfact
											from 
													integraapp.dbo.xctascon as "fletes" 
											where 
													"fletes".Embalaje = 0 
												and
													"fletes".Cfact = "tran".Acct
												and 
													"fletes".ConcenSL = '901'
										 )
								and 
									"tran".CuryCrAmt is null or "tran".CuryCrAmt = 0
						 	   )
								then ( @ret*(-1) )
						end
				end as 'CuryCrAmt' --> pass the CuryDrAmt = Total = iva = ret |
--			,"pol".CuryDrAmt -- invert or set the inversion value (CuryCrAmt) = zero = zero = zero |
			,case 
				when ( "pol".tmpcnfact  is not null and @checker = 0 )
					then -- set fletes 
						"pol".CuryDrAmt
				when ( "pol".tmpcnfact is null and "tran".Acct = '0101040400' or "tran".Acct = '0101040100') -- gets total
					then -- set total
						case 
							when ("tran".CuryDrAmt = 0 or "tran".CuryDrAmt is null) and @checker = 0 -- this goint to be tax or ret
								then 
									coalesce( "tran".CuryCrAmt , 0.00 )
							when ("tran".CuryDrAmt = 0 or "tran".CuryDrAmt is null) and @checker > 0 -- this goint to be tax or ret								
								then
									(@subtotal + @tax - @ret)
						end
-- check if has other concepts
				when ("fut".tmpcnfact is not null and @checker > 0 ) --set fletes
					then 
						"fut".CuryDrAmt
				when ("fut".tmpcnfact is null and @checker > 0 ) --set fletes
					then
						case 
							when 
								("tran".Acct = (
						 					select 
													"fletes".cfact
											from 
													integraapp.dbo.xctascon as "fletes" 
											where 
													"fletes".Embalaje = 0 
												and
													"fletes".Cfact = "tran".Acct
												and 
													"fletes".ConcenSL = '900'
										 )
								and 
									"tran".CuryDrAmt is null or "tran".CuryDrAmt = 0
						 	   )
								then @tax
							when 
								("tran".Acct = (
						 					select 
													"fletes".cfact
											from 
													integraapp.dbo.xctascon as "fletes" 
											where 
													"fletes".Embalaje = 0 
												and
													"fletes".Cfact = "tran".Acct
												and 
													"fletes".ConcenSL = '901'
										 )
								and 
									"tran".CuryDrAmt is null or "tran".CuryDrAmt = 0
						 	   )
								then ( @ret*(-1) )
						end
			 end as 'CuryDrAmt'
--			,"tran".CuryEffDate ,"tran".CuryId ,"tran".CuryMultDiv ,"tran".CuryRate ,"tran".CuryRateType 
			,case 
				when ( "pol".tmpcnfact  is not null and @checker = 0 )
					then -- set fletes 
						"pol".DrAmt
				when ( "pol".tmpcnfact is null and "tran".Acct = '0101040400' or "tran".Acct = '0101040100') -- gets total
					then -- set total
						case 
							when ("tran".DrAmt = 0 or "tran".DrAmt is null) and @checker = 0 -- this goint to be tax or ret
								then 
									coalesce( "tran".CrAmt , 0.00 )
							when ("tran".DrAmt = 0 or "tran".DrAmt is null) and @checker > 0 -- this goint to be tax or ret								
								then
									(@subtotal + @tax - @ret)
						end
-- check if has other concepts
				when ("fut".tmpcnfact is not null and @checker > 0 ) --set fletes
					then 
						"fut".DrAmt
				when ("fut".tmpcnfact is null and @checker > 0 ) --set fletes
					then
						case 
							when 
								("tran".Acct = (
						 					select 
													"fletes".cfact
											from 
													integraapp.dbo.xctascon as "fletes" 
											where 
													"fletes".Embalaje = 0 
												and
													"fletes".Cfact = "tran".Acct
												and 
													"fletes".ConcenSL = '900'
										 )
								and 
									"tran".DrAmt is null or "tran".DrAmt = 0
						 	   )
								then @tax
							when 
								("tran".Acct = (
						 					select 
													"fletes".cfact
											from 
													integraapp.dbo.xctascon as "fletes" 
											where 
													"fletes".Embalaje = 0 
												and
													"fletes".Cfact = "tran".Acct
												and 
													"fletes".ConcenSL = '901'
										 )
								and 
									"tran".DrAmt is null or "tran".DrAmt = 0
						 	   )
								then ( @ret*(-1) )
						end
			 end as 'DrAmt'
--			----"pol".DrAmt 	   -- invert or set the inversion value (CrAmt) = zero = zero = zero |
			,"tran".EmployeeID ,"tran".ExtRefNbr ,"tran".FiscYr ,"tran".IC_Distribution ,"tran".Id 
			,"tran".JrnlType -- set as 'AR' = JrnlType = JrnlType = JrnlType |
			,"tran".Labor_Class_Cd 
			,"tran".LedgerID -- set as 'REAL' = LedgerID = LedgerID = LedgerID |
			,"tran".LineId ,"tran".LineNbr ,"tran".LineRef 
			,case when @doctype = 'IN' then current_timestamp end as 'LUpd_DateTime' -- set the newtime getdate or timestamp
			,case when @doctype = 'IN' then 'AR010' end as 'LUpd_Prog' -- set as 'AR010'
			,case when @doctype = 'IN' then @user_ end as 'LUpd_User' -- set the user from ARDoc.Crtd_User
			,case when @doctype = 'IN' then 'GL' end as 'Module' 	-- set to 'GL'
			,"tran".NoteID ,"tran".OrigAcct ,"tran".OrigBatNbr ,"tran".OrigCpnyID
			,"tran".OrigSub ,"tran".PC_Flag ,"tran".PC_ID ,"tran".PC_Status ,"tran".PerEnt 
			,"tran".PerPost -- set the perpost
			,case when @doctype = 'IN' then 'U' end as 'Posted' -- set to 'U' means "poliza no asentada"
			,"tran".ProjectID ,"tran".Qty ,"tran".RefNbr ,"tran".RevEntryOption 
			,case when @doctype = 'IN' then '1' end as 'Rlsed'  -- set to 1 means (liberado)
			,"tran".S4Future01 ,"tran".S4Future02 ,"tran".S4Future03 ,"tran".S4Future04 ,"tran".S4Future05 ,"tran".S4Future06 -- all sfuture sets to 0 zero
			,"tran".S4Future07 ,"tran".S4Future08 ,"tran".S4Future09 ,"tran".S4Future10 ,"tran".S4Future11 ,"tran".S4Future12 -- all sfuture sets to 0 zero
			,"tran".ServiceDate ,"tran".Sub ,"tran".TaskID ,"tran".TranDate 
			,case when @doctype = 'IN' then 'Reversión de Ingresos ' + RTRIM(LTRIM(@BATNBR)) else "tran".TranDesc end as 'TranDesc' -- set the description ===> 'Reversión de Ingresos ' + RTRIM(LTRIM(@BATNBR))
			,"tran".TranType ,"tran".Units 
			,"tran".User1 ,"tran".User2 ,"tran".User3 ,"tran".User4 ,"tran".User5 ,"tran".User6 ,"tran".User7 ,"tran".User8 -- all users set to 0 zero
			,tstamp as 'trumpStomp' -- need omit this  or maybe not nobody knows?
	from 
			integraapp.dbo.GLTran as "tran"
		left join 
			@polizas as "pol" on "tran".Acct = "pol".Acct and "tran".tstamp = "pol".trunstomp
		left join 
			@flete as "fut" on "tran".Acct = "fut".Acct and "tran".tstamp = "fut".trunstomp
	where 
			"tran".BatNbr = @batnbr
		and 
			"tran".Module = @module	
	
	--- NEW ---		
--	select 
--			"fletes".cfact
--	from 
--			integraapp.dbo.xctascon as "fletes" 
--	where 
--			"fletes".Embalaje = 0 
--		and
--			"fletes".Cfact = "tran".Acct
--		and 
--			"fletes".ConcenSL = '900'	

--select * from integraapp.dbo.zFacNot where Fact = 'FOG-008182' and concepto = '901'
		
-- changes in batch 
-- BatNbr => old to new
-- Descr => set the new desc
-- DrTot => new concept
-- EditScrnNbr => 08010  => 01010 
-- JrnlType => AR => RE
-- Module => AR => GL

-- CrTot,CtrlTot,CuryCrTot,CuryCtrlTot,CuryDepositAmt,CuryDrTot => set values
/*
		
--		query for batch
select 
			 Acct ,AutoRev ,AutoRevCopy ,BalanceType ,BankAcct ,BankSub ,BaseCuryID 
			,@GL_BATNBR as 'BatNbr' -- change
			,BatType ,clearamt ,Cleared ,CpnyID ,Crtd_DateTime ,Crtd_Prog ,Crtd_User 
			,CrTot ,CtrlTot ,CuryCrTot ,CuryCtrlTot -- change
			,CuryDepositAmt 
			,CuryDrTot -- change
			,CuryEffDate ,CuryId ,CuryMultDiv ,CuryRate ,CuryRateType ,Cycle ,DateClr ,DateEnt ,DepositAmt 
			,Descr ,DrTot ,EditScrnNbr -- change
			,GLPostOpt 
			,JrnlType ,LedgerID ,LUpd_DateTime ,LUpd_Prog ,LUpd_User ,Module -- change
			,NbrCycle ,NoteID ,OrigBatNbr ,OrigCpnyID ,OrigScrnNbr ,PerEnt 
			,PerPost ,Rlsed  --change
			,S4Future01 ,S4Future02 ,S4Future03 ,S4Future04 ,S4Future05 ,S4Future06 ,S4Future07 ,S4Future08 ,S4Future09 ,S4Future10 ,S4Future11 ,S4Future12 
			,Status  --change
			,Sub ,User1 ,User2 ,User3 ,User4 ,User5 ,User6 ,User7 ,User8
from 
			integraapp.dbo.Batch 
where 
			BatNbr = '064293' 
	and 
			CpnyID = 'TBKGDL'		
		


select CrTot,CtrlTot,CuryCrTot,CuryCtrlTot,CuryDepositAmt,CuryDrTot,DrTot,EditScrnNbr,JrnlType,LedgerID,Module,Descr,* from integraapp.dbo.Batch where BatNbr = '064293' and CpnyID = 'TBKGDL'



		
		
		
		
		
-- IN type		
		
select CrTot,CtrlTot,CuryCrTot,CuryCtrlTot,CuryDepositAmt,CuryDrTot,DrTot,EditScrnNbr,JrnlType,LedgerID,Module,Descr,* from integraapp.dbo.Batch where BatNbr = '064293' and CpnyID = 'TBKGDL'
union all
select CrTot,CtrlTot,CuryCrTot,CuryCtrlTot,CuryDepositAmt,CuryDrTot,DrTot,EditScrnNbr,JrnlType,LedgerID,Module,Descr,* from integraapp.dbo.Batch where BatNbr = '086105' and CpnyID = 'TBKGDL'







select 
		User6 as 'Factura_User6', Crtd_User as 'User_Crtd_User', User2 as 'ConCP_User2', DocType as 'Tipo_DocType',CpnyID as 'CiaCpnyID' 
from
		integraapp.dbo.ARDoc Where BatNbr = '064293'


select Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryDrAmt,TranDesc,* from integraapp.dbo.GLTran where BatNbr = '064293' and Module = 'AR'
union all
select Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryDrAmt,TranDesc,* from integraapp.dbo.GLTran where BatNbr = '086105' and Module = 'GL'


--select Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryCrAmt,* from integraapp.dbo.GLTran where BatNbr = '064237' and Module = 'AR'
--uniona all
--select Acct,BatNbr,CrAmt,DrAmt,CuryCrAmt,CuryCrAmt,* from integraapp.dbo.GLTran where BatNbr = '086105' and Module = 'GL'
*/