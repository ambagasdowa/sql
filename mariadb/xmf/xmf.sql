show databases;

create database cakephp;

grant usage on cakephp.* to cakephp@localhost identified by '@cakephp#';
grant select, insert, update, delete, drop, alter, create , create temporary tables on cakephp.* to cakephp@localhost;
grant file on *.* to 'cakephp'@'localhost';
flush privileges;
SHOW GRANTS FOR 'cakephp'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO cakephp@'localhost' -- with grant options;
flush privileges;


-- ============================================================================================== --
-- ================================== cakephp 3.x blog example ================================== --
-- ============================================================================================== --

use cakephp

/* First, create our articles table: */
CREATE TABLE xmf (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    xmf_title VARCHAR(50),
    xmf_header VARCHAR(50),
    xmf_index int unsigned,
    xmf_body TEXT,
    xmf_published BOOLEAN DEFAULT FALSE,
    created DATETIME,
    modified DATETIME
);

/* Then insert some articles for testing: */
INSERT INTO articles (title,body,created)
    VALUES ('The title', 'This is the article body.', NOW());
INSERT INTO articles (title,body,created)
    VALUES ('A title once again', 'And the article body follows.', NOW());
INSERT INTO articles (title,body,created)
    VALUES ('Title strikes back', 'This is really exciting! Not.', NOW());



drop table articles

CREATE TABLE articles (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id char(36) NOT NULL,
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
		articles (user_id, title, slug, body, published, created, modified)
VALUES
	('88190bfa-4fb5-4567-a4b6-0c9f46503894', 'First Post', 'first-post', 'This is the first post.', 1, now(), now());



-- drop table articles

-- drop table users
-- drop table social_accounts
-- drop table cake_d_c_users_phinxlog

use cakephp
show tables
-- ALTER TABLE aros CHANGE foreign_key foreign_key CHAR(36) NULL DEFAULT NULL;
create table articles

describe users
describe social_accounts
describe cake_d_c_users_phinxlog

select * from users
	
--	delete from cakephp.users where username like 'superadmin%'


select * from social_accounts
select * from cake_d_c_users_phinxlog

CREATE TABLE roles (
    id CHAR(36) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created DATETIME,
    modified DATETIME
);


ALTER TABLE users
    ADD role_id CHAR(36) NULL DEFAULT NULL AFTER role,
    ADD INDEX role_id (role_id),
    ADD FOREIGN KEY (role_id) REFERENCES roles(id);

ALTER TABLE users
    DROP role;



show tables
-- truncate table users
-- truncate table cake_d_c_users_phinxlog


-- ============================================================================================== --
-- ========================================   XMF Proposal  ===================================== --
-- ============================================================================================== --


create table xmf_casillas (
    id int unsigned auto_increment primary key,
    casillas_name varchar(50),
    seccions_id int unsigned,
    distritos_id int unsigned,
    agrupamientos_id int unsigned,
    
    xmf_body TEXT,
    xmf_published BOOLEAN DEFAULT FALSE,
    created DATETIME,
    modified DATETIME
);



