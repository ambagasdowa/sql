use integraapp

select * from getBalanzaComprobacion('201602','201602','TBKORI|TBKGDL|TBKRAM|TBKTIJ|TBKHER|TBKLAP','|') -- 19,17,17,15,20,15,22,27,25 secs 11529

exec [sp_udsp_getBalanzaComprobacion] N'201602', N'201602', N'TBKORI|TBKGDL|TBKRAM|TBKTIJ|TBKHER|TBKLAP', N'|' -- 2,2,2,4,4,5,5,4,3 secs 11529

exec [dbo].[sp_udsp_getBalanzaComprobacion] N'201601', N'201601', N'TBKRAM', N'|' 

SELECT ('Happy ' + 'Birthday ' +  cast(11 as nvarchar) + '/' +  '25' ) AS Result;


use NOM2001;
SELECT
	[ViewGetPayrolls].[Cvetra] AS [ViewGetPayrolls__0],
	(rtrim(ltrim([ViewGetPayrolls].[Nombre])) +' '+ rtrim(ltrim([ViewGetPayrolls].[Apepat]))) AS  [ViewGetPayrolls__display_name] 
FROM 
	[view_get_payrolls] AS [ViewGetPayrolls]   
WHERE 
	1 = 1 

use NOM2001;
SELECT
	*
FROM 
	[view_get_payrolls] AS [ViewGetPayrolls]   

SELECT  [ViewGetPayrolls].[Cvetra] AS [ViewGetPayrolls__0], (rtrim(ltrim([ViewGetPayrolls].[Nombre])) + ' ' + rtrim(ltrim([ViewGetPayrolls].[Apepat]))) AS  [ViewGetPayrolls__virtual_name] FROM [view_get_payrolls] AS [ViewGetPayrolls]   WHERE 1 = 1   


SELECT  TOP 80 [ViewGetPayroll].[id] AS [ViewGetPayroll__0], [ViewGetPayroll].[Cvetno] AS [ViewGetPayroll__1], [ViewGetPayroll].[Cvepue] AS [ViewGetPayroll__2], [ViewGetPayroll].[Cvecia] AS [ViewGetPayroll__3], [ViewGetPayroll].[Cveare] AS [ViewGetPayroll__4], [ViewGetPayroll].[Cvetra] AS [ViewGetPayroll__5], [ViewGetPayroll].[Apepat] AS [ViewGetPayroll__6], [ViewGetPayroll].[Apemat] AS [ViewGetPayroll__7], [ViewGetPayroll].[Nombre] AS [ViewGetPayroll__8], [ViewGetPayroll].[Nomina] AS [ViewGetPayroll__9], [ViewGetPayroll].[Company] AS [ViewGetPayroll__10], [ViewGetPayroll].[Area] AS [ViewGetPayroll__11], [ViewGetPayroll].[Departamento] AS [ViewGetPayroll__12], [ViewGetPayroll].[Puesto] AS [ViewGetPayroll__13], [ViewGetPayroll].[Baja] AS [ViewGetPayroll__14], [ViewGetPayroll].[Numrfc] AS [ViewGetPayroll__15], [ViewGetPayroll].[Curp] AS [ViewGetPayroll__16], [ViewGetPayroll].[Numims] AS [ViewGetPayroll__17], [ViewGetPayroll].[Cvecau] AS [ViewGetPayroll__18], (rtrim(ltrim([ViewGetPayrolls].[Nombre]) + ' ' + rtrim(ltrim([ViewGetPayrolls].[Apepat])))) AS  [ViewGetPayroll__virtual_name] FROM [view_get_payrolls] AS [ViewGetPayroll]   WHERE 1 = 1  
SELECT  TOP 80 [ViewGetPayroll].[id] AS [ViewGetPayroll__0], [ViewGetPayroll].[Cvetno] AS [ViewGetPayroll__1], [ViewGetPayroll].[Cvepue] AS [ViewGetPayroll__2], [ViewGetPayroll].[Cvecia] AS [ViewGetPayroll__3], [ViewGetPayroll].[Cveare] AS [ViewGetPayroll__4], [ViewGetPayroll].[Cvetra] AS [ViewGetPayroll__5], [ViewGetPayroll].[Apepat] AS [ViewGetPayroll__6], [ViewGetPayroll].[Apemat] AS [ViewGetPayroll__7], [ViewGetPayroll].[Nombre] AS [ViewGetPayroll__8], [ViewGetPayroll].[Nomina] AS [ViewGetPayroll__9], [ViewGetPayroll].[Company] AS [ViewGetPayroll__10], [ViewGetPayroll].[Area] AS [ViewGetPayroll__11], [ViewGetPayroll].[Departamento] AS [ViewGetPayroll__12], [ViewGetPayroll].[Puesto] AS [ViewGetPayroll__13], [ViewGetPayroll].[Baja] AS [ViewGetPayroll__14], [ViewGetPayroll].[Numrfc] AS [ViewGetPayroll__15], [ViewGetPayroll].[Curp] AS [ViewGetPayroll__16], [ViewGetPayroll].[Numims] AS [ViewGetPayroll__17], [ViewGetPayroll].[Cvecau] AS [ViewGetPayroll__18], (rtrim(ltrim([ViewGetPayrolls].[Nombre]) + ' ' + rtrim(ltrim([ViewGetPayrolls].[Apepat])))) AS  [ViewGetPayroll__virtual_name] FROM [view_get_payrolls] AS [ViewGetPayroll]   WHERE 1 = 1   ORDER BY [ViewGetPayroll].[id] asc 

select Nombre collate SQL_Latin1_General_CP1_CI_AS as 'Nombre' from view_get_payrolls