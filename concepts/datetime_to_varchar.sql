-- From @Stack Overflow 
-- How to convert DateTime to VarChar

-- Here's some test sql for all the styles. Make nvarchar(max) shorter to trim (e.g. nvarchar(10)) . 


-- cambiar el año de un registro manteniendo el mes , dia y hora

declare @ColumnDate as datetime
set @ColumnDate = GETDATE();
select 
			'2027'+right(convert(nvarchar(MAX), @ColumnDate, 20),len(convert(nvarchar(MAX), @ColumnDate, 20))-4) as 'edited_time' 
			,@ColumnDate as 'time_current'

		
DECLARE @now datetime
SET @now = GETDATE()
select convert(nvarchar(MAX), @now, 0) as output, 0 as style 
union select convert(nvarchar(MAX), @now, 1), 1
union select convert(nvarchar(MAX), @now, 2), 2
union select convert(nvarchar(MAX), @now, 3), 3
union select convert(nvarchar(MAX), @now, 4), 4
union select convert(nvarchar(MAX), @now, 5), 5
union select convert(nvarchar(MAX), @now, 6), 6
union select convert(nvarchar(MAX), @now, 7), 7
union select convert(nvarchar(MAX), @now, 8), 8
union select convert(nvarchar(MAX), @now, 9), 9
union select convert(nvarchar(MAX), @now, 10), 10
union select convert(nvarchar(MAX), @now, 11), 11
union select convert(nvarchar(MAX), @now, 12), 12
union select convert(nvarchar(MAX), @now, 13), 13
union select convert(nvarchar(MAX), @now, 14), 14
--15 to 19 not valid
union select convert(nvarchar(MAX), @now, 20), 20
union select convert(nvarchar(MAX), @now, 21), 21
union select convert(nvarchar(MAX), @now, 22), 22
union select convert(nvarchar(MAX), @now, 23), 23
union select convert(nvarchar(MAX), @now, 24), 24
union select convert(nvarchar(MAX), @now, 25), 25
--26 to 99 not valid
union select convert(nvarchar(MAX), @now, 100), 100
union select convert(nvarchar(MAX), @now, 101), 101
union select convert(nvarchar(MAX), @now, 102), 102
union select convert(nvarchar(MAX), @now, 103), 103
union select convert(nvarchar(MAX), @now, 104), 104
union select convert(nvarchar(MAX), @now, 105), 105
union select convert(nvarchar(MAX), @now, 106), 106
union select convert(nvarchar(MAX), @now, 107), 107
union select convert(nvarchar(MAX), @now, 108), 108
union select convert(nvarchar(MAX), @now, 109), 109
union select convert(nvarchar(MAX), @now, 110), 110
union select convert(nvarchar(MAX), @now, 111), 111
union select convert(nvarchar(MAX), @now, 112), 112
union select convert(nvarchar(MAX), @now, 113), 113
union select convert(nvarchar(MAX), @now, 114), 114
union select convert(nvarchar(MAX), @now, 120), 120
union select convert(nvarchar(MAX), @now, 121), 121
--122 to 125 not valid
union select convert(nvarchar(MAX), @now, 126), 126
union select convert(nvarchar(MAX), @now, 127), 127
--128, 129 not valid
union select convert(nvarchar(MAX), @now, 130), 130
union select convert(nvarchar(MAX), @now, 131), 131
--132 not valid
order BY style