-- AR emitidas
-- Ap recividas  done

use integraapp;

--/**19470*/

select
	a.perpost,
	a.BatNbr as Lote,
	b.CustId as RFC,
	a.CpnyID as Company,
	b.RefNbr as Documento,
	b.BankAcct as Cuenta,
	b.CuryOrigDocAmt as Monto,
	Modulo = 'AR',
	LineRef = 0,
	case
		a.CuryId
		when 'MN' then 'MXN'
		when 'USD' then 'USD'
		when 'EUR' then 'EUR'
	end as Moneda,
	CuryRate = 1,
	Tipo = 'I',
	b.User6 as Factura,
	b.DocType as TipoDocto
from
	Batch a 
		inner join ARDoc b on b.BatNbr = a.BatNbr
where
	a.PerPost > '201506'
	and a.Status = 'P'
	and b.DocType = 'IN'
	and a.JrnlType = 'AR'
	and b.user5 = 'S'
order by
	b.DocType;

-- ====================== AR =========================== --
--in query 21521
-- WTF supose to do  hahahaha !!!!!!!!!!!!!!!??????????????????????????????
select
	bat.perpost,
	bat.batnbr as 'bat_lote',
	bat.CpnyID as 'bat_Company',
	case
		bat.CuryId
		when 'MN' then 'MXN'
	end as 'bat_Moneda',
	ar.CustId as 'ar_rfc',
	ar.RefNbr as 'ar_documento',
	ar.BankAcct as 'ar_cuenta',
	ar.CuryOrigDocAmt as 'ar_monto',
	ar.User6 as 'ar_factura',
	ar.DocType as 'tipodocto',
	ar.CuryRate,
	ar.CuryRateType
from
	integraapp.dbo.Batch as bat
	left join
		integraapp.dbo.ARDoc as ar on bat.BatNbr = ar.BatNbr
where
		bat.PerPost > 201506
	and 
		bat.Status = 'P' and bat.JrnlType = 'AR'
	and
		ar.DocType = 'IN' and ar.User5 = 'S'
;

-- ====================== AP =========================== --
--in query 21521
select 
         bat.perpost,bat.batnbr as 'bat_lote',bat.CpnyID as 'bat_Company', case bat.CuryId when 'MN' then 'MXN' end as 'bat_Moneda'
		----,ap.CuryDocBal as 'ar_rfc'
		--,ap.RefNbr as 'ar_documento' 
		----,ap.BankAcct as 'ar_cuenta' 
		--,ap.CuryOrigDocAmt as 'ar_monto'
		--,ap.User6 as 'ar_factura' , ap.DocType as 'tipodocto'
		--,ap.CuryRate,ap.CuryRateType
		-- info
		,bat.JrnlType
		,ap.DocType,ap.User1,ap.User2,ap.User3,ap.User4,ap.User5,ap.User6,ap.User7,ap.User8
		,tra.*
from 
        integraapp.dbo.Batch as bat
	left join
		integraapp.dbo.APDoc as ap on bat.BatNbr = ap.BatNbr
	left join 
		integraapp.dbo.APTran as tra on bat.BatNbr = tra.BatNbr
where
		bat.PerPost > 201506
	and 
		bat.Status = 'P' and bat.JrnlType = 'AP'
	and
		ap.DocType = 'VO'
	--and 
	--	ap.User5 = 'S'
	and
		bat.BatNbr = '290839'
;

-- =================================================== rebuild ======================================== --


use integraapp
select 
        bat.perpost,bat.batnbr as 'bat_lote',bat.CpnyID as 'bat_Company', case bat.CuryId when 'MN' then 'MXN' end as 'bat_Moneda'
		----,ap.CuryDocBal as 'ar_rfc'
		--,ap.RefNbr as 'ar_documento' 
		----,ap.BankAcct as 'ar_cuenta' 
		--,ap.CuryOrigDocAmt as 'ar_monto'
		--,ap.User6 as 'ar_factura' , ap.DocType as 'tipodocto'
		--,ap.CuryRate,ap.CuryRateType
		,bat.JrnlType as 'bat_jrnltype'
		,ap.DocType as 'ap_doctype',ap.Acct as 'ap_Acct', ap.CuryTxblTot00 as 'ap_curytxbltot00' ,ap.CuryTxblTot01 as 'ap_curytxbltot01',ap.CuryTaxTot00 as 'ap_curytaxtot00'
		,ap.CuryDocBal as 'ap_curydocbal',ap.CpnyID as 'ap_cpnyid',ap.PerPost as 'ap_perpost',ap.User2 as 'ap_user2',ap.VendId as 'ap_vendid'
		,ap.InvcNbr as 'ap.InvcNbr',cast(ap.InvcDate as date) as 'ap.InvcDate', ap.TaxId01 as 'ap.TaxId01'
		,tra.CuryTxblAmt00  as 'tra_curytxblamt00',tra.CuryTaxAmt00 as 'tra_curytaxamt00',tra.TaxId00 as 'tra.tax' ,tra.User1 as 'tra.user1'
		,cast(tra.TranDate as date) as 'tra_TranDate', tra.TranDesc as 'tra_TranDesc', tra.ExtRefNbr as 'tra.ExtRefNbr'
		,tra.PC_Flag as 'tra.PC_Flag'
--		,bat.*
--		,ap.*
--		,tra.*
from 
        integraapp.dbo.Batch as bat
	left join
		integraapp.dbo.APDoc as ap on bat.BatNbr = ap.BatNbr
	left join 
		integraapp.dbo.APTran as tra on bat.BatNbr = tra.BatNbr
where
		bat.PerPost > 201506
	and 
		bat.Status = 'P' and bat.JrnlType = 'AP'
	and
		ap.DocType = 'VO'
	and 
		tra.TaxId00 = 'IVA 16'
--	and 
--		tra.User1 = 'APU640930KV9' 
--	and 
--		ap.InvcNbr = '40062528026'
--	and 
--		tra.CuryTxblAmt00 = '405.17'
group by 
        bat.perpost,bat.batnbr,bat.CpnyID,bat.CuryId,bat.JrnlType
 		,ap.DocType,ap.Acct,ap.CuryTxblTot00,ap.CuryTxblTot01,ap.CuryTaxTot00
 		,ap.CuryDocBal,ap.CpnyID,ap.PerPost,ap.User2,ap.VendId
		,ap.InvcNbr,ap.InvcDate,ap.TaxId01
 		,tra.CuryTxblAmt00,tra.CuryTaxAmt00,tra.TaxId00,tra.User1
		,tra.TranDate ,tra.TranDesc,tra.ExtRefNbr,tra.PC_Flag


		
		
		
select * from integraapp.dbo.APDoc where BatNbr = '208563'

	
	
-- ==================================== stats ================================================== --	
with mon as (
	select 
			case
				when isnumeric("tran".ExtRefNbr) = 1
					then sum(isnumeric("tran".ExtRefNbr))
			 end as 'numeric'
			,case
				when ( ("tran".ExtRefNbr is not null and "tran".ExtRefNbr <> '') and (isnumeric("tran".ExtRefNbr) = 0) )
					then count("tran".ExtRefNbr)
			 end as 'not_numeric'
			,case
				when ("tran".ExtRefNbr is null or "tran".ExtRefNbr = '')
					then count("tran".ExtRefNbr)
			 end as 'nulls'
			,"tran".User1 as 'rfc' 
	from 
			integraapp.dbo.APTran as "tran"
	where 
			isnumeric(SUBSTRING("tran".User1,1,3)) = 0 and "tran".User1 is not null and "tran".User1 <> '' and "tran".User1 <> 'GLOBAL'
		and
			PerPost > '201600'
	group by 
			"tran".User1
			,"tran".ExtRefNbr
)
select 
			sum("numeric") as 'numeric'
			,sum("not_numeric") as 'not_numeric'
			,sum("nulls") as 'nulls'
			,count("rfc") as 'rfc_not_nulls' 
from 
		mon
		
--	numeric |not_numeric |nulls |rfc_not_nulls |
--	--------|------------|------|--------------|
--	24544   |70103       |3640  |27181         |
		
;



with folios as (
	select 
			case
				when isnumeric("import".Folio) = 1
					then sum(isnumeric("import".Folio))
			end as 'numeric'
			,case
				when ( ("import".Folio is not null and "import".Folio <> '') and (isnumeric("import".Folio) = 0) )
					then count("import".Folio)
			 end as 'not_numeric'
			,case
				when ("import".Folio is null or "import".Folio = '')
					then count("import".Folio)
			 end as 'nulls'
			,"import"."RFC Emisor" as 'rfc'
	from 
			sistemas.dbo.importtbk as "import"
	group by 
				 "import".Folio
				,"import"."RFC Emisor"
)
select 
			sum("numeric") as 'numeric'
			,sum("not_numeric") as 'not_numeric'
			,sum("nulls") as 'nulls'
			,count("rfc") as 'rfc_not_nulls' 
from 
			folios
			
--	numeric |not_numeric |nulls |rfc_not_nulls |
--	--------|------------|------|--------------|
--	22900   |75          |713   |19044         |

select year("Fecha Timbrado") as 'year' from sistemas.dbo.importtbk group by year("Fecha Timbrado")
-- ==================================== stats ================================================== --


where --"import"."RFC Emisor" = 'APU640930KV9'
--and 
"import".Folio like '%30000843%' 




select * from sistemas.dbo.importtbk as "import"
where "import"."RFC Emisor" = 'APU640930KV9'
and "import".Folio like '%10072460742%' 



--upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1)


select isnumeric(Folio) as 'isnumeric',* from sistemas.dbo.importtbk as "import"
where "import"."RFC Emisor" = 'AME880912I89'
and "import".Folio like '%1392193572814%'





-- ORIGINAL ----------------------------------------------------------

select 
		 "import".Archivoimp
		,"import".UUID as 'UUID'
--		,"tb2".ZUUID as 'ZUUID'
		,"import"."RFC Emisor"
		,"import".Folio
		,"ap".User1 as 'AP_RFC_Emisor'
		,"ap".ExtRefNbr as 'AP_Folio'
		,"tb2".ZInvcNbr as 'ZInvcNbr'
		,case
			when substring("ap".ExtRefNbr,1,2) = 'F-'
				then replace("ap".ExtRefNbr,'F-','0')
			when substring("ap".ExtRefNbr,1,2) = 'AP'
				then replace("ap".ExtRefNbr,'AP','')
		 	else "ap".ExtRefNbr
		 end as 'AP_NewFolio'
		,"ap".BatNbr as 'AP_BatNbr'
		,"tb2".ZAPBatNbr as 'ZAPBatNbr'
		,"tb2".ZCuryRcptCtrlAmt as 'ZCuryRcptCtrlAmt'
		,"ap".CpnyID
		,"ap".TranDesc
		,"ap".CuryTxblAmt00
		,"ap".CuryTaxAmt00
		,"import".SubTotal
		,len("ap".ExtRefNbr) as 'AP_len'
		,left("ap".ExtRefNbr, 2 ) as 'AP_left'
		,right("ap".ExtRefNbr, 2 ) as 'AP_right'
from 
		sistemas.dbo.importtbk as "import"
left join 
			(	
				select 
						 "tran".ExtRefNbr
						,case
							when substring("tran".ExtRefNbr,1,2) = 'F-' -- case 'APU640930KV9' = ADO
								then replace("tran".ExtRefNbr,'F-','0')
							when substring("tran".ExtRefNbr,1,2) = 'AP' -- case 'APU640930KV9' = ADO
								then replace("tran".ExtRefNbr,'AP','')
						 	else "tran".ExtRefNbr
						 end as 'NewFolio'
						,"tran".User1
						,"tran".BatNbr
						,"tran".CpnyID
						,"tran".CuryTxblAmt00
						,"tran".CuryTaxAmt00
						,"tran".TranDesc
				from 
						integraapp.dbo.APTran as "tran"
				where 
						"tran".JrnlType = 'AP' and "tran".TaxId00 = 'IVA 16'
					and
						isnumeric(SUBSTRING("tran".User1,1,3)) = 0 and "tran".User1 is not null and "tran".User1 <> '' and "tran".User1 <> 'GLOBAL'
					and
						"tran".ExtRefNbr <> '' and "tran".ExtRefNbr is not null
					and
						"tran".PerPost > '201600'
--					and 
--						"tran".BatNbr in ('284549','284821')
			)
		as "ap"
			on
				"import"."RFC Emisor" collate SQL_Latin1_General_CP1_CI_AS = "ap".User1
			and
				"import".Folio collate SQL_Latin1_General_CP1_CI_AS = "ap".NewFolio 
left join 
			sistemas.dbo.validaciones2 as "tb2" 
	on
			"ap".BatNbr = "tb2".ZAPBatNbr and "ap".CpnyID = "tb2".ZCpnyId collate SQL_Latin1_General_CP1_CI_AS
		and
			"ap".User1 = "tb2".ZVendId collate SQL_Latin1_General_CP1_CI_AS
		and
			"ap".CuryTxblAmt00 = "tb2".ZCuryRcptCtrlAmt
		and
			"import"."RFC Emisor" = "tb2".ZVendId collate SQL_Latin1_General_CP1_CI_AS
		and	
			"import".UUID = "tb2".ZUUID 
--where 
--		"ap".BatNbr = '200742'
where
		"import"."RFC Emisor" = 'APU640930KV9' 
--	and 
--		"import".Folio like '%10072460742%' 		


		--	-- ================================ try2 gtran with excel db ============================================ --


													
													
													
		
	-- TRYING ----------------------------------------------------------
-->> maybe
1
--			and
--				"aps".PerPost = '201603'
--			and
--				"aps".CpnyId = 'TEICUA'
				
				
select * from sistemas.dbo.validaciones2 where ZCpnyId = 'TEICUA' and ZPerPost = '201603' and ZAPBatNbr = '211314'

select User1,VendId,JrnlType,TaxId00,ExtRefNbr,* from integraapp.dbo.APTran where CpnYId = 'TEICUA' and FiscYr = '2016' and BatNbr = '211314'


								
	-- APTRAN ----------------------------------------------------------			
				
				
		select 
				 "tran".ExtRefNbr
				,case
					when substring("tran".ExtRefNbr,1,2) = 'F-' -- case 'APU640930KV9' = ADO
						then replace("tran".ExtRefNbr,'F-','0')
					when substring("tran".ExtRefNbr,1,2) = 'AP' -- case 'APU640930KV9' = ADO
						then replace("tran".ExtRefNbr,'AP','')
				 	else "tran".ExtRefNbr
				 end as 'NewFolio'
				,"tran".User1
				,"tran".BatNbr
				,"tran".CpnyID
				,"tran".CuryTxblAmt00
				,"tran".CuryTaxAmt00
				,"tran".TranDesc
				,*
		from 
				integraapp.dbo.APTran as "tran"
		where 
				"tran".JrnlType = 'AP' and "tran".TaxId00 = 'IVA 16'
			and
				isnumeric(SUBSTRING("tran".User1,1,3)) = 0 and "tran".User1 is not null and "tran".User1 <> '' and "tran".User1 <> 'GLOBAL'
			and
				"tran".ExtRefNbr <> '' and "tran".ExtRefNbr is not null
			and
				"tran".PerPost > '201600'
			and 
				"tran".BatNbr in ('200742','205003')
		
			
	-- ================================ try3  ============================================ --
select 
		 "import".Archivoimp
		,"import".UUID as 'UUID'
		,"import"."RFC Emisor"
		,"import".Folio
		,"import".SubTotal
from 
		sistemas.dbo.importtbk as "import"
where
		"import"."RFC Emisor" = 'CNM980114PI2'
	and
		"import".Folio in ('120728625','495888')
		
		
select * from sistemas.dbo.validaciones2 where ZInvcNbr in ('495888')
and ZUUID in ('968C14B9-88DD-0742-B15E-8A6282B3AF1C')
		
		
	-- ================================ try2 gtran with excel db ============================================ --
	




select 
	        bat.perpost,bat.batnbr as 'bat_lote',bat.CpnyID as 'bat_Company', case bat.CuryId when 'MN' then 'MXN' end as 'bat_Moneda'
			----,ap.CuryDocBal as 'ar_rfc'
			--,ap.RefNbr as 'ar_documento' 
			----,ap.BankAcct as 'ar_cuenta' 
			--,ap.CuryOrigDocAmt as 'ar_monto'
			--,ap.User6 as 'ar_factura' , ap.DocType as 'tipodocto'
			--,ap.CuryRate,ap.CuryRateType
			,bat.JrnlType as 'bat_jrnltype'
			,ap.DocType as 'ap_doctype',ap.Acct as 'ap_Acct', ap.CuryTxblTot00 as 'ap_curytxbltot00' ,ap.CuryTxblTot01 as 'ap_curytxbltot01',ap.CuryTaxTot00 as 'ap_curytaxtot00'
			,ap.CuryDocBal as 'ap_curydocbal',ap.CpnyID as 'ap_cpnyid',ap.PerPost as 'ap_perpost',ap.User2 as 'ap_user2',ap.VendId as 'ap_vendid'
			,ap.InvcNbr as 'ap.InvcNbr',cast(ap.InvcDate as date) as 'ap.InvcDate', ap.TaxId01 as 'ap.TaxId01'
			,tra.CuryTxblAmt00  as 'tra_curytxblamt00',tra.CuryTaxAmt00 as 'tra_curytaxamt00',tra.TaxId00 as 'tra.tax' ,tra.User1 as 'tra.user1'
			,cast(tra.TranDate as date) as 'tra_TranDate', tra.TranDesc as 'tra_TranDesc'
			,tra.ExtRefNbr as 'tra.ExtRefNbr'
			,case
				when substring("tra".ExtRefNbr,1,2) = 'F-' -- case 'APU640930KV9' = ADO
					then replace("tra".ExtRefNbr,'F-','0')
				when substring("tra".ExtRefNbr,1,2) = 'AP' -- case 'APU640930KV9' = ADO
					then replace("tra".ExtRefNbr,'AP','')
			 	else "tra".ExtRefNbr
			 end as 'NewFolio'
			,tra.PC_Flag as 'tra.PC_Flag'
	--		,bat.*
	--		,ap.*
	--		,tra.*
	from 
	        integraapp.dbo.Batch as bat
		left join
			integraapp.dbo.APDoc as ap on bat.BatNbr = ap.BatNbr
		left join 
			integraapp.dbo.APTran as tra on bat.BatNbr = tra.BatNbr
	where
--			bat.PerPost > 201506
--		and 
			bat.Status = 'P' and bat.JrnlType = 'AP'
		and
			ap.DocType = 'VO'
		and 
			tra.TaxId00 = 'IVA 16'
		-- ================================ maybe don't use this ================================================= --
		and
			isnumeric(SUBSTRING("tra".User1,1,3)) = 0 and "tra".User1 is not null and "tra".User1 <> '' and "tra".User1 <> 'GLOBAL'
		and
			"tra".ExtRefNbr <> '' and "tra".ExtRefNbr is not null
		and
			"tra".PerPost > '201600'
		and
			"tra".BatNbr = '201449'
		-- ================================ maybe do not use this ================================================= --
--		and 
--			tra.User1 = 'APU640930KV9' 
--		and 
--			ap.InvcNbr = '40062528026'
	--	and 
	--		tra.CuryTxblAmt00 = '405.17'
	group by 
	        bat.perpost,bat.batnbr,bat.CpnyID,bat.CuryId,bat.JrnlType
	 		,ap.DocType,ap.Acct,ap.CuryTxblTot00,ap.CuryTxblTot01,ap.CuryTaxTot00
	 		,ap.CuryDocBal,ap.CpnyID,ap.PerPost,ap.User2,ap.VendId
			,ap.InvcNbr,ap.InvcDate,ap.TaxId01
	 		,tra.CuryTxblAmt00,tra.CuryTaxAmt00,tra.TaxId00,tra.User1
			,tra.TranDate ,tra.TranDesc,tra.ExtRefNbr,tra.PC_Flag

		
		
		



		
--Folio                 |nvarchar(255) |UNICODE |Modern_Spanish_CI_AS
--RFC Emisor            |nvarchar(255) |UNICODE |Modern_Spanish_CI_AS
--ExtRefNbr       |char(15)      |iso_1   |SQL_Latin1_General_CP1_CI_AS
--User1           |char(30)      |iso_1   |SQL_Latin1_General_CP1_CI_AS



			
--zapbatnbr

-- =============================================================================================================================== -- 
-- ===============================================    Working From hir   ========================================================= --
-- =============================================== from hir do -- Latest -- ====================================================== --
-- =============================================================================================================================== --
-- /**This is the ultimate and working  Wed Jul 12 18:28:06 CDT 2017 */


with "aps" as (
    select
                row_number() over(partition by "ap".CpnyId,"ap".BatNbr,"ap".User1,"ap".VendId,"ap".tstamp order by "ap".tstamp) as "index"
                ,"tb2".ZUUID
                ,"ap".ExtRefNbr
                ,"tb2".ZInvcNbr as 'ZZInvcNbr'
                ,"tb2".ZAPRefno as 'ZZAPRefno'
                ,"ap".CuryTranAmt
--                ,"ap".CuryTxblAmt00
                ,"ap".CuryTaxAmt00
                ,"tb2".ZCuryRcptCtrlAmt as 'zcrcpAmmt'
                ,"ap".TranDesc
                ,"ap".CpnyId,"ap".BatNbr,"ap".User1,"ap".VendId,"ap".tstamp as 'ap.tstamp'
                ,"ap".FiscYr,"ap".PerPost
                ,"tb2".ZAPBatNbr
    from
                sistemas.dbo.validaciones2 as "tb2" --> xls file -> validaciones 2016
        left join
                integraapp.dbo.APTran as "ap" on "ap".JrnlType = 'AP' -- and "ap".TaxId00 = 'IVA 16'
            and
                isnumeric(SUBSTRING("ap".VendId,1,3)) = 0 --> jajajaja ... and this why ??
            and
                "ap".User1 <> 'GLOBAL'
            and
                "ap".BatNbr = "tb2".ZAPBatNbr and "ap".CpnyID = "tb2".ZCpnyId collate SQL_Latin1_General_CP1_CI_AS
            and
                "ap".VendId = "tb2".ZVendId collate SQL_Latin1_General_CP1_CI_AS --> Redeem! collate for solomon
            and
            	"ap".LineType = 'R'
--	where 
--            	"ap".BatNbr in ( '237950' )
--	and
--            round("ap".CuryTxblAmt00,0,1) = round("tb2".ZCuryRcptCtrlAmt,0,1) --> without decimals and not rounding
)
select 	
		"aps"."index","aps".ZUUID,"aps".ExtRefNbr,"aps".ZZInvcNbr,"aps".ZZAPRefno
		,sum("aps".CuryTranAmt) as 'CuryTranAmt'
		--,sum("aps".CuryTxblAmt00) as 'CuryTxblAmt00'
		,sum("aps".CuryTaxAmt00) as 'CuryTaxAmt00'
		,"aps".zcrcpAmmt 
		,"aps".CpnyId,"aps".BatNbr
		--,"aps".User1
		,"aps".VendId
		,"aps".FiscYr,"aps".PerPost,"aps".ZAPBatNbr
from 
		"aps"
where
        "aps"."index" = 1
--    and
--    	"aps".ZUUID in ('32714189-B164-48BF-B815-F79C5C5158B5','D69BFC03-0814-4385-4E84-EA91FED2E588')
--	and 
--		"aps".ZAPBatNbr in (
--							'200169',
--							'246811',
--							'237950'
--							)
group by 
		"aps"."index","aps".ZUUID,"aps".ExtRefNbr,"aps".ZZInvcNbr,"aps".ZZAPRefno
		,"aps".zcrcpAmmt 
		,"aps".CpnyId,"aps".BatNbr
		--,"aps".User1
		,"aps".VendId
		,"aps".FiscYr,"aps".PerPost,"aps".ZAPBatNbr

-- =============================================================================================================================== --
-- ===============================================     Working Done   =  ========================================================= --
-- =============================================================================================================================== --

select count(*) from sistemas.dbo.validaciones2
		
		
		

select LineRef,TranAmt,CuryTranAmt,CuryTaxAmt00,BatNbr,CpnyID,tstamp,* from integraapp.dbo.APTran as "ap" where  "ap".BatNbr in ( '247823' , '247808' )

select * from sistemas.dbo.validaciones2 as "tb2" where ZAPBatNbr in ( '247823' , '247808' )



select LineRef,TranAmt,CuryTranAmt,CuryTaxAmt00,BatNbr,CpnyID,tstamp,* from integraapp.dbo.APTran as "ap" where  "ap".BatNbr in ( '175281', '181090', '190092', '193515', '247808', '247823' )

select * from sistemas.dbo.validaciones2 as "tb2" where ZAPBatNbr in ( '175281', '181090', '190092', '193515', '247808', '247823' )


