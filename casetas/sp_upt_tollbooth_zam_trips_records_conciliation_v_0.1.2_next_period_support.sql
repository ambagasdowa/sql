Use sistemas;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE sp_upt_tollbooth_zam_trips_records_conciliation
--(
--	@bussines_unit int,
--	@casetas_controls_files_id int,
--	@user_id int
--)
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
	 Description    : sp_upt_tollbooth_zam_trips_records_conciliation
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
	declare  @iave_periods table
								(
									period_iave_id				int,
									period_desc					nvarchar(80)	collate	sql_latin1_general_cp1_ci_as,
									fecha_ini					date,
									fecha_fin					date,
									offset_day_minus			int,
									offset_day_plus				int,
									user_id						int,
									created						datetime default current_timestamp,
									_status						tinyint default 1 null
								)

	insert into @iave_periods values	('375','Mayo 21 al 31','2016-05-21 00:00:00.000','2016-05-31 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('376','Junio 1 al 10','2016-06-01 00:00:00.000','2016-06-10 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('377','Junio 11 al 20','2016-06-11 00:00:00.000','2016-06-20 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('378','Junio 21 al 30','2016-06-21 00:00:00.000','2016-06-30 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('379','Julio 01 al 10','2016-07-01 00:00:00.000','2016-07-10 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('380','Julio 11 al 20','2016-07-11 00:00:00.000','2016-07-20 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('391','Noviembre 01 al 10','2016-11-01 00:00:00.000','2016-11-10 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('392','Noviembre 11 al 20','2016-11-11 00:00:00.000','2016-11-20 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('393','Noviembre 21 al 30','2016-11-21 00:00:00.000','2016-11-30 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1'),
										('394','Diciembre 01 al 10','2016-12-01 00:00:00.000','2016-12-10 23:59:00.000','5','1','1',CURRENT_TIMESTAMP,'1');

--select * from sistemas.dbo.casetas_iave_periods
--	insert into sistemas.dbo.casetas_iave_periods values (1,'393','Noviembre 21 al 30','2016-11-21','2016-11-30','5','1',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1');

	--declare @_periods as int ; set @_periods = '394';
	print 'updating ......';

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
	declare @tollbooth_next_full table
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
											ruta.id_ruta,ruta.desc_ruta -- fucking ruta
											--rcaseta.id_caseta,rcaseta.orden,rcaseta.consecutivo,
											--caseta.desc_caseta,
											--trcaseta.no_de_ejes,trcaseta.monto_iave,trcaseta.tarifas,
											,liq.id_caseta as 'id_caseta',liq.consecutivo as 'orden',liq.consecutivo as 'consecutivo'
											,liq.nombre_caseta as 'desc_caseta'
											,liq.no_ejes as 'no_de_ejes',liq.monto_iave as 'monto_iave',null as 'tarifas'
											--,liq.consecutivo as 'liq_orden',liq.no_ejes as 'liq_no_ejes',liq.nombre_caseta as 'liq_nombre_caseta'
											,liq.tipo_pago as 'liq_tipo_pago',liq.paso as 'liq_paso',liq.id_caseta as 'liq_id_caseta'
											,liq.monto_caseta as 'liq_monto_caseta' , liq.monto_iave as 'liq_monto_iave',trliq.no_liquidacion as 'liq_no_liquidacion'
											,trliq.fecha_ingreso as 'trliq_fecha_ingreso'
									from 
												bonampakdb.dbo.trafico_viaje as viaje 
										inner join
												bonampakdb.dbo.mtto_unidades as mtt on viaje.id_area = mtt.id_area and viaje.id_unidad = mtt.id_unidad
										inner join 
												bonampakdb.dbo.trafico_ruta as ruta on viaje.id_ruta = ruta.id_ruta 
										--inner join
										--		bonampakdb.dbo.trafico_ruta_caseta as rcaseta on viaje.id_ruta = rcaseta.id_ruta
										--inner join 
										--		bonampakdb.dbo.trafico_caseta as caseta on rcaseta.id_caseta = caseta.id_caseta
										--inner join
										--		bonampakdb.dbo.trafico_renglon_caseta as trcaseta on caseta.id_caseta = trcaseta.id_caseta and viaje.no_ejes_viaje = trcaseta.no_de_ejes
										left join 
												bonampakdb.dbo.trafico_catiaveunidoper as liave on viaje.id_area = liave.id_area and liave.fecha_fin_mov is null and liave.id_unidad = mtt.id_unidad
										left join 
												bonampakdb.dbo.trafico_catiaveunidoper as llave on viaje.no_tarjeta_llave = llave.no_tarjeta_iave and viaje.id_area = llave.id_area and llave.fecha_fin_mov is null and llave.id_unidad = mtt.id_unidad
										left join 
												bonampakdb.dbo.trafico_liquidacion_casetas as liq on viaje.no_viaje = liq.no_viaje and viaje.id_area = liq.id_area   and viaje.no_liquidacion = liq.no_liquidacion -- and liq.consecutivo = rcaseta.consecutivo and caseta.id_caseta = liq.id_caseta
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
											ruta.id_ruta,ruta.desc_ruta -- fucking ruta
											--rcaseta.id_caseta,rcaseta.orden,rcaseta.consecutivo,
											--caseta.desc_caseta,
											--trcaseta.no_de_ejes,trcaseta.monto_iave,trcaseta.tarifas,
											,liq.id_caseta as 'id_caseta',liq.consecutivo as 'orden',liq.consecutivo as 'consecutivo'
											,liq.nombre_caseta as 'desc_caseta'
											,liq.no_ejes as 'no_de_ejes',liq.monto_iave as 'monto_iave',null as 'tarifas'
											--,liq.consecutivo as 'liq_orden',liq.no_ejes as 'liq_no_ejes',liq.nombre_caseta as 'liq_nombre_caseta'
											,liq.tipo_pago as 'liq_tipo_pago',liq.paso as 'liq_paso',liq.id_caseta as 'liq_id_caseta'
											,liq.monto_caseta as 'liq_monto_caseta' , liq.monto_iave as 'liq_monto_iave',trliq.no_liquidacion as 'liq_no_liquidacion'
											,trliq.fecha_ingreso as 'trliq_fecha_ingreso'
									from 
												macuspanadb.dbo.trafico_viaje as viaje 
										inner join
												macuspanadb.dbo.mtto_unidades as mtt on viaje.id_area = mtt.id_area and viaje.id_unidad = mtt.id_unidad
										inner join 
												macuspanadb.dbo.trafico_ruta as ruta on viaje.id_ruta = ruta.id_ruta 
										--inner join
										--		macuspanadb.dbo.trafico_ruta_caseta as rcaseta on viaje.id_ruta = rcaseta.id_ruta
										--inner join 
										--		macuspanadb.dbo.trafico_caseta as caseta on rcaseta.id_caseta = caseta.id_caseta
										--inner join
										--		macuspanadb.dbo.trafico_renglon_caseta as trcaseta on caseta.id_caseta = trcaseta.id_caseta and viaje.no_ejes_viaje = trcaseta.no_de_ejes
										left join 
												macuspanadb.dbo.trafico_catiaveunidoper as liave on viaje.id_area = liave.id_area and liave.fecha_fin_mov is null and liave.id_unidad = mtt.id_unidad
										left join 
												macuspanadb.dbo.trafico_catiaveunidoper as llave on viaje.no_tarjeta_llave = llave.no_tarjeta_iave and viaje.id_area = llave.id_area and llave.fecha_fin_mov is null and llave.id_unidad = mtt.id_unidad
										left join 
												macuspanadb.dbo.trafico_liquidacion_casetas as liq on viaje.no_viaje = liq.no_viaje and viaje.id_area = liq.id_area   and viaje.no_liquidacion = liq.no_liquidacion -- and liq.consecutivo = rcaseta.consecutivo and caseta.id_caseta = liq.id_caseta
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
											ruta.id_ruta,ruta.desc_ruta -- fucking ruta
											--rcaseta.id_caseta,rcaseta.orden,rcaseta.consecutivo,
											--caseta.desc_caseta,
											--trcaseta.no_de_ejes,trcaseta.monto_iave,trcaseta.tarifas,
											,liq.id_caseta as 'id_caseta',liq.consecutivo as 'orden',liq.consecutivo as 'consecutivo'
											,liq.nombre_caseta as 'desc_caseta'
											,liq.no_ejes as 'no_de_ejes',liq.monto_iave as 'monto_iave',null as 'tarifas'
											--,liq.consecutivo as 'liq_orden',liq.no_ejes as 'liq_no_ejes',liq.nombre_caseta as 'liq_nombre_caseta'
											,liq.tipo_pago as 'liq_tipo_pago',liq.paso as 'liq_paso',liq.id_caseta as 'liq_id_caseta'
											,liq.monto_caseta as 'liq_monto_caseta' , liq.monto_iave as 'liq_monto_iave',trliq.no_liquidacion as 'liq_no_liquidacion'
											,trliq.fecha_ingreso as 'trliq_fecha_ingreso'
									from 
												tespecializadadb.dbo.trafico_viaje as viaje 
										inner join
												tespecializadadb.dbo.mtto_unidades as mtt on viaje.id_area = mtt.id_area and viaje.id_unidad = mtt.id_unidad
										inner join 
												tespecializadadb.dbo.trafico_ruta as ruta on viaje.id_ruta = ruta.id_ruta 
										--inner join
										--		tespecializadadb.dbo.trafico_ruta_caseta as rcaseta on viaje.id_ruta = rcaseta.id_ruta
										--inner join 
										--		tespecializadadb.dbo.trafico_caseta as caseta on rcaseta.id_caseta = caseta.id_caseta
										--inner join
										--		tespecializadadb.dbo.trafico_renglon_caseta as trcaseta on caseta.id_caseta = trcaseta.id_caseta and viaje.no_ejes_viaje = trcaseta.no_de_ejes
										left join 
												tespecializadadb.dbo.trafico_catiaveunidoper as liave on viaje.id_area = liave.id_area and liave.fecha_fin_mov is null and liave.id_unidad = mtt.id_unidad
										left join 
												tespecializadadb.dbo.trafico_catiaveunidoper as llave on viaje.no_tarjeta_llave = llave.no_tarjeta_iave and viaje.id_area = llave.id_area and llave.fecha_fin_mov is null and llave.id_unidad = mtt.id_unidad
										left join 
												tespecializadadb.dbo.trafico_liquidacion_casetas as liq on viaje.no_viaje = liq.no_viaje and viaje.id_area = liq.id_area   and viaje.no_liquidacion = liq.no_liquidacion -- and liq.consecutivo = rcaseta.consecutivo and caseta.id_caseta = liq.id_caseta
										left join
												tespecializadadb.dbo.trafico_liquidacion as trliq on viaje.no_liquidacion = trliq.no_liquidacion and viaje.id_area = trliq.id_area
								) as travel
	-- ancient logic
					on travel.fecha_real_viaje between iave.fecha_ini and iave.fecha_fin --984 records
					--on travel.f_despachado between iave.fecha_ini and iave.fecha_fin --984 records
	-- add new and better logic 
					--on 
					--		travel.fecha_real_viaje between iave.fecha_ini and iave.fecha_fin
					--	and -- 775
					--		travel.fecha_real_fin_viaje between iave.fecha_ini and iave.fecha_fin
					
						--OR 
						--and
						--(
						--	travel.fecha_real_viaje between iave.fecha_ini and iave.fecha_fin and travel.fecha_real_fin_viaje > iave.fecha_fin 
						--)

					inner join
							sistemas.dbo.projections_view_bussiness_units as units
						on	
							units.id_area = travel.id_area 
						and
							units.projections_corporations_id = travel.company_id -- tbk
				--where iave.period_iave_id in (select cast(item as int) as 'item' from sistemas.dbo.fnSplit(@_periods, '|'))  
		)
			 
	------ ===================================== set the query ========================================================
		insert into @tollbooth_no_trips
		select 
				 op.period_iave_id,op.fecha_ini,op.fecha_fin
				,op.no_viaje,op.f_despachado,op.id_area,op.name,op.cia,op.company_id
				,op.id_unidad,op.iave_catalogo,op.iave_viaje,op.id_ruta,op.desc_ruta,op.id_caseta
				--
				,op.fecha_real_viaje,op.fecha_real_fin_viaje
				--
				--,tool.fecha_a as 'tool_fecha_a',tool.time_a as 'tool_time_a'
				--
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
									 _fl.id as 'casetas_controls_files_id'
									,max(_hi.id) as 'casetas_historical_conciliations_id'
									,_fl._filename
									,_fl._area as 'cia'
									,per.key_num_2 as 'iave_period'
									,null as 'fecha_conciliacion'
							from 
									sistemas.dbo.casetas_controls_files as _fl
								left join 
									sistemas.dbo.casetas_historical_conciliations as _hi
							on 
									_fl.id = _hi.casetas_controls_files_id
								left join 
										  (
											select  
													sisco.casetas_controls_files_id,sisco.key_num_2 ,sisco._filename COLLATE SQL_Latin1_General_CP1_CI_AS as '_filename',sisco._area 
											from 
													sistemas.dbo.casetas as sisco
											group by 
													sisco.casetas_controls_files_id,sisco.key_num_2 ,sisco._filename,sisco._area
										  ) as per on per.casetas_controls_files_id = _fl.id

							group by 
									_fl.id,_fl._filename,_fl._area
									,per.key_num_2
						)
			as file_period on op.period_iave_id = file_period.iave_period and (select cast(file_period.cia as nvarchar(10)) COLLATE SQL_Latin1_General_CP1_CI_AS) = op.cia
			-- -
			-- -
		order by op.period_iave_id,file_period._filename,op.no_viaje,op.f_despachado,op.fecha_ini,op.cia,op.orden;

		--truncate table sistemas.dbo.casetas_lis_full_conciliations ;
		--insert into sistemas.dbo.casetas_lis_full_conciliations 
	if ((select options.switch from sistemas.dbo.casetas_options as options where options.option_name = 'next_period') = 1)
		begin
		;with next_full as 
			(
					select 
							 _full.period_iave_id
							,_full.fecha_ini
							,_full.fecha_fin
							,_full.no_viaje
							,_full.f_despachado
							,_full.id_area
							,_full.name
							,_full.cia
							,_full.company_id
							,_full.id_unidad
							,_full.iave_catalogo
							,_full.iave_viaje
							,_full.id_ruta
							,_full.desc_ruta
							,_full.id_caseta
							,_full.fecha_real_viaje
							,_full.fecha_real_fin_viaje
							,_full.diff_length_hours
							,_full.no_ejes_viaje
							,_full.no_tarjeta_llave
							,_full.orden
							,_full.consecutivo
							,_full.desc_caseta
							,_full.no_de_ejes
							,_full.monto_iave
							,_full.tarifas
							,_full.liq_tipo_pago
							,_full.liq_paso
							,_full.liq_id_caseta
							,_full.liq_monto_caseta
							,_full.liq_monto_iave
							,_full.liq_no_liquidacion
							,_full.trliq_fecha_ingreso
							,_full._filename
							,_full.iave_period
							,_full.casetas_controls_files_id
							,_full.casetas_historical_conciliations_id
							,_full.fecha_conciliacion
							,_full._modified
							,_full._status
					from @tollbooth_no_trips as _full -- where period_iave_id in ('394') and cia = 'TEICUA'

					union all

					select 
							 --nxt.lis_full_id
							 nxt.period_iave_id
							,nxt.fecha_ini
							,nxt.fecha_fin
							,nxt.no_viaje
							,nxt.f_despachado
							,nxt.id_area
							,nxt.name
							,nxt.cia
							,nxt.company_id
							,nxt.id_unidad
							,nxt.iave_catalogo
							,nxt.iave_viaje
							,nxt.id_ruta
							,nxt.desc_ruta
							,nxt.id_caseta
							,nxt.fecha_real_viaje
							,nxt.fecha_real_fin_viaje
							,nxt.diff_length_hours
							,nxt.no_ejes_viaje
							,nxt.no_tarjeta_llave
							,nxt.orden
							,nxt.consecutivo
							,nxt.desc_caseta
							,nxt.no_de_ejes
							,nxt.monto_iave
							,nxt.tarifas
							,nxt.liq_tipo_pago
							,cast(nxt.liq_paso as nvarchar(1)) collate	sql_latin1_general_cp1_ci_as
							,nxt.liq_id_caseta
							,nxt.liq_monto_caseta
							,nxt.liq_monto_iave
							,nxt.liq_no_liquidacion
							,nxt.trliq_fecha_ingreso
							--,nxt._filename
							,fil._filename
							,nxt.iave_period
							--,nxt.casetas_controls_files_id
							,fil.id as 'casetas_controls_files_id' 
							--,nxt.casetas_historical_conciliations_id
							,hist.casetas_historical_conciliations_id
							,nxt.fecha_conciliacion
							,nxt._modified
							,nxt._status
					from sistemas.dbo.casetas_lis_next_conciliations as nxt -- where period_iave_id in ('394') and cia in ('TEICUA')
						left join sistemas.dbo.casetas_controls_files as fil on nxt.iave_period = fil._fraction and nxt.cia = fil._area
									and fil._status = 1
						left join 
									(
										select max(h.id) as 'casetas_historical_conciliations_id',casetas_controls_files_id from sistemas.dbo.casetas_historical_conciliations as h group by casetas_controls_files_id
									) as hist on hist.casetas_controls_files_id = fil.id			
				)
				--truncate table sistemas.dbo.casetas_lis_full_conciliations
				insert into @tollbooth_next_full
					select * from next_full --where period_iave_id in ('394') and cia in ('TEICUA')
				;
			end
		else 
		   begin
				insert into @tollbooth_next_full
					select * from @tollbooth_no_trips --where period_iave_id in ('394') and cia in ('TEICUA')
				;
		   end

		truncate table sistemas.dbo.casetas_lis_full_conciliations
		insert into sistemas.dbo.casetas_lis_full_conciliations 
			select * from @tollbooth_next_full
		;
		print 'updating are successfull';
 end
go
	-- select * from sistemas.dbo.casetas_iave_periods
	-- select * from sistemas.dbo.casetas_lis_full_conciliations where period_iave_id = '394' and company_id = '2'
	--where casetas_controls_files_id = 106
	--order by casetas_controls_files_id