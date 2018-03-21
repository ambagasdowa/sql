-- ======================================== FK examples ======================================== --
show databases;
create database test_notes
use test_notes;

CREATE TABLE parent (
    id INT NOT NULL,
    PRIMARY KEY (id)
) ENGINE=INNODB;

CREATE TABLE child (
    id INT,
    parent_id INT,
    INDEX par_ind (parent_id), 	-- build a index
    FOREIGN KEY (parent_id)		-- declare as fk
        REFERENCES parent(id)	-- reference to a parent
        ON DELETE cascade		-- set the action
) ENGINE=INNODB;


insert into parent values(4)

insert into child values(3,5)

select * from parent
select * from child



delete from parent where id = 5
delete from child where id = 4
-- ------------------------------ a better example ------------------------------ --

CREATE TABLE product (
     category INT NOT null
    ,id INT NOT NULL
    ,price DECIMAL,
    PRIMARY KEY(category, id)
)   ENGINE=INNODB;

CREATE TABLE customer (
    id INT NOT NULL,
    PRIMARY KEY (id)
)   ENGINE=INNODB;

CREATE TABLE product_order (
    no INT NOT NULL AUTO_INCREMENT,
    product_category INT NOT NULL,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,

    PRIMARY KEY(no),
    INDEX (product_category, product_id),
    INDEX (customer_id),

    FOREIGN KEY (product_category, product_id)
      REFERENCES product(category, id)
      ON UPDATE CASCADE ON DELETE RESTRICT, -- if won can define the delete as cascade to 

    FOREIGN KEY (customer_id)
      REFERENCES customer(id)
)   ENGINE=INNODB;

select * from product
	insert into product values (100,2,108)
	update product set category = 113 where id = 1
	delete from product where category = 100 and id = 1

select * from customer
	insert into customer values(3)
update customer set id = 10 where id = 1
delete from customer where id = 1

select * from product_order
	insert into product_order values (null,100,2,1)
delete from product_order where product_category = 113
	update product_order set product_id = 1 where product_category = 100 
-- 
	update product_order set product_category = 2 where product_category = 113 
	
-- ======================================== WORDPRESS ======================================== --
show databases

create database wordpress

use wordpress

-- create database portal_apps;
-- create an user to portal_apps

grant usage on wordpress.* to wordpress@localhost identified by '@wordpress#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on wordpress.* to wordpress@localhost;
grant file on *.* to 'wordpress'@'localhost';
flush privileges;

SHOW GRANTS FOR 'wordpress'@'localhost';

flush privileges;


-- ======================================== SYMFONY ======================================== --

show databases

create database symfony

use symfony

-- create database portal_apps;
-- create an user to portal_apps

grant usage on symfony.* to symfony@localhost identified by '@symfony#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on symfony.* to symfony@localhost;
grant file on *.* to 'symfony'@'localhost';
flush privileges;

SHOW GRANTS FOR 'symfony'@'localhost';

flush privileges;


-- ======================================== CAKEPHP 3.X ======================================== --

show databases;

create database cakephp
grant usage on cakephp.* to cakephp@localhost identified by '@cakephp#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on cakephp.* to cakephp@localhost;
grant file on *.* to 'cakephp'@'localhost';
flush privileges;
SHOW GRANTS FOR 'cakephp'@'localhost';
flush privileges;

use cakephp
show tables
describe articles

USE cakephp;
CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
	email VARCHAR(255) NOT NULL,
	password VARCHAR(255) NOT NULL,
	created DATETIME,
	modified DATETIME
);


CREATE TABLE articles (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT NOT NULL,
	title VARCHAR(255) NOT NULL,
	slug VARCHAR(191) NOT NULL,
	body TEXT,
	published BOOLEAN DEFAULT FALSE,
	created DATETIME,
	modified DATETIME,
	UNIQUE KEY (slug),
	FOREIGN KEY user_key (user_id) REFERENCES users(id)
) CHARSET=utf8mb4;

CREATE TABLE tags (
	id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(191),
	created DATETIME,
	modified DATETIME,
	UNIQUE KEY (title)
	) CHARSET=utf8mb4;

CREATE TABLE articles_tags (
	article_id INT NOT NULL,
	tag_id INT NOT NULL,
	PRIMARY KEY (article_id, tag_id),
	FOREIGN KEY tag_key(tag_id) REFERENCES tags(id),
	FOREIGN KEY article_key(article_id) REFERENCES articles(id)
);

INSERT INTO 
		users (email, password, created, modified)
values 
	('cakephp@example.com', 'sekret', NOW(), NOW());
INSERT INTO 
		articles (user_id, title, slug, body, published, created, modified)
VALUES
	(1, 'First Post', 'first-post', 'This is the first post.', 1, now(), now());









drop database 

create database cakephp_acl
grant usage on cakephp_acl.* to cakephp_acl@localhost identified by '@cakephp_acl#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on cakephp_acl.* to cakephp_acl@localhost;
grant file on *.* to 'cakephp_acl'@'localhost';
flush privileges;
SHOW GRANTS FOR 'cakephp_acl'@'localhost';
flush privileges;



use cakephp_acl

show tables;




use cakephp

-- drop database cakephp

show tables

select * from 
-- truncate
cakephp.acl_phinxlog

select * from 
-- truncate
cakephp.acos

select * from 
-- truncate
cakephp.aros

select * from 
-- truncate
cakephp.aros_acos

select * from 
-- truncate
cakephp.articles

select * from 
-- truncate
cakephp.cake_d_c_users_phinxlog

select * from 
-- truncate
-- Drop table
-- delete from
cakephp.roles

select * from 
-- truncate
-- delete from
cakephp.social_accounts



select * from 
-- truncate
-- delete from 
cakephp.users



select * from 
-- truncate
cakephp_acl.aros

select * from 
-- truncate
cakephp_acl.acos

curyorigdocamt


drop database cakephp

create database cakephp

use cakephp

show tables;



describe users



-- bin/cake migrations migrate -p CakeDC/Users

-- bin/cake migrations migrate -p Acl

-- bin/cake users add_superuser

-- bin/cake users reset_password superadmin newpass

alter table aros change foreign_key foreign_key char(36) null default null;



CREATE TABLE articles (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id char(36) NOT NULL,
	title VARCHAR(255) NOT NULL,
	body TEXT,
	published BOOLEAN DEFAULT FALSE,
	created DATETIME,
	modified DATETIME,
	FOREIGN KEY user_key (user_id) REFERENCES users(id)
) CHARSET=utf8mb4;


create table roles(
	id char(36) not null primary key,
	name char(120) not null,
	created datetime,
	modified datetime
) CHARSET=utf8mb4;


alter table users
	add role_id char(36) null default null after role,
	add index role_id (role_id),
	add foreign key (role_id) references roles(id);

alter table users
	drop role;


-- create roles and users in app

-- bin/cake acl create aco root controllers
-- bin/cake acl create aco controllers Articles
-- bin/cake acl create aco Articles index
-- bin/cake acl create aco Articles view
-- bin/cake acl create aco Articles add
-- bin/cake acl create aco Articles edit
-- bin/cake acl create aco Articles delete



select * from cakephp.roles

select `usr`.id,`usr`.username,`usr`.role_id,`rl`.name from cakephp.users as `usr`
left join cakephp.roles as `rl` on `usr`.role_id = `rl`.id


select * from cakephp.aros

select * from cakephp.acos

select * from cakephp.aros_acos











