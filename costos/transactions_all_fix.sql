-- =================================================== Transacciones Todo (fix) ============================================= --

-- ================================= Set Permissions to a user ================================== --

use integraapp

select
	TABLE_NAME
from
	information_schema.tables
where 
	TABLE_NAME like '%transacciones%'
	


-- exec sp_helptext "Bon_v_TransaccionesTodo"
-- exec sp_helptext "Bon_v_transaccionesATM"
-- exec sp_helptext "Bon_v_transaccionesTEISA"
-- exec sp_helptext "Bon_v_TransaccionesGST"
-- exec sp_helptext "Bon_v_Transacciones"
-- ================================= start the views ============================================== --
use integraapp;
IF OBJECT_ID ('Bon_v_TransaccionesTodo', 'V') IS NOT NULL
    DROP VIEW Bon_v_TransaccionesTodo

create view Bon_v_TransaccionesTodo
--with encryption
as

--create view dbo.Bon_v_TransaccionesTodo 
--	AS 
	
	select
		case
			substring(dbo.GLTran.PerPost,5,2) 
			when '01' then 'ENERO'
			when '02' then 'FEBRERO'
			when '03' then 'MARZO'
			when '04' then 'ABRIL'
			when '05' then 'MAYO' 
			WHEN '06' then 'JUNIO'
			when '07' then 'JULIO'
			when '08' then 'AGOSTO'
			when '09' then 'SEPTIEMBRE'
			when '10' then 'OCTUBRE' 
			WHEN '11' then 'NOVIEMBRE'
			when '12' then 'DICIEMBRE'
		end as Mes,
		dbo.GLTran.PerPost,
		dbo.GLTran.Acct as NoCta,
		dbo.Account.Descr as NombreCta,
		dbo.GLTran.PerEnt,
		dbo.GLTran.CpnyID as Compañía,
		dbo.GLTran.JrnlType as Tipo,
		dbo.GLTran.Sub as Entidad,
		case
			(
				substring( dbo.GLTran.Sub, 1, 1 )
			) 
			when 'A' then 'BALANCE'
			when 'C' then 'BALANCE'
			when 'B' then 'BALANCE'
			when 'F' then 'BALANCE'
			when 0 then 'GRANEL'
			when 8 then 'TERCEROS' WHEN 7 then 'ENVASADO'
			else 'BALANCE'
		end as linea_negocio,
		dbo.GLTran.TranType as TipoTransacción,
		dbo.GLTran.RefNbr as Referencia,
		dbo.GLTran.ExtRefNbr as RefExterna,
		dbo.GLTran.TranDate as FechaTransacción,
		dbo.GLTran.TranDesc as Descripción,
		dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate as Abono,
		dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate as Cargo,
		substring( dbo.GLTran.Sub, 8, 2 )  as UnidadNegocio,
		substring( dbo.GLTran.Sub, 10, 6 ) as CentroCosto,
		dbo.SubAcct.Descr,
		dbo.GLTran.Crtd_User,
		dbo.GLTran.BatNbr
	from
		dbo.GLTran inner JOIN dbo.Account on
		dbo.GLTran.Acct = dbo.Account.Acct inner JOIN dbo.SubAcct on
		dbo.GLTran.Sub = dbo.SubAcct.Sub
	where
		(
			dbo.GLTran.Posted = 'P'
		)
		and(
			dbo.GLTran.PerPost > '201600'
		)
		and(
			dbo.GLTran.CpnyID in(
				'TBKORI',
				'TBKRAM',
				'TBKHER',
				'TBKCUL',
				'TBKGDL',
				'TBKLAP',
				'TBKTIJ'
			)
		)
		
		
-- ============================================ ATM ======================================== --
use integraapp;
IF OBJECT_ID ('Bon_v_transaccionesATM', 'V') IS NOT NULL
    DROP VIEW Bon_v_transaccionesATM

--with encryption

create
	view dbo.Bon_v_transaccionesATM 
	as 
	select
		case
			substring(dbo.GLTran.PerPost,5,2) 
			when '01' then 'ENERO'
			when '02' then 'FEBRERO'
			when '03' then 'MARZO'
			when '04' then 'ABRIL'
			when '05' then 'MAYO' 
			WHEN '06' then 'JUNIO'
			when '07' then 'JULIO'
			when '08' then 'AGOSTO'
			when '09' then 'SEPTIEMBRE'
			when '10' then 'OCTUBRE' 
			WHEN '11' then 'NOVIEMBRE'
			when '12' then 'DICIEMBRE'
		end as Mes,
		dbo.GLTran.PerPost,
		dbo.GLTran.Acct as NoCta,
		dbo.Account.Descr as NombreCta,
		dbo.GLTran.PerEnt,
		dbo.GLTran.CpnyID as Compañía,
		dbo.GLTran.JrnlType as Tipo,
		dbo.GLTran.Sub as Entidad,
		dbo.GLTran.TranType as TipoTransacción,
		dbo.GLTran.RefNbr as Referencia,
		dbo.GLTran.ExtRefNbr as RefExterna,
		dbo.GLTran.TranDate as FechaTransacción,
		dbo.GLTran.TranDesc as Descripción,
		dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate as Abono,
		dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate as Cargo,
		substring( dbo.GLTran.Sub, 8, 2 ) as UnidadNegocio,
		substring( dbo.GLTran.Sub, 10, 6 ) as CentroCosto,
		dbo.SubAcct.Descr as NombreEntidad,
		dbo.GLTran.Crtd_User,
		dbo.GLTran.BatNbr
	from
		dbo.GLTran inner join dbo.Account on
		dbo.GLTran.Acct = dbo.Account.Acct inner join dbo.SubAcct on
		dbo.GLTran.Sub = dbo.SubAcct.Sub
	where
		(
			dbo.GLTran.Posted = 'P'
		)
		and(
			dbo.GLTran.PerPost > '201500'
		)
		and(
			dbo.GLTran.CpnyID = 'ATMMAC'
		)
		
	-- ============================================ Teisa ======================================== --		
		
create
	view dbo.Bon_v_transaccionesTEISA as 
	select
		case
			substring(dbo.GLTran.PerPost,5,2) 
			when '01' then 'ENERO'
			when '02' then 'FEBRERO'
			when '03' then 'MARZO'
			when '04' then 'ABRIL'
			when '05' then 'MAYO' 
			WHEN '06' then 'JUNIO'
			when '07' then 'JULIO'
			when '08' then 'AGOSTO'
			when '09' then 'SEPTIEMBRE'
			when '10' then 'OCTUBRE' 
			WHEN '11' then 'NOVIEMBRE'
			when '12' then 'DICIEMBRE'
		end as Mes,
		dbo.GLTran.PerPost,
		dbo.GLTran.Acct as NoCta,
		dbo.Account.Descr as NombreCta,
		dbo.GLTran.PerEnt,
		dbo.GLTran.CpnyID as Compañía,
		dbo.GLTran.JrnlType as Tipo,
		dbo.GLTran.Sub as Entidad,
		dbo.GLTran.TranType as TipoTransacción,
		dbo.GLTran.RefNbr as Referencia,
		dbo.GLTran.ExtRefNbr as RefExterna,
		dbo.GLTran.TranDate as FechaTransacción,
		dbo.GLTran.TranDesc as Descripción,
		dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate as Abono,
		dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate as Cargo,
		substring( dbo.GLTran.Sub, 8, 2 ) as UnidadNegocio,
		substring( dbo.GLTran.Sub, 10, 6 ) as CentroCosto,
		dbo.SubAcct.Descr,
		dbo.GLTran.Crtd_User,
		dbo.GLTran.BatNbr
	from
		dbo.GLTran inner join dbo.Account on
		dbo.GLTran.Acct = dbo.Account.Acct inner join dbo.SubAcct on
		dbo.GLTran.Sub = dbo.SubAcct.Sub
	where
		(
			dbo.GLTran.Posted = 'P'
		)
		and(
			dbo.GLTran.PerPost > '201500'
		)
		and(
			dbo.GLTran.CpnyID in('TEICUA')
		)                                                               

	-- ============================================ GST ======================================== --	
use integraapp;
IF OBJECT_ID ('Bon_v_TransaccionesGST', 'V') IS NOT NULL
    DROP VIEW Bon_v_TransaccionesGST

create
	view dbo.Bon_v_TransaccionesGST as 
	select
		case
			substring(dbo.GLTran.PerPost,5,2) 
			when '01' then 'ENERO'
			when '02' then 'FEBRERO'
			when '03' then 'MARZO'
			when '04' then 'ABRIL'
			when '05' then 'MAYO' 
			WHEN '06' then 'JUNIO'
			when '07' then 'JULIO'
			when '08' then 'AGOSTO'
			when '09' then 'SEPTIEMBRE'
			when '10' then 'OCTUBRE' 
			WHEN '11' then 'NOVIEMBRE'
			when '12' then 'DICIEMBRE'
		end as Mes,
		dbo.GLTran.PerPost,
		dbo.GLTran.Acct as NoCta,
		dbo.Account.Descr as NombreCta,
		dbo.GLTran.PerEnt,
		dbo.GLTran.CpnyID as Compañía,
		dbo.GLTran.JrnlType as Tipo,
		dbo.GLTran.Sub as Entidad,
		dbo.GLTran.TranType as TipoTransacción,
		dbo.GLTran.RefNbr as Referencia,
		dbo.GLTran.ExtRefNbr as RefExterna,
		dbo.GLTran.TranDate as FechaTransacción,
		dbo.GLTran.TranDesc as Descripción,
		dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate as Abono,
		dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate as Cargo,
		substring( dbo.GLTran.Sub, 8, 2 ) as UnidadNegocio,
		substring( dbo.GLTran.Sub, 10, 6 ) as CentroCosto,
		dbo.SubAcct.Descr as NombreEntidad,
		dbo.GLTran.Crtd_User,
		dbo.GLTran.BatNbr
	from
		dbo.GLTran inner join dbo.Account on
		dbo.GLTran.Acct = dbo.Account.Acct inner join dbo.SubAcct on
		dbo.GLTran.Sub = dbo.SubAcct.Sub
	where
		(
			dbo.GLTran.Posted = 'P'
		)
		and(
			dbo.GLTran.PerPost > '201500'
		)
		and(
			dbo.GLTran.CpnyID = 'GSTFYS'
		)
		
		-- ==================================== **** ======================== --
		
		
		
-- INSERT, UPDATE, SELECT, DELETE , EXECUTE
use integraapp
select
--	'select * from "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '" ' --+ ' TO "ambagasdowa"'
--	'REVOKE SELECT ON "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '" TO "ambagasdowa"'
  '"' + TABLE_NAME + '" '
from
	information_schema.tables
where 
	TABLE_NAME like '%ransaccion%'
-- and 
-- 	TABLE_TYPE = 'BASE TABLE'
-- 	TABLE_TYPE = 'VIEW'
	
		
	-- ============================================ Teisa ======================================== --		

	
use integraapp
IF OBJECT_ID ('Bon_v_transaccionesTCGTUL', 'V') IS NOT NULL
    DROP VIEW Bon_v_transaccionesTCGTUL
	
create
	view dbo.Bon_v_transaccionesTCGTUL as 
	select
		case
			substring(dbo.GLTran.PerPost,5,2) 
			when '01' then 'ENERO'
			when '02' then 'FEBRERO'
			when '03' then 'MARZO'
			when '04' then 'ABRIL'
			when '05' then 'MAYO' 
			WHEN '06' then 'JUNIO'
			when '07' then 'JULIO'
			when '08' then 'AGOSTO'
			when '09' then 'SEPTIEMBRE'
			when '10' then 'OCTUBRE' 
			WHEN '11' then 'NOVIEMBRE'
			when '12' then 'DICIEMBRE'
		end as Mes,
		dbo.GLTran.PerPost,
		dbo.GLTran.Acct as NoCta,
		dbo.Account.Descr as NombreCta,
		dbo.GLTran.PerEnt,
		dbo.GLTran.CpnyID as Compañía,
		dbo.GLTran.JrnlType as Tipo,
		dbo.GLTran.Sub as Entidad,
		dbo.GLTran.TranType as TipoTransacción,
		dbo.GLTran.RefNbr as Referencia,
		dbo.GLTran.ExtRefNbr as RefExterna,
		dbo.GLTran.TranDate as FechaTransacción,
		dbo.GLTran.TranDesc as Descripción,
		dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate as Abono,
		dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate as Cargo,
		substring( dbo.GLTran.Sub, 8, 2 ) as UnidadNegocio,
		substring( dbo.GLTran.Sub, 10, 6 ) as CentroCosto,
		dbo.SubAcct.Descr,
		dbo.GLTran.Crtd_User,
		dbo.GLTran.BatNbr,
		SUBSTRING(dbo.GLTran.PerPost,1,4) as 'year'
	from
		dbo.GLTran inner join dbo.Account on
		dbo.GLTran.Acct = dbo.Account.Acct inner join dbo.SubAcct on
		dbo.GLTran.Sub = dbo.SubAcct.Sub
	where
		(
			dbo.GLTran.Posted = 'P'
		)
		and(
			dbo.GLTran.PerPost > '201500'
		)
		and(
			dbo.GLTran.CpnyID in('TCGTUL')
		)                                                               

		select * from Bon_v_transaccionesTCGTUL
