-- ==================================================================================================================== --	
-- ========================================     App Performance Client      =========================================== --
-- ==================================================================================================================== --

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 06, 2017
 Description    : Build Tables for constant values like months names translation to spanish names
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ================================================================================ */
		
-- ==================================================================================================================== --	
-- =================================     	  Client Catalog View		     ====================================== --
-- ==================================================================================================================== --
-- table rename to performance_customers

use sistemas;

IF OBJECT_ID ('performance_customers', 'V') IS NOT NULL
    DROP VIEW performance_customers;
-- now build the view
create view performance_customers
--with encryption
as
select 
		 "customer".CustId as 'id'
		,"customer".AccrRevAcct ,"customer".AccrRevSub ,"customer".AcctNbr ,"customer".Addr1 ,"customer".Addr2 
		,"customer".AgentID ,"customer".ApplFinChrg ,"customer".ArAcct ,"customer".ArSub 
		,"customer".Attn ,"customer".AutoApply ,"customer".BankID ,"customer".BillAddr1 
		,"customer".BillAddr2 ,"customer".BillAttn ,"customer".BillCity ,"customer".BillCountry 
		,"customer".BillFax ,"customer".BillName ,"customer".BillPhone ,"customer".BillSalut 
		,"customer".BillState ,"customer".BillThruProject ,"customer".BillZip ,"customer".CardExpDate 
		,"customer".CardHldrName ,"customer".CardNbr ,"customer".CardType ,"customer".City ,"customer".ClassId 
		,"customer".ConsolInv ,"customer".Country ,"customer".CrLmt ,"customer".Crtd_DateTime ,"customer".Crtd_Prog 
		,"customer".Crtd_User ,"customer".CuryId ,"customer".CuryPrcLvlRtTp ,"customer".CuryRateType ,"customer".CustFillPriority 
		,"customer".CustId
		,"customer".DfltShipToId ,"customer".DocPublishingFlag ,"customer".DunMsg ,"customer".EMailAddr 
		,"customer".Fax ,"customer".InvtSubst ,"customer".LanguageID ,"customer".LUpd_DateTime ,"customer".LUpd_Prog 
		,"customer".LUpd_User ,"customer".Name ,"customer".NoteId ,"customer".OneDraft ,"customer".PerNbr ,"customer".Phone 
		,"customer".PmtMethod ,"customer".PrcLvlId ,"customer".PrePayAcct ,"customer".PrePaySub ,"customer".PriceClassID 
		,"customer".PrtMCStmt ,"customer".PrtStmt ,"customer".S4Future01 ,"customer".S4Future02 ,"customer".S4Future03 
		,"customer".S4Future04 ,"customer".S4Future05 ,"customer".S4Future06 ,"customer".S4Future07 ,"customer".S4Future08 
		,"customer".S4Future09 ,"customer".S4Future10 ,"customer".S4Future11 ,"customer".S4Future12 ,"customer".Salut 
		,"customer".SetupDate ,"customer".ShipCmplt ,"customer".ShipPctAct ,"customer".ShipPctMax ,"customer".SICCode1 
		,"customer".SICCode2 ,"customer".SingleInvoice ,"customer".SlsAcct ,"customer".SlsperId ,"customer".SlsSub 
		,"customer".State ,"customer".Status ,"customer".StmtCycleId ,"customer".StmtType ,"customer".TaxDflt 
		,"customer".TaxExemptNbr ,"customer".TaxID00 ,"customer".TaxID01 ,"customer".TaxID02 ,"customer".TaxID03 
		,"customer".TaxLocId ,"customer".TaxRegNbr ,"customer".Terms ,"customer".Territory ,"customer".TradeDisc 
		,"customer".User1 ,"customer".User2 ,"customer".User3 ,"customer".User4 ,"customer".User5 ,"customer".User6 
		,"customer".User7 ,"customer".User8 ,"customer".Zip 
--		,"customer".tstamp
from 
		integraapp.dbo.Customer as "customer"
		
-- ==================================================================================================================== --	
-- =================================     	  Factura Data View		     ====================================== --
-- ==================================================================================================================== --

		
use sistemas;

IF OBJECT_ID ('performance_references', 'V') IS NOT NULL
    DROP VIEW performance_references;
-- now build the view
create view performance_references
--with encryption
as
select
	 "document".RefNbr as 'id'
 	,"document".CustId as 'performance_customers_id'
	,"document".CpnyID as Empresa
	,case
		("document".DocType)
		when 'IN' then 'FACTURA'
		when 'CM' then 'NOTA DE CREDITO'
		when 'DM' then 'NOTA DE CARGO'
	end as TipoDocumento
	,"document".User6 as Folio
	,"customer".Name as Nombre
	,"document".CuryTxblTot00 as Flete
	,"document".CuryTaxTot00 as Iva
	,"document".CuryTaxTot01 as Retencion
	,"document".CuryOrigDocAmt as Total
	,"document".RefNbr as Referencia
	,"document".BatNbr as Lote
	,"document".DocDesc as Descripcion
	,"document".Crtd_DateTime as ElaboracionFactura
	
	,case
		month("document".Crtd_DateTime)
		when 1 then 'ENERO'
		when 2 then 'FEBRERO'
		when 3 then 'MARZO'
		when 4 then 'ABRIL'
		when 5 then 'MAYO'
		when 6 then 'JUNIO'
		when 7 then 'JULIO'
		when 8 then 'AGOSTO'
		when 9 then 'SEPTIEMBRE'
		when 10 then 'OCTUBRE'
		when 11 then 'NOVIEMBRE'
		when 12 then 'DICIEMBRE'
	end as MES  
	,day("document".Crtd_DateTime) as DIA
from
	integraapp.dbo.ARDoc as "document" inner join integraapp.dbo.Customer as "customer" on
	"document".CustId = "customer".CustId
where
		"document".DocType = 'IN'
	and
		"document".CpnyID = 'TEICUA' and year("document".Crtd_DateTime) = '2017' and month("document".Crtd_DateTime) = '10' and day("document".Crtd_DateTime) = '25'
		
		
