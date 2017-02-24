-- >status original
-- conciliado
--orig date = '2016-12-12' cruazado originalmente 
--orig id = '186489'

-- conciliado
--id = 186491
-- fecha_a = 2016-12-14


-- no conciliado
-- id 186496
-- fecha_a = 2016-12-14


select * from sistemas.dbo.casetas where id ='186491'

-- update sistemas.dbo.casetas set fecha_a = '2011-12-14' where id ='186491'


select * 
from sistemas.dbo.casetas_views 
where casetas_controls_files_id = '161' 
and casetas_historical_conciliations_id = (select max(id) from sistemas.dbo.casetas_historical_conciliations as hist where hist.casetas_controls_files_id = '161')
and casetas_standings_id <> 5
