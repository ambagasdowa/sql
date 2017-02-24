CREATE
	VIEW dbo.Bon_v_TransaccionesTodoTultitlan AS 
	
	SELECT
		CASE
			substring(dbo.GLTran.PerPost,5,2)
			WHEN '01' THEN 'ENERO'
			WHEN '02' THEN 'FEBRERO'
			WHEN '03' THEN 'MARZO'
			WHEN '04' THEN 'ABRIL'
			WHEN '05' THEN 'MAYO'
			WHEN '06' THEN 'JUNIO'
			WHEN '07' THEN 'JULIO'
			WHEN '08' THEN 'AGOSTO'
			WHEN '09' THEN 'SEPTIEMBRE'
			WHEN '10' THEN 'OCTUBRE'
			WHEN '11' THEN 'NOVIEMBRE'
			WHEN '12' THEN 'DICIEMBRE'
		END AS Mes,
		dbo.GLTran.PerPost,
		dbo.GLTran.Acct AS NoCta,
		dbo.Account.Descr AS NombreCta,
		dbo.GLTran.PerEnt,
		dbo.GLTran.CpnyID AS Compañía,
		dbo.GLTran.JrnlType AS Tipo,
		dbo.GLTran.Sub AS Entidad,
		CASE
			(
				SUBSTRING( dbo.GLTran.Sub, 1, 1 )
			)
			WHEN 'A' THEN 'BALANCE'
			WHEN 'C' THEN 'BALANCE'
			WHEN 'B' THEN 'BALANCE'
			WHEN 'F' THEN 'BALANCE'
			WHEN 0 THEN 'GRANEL'
			WHEN 8 THEN 'TERCEROS'
			WHEN 7 THEN 'ENVASADO'
			ELSE 'BALANCE'
		END AS linea_negocio,
		dbo.GLTran.TranType AS TipoTransacción,
		dbo.GLTran.RefNbr AS Referencia,
		dbo.GLTran.ExtRefNbr AS RefExterna,
		dbo.GLTran.TranDate AS FechaTransacción,
		dbo.GLTran.TranDesc AS Descripción,
		dbo.GLTran.CuryCrAmt * dbo.GLTran.CuryRate AS Abono,
		dbo.GLTran.CuryDrAmt * dbo.GLTran.CuryRate AS Cargo,
		SUBSTRING( dbo.GLTran.Sub, 8, 2 ) AS UnidadNegocio,
		SUBSTRING( dbo.GLTran.Sub, 10, 6 ) AS CentroCosto,
		dbo.SubAcct.Descr,
		dbo.GLTran.Crtd_User,
		dbo.GLTran.BatNbr
	FROM
		dbo.GLTran
	INNER JOIN dbo.Account ON
		dbo.GLTran.Acct = dbo.Account.Acct
	INNER JOIN dbo.SubAcct ON
		dbo.GLTran.Sub = dbo.SubAcct.Sub
	WHERE
		(
			dbo.GLTran.Posted = 'P'
		)
		AND(
			dbo.GLTran.PerPost > '201600'
		)
		AND(
			dbo.GLTran.CpnyID IN(
				'TCGTUL'
			)
		)
