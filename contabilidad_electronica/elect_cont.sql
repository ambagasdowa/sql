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


