use NOM2001;
IF OBJECT_ID ('getPayroll', 'V') IS NOT NULL
    DROP VIEW getPayroll;
GO

create view getPayroll
with encryption
as

SELECT     cvetra, apepat, apemat, nombre,
                          (SELECT     dbo.getNamePuesto(dbo.nomtrab.cveare, dbo.nomtrab.cvecia) AS Expr1) AS Puesto,
                          (SELECT     dbo.getNameDept(dbo.nomtrab.cveare, dbo.nomtrab.cvecia, dbo.nomtrab.cvedep) AS Expr1) AS Department, numrfc, numims, cvecia, cveare, cvepue, 
                      ctaban, sexo, cveban, sucurs, curp, status
FROM         dbo.nomtrab
WHERE     (status = 'A')
go