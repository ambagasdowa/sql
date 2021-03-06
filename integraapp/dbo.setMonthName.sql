USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[setMonthName]    Script Date: 12/04/2016 01:35:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 20, 2015
 Description    : function that returns a month_name getting a numerical month as 
                : parameter , is still have some comprobations incomplete but works 
 Database owner : bonampak s.a de c.v 
 ===============================================================================*/

  ALTER FUNCTION [dbo].[setMonthName](
--	@year		varchar(4),
	@month		varchar(2)
--	@day		varchar(2) -- not for now
  )
  returns varchar(20) with encryption
  as
  BEGIN
	 declare @setMonthNamae varchar(20), @initFlag int;
	 declare @MonthsTranslation table
							  (
								monthNumber varchar(2),
								monthName varchar(20)
							  );
	 insert into @MonthsTranslation
			select '01', 'Enero'
			union select '02', 'Febrero'
			union select '03', 'Marzo'
			union select '04', 'Abril'
			union select '05', 'Mayo'
			union select '06', 'Junio'
			union select '07', 'Julio'
			union select '08', 'Agosto'
			union select '09', 'Septiembre'
			union select '10', 'Octubre'
			union select '11', 'Noviembre'
			union select '12', 'Diciembre'

		select @setMonthNamae = (select monthName from @MonthsTranslation where monthNumber = @month );

		return (@setMonthNamae);
  END;
