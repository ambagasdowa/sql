


		select * from sistemas.dbo.projections_access_modules
		
		-- ==================== ADD control user module like casetas =================================== --
		select * from sistemas.dbo.projections_controls_users
		
		select * from sistemas.dbo.projections_accesses
		
		
		-- ==================== close a period ================================ --
		select * from sistemas.dbo.projections_closed_period_controls
		
-- ====================  irrelevant tables  ================================ --
		select * from sistemas.dbo.projections_periods --dont use 
		
		select * from sistemas.dbo.projections_cancelations -- dont use 
		
		select * from sistemas.dbo.projections_dismiss_cancelations -- dont use wrong table use dissmiss instead  
		
		select * from sistemas.dbo.projections_view_closed_periods -- dont use this
		
-- ====================  irrelevant tables  ================================ --
		
		
		-- ================== Control Tables ===================== --
		select * from sistemas.dbo.projections_fraccion_defs
		
		-- ==== group fraction by granel and others
		
		select * from sistemas.dbo.projections_fraccion_groups order by projections_corporations_id

		
		-- ============= core ======================= --
		
		use sistemas
		select TABLE_NAME ,TABLE_TYPE,TABLE_CATALOG 
		from INFORMATION_SCHEMA.TABLES 
		where TABLE_NAME like 'projections_%' order by TABLE_TYPE
		
		
		select * from sistemas.dbo.projections_dissmiss_cancelations -- canceled Cportes
		
		select * from sistemas.dbo.projections_view_indicators_periods order by mes,cyear -- get monthly closed, accepted and dissmiss data
		
		select * from sistemas.dbo.projections_closed_period_datas -- detail results by fraction , area and type of trip 0 or 1 
		
		select * from sistemas.dbo.projections_closed_period_controls -- Control the closed period by corporation ,area ,period and status
		
		select * from sistemas.dbo.projections_view_closed_period_units -- the control projections closed period 
		
		select * from sistemas.dbo.projections_logs 	-- temporal logs
		
		select * from sistemas.dbo.projections_systems_logs -- system wide logs truncate table sistemas.dbo.projections_systems_logs
		
		select * from sistemas.dbo.projections_view_bussiness_units
		
		select * from sistemas.dbo.projections_upt_indops  -- where updates of the indOps are stored
		
		
		
		
	-- =================== Visualize the closed Periods ================== --
		
		
		select 
				 (right( CONVERT(VARCHAR(10), per.projections_closed_periods, 105), 7) ) as 'projections_closed_periods_mod' 
				,per._status
				,per.projections_corporations_id ,per.id_area
		from 
				sistemas.dbo.projections_closed_period_controls as per
		where 
				per._status = 1
		order by 
				per._status,per.projections_closed_periods,per.projections_corporations_id,per.id_area
				
				
	-- =================== Visualize the closed Periods ================== --
		
		select * from sistemas.dbo.projections_logs
		
		