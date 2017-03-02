-- Set 
use AdventureWorks2012 --DROP PROCEDURE Usp_sample
--GO
create
	procedure 
			Usp_sample @City nvarchar(30),
			@CountryRegionName nvarchar(50) 
	as 
	select
		*
	from
		HumanResources.vEmployee
	where
		(
			1 = (
				case
					when @City is null 
						then 1
					else 0
				end
			)
			or [City] = @City
		)
		and(
			1 =(
				case
					when @CountryRegionName is null 
						then 1
					else 0
				end
			)
			or [CountryRegionName] = @CountryRegionName
		)
	

		
-- EXEC Usp_sample @City=NULL,@CountryRegionName=null

-- EXEC Usp_sample @City='Renton',@CountryRegionName=null

declare @City as varchar(50) 

select
	BusinessEntityID,
	FirstName,
	LastName,
	City
from
	[HumanResources].[vEmployee]
where
	City =	(
				case
					when @City is null then 'Renton'
					else @City
				end
			)
order by
	BusinessEntityID
	
	
	
-- ========================== working example ====================== --	
	select * from Production.Product --504
	
	select * from Production.Product where year(SellStartDate) = '2006' and month(SellStartDate) = '06' --211

	select * from Production.Product where SellStartDate between '2005-02-01' and '2005-09-01' --72

	
	declare @mode as int ,@cyear as int , @cmonth as int
	set @mode = 8 -- set to 0 or 8
	set @cyear = '2007'
	set @cmonth = '07'

	select * from
		Production.Product
	where 
			(
				1 = (
				case 
					when @mode = 8
							then 1
						else 0
					end
			    )
			    or 
				    year(SellStartDate) = @cyear
			 )
		and
			(
				1 = (
				case 
					when @mode = 8
							then 1
						else 0
					end
			    )
			    or 
				    month(SellStartDate) = @cmonth
			 )
		and
			(
				1 = (
				case 
					when @mode != 8
							then 1
						else 0
					end
			    )
			    or 
				    SellStartDate between '2005-02-01' and '2005-09-01'
			 )

	
	
select dateadd(month,-3,cast((current_timestamp) as date))

select dateadd(month,1,cast((current_timestamp) as date))


(select DateName( month , DateAdd( month , cast('01' as int), -1 ) ) from sistemas.dbo.fnSplit(@month, '|'))
			 
			 