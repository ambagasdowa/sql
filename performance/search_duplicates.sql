-- search for DUPLICATES
with recursive `dup` as (  
select 
		Lote,Referencia
		-- ,row_number() over(partition by Lote,Referencia, order by Lote) as 'index'
from `portal_apps`.performance_view_facturas
)
select * from `dup` where `index` > 1


SELECT
    Lote,
    Referencia,
	Empresa,    
    @currentRow := @currentRow + 1 AS rowNumber
FROM `portal_apps`.performance_view_facturas
JOIN (SELECT @currentRow := 0) row

with recursive dup as (
SELECT
    @row_number:=CASE
        WHEN @customer_no = Referencia THEN @row_number + 1
        ELSE 1
    END AS num,
    @customer_no:=Referencia as RefNum,
    performance_facturas_id,
    Lote,
    Referencia,
    Empresa
FROM
    `portal_apps`.performance_view_facturas
where 
	performance_facturas_id is not null
)
select * from dup where num > 1

 	

-- 060876
-- 060877
-- 060878
-- 060926
-- 060933

-- search 058324 	074193

-- batch => 059195 , refer => 059195

select * from `portal_apps`.performance_view_facturas where Lote = '075141' and Referencia = '059195' -- and Empresa = 'TBKORI'

select * from `portal_apps`.performance_facturas where performance_references_id = '060568'




select * from `portal_apps`.performance_facturas where id  	in (
			'674' ,'676' -- '673'
			,'679' 
			,'3' ,'4'
			,'611' ,'638' ,'526' ,'614' ,'619' ,'630' ,'635' ,'644' ,'646' ,'177' ,'713' ,'717' ,'718' ,'135' ,'715')


	
			
-- =================== Viajes ================================ --

select * from portal_apps.performance_trips where num_guia = 'OO-048040'

select * from portal_apps.performance_viajes where performance_num_guia_id = 'OO-048040'

select * from portal_apps.performance_view_viajes where num_guia = 'OO-048040'
			
			
			
			
select * from 
-- update 
portal_apps.performance_viajes where id in (53,54,55,56,57,58,62)


select * from portal_apps.performance_view_viajes
where internal_id in (53,54,55,56,57,58,62)


			
			
SELECT
    @row_number:=CASE
        WHEN @customer_no = no_guia THEN @row_number + 1
        ELSE 1
    END AS num,
    @customer_no:=no_guia as NoGuia,
    internal_id,
    num_guia,
    no_viaje,
    id_area,
    company
FROM
    `portal_apps`.performance_view_viajes
where 
	internal_id is not null
	
	
	
	select * from portal_apps.performance_facturas
	
	select * from portal_apps.performance_viajes
	
	
	
	
	
	
	
	
	
