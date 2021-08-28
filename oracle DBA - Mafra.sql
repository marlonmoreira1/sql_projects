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
---------------------------------------------------------------------------------------------------------------------------------------------
create tablespace recursos_humanos
datafile 'C:/data/RH_01.DBF'
size 100m autoextend
on next 100m
maxsize 4096m;

alter tablespace recursos_humanos
add datafile 'C:/data/RH_02.DBF'
size 200m autoextend
on next 200m
maxsize 4096m;

select tablespace_name,file_name from dba_data_files;

create sequence seq_geral
start with 100
increment by 10;

create table funcionarios(
idfuncionario int primary key,
nome varchar2(30)
)tablespace recursos_humanos;

insert into funcionarios values (seq_geral.nextval,'João');
insert into funcionarios values (seq_geral.nextval,'Clara');
insert into funcionarios values (seq_geral.nextval,'Lilian');

select * from funcionarios;

create tablespace marketing
datafile 'C:/data/MKT_01.DBF'
size 100m autoextend
on next 100m
maxsize 4096m;

create table campanhas(
idcampanha int primary key,
nome varchar2(30)
)tablespace marketing;

insert into campanhas values (seq_geral.nextval,'Primavera');
insert into campanhas values (seq_geral.nextval,'Inverno');
insert into campanhas values (seq_geral.nextval,'Verão');

select * from campanhas;

alter tablespace recursos_humanos offline;

alter tablespace recursos_humanos
rename datafile 'C:/data/RH_01.DBF' to 'C:/producao/RH_01.DBF';

alter tablespace recursos_humanos
rename datafile 'C:/data/RH_02.DBF' to 'C:/producao/RH_02.DBF';

alter tablespace recursos_humanos online;
------------------------------------------------------------------------------------------------------------------------------------------------------
create table aluno(
idaluno int primary key,
nome varchar2(30),
email varchar2(30),
salario number(10,2)
);

insert into aluno values(seq_geral.nextval,'Joao','joao@gmail.com',1000);
insert into aluno values(seq_geral.nextval,'Clara','clara@gmail.com',2000);
insert into aluno values(seq_geral.nextval,'Celia','celia@gmail.com',3000);


select rowid,rownum,idaluno,nome,email,salario from aluno;



select nome,salario,email,idaluno from aluno where rownum <= 2;




create or replace procedure bonus(P_idaluno aluno.idaluno%type, P_percent number)
as 
begin
update aluno set salario = salario + (salario * (P_percent/100))
where P_idaluno = idaluno;
end;
/



call bonus(180,10);
select * from aluno;


create or replace trigger check_salario
before insert or update on aluno
for each row
begin
if :new.salario < 1000 then 
raise_application_error(-20000, 'Valor Incorreto');
end if;
end;
/

select trigger_name,trigger_body
from user_triggers;


create table auditoria(
data_login date,
login varchar2(30)
);

create or replace procedure logproc is
begin 
insert into auditoria(data_login,login)
values(sysdate,user);
end logproc;
/

create or replace trigger logtrigger
after logon on database
call logproc
/


create or replace trigger falha_logon
after servererror
on database
begin
if (is_servererror(1017)) then
insert into auditoria(data_login,login)
values(sysdate,'ORA-1017');
end if;
end;
/



create table usuario(
id int,
nome varchar2(30)
);

create table BKP_usuario(
id int,
nome varchar2(30)
);

insert into usuario values(1,'Joao');
insert into usuario values(2,'Clara');

create or replace trigger log_trigger
before delete on usuario
for each row
begin
insert into BKP_usuario values(:old.id,:old.nome);
end;
/

delete from usuario where id = 1;

select * from BKP_usuario;


create table cliente(
idcliente int primary key,
nome varchar2(30),
sexo char(1)
);

insert into cliente values(seq_geral.nextval,'Marlon','M');

create or replace view V_cliente
as 
select idcliente,nome,sexo
from cliente;

insert into V_cliente values(seq_geral.nextval,'Maria','F');

select * from V_cliente;
select * from cliente;

create or replace view V_cliente_RO
as 
select idcliente,nome,sexo
from cliente
with read only;

insert into V_cliente_RO values(seq_geral.nextval,'Mariana','F');

create or replace force view V_relatorio
as
select nome,sexo,numero
from cliente
inner join telefone 
on idcliente = id_cliente;

create table telefone(
idtelefone int primary key,
numero varchar2(10),
id_cliente int
);

alter table telefone
add constraint FK_telefone_cliente
foreign key (id_cliente) references cliente;

insert into telefone values(seq_geral.nextval,32131312,200);
insert into telefone values(seq_geral.nextval,76581312,210);

select * from V_relatorio;


create table colaborador(
idcolaborador int constraint PK_colaborador primary key,
nome varchar2(100)
);


create table telephone(
idtelephone int primary key,
numero varchar2(10),
id_colaborador int
);

alter table telephone
add constraint FK_telephone_colaborador
foreign key (id_colaborador) references colaborador;


insert into colaborador values(1,'Mauricio');
insert into telephone values(1,'87564478',1);


select constraint_name, deferrable,deferred
from user_constraints where table_name in ('COLABORADOR','TELEPHONE');

alter table telephone drop constraint FK_telephone_colaborador;

alter table telephone
add constraint FK_telephone_colaborador
foreign key (id_colaborador) references colaborador
deferrable;

set constraints all deferred;

select * from colaborador;
select * from telephone;


insert into telephone values(2,'99344478',10);

commit;  (O SET DEFERRED SÓ IRÁ ATRASAR ATÉ O PRÓXIMO COMMIT)