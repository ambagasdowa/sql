Use integraapp;

Select Distinct Bat.CpnyID, Bat.BatNbr, AP.RefNbr As Cheque, AP.Acct, Ap.CuryOrigDocAmt, AP.VendId, CASE Bat.CuryId WHEN 'MN' THEN 'MXN' WHEN 'USD' THEN 'USD' WHEN 'EUR' THEN 'EUR' End As Moneda, CASE AP.User1 WHEN 'CK' THEN 'CHEQUE' WHEN 'EC' THEN 'TRANSFERENCIA' WHEN '' THEN 'OTROS' END Tipo_pago, AP.VendId as RFC_Beneficiario, CASE Xven.BankDestination WHEN 'UNIC' THEN 'X' Else Xven.BankDestination End As Banco_Destino, XBank.Descr AS Banco_Destino, Cury.Rate
From Batch Bat
INNER JOIN APDoc AP ON AP.BatNbr = Bat.BatNbr
LEFT JOIN XVendorMulAcctBank Xven ON Xven.VendId = AP.VendId
LEFT JOIN XBankingCommission XBank ON XBank.Code = Xven.BankDestination
LEFT JOIN Curyrate Cury ON Cury.FromCuryId = Bat.CuryId
Where Bat.BatNbr = '234641' And AP.RefNbr = '152512'
--INNER JOIN XVendorMulAcctBank Xven ON Xven.VendId = AP.VendId
--INNER JOIN XVendorMulAcctBank Xven ON Xven.VendId = AP.VendId
--INNER JOIN XBankingCommission Xbank ON Xbank.Code 0 Xven.BankDestination
--INNER JOIN curyrate Cu ON Cu.FromCuryId = bat.CuryId
--485452

--Select * From APDoc
--Select * From Batch
--Select * From curyrate
--Select * From XVendorMulAcctBank
--Select * From XBankingCommission

--curyrate.fromcuryid
--curyrate.ratetype
--curyrate.rate
--curyunits.fromunits
--curyunits.fromcuryid
--XVendorMulAcctBank.BankDestination
--XVendorMulAcctBank.DestAcct
--XVendorMulAcctBank.DocType
--Vendor.VendId
