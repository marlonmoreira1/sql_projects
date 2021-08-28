show user;

select 1 + 1 as soma from dual;

select metadata from sys.kopm$;

select * from dict;

select parallel from v$instance;

select component,current_size,min_size,max_size
from v$sga_dynamic_components;

select name from v$database;

select banner from v$version;

select * from user_sys_privs;

select table_name from user_tables;

create table cursos(
idcurso int primary key,
nome varchar2(30),
carga int
)tablespace users;

create table teste(
idteste int,
nome varchar2(30)
);
 
select table_name, tablespace_name
from user_tables
where table_name = 'TESTE';

select table_name, tablespace_name
from user_tables
where table_name = 'CURSOS';

select segment_name,segment_type,tablespace_name,
bytes,blocks,extents
from user_segments
where segment_name = 'CURSOS';

select segment_name,segment_type,tablespace_name,
bytes,blocks,extents
from user_segments
where segment_name = 'TESTE';
