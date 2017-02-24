use NOM2001;
--('4000001','4000004','4000005','4000008','4000011','4000013','4000010','4000018','4000019','4000022','4000023','4000028','4000030','4000017')
select * from NOM2001.dbo.getPayroll where cvetra in (
															 '4000006', '4000009', '4000026', '4000002', '4000029', '4000030', '4000031', '4000032','1000370'
													 )

select * from NOM2001.dbo.view_get_payrolls where Cvetra in (
															 '4000006', '4000009', '4000026', '4000002', '4000029', '4000030', '4000031', '4000032'
															)

select * from NOM2001.dbo.nomtrab where cvetra in	
													(
														 '4000006', '4000009', '4000026', '4000002', '4000029', '4000030', '4000031', '4000032','1000370'
													)
										and status = 'A'


select * from NOM2001.dbo.nomtrab where nombre like 'jesus%'

select regims,* from NOM2001.dbo.nomrpat where replace(desrpa,'TBK ','') = replace(payroll.Area,'BASE ','') ) as 'rp',
--update 
--NOM2001.dbo.nomtrab 
--set status = 'B'
----, fecbaj = NULL , fecbim = NULL, feccba = NULL
--where cvetra = '3002003'



select * from NODI.dbo.ca_empleados where cve_empleado in ('4000033', '1000792', '4000006', '4000009', '4000026', '1000790', '4000030', '4000002', '4000029', '1000787', '1000793', '4000031', '4000032')

select * from NOM2001.dbo.nomtrab where nombre = 'miriam'

select * from NOM2001.dbo.nomtrab where cvetra in ('4000001','4000004','4000005','4000008','4000011','4000013','4000010','4000018','4000019','4000022','4000023','4000028','4000030','4000017')
