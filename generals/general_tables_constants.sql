-- ==================================================================================================================== --	
-- =================================     General Tables for Constant Values      ====================================== --
-- ==================================================================================================================== --

/*===============================================================================
 Author         : Jesus Baizabal
 email			: ambagasdowa@gmail.com
 Create date    : April 06, 2017
 Description    : Build Tables for constant values like months names translation to spanish names
 TODO			: clean
 @Last_patch	: --
 @license       : MIT License (http://www.opensource.org/licenses/mit-license.php)
 Database owner : bonampak s.a de c.v 
 @status        : Stable
 @version		: 1.0.0
 ===============================================================================*/


-- ==================================================================================================================== --	
-- =================================     	  month translation table		     ====================================== --
-- ==================================================================================================================== --


use sistemas

IF OBJECT_ID('dbo.generals_month_translations', 'U') IS NOT NULL 
  DROP TABLE dbo.generals_month_translations; 

set ansi_nulls on

set quoted_identifier on

set ansi_padding on

 
create table dbo.generals_month_translations(
		id									int identity(1,1),
		month_num							int,
		month_name							nvarchar(60) 		collate		sql_latin1_general_cp1_ci_as,
		created								datetime,
		modified							datetime,
		_status								tinyint default 1 null
) on [primary]

set ansi_padding off

--	insert into sistemas.dbo.generals_month_translations values 	('1','enero',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('2','febrero',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('3','marzo',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('4','abril',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('5','mayo',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('6','junio',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('7','julio',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('8','agosto',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('9','septiembre',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('10','octubre',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('11','noviembre',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1'),
--																	('12','diciembre',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'1')
--																	
--	select * from sistemas.dbo.generals_month_translations
																	
																	
