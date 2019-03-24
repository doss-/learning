/*create user 'tuser'@'localhost' identified by 'testp';
grant all on *.* to 'tuser'@'localhost';
create schema testdb;*/
CREATE TABLE IF NOT EXISTS testdb.t (c CHAR(20), ci INT);
INSERT testdb.t (c, ci) VALUE ('first', 1);
