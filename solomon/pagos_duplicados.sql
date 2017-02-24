
--- buscar canceladas de lis en ramos del mes de junio 

--declare @period nvarchar(6);
--set @period = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(current_timestamp)), 2)) ;



--select 
--		doc.CpnyID as 'Company',
--		doc.BatNbr as 'Lote',
--		doc.RefNbr as 'Referencia',
--		doc.InvcNbr as 'NumFactura',
--		doc.VendId as  'Proveedor',
--		doc.PerPost as 'PeriodoAfectacion',
--		doc.CuryOrigDocAmt as 'MontoDocumento',
--		doc.DocBal as 'SaldoDocumento',
--		(
--			select 
--				case doc.Doctype
--					when 'PP' then 'Anticipo' 
--					when 'VO' then 'Factura'
-- 					else 'N/A' end as 'Doc'
--		) as 'TipoDocumento'
		
--from 
--		integraapp.dbo.APDoc as doc
--		inner join integraapp.dbo.Batch as bat on doc.BatNbr = bat.BatNbr
--where
--		doc.DocType in ('PP','VO')
--		and 
--			bat.Status in ('U','P')
--		and 
--			doc.CuryOrigDocAmt = doc.DocBal
--		and 
--			doc.PerPost in(@period-2, @period-1 ,@period, @period+1 , @period + 2)

USE [integraapp]
GO
/****** Object:  StoredProcedure [dbo].[sp_fetchDuplicatesVOPP]    Script Date: 21/04/2016 12:54:02 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*===============================================================================
 Author         : Jesus Baizabal
 email			: Baizabal.jesus@gmail.com
 Create date    : April 20, 2015
 Description    : fetch the Duplicate Records for revision
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.9
 ===============================================================================*/
 
ALTER PROCEDURE [dbo].[sp_fetchDuplicatesVOPP] 
with encryption
as 
SET NOCOUNT ON;		


		----1232
	-- Set the table for duplicate

	declare @save_record table 
	(
		Company				nvarchar(6) collate SQL_Latin1_General_CP1_CI_AS,
		Lote				nvarchar(15) collate SQL_Latin1_General_CP1_CI_AS,
		Referencia			nvarchar(15) collate SQL_Latin1_General_CP1_CI_AS,
		NumFactura			nvarchar(14) collate SQL_Latin1_General_CP1_CI_AS,
		Proveedor			nvarchar(25) collate SQL_Latin1_General_CP1_CI_AS,
		PeriodoAfectacion	nvarchar(6) collate SQL_Latin1_General_CP1_CI_AS,
		MontoDocumento		float(2),
		SaldoDocumento		float(2),
		TipoDocumento		nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS
	);
	declare @record_duplicate table 
	(
		Company				nvarchar(6) collate SQL_Latin1_General_CP1_CI_AS,
		Lote				nvarchar(15) collate SQL_Latin1_General_CP1_CI_AS,
		Referencia			nvarchar(15) collate SQL_Latin1_General_CP1_CI_AS,
		NumFactura			nvarchar(14) collate SQL_Latin1_General_CP1_CI_AS,
		Proveedor			nvarchar(25) collate SQL_Latin1_General_CP1_CI_AS,
		PeriodoAfectacion	nvarchar(6) collate SQL_Latin1_General_CP1_CI_AS,
		MontoDocumento		float(2),
		SaldoDocumento		float(2),
		TipoDocumento		nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS
	);
	--select count(*) from @save_record
	declare @period nvarchar(6) ,@periodmone nvarchar(6),@periodmtwo nvarchar(6),@periodpone nvarchar(6),@periodptwo nvarchar(6), @counter int;
	set @period = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(current_timestamp)), 2)) ;

	--select CURRENT_TIMESTAMP
	----declare 053617 GL
	--declare @date_ datetime ; set @date_ = '2016-01-01 09:25:00.000';
	--select(CONVERT(nvarchar(4), YEAR(@date_)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -1, @date_))), 2)) 
	if MONTH(CURRENT_TIMESTAMP) = 1
		begin
			select @periodmone = (CONVERT(nvarchar(4), YEAR(DATEADD(YEAR,-1,CURRENT_TIMESTAMP))) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -1, current_timestamp))), 2)) 
			select @periodmtwo = (CONVERT(nvarchar(4), YEAR(DATEADD(YEAR,-1,CURRENT_TIMESTAMP))) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -2, current_timestamp))), 2)) 
			select @periodpone = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, +1, current_timestamp))), 2)) ;
			select @periodptwo = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, +2, current_timestamp))), 2)) ;
		end
	else if MONTH(CURRENT_TIMESTAMP) = 12
		begin
			select @periodmone = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -1, current_timestamp))), 2)) ;
			select @periodmtwo = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -2, current_timestamp))), 2)) ;
			select @periodpone = (CONVERT(nvarchar(4), YEAR(DATEADD(YEAR,+1,CURRENT_TIMESTAMP))) + right('00'+convert(varchar(2),MONTH(DATEADD(month, +1, current_timestamp))), 2)) 
			select @periodptwo = (CONVERT(nvarchar(4), YEAR(DATEADD(YEAR,+1,CURRENT_TIMESTAMP))) + right('00'+convert(varchar(2),MONTH(DATEADD(month, +2, current_timestamp))), 2)) 
		end
	else
		select @periodmone = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -1, current_timestamp))), 2)) ;
		select @periodmtwo = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, -2, current_timestamp))), 2)) ;
		select @periodpone = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, +1, current_timestamp))), 2)) ;
		select @periodptwo = (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + right('00'+convert(varchar(2),MONTH(DATEADD(month, +2, current_timestamp))), 2)) ;

	--Declare variables for cursor
	declare
		@Company			nvarchar(6),
		@Lote				nvarchar(15),
		@Referencia			nvarchar(15),
		@NumFactura			nvarchar(14),
		@Proveedor			nvarchar(25),
		@PeriodoAfectacion	nvarchar(6),
		@MontoDocumento		float(2),
		@SaldoDocumento		float(2),
		@TipoDocumento		nvarchar(10);
		SET NOCOUNT ON;  
		declare duplicate_cursor cursor for 
										(										
											  select 
														doc.CpnyID as 'Company',
														doc.BatNbr as 'Lote',
														doc.RefNbr as 'Referencia',
														doc.InvcNbr as 'NumFactura',
														doc.VendId as  'Proveedor',
														doc.PerPost as 'PeriodoAfectacion',
														doc.CuryOrigDocAmt as 'MontoDocumento',
														doc.DocBal as 'SaldoDocumento',
														(
															select 
																case doc.Doctype
																	when 'PP' then 'Anticipo' 
																	when 'VO' then 'Factura'
 																	else 'N/A' end as 'Doc'
														) as 'TipoDocumento'
		
												from 
														integraapp.dbo.APDoc as doc
														inner join integraapp.dbo.Batch as bat on doc.BatNbr = bat.BatNbr
												where
														doc.DocType in ('PP','VO')
														and 
															bat.Status in ('U','P')
														and 
															doc.CuryOrigDocAmt = doc.DocBal
														and 
															doc.PerPost in(@periodmtwo, @periodmone ,@period, @periodpone , @periodptwo)
										)
		open duplicate_cursor;
				fetch next from duplicate_cursor into 		
														@Company,
														@Lote,
														@Referencia,
														@NumFactura,
														@Proveedor,
														@PeriodoAfectacion,
														@MontoDocumento,
														@SaldoDocumento,
														@TipoDocumento;
						while @@fetch_status = 0
							begin
								--Company,Lote,Referencia,NumFactura,Proveedor,PeriodoAfectacion,MontoDocumento,SaldoDocumento,TipoDocumento
								select @counter = (select count(*) from @save_record where Company = @Company and Proveedor = @Proveedor and MontoDocumento = @MontoDocumento and TipoDocumento = @TipoDocumento)
								
								if @counter > 0 
									begin
										--if @counter = 1
										--	begin
										--		insert into @record_duplicate 
										--				select Company,Lote,Referencia,NumFactura,Proveedor,PeriodoAfectacion,MontoDocumento,SaldoDocumento,TipoDocumento
										--				from @save_record where Company = @Company and Proveedor = @Proveedor and MontoDocumento = @MontoDocumento and TipoDocumento = @TipoDocumento
										--	end

										insert into @record_duplicate select 
																			@Company,
																			@Lote,
																			@Referencia,
																			@NumFactura,
																			@Proveedor,
																			@PeriodoAfectacion,
																			@MontoDocumento,
																			@SaldoDocumento,
																			@TipoDocumento;
									end 
								else if @counter = 0
									begin
										insert into @save_record select
																			@Company,
																			@Lote,
																			@Referencia,
																			@NumFactura,
																			@Proveedor,
																			@PeriodoAfectacion,
																			@MontoDocumento,
																			@SaldoDocumento,
																			@TipoDocumento;
									end


								fetch next from duplicate_cursor into 
																		@Company,
																		@Lote,
																		@Referencia,
																		@NumFactura,
																		@Proveedor,
																		@PeriodoAfectacion,
																		@MontoDocumento,
																		@SaldoDocumento,
																		@TipoDocumento;
							end
			close duplicate_cursor;
		deallocate duplicate_cursor;


		--select * from @save_record;
--		PRINT '-------- Duplicate Vouchers Report --------'; 
		select * from @record_duplicate order by Proveedor;
go


--053617 gl


--after procedure

use integraapp;
go

IF OBJECT_ID ('view_fetchDuplicatesVOPP', 'V') IS NOT NULL
    DROP VIEW view_fetchDuplicatesVOPP;
GO

create view view_fetchDuplicatesVOPP
--with encryption
as

select
			Company,Lote,Referencia,NumFactura,Proveedor,PeriodoAfectacion,MontoDocumento,SaldoDocumento,TipoDocumento
from 
			openquery(local,'exec integraapp.dbo.sp_fetchDuplicatesVOPP')
go
-----------------------------------------------------------------------------------------------------------------------------------------------
--exec sp_fetchDuplicatesVOPP

--select * from view_fetchDuplicatesVOPP