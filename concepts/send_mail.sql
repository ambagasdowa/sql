

use msdb
exec sysmail_help_status_sp 

exec sysmail_help_account_sp

exec sysmail_help_profileaccount_sp

EXEC sp_send_dbmail @profile_name='mail_delivery_system',
      @recipients='jesus.mendozab@gsttransportes.com',
      @subject='Query Error',
      @body='An error occurred during execution of a statement. The Server is on Fire!'