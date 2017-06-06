-- TEST
select * from sistemas.dbo.bon_view_anticipos_conv_gtos

-- =============================================================================================================== --
-- 								another View
-- =============================================================================================================== --

use sistemas;

IF OBJECT_ID ('bon_view_anticipos_conv_gtos', 'V') IS NOT NULL
	DROP VIEW bon_view_anticipos_conv_gtos;

create view bon_view_anticipos_conv_gtos
	as
	select 
			*
	from openquery(local,'sistemas.dbo.sp_bon_view_anticipos_conv_gto')


-- =============================================================================================================== --
-- 								Store
-- =============================================================================================================== --
USE sistemas;

/*===============================================================================
 Author         : Javir Garcia (ah perro!!, su primer sprite)
 email			: fcojaviergv@gmail.com
 Create date    : September 09, 2017
 Description    : Quering some kind of report for something ???
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.2
 ===============================================================================*/
 
ALTER PROCEDURE sp_bon_view_anticipos_conv_gto
 with encryption
 as 
 	SET NOCOUNT ON
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

set datefirst 5

select 
			'1' as "id_company"
			,UdN
			,id_area 
			,no_viaje 
			,"Monto Anticipo"
			,desc_ruta                                
			,"Monto en Liq" 
			,no_liquidacion 
			,fecha_liquidacion   
			,"Monto Convenio" 
			,"Diferencia Anticipo"
			,datepart(week,fecha_liquidacion) as 'liq_week'
from 
			bonampakdb.dbo.bon_view_anticipos_conv_gto
union all
select 
			'2' as "id_company"
			,UdN
			,id_area 
			,no_viaje 
			,"Monto Anticipo"
			,desc_ruta                                
			,"Monto en Liq" 
			,no_liquidacion 
			,fecha_liquidacion   
			,"Monto Convenio" 
			,"Diferencia Anticipo"
			,datepart(week,fecha_liquidacion) as 'liq_week'
from 
			macuspanadb.dbo.atm_view_anticipos_conv_gto
union all
select 
			'3' as "id_company"
			,UdN
			,id_area 
			,no_viaje 
			,"Monto Anticipo"
			,desc_ruta                                
			,"Monto en Liq" 
			,no_liquidacion 
			,fecha_liquidacion   
			,"Monto Convenio" 
			,"Diferencia Anticipo"
			,datepart(week,fecha_liquidacion) as 'liq_week'
from 
			tespecializadadb.dbo.tei_view_anticipos_conv_gto
