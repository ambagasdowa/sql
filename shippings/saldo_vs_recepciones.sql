--- RECEPCIONES---

SELECT     YEAR(RcptDate) AS AÑO, CASE month(Rcptdate)

                      WHEN 1 THEN 'ENERO' WHEN 2 THEN 'FEBRERO' WHEN 3 THEN 'MARZO' WHEN 4 THEN 'ABRIL' WHEN 5 THEN 'MAYO' WHEN 6 THEN 'JUNIO' WHEN 7 THEN 'JULIO'

                       WHEN 8 THEN 'AGOSTO' WHEN 9 THEN 'SEPTIEMBRE' WHEN 10 THEN 'OCTUBRE' WHEN 11 THEN 'NOVIEMBRE' WHEN 12 THEN 'DICIEMBRE' END AS MES,

                      CASE (RcptType) WHEN 'X' THEN (RcptAmtTot) * - 1 ELSE RcptAmtTot END AS Costo, BatNbr AS Lote, CpnyID AS Compañía, PerEnt, PONbr AS OC, Status AS Estatus,

                      VendID AS RFC

FROM         dbo.POReceipt

WHERE     (YEAR(RcptDate) = 2017) AND (Status = 'C')  and VendID = 'BFM910826TW6' and CpnyID = 'TBKORI'

GROUP BY RcptDate, RcptType, RcptAmtTot, BatNbr, CpnyID, PerEnt, PONbr, Status, VendID


--- SALDO PROVEEDORES ---

SELECT     dbo.AP_Balances.CpnyID, dbo.AP_Balances.CurrBal, dbo.AP_Balances.VendID

FROM         dbo.Vendor INNER JOIN

                      dbo.AP_Balances ON dbo.Vendor.VendId = dbo.AP_Balances.VendID

WHERE     (dbo.Vendor.ClassID <> 'FUNEMP')

GROUP BY dbo.AP_Balances.CpnyID, dbo.AP_Balances.CurrBal, dbo.AP_Balances.VendID
 

---FULL JOIN ---

select * from dbo.Gst_v_recepciones FULL JOIN dbo.Gst_v_saldoprov

where dbo.Gst_v_recepciones.cpnyid=dbo.Gst_v_saldoprov.cpnyid


/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 06, 2017
 Description    : Re-Build of the last two querys like the boss ask for it 
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ===============================================================================*/


-- ==================================================================================================================== --	
-- =================================     	  Rebuild of the after    		     ====================================== --
-- ==================================================================================================================== --

with reception as 
		(
			select 
						 year("rec".RcptDate) as 'Año'
						,"trmonth".month_name as 'Mes'
						,case	"rec".RcptType
							when 'X' then (("rec".RcptAmtTot)*-1)
							else "rec".RcptAmtTot
						 end as 'Costo'
						,"rec".BatNbr as 'Lote'
						,"rec".CpnyID as 'Compañia'
						,"rec".PerEnt
						,"rec".PONbr as 'OC'
						,"rec".Status as 'Estatus'
						,"rec".VendID as 'RFC'
						,(row_number() over(partition by "rec".VendID order by "rec".PerEnt)) as 'indexOrder'
			from
						integraapp.dbo.POReceipt as "rec"
				inner join 
						sistemas.dbo.generals_month_translations as "trmonth" on cast(month("rec".RcptDate) as int) = "trmonth".month_num
			where
						year("rec".RcptDate) = '2017' and "rec".Status = 'C'
			group by
						"rec".RcptDate, "rec".RcptType, "rec".RcptAmtTot, "rec".BatNbr, "rec".CpnyID, "rec".PerEnt, "rec".PONbr, "rec".Status, "rec".VendID
						,"trmonth".month_name
		)
		select 
					 "rep"."Año"
					,"rep"."Mes"
					,"rep"."Costo"
					,"rep"."Lote"
					,"rep"."Compañia"
					,"rep"."PerEnt"
					,"rep"."OC"
					,"rep"."Estatus"
					,"rep"."RFC"
					,"sal"."CpnyID" as 'saldoCompany'
					,"sal"."VendID" as 'saldoVendorId'
					,"sal"."CurrBal" as 'Saldo'
		from reception as "rep"
			left join	
						(
							select 
										 "saldo".CpnyID
										,"saldo".CurrBal
										,"saldo".VendID
										,"saldo".PerNbr
										,row_number() over(partition by "saldo".VendID order by "saldo".PerNbr) as 'indexOrder'
							from
										integraapp.dbo.AP_Balances as "saldo"
								inner join
										integraapp.dbo.Vendor as "vdor"
									on
										"vdor".VendID = "saldo".VendID 
							where
										"vdor".ClassID <> 'FUNEMP'
						) as "sal" on "sal".CpnyID = "rep"."Compañia" and "sal".VendID = "rep"."RFC" and "sal".indexOrder = "rep".indexOrder
						
				