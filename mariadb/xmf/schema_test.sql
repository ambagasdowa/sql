/**
  *
  *
  *
  */

use cakephp

select * from cakephp.users


select * from cakephp.roles


select id,username,role_id from cakephp.users





drop database cakephp
create database cakephp

show databases;

use cakephp;

show tables;
  -- Casillas descritions
  -- incidents report ->

  -- ============================================================================================================= --
  -- ==============================================   Casillas   ================================================= --
  -- ============================================================================================================= --

  create or replace table `xmf_casillas`(
   `id` 						int unsigned not null auto_increment,
   `name` 						char(50) not null,
   `description` 				char(150) not null,

   `rgl_id` 					INT NOT NULL,  -- ??
   `abo_id` 					INT NOT NULL,  -- ??
   `cap_id` 					INT NOT NULL,  -- ??

   `municipio` 					TEXT DEFAULT NULL,
   `seccion` 					TEXT DEFAULT NULL,
   -- key=> Clave [distrito,agrupamiento]
--    `clave_distrito`       		char(2) default null,
   `clave_agrupamiento`   		char(2) default null,
   -- key => [basica,contigua,especial]
   `tipo_casilla`       		text default null ,
--    `tipo_basica`         		boolean null default FALSE,
--    `tipo_contigua`       		int(2) default null,
--    `tipo_especial`       		boolean null default FALSE,
   -- `distrito` TEXT DEFAULT NULL,
   `urbana` 					TEXT DEFAULT NULL,
--    `tipo` TEXT DEFAULT NULL,  -- basica,contigua,especial || Presidente.Senador,Diputado,Ayuntamiento ??
   `distrito` 					TEXT DEFAULT NULL, -- IX,X Appears two times
   `locacion` 					TEXT DEFAULT NULL, -- localidad
   `hora_instalacion`			datetime,	
   `hora_inicio`				datetime,
   `hora_cierre`				datetime,
   `created` 					datetime,
   `modified` 					datetime,
    primary key (`id`),
    unique key (`name`)          -- avoid duplicates [optional]
  ) engine=InnoDB default charset=utf8mb4 ;

insert into `xmf_casillas` values 
						 (null,'CB201','description',1,1,1,'Solidaridad','seccion','XX','contigua','urbana','IX','...',now(),now(),now(),now(),now())
						,(null,'CB202','description',1,1,1,'Solidaridad','seccion','XX','contigua','urbana','IX','...',now(),now(),now(),now(),now())
						,(null,'CB206','description',1,1,1,'Solidaridad','seccion','XX','contigua','urbana','IX','...',now(),now(),now(),now(),now())
;



-- test
--  select * from `cakephp`.`xmf_casillas`
-- truncate `cakephp`.`casillas`
-- use `cakephp`
  -- ============================================================================================================= --
  -- =================================   Proposal of Par/Func Status Precense      =============================== --
  -- ============================================================================================================= --


  -- =================================   Partidos Catalog    =============================== --

  create or replace table `xmf_partidos`(
   `id` 			  		int unsigned not null auto_increment,
   `nombre`           		TEXT DEFAULT NULL, -- coal1, coal2 ....
   `formula`          		TEXT DEFAULT NULL, -- Coaliciones
   `is_coalicion`     		boolean not null default false,
   `has_parent`       		boolean not null default false,
   `parent_id`        		int unsigned null,
   `is_funcionario`	  		boolean not null default false ,
   `funcionario_name`		char(55) default null,
   `funcionario_lastname` 	char(55) default null,
   `description`      		text default null,
   `created`          		datetime,
   `modified`        		datetime,
    primary key (`id`)
   )engine=InnoDB default charset=utf8mb4;

  ALTER TABLE `xmf_partidos` COMMENT = 'INFORMACION PARTIDOS';
--   ALTER TABLE `partidos`
--     ADD PRIMARY KEY (`id`);
--   ALTER TABLE `partidos`
--   MODIFY `id` unsigned INT(11) NOT NULL AUTO_INCREMENT;
insert into `xmf_partidos` values
                             (null,'PAN','pan',0,0,null,true,'name','lastname','',now(),now())
                            ,(null,'PRI','pri',0,0,null,true,'','','',now(),now())
                            ,(null,'PRD','prd',0,0,null,true,'','','',now(),now())
                            ,(null,'PVE','pve',0,0,null,true,'','','',now(),now())
                            ,(null,'PT','pt',0,0,null,true,'','','',now(),now())
                            ,(null,'MC','mc',0,0,null,true,'','','',now(),now())
                            ,(null,'PANAL','panal',0,0,null,true,'','','',now(),now())
                            ,(null,'MORENA','morena',0,0,null,true,'','','',now(),now())
                            ,(null,'Pes','pes',0,0,null,true,'','','',now(),now())
                            ,(null,'Coalicion Pan-Prd-Mc','coa_pan_prd_mc',1,0,null,false,'','','',now(),now())
                            ,(null,'Pan-Prd','for_pan_prd',1,1,10,false,'','','',now(),now())
                            ,(null,'Pan-Mc','for_pan_mc',1,1,10,false,'','','',now(),now())
                            ,(null,'Prd-Mc','for_prd_mc',1,1,10,false,'','','',now(),now())
                            ,(null,'Coalicion Pri-Pve-Panal','coa_pri_pve_panal',1,0,null,false,'','','',now(),now())
                            ,(null,'Pri-Pve','for_pri_pve',1,1,14,false,'','','',now(),now())
                            ,(null,'Pri-Panal','for_pri_panal',1,1,14,false,'','','',now(),now())
                            ,(null,'Pve-Panal','for_pve_panal',1,1,14,false,'','','',now(),now())
                            ,(null,'Presidente','',0,0,null,true,'name','lastname','',now(),now())
                            ,(null,'Secretario','',0,0,null,true,'name','lastname','',now(),now())
                            ,(null,'Escrutador1','',0,0,null,true,'name','lastname','',now(),now())
                            ,(null,'Escrutador2','',0,0,null,true,'name','lastname','',now(),now())
                            ,(null,'Suplente1','',0,0,null,true,'name','lastname','',now(),now())
                            ,(null,'Suplente2','',0,0,null,true,'name','lastname','',now(),now())
                            ,(null,'Suplente3','',0,0,null,true,'name','lastname','',now(),now())
                            ;
-- ,true,'',''
-- test 
-- select * from `cakephp`.`xmf_partidos`
  -- =================================   Partidos Precense Status    =============================== --

	create or replace table `xmf_presences_references` (
	   `id` 			int unsigned not null auto_increment,
	   `xmf_casillas_id` 	int unsigned not null ,
	   `xmf_partidos_id` 	int unsigned not null ,
	   `is_present`  	boolean null,
	   `description` 	char(150) not null,   
	   `created` 		datetime,
	   `modified` 		datetime,
	    primary key (`id`)
	) engine=InnoDB default charset=utf8mb4;

	insert into `xmf_presences_references` values 
											 	 (null,1,1,1,'',now(),now())
											 	,(null,1,2,1,'',now(),now())
											 	,(null,1,10,1,'',now(),now())
											 	,(null,18,1,1,'',now(),now())
											 	,(null,19,1,1,'',now(),now())
											 	,(null,21,2,1,'',now(),now())
											 	,(null,22,7,1,'',now(),now())
	;
select * from `xmf_presences_references`
-- select * from xmf_partidos_references
-- truncate table partidos_references


 -- =================================   View of Precense Status    =============================== --
-- 
	create or replace view `xmf_funcionarios_presence_status` 
	as 
		select 
				 `prt`.id
				,`prt`.xmf_casillas_id
				,`prt`.xmf_partidos_id
				,`prt`.is_present
				,`prt`.description
				,`part`.nombre		as `nombre`
				,`part`.formula		as `descripcion`
		from 
				`cakephp`.`xmf_presences_references` as `prt` 
		inner join 
				`cakephp`.`xmf_partidos` as `part` on `prt`.xmf_partidos_id = `part`.id


  select * from `cakephp`.`xmf_funcionarios_presence_status` 

-- =================================   View of All Functioners    =============================== --		

create or replace view `xmf_presences` 
as 
select
			 @rownum := @rownum + 1 AS rank,
 			,`cas`.id as 'casillas_index'
			,`cas`.name
			,`cas`.rgl_id,abo_id
			,`cas`.cap_id
			,`cas`.municipio
			,`cas`.seccion
-- 			,`cas`.clave_distrito
			,`cas`.clave_agrupamiento
			,`cas`.tipo_casilla
-- 			,`cas`.tipo_contigua
-- 			,`cas`.tipo_especial
			,`cas`.urbana
			,`cas`.distrito
			,`cas`.locacion
			,`cas`.hora_instalacion
			,`cas`.hora_inicio
			,`cas`.hora_cierre
			,`party`.nombre
			,`party`.formula
			,`party`.description
			,`status`.is_present
	from 
			`cakephp`.`xmf_casillas` as `cas`
	inner join 
			`cakephp`.`xmf_partidos` as `party`
			on 
			`party`.is_coalicion = 0 and `party`.has_parent = 0 and `party`.is_funcionario = 1
	left join 
			`cakephp`.`xmf_funcionarios_presence_status` as `status`
			on
			`cas`.id = `status`.xmf_casillas_id and `party`.id = `status`.xmf_partidos_id
	,(select @rownum := 0) r

--  select * from cakephp.`xmf_presences` 

-- ============================================================================================== --


  create or replace TABLE `xmf_incidencias`(  -- this comes from a Catalog
  `id` int unsigned NOT null auto_increment,
  `titulo` TEXT DEFAULT NULL,
  `descripcion` TEXT DEFAULT null,
  `created` DATETIME,
  `modified` DATETIME,
   primary key (`id`)
  )engine=InnoDB default charset=utf8mb4;

  ALTER TABLE `xmf_incidencias` COMMENT = 'TIPO INCIDENCIAS';

	
  insert into `cakephp`.`xmf_incidencias` values 
  							 (null,'La casilla se instalo antes de las 7 am.','',now(),now())
							,(null,'Falto material electoral (Boletas, tinta indeleble, listados nominales).','',now(),now())
							,(null,'Se impidio el acceso a la casilla a los Representantes de Partido sin causa 8 justificada.','',now(),now())
							,(null,'Se expulso de la casilla a los Representantes de Partido sin causa 11 justificada.','',now(),now())
							,(null,'Se instalo la casilla, sin causa justificada, en lugar distinto al seﬁalado por el 14 Consejo Distrital.','',now(),now())
							,(null,'Se recibio la votacion por personas distintas a las facultadas por la ley.','',now(),now())
							,(null,'Se permitio sufragar a ciudadanos que no contaban con su credencial para votar con fotografia.','',now(),now())
							,(null,'Se permitio sufragar a ciudadanos cuyo nombre no aparecio en la Lista Nominal de Electores con fotografia.','',now(),now())
							,(null,'No se permitio sufragar a ciudadanos que contaban con sentencia favorable del Tribunal Electoral (JDC)','',now(),now())
							,(null,'Se impidio el ejercicio del derecho al voto a los ciudadanos sin causa justificada.','',now(),now())
							,(null,'Se ejercio violencia fisica o presién sobre los miembros de la Mesa Directiva de Casilla, Representantes de los Partidos o Electores.','',now(),now())
							,(null,'Se cerro la votacion antes de las 17:00 horas sin que se hubiera agotado el listado nominal.','',now(),now())
							,(null,'Medio dolo o error en el computo de los votos, lo cual fue determinante para el resultado de la votacion.','',now(),now())
							,(null,'Se permitio la presencia de personas no acreditadas en la casilla.','',now(),now())
							,(null,'Se realizo el escrutinio y computo local diferente al determinado por el Consejo Distrital','',now(),now())
							,(null,'Exististieron Irregularidades graves, plenamente acreditadas y no reparables durante la jornada electoral','',now(),now())
-- 							,(null,'','',now(),now())

							
select * from `cakephp`.`xmf_incidencias`


  create or replace TABLE `xmf_partidos_incidencias`(
  `id` int unsigned NOT null auto_increment,
  `xmf_casillas_id` int unsigned DEFAULT NULL,
  `xmf_partidos_id` int unsigned DEFAULT NULL,
  `xmf_incidencias_id` int unsigned DEFAULT NULL,
  `otra` TEXT DEFAULT NULL,
  `created` DATETIME,
  `modified` DATETIME,
   primary key (`id`)
  ) engine=InnoDB default charset=utf8mb4;
  ALTER TABLE `xmf_partidos_incidencias` COMMENT = 'INFORMACION DE CASILLA - INCIDENCIAS';

insert into `cakephp`.`xmf_partidos_incidencias` values 
														 (null,1,1,1,'',now(),now())
														,(null,1,1,2,'',now(),now())
														,(null,1,1,3,'',now(),now())
														,(null,1,3,1,'',now(),now())
														
select * from `cakephp`.`xmf_partidos_incidencias`
--   ALTER TABLE `xmf_partidos_incidencias`
--     ADD PRIMARY KEY (`id`);

--   ALTER TABLE `xmf_partidos_incidencias`
--   MODIFY `id` unsigned INT(11) NOT NULL AUTO_INCREMENT;



select * from `cakephp`.`xmf_partidos_incidencias`


create or replace view `xmf_view_incidencias` 
as
	select 
			 `cas`.id as 'casillas_index'
			,`cas`.name
			,`cas`.rgl_id
			,`cas`.abo_id
			,`cas`.cap_id
			,`cas`.municipio
			,`cas`.seccion
			,`cas`.clave_agrupamiento
			,`cas`.tipo_casilla
			,`cas`.urbana
			,`cas`.distrito
			,`cas`.locacion
			,`partition`.nombre
			,`partition`.formula
			,`parin`.id
			,`parin`.xmf_incidencias_id
			,`parin`.otra
			,`inc`.titulo
			,`inc`.descripcion
	from 
			`cakephp`.`xmf_casillas` as `cas`
	inner join 
			`cakephp`.`xmf_partidos` as `partition`
	left join 
			`cakephp`.`xmf_partidos_incidencias` as `parin`
		on 
			`cas`.id = `parin`.xmf_casillas_id and `partition`.id = `parin`.xmf_partidos_id
	left join 
			`cakephp`.`xmf_incidencias` as `inc`
		on 
			`parin`.xmf_incidencias_id = `inc`.id
 			
-- select * from `cakephp`.`xmf_view_incidencias`
-- select * from `cakephp`.`xmf_partidos_incidencias`

  -- ============================================================================================================= --
  -- =======================================   Proposal of catalogs =============================================== --
  -- ============================================================================================================= --

-- create table protoTable (
--   `id` unsigned INT(11) not null auto_increment,
--   `created` DATETIME,
--   `modified` DATETIME,
--   primary key (`id`);
-- )engine=InnoDB default charset=utf8mb4;

-- ================================ Config Level of auth ================================== --

-- set config set the level by role
create table `xmf_validations_configs` (
  `id` 				unsigned INT(11) not null auto_increment,
  `top_level` 		tinyint not null ,           -- at least 2 levels of validation and zero means unlimited
  `role_id` 		char(36) null default null ,
  `created` 		datetime,
  `modified` 		datetime,
  primary key (`id`)
)engine=InnoDB default charset=utf8mb4;

-- ================================ show in a reports view ================================== --

-- set the config by report this is one record updatable
create table `xmf_validations` (
  `id`                  int unsigned not null auto_increment,
  `reports_id`			int unsigned not null ,  					-- fk to reports
  `level`               tinyint not null ,                        	-- set the level , ex: 1st or 2nd but the insert are top of config:top_level
  `level_validation`    boolean default null,                    	-- the level is validate 0|1 ,then just sum for a true validation
  `created` 			datetime,
  `modified` 			datetime,
  primary key (`id`)
)engine=InnoDB default charset=utf8mb4;
-- example
-- level => 1 and level_validation => true
-- level => 1 and level_validation => true
-- set the value in users $this->Auth('User')['reports']['validations]['ReportId{n}' => true , 'ReportId{n+1}' =>false ] ;

-- ================================ just in case ================================== --

create or replace table `xmf_validations_logs` (
  `id`                  		int unsigned not null auto_increment,
  `xmf_reports_id`				int unsigned not null ,  					-- fk to reports
  `xmf_validations_id`			int unsigned not null ,  					-- fk to reports
  `xmf_validations_configs_id`	int unsigned not null ,  					-- fk to reports
  `level`               		tinyint not null ,                        	-- set the level , ex: 1st or 2nd but the insert are top of config:top_level
  `level_validation`    		boolean default null,                    	-- the level is validate 0|1 ,then just sum for a true validation
  `created` 					datetime,
  `modified`		 			datetime,
  primary key (`id`)
)engine=InnoDB default charset=utf8mb4;


create table `xmf_tipo_votaciones` (
  `id`                 int unsigned not null auto_increment,
  `tipo`               char(50) null,
  `description`        text null,
  `created`            DATETIME,
  `modified`           DATETIME,
  primary key (`id`)
)engine=InnoDB default charset=utf8mb4;
insert into `xmf_tipo_votaciones` (`tipo`,`description`,`created`,`modified` )
                    values
                    	   ('Presidente','',now(),now())
                          ,('Senador','',now(),now())
                          ,('Diputado','',now(),now())
                          ,('Ayuntamiento','',now(),now());

select * from `cakephp`.`xmf_tipo_votaciones`

 -- ============================================================================================================= --
 -- =======================================   Proposal of reports =============================================== --
 -- ============================================================================================================= --

 -- 1st instalacion , inicio , representantes
 -- 2nd flujo de 8-12 votantes-promovidos
 -- 3rd flujo de 8-16 votantes-promovidos
 -- 4th cierre y flujo final votantes-promovidos , people in tail
 -- last results captura resultados finales


	create or replace table `xmf_reports_definitions` (
	  `id`                 int unsigned not null auto_increment,
	  `name`               char(50) null,
	  `description`        text null,
	  `created`            DATETIME,
	  `modified`           DATETIME,
	  primary key (`id`)
	)engine=InnoDB default charset=utf8mb4;

	insert into `xmf_reports_definitions` values 
												 (null,'first','reporte_primero',now(),now())
												,(null,'second','reporte_segundo',now(),now())
												,(null,'third','reporte_tercero',now(),now())
												,(null,'fourth','reporte_final',now(),now())
												;
select * from `cakephp`.`xmf_reports_definitions`

	create or replace table `xmf_reports_config_definitions`(
	  `id`                 			int unsigned not null auto_increment,	
	  `xmf_reports_definitions_id`  int unsigned not null ,
	  `field_name`		   			char null,
	  `description`        			text null,
	  `created`            			datetime,
	  `modified`          			datetime,
	  primary key (`id`);
	)engine=InnoDB default charset=utf8mb4;

select * from `cakephp`.`xmf_reports_view_definitions`

-- set join with roles table 
	create or replace table `xmf_reports_controls` (
      `id` 							int unsigned not null auto_increment ,
      `xmf_reports_id`				int unsigned not null ,
      `xmf_users_id`				int unsigned not null ,
      `xmf_roles_id`				int unsigned not null ,
      `is_user_config`				boolean null default false ,
      `is_role_config`				boolean null default true ,
      `xmf_validations_id`			int unsigned not null ,
	  `created`          	  		datetime,
	  `modified`           			datetime,
       primary key (`id`)
    )engine=InnoDB default charset=utf8mb4;

-- when save need activate cascade 
    create table `xmf_reports` (
      `id` 							int unsigned not null auto_increment,
      `xmf_reports_controls_id`		int unsigned not null ,  -- fk to define the report validity
      `xmf_reports_definitions_id`	int unsigned not null ,  -- fk to define the report [reports x reports_definitions]
      `xmf_casillas_id` 			int unsigned not null ,  -- fk with casillas [reports x reports_definitions x casillas]
      `xmf_partidos_id`				int unsigned not null ,  -- fk with partidos so this [reports x reports_definitions x reports_definitions x casillas x partidos]
      `xmf_tipo_votaciones_id`		int unsigned not null ,  -- fk with tipo_votaciones  [reports x reports_definitions x casillas x partidos x tipoVotacion]     
	  `created`            			datetime,
	  `modified`           			datetime,
       primary key (`id`)
    )engine=InnoDB default charset=utf8mb4;



    -- Content the updatable data of reports
    create or replace table `xmf_votes` (
      -- set the updatable fields in reports when in view take the max id or datetime
      `id` 							int unsigned not null auto_increment,
      `xmf_casillas_id`				int unsigned not null ,  -- casillas
      `xmf_tipo_votaciones_id`		int unsigned not null ,  -- tipoVotaciones
      `xmf_partidos_id`				int unsigned not null ,  -- partidos
      `votes`						int unsigned not null ,  -- votes 
	  `created`         	   		datetime,
	  `modified`           			datetime,
       primary key (`id`)
    )engine=InnoDB default charset=utf8mb4;

	insert into `cakephp`.`xmf_votes` values 
												  (null,1,1,1,200,now(),now())
												 ,(null,1,2,1,50,now(),now())
												 ,(null,2,1,1,201,now(),now());



 -- ============================================================================================================= --
 -- =======================================   Updatable Votes View  ============================================= --
 -- ============================================================================================================= --
 
use xmf_casillas

create or replace view `xmf_reaper` 
as
	select 
 			 `cas`.id as 'casillas_index'
			,`cas`.name
-- 			,`cas`.description
			,`cas`.rgl_id
			,`cas`.abo_id
			,`cas`.cap_id
			,`cas`.municipio
			,`cas`.seccion
-- 			,`cas`.clave_distrito
			,`cas`.clave_agrupamiento
			,`cas`.tipo_casilla
-- 			,`cas`.tipo_contigua
-- 			,`cas`.tipo_especial
			,`cas`.urbana
			,`cas`.distrito
			,`cas`.locacion
			,`cas`.hora_instalacion
			,`cas`.hora_inicio
			,`cas`.hora_cierre
-- 			,`cas`.created
-- 			,`cas`.modified
-- 			,`partition`.id
			,`partition`.nombre
			,`partition`.formula
			,`partition`.is_coalicion
			,`partition`.has_parent
			,`partition`.parent_id
-- 			,`partition`.description
-- 			,`partition`.created
-- 			,`partition`.modified
-- 			,`tvt`.id
			,`tvt`.tipo
-- 			,`tvt`.description
-- 			,`tvt`.created
-- 			,`tvt`.modified
			,`vts`.id						-- this id is the most 
			,`vts`.xmf_casillas_id
			,`vts`.xmf_tipo_votaciones_id
			,`vts`.xmf_partidos_id
			,`vts`.votes
-- 			,`vts`.created
-- 			,`vts`.modified
	from 
			`cakephp`.`xmf_casillas` as `cas`
	inner join 
			`cakephp`.`xmf_partidos` as `partition`
	inner join
			`cakephp`.`xmf_tipo_votaciones` as `tvt`
	left join 
			`cakephp`.`xmf_votes` as `vts` on `cas`.id = `vts`.xmf_casillas_id 
		and 
			`vts`.xmf_tipo_votaciones_id = `tvt`.id 
		and 
			`vts`.xmf_partidos_id = `partition`.id



-- select * from `cakephp`.`xmf_presences`
			
-- select * from `cakephp`.`xmf_reaper`where casillas_index = 1
-- 
-- select * from `cakephp`.`xmf_view_incidencias`

			
			
select TABLE_NAME,IS_UPDATABLE from information_schema.VIEWS



-- 	protoReport
-- use cakephp

    -- content the fists summary data of the main reports and using coalesce(reportes_complementos) for a clean update
    create view for first_reports (
      -- ....select from casillas left join partidos left join reports_definitions left join reports on ... left join reports_complements
    );
    create view for second_reports (
      -- ....
    );
    create view for third_reports (
      -- ....
    );
    create view for fourth_reports (
      -- ....
    );

	-- we need a build report procedure with option [build , delete , update ]
	
	


-- ======================================= End of Proposal of reports =============================================== --



  CREATE TABLE `reporte_primero`(
  `id` INT(11) NOT NULL,
  `casillas_id` INT(11) NOT NULL,
  `hora_instalacion` DATETIME DEFAULT NULL,
  `hora_inivotacion` DATETIME DEFAULT NULL,   -- repeated in  casillas_presencias
  `lugar_indi_ieqro` TINYINT(2) DEFAULT NULL,
  `toma_gente_fila` TINYINT(2) DEFAULT NULL,
  `pres_pan` TINYINT(2) DEFAULT NULL,
  `pres_pri` TINYINT(2) DEFAULT NULL,
  `pres_prd` TINYINT(2) DEFAULT NULL,
  `pres_pve` TINYINT(2) DEFAULT NULL,
  `pres_pt` TINYINT(2) DEFAULT NULL,
  `pres_mc` TINYINT(2) DEFAULT NULL,
  `pres_panal` TINYINT(2) DEFAULT NULL,
  `pres_morena` TINYINT(2) DEFAULT NULL,
  `pres_pes` TINYINT(2) DEFAULT NULL,
  `pres_presidente` TINYINT(2) DEFAULT NULL,
  `pres_secretario` TINYINT(2) DEFAULT NULL,
  `pres_escrutador_1` TINYINT(2) DEFAULT NULL,
  `pres_escrutador_2` TINYINT(2) DEFAULT NULL,
  `pres_suplente_1` TINYINT(2) DEFAULT NULL,
  `pres_suplente_2` TINYINT(2) DEFAULT NULL,
  `pres_suplente_3` TINYINT(2) DEFAULT NULL,
  `info_validada` TINYINT(2) DEFAULT NULL
  );
  ALTER TABLE `reporte_primero` COMMENT = 'INFORMACION DE CASILLA - REPORTE I';
  ALTER TABLE `reporte_primero`
    ADD PRIMARY KEY (`id`);
  ALTER TABLE `reporte_primero`
  MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT;

  CREATE TABLE `reporte_segundo_tercero`(
  `id` INT(11) NOT NULL,
  `casillas_id` INT(11) NOT NULL,
  `votantes_segundo` INT(11) DEFAULT NULL,
  `promovidos_segundo` INT(11) DEFAULT NULL,
  `hr_voto_segundo` DATETIME DEFAULT NULL,

  `votantes_tercero` INT(11) DEFAULT NULL,
  `promovidos_tercero` INT(11) DEFAULT NULL,
  `hr_voto_tercero` DATETIME DEFAULT NULL,
  `info_validada` TINYINT(2) DEFAULT NULL
  );
  ALTER TABLE `reporte_segundo_tercero` COMMENT = 'INFORMACION DE CASILLA - REPORTE II y III';

  ALTER TABLE `reporte_segundo_tercero`
    ADD PRIMARY KEY (`id`);

  ALTER TABLE `reporte_segundo_tercero`
  MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT;

  CREATE TABLE `reporte_cierre`(
  `id`  INT(11) NOT NULL,
  `casillas_id` INT(11) NOT NULL,
  `hr_cierre` DATETIME DEFAULT NULL,
  `habia_gente_fila` TINYINT(2) DEFAULT NULL,
  `votantes` INT(11) DEFAULT NULL,
  `promovidos` INT(11) DEFAULT NULL,
  `info_validada` TINYINT(2) DEFAULT NULL
  );
  ALTER TABLE `reporte_cierre` COMMENT = 'INFORMACION DE CASILLA - REPORTE I';

  ALTER TABLE `reporte_cierre`
    ADD PRIMARY KEY (`id`);

  ALTER TABLE `reporte_cierre`
  MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT;

  CREATE TABLE `resultados_finales`(
  `id` INT(11) NOT NULL,
  `casillas_id` INT(11) NOT NULL,
  `res_pan` INT(11) DEFAULT NULL,
  `res_pri` INT(11) DEFAULT NULL,
  `res_prd` INT(11) DEFAULT NULL,
  `res_pve` INT(11) DEFAULT NULL,
  `res_pt` INT(11) DEFAULT NULL,
  `res_mc` INT(11) DEFAULT NULL,
  `res_panal` INT(11) DEFAULT NULL,
  `res_morena` INT(11) DEFAULT NULL,
  `res_pes` INT(11) DEFAULT NULL,
  `coa_pan_prd_mc` INT(11) DEFAULT NULL,
  `for_pan_prd` INT(11) DEFAULT NULL,
  `for_pan_mc` INT(11) DEFAULT NULL,
  `for_prd_mc` INT(11) DEFAULT NULL,

  `coa_pri_pve_panal` INT(11) DEFAULT NULL,
  `for_pri_pve` INT(11) DEFAULT NULL,
  `for_pri_panal` INT(11) DEFAULT NULL,
  `for_pve_panal` INT(11) DEFAULT NULL,

  `no_registrados` INT(11) DEFAULT NULL,
  `votos_nulos` INT(11) DEFAULT NULL,
  `info_validada` TINYINT(2) DEFAULT NULL
  );
  ALTER TABLE `resultados_finales` COMMENT = 'INFORMACION VOTACIONES - RESULTADOS FINALES';

  ALTER TABLE `resultados_finales`
    ADD PRIMARY KEY (`id`);

  ALTER TABLE `resultados_finales`
  MODIFY `id` INT(11) NOT NULL AUTO_INCREMENT;

  DESC `casillas`;
  DESC `casillas_presencia`;
  DESC `partidos`;
  DESC `incidencias`;
  DESC `partidos_incidencias`;
  DESC `reporte_primero`;
  DESC `reporte_segundo_tercero`;
  DESC `reporte_cierre`;
  DESC `resultados_finales`;


-- =============================== laboratory ======================================== --
