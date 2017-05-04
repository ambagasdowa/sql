use sistemas

select
	SC.name as 'Field',
	ISC.DATA_TYPE as 'Type',
	ISC.CHARACTER_MAXIMUM_LENGTH as 'Length',
	SC.IS_NULLABLE as 'Null',
	I.is_primary_key as 'Key',
	SC.is_identity as 'Identity'
from
	sys.columns as SC left join sys.index_columns as IC on
	IC.object_id = OBJECT_ID('dbo.Expenses')
	and IC.column_id = SC.column_id left join sys.indexes as I on
	I.object_id = OBJECT_ID('dbo.Expenses')
	and IC.index_id = I.index_id left join information_schema.columns ISC on
	ISC.TABLE_NAME = 'Expenses'
	and ISC.COLUMN_NAME = SC.name
where
	SC.object_id = OBJECT_ID('dbo.projections_access_modules')


--select * from sistemas.dbo.projections_access_modules