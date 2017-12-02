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
	,"customer".terms as 'diasCredito'
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
		
		

		
-- ==================================================================================================================== --	
-- =================================     	  Viajes Indicadores Data View		  ===================================== --
-- ==================================================================================================================== --		
		
-- TBK
		
use sistemas;

IF OBJECT_ID ('performance_view_full_indicators_tbk_periods', 'V') IS NOT NULL
    DROP VIEW performance_view_full_indicators_tbk_periods;
-- now build the view
create view performance_view_full_indicators_tbk_periods
with encryption
as
	with guia_tbk as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
					,guia.num_guia
					,guia.no_guia
					,viaje.f_despachado
					,cast(guia.fecha_guia as date) as 'fecha_guia'
					,cast(guia.fecha_ingreso as date) as 'fecha_ingreso'
					,cast(guia.fecha_modifico as date) as 'fecha_modifico'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,cliente.id_cliente
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
					,"trg".peso
					,(
						select 
								descripcion
						from
								bonampakdb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								bonampakdb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								bonampakdb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								bonampakdb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							bonampakdb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'1' as 'company'
			from 
						bonampakdb.dbo.trafico_viaje as "viaje"
				inner join 
						bonampakdb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
					and 
						guia.prestamo <> 'P'
					and 
						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
				inner join
						bonampakdb.dbo.trafico_renglon_guia as "trg"
					on
						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				inner join
						bonampakdb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				inner join 
						bonampakdb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(guia.fecha_guia) = "translation".month_num
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
 				,"guia".num_guia,"guia".no_guia
				,"guia".f_despachado ,"guia".fecha_guia ,"guia".fecha_ingreso ,"guia".fecha_modifico
				,"guia".mes ,"guia".id_cliente ,"guia".cliente 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else '1'
				end as 'trip_count'
	from 
				guia_tbk as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
				,"guia".num_guia , "guia".no_guia
				,"guia".fecha_guia ,"guia".f_despachado ,"guia".fecha_ingreso , "guia".fecha_modifico
				,"guia".mes 
				,"guia".id_cliente
				,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company

--select * from sistemas.dbo.performance_view_full_indicators_tbk_periods
				
				
--	ATM

use sistemas
IF OBJECT_ID ('performance_view_full_indicators_atm_periods', 'V') IS NOT NULL		
    DROP VIEW performance_view_full_indicators_atm_periods;
create view performance_view_full_indicators_atm_periods

with encryption
as			
	with guia_atm as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
					,guia.num_guia
					,guia.no_guia
					,viaje.f_despachado
					,cast(guia.fecha_guia as date) as 'fecha_guia'
					,cast(guia.fecha_ingreso as date) as 'fecha_ingreso'
					,cast(guia.fecha_modifico as date) as 'fecha_modifico'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,cliente.id_cliente
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
					,"trg".peso
					,(
						select 
								descripcion
						from
								macuspanadb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								macuspanadb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								macuspanadb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								macuspanadb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							macuspanadb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'2' as 'company'
			from 
						macuspanadb.dbo.trafico_viaje as "viaje"
				inner join 
						macuspanadb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
					and 
						guia.prestamo <> 'P'
					and 
						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
				inner join
						macuspanadb.dbo.trafico_renglon_guia as "trg"
					on
						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				inner join
						macuspanadb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				inner join 
						macuspanadb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(guia.fecha_guia) = "translation".month_num
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
				,"guia".num_guia , "guia".no_guia
				,"guia".f_despachado ,"guia".fecha_guia ,"guia".fecha_ingreso , "guia".fecha_modifico
				,"guia".mes ,"guia".id_cliente ,"guia".cliente
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else '1'
				end as 'trip_count'
	from 
				guia_atm as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
				,"guia".num_guia , "guia".no_guia
				,"guia".f_despachado,"guia".fecha_guia ,"guia".fecha_ingreso ,"guia".fecha_modifico
				,"guia".mes ,"guia".id_cliente ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company

				
-- Teisa

			
-- ==================================================================================================================== --	
-- ===============================      full indicators for tespecializadadb	  ===================================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('performance_view_full_indicators_tei_periods', 'V') IS NOT NULL		
    DROP VIEW performance_view_full_indicators_tei_periods;
    
create view performance_view_full_indicators_tei_periods
with encryption
as
	with guia_tei as 
		(
			select 
					 viaje.id_area
					,viaje.id_unidad
					,viaje.id_configuracionviaje
					,guia.id_tipo_operacion
					,guia.id_fraccion
					,manto.id_flota
					,viaje.no_viaje
					,guia.num_guia
					,guia.no_guia
					,viaje.f_despachado
					,cast(guia.fecha_guia as date) as 'fecha_guia'
					,cast(guia.fecha_ingreso as date) as 'fecha_ingreso'
					,cast(guia.fecha_modifico as date) as 'fecha_modifico'
--					,(select datename(mm,guia.fecha_guia)) as 'mes'
					,upper(left("translation".month_name,1)) + right("translation".month_name,len("translation".month_name) - 1) as 'mes'
					,cliente.id_cliente
					,cliente.nombre as 'cliente'
					,viaje.kms_viaje
					,viaje.kms_real
					,guia.subtotal
					,"trg".peso
					,(
						select 
								descripcion
						from
								tespecializadadb.dbo.trafico_configuracionviaje as "trviaje"
						where
								trviaje.id_configuracionviaje = viaje.id_configuracionviaje
					) as 'configuracion_viaje'
					,(
						select 
								tipo_operacion
						from
								tespecializadadb.dbo.desp_tipooperacion as "tpop"
						where 
								tpop.id_tipo_operacion = guia.id_tipo_operacion
					 ) as 'tipo_de_operacion'
					,(
						select 
								nombre
						from 
								tespecializadadb.dbo.desp_flotas as "fleet"
						where
								fleet.id_flota = manto.id_flota
							
					) as 'flota'
					,(
						select
								ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
						from 
								tespecializadadb.dbo.general_area as "areas"
						where 
								areas.id_area = viaje.id_area
					) as 'area'
					,(
						select
								desc_producto
						from
							tespecializadadb.dbo.trafico_producto as "producto"
						where      
							producto.id_producto = 0 and producto.id_fraccion = guia.id_fraccion
					) as 'fraccion'
					,'3' as 'company'
			from 
						tespecializadadb.dbo.trafico_viaje as "viaje"
				inner join 
						tespecializadadb.dbo.trafico_guia as "guia"
					on	
						guia.status_guia in (select item from sistemas.dbo.fnSplit('R|T|C|A', '|'))
					and 
						guia.prestamo <> 'P'
					and 
						guia.tipo_doc = 2 
					and
						guia.id_area = viaje.id_area and guia.no_viaje = viaje.no_viaje
				inner join
						tespecializadadb.dbo.trafico_renglon_guia as "trg"
					on
						"trg".no_guia = "guia".no_guia and "trg".id_area = "viaje".id_area 
				inner join
						tespecializadadb.dbo.trafico_cliente as "cliente"
					on 
						cliente.id_cliente = guia.id_cliente
				inner join 
						tespecializadadb.dbo.mtto_unidades as "manto"
					on 
						manto.id_unidad = viaje.id_unidad
				inner join
						sistemas.dbo.generals_month_translations as "translation"
					on
						month(guia.fecha_guia) = "translation".month_num
		)
	select 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
				,"guia".num_guia , "guia".no_guia
				,"guia".f_despachado ,"guia".fecha_guia , "guia".fecha_ingreso , "guia".fecha_modifico
				,"guia".mes  ,"guia".id_cliente ,"guia".cliente 
--				,avg("guia".kms_viaje) as 'kms_viaje' 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_viaje
				end as 'kms_viaje'
--				,avg("guia".kms_real) as 'kms_real'
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else "guia".kms_real
				end as 'kms_real'
				,sum("guia".subtotal) as 'subtotal' 
				,sum("guia".peso) as 'peso'
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company 
				,case 
					when ( row_number() over(partition by "guia".no_viaje,"guia".id_area,"guia".company order by "guia".fecha_guia) ) > 1 
						then '0' else '1'
				end as 'trip_count'
	from 
				guia_tei as "guia"
	group by 
				 "guia".id_area ,"guia".id_unidad ,"guia".id_configuracionviaje ,"guia".id_tipo_operacion ,"guia".id_fraccion ,"guia".id_flota ,"guia".no_viaje 
 				,"guia".num_guia , "guia".no_guia
				,"guia".f_despachado , "guia".fecha_guia , "guia".fecha_ingreso , "guia".fecha_modifico
				,"guia".mes ,"guia".id_cliente ,"guia".cliente
				,"guia".kms_viaje,"guia".kms_real
				,"guia".configuracion_viaje ,"guia".tipo_de_operacion ,"guia".flota ,"guia".area ,"guia".fraccion ,"guia".company
		


-- ==================================================================================================================== --	
-- =============================      full query indicators for all company    ======================================== --
-- ==================================================================================================================== --

use sistemas
IF OBJECT_ID ('performance_trips', 'V') IS NOT NULL		
    DROP VIEW performance_trips;
    
create view performance_trips
as 
(
	select
		row_number()
	over 
		(order by num_guia) as 
				     id
					,id_area,id_unidad,id_configuracionviaje,id_tipo_operacion,id_fraccion,id_flota,no_viaje
					,num_guia, no_guia
					,f_despachado,fecha_guia,fecha_ingreso,fecha_modifico,mes,id_cliente,cliente,kms_viaje,kms_real,subtotal
					,peso,configuracion_viaje,tipo_de_operacion,flota,area,fraccion,company,trip_count	
	from (
			select 
					 id_area,id_unidad,id_configuracionviaje,id_tipo_operacion,id_fraccion,id_flota,no_viaje
					,num_guia , no_guia
					,f_despachado,fecha_guia,fecha_ingreso,fecha_modifico,mes,id_cliente,cliente,kms_viaje,kms_real,subtotal
					,peso,configuracion_viaje,tipo_de_operacion,flota
					, -- area
					case 
						when id_tipo_operacion = '12'
							then 'LA PAZ'
						else	
							area
					end as 'area'
					,fraccion,company,trip_count	
			from 
					sistemas.dbo.performance_view_full_indicators_tbk_periods
			union all
			select 
					 id_area,id_unidad,id_configuracionviaje,id_tipo_operacion,id_fraccion,id_flota,no_viaje
					,num_guia,no_guia
					,f_despachado,fecha_guia,fecha_ingreso,fecha_modifico,mes,id_cliente,cliente,kms_viaje,kms_real,subtotal
					,peso,configuracion_viaje,tipo_de_operacion,flota,area,fraccion,company,trip_count	
			from 
					sistemas.dbo.performance_view_full_indicators_atm_periods
			union all
			select 
					 id_area,id_unidad,id_configuracionviaje,id_tipo_operacion,id_fraccion,id_flota,no_viaje
					,num_guia , no_guia
					,f_despachado,fecha_guia,fecha_ingreso,fecha_modifico,mes,id_cliente,cliente,kms_viaje,kms_real,subtotal
					,peso,configuracion_viaje,tipo_de_operacion,flota,area,fraccion,company,trip_count	
			from 
					sistemas.dbo.performance_view_full_indicators_tei_periods
	) as result
) 


-- select * from sistemas.dbo.performance_trips_indicators

select * from sistemas.dbo.casetas_lis_full_conciliations



select * from sistemas.dbo.casetas_controls_files where [_filename] like '%425%' and [_area] = 'teicua'

select * from sistemas.dbo.casetas_view_resume_stands where  casetas_controls_files_id = '426'



select is_current from sistemas.dbo.ingresos_costos_gst_holidays where year(is_current) = year(current_timestamp) and month(is_current) = month(current_timestamp)

select current_timestamp , cast(dateadd(day,-1,current_timestamp) as date) as 'new_date'

