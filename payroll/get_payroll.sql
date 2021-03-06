
use NOM2001

declare @cvecia nvarchar(3);

select @cvecia = '001' 
-- teisa		cvecia	'001'		-- tipo nomina 0001
-- bonampak		cvecia	'002'		-- tipo nomina 0002
-- macuspana	cvecia	'003'		-- tipo nomina 0001

-- -------------------------------------------------------------------------------------------------------------------------------------------------------- --
-- view thats fecth the current payroll from nom2001
-- -------------------------------------------------------------------------------------------------------------------------------------------------------- --

use NOM2001;
go

IF OBJECT_ID ('view_get_payrolls', 'V') IS NOT NULL
    DROP VIEW view_get_payrolls ;
GO

create view view_get_payrolls
with encryption
as
	select
		row_number()
	over 
		(order by cvetra) as 
							id,
							Cvetno COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvetno',
							Cvepue COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvepue',
							Cvecia COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvecia',
							Cveare COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cveare',
							Cvetra COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvetra',
							Apepat COLLATE SQL_Latin1_General_CP1_CI_AS as 'Apepat',
							Apemat COLLATE SQL_Latin1_General_CP1_CI_AS as 'Apemat',
							Nombre COLLATE SQL_Latin1_General_CP1_CI_AS as 'Nombre',
							Nomina COLLATE SQL_Latin1_General_CP1_CI_AS as 'Nomina',
							Company COLLATE SQL_Latin1_General_CP1_CI_AS as 'Company',
							Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area',
							Departamento COLLATE SQL_Latin1_General_CP1_CI_AS as 'Departamento',
							Puesto COLLATE SQL_Latin1_General_CP1_CI_AS as 'Puesto',
							Baja COLLATE SQL_Latin1_General_CP1_CI_AS as 'Baja',
							Numrfc COLLATE SQL_Latin1_General_CP1_CI_AS as 'Numrfc',
							Curp COLLATE SQL_Latin1_General_CP1_CI_AS as 'Curp',
							Numims COLLATE SQL_Latin1_General_CP1_CI_AS as 'Numims',
							Cvecau COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvecau'
	from(

		select 

				worker.cvetno as 'Cvetno',worker.cvepue as 'Cvepue',
				worker.cvecia as 'Cvecia',worker.cveare as 'Cveare',
				worker.cvetra as 'Cvetra',worker.apepat as 'Apepat',
				worker.apemat as 'Apemat',worker.nombre as 'Nombre',
				(
					select 
						payroll.destno
					from 
						NOM2001.dbo.nomtino as payroll
					where
							payroll.cvecia = worker.cvecia
						and
							payroll.cvetno = worker.cvetno
				) as 'Nomina',
				(
					select 
						company.descia
					from
						NOM2001.dbo.nomcias as company
					where
							company.cvecia = worker.cvecia
				) as 'Company',
				(
					select 
						area.desare
					from 
						NOM2001.dbo.nomarea as area
					where 
							area.cvecia	= worker.cvecia
						and
							area.cveare = worker.cveare
				) as 'Area',
				(
					select 
						dept.desdep
					from 
						NOM2001.dbo.nomdept as dept
					where 
							dept.cvecia = worker.cvecia
						and
							dept.cvedep = worker.cvedep
						and 
							dept.cveare = worker.cveare

				) as 'Departamento',
				(
					select 
						puesto.despue
					from 
						NOM2001.dbo.nompues as puesto
					where 
							puesto.cvecia = worker.cvecia
						and
							puesto.cvepue = worker.cvepue
				) as 'Puesto',

				--(
				--	select distinct
				--		salary.sd
				--	from
				--		NOM2001.dbo.nomsuel as salary
				--	where
				--			salary.cvecia = worker.cvecia
				--		and
				--			salary.cveare = worker.cveare
				--		and
				--			salary.cvepue = worker.cvepue
				--		and
				--			salary.cvetra = worker.cvetra
				--) as 'Salary',

				isnull(
				(
					select
						baja.descau
					from
						NOM2001.dbo.nomcbaj as baja
					where
							baja.cvecia = worker.cvecia
						and
							baja.cvecau = worker.cvecau
				),'Activo') as 'Baja'
				,worker.numrfc,worker.curp,worker.numims,worker.cvecau
				--(select dbo.getNamePuesto(cveare,cvecia)) as Puesto,
				--(select dbo.getNameDept(cveare,cvecia,cvedep)) as Department,
		--		worker.numrfc,worker.numims,worker.cvecia,worker.cveare,worker.cvepue,worker.ctaban,worker.sexo,worker.cveban,worker.sucurs,worker.curp
		from 
				dbo.nomtrab as worker where status = 'A'
			--and 
			--	worker.cvecia = @cvecia -- 275 normal records
			and -- fetch only active workers have 53 inactive with 52 codes and one blank so the blank goes to null ?
				(
						worker.cvecau is null 
					or 
						worker.cvecau = ''
				) 
	) AS Results

go

---- teisa 98
--select *
--from NOM2001.dbo.nomarea 
--where NOM2001.dbo.nomarea.cvecia = @cvecia --and NOM2001.dbo.nomarea.cveare = @cveare

--select *
--from NOM2001.dbo.nomdept 
--where NOM2001.dbo.nomdept.cvecia = @cvecia
--	-- and dbo.nomdept.cvedep = @cvedep
--	-- and NOM2001.dbo.nomdept.cveare = @cveare

--select * 
--from NOM2001.dbo.nompues 
--where NOM2001.dbo.nompues.cvecia = @cvecia

--select * from NOM2001.dbo.nomtino

-- select count(cvetra) from NOM2001.dbo.nomsuel -- 75128

-- select * from NOM2001.dbo.nomcbaj


select * from NOM2001.dbo.view_get_payrolls

-- -------------------------------------------------------------------------------------------------------------------------------------------------------- --
-- view thats fecth the current payroll from nom2001 id version with cvetra
-- -------------------------------------------------------------------------------------------------------------------------------------------------------- --

use NOM2001;
go

IF OBJECT_ID ('view_get_payrolls', 'V') IS NOT NULL
    DROP VIEW view_get_payrolls ;
GO

create view view_get_payrolls
with encryption
as
	--select
	--	row_number()
	--over 
	--	(order by cvetra) as 
	--						id,
	--						Cvetno COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvetno',
	--						Cvepue COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvepue',
	--						Cvecia COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvecia',
	--						Cveare COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cveare',
	--						Cvetra COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvetra',
	--						Apepat COLLATE SQL_Latin1_General_CP1_CI_AS as 'Apepat',
	--						Apemat COLLATE SQL_Latin1_General_CP1_CI_AS as 'Apemat',
	--						Nombre COLLATE SQL_Latin1_General_CP1_CI_AS as 'Nombre',
	--						Nomina COLLATE SQL_Latin1_General_CP1_CI_AS as 'Nomina',
	--						Company COLLATE SQL_Latin1_General_CP1_CI_AS as 'Company',
	--						Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area',
	--						Departamento COLLATE SQL_Latin1_General_CP1_CI_AS as 'Departamento',
	--						Puesto COLLATE SQL_Latin1_General_CP1_CI_AS as 'Puesto',
	--						Baja COLLATE SQL_Latin1_General_CP1_CI_AS as 'Baja',
	--						Numrfc COLLATE SQL_Latin1_General_CP1_CI_AS as 'Numrfc',
	--						Curp COLLATE SQL_Latin1_General_CP1_CI_AS as 'Curp',
	--						Numims COLLATE SQL_Latin1_General_CP1_CI_AS as 'Numims',
	--						Cvecau COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cvecau'
	--from(

		select 
				worker.cvetra as id,
				worker.cvetno,worker.cvepue,
				worker.cvecia,worker.cveare,
				worker.cvetra,worker.apepat,
				worker.apemat,worker.nombre,
				(
					select 
						payroll.destno
					from 
						NOM2001.dbo.nomtino as payroll
					where
							payroll.cvecia = worker.cvecia
						and
							payroll.cvetno = worker.cvetno
				) as 'Nomina',
				(
					select 
						company.descia
					from
						NOM2001.dbo.nomcias as company
					where
							company.cvecia = worker.cvecia
				) as 'Company',
				(
					select 
						area.desare
					from 
						NOM2001.dbo.nomarea as area
					where 
							area.cvecia	= worker.cvecia
						and
							area.cveare = worker.cveare
				) as 'Area',
				(
					select 
						dept.desdep
					from 
						NOM2001.dbo.nomdept as dept
					where 
							dept.cvecia = worker.cvecia
						and
							dept.cvedep = worker.cvedep
						and 
							dept.cveare = worker.cveare

				) as 'Departamento',
				(
					select 
						puesto.despue
					from 
						NOM2001.dbo.nompues as puesto
					where 
							puesto.cvecia = worker.cvecia
						and
							puesto.cvepue = worker.cvepue
				) as 'Puesto',

				--(
				--	select distinct
				--		salary.sd
				--	from
				--		NOM2001.dbo.nomsuel as salary
				--	where
				--			salary.cvecia = worker.cvecia
				--		and
				--			salary.cveare = worker.cveare
				--		and
				--			salary.cvepue = worker.cvepue
				--		and
				--			salary.cvetra = worker.cvetra
				--) as 'Salary',

				isnull(
				(
					select
						baja.descau
					from
						NOM2001.dbo.nomcbaj as baja
					where
							baja.cvecia = worker.cvecia
						and
							baja.cvecau = worker.cvecau
				),'no') as 'Baja'
				,worker.numrfc,worker.curp,worker.numims,worker.cvecau
				--(select dbo.getNamePuesto(cveare,cvecia)) as Puesto,
				--(select dbo.getNameDept(cveare,cvecia,cvedep)) as Department,
		--		worker.numrfc,worker.numims,worker.cvecia,worker.cveare,worker.cvepue,worker.ctaban,worker.sexo,worker.cveban,worker.sucurs,worker.curp
		from 
				dbo.nomtrab as worker where status = 'A'
			--and 
			--	worker.cvecia = @cvecia -- 275 normal records
			and -- fetch only active workers have 53 inactive with 52 codes and one blank so the blank goes to null ?
				(
						worker.cvecau is null 
					or 
						worker.cvecau = ''
				) 
	--) AS Results

go