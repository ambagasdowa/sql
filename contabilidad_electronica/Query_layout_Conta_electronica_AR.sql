Use integraapp;
-- 36825
select
	a.perpost,
	cast(a.BatNbr as char(12)) as Lote,
	b.CustId as RFC,
	a.CpnyID as Company,
	cast(b.RefNbr as char(12)) as Documento,
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
use integraapp

select 
		* 
from 
		sistemas.dbo.electrocontaeminitdas as "elec"
where 
		[Estado SAT] = 'Cancelado'

		
		
		

-- electroconta

use integraapp;	

			
with "slr" as (
	
select 
		* 
from 
		sistemas.dbo.electrocontaeminitdas as "elec"
left join 
		(
			select
				a.perpost,
				cast(a.BatNbr as char(12)) as Lote,
				b.CustId as RFC,
				a.CpnyID as Company,
				cast(b.RefNbr as char(12)) as Documento,
				b.BankAcct as Cuenta,
				b.CuryOrigDocAmt as Monto,
				Modulo = 'AR',
				LineRef = 0,
				case
					a.CuryId
					when 'MN' then 'MXN'
					when 'USD' then 'USD'
					when 'EUR' then 'EUR'
				end as MonedaSL,
				CuryRate = 1,
				'I' as "SlTipo",
				b.User6 as Factura,
				b.User2 as 'x',
				b.DocType as TipoDocto
			from
				integraapp.dbo.Batch a
			inner join integraapp.dbo.ARDoc b on
				b.BatNbr = a.BatNbr
			where
				a.PerPost > '201506'
				and a.Status = 'P'
				and b.DocType in ('IN','CM','DM')
				and a.JrnlType = 'AR'
				and b.user5 = 'S'
		)as "solomon" 
	on 
			"elec".EstadoPago = "solomon".Factura collate SQL_Latin1_General_CP1_CI_AS
	and 
			"elec".Total = "solomon".Monto
)
select 
		* 
from 
		"slr" 
where 
		"slr".[Estado SAT] <> 'Cancelado'
			
--////////////////////////////			
			
with "slr" as (
	
select 
		* 
from 
		sistemas.dbo.electrocontaeminitdas as "elec"
full join 
		(
			select
				a.perpost,
				cast(a.BatNbr as char(12)) as Lote,
				b.CustId as RFC,
				a.CpnyID as Company,
				cast(b.RefNbr as char(12)) as Documento,
				b.BankAcct as Cuenta,
				b.CuryOrigDocAmt as Monto,
				Modulo = 'AR',
				LineRef = 0,
				case
					a.CuryId
					when 'MN' then 'MXN'
					when 'USD' then 'USD'
					when 'EUR' then 'EUR'
				end as MonedaSL,
				CuryRate = 1,
				'I' as "SlTipo",
				b.User6 as Factura,
				b.User2 as 'x',
				b.DocType as TipoDocto
			from
				integraapp.dbo.Batch a
			inner join integraapp.dbo.ARDoc b on
				b.BatNbr = a.BatNbr
			where
				a.PerPost > '201506'
				and a.Status = 'P'
				and b.DocType in ('IN','CM','DM')
				and a.JrnlType = 'AR'
				and b.user5 = 'S'
		)as "solomon" 
	on 
			"elec".EstadoPago = "solomon".Factura collate SQL_Latin1_General_CP1_CI_AS
	and 
			"elec".Total = "solomon".Monto
)
select 
		* 
from 
		"slr" 
where 
		"slr".[Estado SAT] <> 'Cancelado'
	
--///////////////////////////			
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
	end as MonedaSL,
	CuryRate = 1,
	'I' as "SlTipo",
	b.User6 as Factura,
	b.User2 as 'x',
	b.DocType as TipoDocto
from
	Batch a
inner join ARDoc b on
	b.BatNbr = a.BatNbr
where
--	a.PerPost > '201506'
--	and 
	a.Status = 'P'
	and b.DocType in ('IN','CM','DM')
	and a.JrnlType = 'AR'
	and b.user5 = 'S'
	and a.BatNbr = '070346'
	
select 
		"bat".Status,"bat".JrnlType,"bat".BatNbr
		,"doc".DocType,"doc".User5,
		* 
from integraapp.dbo.Batch as "bat" -- where BatNbr = '070346'
inner join integraapp.dbo.ARDoc as "doc" on "bat".BatNbr = "doc".BatNbr
where "bat".BatNbr = '070346'
	and "bat".JrnlType = 'AR'
	
	select * from sistemas.dbo.electrocontaeminitdas 
	where EstadoPago = 'FGC-000173'
	
	
select DocType from integraapp.dbo.ARDoc	
group by DocType





--//** Filtros a considerar: Documentos asentados, documentos fiscales , documentos del modulo AR **// 

--//IN;Factura ,CM;Nota Credito ,DM;Nota Cargo//


-- // 



