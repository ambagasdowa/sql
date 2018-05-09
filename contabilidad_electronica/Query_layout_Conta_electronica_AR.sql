Use integraapp;
-- 36825
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
	b.User2 as 'x',
	b.DocType as TipoDocto
from
	Batch a
inner join ARDoc b on
	b.BatNbr = a.BatNbr
where
	a.PerPost > '201506'
	and a.Status = 'P'
	and b.DocType = 'IN'
	and a.JrnlType = 'AR'
	and b.user5 = 'S'
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	and b.User6 like '%004836%'
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
order by
	b.DocType

--join with 

select * from sistemas.dbo.importtotbk
where Folio like '%004836%'

-- 47139
select count(Tipo) from sistemas.dbo.electrocontaeminitdas

-- ================= First Test ===================== --
-- 47136
select 
		Monto,Total,Factura,EstadoPago,* 
from sistemas.dbo.electrocontaeminitdas as "elec"
left join 
		(
			select
				a.perpost,
				a.BatNbr as Lote,
				b.CustId as RFC,
				a.CpnyID as Company,
				b.RefNbr as Documento,
				b.BankAcct as Cuenta,
				b.CuryOrigDocAmt as Monto,0
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
				b.User2 as 'x',
				b.DocType as TipoDocto
			from
				Batch a
			inner join ARDoc b on
				b.BatNbr = a.BatNbr
			where
				a.PerPost > '201506'
				and a.Status = 'P'
				and b.DocType = 'IN'
				and a.JrnlType = 'AR'
				and b.user5 = 'S'
			-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			--	and b.User6 like '%004836%'
			-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--			order by
--				b.DocType
		)	as "solomon" on "elec".EstadoPago = "solomon".Factura collate SQL_Latin1_General_CP1_CI_AS
			and "elec".Total = "solomon".Monto
		order by
			"solomon".Monto asc

-- electroconta



--//** Filtros a considerar: Documentos asentados, documentos fiscales , documentos del modulo AR **// 

--//IN;Factura ,CM;Nota Credito ,DM;Nota Cargo//


-- // 



