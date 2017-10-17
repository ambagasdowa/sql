-- Firts build the tunnel

/usr/bin/sshpass -p 'mypass' ssh -L 3309:127.0.0.1:3306 user@host

-- then run mysqldum

mysqldump -P 3309 -h 127.0.0.1 -u user -p"mypass" my_db > /tmp/my_db.sql

-- and

mysql -u user -p -h localhost my_db < /tmp/my_db.sql
