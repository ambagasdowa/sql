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
	select
		*
	from
		HumanResources.vEmployee
		

		
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
	
	
	
	select year(current_timestamp);
	
	
