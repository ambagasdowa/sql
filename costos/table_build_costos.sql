-- ==================================================================================================================== --
-- =================================     General Tables for Constant Values      ====================================== --
-- ==================================================================================================================== --

-- ==================================================================================================================== --
/*
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
 */
-- ==================================================================================================================== --

-- ==================================================================================================================== --
-- ==================================    add permissions to a user "integra"   ======================================== --
-- ==================================================================================================================== --
-- Grant permission to an user to execute the stores of MR this is on sistemas
	use sistemas
	GRANT EXECUTE ON "sistemas"."dbo"."reporter_sp_accounts" TO "reporter"
-- Create a Role to view Mr Tables and execute the stores
-- the user enuma exists but not in MR so create
	use ManagementReporter
	CREATE USER enuma FOR LOGIN enuma; -- create connection permissions for enuma admin
	CREATE USER integra FOR LOGIN integra; -- create connection permissions for integra user
	exec sp_addrolemember 'db_owner', 'enuma'  -- add enuma to a owners role

-- Create a role to view tables and views
	use ManagementReporter
	CREATE ROLE [reporter] AUTHORIZATION enuma;
-- watch the role for users
	exec sp_helpuser 'integra' --check the user in db
	exec sp_helprole -- check roles
	exec sp_helplogins 'integra' -- check login user has a login ?

-- Add user to a role
	use ManagementReporter
	exec sp_addrolemember 'reporter' , 'integra'

-- Grant View Permission on tables of MR
	use ManagementReporter
	GRANT SELECT ON "ManagementReporter"."dbo"."ControlRowCriteria" to "reporter"
	GRANT SELECT ON "ManagementReporter"."dbo"."ControlRowDetail" to "reporter"
	GRANT SELECT ON "ManagementReporter"."dbo"."ControlRowMaster" to "reporter"



/*
-- ==================================================================================================================== --
-- =================================    NOTE  View to select the main report     ====================================== --
-- ==================================================================================================================== --
TODO : Select the report and store in a variable this in php
TEST ; select top(200)* from sistemas.dbo.reporter_views_main_reports
STATUS : success
*/

use sistemas;
IF OBJECT_ID ('reporter_views_main_reports', 'V') IS NOT NULL
    DROP VIEW reporter_views_main_reports;
create view reporter_views_main_reports
with encryption
as
select
				 ( row_number() over(order by "ControlRowMaster".ID) ) as 'index_id'
				, convert( nvarchar(36),"ControlRowMaster".ID ) as 'ID'
				,"]ControlRowMaster".name
				,"ControlRowMaster".Description
from
				"ManagementReporter"."dbo".ControlRowMaster as "ControlRowMaster"

/*
-- ==================================================================================================================== --
-- =================================    NOTE  View to select the main report     ====================================== --
-- ==================================================================================================================== --
TODO : Select the report and store in a variable this in php
TEST : select top(200)* from sistemas.dbo.reporter_views_main_subreports
STATUS : success
*/

	use sistemas;
	IF OBJECT_ID ('reporter_views_main_subreports', 'V') IS NOT NULL
	    DROP VIEW reporter_views_main_subreports;
	create view reporter_views_main_subreports
	with encryption
	as
		select
					( row_number() over(order by ID) ) as 'index_id'
	        , convert( nvarchar(36),ID ) as 'ID'
					, convert(nvarchar(36),RowFormatID) as 'RowFormatID'
					,RowNumber,RowCode,Description,RelatedRows
	        ,case
	          when OverrideIndent = 3
	            then '1'
	            else '0'
	          end as 'type_of_block'
	  from ManagementReporter.dbo.ControlRowDetail

/*
-- ==================================================================================================================== --
-- =================================    NOTE  View to select subreport accounts  ====================================== --
-- ==================================================================================================================== --
TODO : Select the report and store in a variable this in php
TEST : select top(200)* from sistemas.dbo.reporter_views_main_subreports_accounts where RowDetailID = '03218FF3-F7DE-436B-8AA7-F1629FA89195'
STATUS : success
*/

use sistemas;
IF OBJECT_ID ('reporter_views_main_subreports_accounts', 'V') IS NOT NULL
		DROP VIEW reporter_views_main_subreports_accounts;
create view reporter_views_main_subreports_accounts
with encryption
as
		select
			 ( row_number() over(order by criteria.RowDetailID) ) as 'id'
			 , convert(nvarchar(36),criteria.RowDetailID) as 'RowDetailID'
			 , convert(nvarchar(36),criteria.RowLinkID) as 'RowLinkID'
			 ,criteria.DisplayOrder
 	         ,criteria.Low as 'rangeaccounta',criteria.High as 'rangeaccountb'
		     ,zero.Low as 'segmenta', zero.High as 'segmentb'
		  from
		      ManagementReporter.dbo.ControlRowCriteria as criteria
		  left join ManagementReporter.dbo.ControlRowCriteria as zero
		  on
		      zero.RowDetailID = criteria.RowDetailID
		  and
		      zero.DimensionCode = 'Segment_04'
		  and
		      zero.DisplayOrder = criteria.DisplayOrder
		where
		      criteria.DimensionCode = 'Natural'
--		  and
--		  	  criteria.RowDetailID = ?

-- ==================================================================================================================== --
-- =================================    definition of table keys for solomon     ====================================== --
-- ==================================================================================================================== --
-- TEST select * from sistemas.dbo.reporter_table_keys
-- NOTE this is the glue in the reports 
use sistemas

IF OBJECT_ID('reporter_table_keys', 'U') IS NOT NULL
  DROP TABLE reporter_table_keys;

set ansi_nulls on
set quoted_identifier on
set ansi_padding on

create table reporter_table_keys(
		id									int identity(1,1),
        "_key"								nvarchar(10) 		collate		sql_latin1_general_cp1_ci_as,
        "_description"						nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
        -- row_code							int,
        -- report_name							nvarchar(450) 		collate		sql_latin1_general_cp1_ci_as,
        row_detail_id						nvarchar(450) 		collate		sql_latin1_general_cp1_ci_as,
		created								datetime,
		modified							datetime,
		user_id								int,
		"_status"							tinyint default 1 null
) on [primary]

set ansi_padding off

-- insert into sistemas.dbo.reporter_table_keys  values
-- 					('OF','Costos Operativos Fijos','03218FF3-F7DE-436B-8AA7-F1629FA89195',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1',1),
-- 					('OV','Costos Operativos Variables',null,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1',1),
-- 					('MF','Costos Mantenimiento Fijos',null,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1',1),
-- 					('MV','Costos Mantenimiento Variables',null,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1',1),
-- 					('AD','Costos Administrativos',null,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1',1)


-- truncate table sistemas.dbo.reporter_table_keys
-- select * from sistemas.dbo.reporter_table_keys

-- ==================================================================================================================== --
-- =================================     	  Unidades de Negocio Solomon	     ====================================== --
-- ==================================================================================================================== --
-- Add a third segment definitions
-- select * from sistemas.dbo.reporter_views_bussiness_units

use sistemas;
-- go
IF OBJECT_ID ('reporter_views_bussiness_units', 'V') IS NOT NULL
    DROP VIEW reporter_views_bussiness_units;
-- go

create view reporter_views_bussiness_units
with encryption
as

select
		row_number()
	over
		(order by idbase) as
							 id
							,idbase
							,idsl
	from(

				select
							idbase,idsl
				from
							integraapp.dbo.xrefcia
				group by
							idbase,idsl
			union all      -- this can be temporal add until understand
				select
							distinct (select '00') as 'idbase',idsl
				from
							integraapp.dbo.xrefcia
				where
							idsl not in
										(
											select
													distinct idsl
											from
													integraapp.dbo.xrefcia
											where
													substring(idsl,1,3) = 'TBK' and idsl <> 'TBKORI'
										)
	   ) as result


-- ==================================================================================================================== --
-- ================================================    	  Years	     ================================================== --
-- ==================================================================================================================== --
-- get the current and one past years
-- select * from sistemas.dbo.reporter_views_years

use sistemas

IF OBJECT_ID ('reporter_views_years', 'V') IS NOT NULL
    DROP VIEW reporter_views_years;

create view reporter_views_years
with encryption
as
with years as (
				select cast(year(dateadd(year,-1,CURRENT_TIMESTAMP)) as varchar(4)) as 'cyear'
				union all
				select cast(year(CURRENT_TIMESTAMP) as varchar(4)) as 'cyear'
			   )
select
		row_number()
		over
			(order by cyear) as
				 id
				,cyear		collate SQL_Latin1_General_CP1_CI_AS as "cyear"
				,id_month	collate SQL_Latin1_General_CP1_CI_AS as "id_month"
				,"month"	collate SQL_Latin1_General_CP1_CI_AS as "month"
				,period		collate SQL_Latin1_General_CP1_CI_AS as "period"
				,"_period"		collate SQL_Latin1_General_CP1_CI_AS as "_period"
	from
		(
			select
					 "yr".cyear,"mts".id_month,"mts"."month","yr".cyear + "mts".id_month as "period"
					,"mts".id_month + '-' + "yr".cyear as "_period"
			from
					years as "yr"
				left join (
							select '01' as "id_month", 'Enero' as "month"
							union select '02' as "id_month", 'Febrero' as "month"
							union select '03' as "id_month", 'Marzo' as "month"
							union select '04' as "id_month", 'Abril' as "month"
							union select '05' as "id_month", 'Mayo' as "month"
							union select '06' as "id_month", 'Junio' as "month"
							union select '07' as "id_month", 'Julio' as "month"
							union select '08' as "id_month", 'Agosto' as "month"
							union select '09' as "id_month", 'Septiembre' as "month"
							union select '10' as "id_month", 'Octubre' as "month"
							union select '11' as "id_month", 'Noviembre' as "month"
							union select '12' as "id_month", 'Diciembre' as "month"
						   )
				as "mts" on 1 = 1
			where
				"yr".cyear + "mts".id_month <= (CONVERT(nvarchar(4), YEAR(CURRENT_TIMESTAMP)) + (select right('00'+convert(varchar(2),MONTH(current_timestamp)), 2)) )
		)
	as result

-- ==================================================================================================================== --
-- =================================     	  Define Accounts for Costos	     ====================================== --
-- ==================================================================================================================== --
-- OF,OV,MF,MV,AD
-- select * from sistemas.dbo.reporter_views_acounts_costos


use sistemas
-- go
IF OBJECT_ID ('reporter_views_acounts_costos', 'V') IS NOT NULL
    DROP VIEW reporter_views_acounts_costos;
-- go

create view reporter_views_acounts_costos
with encryption
as
	select
			 "acc".id
			,"acc".RowDetailID
			,"acc".RowLinkID
			,"acc".DisplayOrder
			,"acc".rangeaccounta
			,"acc".rangeaccountb
			,"acc".segmenta
			,"acc".segmentb
			,"keys"."_key"
			,"keys"."_description"
	from
				sistemas.dbo.reporter_views_main_subreports_accounts as "acc"
		inner join
				sistemas.dbo.reporter_table_keys as "keys"
			on
				"keys".row_detail_id = "acc".RowDetailID collate SQL_Latin1_General_CP1_CI_AS
--
--
-- -- OF	   select * from sistemas.dbo.mr_source_mains where "_key" = 'OF'
-- 	select
-- 				 criteria.RowDetailID,criteria.RowLinkID,criteria.DisplayOrder
-- 				 ,criteria.Low as 'rangeaccounta',criteria.High as 'rangeaccountb'
-- 				 ,zero.Low as 'segmenta', zero.High as 'segmentb'
-- 				 ,'OF' as "_key"
-- 	from
-- 				ManagementReporter.dbo.ControlRowCriteria as criteria
-- 	left join ManagementReporter.dbo.ControlRowCriteria as zero
-- 		on
-- 				zero.RowDetailID = criteria.RowDetailID
-- 		and
-- 				zero.DimensionCode = 'Segment_04'
-- 		and
-- 				zero.DisplayOrder = criteria.DisplayOrder
-- 	where criteria.RowDetailID = (
-- 							select ID from ManagementReporter.dbo.ControlRowDetail
-- 							where RowFormatID = (select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1')
-- 							and RowCode = '734'
-- 						)
-- 	and criteria.DimensionCode = 'Natural'
-- --	order by criteria.DisplayOrder
--
-- union all
-- -- OV	select * from sistemas.dbo.mr_source_mains where "_key" = 'OV'
-- 	select
-- 				 criteria.RowDetailID,criteria.RowLinkID,criteria.DisplayOrder
-- 				 ,criteria.Low as 'rangeaccounta',criteria.High as 'rangeaccountb'
-- 				 ,zero.Low as 'segmenta', zero.High as 'segmentb'
-- 				 ,'OV' as "_key"
-- 	from
-- 				ManagementReporter.dbo.ControlRowCriteria as criteria
-- 	left join ManagementReporter.dbo.ControlRowCriteria as zero
-- 		on
-- 				zero.RowDetailID = criteria.RowDetailID
-- 		and
-- 				zero.DimensionCode = 'Segment_04'
-- 		and
-- 				zero.DisplayOrder = criteria.DisplayOrder
-- 	where criteria.RowDetailID = (
-- 							select ID from ManagementReporter.dbo.ControlRowDetail
-- 							where RowFormatID = (select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1')
-- 							and RowCode = '768'
-- 						)
-- 	and criteria.DimensionCode = 'Natural'
-- --	order by criteria.DisplayOrder
--
-- union all
-- -- MF    select * from sistemas.dbo.mr_source_mains where "_key" = 'MF'
-- 	select
-- 				 criteria.RowDetailID,criteria.RowLinkID,criteria.DisplayOrder
-- 				 ,criteria.Low as 'rangeaccounta',criteria.High as 'rangeaccountb'
-- 				 ,zero.Low as 'segmenta', zero.High as 'segmentb'
-- 				 ,'MF' as "_key"
-- 	from
-- 				ManagementReporter.dbo.ControlRowCriteria as criteria
-- 	left join ManagementReporter.dbo.ControlRowCriteria as zero
-- 		on
-- 				zero.RowDetailID = criteria.RowDetailID
-- 		and
-- 				zero.DimensionCode = 'Segment_04'
-- 		and
-- 				zero.DisplayOrder = criteria.DisplayOrder
-- 	where criteria.RowDetailID = (
-- 							select ID from ManagementReporter.dbo.ControlRowDetail
-- 							where RowFormatID = (select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1')
-- 							and RowCode = '648'
-- 						)
-- 	and criteria.DimensionCode = 'Natural'
-- --	order by criteria.DisplayOrder
--
-- union all
--
-- -- MV		select * from sistemas.dbo.mr_source_mains where "_key" = 'MV'
--
-- 	select
-- 				 criteria.RowDetailID,criteria.RowLinkID,criteria.DisplayOrder
-- 				 ,criteria.Low as 'rangeaccounta',criteria.High as 'rangeaccountb'
-- 				 ,zero.Low as 'segmenta', zero.High as 'segmentb'
-- 				 ,'MV' as "_key"
-- 	from
-- 				ManagementReporter.dbo.ControlRowCriteria as criteria
-- 	left join ManagementReporter.dbo.ControlRowCriteria as zero
-- 		on
-- 				zero.RowDetailID = criteria.RowDetailID
-- 		and
-- 				zero.DimensionCode = 'Segment_04'
-- 		and
-- 				zero.DisplayOrder = criteria.DisplayOrder
-- 	where criteria.RowDetailID = (
-- 							select ID from ManagementReporter.dbo.ControlRowDetail
-- 							where RowFormatID = (select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1')
-- 							and RowCode = '658'
-- 						)
-- 	and criteria.DimensionCode = 'Natural'
-- --	order by criteria.DisplayOrder
-- union all
-- -- AD		select * from sistemas.dbo.mr_source_mains where "_key" = 'AD'
-- 	select
-- 				 criteria.RowDetailID,criteria.RowLinkID,criteria.DisplayOrder
-- 				 ,criteria.Low as 'rangeaccounta',criteria.High as 'rangeaccountb'
-- 				 ,zero.Low as 'segmenta', zero.High as 'segmentb'
-- 				 ,'AD' as "_key"
-- 	from
-- 				ManagementReporter.dbo.ControlRowCriteria as criteria
-- 	left join ManagementReporter.dbo.ControlRowCriteria as zero
-- 		on
-- 				zero.RowDetailID = criteria.RowDetailID
-- 		and
-- 				zero.DimensionCode = 'Segment_04'
-- 		and
-- 				zero.DisplayOrder = criteria.DisplayOrder
-- 	where criteria.RowDetailID = (
-- 							select ID from ManagementReporter.dbo.ControlRowDetail
-- 							where RowFormatID = (select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1')
-- 							and RowCode = '910'
-- 						)
-- 	and criteria.DimensionCode = 'Natural'
--	order by criteria.DisplayOrder


-- ==================================================================================================================== --
-- =================================    deploy the config subaccount as sp       ====================================== --
-- ==================================================================================================================== --
-- Add a third segment definitions
USE sistemas

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [dbo].[reporter_sp_accounts]

 with encryption
 as

SET NOCOUNT ON -- enable vba Excel access
SET FMTONLY OFF

	declare @config_accounts table
	(
		rangeaccounta	nvarchar(10)	collate	sql_latin1_general_cp1_ci_as,
		segmenta		nvarchar(6)	collate		sql_latin1_general_cp1_ci_as,
		segmentb		nvarchar(6)	collate		sql_latin1_general_cp1_ci_as,
		_key			nvarchar(2)	collate		sql_latin1_general_cp1_ci_as
	)

	-- declare the fields from
	-- use sistemas
	declare		@rangeaccounta varchar(10), @rangeaccountb varchar(10) ,
				@segmenta varchar(6) , @segmentb varchar(6),
				@_key varchar(2), @accounts varchar(255) ,@counter int


	declare guia_cursor cursor for	(
											select
													source_accounts.rangeaccounta,
													source_accounts.rangeaccountb,
													source_accounts.segmenta,
													source_accounts.segmentb,
													source_accounts."_key"
											from
													sistemas.dbo.reporter_views_acounts_costos as source_accounts
										)
		open guia_cursor
			fetch next from guia_cursor into		@rangeaccounta,
													@rangeaccountb,
													@segmenta,
													@segmentb,
													@_key
				while @@fetch_status = 0
					begin
						/** only fetch the accounts */
						--if ((@rangeaccounta is not null  and @rangeaccountb is not null ) and (@rangeaccounta <> '' and @rangeaccountb <> '') )
						--	begin
						--print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
						--	end

						if ((@rangeaccounta is not null  and @rangeaccountb is not null ) and (@rangeaccounta <> '' and @rangeaccountb <> '') )
							begin
							-- print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key

								declare account_cursor cursor for (
																	select acct
																	from integraapp.dbo.account
																	where
																		--	integraapp.dbo.account.accttype = '5e'
																		--and
																			active = '1'
																		and
																			acct between @rangeaccounta and @rangeaccountb

																)

								open account_cursor
									fetch next from account_cursor into	@accounts -- save into

										while @@fetch_status = 0
											begin
												if @accounts is not null
													begin
														-- print 'acct => '+ @accounts + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
														-- INSERT INTO CONFIG ACCOUNTS
														insert @config_accounts
															select @accounts,@segmenta,@segmentb,@_key
													end
												fetch next from account_cursor into @accounts
											end
								close account_cursor
								deallocate account_cursor
							end
						else if ( ( @rangeaccounta is not null ) and ( @rangeaccountb is null or @rangeaccountb = '') )
							begin
								-- print @rangeaccounta + ' accb => '+ @rangeaccountb + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
								-- print 'acct => '+ @accounts + ' sega => ' + @segmenta + ' segb => ' + @segmentb + ' key => ' + @_key
													-- INSERT INTO CONFIG ACCOUNTS
														insert @config_accounts
															select @rangeaccounta,@segmenta,@segmentb,@_key
							end
						fetch next from guia_cursor into	@rangeaccounta,
															@rangeaccountb,
															@segmenta,
															@segmentb,
															@_key
					end
		close guia_cursor
	deallocate guia_cursor
	select
			source_accounts.rangeaccounta,
			source_accounts.segmenta,
			source_accounts.segmentb,
			source_accounts."_key"
	from
			@config_accounts as source_accounts


-- ==================================================================================================================== --
-- =================================    deploy the config subaccount as sp       ====================================== --
-- ==================================================================================================================== --
-- Add a third segment definitions

--select * from sistemas.dbo.reporter_view_sp_xs4z_accounts
			
use sistemas

IF OBJECT_ID ('reporter_view_sp_xs4z_accounts', 'V') IS NOT NULL
	DROP VIEW reporter_view_sp_xs4z_accounts;

create view reporter_view_sp_xs4z_accounts
	with encryption as
	select
			( row_number() over(order by "cost".rangeaccounta) ) as 'id'
			,"cost".rangeaccounta
			,"cost".segmenta
			,"cost".segmentb
			,"cost"."_key"
			,"acc".Descr as 'name'
	from
			openquery(local,'sistemas.dbo.reporter_sp_accounts') as "cost"
	inner join 
			integraapp.dbo.Account as "acc"
		on
			"acc".Acct = "cost".rangeaccounta


-- ==================================================================================================================== --
-- =================================    	build the rowdata of GLTran		     ====================================== --
-- ==================================================================================================================== --
-- select * from reporter_view_gltran_account_rows

use sistemas

IF OBJECT_ID ('reporter_view_gltran_account_rows_tbks', 'V') IS NOT NULL
	DROP VIEW reporter_view_gltran_account_rows_tbks;

create view reporter_view_gltran_account_rows_tbks
	with encryption as


	with costos as (
						select
									 bsu.idbase as 'segmentx' , bsu.idsl as 'bsu'
									,costs.rangeaccounta,costs.segmenta,costs.segmentb,costs."_key"
						from
									sistemas.dbo.reporter_views_bussiness_units as bsu
						inner join
									sistemas.dbo.reporter_view_sp_xs4z_accounts as costs
									on  1 = 1
						where
									bsu.idsl not in ('TCGTUL','ATMMAC','TEICUA')
					)
	select
				 cost.segmentx ,cost.bsu
				,cost.rangeaccounta,cost.segmenta,cost.segmentb,cost."_key"
				,ISNULL(gl.CuryCrAmt * gl.CuryRate,0.0) as 'Abono'
				,ISNULL(gl.CuryDrAmt * gl.CuryRate,0.0) as 'Cargo'
				,gl.Acct, gl.Sub, gl.CpnyID ,gl.PerPost ,gl.FiscYr
				,gl.PerEnt , gl.JrnlType ,gl.TranType ,gl.RefNbr
				,gl.ExtRefNbr ,gl.TranDesc
	from
				costos as cost
		inner join
				integraapp.dbo.GLTran as gl
			on
				substring(gl.Sub,8,2) = cost.segmentx
			and
				gl.Posted = 'P' and gl.LedgerID = 'REAL'
			and
				gl.Acct = cost.rangeaccounta
			and	-- start the logic for all the segments
				(
				--condition 1
					(
							cost.segmentb is not null and cost.segmenta is not null -- when mode is equal then omit this and use the next case else use the limit defined in the or clause
				    	and
						   	substring(gl.Sub,10,2)  between replace(cost.segmenta,'?',' ') and replace(cost.segmentb,'?',' ')
					)
	--			--condition 2
					or
					(
							(cost.segmentb is null or cost.segmentb = '' ) and cost.segmenta is not null
						and
							substring(gl.Sub,10,6)  = replace(cost.segmenta,'?',' ')
					)
				-- else
					or
					(
							(cost.segmentb is null or cost.segmentb = '' ) and (cost.segmenta is null or cost.segmenta = '' )
						and
							substring(gl.Sub,10,6) like '%'
					)
				 )
	where
				gl.FiscYr in ( year(CURRENT_TIMESTAMP), year(dateadd(year,-1,CURRENT_TIMESTAMP)) )





-- ==================================================================================================================== --
-- =================================    	fetch the rowdata of GLTran		     ====================================== --
-- ==================================================================================================================== --
-- select * from reporter_view_gltran_account_rows

use sistemas

IF OBJECT_ID ('reporter_view_gltran_account_rows_not_tbks', 'V') IS NOT NULL
	DROP VIEW reporter_view_gltran_account_rows_not_tbks;

create view reporter_view_gltran_account_rows_not_tbks
	with encryption as


	with costos as (
						select
									 bsu.idbase as 'segmentx' , bsu.idsl as 'bsu'
									,costs.rangeaccounta,costs.segmenta,costs.segmentb,costs."_key"
						from
									sistemas.dbo.reporter_views_bussiness_units as bsu
						inner join
									sistemas.dbo.reporter_view_sp_xs4z_accounts as costs
									on  1 = 1
						where
									bsu.idsl in ('ATMMAC','TEICUA','TCGTUL')
					)
	select
				 cost.segmentx ,cost.bsu
				,cost.rangeaccounta,cost.segmenta,cost.segmentb,cost."_key"
				,ISNULL(gl.CuryCrAmt * gl.CuryRate,0.0) as 'Abono'
				,ISNULL(gl.CuryDrAmt * gl.CuryRate,0.0) as 'Cargo'
				,gl.Acct, gl.Sub, gl.CpnyID ,gl.PerPost ,gl.FiscYr
				,gl.PerEnt , gl.JrnlType ,gl.TranType ,gl.RefNbr
				,gl.ExtRefNbr ,gl.TranDesc
	from
				costos as cost
		inner join
				integraapp.dbo.GLTran as gl
			on
				substring(gl.Sub,8,2) = cost.segmentx
			and
				gl.Posted = 'P' and gl.LedgerID = 'REAL'
			and
				gl.Acct = cost.rangeaccounta
			and
				cost.bsu = gl.CpnyID
			and	-- start the logic for all the segments
				(
				--condition 1
					(
							cost.segmentb is not null and cost.segmenta is not null -- when mode is equal then omit this and use the next case else use the limit defined in the or clause
				    	and
						   	substring(gl.Sub,10,2)  between replace(cost.segmenta,'?',' ') and replace(cost.segmentb,'?',' ')
					)
	--			--condition 2
					or
					(
							(cost.segmentb is null or cost.segmentb = '' ) and cost.segmenta is not null
						and
							substring(gl.Sub,10,6)  = replace(cost.segmenta,'?',' ')
					)
				-- else
					or
					(
							(cost.segmentb is null or cost.segmentb = '' ) and (cost.segmenta is null or cost.segmenta = '' )
						and
							substring(gl.Sub,10,6) like '%'
					)
				 )
	where
				gl.FiscYr in ( year(CURRENT_TIMESTAMP), year(dateadd(year,-1,CURRENT_TIMESTAMP)) )




-- ==================================================================================================================== --
-- ============================    	fetch the extradata for teisa of GLTran     ====================================== --
-- ==================================================================================================================== --
-- select * from reporter_view_gltran_account_rows

use sistemas

IF OBJECT_ID ('reporter_view_gltran_account_rows_teiexs', 'V') IS NOT NULL
	DROP VIEW reporter_view_gltran_account_rows_teiexs;

create view reporter_view_gltran_account_rows_teiexs
	with encryption as


	with costos as (
						select
									 bsu.idbase as 'segmentx' , bsu.idsl as 'bsu'
									,costs.rangeaccounta,costs.segmenta,costs.segmentb,costs."_key"
						from
									sistemas.dbo.reporter_views_bussiness_units as bsu
						inner join
									sistemas.dbo.reporter_view_sp_xs4z_accounts as costs
									on  1 = 1
						where
									bsu.idsl in ('TCGTUL')
					)
	select
				 cost.segmentx
				,case
					when gl.CpnyID = 'TEICUA'
						then 'TEICUA'
					else cost.bsu
				 end as 'bsu'
				,cost.rangeaccounta,cost.segmenta,cost.segmentb,cost."_key"
				,ISNULL(gl.CuryCrAmt * gl.CuryRate,0.0) as 'Abono'
				,ISNULL(gl.CuryDrAmt * gl.CuryRate,0.0) as 'Cargo'
				,gl.Acct, gl.Sub, gl.CpnyID ,gl.PerPost ,gl.FiscYr
				,gl.PerEnt , gl.JrnlType ,gl.TranType ,gl.RefNbr
				,gl.ExtRefNbr ,gl.TranDesc
	from
				costos as cost
		inner join
				integraapp.dbo.GLTran as gl
			on
				substring(gl.Sub,8,2) = cost.segmentx
			and
				gl.Posted = 'P' and gl.LedgerID = 'REAL'
			and
				gl.Acct = cost.rangeaccounta
--			and
--				cost.bsu = gl.CpnyID
			and	-- start the logic for all the segments
				(
				--condition 1
					(
							cost.segmentb is not null and cost.segmenta is not null -- when mode is equal then omit this and use the next case else use the limit defined in the or clause
				    	and
						   	substring(gl.Sub,10,2)  between replace(cost.segmenta,'?',' ') and replace(cost.segmentb,'?',' ')
					)
	--			--condition 2
					or
					(
							(cost.segmentb is null or cost.segmentb = '' ) and cost.segmenta is not null
						and
							substring(gl.Sub,10,6)  = replace(cost.segmenta,'?',' ')
					)
				-- else
					or
					(
							(cost.segmentb is null or cost.segmentb = '' ) and (cost.segmenta is null or cost.segmenta = '' )
						and
							substring(gl.Sub,10,6) like '%'
					)
				 )
	where
				gl.FiscYr in ( year(CURRENT_TIMESTAMP), year(dateadd(year,-1,CURRENT_TIMESTAMP)) )
		and
			    gl.CpnyID in ('TEICUA') and substring(Sub,8,2) = 'EA'

-- ==================================================================================================================== --
-- =================================    	fetch the rowdata of GLTran		     ====================================== --
-- ==================================================================================================================== --
-- select * from reporter_view_gltran_account_rows

use sistemas

IF OBJECT_ID ('reporter_view_gltran_account_rows', 'V') IS NOT NULL
	DROP VIEW reporter_view_gltran_account_rows;

create view reporter_view_gltran_account_rows
	with encryption as

	select
				 segmentx,bsu,rangeaccounta,segmenta,segmentb,"_key",Abono,Cargo,Acct,Sub,CpnyID
				,PerPost ,FiscYr ,PerEnt ,JrnlType ,TranType ,RefNbr ,ExtRefNbr ,TranDesc
	from
				sistemas.dbo.reporter_view_gltran_account_rows_not_tbks
	union all
	select
				 segmentx,bsu,rangeaccounta,segmenta,segmentb,"_key",Abono,Cargo,Acct,Sub,CpnyID
				,PerPost ,FiscYr ,PerEnt ,JrnlType ,TranType ,RefNbr ,ExtRefNbr ,TranDesc
	from
				sistemas.dbo.reporter_view_gltran_account_rows_tbks
	union all
	select
				 segmentx,bsu,rangeaccounta,segmenta,segmentb,"_key",Abono,Cargo,Acct,Sub,CpnyID
				,PerPost ,FiscYr ,PerEnt ,JrnlType ,TranType ,RefNbr ,ExtRefNbr ,TranDesc
	from
				sistemas.dbo.reporter_view_gltran_account_rows_teiexs

-- ==================================================================================================================== --
-- =====================    building budget report compatible with as mr_* tables   =================================== --
-- ==================================================================================================================== --
-- select * from sistemas.dbo.reporter_view_account_hist_bugs
use sistemas

IF OBJECT_ID ('reporter_view_account_hist_bugs_not_tbks', 'V') IS NOT NULL
	DROP VIEW reporter_view_account_hist_bugs_not_tbks;

create view reporter_view_account_hist_bugs_not_tbks
	with encryption as

with presupuesto as
				(
					select
								 bsu.idbase as 'segmentx' , bsu.idsl as '_source_company'
								,costs.rangeaccounta as "Acct",costs.segmenta,costs.segmentb,costs."_key"
					from
								sistemas.dbo.reporter_views_bussiness_units as bsu
					inner join
								sistemas.dbo.reporter_view_sp_xs4z_accounts as costs
								on  1 = 1
						where
									bsu.idsl in ('TCGTUL','ATMMAC','TEICUA')
				)
select
			 "prep".segmentx
			,"prep".Acct
			,"hist".Sub,"hist".CpnyID
			,"hist".PtdBal00 ,"hist".PtdBal01 ,"hist".PtdBal02 ,"hist".PtdBal03 ,"hist".PtdBal04
			,"hist".PtdBal05 ,"hist".PtdBal06 ,"hist".PtdBal07 ,"hist".PtdBal08 ,"hist".PtdBal09
			,"hist".PtdBal10 ,"hist".PtdBal11 ,"hist".PtdBal12 ,"hist".FiscYr
			,"prep"."_key"
			,"prep"."_source_company"
			,"account".Descr
			,"sub".Descr as 'subdesc'
from
			presupuesto as "prep"
inner join
			integraapp.dbo.Account as "account"
	on
			"account".Acct = "prep".Acct
inner join
			integraapp.dbo.AcctHist as "hist"
	on
			"hist".Acct = "prep".Acct and "hist".FiscYr in ( year(CURRENT_TIMESTAMP), year(dateadd(year,-1,CURRENT_TIMESTAMP)) )
		and
			"hist".LedgerID = 'PRESUP' + "hist".FiscYr --and "hist".CpnyID = "prep"."_company"
		and
			substring("hist".Sub,8,2) = "prep".segmentx
		and
			"prep"."_source_company" = "hist".CpnyID
		and	-- start the logic for all the segments
			(
			--condition 1
				(
						"prep".segmentb is not null and "prep".segmenta is not null -- when mode is equal then omit this and use the next case else use the limit defined in the or clause
			    	and
					   	substring("hist".Sub,10,6)  between replace("prep".segmenta,'?',' ') and replace("prep".segmentb,'?',' ')
				)
--			--condition 2
				or
				(
						("prep".segmentb is null or "prep".segmentb = '' ) and "prep".segmenta is not null
					and
						substring("hist".Sub,10,6)  = replace("prep".segmenta,'?',' ')
				)
				or
				(
						("prep".segmentb is null or "prep".segmentb = '' ) and ("prep".segmenta is null or "prep".segmenta = '' )
					and
						substring("hist".Sub,10,6) like '%'
				)
			 )
inner join
			integraapp.dbo.SubAcct as "sub"
	on
			"hist".Sub = "sub".Sub


-- ==================================================================================================================== --
-- =====================    building budget report compatible with as mr_* tables   =================================== --
-- ==================================================================================================================== --
-- select * from sistemas.dbo.reporter_view_account_hist_bugs
use sistemas

IF OBJECT_ID ('reporter_view_account_hist_bugs_tbks', 'V') IS NOT NULL
	DROP VIEW reporter_view_account_hist_bugs_tbks;

create view reporter_view_account_hist_bugs_tbks
	with encryption as

with presupuesto as
				(
					select
								 bsu.idbase as 'segmentx' , bsu.idsl as '_source_company'
								,costs.rangeaccounta as "Acct",costs.segmenta,costs.segmentb,costs."_key"
					from
								sistemas.dbo.reporter_views_bussiness_units as bsu
					inner join
								sistemas.dbo.reporter_view_sp_xs4z_accounts as costs
								on  1 = 1
						where
									bsu.idsl not in ('TCGTUL','ATMMAC','TEICUA')
				)
select
			 "prep".segmentx
			,"prep".Acct
			,"hist".Sub,"hist".CpnyID
			,"hist".PtdBal00 ,"hist".PtdBal01 ,"hist".PtdBal02 ,"hist".PtdBal03 ,"hist".PtdBal04
			,"hist".PtdBal05 ,"hist".PtdBal06 ,"hist".PtdBal07 ,"hist".PtdBal08 ,"hist".PtdBal09
			,"hist".PtdBal10 ,"hist".PtdBal11 ,"hist".PtdBal12 ,"hist".FiscYr
			,"prep"."_key"
			,"prep"."_source_company"
			,"account".Descr
			,"sub".Descr as 'subdesc'
from
			presupuesto as "prep"
inner join
			integraapp.dbo.Account as "account"
	on
			"account".Acct = "prep".Acct
inner join
			integraapp.dbo.AcctHist as "hist"
	on
			"hist".Acct = "prep".Acct and "hist".FiscYr in ( year(CURRENT_TIMESTAMP), year(dateadd(year,-1,CURRENT_TIMESTAMP)) )
		and
			"hist".LedgerID = 'PRESUP' + "hist".FiscYr --and "hist".CpnyID = "prep"."_company"
		and
			substring("hist".Sub,8,2) = "prep".segmentx
		and	-- start the logic for all the segments
			(
			--condition 1
				(
						"prep".segmentb is not null and "prep".segmenta is not null -- when mode is equal then omit this and use the next case else use the limit defined in the or clause
			    	and
					   	substring("hist".Sub,10,6)  between replace("prep".segmenta,'?',' ') and replace("prep".segmentb,'?',' ')
				)
--			--condition 2
				or
				(
						("prep".segmentb is null or "prep".segmentb = '' ) and "prep".segmenta is not null
					and
						substring("hist".Sub,10,6)  = replace("prep".segmenta,'?',' ')
				)
				or
				(
						("prep".segmentb is null or "prep".segmentb = '' ) and ("prep".segmenta is null or "prep".segmenta = '' )
					and
						substring("hist".Sub,10,6) like '%'
				)
			 )
inner join
			integraapp.dbo.SubAcct as "sub"
	on
			"hist".Sub = "sub".Sub



-- ==================================================================================================================== --
-- =====================    building budget report compatible with as mr_* tables   =================================== --
-- ==================================================================================================================== --
-- select * from sistemas.dbo.reporter_view_account_hist_bugs
use sistemas

IF OBJECT_ID ('reporter_view_account_hist_bugs', 'V') IS NOT NULL
	DROP VIEW reporter_view_account_hist_bugs;

create view reporter_view_account_hist_bugs
	with encryption as

	select
				segmentx ,Acct ,Sub ,CpnyID ,PtdBal00 ,PtdBal01 ,PtdBal02 ,PtdBal03 ,PtdBal04 ,PtdBal05 ,PtdBal06
				,PtdBal07 ,PtdBal08 ,PtdBal09 ,PtdBal10 ,PtdBal11 ,PtdBal12 ,FiscYr ,_key ,_source_company ,Descr
				,subdesc
	from
				reporter_view_account_hist_bugs_tbks
union all
	select
				segmentx ,Acct ,Sub ,CpnyID ,PtdBal00 ,PtdBal01 ,PtdBal02 ,PtdBal03 ,PtdBal04 ,PtdBal05 ,PtdBal06
				,PtdBal07 ,PtdBal08 ,PtdBal09 ,PtdBal10 ,PtdBal11 ,PtdBal12 ,FiscYr ,_key ,_source_company ,Descr
				,subdesc
	from
				reporter_view_account_hist_bugs_not_tbks


-- ==================================================================================================================== --
-- ===========================    	fetch the rowdata of GLTran	as report and prep   ================================== --
-- ==================================================================================================================== --
-- select top(200) * from sistemas.dbo.reporter_view_report_accounts
use sistemas

IF OBJECT_ID ('reporter_view_report_accounts', 'V') IS NOT NULL
	DROP VIEW reporter_view_report_accounts;

create view reporter_view_report_accounts
	--with encryption
	as

select -- Get Acoounts
			case substring("rows".PerPost,5,2)
						when '01' then 'Enero'
						when '02' then 'Febrero'
						when '03' then 'Marzo'
						when '04' then 'Abril'
						when '05' then 'Mayo'
						when '06' then 'Junio'
						when '07' then 'Julio'
						when '08' then 'Agosto'
						when '09' then 'Septiembre'
						when '10' then 'Octubre'
						when '11' then 'Noviembre'
						when '12' then 'Diciembre'
						else 'other'
				 end as 'Mes'
			,"rows".Acct as 'NoCta'
			,"account".Descr as 'NombreCta'
			,"rows".PerEnt as 'PerEnt'
			,"rows".CpnyID as 'Compania'
			,"rows".JrnlType as 'Tipo'
			,"rows".Sub as 'Entidad'
			,"rows".TranType as 'TipoTransaccion'
			,"rows".RefNbr as 'Referencia'
			,"rows".ExtRefNbr as 'ReferenciaExterna'
			,"rows".TranDesc as 'Descripcion'
			,"rows".Abono as 'Abono'
			,"rows".Cargo as 'Cargo'
			,"rows".Cargo - "rows".Abono as 'Real'
			,"rows".segmentx as 'UnidadNegocio'
			,substring("rows".Sub,10,6) as 'CentroCosto'
			,"sub".Descr as 'NombreEntidad'
			,"rows".bsu as '_source_company'
			,"rows".PerPost as '_period'
			,"rows"."_key" as '_key'
			,' ' as 'Presupuesto'
			,"rows".FiscYr
from
			sistemas.dbo.reporter_view_gltran_account_rows as "rows"
	inner join
			integraapp.dbo.Account as "account"
		on "rows".rangeaccounta = account.Acct
	inner join
			integraapp.dbo.SubAcct as "sub"
		on "rows".Sub = sub.Sub

union all

select -- Get Presupuesto
		 "per"."month" as 'Mes'
		,"bug".Acct as 'NoCta'
		,"bug".Descr as 'NombreCta'
		,'' as 'PerEnt'
		,"bug".CpnyID as 'Compania'
		,'' as 'Tipo'
		,"bug".Sub as 'Entidad'
		,'' as 'TipoTransaccion'
		,'' as 'Referencia'
		,'' as 'ReferenciaExterna'
		,'' as 'Descripcion'
		,'' as 'Abono'
		,'' as 'Cargo'
		,'' as 'Real'
		,"bug".segmentx as 'UnidadNegocio'
		,substring("bug".Sub,10,6) as 'CentroCosto'
		,"bug".subdesc as 'NombreEntidad'
		,"bug"."_source_company" '_source_company'
 		,"per".period as "_period"
 		,"bug"."_key" as '_key'
		,case
			when "per".id_month = '01' then "bug".PtdBal00
			when "per".id_month = '02' then "bug".PtdBal01
			when "per".id_month = '03' then "bug".PtdBal02
			when "per".id_month = '04' then "bug".PtdBal03
			when "per".id_month = '05' then "bug".PtdBal04
			when "per".id_month = '06' then "bug".PtdBal05
			when "per".id_month = '07' then "bug".PtdBal06
			when "per".id_month = '08' then "bug".PtdBal07
			when "per".id_month = '09' then "bug".PtdBal08
			when "per".id_month = '10' then "bug".PtdBal09
			when "per".id_month = '11' then "bug".PtdBal10
			when "per".id_month = '12' then "bug".PtdBal11
		end as 'Presupuesto'
		,"bug".FiscYr
from
		sistemas.dbo.reporter_views_years as "per"
left join
		sistemas.dbo.reporter_view_account_hist_bugs as "bug"
	on
		substring("per".period,1,4) = "bug".FiscYr
