use sistemas

declare @search_term as nvarchar(200)
set @search_term = 'projections_'

select 
	TABLE_NAME, TABLE_TYPE, TABLE_CATALOG
from
	INFORMATION_SCHEMA.TABLES
where
	TABLE_NAME like '%'+ @search_term +'%'
order by
	TABLE_TYPE
