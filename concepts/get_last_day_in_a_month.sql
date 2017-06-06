
DECLARE @test DATETIME
SET @test = GETDATE()  -- or any other date
SELECT DATEADD(month, ((YEAR(@test) - 1900) * 12) + MONTH(@test), -1)



select * from sistemas.dbo.generals_month_translations


-- 375 |  Mayo 21 al 31 | 2016-05-21 00:00:00 |  2016-05-31 23:59:00


select * from sistemas.dbo.casetas_iave_periods

