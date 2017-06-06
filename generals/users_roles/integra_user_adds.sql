--SETTING PERMISIONS to THE view "sistemas"."dbo"."v_DieselContraloriaGST" to user integra


use macuspanadb

SELECT
		name,"type"
		,case "type"
			when	'P' 	then 	'Stored Procedures'
			when	'FN' 	then	'Scalar Functions'
			when	'IF'	then 	'Inline Table-Value Functions'
			when	'TF'	then	'Table-Value Functions'
			when	'TF'	then	'Tigger Functions'
			when	'U'		then	'Base Table'
			when	'V'		then	'View'
		end as 'Types'
FROM
	dbo.sysobjects
WHERE
	"type" IN
		(
		'P', -- stored procedures
		'FN', -- scalar functions
		'IF', -- inline table-valued functions
		'TF', -- table-valued functions
		'TR', -- tigerUppercut
		'U',
		'V'
		)
	and 
		name like '%contraloria%'
ORDER BY "type", name

-- setting permissions on integra user out of the scope

use sistemas
exec sp_helptext v_DieselContraloriaGST

use bonampakdb
exec sp_helptext Bon_v_dieselContraloria

use macuspanadb
exec sp_helptext Atm_v_dieselContraloria

select * from macuspanadb.dbo.Atm_v_DieselContraloria


use tespecializadadb
exec sp_helptext TEI_v_dieselContraloria


-- add user integra to role projections
--use macuspanadb
--use bonampakdb
--use tespecializadadb
exec sp_addrolemember 'projections' , 'integra'

-- set access to the view
GRANT SELECT ON "sistemas"."dbo"."v_DieselContraloriaGST" to "projections"

-- set permissions inherits of the view 
use bonampakdb
GRANT SELECT ON "bonampakdb"."dbo"."Bon_v_dieselContraloria" to "projections"
GRANT SELECT ON "bonampakdb"."dbo"."trafico_proveedor" to "projections"
GRANT SELECT ON "bonampakdb"."dbo"."trafico_comb_fact" to "projections"
use macuspanadb
GRANT SELECT ON "macuspanadb"."dbo"."Atm_v_DieselContraloria" to "projections"
GRANT SELECT ON "macuspanadb"."dbo"."trafico_proveedor" to "projections"
GRANT SELECT ON "macuspanadb"."dbo"."trafico_comb_fact" to "projections"
use tespecializadadb
GRANT SELECT ON "tespecializadadb"."dbo"."TEI_v_dieselContraloria" to "projections"
GRANT SELECT ON "tespecializadadb"."dbo"."trafico_proveedor" to "projections"
GRANT SELECT ON "tespecializadadb"."dbo"."trafico_comb_fact" to "projections"


