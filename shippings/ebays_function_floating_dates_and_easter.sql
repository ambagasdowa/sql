
use sistemas;

IF OBJECT_ID ('ebays_function_floating_dates', 'TF') IS NOT NULL		
    DROP VIEW ebays_function_floating_dates;


ALTER FUNCTION ebays_function_floating_dates(@Occur INT,@WeekDay INT,@Month INT,@Year INT)

returns
SMALLDATETIME
with encryption
AS
BEGIN
	DECLARE @Result SMALLDATETIME
	DECLARE @StartDate SMALLDATETIME
	
	-- Get Starting date, which is first day of the month
	SET @StartDate = CONVERT(SmallDateTime,CAST(@Month AS VARCHAR(2))+'/1/'+CAST(@Year AS VARCHAR(4)))
	
	SET @Result = cast(str(@Month)+'/'+ str((7+ @Weekday-datepart(dw,@StartDate))%7+1) +'/'+str(@Year) AS datetime)+(@Occur-1)*7 
	
	RETURN @Result
END


-- usage
 -- select sistemas.dbo.ebays_function_floating_dates (1,2,2,2017) -- 1st monday of february battle of puebla (@Occur INT,@WeekDay INT,@Month INT,@Year INT)



---------------------------------------------------------------------------------
-- Returns a virtual table containing all holidays for a given year
---------------------------------------------------------------------------------

use sistemas;

IF OBJECT_ID ('ebays_function_easter_dates', 'TF') IS NOT NULL		
    DROP VIEW ebays_function_easter_dates;

    
ALTER FUNCTION ebays_function_easter_dates (@nYear INT)
RETURNS @Holidays TABLE
(Holiday_name VARCHAR(32),
Holiday_date SMALLDATETIME
)
with encryption
AS
BEGIN
-- Calculate Easter Sunday
DECLARE @g INT
DECLARE @c INT
DECLARE @h INT
DECLARE @i INT
DECLARE @j INT
DECLARE @l INT
DECLARE @Month INT
DECLARE @Day INT
DECLARE @Easter SMALLDATETIME
DECLARE @WorkDT SMALLDATETIME

-- Bizarre Algorithm to determine Easter Sunday
SET @g = @nYear % 19
SET @c = @nYear / 100
SET @h = ((@c - (@c / 4) - ((8 * @c + 13) / 25) + (19 * @g) + 15) % 30)
SET @i = @h - ((@h / 28) * (1 - (@h /28) * (29 / (@h + 1)) * ((21 - @g) / 11)))
SET @j = ((@nYear + (@nYear / 4) + @i + 2 - @c + (@c / 4)) % 7)
SET @l = @i - @j
SET @Month = 3 + ((@l + 40) / 44)
SET @Day = @l + 28 - (31 * (@Month / 4))
SET @Easter = CAST(@Month AS VARCHAR(2)) + '/' + CAST(@Day As VARCHAR(2)) + '/' + CAST(@nYear AS VARCHAR(4))

------------------------------------------------------------------------------------------------
-- Add Easter Sunday to holiday list, and get holidays based around Easter
--INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Easter',@Easter) -- Pascua
-- Good Friday
INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Good Friday',DateAdd(d,-2,@Easter)) -- viernes santo
-- Mardi Gras
INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Mardi Gras Saturday',DateAdd(d,-1,@Easter)) -- Sabado de Gloria
-- Palm Sunday
--INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Palm Sunday',DateAdd(ww,-1,@Easter)) -- Domingo de ramos
-------------------------------------------------------------------------------------------------

-- Fixed date holidays are loaded next
INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('New Years Day',CONVERT(SmallDateTime,'1/1/'+CAST(@nYear AS VARCHAR(4))))
INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Labour Day',CONVERT(SmallDateTime,'5/1/'+CAST(@nYear AS VARCHAR(4))))
INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Independence Day',CONVERT(SmallDateTime,'9/16/'+CAST(@nYear AS VARCHAR(4))))
INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Christmas',CONVERT(SmallDateTime,'12/25/'+CAST(@nYear AS VARCHAR(4))))
INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('All Souls Day',CONVERT(SmallDateTime,'11/2/'+CAST(@nYear AS VARCHAR(4))))

-- Holidays that full on the same day of the week (based on the year they were officially established)
IF @nYear>=1983 INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Battle of Puebla',sistemas.dbo.ebays_function_floating_dates(1,2,2,@nYear)) -- 1st Monday in Febraury
IF @nYear>=1983 INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Juarez Birthday',sistemas.dbo.ebays_function_floating_dates(3,2,3,@nYear)) -- 3rd Monday in March
IF @nYear>=1983 INSERT INTO @Holidays (Holiday_name,Holiday_date) VALUES ('Mexican Revolution',sistemas.dbo.ebays_function_floating_dates(3,2,11,@nYear)) -- 3rd Monday in November

RETURN
end



