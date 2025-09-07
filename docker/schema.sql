create database if not exists saccomizi;
create user saccomiziapp@localhost identified by 'password';
grant all privileges on saccomizi.* to 'saccomiziapp'@'%' identified by 'password';
flush privileges;