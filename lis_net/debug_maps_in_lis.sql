

select id_ruta,* from pruebasteisa.dbo.trafico_convenio where id_convenio = 65 and id_cliente = 1637

select id_cliente,id_convenio,* from pruebasteisa.dbo.trafico_guia where num_guia = 'CU-120313'
	

-- lo que integra la ruta q:select * from pruebasteisa.dbo.trafico_ruta where id_ruta = 1106

select * from pruebasteisa.dbo.trafico_ruta_georeferencia where id_ruta = 1106

select * from pruebasteisa.dbo.trafico_ruta_caseta where id_ruta = 1106


-- tipo de ruta (fultra local foranea etc ...)
		 select * from pruebasteisa.dbo.trafico_tipo_ruta 
		 
		 
		 select * from pruebasteisa.dbo.trafico_tramo
		 
-- impresion de formato 
		 
		 select * from pruebasteisa.dbo.formato_impresion
		 
		 select * from pruebastbk.dbo.formato_impresion
		 
		 

		 
--		 insert into pruebasteisa.dbo.formato_impresion values ('8','3','imp_i_cartaportemapa.ascx','Carta Porte Mapa de Papel')
-- 		 insert into pruebastbk.dbo.formato_impresion values ('8','3','imp_i_cartaportemapa.ascx','Carta Porte Mapa de Papel')
		 
		 
		 exec sp_desc formato_impresion
		 
		 
	select * from pruebasteisa.dbo.desp_parametros
	
	select * from pruebasteisa.dbo.general_parametros where modulo = 'operaciones' and descripcion like '%ruta%'
	
	select * from pruebasteisa.dbo.trafico_ruta_caseta where id_ruta = 1106

		select * from pruebasteisa.dbo.trafico_ruta_georeferencia
	
		
--	example 
--	
select num_guia,id_convenio,id_cliente,id_area
from pruebastbk.dbo.trafico_guia 
where num_guia = 'OO-032365'

--num_guia  |id_convenio |id_cliente |id_area 
	--------|------------|-----------|--------
--OO-032365 |65          |1          |1       
		select id_ruta,* from pruebastbk.dbo.trafico_convenio where id_convenio = 65 and id_cliente = 1 and id_area = '1'
		
		select * from pruebastbk.dbo.trafico_convenio where id_convenio = 65 and id_cliente = 1 and id_area = '1'
		
		

		
		
		
		
		
		