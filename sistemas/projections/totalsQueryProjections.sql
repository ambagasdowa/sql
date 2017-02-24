
-- full stack developer level
-- ================================================================================================
-- fetch subtotals as sistemas.dbo.projections_view_indicators_periods
-- ================================================================================================
--USE AdventureWorks2012;  
--GO  
--SELECT SalesOrderID, ProductID, OrderQty  
--    ,SUM(OrderQty) OVER(PARTITION BY SalesOrderID) AS Total  
--    ,AVG(OrderQty) OVER(PARTITION BY SalesOrderID) AS "Avg"  
--    ,COUNT(OrderQty) OVER(PARTITION BY SalesOrderID) AS "Count"  
--    ,MIN(OrderQty) OVER(PARTITION BY SalesOrderID) AS "Min"  
--    ,MAX(OrderQty) OVER(PARTITION BY SalesOrderID) AS "Max"  
--FROM Sales.SalesOrderDetail   
--WHERE SalesOrderID IN(43659,43664);  

---- Define the CTE expression name and column list.  
--WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)  
--AS  
---- Define the CTE query.  
--(  
--    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear  
--    FROM Sales.SalesOrderHeader  
--    WHERE SalesPersonID IS NOT NULL  
--)  
---- Define the outer query referencing the CTE name.
--SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear  
--FROM Sales_CTE  
--GROUP BY SalesYear, SalesPersonID  
--ORDER BY SalesPersonID, SalesYear;
--GO
--GO  
-- 54

-- Define the CTE expression name and column list.


--use sistemas;
--go
--IF OBJECT_ID ('projections_view_indicators_periods', 'V') IS NOT NULL
--    DROP VIEW projections_view_indicators_periods;
--GO

--create view projections_view_indicators_periods
--with encryption
--as

WITH operations_ind
					(  
							company,id_area,area,id_fraccion
							,fraccion,cyear,mes
							,kms_real
							,kms_viaje
							,subtotal
							,peso
							,non_zero
					)
	as (
			select 
					company,id_area,area
					--,id_flota,flota,
					,id_fraccion,fraccion
					,year(fecha_guia) as 'cyear'
					,mes
					--,tipo_de_operacion
					,case
						when trip_count = 1
							then sum(kms_real)
						else
							cast ((select '0') as int)
					end as 'kms_real'
					--,sum(kms_real) as 'kms-real'
					,case
						when trip_count = 1
							then sum(kms_viaje)
						else
							cast ((select '0') as int)
					end as 'kms_viaje'
					--,sum(kms_viaje) as 'kms-viaje'
					,sum(subtotal) as 'subtotal',sum(peso) as 'peso'
					,case
						when trip_count = 1
							then count(trip_count)
						else
							cast ((select '0') as int)
					end as 'non_zero'
			from
					sistemas.dbo.projections_upt_indops as indupt
					--left join	
					--	sistemas.dbo.projections_upt_cancelations as uptc
					--openquery(local, 'exec sistemas.dbo.sp_xd4e_fullByMonthCompanyOperations "xxxx","xx",0')
			group by
					company,id_area,area
					,id_fraccion,fraccion
					,year(fecha_guia)
					,mes
					,trip_count
			union all
			select 
					company,id_area,area
					--,id_flota,flota,
					,id_fraccion,fraccion
					,year(fecha_guia) as 'cyear'
					,mes
					--,tipo_de_operacion
					,case
						when trip_count = 1
							then sum(kms_real)
						else
							cast ((select '0') as int)
					end as 'kms_real'
					,case
						when trip_count = 1
							then sum(kms_viaje)
						else
							cast ((select '0') as int)
					end as 'kms_viaje'
					,sum(subtotal) as 'subtotal',sum(peso) as 'peso'
					,case
						when trip_count = 1
							then count(trip_count)
						else
							cast ((select '0') as int)
					end as 'non_zero'
			from
					sistemas.dbo.projections_closed_period_datas
			where
					_status = 1
			group by
					company,id_area,area
					,id_fraccion,fraccion
					,year(fecha_guia)
					,mes
					,trip_count
		)

	select
			row_number()
		over 
			(order by id_area) as 
								id,
								company,
								id_area,
								area,
								id_fraccion,
								fraccion,
								cyear,
								mes,
								kms,
								subtotal,
								peso,
								dsubtotal,
								dpeso,
								subsubtotal,
								subpeso,
								non_zero
		from(
			select 			
					opsind.company,opsind.id_area,opsind.area,opsind.id_fraccion
					,opsind.fraccion,opsind.cyear,opsind.mes
					,case
						when opsind.id_fraccion in ( 
												select projections_id_fraccion 
												from sistemas.dbo.projections_view_company_fractions 
												where projections_corporations_id = opsind.company and projections_rp_fraction_id = 1) -- means granel
							then 
								(sum(opsind.kms_viaje)*2)
						when opsind.id_fraccion in (	
												select projections_id_fraccion 
												from sistemas.dbo.projections_view_company_fractions 
												where projections_corporations_id = opsind.company and projections_rp_fraction_id = 2) -- means otros
							then 
								sum(opsind.kms_real)
						else
							null
					end as 'kms'
					,sum(opsind.subtotal) as 'subtotal'
					,sum(opsind.peso) as 'peso'
					,(uptops.subtotal) as 'dsubtotal',(uptops.peso) as 'dpeso'
					,(sum(opsind.subtotal) - isnull(uptops.subtotal,0)) as 'subsubtotal'
					,(sum(opsind.peso) - isnull(uptops.peso,0)) as 'subpeso'
					,sum(opsind.non_zero) as 'non_zero'
			from 
					operations_ind opsind
					left join
								(
									select 
											uptc.company,uptc.id_area
											,uptc.Area as 'area'
											,uptc.id_fraccion
											,(select desc_producto from sistemas.dbo.projections_view_fractions as fr where fr.projections_corporations_id = uptc.company and fr.id_fraccion = uptc.id_fraccion) as 'fraccion'
											,year(uptc.fecha_cancelacion) as 'cyear'
											,uptc.mes
											,(select NULL) as 'kms'
											,sum(uptc.subtotal) as 'subtotal'
											,sum(uptc.peso) as 'peso'
											,(select NULL) as 'non_zero'
									from
											sistemas.dbo.projections_upt_cancelations as uptc
									group by 
												uptc.company
											,uptc.id_area
											,uptc.Area
											,uptc.id_fraccion
											,year(uptc.fecha_cancelacion)
											--,datename(mm,uptc.fecha_cancelacion)
											,mes
									union all 
									select 
											disstc.company,disstc.id_area
											,disstc.Area as 'area'
											,disstc.id_fraccion
											,(select desc_producto from sistemas.dbo.projections_view_fractions as fr where fr.projections_corporations_id = disstc.company and fr.id_fraccion = disstc.id_fraccion) as 'fraccion'
											,year(disstc.fecha_cancelacion) as 'cyear'
											,disstc.mes
											,(select NULL) as 'kms'
											,sum(disstc.subtotal) as 'subtotal'
											,sum(disstc.peso) as 'peso'
											,(select NULL) as 'non_zero'
									from
											sistemas.dbo.projections_dissmiss_cancelations as disstc
									group by 
												disstc.company
											,disstc.id_area
											,disstc.Area
											,disstc.id_fraccion
											,year(disstc.fecha_cancelacion)
											--,datename(mm,disstc.fecha_cancelacion)
											,mes
								) as uptops on uptops.company = opsind.company 
									and uptops.id_area = opsind.id_area
									and uptops.cyear = opsind.cyear
									and uptops.id_fraccion = opsind.id_fraccion
									and uptops.mes = opsind.mes
						
			group by 
					opsind.company,opsind.id_area,opsind.area,opsind.id_fraccion,opsind.fraccion,opsind.cyear,opsind.mes,uptops.subtotal,uptops.peso
		) as result
--go

-- company , id_area , area , id_fraccion , cyear , mes , kms , subtotal , peso , non-zero

--set language spanish;
-- set language english;


 
	--select 
	--		uptc.company,uptc.id_area
	--		,uptc.Area as 'area'
	--		,uptc.id_fraccion
	--		,(select desc_producto from dbo.projections_view_fractions as fr where fr.projections_corporations_id = uptc.company and fr.id_fraccion = uptc.id_fraccion) as 'fraccion'
	--		,year(uptc.fecha_cancelacion) as 'cyear'
	--		,uptc.mes
	--		,(select NULL) as 'kms'
	--		,sum(uptc.subtotal) as 'subtotal'
	--		,sum(uptc.peso) as 'peso'
	--		,(select NULL) as 'non_zero'
	--from
	--		sistemas.dbo.projections_upt_cancelations as uptc
	--group by 
	--		 uptc.company
	--		,uptc.id_area
	--		,uptc.Area
	--		,uptc.id_fraccion
	--		,year(uptc.fecha_cancelacion)
	--		--,datename(mm,uptc.fecha_cancelacion)
	--		,mes
	--union all 
	--select 
	--		disstc.company,disstc.id_area
	--		,disstc.Area as 'area'
	--		,disstc.id_fraccion
	--		,(select desc_producto from dbo.projections_view_fractions as fr where fr.projections_corporations_id = disstc.company and fr.id_fraccion = disstc.id_fraccion) as 'fraccion'
	--		,year(disstc.fecha_cancelacion) as 'cyear'
	--		,disstc.mes
	--		,(select NULL) as 'kms'
	--		,sum(disstc.subtotal) as 'subtotal'
	--		,sum(disstc.peso) as 'peso'
	--		,(select NULL) as 'non_zero'
	--from
	--		sistemas.dbo.projections_dissmiss_cancelations as disstc
	--group by 
	--		 disstc.company
	--		,disstc.id_area
	--		,disstc.Area
	--		,disstc.id_fraccion
	--		,year(disstc.fecha_cancelacion)
	--		--,datename(mm,disstc.fecha_cancelacion)
	--		,mes

--	select * from projections_view_fractions
	--select * from sistemas.dbo.projections_upt_cancelations


	--select * from projections_view_indicators_periods

--select * from projections_view_company_fractions

--select * from sistemas.dbo.projections_fraccion_defs
--select * from sistemas.dbo.projections_fraccion_groups
--select * from sistemas.dbo.projections_view_fractions






			--select * from sistemas.dbo.projections_logs


--WITH operations_hist_ind
--					(  
--							company,id_area,area,id_fraccion
--							,fraccion,cyear,mes
--							,kms_real
--							,kms_viaje
--							,subtotal
--							,peso
--							,non_zero
--					)
--	as (
--			select 
--					company,id_area,area
--					--,id_flota,flota,
--					,id_fraccion,fraccion
--					,year(fecha_guia) as 'cyear'
--					,mes
--					--,tipo_de_operacion
--					,case
--						when trip_count = 1
--							then sum(kms_real)
--						else
--							cast ((select '0') as int)
--					end as 'kms_real'
--					--,sum(kms_real) as 'kms-real'
--					,case
--						when trip_count = 1
--							then sum(kms_viaje)
--						else
--							cast ((select '0') as int)
--					end as 'kms_viaje'
--					--,sum(kms_viaje) as 'kms-viaje'
--					,sum(subtotal) as 'subtotal',sum(peso) as 'peso'
--					,case
--						when trip_count = 1
--							then count(trip_count)
--						else
--							cast ((select '0') as int)
--					end as 'non_zero'
--			from
--					sistemas.dbo.projections_closed_period_datas
--			where
--					_status = 1
--			group by
--					company,id_area,area
--					,id_fraccion,fraccion
--					,year(fecha_guia)
--					,mes
--					,trip_count
--		)
--		select 			
--				company,id_area,area,id_fraccion
--				,fraccion,cyear,mes
--				,case
--					when id_fraccion in (1,2)
--						then (sum(kms_viaje)*2)
--					else
--						sum(kms_real)
--				end as 'kms'
--				--,sum(kms_real) as 'kms_real'
--				--,sum(kms_viaje) as 'kms_viaje'
--				,sum(subtotal) as 'subtotal'
--				,sum(peso) as 'peso'
--				,sum(non_zero) as 'non_zero'
--		from 
--				operations_hist_ind
--		group by 
--				company,id_area,area,id_fraccion,fraccion,cyear,mes
--		order by cyear
--			--select * from sistemas.dbo.projections_logs
--			--where
--			--		time_identifier = '42682.749389'
			
			



--select * from 
--openquery(local, 'exec sistemas.dbo.sp_xd3e_getFullCompanyOperations  "2016" , "01", "1" , "1" , 0 , 0 , 0')
--exec sistemas.dbo.sp_xd4e_fullByMonthCompanyOperations