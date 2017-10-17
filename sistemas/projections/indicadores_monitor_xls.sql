-- Orizaba

select 
		sum(Tonelaje) as 'tonelaje' , sum(subtotal) as 'subtotal', fraccion 
from 
		"bonampakdb"."dbo"."Bon_v_IndOperativosOZ"
where 
		Area = 'Orizaba' and Año = '2017' and Mes = 'MAYO'
group by
		fraccion
		
		
select 
		 sum(kms_viaje) as 'kmsviaje'
		,sum(kms_real) as 'kmsreal'
		,sum(subtotal) as 'total'
		,sum(peso) as 'peso'
		,fraccion
from sistemas.dbo.projections_view_full_company_dispatched_indicators
where year(f_despachado) = '2017' and mes = 'Mayo' and company = '1' and id_area = '1' group by fraccion

-- Macuspana

select 
		sum(Tonelaje) as 'tonelaje' , sum(subtotal) as 'subtotal', fraccion
from 
			"macuspanadb"."dbo"."v_IndicadoresOperativos"
where 
		 Año = '2017' and Mes = 'MAYO'
group by
		fraccion

select 
		 sum(kms_viaje) as 'kmsviaje'
		,sum(kms_real) as 'kmsreal'
		,sum(subtotal) as 'total'
		,sum(peso) as 'peso'
		,fraccion
from sistemas.dbo.projections_view_full_company_dispatched_indicators
where year(f_despachado) = '2017' and mes = 'Mayo' and company = '2' and id_area = '1' group by fraccion
		

-- Ramos

select 
		sum(Tonelaje) as 'tonelaje' , sum(subtotal) as 'subtotal', fraccion
from 
			"bonampakdb"."dbo"."Bon_v_IndOperativosRA"
where 
		 Año = '2017' and Mes = 'JUNIO'
group by
		fraccion

select 
		 sum(kms_viaje) as 'kmsviaje'
		,sum(kms_real) as 'kmsreal'
		,sum(subtotal) as 'total'
		,sum(peso) as 'peso'
		,fraccion
from sistemas.dbo.projections_view_full_company_dispatched_indicators
where year(f_despachado) = '2017' and mes = 'Junio' and company = '1' and id_area = '3' group by fraccion
	


select * from sistemas.dbo.projections_view_full_company_dispatched_indicators 
	where id_area = '3' and company = '1' and no_viaje = '59682'

select * from bonampakdb.dbo.trafico_guia where 







