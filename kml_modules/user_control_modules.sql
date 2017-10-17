-- ==================================================================================================================== --	
-- =================================     General Tables userModule Control builds    ================================== --
-- ==================================================================================================================== --

/*=====================================================================================================================
 Author         : Jesus Baizabal
 email			: baizabal.jesus@gmail.com
 Create date    : April 06, 2017
 Description    : Build Tables for user-credential mechanish for distinct modules in kml application
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 =====================================================================================================================*/


-- ==================================================================================================================== --	
-- =================================     	  main definition catalog		     ====================================== --
-- ==================================================================================================================== --


use sistemas

IF OBJECT_ID('module_user_credentials_mains', 'U') IS NOT NULL 
  DROP TABLE module_user_credentials_mains; 

set ansi_nulls on

set quoted_identifier on

set ansi_padding on

 
create table module_user_credentials_mains(
		id									int identity(1,1),
--		module_name							varchar(80) 		collate		sql_latin1_general_cp1_ci_as,
		module_description					text 		collate		sql_latin1_general_cp1_ci_as,
		model_name							nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
		database_name						nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
		database_column						nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
		model_option_var					nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
		is_in								tinyint default 1 null,
		module_ui_name						nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
		created								datetime,
		modified							datetime,
		_status								tinyint default 1 null
) on [primary]

set ansi_padding off




-- ==================================================================================================================== --	
-- =================================     	  users_control		     ====================================== --
-- ==================================================================================================================== --


use sistemas

IF OBJECT_ID('module_user_credentials_controls', 'U') IS NOT NULL 
  DROP TABLE module_user_credentials_controls; 

set ansi_nulls on

set quoted_identifier on

set ansi_padding on

 
create table module_user_credentials_controls(
		id									int identity(1,1),
		module_user_credentials_mains_id	int,
		user_id								int,
		value								nvarchar(250) 		collate		sql_latin1_general_cp1_ci_as,
		created								datetime,
		modified							datetime,
		_status								tinyint default 1 null
) on [primary]

set ansi_padding off



