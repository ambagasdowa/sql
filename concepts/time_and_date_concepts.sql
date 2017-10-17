
declare @reporte TABLE
    (  
    	 iniDate date 
    	,initime time
	    ,endDate date 
	    ,endtime time
    )  
INSERT INTO @reporte
    values ('2017-04-03','14:10:09','2017-04-03','18:10:09')
    
-- select iniDate,initime,endDate,endtime from @reporte

 
 select 
 		iniDate,initime,endDate,endtime,
 		(cast(iniDate as varchar(15)) +' '+cast(initime as varchar(20)))  as 'inidatetime',
 		(cast(endDate as varchar(15)) +' '+cast(endtime as varchar(20)))  as 'enddatetime'
 
 from @reporte    
    
SELECT DATEDIFF(hour,(cast(iniDate as varchar(15)) +' '+cast(initime as varchar(20))),(cast(endDate as varchar(15)) +' '+cast(endtime as varchar(20)))) AS 'Duration'  
FROM @reporte  


SELECT 
	 DATEPART(year, CURRENT_TIMESTAMP)  as 'year'
    ,DATEPART(month, CURRENT_TIMESTAMP)  as 'month'
    ,DATEPART(day, CURRENT_TIMESTAMP)  as 'dia'
    ,DATEPART(dayofyear, CURRENT_TIMESTAMP)  as 'dia del año'
    ,DATEPART(weekday, CURRENT_TIMESTAMP) as 'dia de la semana'
    ,DATEPART(week, CURRENT_TIMESTAMP) as 'semana'
    
-- SET DATEFIRST 5;  
SELECT @@DATEFIRST AS 'First Day'  
    ,DATEPART(dw, SYSDATETIME()) AS 'Today';
    
--Is an integer that indicates the first day of the week. It can be one of the following values.
--Value	First day of the week is
--1	Monday
--2	Tuesday
--3	Wednesday
--4	Thursday
--5	Friday
--6	Saturday
--7 (default, U.S. English)	Sunday

--but when firts day is seven or sunday then monday is 2
			
    
CREATE TABLE dbo.Calendar
(
  dt DATE PRIMARY KEY, -- use SMALLDATETIME if < SQL Server 2008
  IsWorkDay BIT
)

DECLARE @s DATE, @e DATE;
SELECT @s = '2000-01-01' , @e = '2029-12-31';

INSERT dbo.Calendar(dt, IsWorkDay)
  SELECT DATEADD(DAY, n-1, '2000-01-01'), 1 
  FROM
  (
    SELECT TOP (DATEDIFF(DAY, @s, @e)+1) ROW_NUMBER() 
      OVER (ORDER BY s1.[object_id])
      FROM sys.all_objects AS s1
      CROSS JOIN sys.all_objects AS s2
  ) AS x(n);

SET DATEFIRST 1;

-- weekends
UPDATE dbo.Calendar SET IsWorkDay = 0 
  WHERE DATEPART(WEEKDAY, dt) IN (6,7);

-- Christmas
UPDATE dbo.Calendar SET IsWorkDay = 0 
  WHERE MONTH(dt) = 12
  AND DAY(dt) = 25
  AND IsWorkDay = 1;

-- continue with other holidays, known company events, etc.
-- Now the query you're after is quite simple to write:

SELECT COUNT(*) FROM dbo.Calendar
  WHERE dt >= '20130110'
    AND dt <  '20130115'
    AND IsWorkDay = 1;
    
    
   -- ================================================= iso week ============================================= --
   


--down vote
--For stuff like this i tend to maintain a calendar table that also includes bank holidays etc.
--
--The script i use for this is as follows (Note that i didnt write it @ i forget where i found it)

SET DATEFIRST 1
SET NOCOUNT ON
--GO

--Create ISO week Function (thanks BOL)
CREATE FUNCTION ISOweek ( @DATE DATETIME )
RETURNS INT
AS 
    BEGIN
        DECLARE @ISOweek INT
        SET @ISOweek = DATEPART(wk, @DATE) + 1 - DATEPART(wk, CAST(DATEPART(yy, @DATE) AS CHAR(4)) + '0104')
        --Special cases: Jan 1-3 may belong to the previous year
        IF ( @ISOweek = 0 ) 
            SET @ISOweek = dbo.ISOweek(CAST(DATEPART(yy, @DATE) - 1 AS CHAR(4)) + '12' + CAST(24 + DATEPART(DAY, @DATE) AS CHAR(2))) + 1
        --Special case: Dec 29-31 may belong to the next year
        IF ( ( DATEPART(mm, @DATE) = 12 )
             AND ( ( DATEPART(dd, @DATE) - DATEPART(dw, @DATE) ) >= 28 )
           ) 
            SET @ISOweek = 1
        RETURN(@ISOweek)
    END
GO
--END ISOweek

--CREATE Easter algorithm function 
--Thanks to Rockmoose (http://www.sqlteam.com/forums/topic.asp?TOPIC_ID=45689)
CREATE FUNCTION fnDLA_GetEasterdate ( @year INT )
RETURNS CHAR(8)
AS 
    BEGIN
    -- Easter date algorithm of Delambre
        DECLARE @A INT ,
            @B INT ,
            @C INT ,
            @D INT ,
            @E INT ,
            @F INT ,
            @G INT ,
            @H INT ,
            @I INT ,
            @K INT ,
            @L INT ,
            @M INT ,
            @O INT ,
            @R INT              

        SET @A = @YEAR % 19
        SET @B = @YEAR / 100
        SET @C = @YEAR % 100
        SET @D = @B / 4
        SET @E = @B % 4
        SET @F = ( @B + 8 ) / 25
        SET @G = ( @B - @F + 1 ) / 3
        SET @H = ( 19 * @A + @B - @D - @G + 15 ) % 30
        SET @I = @C / 4
        SET @K = @C % 4
        SET @L = ( 32 + 2 * @E + 2 * @I - @H - @K ) % 7
        SET @M = ( @A + 11 * @H + 22 * @L ) / 451
        SET @O = 22 + @H + @L - 7 * @M

        IF @O > 31 
            BEGIN
                SET @R = @O - 31 + 400 + @YEAR * 10000
            END
        ELSE 
            BEGIN
                SET @R = @O + 300 + @YEAR * 10000
            END 

        RETURN @R
    END
GO
--END fnDLA_GetEasterdate

--Create the table
CREATE TABLE MyDateTable
    (
      FullDate DATETIME NOT NULL
                        CONSTRAINT PK_FullDate PRIMARY KEY CLUSTERED ,
      Period INT ,
      ISOWeek INT ,
      WorkingDay VARCHAR(1) CONSTRAINT DF_MyDateTable_WorkDay DEFAULT 'Y'
    )
GO
--End table create

--Populate table with required dates
DECLARE @DateFrom DATETIME ,
    @DateTo DATETIME ,
    @Period INT
SET @DateFrom = CONVERT(DATETIME, '20000101')
 --yyyymmdd (1st Jan 2000) amend as required
SET @DateTo = CONVERT(DATETIME, '20991231')
 --yyyymmdd (31st Dec 2099) amend as required
WHILE @DateFrom <= @DateTo 
    BEGIN
        SET @Period = CONVERT(INT, LEFT(CONVERT(VARCHAR(10), @DateFrom, 112), 6))
        INSERT  MyDateTable
                ( FullDate ,
                  Period ,
                  ISOWeek
                )
                SELECT  @DateFrom ,
                        @Period ,
                        dbo.ISOweek(@DateFrom)
        SET @DateFrom = DATEADD(dd, +1, @DateFrom)
    END
GO
--End population


/* Start of WorkingDays UPDATE */
UPDATE  MyDateTable
SET     WorkingDay = 'B' --B = Bank Holiday
--------------------------------EASTER---------------------------------------------
WHERE   FullDate = DATEADD(dd, -2, CONVERT(DATETIME, dbo.fnDLA_GetEasterdate(DATEPART(yy, FullDate)))) --Good Friday
        OR FullDate = DATEADD(dd, +1, CONVERT(DATETIME, dbo.fnDLA_GetEasterdate(DATEPART(yy, FullDate))))
 --Easter Monday
GO

UPDATE  MyDateTable
SET     WorkingDay = 'B'
--------------------------------NEW YEAR-------------------------------------------
WHERE   FullDate IN ( SELECT    MIN(FullDate)
                      FROM      MyDateTable
                      WHERE     DATEPART(mm, FullDate) = 1
                                AND DATEPART(dw, FullDate) NOT IN ( 6, 7 )
                      GROUP BY  DATEPART(yy, FullDate) )
---------------------MAY BANK HOLIDAYS(Always Monday)------------------------------
        OR FullDate IN ( SELECT MIN(FullDate)
                         FROM   MyDateTable
                         WHERE  DATEPART(mm, FullDate) = 5
                                AND DATEPART(dw, FullDate) = 1
                         GROUP BY DATEPART(yy, FullDate) )
        OR FullDate IN ( SELECT MAX(FullDate)
                         FROM   MyDateTable
                         WHERE  DATEPART(mm, FullDate) = 5
                                AND DATEPART(dw, FullDate) = 1
                         GROUP BY DATEPART(yy, FullDate) )
--------------------AUGUST BANK HOLIDAY(Always Monday)------------------------------
        OR FullDate IN ( SELECT MAX(FullDate)
                         FROM   MyDateTable
                         WHERE  DATEPART(mm, FullDate) = 8
                                AND DATEPART(dw, FullDate) = 1
                         GROUP BY DATEPART(yy, FullDate) )
--------------------XMAS(Move to next working day if on Sat/Sun)--------------------
        OR FullDate IN ( SELECT CASE WHEN DATEPART(dw, FullDate) IN ( 6, 7 ) THEN DATEADD(dd, +2, FullDate)
                                     ELSE FullDate
                                END
                         FROM   MyDateTable
                         WHERE  DATEPART(mm, FullDate) = 12
                                AND DATEPART(dd, FullDate) IN ( 25, 26 ) )
GO

---------------------------------------WEEKENDS--------------------------------------
UPDATE  MyDateTable
SET     WorkingDay = 'N'
WHERE   DATEPART(dw, FullDate) IN ( 6, 7 )
GO
/* End of WorkingDays UPDATE */

--SELECT * FROM MyDateTable ORDER BY 1
DROP FUNCTION fnDLA_GetEasterdate
DROP FUNCTION ISOweek
--DROP TABLE MyDateTable

SET NOCOUNT OFF
Once you have created the table, finding the number of working days is easy peasy:

SELECT  COUNT(FullDate) AS WorkingDays
FROM    dbo.tbl_WorkingDays
WHERE   WorkingDay = 'Y'
        AND FullDate >= CONVERT(DATETIME, '10/01/2013', 103)
        AND FullDate <  CONVERT(DATETIME, '15/01/2013', 103)
-- Note that this script includes UK bank holidays, i'm not sure what region you're in.



select * from NOM2001.dbo.getPayroll where nombre like 'carlos%'
		
---------------------------------------------------------------------------------------------------------------------------------


-- ============================ firts and last day in a month and year =============================================== --


declare @mes as int
declare @nyear as int
 set @nyear = 2017
 set @mes = 8
 
    select DATEADD(month,@mes-1,DATEADD(year,@nyear-1900,0)) as 'First' /*First*/

    select DATEADD(day,-1,DATEADD(month,@mes,DATEADD(year,@nyear-1900,0))) as 'Last' /*Last*/
    


-- how many sundays has

declare @fini as date
declare @fend as date

set @fini = '2017-08-01'
set @fend = '2017-08-18'

select (datediff(day,@fini,@fend)-DATEPART(dw,@fend)+8)/7 as 'Sundays'



-- day of month 

DECLARE @mydate DATETIME
SELECT @mydate = GETDATE()
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)),@mydate),23) ,
'Último día del mes anterior'
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)-1),@mydate),23) AS Date_Value,
'Primer día del mes corriente' AS Date_Type
UNION
SELECT CONVERT(VARCHAR(25),@mydate,23) AS Date_Value, 'Hoy' AS Date_Type
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),DATEADD(mm,1,@mydate)),23) ,
'Último día del mes corriente'
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1),DATEADD(mm,1,@mydate)),23) ,
'Primer día del mes siguiente'

