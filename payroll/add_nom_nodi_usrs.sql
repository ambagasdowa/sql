
--select regims,desrpa,* from NOM2001.dbo.nomrpat 

-- ramos arizpe ('1000717', '1000732', '1000733', '1000378', '1000447', '1000742', '1000755', '1000756', '1000757', '1000759', '1000095', '1000777', '1000770', '1000774', '1000775', '1000776', '1000782', '1000785', '1000786', '1000787')

-- gualalajara ('1000710', '1000728', '1000734', '1000517', '1000740', '1000484', '1000743', '1000745', '1000749', '1000750', '1000751', '1000752', '1000531', '1000762', '1000763', '1000764    ', '1000768', '1000769', '1000778', '1000779', '1000780', '1000783', '1000784')

-- hermosillo ('1000721', '1000719', '1000722', '1000723', '1000727', '1000731', '1000738', '1000747', '1000758', '1000765')

-- mexicali ('1000712', '1000724', '1000725', '1000737', '1000772', '1000773')

-- orizaba ('1000716', '1000713', '1000714', '1000715', '1000720', '1000739', '1000748', '1000753', '1000754', '1000766', '1000781')
-- all ( '1000717','1000732','1000733','1000378','1000447', '1000742', '1000755', '1000756', '1000757', '1000759', '1000095', '1000777', '1000770', '1000774', '1000775', '1000776    ', '1000782', '1000785', '1000786', '1000787', '1000710', '1000728', '1000734', '1000517', '1000740', '1000484', '1000743', '1000745', '1000749', '1000750', '1000751', '1000    752', '1000531', '1000762', '1000763', '1000764', '1000767', '1000768', '1000769', '1000778', '1000779', '1000780', '1000783', '1000784', '1000721', '1000719', '1000722', '1    000723', '1000727', '1000731', '1000738', '1000747', '1000758', '1000765', '1000716', '1000713', '1000714', '1000715', '1000720', '1000739', '1000748', '1000753', '1000754','1000766', '1000781', '1000712', '1000724','1000725', '1000737', '1000772','1000773')

-- use vim to paste xls data to inline data 
-- %s/^/'/g | %s/$/',/g | %j

-- nov-2016 '1000811', '1000821', '1000822', '4000033', '1000816', '1000812', '1000815', '1000813', '1000814', '1000823', '1000825', '1000826', '1000817', '1000818', '    1000819', '1000820', '1000824'

-- Insert to Nodi firts remove old records of nodi after that insert the updated records from NOM

----  insert into NODI.dbo.ca_empleados 
--select  

--		Numrfc as 'rfc',
--		(select Apepat + ' ' + Apemat + ' ' + Nombre ) as 'nombre',
--		(select ' ') as 'calle',
--		(select ' ') as 'no_ext',
--		(select ' ') as 'no_int',
--		(select ' ') as 'colonia',
--		Area as 'localidad',
--		Area as 'municipio',
--		(select ' ') as 'estado',
--		(select 'MEXICO') as 'pais',
--		(select ' ') as 'cp',
--		(select ' ') as 'email',
--		--this is valid only in tbk
--		--(select regims from NOM2001.dbo.nomrpat where replace(desrpa,'TBK ','') = replace(payroll.Area,'BASE ','') ) as 'rp',
--		Cvetra as 'cve_empleado',
--		Curp as 'curp',
--		Numims as 'nss',
--		Departamento as 'departamento',
--		(select ' ') as 'clabe',
--		(select ' ') as 'banco',
--		--(select fecalt from NOM2001.dbo.nomtrab where cvetra = payroll.Cvetra) as 'fecha_alta',
--		--(select( right('00'+convert(varchar(2),day(fecalt)), 2) + '/' + right('00'+convert(varchar(2),MONTH(fecalt)), 2) + '/' + CONVERT(nvarchar(4), YEAR(fecalt)) ) from NOM2001.dbo.nomtrab where cvetra = payroll.Cvetra ) as 'fecha_alta' ,
--		(select ' ') as 'fecha_baja',
--		Puesto as 'puesto',
--		(select ' ') as 'tipocontr',
--		(select ' ') as 'tipojorn',
--		(select ' ') as 'perpago',
--		(select ' ') as 'clv_regimen',
--		(select ' ') as 'des_regimen',
--		(select ' ') as 'clv_riesgop',
--		(select ' ') as 'des_riesgop'
		  
--	from 
--		NOM2001.dbo.view_get_payrolls as payroll 
--	where 
--		Baja = 'no'
--		and	Cvetra in	(
--							 '4000006', '4000009', '4000026', '4000002', '4000029', '4000030', '4000031', '4000032'
--						)


--  insert into NODI.dbo.ca_empleados 

select  

		numrfc as 'rfc',
		(select apepat + ' ' + apemat + ' ' + nombre ) as 'nombre',
		(select ' ') as 'calle',
		(select ' ') as 'no_ext',
		(select ' ') as 'no_int',
		(select ' ') as 'colonia',
		(
			select 
				area.desare
			from 
				NOM2001.dbo.nomarea as area
			where 
					area.cvecia	= payroll.cvecia
				and
					area.cveare = payroll.cveare
		)  as 'localidad',
		(
			select 
				area.desare
			from 
				NOM2001.dbo.nomarea as area
			where 
					area.cvecia	= payroll.cvecia
				and
					area.cveare = payroll.cveare
		) as 'municipio',
		(select ' ') as 'estado',
		(select 'MEXICO') as 'pais',
		(select ' ') as 'cp',
		(select ' ') as 'email',
		-- set the registro patronal
		--(select regims from NOM2001.dbo.nomrpat where cvecia = '002' and cverpa = '01') as 'rp',
		--this is valid only in tbk
		--(select 'E6480571109') as 'rp',
		(select regims from NOM2001.dbo.nomrpat where replace(desrpa,'TBK ','') = replace(
			(
				select 
					area.desare
				from 
					NOM2001.dbo.nomarea as area
				where 
						area.cvecia	= payroll.cvecia
					and
						area.cveare = payroll.cveare
				group by area.desare
			)
			,'BASE ','') 
		) as 'rp',
		cvetra as 'cve_empleado',
		curp as 'curp',
		numims as 'nss',
		Department as 'departamento',
		(select ' ') as 'clabe',
		(select ' ') as 'banco',
		--(select trab.fecalt from NOM2001.dbo.nomtrab as trab where trab.cvetra = payroll.cvetra and trab.status = payroll.status) as 'fecha_alta',
		(select( right('00'+convert(varchar(2),day(source_date.fecalt)), 2) + '/' + right('00'+convert(varchar(2),MONTH(source_date.fecalt)), 2) + '/' + CONVERT(nvarchar(4), YEAR(source_date.fecalt)) ) from NOM2001.dbo.nomtrab as source_date where source_date.cvetra = payroll.cvetra and source_date.status = payroll.status and source_date.cvecia = payroll.cvecia and source_date.cveare = payroll.cveare and source_date.numrfc = payroll.numrfc) as 'fecha_alta' ,
		(select ' ') as 'fecha_baja',
		Puesto as 'puesto',
		(select ' ') as 'tipocontr',
		(select ' ') as 'tipojorn',
		(select ' ') as 'perpago',
		(select ' ') as 'clv_regimen',
		(select ' ') as 'des_regimen',
		(select ' ') as 'clv_riesgop',
		(select ' ') as 'des_riesgop'
		
	from 
		NOM2001.dbo.getPayroll as payroll 
	where 
			cvetra in	(
							--'1000835',
							--  '1000837', '1000839',  '1000838', '1000842', '1000843', '1000844'
							 -- '1000842'
							 --,'1000843'
							 --,'1000844'
							--'1000850'
							-- '1000522'
							 --'1000841'
							 --,'1000847'
							 --,'1000848'
							--  '1000650'
							 '1000799', '1000825', '1000826'
							--, '1000845', '1000846'
							--, '1000840', '1000849', '1000611'
						)
--		and numrfc not in ('ROMC710221816')

	--select * from NODI.dbo.ca_empleados where cve_empleado = '3000971'
-- to

select 
		--cve_empleado,nombre,rfc,curp,nss,rp,localidad,municipio,pais
		--,calle,no_ext,no_int,colonia,estado,cp,email
		--,
		* 
from 
--update	
-- delete
		NODI.dbo.ca_empleados 
--set rp = 'G3310716101'
where 
		cve_empleado in (
							--  '1000650'
							 '1000799', '1000825', '1000826'
							--, '1000845', '1000846'
							--, '1000840', '1000849', '1000611'
						)
order by cve_empleado



--select * from NODI.dbo.ma_master where numempleado in ( '1000722','1000010')

select BatNbr,FiscYr,* from integraapp.dbo.GLTran where FiscYr = ''

select BatNbr,FiscYr,* from integraapp.dbo.GLTran where BatNbr = '221152'


select BatNbr,FiscYr,*
from
--update
integraapp.dbo.GLTran
--set FiscYr = '2016'
 where BatNbr = '221152' and FiscYr = ''



