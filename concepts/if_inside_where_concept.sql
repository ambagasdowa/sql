
set nocount on

	declare	  @FirstTable table
								(
									RandomInteger int
								) 
	
  declare @SecondTable table
								(
									RandomInteger int
								) 
  declare @WhenWeStarted datetime
  declare @ii int  
  
  begin  
	  
	transaction
		set @ii = 0 
		
			while @ii < 100000   
				begin     
					INSERT  into @FirstTable VALUES (rand()* 10000)    
					set @ii = @ii + 1  
		   		end
		   		
			set @ii = 0 
			
			while @ii < 100000   
				begin    
					INSERT  into @SecondTable VALUES ( rand()* 10000 )    
					set @ii = @ii + 1
				end 
	commit transaction SELECT  @WhenWeStarted = GETDATE()

	set statistics PROFILE on
								SELECT 
										count(*) FROM @FirstTable as "first"
				      				inner join 
										@SecondTable as  "second" 
									on
									"first".RandomInteger = "second".RandomInteger option(RECOMPILE)   -- 153Ms  as opposed to 653Ms without the hint
	set statistics PROFILE off 
								SELECT  'That took ' + convert( varchar(8), DATEDIFF( ms, @WhenWeStarted,GETDATE() ) )+ ' ms'
								
								
-- ==================================================================================================== --

	declare @mode as int 
	
	set @mode = 8
								
   select * from sistemas.dbo.projections_bsu_presupuestos as bsu
				
		where 
					(
						1 = (
						case 
							when @mode = 8 -- when mode is equal then omit this and use the next case else use the limit defined in the or clause
									then 1
								else 0
							end
					    )
					    or 
						    bsu.id_area = 5
					 )

				
-- ==================================================================================================== --
					 
					 











