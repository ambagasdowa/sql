/**
  *
  *
  *
  */


create database cakephp

show databases;
use cakephp;

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
   `clave_distrito`       		char(2) default null,
   `clave_agrupamiento`   		char(2) default null,
   -- key => [basica,contigua,especial]
   `tipo_basica`         		boolean null default FALSE,
   `tipo_contigua`       		int(2) default null,
   `tipo_especial`       		boolean null default FALSE,

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
						 (null,'CB201','',1,1,1,'Solidaridad','','','',null,null,null,'','','',null,null,null,now(),now())
						,(null,'CB202','',1,1,1,'Solidaridad','','','',null,null,null,'','','',null,null,null,now(),now())
						,(null,'CB206','',1,1,1,'Solidaridad','','','',null,null,null,'','','',null,null,null,now(),now())
;

-- test
--  select * from `cakephp`.`xmf_casillas`
-- truncate `cakephp`.`casillas`
  -- ============================================================================================================= --
  -- =================================   Proposal of Par/Func Status Precense      =============================== --
  -- ============================================================================================================= --


  -- =================================   Partidos Catalog    =============================== --

  create or replace table `xmf_partidos`(
   `id` 			  int unsigned not null auto_increment,
   `nombre`           TEXT DEFAULT NULL, -- coal1, coal2 ....
   `formula`          TEXT DEFAULT NULL, -- Coaliciones
   `is_coalicion`     boolean not null default false,
   `has_parent`       boolean not null default false,
   `parent_id`        int unsigned null,
   `description`      text default null,
   `created`          datetime,
   `modified`         datetime,
    primary key (`id`)
   )engine=InnoDB default charset=utf8mb4;
  ALTER TABLE `xmf_partidos` COMMENT = 'INFORMACION PARTIDOS';
--   ALTER TABLE `partidos`
--     ADD PRIMARY KEY (`id`);
--   ALTER TABLE `partidos`
--   MODIFY `id` unsigned INT(11) NOT NULL AUTO_INCREMENT;
insert into `xmf_partidos` values
                             (null,'PAN','pan',0,0,null,'',now(),now())
                            ,(null,'PRI','pri',0,0,null,'',now(),now())
                            ,(null,'PRD','prd',0,0,null,'',now(),now())
                            ,(null,'PVE','pve',0,0,null,'',now(),now())
                            ,(null,'PT','pt',0,0,null,'',now(),now())
                            ,(null,'MC','mc',0,0,null,'',now(),now())
                            ,(null,'PANAL','panal',0,0,null,'',now(),now())
                            ,(null,'MORENA','morena',0,0,null,'',now(),now())
                            ,(null,'Pes','pes',0,0,null,'',now(),now())
                            ,(null,'Coalicion Pan-Prd-Mc','coa_pan_prd_mc',1,0,null,'',now(),now())
                            ,(null,'Pan-Prd','for_pan_prd',1,1,10,'',now(),now())
                            ,(null,'Pan-Mc','for_pan_mc',1,1,10,'',now(),now())
                            ,(null,'Prd-Mc','for_prd_mc',1,1,10,'',now(),now())
                            ,(null,'Coalicion Pri-Pve-Panal','coa_pri_pve_panal',1,0,null,'',now(),now())
                            ,(null,'Pri-Pve','for_pri_pve',1,1,14,'',now(),now())
                            ,(null,'Pri-Panal','for_pri_panal',1,1,14,'',now(),now())
                            ,(null,'Pve-Panal','for_pve_panal',1,1,14,'',now(),now())
                            ;
-- test 
-- select * from `cakephp`.`xmf_partidos`
  -- =================================   Partidos Precense Status    =============================== --

	create or replace table `xmf_partidos_references` (
	   `id` 			int unsigned not null auto_increment,
	   `xmf_casillas_id` 	int unsigned not null ,
	   `xmf_partidos_id` 	int unsigned not null ,
	   `is_present`  	boolean null,
	   `description` 	char(150) not null,   
	   `created` 		datetime,
	   `modified` 		datetime,
	    primary key (`id`)
	) engine=InnoDB default charset=utf8mb4;

	insert into `xmf_partidos_references` values 
											 	 (null,1,1,1,'',now(),now())
											 	,(null,1,2,1,'',now(),now())
											 	,(null,1,10,1,'',now(),now())
											 	,(null,2,1,1,'',now(),now())
	;
-- select * from xmf_partidos_references
-- truncate table partidos_references
  -- =================================   Funcionarios Catalog    =============================== --

	create or replace table `xmf_funcionarios` (
	  `id` 					int unsigned not null auto_increment,
	  `funcionario`        	char(50) null,
	  `description`        	text null,
	  `created`            	datetime,
	  `modified`           	datetime,
	   primary key(`id`)
	)engine=InnoDB default charset=utf8mb4;
	insert into `xmf_funcionarios` values
	                               (null,'Presidente','',now(),now())
	                              ,(null,'Secretario','',now(),now())
	                              ,(null,'Escrutador1','',now(),now())
	                              ,(null,'Escrutador2','',now(),now())
	                              ,(null,'Suplente1','',now(),now())
	                              ,(null,'Suplente2','',now(),now())
	                              ,(null,'Suplente3','',now(),now());

-- select * from `cakephp`.`xmf_funcionarios`

  -- =================================   Funcionarios Precense Status    =============================== --
  
	create or replace table `xmf_funcionarios_references` (
	   `id` 					int unsigned not null auto_increment,
	   `xmf_casillas_id` 		int unsigned not null ,
	   `xmf_funcionarios_id` 	int unsigned not null ,
	   `is_present`  			boolean null,
	   `description` 			char(150) not null,   
	   `created` 				datetime,
	   `modified` 				datetime,
	    primary key (`id`)
	) engine=InnoDB default charset=utf8mb4;

	insert into `xmf_funcionarios_references` values 
											 	 (null,1,1,1,'',now(),now())
											 	,(null,1,2,1,'',now(),now())
											 	,(null,1,7,1,'',now(),now())										 	
	;
-- select * from cakephp.xmf_funcionarios_references

 -- =================================   View of Precense Status    =============================== --

create or replace view `xmf_precense_status` 
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
				`cakephp`.`xmf_partidos_references` as `prt` 
		inner join 
				`cakephp`.`xmf_partidos` as `part` on `prt`.xmf_partidos_id = `part`.id
		union all
		select 
				 `func`.id
				,`func`.xmf_casillas_id
				,`func`.xmf_funcionarios_id
				,`func`.is_present
				,`func`.description
				,`funk`.funcionario as `nombre`
				,`funk`.description as `descripcion`
		from 
				`cakephp`.`xmf_funcionarios_references` as `func` 
		inner join
				`cakephp`.`xmf_funcionarios` as `funk` on `func`.xmf_funcionarios_id = `funk`.id

-- select * from `cakephp`.`xmf_precense_status`


-- =================================   View of All Functioners    =============================== --		

create or replace view `xmf_precenses` as 
		select 
				 `part`.id
				,`part`.nombre		as `nombre`
				,`part`.formula		as `descripcion`
		from 
				`cakephp`.`xmf_partidos` as `part`
		where 
				`part`.is_coalicion = 0 and `part`.has_parent = 0
		union all
		select 
				 `funk`.id
				,`funk`.funcionario as `nombre`
				,`funk`.description as `descripcion`
		from 
				`cakephp`.`xmf_funcionarios` as `funk`
	
				
-- select * from `cakephp`.`xmf_precenses`				

-- ============================================================================================== --


  CREATE TABLE `xmf_incidencias`(  -- this comes from a Catalog
  `id` INT(11) NOT NULL,
  `titulo` TEXT DEFAULT NULL,
  `descripcion` TEXT DEFAULT NULL
  `created` DATETIME,
  `modified` DATETIME
  );
  ALTER TABLE `xmf_incidencias` COMMENT = 'TIPO INCIDENCIAS';
  ALTER TABLE `xmf_incidencias`
    ADD PRIMARY KEY (`id`);
  ALTER TABLE `xmf_incidencias`
  MODIFY `id` unsigned INT(11) NOT NULL AUTO_INCREMENT;


  CREATE TABLE `xmf_partidos_incidencias`(
  `id` INT(11) NOT NULL,
  `casillas_id` INT(11) DEFAULT NULL,
  `partidos_id` INT(11) DEFAULT NULL,
  `incidencias_id` INT(11) DEFAULT NULL,
  `otra` TEXT DEFAULT NULL,
  `created` DATETIME,
  `modified` DATETIME
  );
  ALTER TABLE `xmf_partidos_incidencias` COMMENT = 'INFORMACION DE CASILLA - INCIDENCIAS';

  ALTER TABLE `xmf_partidos_incidencias`
    ADD PRIMARY KEY (`id`);

  ALTER TABLE `xmf_partidos_incidencias`
  MODIFY `id` unsigned INT(11) NOT NULL AUTO_INCREMENT;

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

	create or replace table `xmf_reports_view_definitions`(
	  `id`                 			int unsigned not null auto_increment,	
	  `xmf_reports_definitions_id`  int unsigned not null ,
	  `field_name`		   			char null,
	  `description`        			text null,
	  `created`            			datetime,
	  `modified`          			datetime,
	  primary key (`id`);
	)engine=InnoDB default charset=utf8mb4;



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


create or replace view `xmf_reaper`
as
	select 
 			 `cas`.id as 'casillas_index'
			,`cas`.name
			,`cas`.description
			,`cas`.rgl_id,abo_id
			,`cas`.cap_id
			,`cas`.municipio
			,`cas`.seccion
			,`cas`.clave_distrito
			,`cas`.clave_agrupamiento
			,`cas`.tipo_basica
			,`cas`.tipo_contigua
			,`cas`.tipo_especial
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
			,`partition`.description
-- 			,`partition`.created
-- 			,`partition`.modified
-- 			,`tvt`.id
			,`tvt`.tipo
			,`tvt`.description
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
	where 
			`cas`.id = 1



select * from information_schema.VIEWS



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

create or replace TABLE products
(
    prod_id INT NOT NULL,
    prod_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (prod_id)
);

insert into products
values(1, 'Shoes'),
(2, 'Pants'),
(3, 'Shirt');
 
create or replace TABLE reps
(
  rep_id INT NOT NULL,
  rep_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (rep_id)
);

insert into reps (rep_id, rep_name)
values (1, 'John'), (2, 'Sally'), (3, 'Joe'), (4, 'Bob');
 
create or replace TABLE sales
(
  prod_id INT NOT NULL,
  rep_id INT NOT NULL,
  sale_date datetime not null,
  quantity int not null,
  PRIMARY KEY (prod_id, rep_id, sale_date),
  FOREIGN KEY (prod_id) REFERENCES products(prod_id),
  FOREIGN KEY (rep_id) REFERENCES reps(rep_id)
);

insert into sales (prod_id, rep_id, sale_date, quantity)
values 
  (1, 1, '2013-05-16', 20),
  (1, 1, '2013-06-19', 2),
  (2, 1, '2013-07-03', 5),
  (3, 1, '2013-08-22', 27),
  (3, 2, '2013-06-27', 500),
  (3, 2, '2013-01-07', 150),
  (1, 2, '2013-05-01', 89),
  (2, 2, '2013-02-14', 23),
  (1, 3, '2013-01-29', 19),
  (3, 3, '2013-03-06', 13),
  (2, 3, '2013-04-18', 1),
  (2, 3, '2013-08-03', 78),
  (2, 3, '2013-07-22', 69);


SET @SQL = NULL
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'sum(case when Date_format(s.sale_date, ''%Y-%M'') = ''',
      dt,
      ''' then s.quantity else 0 end) AS `',
      dt, '`'
    )
  ) INTO @SQL
FROM
(
  SELECT Date_format(s.sale_date, '%Y-%M') AS dt
  FROM sales s
  ORDER BY s.sale_date
) d
 
SET @SQL 
  = CONCAT('SELECT r.rep_name, ', @SQL, ' 
            from reps r
            inner join sales s
              on r.rep_id = s.rep_id
            inner join products p
              on s.prod_id = p.prod_id
            group by r.rep_name;')
 
PREPARE stmt FROM @SQL
EXECUTE stmt
DEALLOCATE PREPARE stmt

