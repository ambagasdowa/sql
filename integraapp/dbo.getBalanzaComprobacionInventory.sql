USE [integraapp]
GO
/****** Object:  UserDefinedFunction [dbo].[getBalanzaComprobacionInventory]    Script Date: 12/04/2016 01:14:06 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[getBalanzaComprobacionInventory]
 (
	@initPer char(6),
	@endPer char(6),
	@shortAnswer varchar(10)
--	@Company varchar(8000), -- just in case
--	@Delimiter varchar(10)
 )
returns table with encryption
as 
return
(

--set @initPer = '201501', @endPer = '201506', @shortAnswer = 'FALSE';

SELECT DISTINCT 
			dbo.ItemSite.ABCCode, dbo.Inventory.ClassID, dbo.ItemSite.COGSAcct, 
			dbo.ItemSite.COGSSub, dbo.Inventory.Descr, dbo.ItemSite.InvtAcct, 
			dbo.ItemSite.InvtID, dbo.ItemSite.InvtSub, dbo.Inventory.InvtType, 
			dbo.Inventory.Kit, dbo.Inventory.LotSerTrack, dbo.Inventory.SerAssign, 
			dbo.Inventory.Source, dbo.Inventory.Status, dbo.Inventory.StkItem, 
			dbo.InventoryADG.WeightUOM, dbo.InventoryADG.Volume, dbo.InventoryADG.Weight,
			dbo.Inventory.TaxCat, dbo.Inventory.User1, dbo.Inventory.User2, dbo.Inventory.User3,
			dbo.Inventory.User4, dbo.Inventory.ValMthd, 
			--dbo.RptRuntime.RI_ID,
			 dbo.Site.Name AS SiteName, 
			dbo.Site.CpnyID, dbo.INTran.LineRef,
			CASE WHEN ItemBMIHist.InvtID IS NULL 
			OR 
				SubString(LTRIM(@initPer), 1, 4) <> ItemBMIHist.FiscYr 
			OR
				Inventory.ValMthd = 'U' 
			THEN 0 
			WHEN RIGHT(RTRIM(@initPer), 2) = '01' 
			THEN ItemBMIHist.BMIBegBal 
			WHEN RIGHT(RTRIM(@initPer), 2) = '02' 
			THEN ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 + ItemBMIHist.BMIPTDCostAdjd00 - ItemBMIHist.BMIPTDCostIssd00 + ItemBMIHist.BMIPTDCostRcvd00
			WHEN RIGHT(RTRIM(@initPer), 2) = '03' 
			THEN ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 + ItemBMIHist.BMIPTDCostAdjd00 + ItemBMIHist.BMIPTDCostAdjd01 - ItemBMIHist.BMIPTDCostIssd00 - ItemBMIHist.BMIPTDCostIssd01 + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01
			WHEN RIGHT(RTRIM(@initPer),2) = '04' 
			THEN	ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 
				- ItemBMIHist.BMIPTDCOGS02 + ItemBMIHist.BMIPTDCostAdjd00 + ItemBMIHist.BMIPTDCostAdjd01 
				+ ItemBMIHist.BMIPTDCostAdjd02 - ItemBMIHist.BMIPTDCostIssd00 - ItemBMIHist.BMIPTDCostIssd01 
				- ItemBMIHist.BMIPTDCostIssd02 + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01 
				+ ItemBMIHist.BMIPTDCostRcvd02 
			WHEN RIGHT(RTRIM(@initPer), 2) = '05' 
			THEN	ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 
				- ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 + ItemBMIHist.BMIPTDCostAdjd00
				+ ItemBMIHist.BMIPTDCostAdjd01 + ItemBMIHist.BMIPTDCostAdjd02 + ItemBMIHist.BMIPTDCostAdjd03 
				- ItemBMIHist.BMIPTDCostIssd00 - ItemBMIHist.BMIPTDCostIssd01
				- ItemBMIHist.BMIPTDCostIssd02 - ItemBMIHist.BMIPTDCostIssd03 + ItemBMIHist.BMIPTDCostRcvd00 
				+ ItemBMIHist.BMIPTDCostRcvd01 + ItemBMIHist.BMIPTDCostRcvd02 + ItemBMIHist.BMIPTDCostRcvd03 
			WHEN RIGHT(RTRIM(@initPer), 2) = '06' 
			THEN	ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 
				- ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 - ItemBMIHist.BMIPTDCOGS04
				+ ItemBMIHist.BMIPTDCostAdjd00 + ItemBMIHist.BMIPTDCostAdjd01 + ItemBMIHist.BMIPTDCostAdjd02 
				+ ItemBMIHist.BMIPTDCostAdjd03 + ItemBMIHist.BMIPTDCostAdjd04 - ItemBMIHist.BMIPTDCostIssd00 
				- ItemBMIHist.BMIPTDCostIssd01 - ItemBMIHist.BMIPTDCostIssd02 - ItemBMIHist.BMIPTDCostIssd03 
				- ItemBMIHist.BMIPTDCostIssd04 + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01 
				+ ItemBMIHist.BMIPTDCostRcvd02 + ItemBMIHist.BMIPTDCostRcvd03 + ItemBMIHist.BMIPTDCostRcvd04
			WHEN RIGHT(RTRIM(@initPer), 2) = '07' 
			THEN	ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 
				- ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 - ItemBMIHist.BMIPTDCOGS04
				- ItemBMIHist.BMIPTDCOGS05 + ItemBMIHist.BMIPTDCostAdjd00 + ItemBMIHist.BMIPTDCostAdjd01 
				+ ItemBMIHist.BMIPTDCostAdjd02 + ItemBMIHist.BMIPTDCostAdjd03 + ItemBMIHist.BMIPTDCostAdjd04 
				+ ItemBMIHist.BMIPTDCostAdjd05 - ItemBMIHist.BMIPTDCostIssd00 - ItemBMIHist.BMIPTDCostIssd01 
				- ItemBMIHist.BMIPTDCostIssd02 - ItemBMIHist.BMIPTDCostIssd03 - ItemBMIHist.BMIPTDCostIssd04 
				- ItemBMIHist.BMIPTDCostIssd05 + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01
				+ ItemBMIHist.BMIPTDCostRcvd02 + ItemBMIHist.BMIPTDCostRcvd03 + ItemBMIHist.BMIPTDCostRcvd04 
				+ ItemBMIHist.BMIPTDCostRcvd05 
			WHEN RIGHT(RTRIM(@initPer),2) = '08' 
			THEN	ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 
				- ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 - ItemBMIHist.BMIPTDCOGS04
				- ItemBMIHist.BMIPTDCOGS05 - ItemBMIHist.BMIPTDCOGS06 + ItemBMIHist.BMIPTDCostAdjd00 
				+ ItemBMIHist.BMIPTDCostAdjd01 + ItemBMIHist.BMIPTDCostAdjd02 + ItemBMIHist.BMIPTDCostAdjd03 
				+ ItemBMIHist.BMIPTDCostAdjd04 + ItemBMIHist.BMIPTDCostAdjd05 + ItemBMIHist.BMIPTDCostAdjd06 
				- ItemBMIHist.BMIPTDCostIssd00 - ItemBMIHist.BMIPTDCostIssd01 - ItemBMIHist.BMIPTDCostIssd02 
				- ItemBMIHist.BMIPTDCostIssd03 - ItemBMIHist.BMIPTDCostIssd04 - ItemBMIHist.BMIPTDCostIssd05 
				- ItemBMIHist.BMIPTDCostIssd06 + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01 
				+ ItemBMIHist.BMIPTDCostRcvd02 + ItemBMIHist.BMIPTDCostRcvd03 + ItemBMIHist.BMIPTDCostRcvd04 
				+ ItemBMIHist.BMIPTDCostRcvd05 + ItemBMIHist.BMIPTDCostRcvd06 
			WHEN RIGHT(RTRIM(@initPer), 2) = '09' 
			THEN	ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 
				- ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 - ItemBMIHist.BMIPTDCOGS04
				- ItemBMIHist.BMIPTDCOGS05 - ItemBMIHist.BMIPTDCOGS06 - ItemBMIHist.BMIPTDCOGS07 
				+ ItemBMIHist.BMIPTDCostAdjd00 + ItemBMIHist.BMIPTDCostAdjd01 + ItemBMIHist.BMIPTDCostAdjd02
				+ ItemBMIHist.BMIPTDCostAdjd03 + ItemBMIHist.BMIPTDCostAdjd04 + ItemBMIHist.BMIPTDCostAdjd05 
				+ ItemBMIHist.BMIPTDCostAdjd06 + ItemBMIHist.BMIPTDCostAdjd07 - ItemBMIHist.BMIPTDCostIssd00 
				- ItemBMIHist.BMIPTDCostIssd01 - ItemBMIHist.BMIPTDCostIssd02 - ItemBMIHist.BMIPTDCostIssd03 
				- ItemBMIHist.BMIPTDCostIssd04 - ItemBMIHist.BMIPTDCostIssd05 - ItemBMIHist.BMIPTDCostIssd06 - ItemBMIHist.BMIPTDCostIssd07 + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01
			   + ItemBMIHist.BMIPTDCostRcvd02 + ItemBMIHist.BMIPTDCostRcvd03 + ItemBMIHist.BMIPTDCostRcvd04 + ItemBMIHist.BMIPTDCostRcvd05 + ItemBMIHist.BMIPTDCostRcvd06
			   + ItemBMIHist.BMIPTDCostRcvd07 
			 WHEN RIGHT(RTRIM(@initPer), 2) = '10' 
			  THEN ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 - ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 - ItemBMIHist.BMIPTDCOGS04
			   - ItemBMIHist.BMIPTDCOGS05 - ItemBMIHist.BMIPTDCOGS06 - ItemBMIHist.BMIPTDCOGS07 - ItemBMIHist.BMIPTDCOGS08 + ItemBMIHist.BMIPTDCostAdjd00 + ItemBMIHist.BMIPTDCostAdjd01
			   + ItemBMIHist.BMIPTDCostAdjd02 + ItemBMIHist.BMIPTDCostAdjd03 + ItemBMIHist.BMIPTDCostAdjd04 + ItemBMIHist.BMIPTDCostAdjd05 + ItemBMIHist.BMIPTDCostAdjd06
			   + ItemBMIHist.BMIPTDCostAdjd07 + ItemBMIHist.BMIPTDCostAdjd08 - ItemBMIHist.BMIPTDCostIssd00 - ItemBMIHist.BMIPTDCostIssd01 - ItemBMIHist.BMIPTDCostIssd02
			   - ItemBMIHist.BMIPTDCostIssd03 - ItemBMIHist.BMIPTDCostIssd04 - ItemBMIHist.BMIPTDCostIssd05 - ItemBMIHist.BMIPTDCostIssd06 - ItemBMIHist.BMIPTDCostIssd07
			   - ItemBMIHist.BMIPTDCostIssd08 + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01 + ItemBMIHist.BMIPTDCostRcvd02 + ItemBMIHist.BMIPTDCostRcvd03
			   + ItemBMIHist.BMIPTDCostRcvd04 + ItemBMIHist.BMIPTDCostRcvd05 + ItemBMIHist.BMIPTDCostRcvd06 + ItemBMIHist.BMIPTDCostRcvd07 + ItemBMIHist.BMIPTDCostRcvd08
			 WHEN RIGHT(RTRIM(@initPer), 2) = '11' 
			 THEN ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 - ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 - ItemBMIHist.BMIPTDCOGS04
			   - ItemBMIHist.BMIPTDCOGS05 - ItemBMIHist.BMIPTDCOGS06 - ItemBMIHist.BMIPTDCOGS07 - ItemBMIHist.BMIPTDCOGS08 - ItemBMIHist.BMIPTDCOGS09 + ItemBMIHist.BMIPTDCostAdjd00
			   + ItemBMIHist.BMIPTDCostAdjd01 + ItemBMIHist.BMIPTDCostAdjd02 + ItemBMIHist.BMIPTDCostAdjd03 + ItemBMIHist.BMIPTDCostAdjd04 + ItemBMIHist.BMIPTDCostAdjd05
			   + ItemBMIHist.BMIPTDCostAdjd06 + ItemBMIHist.BMIPTDCostAdjd07 + ItemBMIHist.BMIPTDCostAdjd08 + ItemBMIHist.BMIPTDCostAdjd09 - ItemBMIHist.BMIPTDCostIssd00
			   - ItemBMIHist.BMIPTDCostIssd01 - ItemBMIHist.BMIPTDCostIssd02 - ItemBMIHist.BMIPTDCostIssd03 - ItemBMIHist.BMIPTDCostIssd04 - ItemBMIHist.BMIPTDCostIssd05
			   - ItemBMIHist.BMIPTDCostIssd06 - ItemBMIHist.BMIPTDCostIssd07 - ItemBMIHist.BMIPTDCostIssd08 - ItemBMIHist.BMIPTDCostIssd09 + ItemBMIHist.BMIPTDCostRcvd00
			   + ItemBMIHist.BMIPTDCostRcvd01 + ItemBMIHist.BMIPTDCostRcvd02 + ItemBMIHist.BMIPTDCostRcvd03 + ItemBMIHist.BMIPTDCostRcvd04 + ItemBMIHist.BMIPTDCostRcvd05
			   + ItemBMIHist.BMIPTDCostRcvd06 + ItemBMIHist.BMIPTDCostRcvd07 + ItemBMIHist.BMIPTDCostRcvd08 + ItemBMIHist.BMIPTDCostRcvd09 
			 WHEN RIGHT(RTRIM(@initPer),2) = '12' 
			 THEN ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 - ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 - ItemBMIHist.BMIPTDCOGS04
			   - ItemBMIHist.BMIPTDCOGS05 - ItemBMIHist.BMIPTDCOGS06 - ItemBMIHist.BMIPTDCOGS07 - ItemBMIHist.BMIPTDCOGS08 - ItemBMIHist.BMIPTDCOGS09 - ItemBMIHist.BMIPTDCOGS10
			   + ItemBMIHist.BMIPTDCostAdjd00 + ItemBMIHist.BMIPTDCostAdjd01 + ItemBMIHist.BMIPTDCostAdjd02 + ItemBMIHist.BMIPTDCostAdjd03 + ItemBMIHist.BMIPTDCostAdjd04
			   + ItemBMIHist.BMIPTDCostAdjd05 + ItemBMIHist.BMIPTDCostAdjd06 + ItemBMIHist.BMIPTDCostAdjd07 + ItemBMIHist.BMIPTDCostAdjd08 + ItemBMIHist.BMIPTDCostAdjd09
			   + ItemBMIHist.BMIPTDCostAdjd10 - ItemBMIHist.BMIPTDCostIssd00 - ItemBMIHist.BMIPTDCostIssd01 - ItemBMIHist.BMIPTDCostIssd02 - ItemBMIHist.BMIPTDCostIssd03
			   - ItemBMIHist.BMIPTDCostIssd04 - ItemBMIHist.BMIPTDCostIssd05 - ItemBMIHist.BMIPTDCostIssd06 - ItemBMIHist.BMIPTDCostIssd07 - ItemBMIHist.BMIPTDCostIssd08
			   - ItemBMIHist.BMIPTDCostIssd09 - ItemBMIHist.BMIPTDCostIssd10 + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01 + ItemBMIHist.BMIPTDCostRcvd02
			   + ItemBMIHist.BMIPTDCostRcvd03 + ItemBMIHist.BMIPTDCostRcvd04 + ItemBMIHist.BMIPTDCostRcvd05 + ItemBMIHist.BMIPTDCostRcvd06 + ItemBMIHist.BMIPTDCostRcvd07
			   + ItemBMIHist.BMIPTDCostRcvd08 + ItemBMIHist.BMIPTDCostRcvd09 + ItemBMIHist.BMIPTDCostRcvd10 
			  WHEN RIGHT(RTRIM(@initPer), 2) = '13' 
			  THEN ItemBMIHist.BMIBegBal - ItemBMIHist.BMIPTDCOGS00 - ItemBMIHist.BMIPTDCOGS01 - ItemBMIHist.BMIPTDCOGS02 - ItemBMIHist.BMIPTDCOGS03 - ItemBMIHist.BMIPTDCOGS04
			   - ItemBMIHist.BMIPTDCOGS05 - ItemBMIHist.BMIPTDCOGS06 - ItemBMIHist.BMIPTDCOGS07 - ItemBMIHist.BMIPTDCOGS08 - ItemBMIHist.BMIPTDCOGS09 - ItemBMIHist.BMIPTDCOGS10
			   - ItemBMIHist.BMIPTDCOGS11 + ItemBMIHist.BMIPTDCostAdjd00 + ItemBMIHist.BMIPTDCostAdjd01 + ItemBMIHist.BMIPTDCostAdjd02 + ItemBMIHist.BMIPTDCostAdjd03
			   + ItemBMIHist.BMIPTDCostAdjd04 + ItemBMIHist.BMIPTDCostAdjd05 + ItemBMIHist.BMIPTDCostAdjd06 + ItemBMIHist.BMIPTDCostAdjd07 + ItemBMIHist.BMIPTDCostAdjd08
			   + ItemBMIHist.BMIPTDCostAdjd09 + ItemBMIHist.BMIPTDCostAdjd10 + ItemBMIHist.BMIPTDCostAdjd11 - ItemBMIHist.BMIPTDCostIssd00 - ItemBMIHist.BMIPTDCostIssd01
			   - ItemBMIHist.BMIPTDCostIssd02 - ItemBMIHist.BMIPTDCostIssd03 - ItemBMIHist.BMIPTDCostIssd04 - ItemBMIHist.BMIPTDCostIssd05 - ItemBMIHist.BMIPTDCostIssd06
			   - ItemBMIHist.BMIPTDCostIssd07 - ItemBMIHist.BMIPTDCostIssd08 - ItemBMIHist.BMIPTDCostIssd09 - ItemBMIHist.BMIPTDCostIssd10 - ItemBMIHist.BMIPTDCostIssd11
			   + ItemBMIHist.BMIPTDCostRcvd00 + ItemBMIHist.BMIPTDCostRcvd01 + ItemBMIHist.BMIPTDCostRcvd02 + ItemBMIHist.BMIPTDCostRcvd03 + ItemBMIHist.BMIPTDCostRcvd04
			   + ItemBMIHist.BMIPTDCostRcvd05 + ItemBMIHist.BMIPTDCostRcvd06 + ItemBMIHist.BMIPTDCostRcvd07 + ItemBMIHist.BMIPTDCostRcvd08 + ItemBMIHist.BMIPTDCostRcvd09
			   + ItemBMIHist.BMIPTDCostRcvd10 + ItemBMIHist.BMIPTDCostRcvd11 
			 END AS BMIBegBal, 
			 
			 CASE WHEN ItemHist.InvtID	IS NULL 
										OR SubString(LTRIM(@initPer), 1, 4) <> ItemHist.FiscYr 
										OR Inventory.ValMthd = 'U' 
					THEN 0 
				  WHEN RIGHT(RTRIM(@initPer), 2) = '01' 
					THEN ItemHist.BegBal 
				  WHEN RIGHT(RTRIM(@initPer), 2) = '02' 
					THEN ItemHist.BegBal - ItemHist.PTDCOGS00 
						+ CASE 
							WHEN @shortAnswer = 'TRUE'
								THEN ItemHist.PTDDShpSls00 
							ELSE 0 
						END + ItemHist.PTDCostAdjd00 - ItemHist.PTDCostIssd00 + ItemHist.PTDCostRcvd00 
							+ ItemHist.PTDCostTrsfrIn00 - ItemHist.PTDCostTrsfrOut00 
				  WHEN RIGHT(RTRIM(@initPer), 2) = '03' 
					THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 
						+ CASE 
							WHEN @shortAnswer = 'TRUE' 
								THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01
							ELSE 0 
						END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01 - ItemHist.PTDCostIssd00 - ItemHist.PTDCostIssd01 + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01
							+ ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01 
				WHEN RIGHT(RTRIM(@initPer), 2) = '04' 
					THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 
						+ CASE WHEN @shortAnswer = 'TRUE' 
							    THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02 
							   ELSE 0 
						END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01 + ItemHist.PTDCostAdjd02 - ItemHist.PTDCostIssd00
							- ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02 + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01 
							+ ItemHist.PTDCostRcvd02 + ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 + ItemHist.PTDCostTrsfrIn02 - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01 - ItemHist.PTDCostTrsfrOut02 
				WHEN RIGHT(RTRIM(@initPer), 2)  = '05' 
					THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 
						+ CASE WHEN @shortAnswer = 'TRUE' 
								THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02 + ItemHist.PTDDShpSls03 
							   ELSE 0 
						END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01
			   + ItemHist.PTDCostAdjd02 + ItemHist.PTDCostAdjd03 - ItemHist.PTDCostIssd00 - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02 - ItemHist.PTDCostIssd03 + ItemHist.PTDCostRcvd00
			   + ItemHist.PTDCostRcvd01 + ItemHist.PTDCostRcvd02 + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 + ItemHist.PTDCostTrsfrIn02
			   + ItemHist.PTDCostTrsfrIn03 - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01 - ItemHist.PTDCostTrsfrOut02 - ItemHist.PTDCostTrsfrOut03 WHEN RIGHT(RTRIM(@initPer),
			   2) 
			  = '06' THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 - ItemHist.PTDCOGS04 + CASE WHEN @shortAnswer
			   = 'TRUE' THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02 + ItemHist.PTDDShpSls03 + ItemHist.PTDDShpSls04 ELSE 0 END + ItemHist.PTDCostAdjd00
			   + ItemHist.PTDCostAdjd01 + ItemHist.PTDCostAdjd02 + ItemHist.PTDCostAdjd03 + ItemHist.PTDCostAdjd04 - ItemHist.PTDCostIssd00 - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02
			   - ItemHist.PTDCostIssd03 - ItemHist.PTDCostIssd04 + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01 + ItemHist.PTDCostRcvd02 + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostRcvd04
			   + ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 + ItemHist.PTDCostTrsfrIn02 + ItemHist.PTDCostTrsfrIn03 + ItemHist.PTDCostTrsfrIn04 - ItemHist.PTDCostTrsfrOut00
			   - ItemHist.PTDCostTrsfrOut01 - ItemHist.PTDCostTrsfrOut02 - ItemHist.PTDCostTrsfrOut03 - ItemHist.PTDCostTrsfrOut04 WHEN RIGHT(RTRIM(@initPer),
			   2) 
			  = '07' THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 - ItemHist.PTDCOGS04 - ItemHist.PTDCOGS05
			   + CASE WHEN @shortAnswer = 'TRUE' THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02 + ItemHist.PTDDShpSls03 + ItemHist.PTDDShpSls04
			   + ItemHist.PTDDShpSls05 ELSE 0 END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01 + ItemHist.PTDCostAdjd02 + ItemHist.PTDCostAdjd03 + ItemHist.PTDCostAdjd04
			   + ItemHist.PTDCostAdjd05 - ItemHist.PTDCostIssd00 - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02 - ItemHist.PTDCostIssd03 - ItemHist.PTDCostIssd04 - ItemHist.PTDCostIssd05
			   + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01 + ItemHist.PTDCostRcvd02 + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostRcvd04 + ItemHist.PTDCostRcvd05 +
			   ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 + ItemHist.PTDCostTrsfrIn02 + ItemHist.PTDCostTrsfrIn03 + ItemHist.PTDCostTrsfrIn04 + ItemHist.PTDCostTrsfrIn05
			   - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01 - ItemHist.PTDCostTrsfrOut02 - ItemHist.PTDCostTrsfrOut03 - ItemHist.PTDCostTrsfrOut04 - ItemHist.PTDCostTrsfrOut05
			   WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '08' THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 - ItemHist.PTDCOGS04 - ItemHist.PTDCOGS05
			   - ItemHist.PTDCOGS06 + CASE WHEN @shortAnswer = 'TRUE' THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02 + ItemHist.PTDDShpSls03
			   + ItemHist.PTDDShpSls04 + ItemHist.PTDDShpSls05 + ItemHist.PTDDShpSls06 ELSE 0 END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01 + ItemHist.PTDCostAdjd02
			   + ItemHist.PTDCostAdjd03 + ItemHist.PTDCostAdjd04 + ItemHist.PTDCostAdjd05 + ItemHist.PTDCostAdjd06 - ItemHist.PTDCostIssd00 - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02
			   - ItemHist.PTDCostIssd03 - ItemHist.PTDCostIssd04 - ItemHist.PTDCostIssd05 - ItemHist.PTDCostIssd06 + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01 + ItemHist.PTDCostRcvd02
			   + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostRcvd04 + ItemHist.PTDCostRcvd05 + ItemHist.PTDCostRcvd06 + ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01
			   + ItemHist.PTDCostTrsfrIn02 + ItemHist.PTDCostTrsfrIn03 + ItemHist.PTDCostTrsfrIn04 + ItemHist.PTDCostTrsfrIn05 + ItemHist.PTDCostTrsfrIn06 - ItemHist.PTDCostTrsfrOut00
			   - ItemHist.PTDCostTrsfrOut01 - ItemHist.PTDCostTrsfrOut02 - ItemHist.PTDCostTrsfrOut03 - ItemHist.PTDCostTrsfrOut04 - ItemHist.PTDCostTrsfrOut05 - ItemHist.PTDCostTrsfrOut06
			   WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '09' THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 - ItemHist.PTDCOGS04 - ItemHist.PTDCOGS05
			   - ItemHist.PTDCOGS06 - ItemHist.PTDCOGS07 + CASE WHEN @shortAnswer = 'TRUE' THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02
			   + ItemHist.PTDDShpSls03 + ItemHist.PTDDShpSls04 + ItemHist.PTDDShpSls05 + ItemHist.PTDDShpSls06 + ItemHist.PTDDShpSls07 ELSE 0 END + ItemHist.PTDCostAdjd00
			   + ItemHist.PTDCostAdjd01 + ItemHist.PTDCostAdjd02 + ItemHist.PTDCostAdjd03 + ItemHist.PTDCostAdjd04 + ItemHist.PTDCostAdjd05 + ItemHist.PTDCostAdjd06 + ItemHist.PTDCostAdjd07
			   - ItemHist.PTDCostIssd00 - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02 - ItemHist.PTDCostIssd03 - ItemHist.PTDCostIssd04 - ItemHist.PTDCostIssd05 - ItemHist.PTDCostIssd06
			   - ItemHist.PTDCostIssd07 + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01 + ItemHist.PTDCostRcvd02 + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostRcvd04 + ItemHist.PTDCostRcvd05
			   + ItemHist.PTDCostRcvd06 + ItemHist.PTDCostRcvd07 + ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 + ItemHist.PTDCostTrsfrIn02 + ItemHist.PTDCostTrsfrIn03
			   + ItemHist.PTDCostTrsfrIn04 + ItemHist.PTDCostTrsfrIn05 + ItemHist.PTDCostTrsfrIn06 + ItemHist.PTDCostTrsfrIn07 - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01
			   - ItemHist.PTDCostTrsfrOut02 - ItemHist.PTDCostTrsfrOut03 - ItemHist.PTDCostTrsfrOut04 - ItemHist.PTDCostTrsfrOut05 - ItemHist.PTDCostTrsfrOut06 - ItemHist.PTDCostTrsfrOut07
			   WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '10' THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 - ItemHist.PTDCOGS04 - ItemHist.PTDCOGS05
			   - ItemHist.PTDCOGS06 - ItemHist.PTDCOGS07 - ItemHist.PTDCOGS08 + CASE WHEN @shortAnswer = 'TRUE' THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01
			   + ItemHist.PTDDShpSls02 + ItemHist.PTDDShpSls03 + ItemHist.PTDDShpSls04 + ItemHist.PTDDShpSls05 + ItemHist.PTDDShpSls06 + ItemHist.PTDDShpSls07 + ItemHist.PTDDShpSls08
			   ELSE 0 END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01 + ItemHist.PTDCostAdjd02 + ItemHist.PTDCostAdjd03 + ItemHist.PTDCostAdjd04 + ItemHist.PTDCostAdjd05
			   + ItemHist.PTDCostAdjd06 + ItemHist.PTDCostAdjd07 + ItemHist.PTDCostAdjd08 - ItemHist.PTDCostIssd00 - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02 - ItemHist.PTDCostIssd03
			   - ItemHist.PTDCostIssd04 - ItemHist.PTDCostIssd05 - ItemHist.PTDCostIssd06 - ItemHist.PTDCostIssd07 - ItemHist.PTDCostIssd08 + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01
			   + ItemHist.PTDCostRcvd02 + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostRcvd04 + ItemHist.PTDCostRcvd05 + ItemHist.PTDCostRcvd06 + ItemHist.PTDCostRcvd07 +
			   ItemHist.PTDCostRcvd08 + ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 + ItemHist.PTDCostTrsfrIn02 + ItemHist.PTDCostTrsfrIn03 + ItemHist.PTDCostTrsfrIn04
			   + ItemHist.PTDCostTrsfrIn05 + ItemHist.PTDCostTrsfrIn06 + ItemHist.PTDCostTrsfrIn07 + ItemHist.PTDCostTrsfrIn08 - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01
			   - ItemHist.PTDCostTrsfrOut02 - ItemHist.PTDCostTrsfrOut03 - ItemHist.PTDCostTrsfrOut04 - ItemHist.PTDCostTrsfrOut05 - ItemHist.PTDCostTrsfrOut06 - ItemHist.PTDCostTrsfrOut07
			   - ItemHist.PTDCostTrsfrOut08 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '11' THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 - ItemHist.PTDCOGS04 - ItemHist.PTDCOGS05
			   - ItemHist.PTDCOGS06 - ItemHist.PTDCOGS07 - ItemHist.PTDCOGS08 - ItemHist.PTDCOGS09 + CASE WHEN @shortAnswer = 'TRUE' THEN ItemHist.PTDDShpSls00
			   + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02 + ItemHist.PTDDShpSls03 + ItemHist.PTDDShpSls04 + ItemHist.PTDDShpSls05 + ItemHist.PTDDShpSls06 + ItemHist.PTDDShpSls07
			   + ItemHist.PTDDShpSls08 + ItemHist.PTDDShpSls09 ELSE 0 END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01 + ItemHist.PTDCostAdjd02 + ItemHist.PTDCostAdjd03
			   + ItemHist.PTDCostAdjd04 + ItemHist.PTDCostAdjd05 + ItemHist.PTDCostAdjd06 + ItemHist.PTDCostAdjd07 + ItemHist.PTDCostAdjd08 + ItemHist.PTDCostAdjd09 - ItemHist.PTDCostIssd00
			   - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02 - ItemHist.PTDCostIssd03 - ItemHist.PTDCostIssd04 - ItemHist.PTDCostIssd05 - ItemHist.PTDCostIssd06 - ItemHist.PTDCostIssd07
			   - ItemHist.PTDCostIssd08 - ItemHist.PTDCostIssd09 + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01 + ItemHist.PTDCostRcvd02 + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostRcvd04
			   + ItemHist.PTDCostRcvd05 + ItemHist.PTDCostRcvd06 + ItemHist.PTDCostRcvd07 + ItemHist.PTDCostRcvd08 + ItemHist.PTDCostRcvd09 + ItemHist.PTDCostTrsfrIn00
			   + ItemHist.PTDCostTrsfrIn01 + ItemHist.PTDCostTrsfrIn02 + ItemHist.PTDCostTrsfrIn03 + ItemHist.PTDCostTrsfrIn04 + ItemHist.PTDCostTrsfrIn05 + ItemHist.PTDCostTrsfrIn06
			   + ItemHist.PTDCostTrsfrIn07 + ItemHist.PTDCostTrsfrIn08 + ItemHist.PTDCostTrsfrIn09 - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01 - ItemHist.PTDCostTrsfrOut02
			   - ItemHist.PTDCostTrsfrOut03 - ItemHist.PTDCostTrsfrOut04 - ItemHist.PTDCostTrsfrOut05 - ItemHist.PTDCostTrsfrOut06 - ItemHist.PTDCostTrsfrOut07 - ItemHist.PTDCostTrsfrOut08
			   - ItemHist.PTDCostTrsfrOut09 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '12' THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 - ItemHist.PTDCOGS04 - ItemHist.PTDCOGS05
			   - ItemHist.PTDCOGS06 - ItemHist.PTDCOGS07 - ItemHist.PTDCOGS08 - ItemHist.PTDCOGS09 - ItemHist.PTDCOGS10 + CASE WHEN @shortAnswer = 'TRUE'
			   THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02 + ItemHist.PTDDShpSls03 + ItemHist.PTDDShpSls04 + ItemHist.PTDDShpSls05 + ItemHist.PTDDShpSls06
			   + ItemHist.PTDDShpSls07 + ItemHist.PTDDShpSls08 + ItemHist.PTDDShpSls09 + ItemHist.PTDDShpSls10 ELSE 0 END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01
			   + ItemHist.PTDCostAdjd02 + ItemHist.PTDCostAdjd03 + ItemHist.PTDCostAdjd04 + ItemHist.PTDCostAdjd05 + ItemHist.PTDCostAdjd06 + ItemHist.PTDCostAdjd07 + ItemHist.PTDCostAdjd08
			   + ItemHist.PTDCostAdjd09 + ItemHist.PTDCostAdjd10 - ItemHist.PTDCostIssd00 - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02 - ItemHist.PTDCostIssd03 - ItemHist.PTDCostIssd04
			   - ItemHist.PTDCostIssd05 - ItemHist.PTDCostIssd06 - ItemHist.PTDCostIssd07 - ItemHist.PTDCostIssd08 - ItemHist.PTDCostIssd09 - ItemHist.PTDCostIssd10 + ItemHist.PTDCostRcvd00
			   + ItemHist.PTDCostRcvd01 + ItemHist.PTDCostRcvd02 + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostRcvd04 + ItemHist.PTDCostRcvd05 + ItemHist.PTDCostRcvd06 +
			   ItemHist.PTDCostRcvd07 + ItemHist.PTDCostRcvd08 + ItemHist.PTDCostRcvd09 + ItemHist.PTDCostRcvd10 + ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 +
			   ItemHist.PTDCostTrsfrIn02 + ItemHist.PTDCostTrsfrIn03 + ItemHist.PTDCostTrsfrIn04 + ItemHist.PTDCostTrsfrIn05 + ItemHist.PTDCostTrsfrIn06 + ItemHist.PTDCostTrsfrIn07
			   + ItemHist.PTDCostTrsfrIn08 + ItemHist.PTDCostTrsfrIn09 + ItemHist.PTDCostTrsfrIn10 - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01 - ItemHist.PTDCostTrsfrOut02
			   - ItemHist.PTDCostTrsfrOut03 - ItemHist.PTDCostTrsfrOut04 - ItemHist.PTDCostTrsfrOut05 - ItemHist.PTDCostTrsfrOut06 - ItemHist.PTDCostTrsfrOut07 - ItemHist.PTDCostTrsfrOut08
			   - ItemHist.PTDCostTrsfrOut09 - ItemHist.PTDCostTrsfrOut10 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '13' THEN ItemHist.BegBal - ItemHist.PTDCOGS00 - ItemHist.PTDCOGS01 - ItemHist.PTDCOGS02 - ItemHist.PTDCOGS03 - ItemHist.PTDCOGS04 - ItemHist.PTDCOGS05
			   - ItemHist.PTDCOGS06 - ItemHist.PTDCOGS07 - ItemHist.PTDCOGS08 - ItemHist.PTDCOGS09 - ItemHist.PTDCOGS10 - ItemHist.PTDCOGS11 + CASE WHEN @shortAnswer
			   = 'TRUE' THEN ItemHist.PTDDShpSls00 + ItemHist.PTDDShpSls01 + ItemHist.PTDDShpSls02 + ItemHist.PTDDShpSls03 + ItemHist.PTDDShpSls04 + ItemHist.PTDDShpSls05
			   + ItemHist.PTDDShpSls06 + ItemHist.PTDDShpSls07 + ItemHist.PTDDShpSls08 + ItemHist.PTDDShpSls09 + ItemHist.PTDDShpSls10 + ItemHist.PTDDShpSls11 ELSE 0
			   END + ItemHist.PTDCostAdjd00 + ItemHist.PTDCostAdjd01 + ItemHist.PTDCostAdjd02 + ItemHist.PTDCostAdjd03 + ItemHist.PTDCostAdjd04 + ItemHist.PTDCostAdjd05 +
			   ItemHist.PTDCostAdjd06 + ItemHist.PTDCostAdjd07 + ItemHist.PTDCostAdjd08 + ItemHist.PTDCostAdjd09 + ItemHist.PTDCostAdjd10 + ItemHist.PTDCostAdjd11 - ItemHist.PTDCostIssd00
			   - ItemHist.PTDCostIssd01 - ItemHist.PTDCostIssd02 - ItemHist.PTDCostIssd03 - ItemHist.PTDCostIssd04 - ItemHist.PTDCostIssd05 - ItemHist.PTDCostIssd06 - ItemHist.PTDCostIssd07
			   - ItemHist.PTDCostIssd08 - ItemHist.PTDCostIssd09 - ItemHist.PTDCostIssd10 - ItemHist.PTDCostIssd11 + ItemHist.PTDCostRcvd00 + ItemHist.PTDCostRcvd01 + ItemHist.PTDCostRcvd02
			   + ItemHist.PTDCostRcvd03 + ItemHist.PTDCostRcvd04 + ItemHist.PTDCostRcvd05 + ItemHist.PTDCostRcvd06 + ItemHist.PTDCostRcvd07 + ItemHist.PTDCostRcvd08 +
			   ItemHist.PTDCostRcvd09 + ItemHist.PTDCostRcvd10 + ItemHist.PTDCostRcvd11 + ItemHist.PTDCostTrsfrIn00 + ItemHist.PTDCostTrsfrIn01 + ItemHist.PTDCostTrsfrIn02
			   + ItemHist.PTDCostTrsfrIn03 + ItemHist.PTDCostTrsfrIn04 + ItemHist.PTDCostTrsfrIn05 + ItemHist.PTDCostTrsfrIn06 + ItemHist.PTDCostTrsfrIn07 + ItemHist.PTDCostTrsfrIn08
			   + ItemHist.PTDCostTrsfrIn09 + ItemHist.PTDCostTrsfrIn10 + ItemHist.PTDCostTrsfrIn11 - ItemHist.PTDCostTrsfrOut00 - ItemHist.PTDCostTrsfrOut01 - ItemHist.PTDCostTrsfrOut02
			   - ItemHist.PTDCostTrsfrOut03 - ItemHist.PTDCostTrsfrOut04 - ItemHist.PTDCostTrsfrOut05 - ItemHist.PTDCostTrsfrOut06 - ItemHist.PTDCostTrsfrOut07 - ItemHist.PTDCostTrsfrOut08
			   - ItemHist.PTDCostTrsfrOut09 - ItemHist.PTDCostTrsfrOut10 - ItemHist.PTDCostTrsfrOut11 END 
			   + CASE WHEN @shortAnswer = 'TRUE' 
						THEN
							(SELECT     COALESCE (SUM(YTDDShpSls), 0)
							FROM          ItemHist ItemHistTotal
							WHERE      ItemHistTotal.InvtID = ItemHist.InvtID AND ItemHistTotal.SiteID = ItemHist.SiteID AND ItemHistTotal.FiscYr < ItemHist.FiscYr)
					  ELSE 0 
				  END AS BegBal, 
			  CASE	WHEN Item2Hist.InvtID IS NULL OR LEFT(LTRIM(@initPer), 4) <> Item2Hist.FiscYr 
						THEN 0 
					WHEN RIGHT(RTRIM(@initPer), 2) = '01' 
						THEN Item2Hist.BegQty 
					WHEN RIGHT(RTRIM(@initPer), 2) = '02' 
						THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 
						+ CASE 
							WHEN @shortAnswer = 'TRUE' 
								THEN Item2Hist.PTDQtyDShpSls00 
							ELSE 0 
						END + Item2Hist.PTDQtyAdjd00 - Item2Hist.PTDQtyIssd00 + Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyTrsfrIn00 - Item2Hist.PTDQtyTrsfrOut00 
							WHEN RIGHT(RTRIM(@initPer), 2) = '03' 
								THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 
								+ CASE	WHEN @shortAnswer = 'TRUE' 
											THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01 
										ELSE 0 
								END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01 
									+ Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01
									- Item2Hist.PTDQtyTrsfrOut00 - Item2Hist.PTDQtyTrsfrOut01 
								WHEN RIGHT(RTRIM(@initPer),
			   2) 
			  = '04' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 + CASE WHEN @shortAnswer = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00
			   + Item2Hist.PTDQtyDShpSls01 + Item2Hist.PTDQtyDShpSls02 ELSE 0 END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 - Item2Hist.PTDQtyIssd00
			   - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02 + Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyTrsfrIn00 +
			   Item2Hist.PTDQtyTrsfrIn01 + Item2Hist.PTDQtyTrsfrIn02 - Item2Hist.PTDQtyTrsfrOut00 - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 WHEN RIGHT(RTRIM(@initPer),
			   2) 
			  = '05' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 + CASE WHEN @shortAnswer
			   = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01 + Item2Hist.PTDQtyDShpSls02 + Item2Hist.PTDQtyDShpSls03 ELSE 0 END + Item2Hist.PTDQtyAdjd00
			   + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 + Item2Hist.PTDQtyAdjd03 - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02 - Item2Hist.PTDQtyIssd03
			   + Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03 + Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01
			   + Item2Hist.PTDQtyTrsfrIn02 + Item2Hist.PTDQtyTrsfrIn03 - Item2Hist.PTDQtyTrsfrOut00 - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03
			   WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '06' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 - Item2Hist.PTDQtySls04 + CASE WHEN
			   @shortAnswer = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01 + Item2Hist.PTDQtyDShpSls02 + Item2Hist.PTDQtyDShpSls03
			   + Item2Hist.PTDQtyDShpSls04 ELSE 0 END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 + Item2Hist.PTDQtyAdjd03 + Item2Hist.PTDQtyAdjd04
			   - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02 - Item2Hist.PTDQtyIssd03 - Item2Hist.PTDQtyIssd04 + Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyRcvd01
			   + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03 + Item2Hist.PTDQtyRcvd04 + Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01 + Item2Hist.PTDQtyTrsfrIn02
			   + Item2Hist.PTDQtyTrsfrIn03 + Item2Hist.PTDQtyTrsfrIn04 - Item2Hist.PTDQtyTrsfrOut00 - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03
			   - Item2Hist.PTDQtyTrsfrOut04 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '07' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 - Item2Hist.PTDQtySls04 - Item2Hist.PTDQtySls05
			   + CASE WHEN @shortAnswer = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01 + Item2Hist.PTDQtyDShpSls02 + Item2Hist.PTDQtyDShpSls03
			   + Item2Hist.PTDQtyDShpSls04 + Item2Hist.PTDQtyDShpSls05 ELSE 0 END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 + Item2Hist.PTDQtyAdjd03
			   + Item2Hist.PTDQtyAdjd04 + Item2Hist.PTDQtyAdjd05 - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02 - Item2Hist.PTDQtyIssd03 - Item2Hist.PTDQtyIssd04
			   - Item2Hist.PTDQtyIssd05 + Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03 + Item2Hist.PTDQtyRcvd04 +
			   Item2Hist.PTDQtyRcvd05 + Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01 + Item2Hist.PTDQtyTrsfrIn02 + Item2Hist.PTDQtyTrsfrIn03 + Item2Hist.PTDQtyTrsfrIn04
			   + Item2Hist.PTDQtyTrsfrIn05 - Item2Hist.PTDQtyTrsfrOut00 - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03 - Item2Hist.PTDQtyTrsfrOut04
			   - Item2Hist.PTDQtyTrsfrOut05 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '08' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 - Item2Hist.PTDQtySls04 - Item2Hist.PTDQtySls05
			   - Item2Hist.PTDQtySls06 + CASE WHEN @shortAnswer = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01 + Item2Hist.PTDQtyDShpSls02
			   + Item2Hist.PTDQtyDShpSls03 + Item2Hist.PTDQtyDShpSls04 + Item2Hist.PTDQtyDShpSls05 + Item2Hist.PTDQtyDShpSls06 ELSE 0 END + Item2Hist.PTDQtyAdjd00 +
			   Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 + Item2Hist.PTDQtyAdjd03 + Item2Hist.PTDQtyAdjd04 + Item2Hist.PTDQtyAdjd05 + Item2Hist.PTDQtyAdjd06 - Item2Hist.PTDQtyIssd00
			   - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02 - Item2Hist.PTDQtyIssd03 - Item2Hist.PTDQtyIssd04 - Item2Hist.PTDQtyIssd05 - Item2Hist.PTDQtyIssd06 + Item2Hist.PTDQtyRcvd00
			   + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03 + Item2Hist.PTDQtyRcvd04 + Item2Hist.PTDQtyRcvd05 + Item2Hist.PTDQtyRcvd06 +
			   Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01 + Item2Hist.PTDQtyTrsfrIn02 + Item2Hist.PTDQtyTrsfrIn03 + Item2Hist.PTDQtyTrsfrIn04 + Item2Hist.PTDQtyTrsfrIn05
			   + Item2Hist.PTDQtyTrsfrIn06 - Item2Hist.PTDQtyTrsfrOut00 - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03 - Item2Hist.PTDQtyTrsfrOut04
			   - Item2Hist.PTDQtyTrsfrOut05 - Item2Hist.PTDQtyTrsfrOut06 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '09' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 - Item2Hist.PTDQtySls04 - Item2Hist.PTDQtySls05
			   - Item2Hist.PTDQtySls06 - Item2Hist.PTDQtySls07 + CASE WHEN @shortAnswer = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01
			   + Item2Hist.PTDQtyDShpSls02 + Item2Hist.PTDQtyDShpSls03 + Item2Hist.PTDQtyDShpSls04 + Item2Hist.PTDQtyDShpSls05 + Item2Hist.PTDQtyDShpSls06 + Item2Hist.PTDQtyDShpSls07
			   ELSE 0 END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 + Item2Hist.PTDQtyAdjd03 + Item2Hist.PTDQtyAdjd04 + Item2Hist.PTDQtyAdjd05
			   + Item2Hist.PTDQtyAdjd06 + Item2Hist.PTDQtyAdjd07 - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02 - Item2Hist.PTDQtyIssd03 - Item2Hist.PTDQtyIssd04
			   - Item2Hist.PTDQtyIssd05 - Item2Hist.PTDQtyIssd06 - Item2Hist.PTDQtyIssd07 + Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03
			   + Item2Hist.PTDQtyRcvd04 + Item2Hist.PTDQtyRcvd05 + Item2Hist.PTDQtyRcvd06 + Item2Hist.PTDQtyRcvd07 + Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01
			   + Item2Hist.PTDQtyTrsfrIn02 + Item2Hist.PTDQtyTrsfrIn03 + Item2Hist.PTDQtyTrsfrIn04 + Item2Hist.PTDQtyTrsfrIn05 + Item2Hist.PTDQtyTrsfrIn06 + Item2Hist.PTDQtyTrsfrIn07
			   - Item2Hist.PTDQtyTrsfrOut00 - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03 - Item2Hist.PTDQtyTrsfrOut04 - Item2Hist.PTDQtyTrsfrOut05
			   - Item2Hist.PTDQtyTrsfrOut06 - Item2Hist.PTDQtyTrsfrOut07 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '10' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 - Item2Hist.PTDQtySls04 - Item2Hist.PTDQtySls05
			   - Item2Hist.PTDQtySls06 - Item2Hist.PTDQtySls07 - Item2Hist.PTDQtySls08 + CASE WHEN @shortAnswer = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01
			   + Item2Hist.PTDQtyDShpSls02 + Item2Hist.PTDQtyDShpSls03 + Item2Hist.PTDQtyDShpSls04 + Item2Hist.PTDQtyDShpSls05 + Item2Hist.PTDQtyDShpSls06 + Item2Hist.PTDQtyDShpSls07
			   + Item2Hist.PTDQtyDShpSls08 ELSE 0 END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 + Item2Hist.PTDQtyAdjd03 + Item2Hist.PTDQtyAdjd04
			   + Item2Hist.PTDQtyAdjd05 + Item2Hist.PTDQtyAdjd06 + Item2Hist.PTDQtyAdjd07 + Item2Hist.PTDQtyAdjd08 - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02
			   - Item2Hist.PTDQtyIssd03 - Item2Hist.PTDQtyIssd04 - Item2Hist.PTDQtyIssd05 - Item2Hist.PTDQtyIssd06 - Item2Hist.PTDQtyIssd07 - Item2Hist.PTDQtyIssd08 + Item2Hist.PTDQtyRcvd00
			   + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03 + Item2Hist.PTDQtyRcvd04 + Item2Hist.PTDQtyRcvd05 + Item2Hist.PTDQtyRcvd06 +
			   Item2Hist.PTDQtyRcvd07 + Item2Hist.PTDQtyRcvd08 + Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01 + Item2Hist.PTDQtyTrsfrIn02 + Item2Hist.PTDQtyTrsfrIn03
			   + Item2Hist.PTDQtyTrsfrIn04 + Item2Hist.PTDQtyTrsfrIn05 + Item2Hist.PTDQtyTrsfrIn06 + Item2Hist.PTDQtyTrsfrIn07 + Item2Hist.PTDQtyTrsfrIn08 - Item2Hist.PTDQtyTrsfrOut00
			   - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03 - Item2Hist.PTDQtyTrsfrOut04 - Item2Hist.PTDQtyTrsfrOut05 - Item2Hist.PTDQtyTrsfrOut06
			   - Item2Hist.PTDQtyTrsfrOut07 - Item2Hist.PTDQtyTrsfrOut08 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '11' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 - Item2Hist.PTDQtySls04 - Item2Hist.PTDQtySls05
			   - Item2Hist.PTDQtySls06 - Item2Hist.PTDQtySls07 - Item2Hist.PTDQtySls08 - Item2Hist.PTDQtySls09 + CASE WHEN @shortAnswer = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00
			   + Item2Hist.PTDQtyDShpSls01 + Item2Hist.PTDQtyDShpSls02 + Item2Hist.PTDQtyDShpSls03 + Item2Hist.PTDQtyDShpSls04 + Item2Hist.PTDQtyDShpSls05 + Item2Hist.PTDQtyDShpSls06
			   + Item2Hist.PTDQtyDShpSls07 + Item2Hist.PTDQtyDShpSls08 + Item2Hist.PTDQtyDShpSls09 ELSE 0 END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02
			   + Item2Hist.PTDQtyAdjd03 + Item2Hist.PTDQtyAdjd04 + Item2Hist.PTDQtyAdjd05 + Item2Hist.PTDQtyAdjd06 + Item2Hist.PTDQtyAdjd07 + Item2Hist.PTDQtyAdjd08 + Item2Hist.PTDQtyAdjd09
			   - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02 - Item2Hist.PTDQtyIssd03 - Item2Hist.PTDQtyIssd04 - Item2Hist.PTDQtyIssd05 - Item2Hist.PTDQtyIssd06
			   - Item2Hist.PTDQtyIssd07 - Item2Hist.PTDQtyIssd08 - Item2Hist.PTDQtyIssd09 + Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03
			   + Item2Hist.PTDQtyRcvd04 + Item2Hist.PTDQtyRcvd05 + Item2Hist.PTDQtyRcvd06 + Item2Hist.PTDQtyRcvd07 + Item2Hist.PTDQtyRcvd08 + Item2Hist.PTDQtyRcvd09 +
			   Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01 + Item2Hist.PTDQtyTrsfrIn02 + Item2Hist.PTDQtyTrsfrIn03 + Item2Hist.PTDQtyTrsfrIn04 + Item2Hist.PTDQtyTrsfrIn05
			   + Item2Hist.PTDQtyTrsfrIn06 + Item2Hist.PTDQtyTrsfrIn07 + Item2Hist.PTDQtyTrsfrIn08 + Item2Hist.PTDQtyTrsfrIn09 - Item2Hist.PTDQtyTrsfrOut00 - Item2Hist.PTDQtyTrsfrOut01
			   - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03 - Item2Hist.PTDQtyTrsfrOut04 - Item2Hist.PTDQtyTrsfrOut05 - Item2Hist.PTDQtyTrsfrOut06 - Item2Hist.PTDQtyTrsfrOut07
			   - Item2Hist.PTDQtyTrsfrOut08 - Item2Hist.PTDQtyTrsfrOut09 WHEN RIGHT(RTRIM(@initPer), 2) 
			  = '12' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 - Item2Hist.PTDQtySls04 - Item2Hist.PTDQtySls05
			   - Item2Hist.PTDQtySls06 - Item2Hist.PTDQtySls07 - Item2Hist.PTDQtySls08 - Item2Hist.PTDQtySls09 - Item2Hist.PTDQtySls10 + CASE WHEN @shortAnswer
			   = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01 + Item2Hist.PTDQtyDShpSls02 + Item2Hist.PTDQtyDShpSls03 + Item2Hist.PTDQtyDShpSls04
			   + Item2Hist.PTDQtyDShpSls05 + Item2Hist.PTDQtyDShpSls06 + Item2Hist.PTDQtyDShpSls07 + Item2Hist.PTDQtyDShpSls08 + Item2Hist.PTDQtyDShpSls09 + Item2Hist.PTDQtyDShpSls10
			   ELSE 0 END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 + Item2Hist.PTDQtyAdjd03 + Item2Hist.PTDQtyAdjd04 + Item2Hist.PTDQtyAdjd05
			   + Item2Hist.PTDQtyAdjd06 + Item2Hist.PTDQtyAdjd07 + Item2Hist.PTDQtyAdjd08 + Item2Hist.PTDQtyAdjd09 + Item2Hist.PTDQtyAdjd10 - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01
			   - Item2Hist.PTDQtyIssd02 - Item2Hist.PTDQtyIssd03 - Item2Hist.PTDQtyIssd04 - Item2Hist.PTDQtyIssd05 - Item2Hist.PTDQtyIssd06 - Item2Hist.PTDQtyIssd07 - Item2Hist.PTDQtyIssd08
			   - Item2Hist.PTDQtyIssd09 - Item2Hist.PTDQtyIssd10 + Item2Hist.PTDQtyRcvd00 + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03 + Item2Hist.PTDQtyRcvd04
			   + Item2Hist.PTDQtyRcvd05 + Item2Hist.PTDQtyRcvd06 + Item2Hist.PTDQtyRcvd07 + Item2Hist.PTDQtyRcvd08 + Item2Hist.PTDQtyRcvd09 + Item2Hist.PTDQtyRcvd10 +
			   Item2Hist.PTDQtyTrsfrIn00 + Item2Hist.PTDQtyTrsfrIn01 + Item2Hist.PTDQtyTrsfrIn02 + Item2Hist.PTDQtyTrsfrIn03 + Item2Hist.PTDQtyTrsfrIn04 + Item2Hist.PTDQtyTrsfrIn05
			   + Item2Hist.PTDQtyTrsfrIn06 + Item2Hist.PTDQtyTrsfrIn07 + Item2Hist.PTDQtyTrsfrIn08 + Item2Hist.PTDQtyTrsfrIn09 + Item2Hist.PTDQtyTrsfrIn10 - Item2Hist.PTDQtyTrsfrOut00
			   - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03 - Item2Hist.PTDQtyTrsfrOut04 - Item2Hist.PTDQtyTrsfrOut05 - Item2Hist.PTDQtyTrsfrOut06
			   - Item2Hist.PTDQtyTrsfrOut07 - Item2Hist.PTDQtyTrsfrOut08 - Item2Hist.PTDQtyTrsfrOut09 - Item2Hist.PTDQtyTrsfrOut10 WHEN RIGHT(RTRIM(@initPer),
			   2) 
			  = '13' THEN Item2Hist.BegQty - Item2Hist.PTDQtySls00 - Item2Hist.PTDQtySls01 - Item2Hist.PTDQtySls02 - Item2Hist.PTDQtySls03 - Item2Hist.PTDQtySls04 - Item2Hist.PTDQtySls05
			   - Item2Hist.PTDQtySls06 - Item2Hist.PTDQtySls07 - Item2Hist.PTDQtySls08 - Item2Hist.PTDQtySls09 - Item2Hist.PTDQtySls10 - Item2Hist.PTDQtySls11 + CASE WHEN
			   @shortAnswer = 'TRUE' THEN Item2Hist.PTDQtyDShpSls00 + Item2Hist.PTDQtyDShpSls01 + Item2Hist.PTDQtyDShpSls02 + Item2Hist.PTDQtyDShpSls03
			   + Item2Hist.PTDQtyDShpSls04 + Item2Hist.PTDQtyDShpSls05 + Item2Hist.PTDQtyDShpSls06 + Item2Hist.PTDQtyDShpSls07 + Item2Hist.PTDQtyDShpSls08 + Item2Hist.PTDQtyDShpSls09
			   + Item2Hist.PTDQtyDShpSls10 + Item2Hist.PTDQtyDShpSls11 ELSE 0 END + Item2Hist.PTDQtyAdjd00 + Item2Hist.PTDQtyAdjd01 + Item2Hist.PTDQtyAdjd02 + Item2Hist.PTDQtyAdjd03
			   + Item2Hist.PTDQtyAdjd04 + Item2Hist.PTDQtyAdjd05 + Item2Hist.PTDQtyAdjd06 + Item2Hist.PTDQtyAdjd07 + Item2Hist.PTDQtyAdjd08 + Item2Hist.PTDQtyAdjd09 + Item2Hist.PTDQtyAdjd10
			   + Item2Hist.PTDQtyAdjd11 - Item2Hist.PTDQtyIssd00 - Item2Hist.PTDQtyIssd01 - Item2Hist.PTDQtyIssd02 - Item2Hist.PTDQtyIssd03 - Item2Hist.PTDQtyIssd04 - Item2Hist.PTDQtyIssd05
			   - Item2Hist.PTDQtyIssd06 - Item2Hist.PTDQtyIssd07 - Item2Hist.PTDQtyIssd08 - Item2Hist.PTDQtyIssd09 - Item2Hist.PTDQtyIssd10 - Item2Hist.PTDQtyIssd11 + Item2Hist.PTDQtyRcvd00
			   + Item2Hist.PTDQtyRcvd01 + Item2Hist.PTDQtyRcvd02 + Item2Hist.PTDQtyRcvd03 + Item2Hist.PTDQtyRcvd04 + Item2Hist.PTDQtyRcvd05 + Item2Hist.PTDQtyRcvd06 +
			   Item2Hist.PTDQtyRcvd07 + Item2Hist.PTDQtyRcvd08 + Item2Hist.PTDQtyRcvd09 + Item2Hist.PTDQtyRcvd10 + Item2Hist.PTDQtyRcvd11 + Item2Hist.PTDQtyTrsfrIn00 +
			   Item2Hist.PTDQtyTrsfrIn01 + Item2Hist.PTDQtyTrsfrIn02 + Item2Hist.PTDQtyTrsfrIn03 + Item2Hist.PTDQtyTrsfrIn04 + Item2Hist.PTDQtyTrsfrIn05 + Item2Hist.PTDQtyTrsfrIn06
			   + Item2Hist.PTDQtyTrsfrIn07 + Item2Hist.PTDQtyTrsfrIn08 + Item2Hist.PTDQtyTrsfrIn09 + Item2Hist.PTDQtyTrsfrIn10 + Item2Hist.PTDQtyTrsfrIn11 - Item2Hist.PTDQtyTrsfrOut00
			   - Item2Hist.PTDQtyTrsfrOut01 - Item2Hist.PTDQtyTrsfrOut02 - Item2Hist.PTDQtyTrsfrOut03 - Item2Hist.PTDQtyTrsfrOut04 - Item2Hist.PTDQtyTrsfrOut05 - Item2Hist.PTDQtyTrsfrOut06
			   - Item2Hist.PTDQtyTrsfrOut07 - Item2Hist.PTDQtyTrsfrOut08 - Item2Hist.PTDQtyTrsfrOut09 - Item2Hist.PTDQtyTrsfrOut10 - Item2Hist.PTDQtyTrsfrOut11 END + CASE WHEN
			   @shortAnswer = 'TRUE' THEN
				  (SELECT     COALESCE (SUM(YTDQtyDShpSls), 0)
					FROM          Item2Hist Item2HistTotal
					WHERE      Item2HistTotal.InvtID = Item2Hist.InvtID AND Item2HistTotal.SiteID = Item2Hist.SiteID AND Item2HistTotal.FiscYr < Item2Hist.FiscYr) 
			  ELSE 0 END AS BegQty, CASE WHEN ItemHist.FiscYr IS NULL THEN LEFT(@initPer, 4) ELSE ItemHist.FiscYr END AS FiscYr, 
			  CASE WHEN ItemHist.SiteID IS NULL THEN CASE WHEN INTran.SiteID IS NULL THEN Site.SiteID ELSE INTran.SiteID END ELSE ItemHist.SiteID END AS SiteID, 
			  CASE WHEN INTran.PerPost IS NULL THEN @initPer ELSE INTran.PerPost END AS PerPost, dbo.INTran.Acct, dbo.INTran.BMITranAmt, 
			  dbo.INTran.BMIUnitPrice, dbo.INTran.CnvFact, dbo.INTran.CostType, dbo.INTran.DrCr, dbo.INTran.ExtCost AS INTran_ExtCost, dbo.INTran.InvtMult, dbo.INTran.LineID, 
			  dbo.INTran.Qty AS INTran_Qty, dbo.INTran.RcptNbr, dbo.INTran.BatNbr, dbo.INTran.RefNbr, dbo.INTran.Rlsed, dbo.INTran.S4Future04, dbo.INTran.SpecificCostID, 
			  dbo.INTran.Sub, dbo.INTran.TranAmt, dbo.INTran.TranDate, dbo.INTran.TranDesc, dbo.INTran.TranType, dbo.INTran.UnitDesc, dbo.INTran.UnitPrice, 
			  dbo.INTran.UnitMultDiv, dbo.INTran.WhseLoc, CASE WHEN INTran.TranType IN ('AB', 'AC', 'AJ', 'PI') THEN CASE WHEN INTran.CnvFact IN (0, 1) 
			  THEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) WHEN INTran.UnitMultDiv = 'D' THEN Round((INTran.Qty * INTran.InvtMult) / INTran.CnvFact, D .DecPlQty) 
			  WHEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) <> 0 THEN Round((INTran.Qty * INTran.InvtMult) * INTran.CnvFact, D .DecPlQty) 
			  ELSE 0 END WHEN INTran.TranType = 'CM' AND INTran.S4Future09 = 1 AND INTran.Jrnltype = 'OM' AND Inventory.StkItem = 1 AND ISNULL(SOShipHeader.DropShip, 
			  0) = 0 THEN 0 WHEN INTran.TranType IN ('II', 'RI') OR
			  (INTran.TranType = 'AS' AND RTrim(INTran.KitID) <> '') THEN CASE WHEN INTran.CnvFact IN (0, 1) THEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  WHEN INTran.UnitMultDiv = 'D' THEN Round((INTran.Qty * INTran.InvtMult) / INTran.CnvFact, D .DecPlQty) WHEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  <> 0 THEN Round((INTran.Qty * INTran.InvtMult) * INTran.CnvFact, D .DecPlQty) ELSE 0 END WHEN INTran.TranType IN ('AS', 'RC') AND RTrim(INTran.KitID) 
			  = '' THEN CASE WHEN INTran.CnvFact IN (0, 1) THEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  WHEN INTran.UnitMultDiv = 'D' THEN Round((INTran.Qty * INTran.InvtMult) / INTran.CnvFact, D .DecPlQty) WHEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  <> 0 THEN Round((INTran.Qty * INTran.InvtMult) * INTran.CnvFact, D .DecPlQty) ELSE 0 END WHEN INTran.TranType IN ('CM', 'IN') OR
			  (INTran.TranType = 'DM' AND INTran.Jrnltype <> 'OM') THEN CASE WHEN INTran.CnvFact IN (0, 1) THEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  WHEN INTran.UnitMultDiv = 'D' THEN Round((INTran.Qty * INTran.InvtMult) / INTran.CnvFact, D .DecPlQty) WHEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  <> 0 THEN Round((INTran.Qty * INTran.InvtMult) * INTran.CnvFact, D .DecPlQty) ELSE 0 END WHEN INTran.TranType = 'TR' AND RTrim(INTran.ToSiteID) 
			  = '' THEN CASE WHEN INTran.CnvFact IN (0, 1) THEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  WHEN INTran.UnitMultDiv = 'D' THEN Round((INTran.Qty * INTran.InvtMult) / INTran.CnvFact, D .DecPlQty) WHEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  <> 0 THEN Round((INTran.Qty * INTran.InvtMult) * INTran.CnvFact, D .DecPlQty) ELSE 0 END WHEN INTran.TranType = 'TR' AND RTrim(INTran.ToSiteID) 
			  <> '' THEN CASE WHEN INTran.CnvFact IN (0, 1) THEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  WHEN INTran.UnitMultDiv = 'D' THEN Round((INTran.Qty * INTran.InvtMult) / INTran.CnvFact, D .DecPlQty) WHEN Round(INTran.Qty * INTran.InvtMult, D .DecPlQty) 
			  <> 0 THEN Round((INTran.Qty * INTran.InvtMult) * INTran.CnvFact, D .DecPlQty) ELSE 0 END ELSE 0 END AS Qty, CASE WHEN INTran.TranType IN ('AB', 'AC', 'AJ', 'PI') 
			  THEN Round(INTran.TranAmt * INTran.InvtMult, D .BaseDecPl) WHEN INTran.TranType = 'II' OR
			  (INTran.TranType = 'AS' AND RTrim(INTran.KitID) <> '') THEN Round(INTran.TranAmt * INTran.InvtMult, D .BaseDecPl) 
			  WHEN INTran.TranType = 'RI' THEN Round(INTran.ExtCost * INTran.InvtMult, D .BaseDecPl) WHEN INTran.TranType IN ('AS', 'RC') AND RTrim(INTran.KitID) 
			  = '' THEN Round(INTran.TranAmt * INTran.InvtMult, D .BaseDecPl) WHEN INTran.TranType IN ('CM', 'DM', 'IN') THEN Round(INTran.ExtCost * INTran.InvtMult, 
			  D .BaseDecPl) WHEN INTran.TranType = 'TR' AND RTrim(INTran.ToSiteID) = '' THEN Round(INTran.TranAmt * INTran.InvtMult, D .BaseDecPl) 
			  WHEN INTran.TranType = 'TR' AND RTrim(INTran.ToSiteID) <> '' THEN Round(INTran.TranAmt * INTran.InvtMult, D .BaseDecPl) ELSE 0 END AS ExtCost, 
			  CASE WHEN INTran.TranType IN ('AB', 'AC', 'AJ', 'PI') THEN Round(INTran.BMITranAmt * INTran.InvtMult, D .BaseDecPl) WHEN INTran.TranType = 'II' OR
			  (INTran.TranType = 'AS' AND RTrim(INTran.KitID) <> '') THEN Round(INTran.BMITranAmt * INTran.InvtMult, D .BaseDecPl) 
			  WHEN INTran.TranType = 'RI' THEN Round(INTran.BMIExtCost * INTran.InvtMult, D .BaseDecPl) WHEN INTran.TranType IN ('AS', 'RC') AND RTrim(INTran.KitID) 
			  = '' THEN Round(INTran.BMITranAmt * INTran.InvtMult, D .BaseDecPl) WHEN INTran.TranType IN ('CM', 'DM', 'IN') THEN Round(INTran.BMIExtCost * INTran.InvtMult, 
			  D .BaseDecPl) WHEN INTran.TranType = 'TR' AND RTrim(INTran.ToSiteID) = '' THEN Round(INTran.BMITranAmt * INTran.InvtMult, D .BaseDecPl) 
			  WHEN INTran.TranType = 'TR' AND RTrim(INTran.ToSiteID) <> '' THEN Round(INTran.BMITranAmt * INTran.InvtMult, D .BaseDecPl) ELSE 0 END AS BMIExtCost
FROM		dbo.Inventory 
				-- INNER JOIN
                  -- dbo.RptRuntime ON dbo.RptRuntime.RI_ID = '16' -- (SELECT MAX(RI_ID) AS Expr1 FROM dbo.RptRuntime WHERE  (ReportNbr = '10630')) 
				INNER JOIN
                  dbo.InventoryADG ON dbo.Inventory.InvtID = dbo.InventoryADG.InvtID 
                INNER JOIN
                  dbo.ItemSite ON dbo.Inventory.InvtID = dbo.ItemSite.InvtID 
                INNER JOIN
                  dbo.Site ON dbo.ItemSite.SiteID = dbo.Site.SiteId 
                LEFT OUTER JOIN
                  dbo.ItemHist ON dbo.ItemHist.InvtID = dbo.ItemSite.InvtID 
						AND dbo.ItemHist.SiteID = dbo.ItemSite.SiteID 
						AND dbo.ItemHist.FiscYr =  '2015' -- LEFT(dbo.@initPer, 4) 
				LEFT OUTER JOIN 
				  dbo.Item2Hist ON dbo.ItemHist.InvtID = dbo.Item2Hist.InvtID 
						AND dbo.ItemHist.SiteID = dbo.Item2Hist.SiteID 
						AND dbo.ItemHist.FiscYr = dbo.Item2Hist.FiscYr 
				LEFT OUTER JOIN
                  dbo.ItemBMIHist ON dbo.ItemHist.InvtID = dbo.ItemBMIHist.InvtID 
						AND dbo.ItemHist.SiteID = dbo.ItemBMIHist.SiteID 
						AND dbo.ItemHist.FiscYr = dbo.ItemBMIHist.FiscYr 
				LEFT OUTER JOIN
                  dbo.INTran ON dbo.ItemSite.InvtID = dbo.INTran.InvtID 
						AND dbo.ItemSite.SiteID = dbo.INTran.SiteID 
						AND dbo.INTran.PerPost 
						BETWEEN @initPer 
						AND @endPer -- dbo.RptRuntime.EndPerNbr 
						AND dbo.INTran.Rlsed = 1 
						AND dbo.INTran.S4Future05 = 0 
						AND (dbo.INTran.S4Future09 = 0 
						OR dbo.Inventory.StkItem = 0 
						AND dbo.INTran.S4Future09 = dbo.INTran.S4Future09 
						OR (dbo.INTran.TranType = 'IN' 
								OR
							dbo.INTran.TranType = 'CM' 
							AND (SELECT     DropShip
								FROM          dbo.SOShipHeader AS SO2
								WHERE      (CpnyID = dbo.INTran.CpnyID) AND (ShipperID = dbo.INTran.ShipperID)) = 1) 
							AND dbo.INTran.S4Future09 = 1 AND dbo.Inventory.StkItem = 1 
							--AND dbo.@shortAnswer <> 'TRUE'
							) 
							AND dbo.INTran.TranType NOT IN ('CT', 'CG') 
				INNER JOIN
                  dbo.vp_DecPl AS D ON 1 = 1 
                LEFT OUTER JOIN
                  dbo.SOShipHeader ON dbo.SOShipHeader.CpnyID = dbo.INTran.CpnyID 
						AND dbo.SOShipHeader.ShipperID = dbo.INTran.ShipperID
						
						
)
