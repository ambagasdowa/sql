

show databases;
use portal_apps



-- search for DUPLICATES
with `dup` as (  
select 
		 Lote,Referencia
		,performance_facturas_id
-- 		,Folio,Empresa,ElaboracionFactura,aprobacionFactura,fechaPromesaPago,fechaPago
		,row_number() over (partition by Lote,Referencia order by Lote) as 'index'
from `portal_apps`.performance_view_facturas
)
select
		Lote,Referencia,performance_facturas_id,`index`
from 	`dup` as `duplicate`
where 
		`duplicate`.`index` > 1
group by
	
		Lote,Referencia,performance_facturas_id
		
	
		
		
select * from portal_apps.performance_view_facturas where Lote  ='075161' and Referencia = '059215'

-- select * from `portal_apps`.performance_facturas where performance_references_id = '059215'

select * from `portal_apps`.performance_facturas where id in (
1291,
1285,
1102,
1360,
1362,
1678,
1679,
1681,
1683,
1685,
1687
)
		
		

select * from `portal_apps`.performance_facturas where id in (
 1703
,1689
,1705
,1690
,1709
,1624
,1626
,1693
,1707
,1711
,1695
,1713
,1697
,1699
,1700
,1716
,1717
)
	
	update `portal_apps`.performance_facturas set status = 0 where id in (1703
,1689
,1705
,1690
,1709
,1624
,1626
,1693
,1707
,1711
,1695
,1713
,1697
,1699
,1700
,1716
,1717
-- 
,1291
,1285
,1102
,1360
,1362
,1678
,1679
,1681
,1683
,1685
,1687
)




select * from `portal_apps`.performance_view_viajes


-- search for DUPLICATES
with `dup` as (  
select 
		
		 num_guia,area,company
		,row_number() over (partition by num_guia,area,company order by num_guia) as 'index'
from `portal_apps`.performance_view_viajes
)
select
		num_guia,area,company,`index`
from 	`dup` as `duplicate`
where 
		`duplicate`.`index` > 1
group by
		num_guia,area,company


