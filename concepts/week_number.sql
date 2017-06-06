--Expanding on @Tomalak's answer. The formula works for days other than Sunday and Monday but you need to use different values for where the 5 is. A way to arrive at the value you need is
--
--Value Needed = 7 - (Value From Date First Documentation for Desired Day Of Week) - 1
--
--here is a link to the document: https://msdn.microsoft.com/en-us/library/ms181598.aspx
--
--And here is a table that lays it out for you.
--
--          | DATEFIRST VALUE |   Formula Value   |   7 - DATEFIRSTVALUE - 1
--Monday    | 1               |          5        |   7 - 1- 1 = 5
--Tuesday   | 2               |          4        |   7 - 2 - 1 = 4
--Wednesday | 3               |          3        |   7 - 3 - 1 = 3
--Thursday  | 4               |          2        |   7 - 4 - 1 = 2
--Friday    | 5               |          1        |   7 - 5 - 1 = 1
--Saturday  | 6               |          0        |   7 - 6 - 1 = 0
--Sunday    | 7               |         -1        |   7 - 7 - 1 = -1
--
--But you don't have to remember that table and just the formula, and actually you could use a slightly different one too the main need is to use a value that will make the remainder the correct number of days.
--
--Here is a working example:

DECLARE @MondayDateFirstValue INT = 1
DECLARE @FridayDateFirstValue INT = 5
DECLARE @TestDate DATE = GETDATE()

SET @MondayDateFirstValue = 7 - @MondayDateFirstValue - 1
SET @FridayDateFirstValue = 7 - @FridayDateFirstValue - 1


SET DATEFIRST 5 -- notice this is friday
   SELECT @@DATEFIRST AS 'First Day',DATEPART(dw, SYSDATETIME()) AS 'Today' , datepart(week,SYSDATETIME()) as 'wk_num'

SELECT 
    DATEADD(DAY, 0 - (@@DATEFIRST + @MondayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate)  as MondayStartOfWeek
    ,DATEADD(DAY, 6 - (@@DATEFIRST + @MondayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate) as MondayEndOfWeek
   ,DATEADD(DAY, 0 - (@@DATEFIRST + @FridayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate)  as FridayStartOfWeek
    ,DATEADD(DAY, 6 - (@@DATEFIRST + @FridayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate) as FridayEndOfWeek


SET DATEFIRST 6 -- notice this is saturday
   SELECT @@DATEFIRST AS 'First Day',DATEPART(dw, SYSDATETIME()) AS 'Today' , datepart(week,SYSDATETIME()) as 'wk_num'

SELECT 
    DATEADD(DAY, 0 - (@@DATEFIRST + @MondayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate)  as MondayStartOfWeek
    ,DATEADD(DAY, 6 - (@@DATEFIRST + @MondayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate) as MondayEndOfWeek
   ,DATEADD(DAY, 0 - (@@DATEFIRST + @FridayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate)  as FridayStartOfWeek
    ,DATEADD(DAY, 6 - (@@DATEFIRST + @FridayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate) as FridayEndOfWeek


SET DATEFIRST 2 --notice this is tuesday
   SELECT @@DATEFIRST AS 'First Day',DATEPART(dw, SYSDATETIME()) AS 'Today' , datepart(week,SYSDATETIME()) as 'wk_num'
SELECT 
    DATEADD(DAY, 0 - (@@DATEFIRST + @MondayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate)  as MondayStartOfWeek
    ,DATEADD(DAY, 6 - (@@DATEFIRST + @MondayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate) as MondayEndOfWeek
   ,DATEADD(DAY, 0 - (@@DATEFIRST + @FridayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate)  as FridayStartOfWeek
    ,DATEADD(DAY, 6 - (@@DATEFIRST + @FridayDateFirstValue + DATEPART(dw,@TestDate)) % 7, @TestDate) as FridayEndOfWeek

--This method would be agnostic of the DATEFIRST Setting which is what I needed as I am building out a date dimension with multiple week methods included.

   SET DATEFIRST 7
   SELECT @@DATEFIRST AS 'First Day',DATEPART(dw, SYSDATETIME()) AS 'Today' , datepart(week,SYSDATETIME()) as 'wk_num'
   
   
--use DATEDIFF like this: 
select DATEDIFF(wk,GETDATE(),GETDATE()+7) 
--to find the number of weeks between two days

--The ISO Year can also be calculated:
 select  YEAR(DATEADD(DAY, (4 - DATEPART(WEEKDAY, GETDATE())), getdate()))
-- Which handles the first day of year in week of previous calendar year
 
 
 
--since '1/1/1900' was a monday,
Declare @MondayNum int
Set @MondayNum=2 --Week Starts Sunday

Select 
	isnull(nullif((datediff(dy,'1/1/1900',getdate())+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+1)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+2)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+3)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+4)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+5)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+6)+@MondayNum)%7,0),7)


Set @MondayNum=1 --Week Starts Monday

Select 
	isnull(nullif((datediff(dy,'1/1/1900',getdate())+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+1)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+2)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+3)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+4)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+5)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+6)+@MondayNum)%7,0),7)

Set @MondayNum=4 --Week Starts Friday

Select 
	isnull(nullif((datediff(dy,'1/1/1900',getdate())+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+1)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+2)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+3)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+4)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+5)+@MondayNum)%7,0),7),
	isnull(nullif((datediff(dy,'1/1/1900',getdate()+6)+@MondayNum)%7,0),7)

	
	select datepart(iso_week, getdate())
	set datefirst 7
	select datepart(week,CURRENT_TIMESTAMP)
	set datefirst 5
	select datepart(week,CURRENT_TIMESTAMP)
	
	select (DATEPART(dw, @firstOfYear)
-- Here's a little snippet that should do what you need.
	
               DECLARE @firstOfYear DATETIME
               SET @firstOfYear = STR(Year(GETDATE()), 4)+'-01-01 00:00:00'
               SELECT DATEDIFF(ww, @firstOfYear - ((DATEPART(dw, @firstOfYear) + 5) % 7), GETDATE()) as 'wk', @firstOfYear as '@firstOfYear'
               
               select ((DATEPART(dw, (STR(Year(GETDATE()), 4)+'-01-01 00:00:00')) + 5) % 7)

               select datepad
               
--   Keep in mind that if you want to set the week start to on a different day, just change the +5 to the value based on 7 - dw. This is for MSSQL.
--   This works by getting the first day of the year and finding the day of the starting week on or before that day. Then we get the number of weeks
--   between whatever date was passed in and that "first" week start. If you want to allow any date to be passed in, just replace all GETDATE calls
--   with your parameter and you should be good to go. If you need a single select statement:

               SELECT
                   DATEDIFF(ww, day1 - ((DATEPART(dw, day1) +5) % 7), GETDATE())
               FROM
                   (SELECT CAST(STR(Year(GETDATE()), 4)+'-01-01 00:00:00' AS DATETIME) day1) as 'd'

--SELECT YEAR('2010-07-20T01:01:01.1234');
                   
                   
                  