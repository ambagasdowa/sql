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
--		bat.BatNbr = '290839'
		
	and tra.User1 = 'APU640930KV9' 
	and ap.PerPost between '201602' and '201604'
	and ap.InvcNbr = '40062528026'
	
--	and substring(tra.ExtRefNbr,2,11) = '040062528026'
--	     in (
--		         '40062528025'
--	     		,'40062681323','40062721075','40062691170','40062720063','40062691169','40062528026'
--	     	    ,'90069535677','90069482918','90069482917','40062012671','40062012673'
--
--	     	)
	and tra.CuryTxblAmt00 = '405.17'
--	and tra.CuryTaxAmt00 = '67.32'
--	and ap.CpnyID = 'TBKORI'
 
group by 
        bat.perpost,bat.batnbr,bat.CpnyID,bat.CuryId,bat.JrnlType
 		,ap.DocType,ap.Acct,ap.CuryTxblTot00,ap.CuryTxblTot01,ap.CuryTaxTot00
 		,ap.CuryDocBal,ap.CpnyID,ap.PerPost,ap.User2,ap.VendId
		,ap.InvcNbr,ap.InvcDate,ap.TaxId01
 		,tra.CuryTxblAmt00,tra.CuryTaxAmt00,tra.TaxId00,tra.User1
		,tra.TranDate ,tra.TranDesc,tra.ExtRefNbr,tra.PC_Flag
;



select * from sistemas.dbo.importtbk





use integraapp


	exec sp_desc APDoc

	exec sp_desc Batch
	
	
	select top 0 * from integraapp.dbo.Batch
	
	select 
			 min(cast(batman.BatNbr as int)) as 'min' 
			,max(cast(batman.BatNbr as int)) as 'max' 
			,max(batman.BatNbr) as 'max_the_var' 
			,count (batman.BatNbr) as 'counts' 
			,batman.CpnyID
	from 
			integraapp.dbo.Batch as batman
	group by 
			batman.CpnyID