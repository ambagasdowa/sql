Use integraapp;

Select a.perpost, a.BatNbr As Lote,  b.CustId As RFC,a.CpnyID As Company,b.RefNbr as Documento,  b.BankAcct as Cuenta, b.CuryOrigDocAmt as Monto, Modulo='AR', LineRef=0,  CASE a.CuryId WHEN 'MN' THEN 'MXN' WHEN 'USD' THEN 'USD' WHEN 'EUR' THEN 'EUR' End As Moneda, CuryRate=1, Tipo='I', b.User6 As Factura, b.DocType As TipoDocto
From Batch a
INNER JOIN ARDoc b
ON b.BatNbr = a.BatNbr
where a.PerPost>'201506' and a.Status='P'   and b.DocType='IN' and a.JrnlType='AR' AND b.user5='S'
order by b.DocType


--//** Filtros a considerar: Documentos asentados, documentos fiscales , documentos del modulo AR **// 

--//IN;Factura ,CM;Nota Crédito ,DM;Nota Cargo//




