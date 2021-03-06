USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[setComprasLvName]    Script Date: 12/04/2016 01:34:36 p.m. ******/
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

  ALTER FUNCTION [dbo].[setComprasLvName](
--	@year		varchar(4),
	@inventoryId		char(3),
	@level				int
--	@day		varchar(2) -- not for now
  )
  returns char(45) with encryption
  as
  BEGIN
	 declare @setInvNamae char(45), @initFlag int;
	 declare @InvTranslation table
							  (
								invNumber char(3),
								invName char(45)
							  );
	if @level = 1
		begin
	 insert into @InvTranslation
				  select '01', 'Mantenimiento Transporte'
			union select '02', 'Insumos Varios'
			union select '03', 'Mantenimiento Edificios'
			union select '04', 'Articulos de Oficina'
			union select '05', 'Servicios'
			union select '06', 'Herramientas Inventariadas'
			union select '07', 'Julio'
			union select '08', 'Activos Fijos'
			union select '09', 'Herramientas no Inventariadas'
			
			select @setInvNamae = (select invName from @InvTranslation where invNumber = @inventoryId );
		end
		
	return (@setInvNamae);
  END;
