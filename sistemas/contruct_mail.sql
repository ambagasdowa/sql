sp_CONFIGURE 'show advanced', 1
GO
RECONFIGURE
GO
sp_CONFIGURE 'Database Mail XPs', 1
GO
RECONFIGURE
GO

USE msdb ;  
GO  
EXECUTE dbo.sysmail_start_sp ;  
GO  


EXECUTE msdb.dbo.sysmail_help_profileaccount_sp

EXEC msdb.dbo.sysmail_help_principalprofile_sp;

EXEC msdb.dbo.sysmail_stop_sp;
EXEC msdb.dbo.sysmail_start_sp;

EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'mail';

SELECT * FROM msdb.dbo.sysmail_event_log where mailitem_id = '178';

SELECT sent_account_id, sent_date FROM msdb.dbo.sysmail_sentitems;

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'mail_delivery_system',  
    @recipients = 'baizabal.jesus@gmail.com',  
    @query = 'SELECT COUNT(*) FROM sistemas.dbo.casetas  
                  WHERE fecha_a > ''2016-04-30''  
                  AND  DATEDIFF(dd, ''2016-04-30'', fecha_a) < 2' ,  
    @subject = 'Work Order Count',
	@body = 'mail test',  
    @attach_query_result_as_file = 1 ;



	USE msdb ;  
GO  
 select sent_status,sent_date,send_request_date,* from sysmail_allitems where sent_status <> 'sent' and year(send_request_date)  = '2016' and month(send_request_date) >= '07'

-- Show the subject, the time that the mail item row was last  
-- modified, and the log information.  
-- Join sysmail_faileditems to sysmail_event_log   
-- on the mailitem_id column.  
-- In the WHERE clause list items where danw was in the recipients,  
-- copy_recipients, or blind_copy_recipients.  
-- These are the items that would have been sent  
-- to danw.  
  
SELECT items.subject,  
    items.last_mod_date  
    ,l.description FROM dbo.sysmail_faileditems as items  
INNER JOIN dbo.sysmail_event_log AS l  
    ON items.mailitem_id = l.mailitem_id  
WHERE items.recipients LIKE '%danw%'    
    OR items.copy_recipients LIKE '%danw%'   
    OR items.blind_copy_recipients LIKE '%danw%'  
GO  

--soporte@gsttransportes.com
-- S0p0rt34@
--The mail could not be sent to the recipients because of the mail server failure. (Sending Mail using Account 13 (2016-09-27T12:21:35). Exception Message: Cannot send mails to mail server. (Mailbox unavailable. The server response was: "JunkMail rejected - (INTEGRABD) [187.141.67.226]:54355 is in an RBL, see).)