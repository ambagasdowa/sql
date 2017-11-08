use sistemas

declare @tbl as char(100)
set @tbl = 'projections_access_modules'

select
	SC.name as 'Field',
	ISC.DATA_TYPE as 'Type',
	ISC.CHARACTER_MAXIMUM_LENGTH as 'Length',
	SC.IS_NULLABLE as 'Null',
	I.is_primary_key as 'Key',
	SC.is_identity as 'Identity'
from
	sys.columns as SC left join sys.index_columns as IC on
	IC.object_id = OBJECT_ID(@tbl)
	and IC.column_id = SC.column_id left join sys.indexes as I on
	I.object_id = OBJECT_ID(@tbl)
	and IC.index_id = I.index_id left join information_schema.columns ISC on
	ISC.TABLE_NAME = @tbl
	and ISC.COLUMN_NAME = SC.name
where
	SC.object_id = OBJECT_ID(@tbl)


--select * from sistemas.dbo.projections_access_modules