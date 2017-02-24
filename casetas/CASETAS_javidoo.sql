


Use sistemas;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
/*======================================================================================================
 Authors        : Jesus Baizabal (ProcedureProgramation&TableSquemaDesign as Core) and Adrian (Query)
 email          : baizabal.jesus@gmail.com and adrian.turru@gmail.com
 Create date    : Dec 05, 2016
 Description    : gst_casetas_conciliacion/gst_tollbooth/update cruces and montos 
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : GST Feltes y Servicios, s.a de c.v
 @status        : Stable
 @version        : 1.0.0
 ======================================================================================================*/

CREATE PROCEDURE sp_upt_tollbooth_manual_trips_not_conciliation

With Encryption
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

/*==========================================================================================================================================
 Authors        : JesusBaizabal (ProcedureProgramation&TableSquemaDesign and Core) and JavierGarcia (ConsultorAnalisis&baseStudyQuery)
 email          : baizabal.jesus@gmail.com and fcojaviergv@gmail.com
 Create date    : Nov 23, 2016
 Description    : tollbooth conciliation
 @license       : MIT License 0(http://www.opensource.org/licenses/mit-license.php)
 Database owner : Any
 @status        : Stable
 @version       : 1.0.0
 ============================================================================================================================================*/
 
 /*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

-- ==========================================================================================================================================
--	From hir , this is part of the new core of conciliations of a toolboth take this from lis and iave shit's this core must be join with 
--  IAVE file for complete conciliation , follow the standar squema of the firts development of the conciliations module.
-- ==========================================================================================================================================
--declare  @iave_periods table
--							(
--								period_iave_id				int,
--								period_desc					nvarchar(80)	collate	sql_latin1_general_cp1_ci_as,
--								fecha_ini					date,
--								fecha_fin					date,
--								offset_day_minus			int,
--								offset_day_plus				int,
--								user_id						int,
--								created						datetime default current_timestamp,
--								_status						tinyint default 1 null
--							)

--insert into @iave_periods values	('375','Mayo 21 al 31','2016-05-21','2016-05-31','5','1','1',CURRENT_TIMESTAMP,'1'),
--									('376','Junio 1 al 10','2016-06-01','2016-06-10','5','1','1',CURRENT_TIMESTAMP,'1'),
--									('377','Junio 11 al 20','2016-06-11','2016-06-20','5','1','1',CURRENT_TIMESTAMP,'1'),
--									('378','Junio 21 al 30','2016-06-21','2016-06-30','5','1','1',CURRENT_TIMESTAMP,'1'),
--									('379','Julio 01 al 10','2016-07-01','2016-07-10','5','1','1',CURRENT_TIMESTAMP,'1'),
--									('391','Noviembre 01 al 10','2016-11-01','2016-11-10','5','1','1',CURRENT_TIMESTAMP,'1')


declare @tollbooth_no_trips table
								  (
									 period_iave_id							int
									,fecha_ini								date
									,fecha_fin								date
									,no_viaje								int
									,f_despachado							date
									,id_area								int
									,name									nvarchar(25) collate	sql_latin1_general_cp1_ci_as
									,cia									nvarchar(15) collate	sql_latin1_general_cp1_ci_as
									,company_id								int
									,id_unidad								nvarchar(10) collate	sql_latin1_general_cp1_ci_as
									,iave_catalogo							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
									,iave_viaje								nvarchar(25) collate	sql_latin1_general_cp1_ci_as
									,id_ruta								int
									,desc_ruta								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
									,id_caseta								int
									,fecha_real_viaje						datetime
									,fecha_real_fin_viaje					datetime
									,diff_length_hours						int
									,no_ejes_viaje							int
									,no_tarjeta_llave						nvarchar(25) collate	sql_latin1_general_cp1_ci_as
									,orden									int
									,consecutivo							int
									,desc_caseta							nvarchar(25) collate	sql_latin1_general_cp1_ci_as
									,no_de_ejes								int
									,monto_iave								decimal(18,6)
									,tarifas								decimal(18,6)
									,liq_tipo_pago							int
									,liq_paso								nvarchar(1)
									,liq_id_caseta							int
									,liq_monto_caseta						decimal(18,6)
									,liq_monto_iave							decimal(18,6)
									,liq_no_liquidacion						int
									,trliq_fecha_ingreso					datetime
									,_filename								nvarchar(50) collate	sql_latin1_general_cp1_ci_as
									,iave_period							int
									,casetas_controls_files_id				int
									,casetas_historical_conciliations_id	int
									,fecha_conciliacion						datetime
									,_modified								datetime default current_timestamp
									,_status								tinyint default 1 null
								  )



;with ops (
			 period_iave_id,fecha_ini,fecha_fin
			,no_viaje,f_despachado,id_area,company_id
			,name
			,cia
			,fecha_real_viaje,fecha_real_fin_viaje,no_ejes_viaje,no_tarjeta_llave
			,id_unidad
			,iave_catalogo
			,iave_viaje
			,id_ruta,desc_ruta
			,id_caseta,orden,consecutivo
			,desc_caseta
			,no_de_ejes,monto_iave,tarifas
			,liq_tipo_pago,liq_paso,liq_id_caseta,liq_monto_caseta,liq_monto_iave,liq_no_liquidacion
			,trliq_fecha_ingreso
         )
as (

			select 
					iave.period_iave_id,iave.fecha_ini,iave.fecha_fin,
					travel.no_viaje,travel.f_despachado,travel.id_area,travel.company_id,
					units.name 
					,case units.projections_corporations_id
						when 1 
							then 
								case (select 'TBK'+substring(units.name,1,3)) 
									when 'TBKGUA' 
										then 'TBKGDL' 
									when 'TBKLA'
										then 'TBKLAP'
									else 
										(select 'TBK'+substring(units.name,1,3)) 
								end
						when 2
							then
								case units.name
									when 'MACUSPANA'
										then 'ATMMAC'
									else units.name
								end
					   when 3
							then
								case (select 'TEI'+substring(units.name,1,3)) 
									when 'TEITUL'
										then 'TCGTUL'
									else
										(select 'TEI'+substring(units.name,1,3)) 
								end
					 end as 'cia'
					,travel.fecha_real_viaje,travel.fecha_real_fin_viaje,travel.no_ejes_viaje,travel.no_tarjeta_llave
					,travel.id_unidad
					,travel.iave_catalogo
					,travel.iave_viaje
					,travel.id_ruta,travel.desc_ruta
					,travel.id_caseta,travel.orden,travel.consecutivo
					,travel.desc_caseta
					,travel.no_de_ejes,travel.monto_iave,travel.tarifas
					,travel.liq_tipo_pago,travel.liq_paso,travel.liq_id_caseta,travel.liq_monto_caseta , travel.liq_monto_iave,travel.liq_no_liquidacion
					,travel.trliq_fecha_ingreso
			from 
				--@iave_periods as iave 
				sistemas.dbo.casetas_iave_periods as iave
				inner join
							(
								select 
										viaje.no_viaje,viaje.id_area,(select '1') as 'company_id'
										,cast(viaje.f_despachado as date) as 'f_despachado'
										,viaje.fecha_real_viaje,viaje.fecha_real_fin_viaje,viaje.no_ejes_viaje,viaje.no_tarjeta_llave,
										mtt.id_unidad,
										liave.no_tarjeta_iave as 'iave_catalogo',
										llave.no_tarjeta_iave as 'iave_viaje',
										ruta.id_ruta,ruta.desc_ruta,
										rcaseta.id_caseta,rcaseta.orden,rcaseta.consecutivo,
										caseta.desc_caseta,
										trcaseta.no_de_ejes,trcaseta.monto_iave,trcaseta.tarifas,
										liq.tipo_pago as 'liq_tipo_pago',liq.paso as 'liq_paso',liq.id_caseta as 'liq_id_caseta'
										,liq.monto_caseta as 'liq_monto_caseta' , liq.monto_iave as 'liq_monto_iave',liq.no_liquidacion as 'liq_no_liquidacion'
										,trliq.fecha_ingreso as 'trliq_fecha_ingreso'
								from 
											bonampakdb.dbo.trafico_viaje as viaje 
									inner join
											bonampakdb.dbo.mtto_unidades as mtt on viaje.id_area = mtt.id_area and viaje.id_unidad = mtt.id_unidad
									inner join 
											bonampakdb.dbo.trafico_ruta as ruta on viaje.id_ruta = ruta.id_ruta 
									inner join
											bonampakdb.dbo.trafico_ruta_caseta as rcaseta on viaje.id_ruta = rcaseta.id_ruta
									inner join 
											bonampakdb.dbo.trafico_caseta as caseta on rcaseta.id_caseta = caseta.id_caseta
									inner join
											bonampakdb.dbo.trafico_renglon_caseta as trcaseta on caseta.id_caseta = trcaseta.id_caseta and viaje.no_ejes_viaje = trcaseta.no_de_ejes
									left join 
											bonampakdb.dbo.trafico_catiaveunidoper as liave on viaje.id_area = liave.id_area and liave.fecha_fin_mov is null and liave.id_unidad = mtt.id_unidad
									left join 
											bonampakdb.dbo.trafico_catiaveunidoper as llave on viaje.no_tarjeta_llave = llave.no_tarjeta_iave and viaje.id_area = llave.id_area and llave.fecha_fin_mov is null and llave.id_unidad = mtt.id_unidad
									left join 
											bonampakdb.dbo.trafico_liquidacion_casetas as liq on viaje.no_viaje = liq.no_viaje and viaje.id_area = liq.id_area  and caseta.id_caseta = liq.id_caseta and viaje.no_liquidacion = liq.no_liquidacion and liq.consecutivo = rcaseta.consecutivo
									left join
											bonampakdb.dbo.trafico_liquidacion as trliq on viaje.no_liquidacion = trliq.no_liquidacion and viaje.id_area = trliq.id_area
							union all
								select 
										viaje.no_viaje,viaje.id_area,(select '2') as 'company_id'
										,cast(viaje.f_despachado as date) as 'f_despachado'
										,viaje.fecha_real_viaje,viaje.fecha_real_fin_viaje,viaje.no_ejes_viaje,viaje.no_tarjeta_llave,
										mtt.id_unidad,
										liave.no_tarjeta_iave as 'iave_catalogo',
										llave.no_tarjeta_iave as 'iave_viaje',
										ruta.id_ruta,ruta.desc_ruta,
										rcaseta.id_caseta,rcaseta.orden,rcaseta.consecutivo,
										caseta.desc_caseta,
										trcaseta.no_de_ejes,trcaseta.monto_iave,trcaseta.tarifas,
										liq.tipo_pago as 'liq_tipo_pago',liq.paso as 'liq_paso',liq.id_caseta as 'liq_id_caseta'
										,liq.monto_caseta as 'liq_monto_caseta' , liq.monto_iave as 'liq_monto_iave',liq.no_liquidacion as 'liq_no_liquidacion'
										,trliq.fecha_ingreso as 'trliq_fecha_ingreso'
								from 
											macuspanadb.dbo.trafico_viaje as viaje 
									inner join
											macuspanadb.dbo.mtto_unidades as mtt on viaje.id_area = mtt.id_area and viaje.id_unidad = mtt.id_unidad
									inner join 
											macuspanadb.dbo.trafico_ruta as ruta on viaje.id_ruta = ruta.id_ruta 
									inner join
											macuspanadb.dbo.trafico_ruta_caseta as rcaseta on viaje.id_ruta = rcaseta.id_ruta
									inner join 
											macuspanadb.dbo.trafico_caseta as caseta on rcaseta.id_caseta = caseta.id_caseta
									inner join
											macuspanadb.dbo.trafico_renglon_caseta as trcaseta on caseta.id_caseta = trcaseta.id_caseta and viaje.no_ejes_viaje = trcaseta.no_de_ejes
									left join 
											macuspanadb.dbo.trafico_catiaveunidoper as liave on viaje.id_area = liave.id_area and liave.fecha_fin_mov is null and liave.id_unidad = mtt.id_unidad
									left join 
											macuspanadb.dbo.trafico_catiaveunidoper as llave on viaje.no_tarjeta_llave = llave.no_tarjeta_iave and viaje.id_area = llave.id_area and llave.fecha_fin_mov is null and llave.id_unidad = mtt.id_unidad
									left join 
											macuspanadb.dbo.trafico_liquidacion_casetas as liq on viaje.no_viaje = liq.no_viaje and viaje.id_area = liq.id_area  and caseta.id_caseta = liq.id_caseta and viaje.no_liquidacion = liq.no_liquidacion and liq.consecutivo = rcaseta.consecutivo
									left join
											macuspanadb.dbo.trafico_liquidacion as trliq on viaje.no_liquidacion = trliq.no_liquidacion and viaje.id_area = trliq.id_area
							union all
								select 
										viaje.no_viaje,viaje.id_area,(select '3') as 'company_id'
										,cast(viaje.f_despachado as date) as 'f_despachado'
										,viaje.fecha_real_viaje,viaje.fecha_real_fin_viaje,viaje.no_ejes_viaje,viaje.no_tarjeta_llave,
										mtt.id_unidad,
										liave.no_tarjeta_iave as 'iave_catalogo',
										llave.no_tarjeta_iave as 'iave_viaje',
										ruta.id_ruta,ruta.desc_ruta,
										rcaseta.id_caseta,rcaseta.orden,rcaseta.consecutivo,
										caseta.desc_caseta,
										trcaseta.no_de_ejes,trcaseta.monto_iave,trcaseta.tarifas,
										liq.tipo_pago as 'liq_tipo_pago',liq.paso as 'liq_paso',liq.id_caseta as 'liq_id_caseta'
										,liq.monto_caseta as 'liq_monto_caseta' , liq.monto_iave as 'liq_monto_iave',liq.no_liquidacion as 'liq_no_liquidacion'
										,trliq.fecha_ingreso as 'trliq_fecha_ingreso'
								from 
											tespecializadadb.dbo.trafico_viaje as viaje 
									inner join
											tespecializadadb.dbo.mtto_unidades as mtt on viaje.id_area = mtt.id_area and viaje.id_unidad = mtt.id_unidad
									inner join 
											tespecializadadb.dbo.trafico_ruta as ruta on viaje.id_ruta = ruta.id_ruta 
									inner join
											tespecializadadb.dbo.trafico_ruta_caseta as rcaseta on viaje.id_ruta = rcaseta.id_ruta
									inner join 
											tespecializadadb.dbo.trafico_caseta as caseta on rcaseta.id_caseta = caseta.id_caseta
									inner join
											tespecializadadb.dbo.trafico_renglon_caseta as trcaseta on caseta.id_caseta = trcaseta.id_caseta and viaje.no_ejes_viaje = trcaseta.no_de_ejes
									left join 
											tespecializadadb.dbo.trafico_catiaveunidoper as liave on viaje.id_area = liave.id_area and liave.fecha_fin_mov is null and liave.id_unidad = mtt.id_unidad
									left join 
											tespecializadadb.dbo.trafico_catiaveunidoper as llave on viaje.no_tarjeta_llave = llave.no_tarjeta_iave and viaje.id_area = llave.id_area and llave.fecha_fin_mov is null and llave.id_unidad = mtt.id_unidad
									left join 
											tespecializadadb.dbo.trafico_liquidacion_casetas as liq on viaje.no_viaje = liq.no_viaje and viaje.id_area = liq.id_area  and caseta.id_caseta = liq.id_caseta and viaje.no_liquidacion = liq.no_liquidacion and liq.consecutivo = rcaseta.consecutivo
									left join
											tespecializadadb.dbo.trafico_liquidacion as trliq on viaje.no_liquidacion = trliq.no_liquidacion and viaje.id_area = trliq.id_area
							) as travel
				on travel.f_despachado between iave.fecha_ini and iave.fecha_fin
				inner join
						sistemas.dbo.projections_view_bussiness_units as units
					on	
						units.id_area = travel.id_area 
					and
						units.projections_corporations_id = travel.company_id -- tbk
	) 
------ ===================================== set the query ========================================================
	insert into @tollbooth_no_trips
	select 
			 op.period_iave_id,op.fecha_ini,op.fecha_fin
			,op.no_viaje,op.f_despachado,op.id_area,op.name,op.cia,op.company_id
			,op.id_unidad,op.iave_catalogo,op.iave_viaje,op.id_ruta,op.desc_ruta,op.id_caseta
			--
			,op.fecha_real_viaje,op.fecha_real_fin_viaje
			,datediff(hh,op.fecha_real_viaje,op.fecha_real_fin_viaje) as 'diff_length_hours'
			,op.no_ejes_viaje,op.no_tarjeta_llave	
			,op.orden,op.consecutivo
			,op.desc_caseta
			,op.no_de_ejes,op.monto_iave,op.tarifas
			,op.liq_tipo_pago,op.liq_paso,op.liq_id_caseta,op.liq_monto_caseta , op.liq_monto_iave,op.liq_no_liquidacion
			,op.trliq_fecha_ingreso
			--
			,file_period._filename,file_period.iave_period
			,file_period.casetas_controls_files_id,file_period.casetas_historical_conciliations_id
			,file_period.fecha_conciliacion
			,NULL as '_modified'
			,1 as '_status'
	from 
			ops as op
		left join 
					(
						select  
								 histo.casetas_historical_conciliations_id
								,per.casetas_controls_files_id
								,con._filename
								,con.cia,per.key_num_2 as 'iave_period'
								,fcon.created as 'fecha_conciliacion'
						from 
								sistemas.dbo.casetas_views as con
							inner join
										(
											select  sisco.casetas_controls_files_id,sisco.key_num_2 ,sisco._filename COLLATE SQL_Latin1_General_CP1_CI_AS as '_filename',sisco._area 
											from sistemas.dbo.casetas as sisco
											group by sisco.casetas_controls_files_id,sisco.key_num_2 ,sisco._filename,sisco._area
										) 
								as per on per._filename = con._filename
							left join  
										(
											select 
													 max(hist.id) as 'casetas_historical_conciliations_id'
													,hist.casetas_controls_files_id
											from
													sistemas.dbo.casetas_historical_conciliations as hist 
											-- -
												--where hist.casetas_controls_files_id = 21 --and rstand.casetas_standings_id = 1
											-- -
											group by	hist.casetas_controls_files_id--,hist.created
										) 
								as histo on histo.casetas_controls_files_id = per.casetas_controls_files_id
							inner join
										sistemas.dbo.casetas_historical_conciliations as fcon 
									on 
										fcon.casetas_controls_files_id = histo.casetas_controls_files_id 
									and 
										fcon.id = histo.casetas_historical_conciliations_id
						group by 
								 histo.casetas_historical_conciliations_id,per.casetas_controls_files_id,con._filename,con.cia,per.key_num_2
								 ,fcon.created
					)
		as file_period on op.period_iave_id = file_period.iave_period and (select cast(file_period.cia as nvarchar(10)) COLLATE SQL_Latin1_General_CP1_CI_AS) = op.cia
		-- -
			where 
					--	file_period.casetas_controls_files_id = '21'  and file_period.casetas_historical_conciliations_id ='25' ---977 records---
					--and
						op.no_viaje not in 
											(
												select 
														concl.no_viaje 
												from 
														sistemas.dbo.casetas_view_conciliated_trips as concl
												where 
														concl.casetas_controls_files_id = file_period.casetas_controls_files_id
													and 
														concl.casetas_historical_conciliations_id = file_period.casetas_historical_conciliations_id
													and
														concl.iave_period = op.period_iave_id
											)
		-- -
	order by op.period_iave_id,file_period._filename,op.no_viaje,op.f_despachado,op.fecha_ini,op.cia,op.orden;

	truncate table sistemas.dbo.casetas_lis_not_conciliations ;
	insert into sistemas.dbo.casetas_lis_not_conciliations 
	select * from @tollbooth_no_trips
end
go




------ ===================================== DONE ========================================================
-- Cruces no correspondidos de I+D en lIS	 Fechas de Cruce no encontrados en LIS
select
		 *
from 
		sistemas.dbo.casetas_views 
where 
		casetas_controls_files_id = 21 and casetas_historical_conciliations_id = 25 and casetas_standings_id = 6 

select
		 *
from 
		sistemas.dbo.casetas_views 
where 
		casetas_controls_files_id = 21 and casetas_historical_conciliations_id = 25 and casetas_standings_id = 7



--	select * from sistemas.dbo.casetas_view_conciliated_trips 
--		where 
--				no_viaje = 22860


--select  sisco.casetas_controls_files_id,sisco.key_num_2 ,sisco._filename COLLATE SQL_Latin1_General_CP1_CI_AS as '_filename',sisco._area 
--from sistemas.dbo.casetas as sisco
--where _area = 'TEICUA'
--group by sisco.casetas_controls_files_id,sisco.key_num_2 ,sisco._filename,sisco._area
--	select * from sistemas.dbo.casetas_views where no_viaje = 22860
-- ===================================== trips to exclude  ========================================================

--select * from sistemas.dbo.casetas_views where casetas_controls_files_id = 1

--select * from sistemas.dbo.casetas_controls_files where _filename in ('1338.379')

--select * from sistemas.dbo.casetas_historical_conciliations where casetas_controls_files_id = 11



	------with historic 
	------				(
	------					 casetas_historical_conciliations_id
	------					,casetas_controls_files_id	
	------				)
	------	as (
	------			select 
	------					max(hist.id) as 'casetas_historical_conciliations_id',hist.casetas_controls_files_id
	------			from
	------					sistemas.dbo.casetas_historical_conciliations as hist 
	------			group by	
	------					hist.casetas_controls_files_id
	------		)
	------select 
	------		 hist.casetas_historical_conciliations_id
	------		,hist.casetas_controls_files_id
	------		,iave_per._filename,iave_per.cia,iave_per.iave_period
	------		,rstand._filename,rstand.casetas_standings_id,rstand.casetas_standings_name,rstand.casetas_historical_conciliations_id
	------		,vw.no_viaje,vw.cia,vw.casetas_standings_id
	------from
	------		historic as hist
	------		left join
	------					(
	------						select 
	------								per.casetas_controls_files_id,con._filename,con.cia,per.key_num_2 as 'iave_period'
	------						from 
	------								sistemas.dbo.casetas_views as con
	------							inner join
	------										(
	------											select  casetas_controls_files_id,key_num_2 ,_filename COLLATE SQL_Latin1_General_CP1_CI_AS as '_filename',_area from sistemas.dbo.casetas
	------											group by casetas_controls_files_id,key_num_2 ,_filename,_area
	------										) 
	------								as per on per._filename = con._filename
	------						group by 
	------								per.casetas_controls_files_id,con._filename,con.cia,per.key_num_2
	------					)
	------			as iave_per on iave_per.casetas_controls_files_id = hist.casetas_controls_files_id
	------		inner join 
	------				sistemas.dbo.casetas_view_resume_stands as rstand
	------					on hist.casetas_historical_conciliations_id = rstand.casetas_historical_conciliations_id and hist.casetas_controls_files_id = rstand.casetas_controls_files_id
	------						and 
	------							rstand.casetas_standings_id = 1	
	------		left join
	------				sistemas.dbo.casetas_views as vw
	------					on 	vw.casetas_historical_conciliations_id = rstand.casetas_historical_conciliations_id and vw.casetas_controls_files_id = hist.casetas_controls_files_id
	------						and
	------							vw.casetas_standings_id = rstand.casetas_standings_id
	-------- -
	------	--where hist.casetas_controls_files_id = 21 -- and vw.no_viaje = '22812'
	-------- -
	------group by	
	------			hist.casetas_controls_files_id,hist.casetas_historical_conciliations_id
	------			,iave_per._filename,iave_per.cia,iave_per.iave_period
	------			,rstand._filename,rstand.casetas_standings_id,rstand.casetas_standings_name,rstand.casetas_historical_conciliations_id
	------			,vw.no_viaje,vw.cia,vw.casetas_standings_id
	------order by 
	------			hist.casetas_controls_files_id




--select f_despachado,fecha_real_viaje,fecha_real_fin_viaje,id_area,* from trafico_viaje where no_viaje = '22812' and id_area = 1


------select * from sistemas.dbo.casetas_views 
------	where 
------		--no_viaje = '22812' and 
------		casetas_historical_conciliations_id = '25' and
------		id_unidad = 'TT1248'
------	order by no_viaje

 
------select * from sistemas.dbo.casetas where _area = 'TBKORI' and unit = 'TT1248' and fecha_a between '2016-07-01' and '2016-07-10' --and key_num_4 = '9'
------		and _filename = '1338.379'
------order by fecha_a,time_a

------select * from sistemas.dbo.casetas_view_resume_stands where casetas_controls_files_id = 1
--------select * from sistemas.dbo.casetas_controls_conciliations where casetas_controls_files_id = 1
------select * from sistemas.dbo.casetas_view_resumes where casetas_controls_files_id = 1







-------- ==========================================================================================================================================
--------	This is the IAVE file , previously loaded in a db , same enviorement as before , the squemas follows the params of the firts development
-------- ==========================================================================================================================================

--------select * from sistemas.dbo.casetas where _area = 'TBKORI' and unit = 'TT1177' and fecha_a between '2016-06-25' and '2016-06-30' and key_num_4 = '9'
--------		and _filename = '1338 378 ORIZABA'
--------order by fecha_a,time_a

-------- ==========================================================================================================================================
--------	End of the Query
-------- ==========================================================================================================================================







-------- ====================== periods from conciliations ======================================
	
------	select 
------			histo.casetas_historical_conciliations_id,per.casetas_controls_files_id,con._filename,con.cia,per.key_num_2 as 'iave_period'
------	from 
------			sistemas.dbo.casetas_views as con	
------		inner join
------					(
------						select  casetas_controls_files_id,key_num_2 ,_filename COLLATE SQL_Latin1_General_CP1_CI_AS as '_filename',_area from sistemas.dbo.casetas
------						group by casetas_controls_files_id,key_num_2 ,_filename,_area
------					) 
------			as per on per._filename = con._filename
------		left join  
------					(
------						select 
------								max(hist.id) as 'casetas_historical_conciliations_id',hist.casetas_controls_files_id
------						from
------								sistemas.dbo.casetas_historical_conciliations as hist 
------						-- -
------			--				where hist.casetas_controls_files_id = 1 --and rstand.casetas_standings_id = 1
------						-- -
------						group by	hist.casetas_controls_files_id
------					)
------			as histo on histo.casetas_controls_files_id = per.casetas_controls_files_id
--------
------	where
------		per.key_num_2 = '379'
------		and substring(cia,1,3) = 'TBK'
--------	
------	group by 
------			histo.casetas_historical_conciliations_id,per.casetas_controls_files_id,con._filename,con.cia,per.key_num_2
------	go

-------- ======================================= new CORE -- casetas -- ===============================================

--------select 
--------		viaje.no_viaje,viaje.id_area,viaje.f_despachado,viaje.fecha_real_viaje,viaje.fecha_real_fin_viaje,viaje.no_ejes_viaje,viaje.no_tarjeta_llave,viaje.no_liquidacion,viaje.id_areaviaje
--------		,mtt.id_unidad
--------		,liave.no_tarjeta_iave as 'iave_catalogo'
--------		,llave.no_tarjeta_iave as 'iave_viaje'
--------		,ruta.id_ruta,ruta.desc_ruta
--------		,rcaseta.id_caseta,rcaseta.orden,rcaseta.consecutivo
--------		,caseta.desc_caseta
--------		,trcaseta.no_de_ejes,trcaseta.monto_iave,trcaseta.tarifas
--------		,liq.tipo_pago as 'liq_tipo_pago',liq.paso as 'liq_paso',liq.id_caseta as 'liq_id_caseta',liq.monto_caseta as 'liq_monto_caseta' , liq.monto_iave as 'liq_monto_iave'
--------from 
--------		trafico_viaje as viaje 
--------	inner join
--------			mtto_unidades as mtt on viaje.id_area = mtt.id_area and viaje.id_unidad = mtt.id_unidad
--------	inner join 
--------			trafico_ruta as ruta on viaje.id_ruta = ruta.id_ruta 
--------	inner join
--------			trafico_ruta_caseta as rcaseta on viaje.id_ruta = rcaseta.id_ruta
--------	inner join 
--------			trafico_caseta as caseta on rcaseta.id_caseta = caseta.id_caseta
--------	inner join
--------			trafico_renglon_caseta as trcaseta on caseta.id_caseta = trcaseta.id_caseta and viaje.no_ejes_viaje = trcaseta.no_de_ejes
--------	left join 
--------			trafico_catiaveunidoper as liave on viaje.id_area = liave.id_area and liave.fecha_fin_mov is null and liave.id_unidad = mtt.id_unidad
--------	left join 
--------			trafico_catiaveunidoper as llave on viaje.no_tarjeta_llave = llave.no_tarjeta_iave and viaje.id_area = llave.id_area and llave.fecha_fin_mov is null and llave.id_unidad = mtt.id_unidad
--------	left join 
--------			trafico_liquidacion_casetas as liq on viaje.no_viaje = liq.no_viaje and viaje.id_area = liq.id_area  and caseta.id_caseta = liq.id_caseta and viaje.no_liquidacion = liq.no_liquidacion and liq.consecutivo = rcaseta.consecutivo
---------- where viaje.id_area = 5 and viaje.no_viaje in ('6840')
--------order by viaje.no_viaje,rcaseta.orden

--------select * from trafico_liquidacion_casetas where no_liquidacion = '1783' and id_area = 5
--------select no_ejes_viaje,* from trafico_viaje where no_viaje = '6840' and id_area = 5
--------select * from mtto_unidades where id_area = 5 and id_unidad = 'TT1201'
--------select * from trafico_ruta where id_ruta = '158'
--------select * from trafico_ruta_caseta where id_ruta = '158'
--------select * from trafico_caseta ca inner join trafico_ruta_caseta ru on ru.id_caseta = ca.id_caseta where ru.id_ruta = '158'

--------select * from trafico_renglon_caseta where id_caseta in ('63','3') and no_de_ejes = '5'


-------- ================================== area ====================================
--------conciliado
--------select * from sistemas.dbo.casetas_views where cia = 'TBKORI' and no_viaje = '22647'
-------- archivo iave

------select * from sistemas.dbo.casetas where _area = 'TBKORI' and unit = 'TT1177' and fecha_a between '2016-06-25' and '2016-06-30' and key_num_4 = '9'
------		and _filename = '1338 378 ORIZABA'
------order by fecha_a,time_a


--------select * from trafico_ruta where id_ruta = '379'

--------select * from trafico_ruta_caseta where id_ruta = '379'

-------- ================================================================================================================================
-------- select * from trafico_viaje where id_unidad =  'TT1177' and id_area = '1' and f_despachado between '2016-06-20' and '2016-06-30'
-------- ================================================================================================================================

------go


--------1208
--------select
--------		no_viaje,	
--------		cast(f_despachado as date) as 'f_despachado',cast(fecha_real_viaje as date) as 'fecha_real_viaje',
--------		cast(fecha_real_fin_viaje as date) as 'fecha_real_fin_viaje',
--------		f_despachado,fecha_real_viaje,fecha_real_fin_viaje 
--------from 
--------		bonampakdb.dbo.trafico_viaje where cast(f_despachado as date) between '2016-05-21' and '2016-05-31'




--------select
--------		no_viaje,	
--------		cast(f_despachado as date) as 'f_despachado',cast(fecha_real_viaje as date) as 'fecha_real_viaje',
--------		cast(fecha_real_fin_viaje as date) as 'fecha_real_fin_viaje',
--------		f_despachado,fecha_real_viaje,fecha_real_fin_viaje 
--------from 
--------		bonampakdb.dbo.trafico_viaje where f_despachado between '2016-05-21' and '2016-05-31'




--------declare @trips_in_periods table 
--------								(
--------									id				int identity(1,1),
--------									user_id			int,
--------									company_id		int,
--------									id_area			int,
--------									no_viaje		int,
--------									created			datetime,
--------									modified		datetime,
--------									_status			tinyint default 1 null
--------								)



--------select 
--------		preiod_iave_id,fecha_ini,fecha_fin 
--------from
--------		@iave_periods as iave_periods
		
--------	inner join 
		
--------go		
		

--------select * from sistemas.dbo.casetas_views where no_viaje = '52720'




--------select no_viaje from sistemas.dbo.casetas_views 
--------where casetas_historical_conciliations_id = '295' and casetas_controls_files_id = '1' and no_viaje is not null
--------group by no_viaje










--------select * from bonampakdb.dbo.trafico_viaje as viaje where viaje.no_viaje = 24290 and viaje.id_area = 1


-------- ====================================================================================================================================
--------	Javier Garcia Analisis
-------- ====================================================================================================================================

--------use bonampakdb;

--------Declare @no_viaje int;
--------Declare @no_ejes int;
--------Declare @id_area int;

--------Select @id_area = 1
--------Select @no_viaje =  24290
--------select @no_ejes = (select no_ejes_viaje from trafico_viaje where no_viaje = @no_viaje and id_area = @id_area) 


---------- ======================================================================================

--------Select 
--------		tv.no_viaje,tv.id_unidad,TV.no_ejes_viaje, tv.no_liquidacion,tv.id_ruta,tv.fecha_real_viaje,
--------		tv.f_despachado,tv.fecha_real_fin_viaje,tr.desc_ruta,tv.id_personal,tv.id_remolque1,tv.id_remolque2,
--------		*
--------from 
--------		trafico_viaje TV 
--------	INNER JOIN trafico_ruta TR on TV.id_ruta = TR.id_ruta
--------where 
--------		TV.no_viaje = @no_viaje and id_area = @id_area

--------Select tv.no_viaje,Tv.id_ruta, tv.no_liquidacion,TC.id_caseta,TC.desc_caseta, TRC.consecutivo,
--------* 
--------from trafico_viaje TV 
--------INNER JOIN trafico_ruta TR on TV.id_ruta = TR.id_ruta
--------INNER JOIN trafico_ruta_caseta TRC on TRC.id_ruta = TV.id_ruta
--------INNER JOIN trafico_caseta TC on TC.id_caseta = TRC.id_caseta 
--------INNER JOIN trafico_renglon_caseta TRRC on TRRC.id_caseta = TC.id_caseta and TRRC.no_de_ejes = @no_ejes
--------where TV.no_viaje = @no_viaje and id_area = @id_area order by TRC.consecutivo 


--------select TCV.id_caseta, TC.desc_caseta, TRC.monto_iave, TRC.no_de_ejes from trafico_casetaviaje TCV 
--------INNER JOIN trafico_caseta TC on TCV.id_caseta = TC.id_caseta
--------INNER JOIN trafico_renglon_caseta TRC on TC.id_caseta = TRC.id_caseta 
--------where no_viaje = @no_viaje and id_area = @id_area and  TCV.no_ejes = @no_ejes and TRC.no_de_ejes =@no_ejes

--------Select id_caseta, nombre_caseta, *from trafico_liquidacion_casetas where no_viaje = @no_viaje and no_ejes = @no_ejes



