
select * from openquery(local,'msdb.dbo.sp_help_job') where name like 'mr_%'

-- delete a job
select job_id,name from openquery(local,'msdb.dbo.sp_help_job') where name like 'mr_%'



-- DELETE a job
-- use msdb
-- EXEC sp_delete_job @job_name = N'NightlyBackups' |  EXEC sp_delete_job @job_id = N'1CC8417A-C0AD-42B3-A397-08E15A9512D8'