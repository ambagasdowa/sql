-- ==================================================================================================================== --	
-- ================================= Xwar mechanism for update a table   ====================================== --
-- ==================================================================================================================== --

/*===============================================================================
 Author : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date: November 30, 2017
 Description: A Auxiliar table for update mechanism on xwar-table
 TODO			: clean
 @Last_patch	: --
 @license   : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status: Stable
 @version		: 1.0.0
 ===============================================================================*/


-- ==================================================================================================================== --	
-- ====================================== 	  auxiliar table  		 ========================================== --
-- ==================================================================================================================== --

-- Maintenance issues : just truncate the table 

use sltestapp

IF OBJECT_ID('xwar_auxiliar_tables', 'U') IS NOT NULL 
  DROP TABLE xwar_auxiliar_tables; 

set ansi_nulls on
set quoted_identifier on
set ansi_padding on
 
create table xwar_auxiliar_tables
	(
			id									bigint identity(1,1) primary key,
			BatNbr								nvarchar(10) 	collate	sql_latin1_general_cp1_ci_as,
			RefNbr								nvarchar(10) 	collate	sql_latin1_general_cp1_ci_as,
			CpnyId								nvarchar(10) 	collate	sql_latin1_general_cp1_ci_as,
			LineNbr								smallint not null,
--			CuryTranAmt							float not null,
--			Qty									float not null,
--			UnitPrice							float not null,
			created								datetime default current_timestamp,
			modified							datetime default current_timestamp,
			_status								tinyint default 1 null
	) on [primary]
set ansi_padding off

-- select * from sltestapp.dbo.xwar_auxiliar_tables
-- truncate table sltestapp.dbo.xwar_auxiliar_tables
--	select * from sltestapp.dbo.XGRWARTrans
	use sltestapp
	exec sp_desc ARTran
-- >>>>
-- ==================================================================================================================== --	
-- ====================================== 	  catch to aux  		 ========================================== --
-- ==================================================================================================================== --
use sltestapp

alter trigger towar_insert
ON sltestapp.dbo.XGRWARTrans
after insert
as 
begin
		-- Catch the rows for examination
	set nocount on
	insert into sltestapp.dbo.xwar_auxiliar_tables
		select "i".BatNbr,"i".RefNbr ,"i".CpnyId,"i".LineNbr,current_timestamp,current_timestamp,'' from inserted as "i"
end

-- > 
-- ==================================================================================================================== --	
-- ====================================== 	  check and update xwar  ========================================== --
-- ==================================================================================================================== --
use sltestapp
alter trigger toupd_xwar
on sltestapp.dbo.xwar_auxiliar_tables
--
after insert
as 
begin
	set nocount on
	
	declare @bat nvarchar(10),@rfr nvarchar(10) , @cpnid nvarchar(10) , @is_user nvarchar(25);
	declare @iva decimal(12,2) , @retencion decimal(12,2) , @monto decimal(16,8);
-- catch the last values in the insertion
	select @bat = "xwar".BatNbr, @rfr = "xwar".RefNbr , @cpnid = "xwar".CpnyId from inserted as "xwar"
-- search if this values has correspondences in ardoc

-- ===========================  change if needed  ==================================== --
-- check if this rows comes from automatic an proccess
	select @is_user = User2 from sltestapp.dbo.Ardoc as "doc" where "doc".BatNbr = @bat and "doc".RefNbr = @rfr and "doc".CpnyId = @cpnid
-- ===========================  change if needed  ==================================== --

-- if automatic is true then go to update else nothing to do 
	if @is_user = 'LIS'
	begin
		update 
			sltestapp.dbo.XGRWARTrans
			set SATProductId = '78101802' , SATUnitId = 'E48'
		from 
			inserted as "in"
		inner join 
			sltestapp.dbo.XGRWARTrans as "xwr" 
		on 
			"xwr".BatNbr = "in".BatNbr and "xwr".RefNbr = "in".RefNbr and "xwr".CpnyId = "in".CpnyId
-- and update on artran
	-- select 
		update
			sltestapp.dbo.ARTran
			set CuryUnitPrice = cast("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end ) as decimal(12,1)) -- aprobed
			,UnitPrice = cast("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end ) as decimal(12,2))
		from 
			inserted as "in"
		inner join 
			sltestapp.dbo.ARTran as "tran"		
		on
			"in".BatNbr = "tran".BatNbr and "in".RefNbr = "tran".RefNbr and "in".CpnyID = "tran".CpnyId	
		inner join
			sltestapp.dbo.XGRWARTrans as "xwar"
		on 
			"tran".BatNbr = "xwar".BatNbr and "tran".RefNbr = "xwar".RefNbr and "tran".CpnyID = "xwar".CpnyId	
		and
			"tran".LineNbr = "xwar".LineNbr
-- Update ardoc	
-- ======================= SET montos ======================= --
	select
	@retencion = CAST((sum("tran".CuryTxblAmt00) * -0.04) AS DECIMAL(12,2))
	   ,@iva = CAST((sum("tran".CuryTxblAmt00) * 0.16) AS DECIMAL(12,2))
	   ,@monto = sum("tran".CuryTxblAmt00) + CAST((sum("tran".CuryTxblAmt00) * -0.04) AS DECIMAL(12,2)) + CAST((sum("tran".CuryTxblAmt00) * 0.16) AS DECIMAL(12,2))
	from
	sltestapp.dbo.ARdoc as "doc"
	inner join
	sltestapp.dbo.ARTran as "tran"
	on  
	"doc".BatNbr = "tran".BatNbr and "doc".RefNbr = "tran".RefNbr and "doc".CpnyID = "tran".CpnyID --and "xwar".LineNbr = "tran".LineNbr
	where
	"doc".User2 = 'LIS'
--		and
--		"doc".PerPost > '201700'
	and
		"doc".BatNbr = @bat and "doc".RefNbr = @rfr and "doc".CpnyID = @cpnid
	group by
	"doc".BatNbr,"doc".RefNbr,"doc".CpnyID
-- ================ update tables =========================== --
		update
		  sltestapp.dbo.ARDoc
		set
		 CuryTaxTot01 = @retencion
		,TaxTot01 = @retencion
		,CuryTaxTot00 = @iva
		,TaxTot00 = @iva
		,CuryOrigDocAmt = @monto
		,CuryDocBal = @monto
		,DocBal = @monto
		,OrigDocAmt = @monto
		where 
				sltestapp.dbo.ARDoc.BatNbr = @bat
			and 
				sltestapp.dbo.ARDoc.RefNbr = @rfr
			and 
				sltestapp.dbo.ARDoc.CpnyID = @cpnid
		-- ====================================================================== --
-- update batch	
		update
			sltestapp.dbo.Batch
			set 
				 sltestapp.dbo.Batch.crtot = @monto
				,sltestapp.dbo.Batch.curycrtot = @monto
		where
		   sltestapp.dbo.Batch.BatNbr = @bat and sltestapp.dbo.Batch.CpnyID = @cpnid
		and
		   sltestapp.dbo.Batch.Crtd_Prog = 'AR010'
		-- ====================================================================== --		
	end 
end 


-- ================================================================= --

-- ======================= FOR UPDATE TRIGER ======================= --
with m as

(
select
	"doc".BatNbr,"doc".RefNbr
	   ,"doc".CpnyID
   ,CAST((sum("tran".CuryTxblAmt00) * -0.04) AS DECIMAL(12,2)) as 'retencion'
   ,CAST((sum("tran".CuryTxblAmt00) * 0.16) AS DECIMAL(12,2)) as 'iva'
   ,sum("tran".CuryTxblAmt00) + CAST((sum("tran".CuryTxblAmt00) * -0.04) AS DECIMAL(12,2)) + CAST((sum("tran".CuryTxblAmt00) * 0.16) AS DECIMAL(12,2)) as 'total'
from
sltestapp.dbo.ARdoc as "doc"
inner join
sltestapp.dbo.ARTran as "tran"
on  
"doc".BatNbr = "tran".BatNbr and "doc".RefNbr = "tran".RefNbr and "doc".CpnyID = "tran".CpnyID --and "xwar".LineNbr = "tran".LineNbr
where
"doc".User2 = 'LIS'
and
"doc".PerPost > '201700'
and
	"doc".BatNbr = '065276' and "doc".RefNbr = '050960' and "doc".CpnyID = 'TEICUA'
group by
"doc".BatNbr,"doc".RefNbr,"doc".CpnyID
)
update
  sltestapp.dbo.ARDoc
set
 CuryTaxTot01 = "m".retencion
,TaxTot01 = "m".retencion
,CuryTaxTot00 = "m".iva
,TaxTot00 = "m".iva
,CuryOrigDocAmt = "m".total
,CuryDocBal = "m".total
,DocBal = "m".total
,OrigDocAmt = "m".total
from m as "m"
where 
		sltestapp.dbo.ARDoc.BatNbr = "m".BatNbr 
	and 
		sltestapp.dbo.ARDoc.RefNbr = "m".RefNbr 
	and 
		sltestapp.dbo.ARDoc.CpnyID = "m".CpnyID
-- ====================================================================== --
update
	sltestapp.dbo.Batch
	set 
		 sltestapp.dbo.Batch.crtot = "m".total
		,sltestapp.dbo.Batch.curycrtot = "m".total
from
	   m as "m"
where
   sltestapp.dbo.Batch.BatNbr = "m".BatNbr and sltestapp.dbo.Batch.CpnyID = "m".CpnyID
and
   sltestapp.dbo.Batch.Crtd_Prog = 'AR010'
-- ====================================================================== --

-- 
select
	"bat".crtot,"bat".curycrtot,cast("bat".curycrtot as decimal(16,8)) as 'dec'
from
   sltestapp.dbo.Batch as "bat"
where
   "bat".BatNbr = '065276' and "bat".CpnyID = 'TEICUA'
and
   "bat".Crtd_Prog = 'AR010'
 
--  '065276', '050960',

-- use sltestapp
-- exec sp_desc Batch
 
select
 BatNbr
,RefNbr
,CpnyID
,CuryTaxTot01
,TaxTot01
,CuryTaxTot00
,TaxTot00
,CuryOrigDocAmt
,CuryDocBal
,DocBal
,OrigDocAmt
from
 sltestapp.dbo.ARDoc as "doc"
where
 "doc".BatNbr = '065276' 
 and "doc".RefNbr = '050960' 
 and "doc".CpnyID = 'TEICUA' 

-- ================================================================= --

use sltestapp
select batnbr,refnbr,* from ardoc
where batnbr in ('065276')
--

--update ardoc
--set curytaxtot01='-1099.63',curyorigdocamt='30789.51', curydocbal=30789.51, docbal=30789.51,origdocamt=30789.51,taxtot01=-1099.63
--where batnbr in ('065372')

-- curytaxtot01 = curyorigdocamt * -0.04

-- suma del tran entre 1.12 = subtotal

--select (30789.51/1.12) = CuryTxblTot00

--select (27490.633928*0.04) = curytaxtot01

 select (27490.633928*0.16)

 -- ret + iva + subtotal
 select (4398.50142848 - (27490.633928*0.04) + (30789.51/1.12)) 
 

	=>30789.50999936
 
	
	with m as 
	(
		select 
		--		 "doc".BatNbr,"doc".RefNbr,"doc".User2,"doc".User6
		--		 "doc".CpnyID
				"tran".Qty
		--		,"tran".UnitPrice
				,"tran".CuryTranAmt
				,"tran".CuryTxblAmt00
				,"tran".CuryUnitPrice
				,cast("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end ) as decimal(12,2)) as 'dec[UnitPrice,12,2]'
				,"tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end ) as 'rawUnitPrice'
				,cast(((case when "tran".Qty = 0 then 1 else "tran".Qty end ) * ("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end ))) as decimal(12,6)) as 'dec[Qty*UnitPrice,12,2]'
				,(case when "tran".Qty = 0 then 1 else "tran".Qty end ) * cast(("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end )) as decimal(12,2)) as 'Qty*dec[UnitPrice,12,2]'
				,cast((case when "tran".Qty = 0 then 1 else "tran".Qty end ) * cast(("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end )) as decimal(12,2)) as decimal(12,2)) as 'dec[Qty*dec[UnitPrice,12,2]]'
				,cast((case when "tran".Qty = 0 then 1 else "tran".Qty end ) as decimal(12,2)) * cast(("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end )) as decimal(12,2)) as '[ dec[Qty,12,2].dec[UnitPrice,12,2] ]'
		from 
				sltestapp.dbo.ARdoc as "doc"
			inner join 
				sltestapp.dbo.ARTran as "tran"
			on	
				"doc".BatNbr = "tran".BatNbr and "doc".RefNbr = "tran".RefNbr and "doc".CpnyID = "tran".CpnyID --and "xwar".LineNbr = "tran".LineNbr
		where 
				"doc".User2 = 'LIS'
			and 
				"doc".PerPost > '201700'
			and
--			"doc".BatNbr = '065276' and "doc".RefNbr = '050960' and "doc".CpnyID = 'TEICUA'
			"doc".BatNbr = '065372' and "doc".RefNbr = '051039' and "doc".CpnyID = 'TEICUA'
	)
	select 
		 sum(CuryTxblAmt00) as 'sum'
		,(sum(CuryTxblAmt00) * -0.0400) as 'ret'
		,(sum(CuryTxblAmt00) * 0.1600) as 'iva'
		,round((sum(CuryTxblAmt00) * -0.04),2,1) as 'retAsTruncating'
		,round((sum(CuryTxblAmt00) * 0.16),2,1) as 'ivaAsTruncating'
		,sum(CuryTxblAmt00) + ( sum(CuryTxblAmt00) * -0.04) + (sum(CuryTxblAmt00) * 0.16) as 'totalAsRaw'
		,cast(sum(CuryTxblAmt00) + ( sum(CuryTxblAmt00) * -0.04) + (sum(CuryTxblAmt00) * 0.16) as decimal(12,2)) as 'totalAsCastDecimal'
		,round( (sum(CuryTxblAmt00) + ( sum(CuryTxblAmt00) * -0.04) + (sum(CuryTxblAmt00) * 0.16)),2,1) as 'totalAsTruncating'
		,sum(CuryTxblAmt00) + (round((sum(CuryTxblAmt00) * -0.04),2,1)) + round((sum(CuryTxblAmt00) * 0.16),2,1) as 'sumAsTruncate'
	from m
	
--ejemplo para actualizar 	
	update 
		tablename
		set subtotal = sum(CuryTxblAmt00)
			,ret = (sum(CuryTxblAmt00) * -0.04)
			,iva = (sum(CuryTxblAmt00) * 0.16)
	from m
		
	
--select * from batch
--where batnbr='065372' and crtd_prog='AR010'
--
--
--update batch
--set crtot=30789.51, curycrtot=30789.51
--where batnbr='065372' and crtd_prog='AR010'


------ =========================================================== ---

-- Emulate Inserted

-- Check and Test

select 
--		 "doc".BatNbr,"doc".RefNbr,"doc".User2,"doc".User6
--		 "doc".CpnyID
		"tran".Qty
--		,"tran".UnitPrice
		,"tran".CuryTranAmt
		,"tran".CuryUnitPrice
		,cast("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end ) as decimal(12,2)) as 'dec[UnitPrice,12,2]'
		,"tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end ) as 'rawUnitPrice'
		,cast(((case when "tran".Qty = 0 then 1 else "tran".Qty end ) * ("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end ))) as decimal(12,6)) as 'dec[Qty*UnitPrice,12,2]'
		,(case when "tran".Qty = 0 then 1 else "tran".Qty end ) * cast(("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end )) as decimal(12,2)) as 'Qty*dec[UnitPrice,12,2]'
		,cast((case when "tran".Qty = 0 then 1 else "tran".Qty end ) * cast(("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end )) as decimal(12,2)) as decimal(12,2)) as 'dec[Qty*dec[UnitPrice,12,2]]'
		,cast((case when "tran".Qty = 0 then 1 else "tran".Qty end ) as decimal(12,2)) * cast(("tran".CuryTranAmt / (case when "tran".Qty = 0 then 1 else "tran".Qty end )) as decimal(12,2)) as '[ dec[Qty,12,2].dec[UnitPrice,12,2] ]'
from 
		sltestapp.dbo.ARdoc as "doc"
	inner join 
		sltestapp.dbo.ARTran as "tran"
	on	
		"doc".BatNbr = "tran".BatNbr and "doc".RefNbr = "tran".RefNbr and "doc".CpnyID = "tran".CpnyID --and "xwar".LineNbr = "tran".LineNbr
where 
		"doc".User2 = 'LIS'
	and 
		"doc".PerPost > '201700'
	and
--	"doc".BatNbr = '065276' and "doc".RefNbr = '050960' and "doc".CpnyID = 'TEICUA'
	"doc".BatNbr = '065372' and "doc".RefNbr = '051039' and "doc".CpnyID = 'TEICUA'
	
-- directorio  =>  Evidencias 

	
	
	
--	"doc".BatNbr = '065339' and "doc".RefNbr = '051009' and "doc".CpnyID = 'TEICUA'
--	"doc".BatNbr = '065340' and "doc".RefNbr = '051010' and "doc".CpnyID = 'TEICUA'
--	"doc".BatNbr = '065341' and "doc".RefNbr = '051011' and "doc".CpnyID = 'TEICUA'
--	and
--		(
--			"tran".Qty is null
--		or 
--			"tran".UnitPrice is null
--		or 
--			"tran".CuryTranAmt is null
--		)



-- ==================================================== --

select CuryTranAmt,Qty,UnitPrice,LineNbr
--update
--	sltestapp.dbo.ARTran
--		set UnitPrice = 0 , CuryUnitPrice = 0
--		set Qty = 0
from
		sltestapp.dbo.ARTran as "tran"
where 
	"tran".BatNbr = '065276' and "tran".RefNbr = '050960' and "tran".CpnyID = 'TEICUA'
	and 
	"tran".LineNbr in (-32704,-32672,-32640,-32608)
	
-- =================================================== --

--	SELECT ROUND(4162.999, 2);		

-- > 43 records	

select 
		 "doc".BatNbr,"doc".RefNbr,"doc".User2,"doc".User6
		,"doc".CpnyID
		,"tran".CuryTranAmt
		,"tran".Qty
		,"tran".UnitPrice
		,"tran".CuryTranAmt * "tran".Qty as 'UnitPr'
		,"xwar".*
from 
		sltestapp.dbo.ARdoc as "doc"
	inner join 
		sltestapp.dbo.XGRWARTrans as "xwar"
	on 
		"doc".BatNbr = "xwar".BatNbr and "doc".RefNbr = "xwar".RefNbr and "doc".CpnyID = "xwar".CpnyId
	inner join 
		sltestapp.dbo.ARTran as "tran"
	on	
		"doc".BatNbr = "tran".BatNbr and "doc".RefNbr = "tran".RefNbr and "doc".CpnyID = "tran".CpnyID and "xwar".LineNbr = "tran".LineNbr
where 
	"doc".BatNbr = '065276' and "doc".RefNbr = '050960'
	
	
	-- == --
	
	
select * from sltestapp.dbo.ARTran as "tran" where 	"tran".BatNbr = '065276' and "tran".RefNbr = '050960' and "tran".CpnyId = 'TEICUA'
	
select * from sltestapp.dbo.XGRWARTrans where BatNbr = '065276' and RefNbr = '050960' and CpnyId = 'TEICUA'

select * from sltestapp.dbo.XGRWARTrans where BatNbr = '065279'

-- delete sltestapp.dbo.XGRWARTrans where BatNbr = '065276' and RefNbr = '050960' and CpnyId = 'TEICUA'
-- truncate table sltestapp.dbo.xwar_auxiliar_tables

-- tests
INSERT INTO sltestapp.dbo.XGRWARTrans
(CpnyId, BatNbr, RefNbr, SATProductId, SATUnitId, LineNbr, S4Future01, S4Future02, S4Future03, S4Future04, S4Future05, S4Future06, S4Future07, S4Future08, S4Future09, S4Future10, S4Future11, S4Future12, User1, User2, User3, User4, User5, User6, User7, User8, XPredial)
values
('TEICUA', '065276', '050960', '  ', ' ', -32768, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32736, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32704, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32672, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32640, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32608, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32576, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32544, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32512, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32480, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32448, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32416, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32384, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32352, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32320, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32288, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32256, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32224, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32192, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32160, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32128, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32096, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32064, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32032, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -32000, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31968, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31936, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31904, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31872, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31840, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31808, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31776, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31744, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31712, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31680, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31648, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31616, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31584, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31552, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31520, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31488, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31456, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, ' '),
('TEICUA', '065276', '050960', '  ', ' ', -31424, '_ ', ' ', 0, 0, 0, 0, {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, 0, 0, '  ', ' ', ' ', '  ', 0, 0, '  ', ' ', {ts '1900-01-01 00:00:00.000'}, {ts '1900-01-01 00:00:00.000'}, '  ');


--


-- Example Concepts

-- drop tables 
drop table tempdb.dbo.t1
-- create the tables
use tempdb


-- this must be the auxiliar table
create table t1 (id int primary key, t1_value varchar(50),batnbr varchar(50),reference varchar(50))
	insert into t1 select 1, 'value1','065276','050960'
	insert into t1 select 2, 'value2','065276','050960'
	insert into t1 select 3, 'value3','065276','050960'
	insert into t1 select 5, 'value5','065277','050962'
-- and this must be the xwar table
create table t2 (id int primary key, t2_value varchar(50),batnbr varchar(50),reference varchar(50),xwar_one varchar(50),xwar_two varchar(50))
	insert into t2 select 1, null,'065276','050960',null,null
	insert into t2 select 2, null,'065276','050960',null,null
	insert into t2 select 3, null,'065276','050960',null,null
	insert into t2 select 6, null,'065278','050968',null,null
	insert into t2 select 7, 'xwarr','065279','050969',null,null
	insert into t2 select 8, 'xxwarr','065280','050970',null,null

	insert into t2 values (13, 'xxwarr13','065282','050972',null,null),(14, 'xxwarr14','065282','050972',null,null)
					,(15, 'xxwarr15','065282','050972',null,null),(16, 'xxwarr16','065282','050972',null,null)
	
--testing
	
select *,'one','two' from tempdb.dbo.t1
union all
select * from tempdb.dbo.t2



create trigger toaux
ON t2
after insert
as 

begin
	set nocount on
		
	insert into t1 
		select "i".id,"i".t2_value ,"i".batnbr ,"i".reference from inserted as "i"
end
	


alter trigger update_t2 on t1
--for update
after insert
as
begin
	set nocount on
 
	update t2
	set t2_value = i.t1_value
		,xwar_one = '78101802'
		,xwar_two = 'E48'
	from inserted as i
	 inner join t2 on t2.id = i.id
end




update t1
set t1_value = cast(id as varchar(50))

insert into t1 select 4, 'value3','065277','050961'

