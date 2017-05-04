--use integraapp 
--select * from integraapp.dbo.indicador_v1_1_ebays


-- ==================================================================================================================== --	
-- =================================  Indicators View for "Attention", shippings ====================================== --
-- =================================            Antonio's version                ====================================== --
-- ==================================================================================================================== --


use sistemas
	if OBJECT_ID('indicador_v1_1_ebays', 'V') is not null
		drop view indicador_v1_1_ebays



create view indicador_v1_1_ebays

as
select

	sol.ItemReqNbr as #_Solicitud,
	sol.ReqNbr as #_Requisicion,
	prio.CpnyID,


	cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detsol.TranTime,'08:30:00') as varchar(10)) as 'FechaSolicicitud',
	
	cast(cast(detrequap.TranDate as date) as varchar(15)) + ' ' + cast(detrequap.TranTime as varchar(10)) as 'Fecha Requisicion',

--	datepart(ww,cast(cast(isnull(detrequ.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detrequ.TranTime,'08:30:00') as varchar(10))) as 'week',
	
--	dateadd(d,3, cast(cast(isnull(detrequ.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detrequ.TranTime,'08:30:00') as varchar(10))) as 'firts24hrs',	
	case 
		when isnull(cast( cast(detrequap.TranDate as date) as varchar(15) ) + ' ' + cast(detrequap.TranTime as varchar(10)) , CURRENT_TIMESTAMP)--fechaReq
					between 
						cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' +   --fecha_solicitud
						cast(isnull(detsol.TranTime,'08:30:00') as varchar(10)) 
					and 
						dateadd(d,3, cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + 
						cast(isnull(detsol.TranTime,'08:30:00') as varchar(10)))   										-- fecha_limite
			then 'ok'	
		else
			' '
	end as 'A tiempo',
	
	case 
		when isnull(cast( cast(detrequap.TranDate as date) as varchar(15) ) + ' ' + cast(detrequap.TranTime as varchar(10)) , CURRENT_TIMESTAMP)--fechaReq
				between 
						dateadd(d,3, cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detsol.TranTime,'08:30:00') as varchar(10))) 
				and 
						dateadd(d,6, cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detsol.TranTime,'08:30:00') as varchar(10)))
			then 'ok'	
		else
			' '
	end as '24 hrs Posteriores',
	
	case 
		when isnull(cast( cast(detrequap.TranDate as date) as varchar(15) ) + ' ' + cast(detrequap.TranTime as varchar(10)) , CURRENT_TIMESTAMP)--fechaReq
				between 
						dateadd(d,6, cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detsol.TranTime,'08:30:00') as varchar(10))) 
				and 
						dateadd(d,9, cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detsol.TranTime,'08:30:00') as varchar(10)))
			then 'ok'	
		else
			' '
	end as '48 hrs Posteriores',
	
	case 
		when isnull(cast( cast(detrequap.TranDate as date) as varchar(15) ) + ' ' + cast(detrequap.TranTime as varchar(10)) , CURRENT_TIMESTAMP)--fechaReq
		between 
				dateadd(d,9, cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detsol.TranTime,'08:30:00') as varchar(10))) 
		and 
				dateadd(d,12, cast(cast(isnull(detsol.TranDate,prio.CreateDate) as date) as varchar(15)) + ' ' + cast(isnull(detsol.TranTime,'08:30:00') as varchar(10)))
			then 'ok'	
		else
			' '
	end as '72 hrs Posteriores',
	
	sol.Dept as Departamento,
	month(detrequ.TranDate) as 'mes',
	year(detrequ.TranDate) as 'year',
	case
		when isnull(detsol.Status,'')= 'AP' 
			then 'APROBADA'
		when isnull(detrequ.Status,'')= 'SA' 
			then 'EN APROBACION'
		when isnull(detsol.Status,'')= 'RQ' 
			then 'REQUISICION'
		else 'ABIERTA'
	end as Status_Solicitud,
	case
		when isnull(detrequ.Status,'')= 'AP' 
			then 'APROBADA'
		when isnull(detrequ.Status,'')= 'SA' 
			then 'EN APROBACION'
		else 'SOLICITUD'
	end as Status_Requisicion,
	case
		prio.S4Future11
		when 'L' then 'BAJA'
		when 'M' then 'MEDIA'
		when 'H' then 'ALTA'
	end as Prioridad,
	detsol.Status as 'Estatus Solicitud',
	detrequ.Status as 'Estatus Requisicion'
from
	integraapp.dbo.RQItemReqDet sol
		left join integraapp.dbo.RQReqDet requ on requ.ItemReqNbr = sol.ItemReqNbr
			and 
				requ.ReqNbr = sol.ReqNbr
			and 
				sol.LineKey = requ.LineKey 
		inner join integraapp.dbo.RQItemReqHist detsol on sol.ItemReqNbr = detsol.ItemReqNbr
			and	
				detsol.Status = 'AP'
			and sol.LineKey = detsol.UniqueID 
		left join integraapp.dbo.RQReqHist detrequ on requ.ReqNbr = detrequ.ReqNbr
			and 
				requ.ReqNbr = detrequ.ReqNbr
			and 
				requ.LineKey = detrequ.UniqueID
			and 
				detrequ.Status = 'SA'
		left join integraapp.dbo.RQReqHist detrequap on requ.ReqNbr = detrequap.ReqNbr
			and 
				requ.ReqNbr = detrequap.ReqNbr
			and 
				requ.LineKey = detrequap.UniqueID
			and 
				detrequap.Status = 'SA' 
		left join integraapp.dbo.Rqitemreqhdr prio on prio.itemreqnbr = sol.itemreqnbr 
where
	year(detrequ.TranDate) = '2017'	
	
--	and 
--		sol.ItemReqNbr = '041123'
--	and
--		sol.ReqNbr = '060362'
		
	
--select * from integraapp.dbo.indicador_v1_1_ebays as eb where eb.#_Solicitud = '042301' and eb.#_Requisicion = '062090'
--
--select TranDate,Trantime,* from integraapp.dbo.RQItemReqHist where ItemReqNbr = '042301' and Status = 'AP'
--
--select TranDate,TranTime,* from integraapp.dbo.RQReqHist where ReqNbr = '062090' and Status = 'SA'



