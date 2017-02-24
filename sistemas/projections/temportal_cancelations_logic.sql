-- ============================================ building the cancelations algoritm ============================================


-- ==== Vista para visuali... los periodo cerrados 
	select 
			(select (right( CONVERT(VARCHAR(10),max(projections_closed_periods), 105), 7) ) ) as 'projections_closed_periods',
			projections_corporations_id,
			projections_status_period
	from 
			sistemas.dbo.projections_periods
	where 
			projections_status_period = 1
	group by 
			projections_corporations_id,
			projections_status_period

-- =============
-- ==== Vista para visuali... los periodo cerrados 
select * from sistemas.dbo.projections_view_closed_periods

-- =============

--(select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) =  ''
							--flota nvarchar(40) collate SQL_Latin1_General_CP1_CI_AS,
							--no_viaje int,
							--id_area int,
							--company int,
							--num_guia nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
							--no_guia int,
							--subtotal decimal(18,6),
							--fecha_cancelacion datetime,
							--fecha_confirmacion datetime,
							--peso decimal(18,6),
							--Area nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS,
							--Tmov char(1) collate SQL_Latin1_General_CP1_CI_AS,
							--Cporte  nvarchar(60) collate SQL_Latin1_General_CP1_CI_AS

-- SPRITE PARA TRAER LAS CANCELADAS
		--======================== BONAMPAK ====================================
			select
				(
					select 
							nombre
					from 
							bonampakdb.dbo.desp_flotas as flt
					where
							flt.id_flota = matto.id_flota
						
				) as 'flota',
					 flete.no_viaje,flete.id_area,(select 1) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
				(
					select 
							sum(rg.peso)
					from 
							bonampakdb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia = flete.no_guia
						and rg.id_area = flete.id_area
				) as 'peso',
				(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
					from 
							bonampakdb.dbo.general_area as areas
					where 
							areas.id_area = flete.id_area
				) as 'Area',
				zpol.Tmov,
				zpol.Cporte
			from 
					bonampakdb.dbo.trafico_guia as flete
			inner join 
						(
							select 
								Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
								CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
								Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
							from 
								integraapp.dbo.zpoling 
							where 
								Cpny = 'bonampakdb'
								and Estatus = 1
								and Tmov = 'C'
							group by Tmov,Tmov,CPorte,Area
						) as zpol on zpol.Cporte = flete.num_guia
			inner join 
					bonampakdb.dbo.mtto_unidades as matto
						on matto.id_unidad = flete.id_unidad
			where 
					flete.status_guia = 'B' 
					--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
					and year(flete.fecha_cancelacion) = '2016' --
					and month(flete.fecha_cancelacion) = '08'  --
					--and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
					--and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
					and flete.fecha_confirmacion is not null 
					--and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
					and flete.id_area = '1'
					and flete.tipo_doc = 2
union all --======================== MACUSPANA ====================================
			select
				(
					select 
							nombre
					from 
							macuspanadb.dbo.desp_flotas as flt
					where
							flt.id_flota = matto.id_flota
						
				) as 'flota',
					 flete.no_viaje,flete.id_area,(select 2) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
				(
					select 
							sum(rg.peso)
					from 
							macuspanadb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia = flete.no_guia
						and rg.id_area = flete.id_area
				) as 'peso',
				(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
					from 
							macuspanadb.dbo.general_area as areas
					where 
							areas.id_area = flete.id_area
				) as 'Area',
				zpol.Tmov,
				zpol.Cporte
			from 
					macuspanadb.dbo.trafico_guia as flete
			inner join 
						(
							select 
								Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
								CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
								Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
							from 
								integraapp.dbo.zpoling 
							where 
								Cpny = 'macuspanadb'
								and Estatus = 1
								and Tmov = 'C'
							group by Tmov,Tmov,CPorte,Area
						) as zpol on zpol.Cporte = flete.num_guia
			inner join 
					macuspanadb.dbo.mtto_unidades as matto
						on matto.id_unidad = flete.id_unidad
			where 
					flete.status_guia = 'B' 
					--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
					and year(flete.fecha_cancelacion) = '2016' --
					and month(flete.fecha_cancelacion) = '08'  --
					--and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
					--and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
					and flete.fecha_confirmacion is not null 
					--and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
					and flete.tipo_doc = 2
union all --======================== TEISA ====================================
			select
				(
					select 
							nombre
					from 
							tespecializadadb.dbo.desp_flotas as flt
					where
							flt.id_flota = matto.id_flota
						
				) as 'flota',
					 flete.no_viaje,flete.id_area,(select 3) as 'company',flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,flete.fecha_confirmacion,
				(
					select 
							sum(rg.peso)
					from 
							tespecializadadb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia = flete.no_guia
						and rg.id_area = flete.id_area
				) as 'peso',
				(
					select
							ltrim(rtrim(replace(replace(replace(replace(replace(areas.nombre ,'AUTOTRANSPORTE' , ''),' S.A. DE C.V.',''),'BONAMPAK',''),'TRANSPORTADORA ESPECIALIZADA INDUSTRIAL','CUAUTITLAN'),'TRANSPORTE DE CARGA GEMINIS','TULTITLAN')))
					from 
							tespecializadadb.dbo.general_area as areas
					where 
							areas.id_area = flete.id_area
				) as 'Area',
				zpol.Tmov,
				zpol.Cporte
			from 
					tespecializadadb.dbo.trafico_guia as flete
			inner join 
						(
							select 
								Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
								CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
								Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
							from 
								integraapp.dbo.zpoling 
							where 
								Cpny = 'tespecializadadb'
								and Estatus = 1
								and Tmov = 'C'
							group by Tmov,Tmov,CPorte,Area
						) as zpol on zpol.Cporte = flete.num_guia
			inner join 
					tespecializadadb.dbo.mtto_unidades as matto
						on matto.id_unidad = flete.id_unidad
			where 
					flete.status_guia = 'B' 
					--and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
					and year(flete.fecha_cancelacion) = '2016' --
					and month(flete.fecha_cancelacion) = '08'  --
					--and year(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@year, '|'))
					--and month(flete.fecha_cancelacion) in (select item from sistemas.dbo.fnSplit(@month, '|'))
					and flete.fecha_confirmacion is not null 
					--and flete.id_area in (select item from sistemas.dbo.fnSplit(@bunit, '|'))
					and flete.tipo_doc = 2







select no_viaje,fecha_cancelacion,fecha_confirmacion,num_guia,no_guia,id_area,no_viaje from tespecializadadb.dbo.trafico_guia as g 
where (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016' and status_guia = 'B' 
							and fecha_confirmacion is not null 
							and id_area = 1
							and tipo_doc = 2




--=================================== 31 select * from sistemas.dbo.projections_logs
		select 
				cancel.flota,cancel.no_viaje,cancel.id_area,cancel.company,flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,
				(
					select 
							sum(rg.peso)
					from 
							bonampakdb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia = flete.no_guia
						and rg.id_area = cancel.id_area
				) as 'peso',
				zpol.Area,zpol.Tmov,zpol.Cporte
		from 
				sistemas.dbo.projections_logs as cancel

			inner join 

						(	
							select no_viaje,num_guia,no_guia,subtotal,fecha_cancelacion
							from bonampakdb.dbo.trafico_guia as g 
							where 

							status_guia = 'B' 
							and (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '08-2016'
							and fecha_confirmacion is not null 
							and id_area = 1
							and tipo_doc = 2
						)
			as flete on cancel.no_viaje = flete.no_viaje
			inner join 
						(
							select 
								Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
								CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
								Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
							from 
								integraapp.dbo.zpoling 
							where 
								Cpny = 'bonampakdb'
								and Estatus = 1
								and Tmov = 'C'
							group by Tmov,Tmov,CPorte,Area
						) as zpol on zpol.Cporte = flete.num_guia
		where cancel.company = 1
		union all
		select 
				cancel.flota,cancel.no_viaje,cancel.id_area,cancel.company,flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,
				(
					select 
							sum(rg.peso)
					from 
							macuspanadb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia = flete.no_guia
						and rg.id_area = cancel.id_area
				) as 'peso',
				zpol.Area,zpol.Tmov,zpol.Cporte
		from 
				sistemas.dbo.projections_logs as cancel

			inner join 

						(	
							select no_viaje,num_guia,no_guia,subtotal,fecha_cancelacion
							from macuspanadb.dbo.trafico_guia as g 
							where 

							status_guia = 'B' 
							and fecha_confirmacion is not null 
							and id_area = 1
							and tipo_doc = 2
						)
			as flete on cancel.no_viaje = flete.no_viaje
			inner join 
						(
							select 
								Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
								CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
								Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
							from 
								integraapp.dbo.zpoling 
							where 
								Cpny = 'macuspanadb'
								and Estatus = 1
								and Tmov = 'C'
							group by Tmov,Tmov,CPorte,Area
						) as zpol on zpol.Cporte = flete.num_guia
		where cancel.company = 2
		union all
				select 
				cancel.flota,cancel.no_viaje,cancel.id_area,cancel.company,flete.num_guia,flete.no_guia,flete.subtotal,flete.fecha_cancelacion,
				(
					select 
							sum(rg.peso)
					from 
							tespecializadadb.dbo.trafico_renglon_guia as rg
					where 
							rg.no_guia = flete.no_guia
						and rg.id_area = cancel.id_area
				) as 'peso',
				zpol.Area,zpol.Tmov,zpol.Cporte
		from 
				sistemas.dbo.projections_logs as cancel

			inner join 

						(	
							select no_viaje,num_guia,no_guia,subtotal,fecha_cancelacion
							from tespecializadadb.dbo.trafico_guia as g 
							where 

							status_guia = 'B' 
							and fecha_confirmacion is not null 
							and id_area = 1
							and tipo_doc = 2
						)
			as flete on cancel.no_viaje = flete.no_viaje
			inner join 
						(
							select 
								Tmov COLLATE SQL_Latin1_General_CP1_CI_AS as 'Tmov',
								CPorte COLLATE SQL_Latin1_General_CP1_CI_AS as 'Cporte',
								Area COLLATE SQL_Latin1_General_CP1_CI_AS as 'Area'
							from 
								integraapp.dbo.zpoling 
							where 
								Cpny = 'tespecializadadb' 
								and Estatus = 1
								and Tmov = 'C'
							group by Tmov,Tmov,CPorte,Area
						) as zpol on zpol.Cporte = flete.num_guia
		where cancel.company = 3

--===================================
	
declare @canceled table
						(
							flota as nvarchar,
							no_viaje as int,
							id_area as int,
							company as int,
							num_guia as nvarchar,
							no_guia as int,
							subtotal as decimal(18,2),
							fecha_cancelacion as datetime,
							peso as decimal(18,2),
							Area as nvarchar,
							Tmov as char(1),
							Cporte as nvarchar
						)


--===================================
		
		--3275			
		select 
			Tmov,CPorte,Area
			--,year(FecAce)as 'year',month(FecAce)as 'month'
		from 
			integraapp.dbo.zpoling 
		where 
			Cpny = 'bonampakdb'
			and Estatus = 1
			and Tmov = 'C'
		group by Tmov,Tmov,CPorte,Area


		--,year(FecAce),month(FecAce)

		--and CPorte = 'OO-035430'


	







--select fecha_guia,fecha_cancelacion,fecha_confirmacion,num_guia,no_viaje,* from bonampakdb.dbo.trafico_guia as g where (select (right( CONVERT(VARCHAR(10), g.fecha_cancelacion, 105), 7) ) ) = '09-2016' and status_guia = 'B'





-- /*CANCELATIONS*/
--status_guia
--A=> Abierta o pendiente
--C=> Confirmada o Transferidas
--T=> Tr�nsito
--R=> Regreso
--B=> Cancelada



