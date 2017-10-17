-- =============================================================================================== --
-- Process for delete conciliations 
-- =============================================================================================== --
-- search the conciliations history 
select casetas_controls_files_id,casetas_historical_conciliations_id from sistemas.dbo.casetas_view_resume_stands
	where casetas_controls_files_id = '397' 
group by casetas_controls_files_id,casetas_historical_conciliations_id

-- delete from historical

--delete the historical that not needed anymore 
select * from sistemas.dbo.casetas_historical_conciliations where casetas_controls_files_id = '397'
and id in ('1161','1162','1163')

-- delete from view
--delete 
select * from sistemas.dbo.casetas_views where casetas_controls_files_id = '397'
and casetas_historical_conciliations_id in ('1161','1162','1163')	

-- update controls
--update 
select * from sistemas.dbo.casetas_controls_conciliations set conciliations_count = '5' where casetas_controls_files_id = '397'


--delete 
select * from sistemas.dbo.casetas_lis_next_conciliations where casetas_controls_files_id = '397'
and casetas_historical_conciliations_id in ('1161','1162','1163')	

--delete
select * from sistemas.dbo.casetas_lis_full_conciliations where casetas_controls_files_id = '397'
and casetas_historical_conciliations_id in ('1161','1162','1163')	

-- delete 
select * from sistemas.dbo.casetas_lis_not_conciliations where casetas_controls_files_id = '397'
and casetas_historical_conciliations_id in ('1161','1162','1163')	
	

-- =============================================================================================== --
-- A madafaka chinese input 
-- =============================================================================================== --
-- Process for viajes that exists but not appear 
-- Extract and replace the character 0xa0c2 Name: YI SYLLABLE ME
-- Character: ꃂ U+A0C2
-- Various Useful Representations
-- UTF-8: 0xEA 0x83 0x82, UTF-16: 0xA0C2 , C octal escaped UTF-8: \352\203\202 , XML decimal entity: &#41154;
-- this problem comes from the ZAM suite in capture module of an iave id
-- in ZAM db
select no_tarjeta_iave,(replace(no_tarjeta_iave,' ','')) as 'toReplaced' from bonampakdb.dbo.trafico_catiaveunidoper where no_tarjeta_iave like '% '
--	update bonampakdb.dbo.trafico_catiaveunidoper set no_tarjeta_iave = (replace(no_tarjeta_iave,' ','')) where no_tarjeta_iave like '% '

--in casetas VIEW
-- fetching 12745 rows
	select no_tarjeta_iave,(replace(no_tarjeta_iave,' ','')) as 'toReplaced' from sistemas.dbo.casetas_views where no_tarjeta_iave like '% '
--	update sistemas.dbo.casetas_views set no_tarjeta_iave = (replace(no_tarjeta_iave,' ','')) where no_tarjeta_iave like '% '

	
	
	