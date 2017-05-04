--select cast(Holiday_date as date) as 'holyday', datepart(ww,Holiday_date) as 'week' from sistemas.dbo.ebays_function_easter_dates( '2017' )

-- ==================================================================================================================== --	
-- =================================  Indicators View for "Attention", shippings ====================================== --
-- ==================================================================================================================== --
-- in progress ... 
	with ship_one as
	(
			select 
						 header.ItemReqNbr as 'solicitud'  			-- Solicitud
						,detail.ReqNbr as 'requisition'				
						,header.RequstnrDept as 'Departamento'
						,header.CpnyID as 'Empresa'
						,cast(cast(isnull(hist.TranDate,header.CreateDate) as date) as varchar(10)) + ' ' + cast(isnull(hist.TranTime,'08:30:00') as varchar(10)) as 'fulldatetimesolicitud'
						,cast(cast(requisition.TranDate as date) as varchar(12)) + ' ' +
						 case	
							when isdate(requisition.TranTime) = 0
								then replace(requisition.TranTime,substring(requisition.TranTime,1,1),'')
							else requisition.TranTime
						end as 'fulldatetimerequisition'		
						,case
							when hist.Status = 'AP' then 'Aprobada'
							when hist.Status = 'SA' then 'En Aprobacion'
							when hist.Status = 'RQ' then 'Requisicion'
						 	else 'Abierta'
						  end as 'Status_Solicitud'
						,case
							when requisition.Status = 'AP' then 'Aprobada'
							when requisition.Status = 'SA' then 'En Aprobacion'
							else 'Solicitud'
						 end as 'Status_Requisicion'
						,case
							header.S4Future11
								when 'L' then 'BAJA'
								when 'M' then 'MEDIA'
								when 'H' then 'ALTA'
						end as 'Prioridad'
						,year(header.CreateDate) as 'year'
						,month(header.CreateDate) as 'mes'
			from 
						integraapp.dbo.RQItemReqHdr as header   --> Header obvious XD!
				inner join
						integraapp.dbo.RQItemReqDet as detail	--> Detalle de la Solicitud 
					on 
						header.ItemReqNbr = detail.ItemReqNbr 
				inner join 
						integraapp.dbo.RQReqDet as rekdetail   --> Detalle de la requisition
					on	
						detail.ReqNbr = rekdetail.ReqNbr and detail.LineKey = rekdetail.LineKey
				inner join 
						integraapp.dbo.RQItemReqHist as hist 			--> Historico de la solicitud 
					on
						header.ItemReqNbr = hist.ItemReqNbr and hist.Status = 'AP' and detail.LineKey = hist.UniqueID
				inner join	
						integraapp.dbo.RQReqHist as requisition 		--> Historico de la Requisition
					on	
						detail.ReqNbr = requisition.ReqNbr and requisition.Status = 'SA' and detail.LineKey = requisition.UniqueID
			
	)
	
	select 
			 solicitud 
			,requisition 
			,Departamento 
			,Empresa 
			,fulldatetimesolicitud 
			,fulldatetimerequisition 
--			,case	
--				when dateadd(d,3,fulldatetimesolicitud)
			,Status_Solicitud 
			,Status_Requisicion 
			,Prioridad 
			,"year" 
			,mes
	from ship_one
	
where solicitud = '041123' and requisition = '060362'
	
						
-- ==================================================================================================================== --	
-- ================================  Indicators View for "Authorization", shippings =================================== --
-- ==================================================================================================================== --
-- NOTE this view is not complete , the definition on times and hrs are fuzzy 
-- if they need to add the holidays and weekend this is not programed yet in the view
	
	use sistemas

	if OBJECT_ID ('shippings_indicators_prom_time_in_auths', 'V') is not null
    drop view shippings_indicators_prom_time_in_auths;
	
	create view shippings_indicators_prom_time_in_auths

	with encryption
	
	as
	with ind_shipp_2 
	as(
		select 
					 head.ReqNbr
					,head.CpnyID as 'Company'
					,item.LineKey,item.ItemReqNbr,item.LineNbr
					,hist.Authority as 'l0_Authority'
					,cast( cast(hist.TranDate as date) as nvarchar(10)) + ' ' + cast(hist.TranTime as nvarchar(15)) as 'fechaNivel0'
					,hist.Status as 'l0_Status'
					,hist_zero.Authority as 'l1_Authority'
					,cast( cast(hist_zero.TranDate as date) as nvarchar(10)) + ' ' + cast(hist_zero.TranTime as nvarchar(15)) as 'fechaNivel1'
					,hist_zero.Status as 'l1_Status'
					,hist_one.Authority as 'l2_Authority'
					,cast( cast(hist_one.TranDate as date) as nvarchar(10)) + ' ' + cast(hist_one.TranTime as nvarchar(15)) as 'fechaNivel2'
					,hist_one.Status as 'l2_Status'
					,hist_two.Authority as 'l3_Authority'
					,cast( cast(hist_two.TranDate as date) as nvarchar(10)) + ' ' + cast(hist_two.TranTime as nvarchar(15)) as 'fechaNivel3'
					,hist_two.Status as 'l3_Status'
					,hist_three.Authority as 'l4_Authority'
					,cast( cast(hist_three.TranDate as date) as nvarchar(10)) + ' ' + cast(hist_three.TranTime as nvarchar(15)) as 'fechaNivel4'
					,hist_three.Status as 'l4_Status'
					,hist_fourth.Authority as 'l5_Authority'
					,cast( cast(hist_fourth.TranDate as date) as nvarchar(10)) + ' ' + cast(hist_fourth.TranTime as nvarchar(15)) as 'fechaNivel5'
					,hist_fourth.Status as 'l5_Status'
					,year(hist.TranDate) as 'year'
					,meses.month_name as 'month'
		from 
					integraapp.dbo.RQReqHdr as head
			inner join
					integraapp.dbo.RQItemReqDet as item
				on 
					head.ReqNbr = item.ReqNbr
			inner join	
					integraapp.dbo.RQReqHist as hist
				on	
					head.ReqNbr = hist.ReqNbr and item.LineKey = hist.UniqueID and hist.Authority = 'L0'
			inner join
					sistemas.dbo.generals_month_translations as meses
				on
					month(hist.TranDate) = meses.month_num
			left join	
					integraapp.dbo.RQReqHist as hist_zero
				on	
					head.ReqNbr = hist_zero.ReqNbr and item.LineKey = hist_zero.UniqueID and hist_zero.Authority = 'L1'
			left join	
					integraapp.dbo.RQReqHist as hist_one
				on	
					head.ReqNbr = hist_one.ReqNbr and item.LineKey = hist_one.UniqueID and hist_one.Authority = 'L2'
			left join	
					integraapp.dbo.RQReqHist as hist_two
				on	
					head.ReqNbr = hist_two.ReqNbr and item.LineKey = hist_two.UniqueID and hist_two.Authority = 'L3'
			left join	
					integraapp.dbo.RQReqHist as hist_three
				on	
					head.ReqNbr = hist_three.ReqNbr and item.LineKey = hist_three.UniqueID and hist_three.Authority = 'L4'
			left join	
					integraapp.dbo.RQReqHist as hist_fourth
				on	
					head.ReqNbr = hist_fourth.ReqNbr and item.LineKey = hist_fourth.UniqueID and hist_fourth.Authority = 'L5'
		where
					year(hist.TranDate) in (year(CURRENT_TIMESTAMP))
			and
					hist.Status in ('SA')
	  )
	  
	  select
	  				 ind.ReqNbr
	  				,ind.Company
	  				,ind.LineKey,ind.ItemReqNbr,ind.LineNbr
	  				,ind.l0_Authority
	  				,ind.fechaNivel0
	  				,ind.l0_Status
	  				,ind.l1_Authority
	  				,ind.fechaNivel1
	  				,ind.l1_Status
	  				,ind.l2_Authority
	  				,ind.fechaNivel2
	  				,ind.l2_Status
	  				,ind.l3_Authority
	  				,ind.fechaNivel3
	  				,ind.l3_Status
	  				,ind.l4_Authority
	  				,ind.fechaNivel4
	  				,ind.l4_Status
	  				,ind.l5_Authority
	  				,ind.fechaNivel5
	  				,ind.l5_Status
			  		,ind."year"
			  		,ind."month"
			  			  		
			  		 ,case 
			  			when ind.fechaNivel3 is not null	
			  				then
								case
				  					when ind.fechaNivel3 between ind.fechaNivel0 and dateadd(d,1,ind.fechaNivel0)
				  						then 'Nivel 3'
				  					else 'Fuera de Tiempo'
				  				end
				  		when ind.fechaNivel2 is not null
			  				then
								case
				  					when ind.fechaNivel2 between ind.fechaNivel0 and dateadd(d,1,ind.fechaNivel0)
				  						then 'Nivel 2'
				  					else 'Fuera de Tiempo'
				  				end
			  			when ind.fechaNivel1 is not null
			  				then
								case
				  					when ind.fechaNivel1 between ind.fechaNivel0 and dateadd(d,1,ind.fechaNivel0)
				  						then 'Nivel 1'
				  					else 'Fuera de Tiempo'
				  				end
			  		 end as 'firts24Hrs'
			  		
			  		,case 
			  			when ind.fechaNivel5 is not null	
			  				then
								case
				  					when ind.fechaNivel5 between dateadd(d,1,ind.fechaNivel0) and  dateadd(d,3,ind.fechaNivel0)
				  						then 'Nivel 5'
				  					else 'Fuera de Tiempo'
				  				end
				  		when ind.fechaNivel4 is not null
			  				then
								case
				  					when ind.fechaNivel4 between dateadd(d,3,ind.fechaNivel0) and dateadd(d,3,ind.fechaNivel0)
				  						then 'Nivel 4'
				  					else 'Fuera de Tiempo'
				  				end
			  		end as 'next24Hrs++'
	  from 
	  				ind_shipp_2 as ind		
	  				
--	 select * from sistemas.dbo.shippings_indicators_prom_time_in_auths
			