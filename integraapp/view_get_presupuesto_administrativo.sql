use sistemas;
IF OBJECT_ID ('view_get_presupuesto_administrativo', 'V') IS NOT NULL
    DROP VIEW view_get_presupuesto_administrativo;
GO

create view view_get_presupuesto_administrativo
with encryption
as
SELECT 
      prep.Acct as 'Cuenta'
	  ,(select Descr from integraapp.dbo.Account as DescAcc where DescAcc.Acct = prep.Acct) as 'Description'
      ,SUBSTRING(prep.Sub,8,4) as 'Segmento'
	  --,prep.Sub
      ,prep.CpnyID 
	  ,(select PtdBal00 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Enero'
	  ,(select PtdBal01 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Febrero'
      ,(select PtdBal02 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Marzo'
      ,(select PtdBal03 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Abril'
      ,(select PtdBal04 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Mayo'
      ,(select PtdBal05 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Junio'
      ,(select PtdBal06 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Julio'
      ,(select PtdBal07 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Agosto'
      ,(select PtdBal08 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Septiembre'
      ,(select PtdBal09 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Octubre'
      ,(select PtdBal10 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Noviembre'
      ,(select PtdBal11 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub) as 'Diciembre'
      --prep.PtdBal12]
      ,prep.FiscYr
      --prep._key]
      ,prep._source_company as 'Company'
  FROM [sistemas].[dbo].[mr_source_presupuestos_temps] as prep
  where prep._key = 'AD' and prep.FiscYr = '2016' 
--  and Acct = '0501179900'
  -- select PtdBal00 from integraapp.dbo.AcctHist where Acct = prep.Acct and LedgerID = 'PRESUP2016' and Sub = prep.Sub