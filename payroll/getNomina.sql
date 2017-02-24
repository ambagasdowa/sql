use NOM2001;
IF OBJECT_ID ('getNomina', 'V') IS NOT NULL
    DROP VIEW getNomina;
GO

create view getNomina
with encryption
as

SELECT     TOP (100) PERCENT dbo.getNamePuesto(acumulado.cveare, acumulado.cvecia) AS Puesto, acumulado.cvecia AS ClaveEmpresa, acumulado.cveper AS Fecha, 
                      acumulado.cvetra AS ClaveTrabajador, acumulado.cvefor AS ClaveConcepto, acumulado.monto, acumulado.reteni AS Retenido, 
                      dbo.getConceptoNomina(acumulado.cvecia, acumulado.cvefor, acumulado.cveper) AS Concepto, 
                      trabajador.apepat + ' ' + trabajador.apemat + ' ' + trabajador.nombre AS Nombre, trabajador.cvetno AS tipoNomina, trabajador.numrfc AS Rfc, 
                      trabajador.numims AS Imss, trabajador.status AS Stauts, trabajador.fecalt AS fechaAlta, trabajador.fecbaj AS fechaBaja, trabajador.cvezon AS ClaveZonaEconomica, 
                      trabajador.curp
FROM         dbo.nomacum AS acumulado INNER JOIN
                      dbo.nomtrab AS trabajador ON trabajador.cvecia = acumulado.cvecia AND trabajador.cvetra = acumulado.cvetra
WHERE     (acumulado.cvecia = '002') AND (acumulado.cveper > '2014-12-20 23:00.000') AND (acumulado.cvefor LIKE 'D00%' OR
                      acumulado.cvefor LIKE 'P00%' OR
                      acumulado.cvefor LIKE 'R00%' OR
                      acumulado.cvefor LIKE 'D0101%' OR
                      acumulado.cvefor LIKE 'P1006%' OR
                      acumulado.cvefor LIKE 'P1003%')
ORDER BY 'Fecha'
go