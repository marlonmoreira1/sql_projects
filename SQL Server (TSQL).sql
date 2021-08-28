**DELIMITADOR T-SQL**

create database banco
go

use banco
go

create table teste(
nome varchar(30)
)
go
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
**CODIGOS**

use empresa
go

create table aluno(
idaluno int primary key identity,
nome varchar(30) not null,
sexo char(1) not null,
nascimento date not null,
email varchar(30) unique
)
go

alter table aluno 
add constraint CK_sexo check (sexo in('M','F'))
go



create table endereco(
idendereco int primary key identity(100,10),
bairro varchar(30),
uf char(2) not null,
check (uf in('SP','RJ','MG')),
id_aluno int unique
)
go


alter table endereco
add constraint FK_endereco_aluno
foreign key (id_aluno) references aluno(idaluno)
go
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
**COMANDOS DE DESCRIÇÃO**
STORED PROCEDURES = SP

SP_columns aluno
go

SP_help aluno
go

insert into aluno values ('Andre','M','1981/12/09','andre@ig.com')
insert into aluno values ('Ana','F','1978/03/09','ana@ig.com')
insert into aluno values ('Rui','M','1951/07/09','rui@ig.com')
insert into aluno values ('Joao','M','2002/11/09','joao@ig.com')
go


insert into endereco values ('Flamengo','RJ',1)
insert into endereco values ('Morumbi','SP',2)
insert into endereco values ('Centro','MG',4)
insert into endereco values ('Centro','SP',6)
go


create table telefone(
idtelefone int primary key identity,
tipo char(3) not null,
numero varchar(10) not null,
id_aluno int,
check(tipo in('CEL','COM','RES'))
)
go


insert into telefone values('cel','7899889',1)
insert into telefone values('res','4325444',1)
insert into telefone values('com','4354354',2)
insert into telefone values('cel','2344556',2)
go


select a.nome,isnull(t.tipo,'sem'),isnull(t.numero,'numero'),e.bairro,e.uf
from aluno a
left join telefone t 
on a.idaluno = t.id_aluno
join endereco e 
on e.id_aluno = a.idaluno
go
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
**DATAS**

select nome, datediff(day,nascimento,getdate())
from aluno
go


select nome, (datediff(day,nascimento,getdate())/365) as 'idade'
from aluno
go


select nome,(datediff(month,nascimento,getdate())/12) as 'idade'
from aluno
go

select nome,datediff(year,nascimento,getdate()) as 'idade'
from aluno
go

select nome, datename(month, nascimento)
from aluno
go

select nome, datename(year, nascimento)
from aluno
go

select nome, datename(weekday, nascimento) 
from aluno
go

select nome, datepart(month, nascimento)
from aluno
go

select nome, datepart(month, nascimento), datename(month, nascimento)
from aluno
go

select dateadd(day,365,getdate())
go

select dateadd(year,10,getdate())
go

select nome, dateadd(day,getdate(),nascimento)
from aluno
go
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
**CONVERSÃO DE DADOS**

select cast('1' as int) + cast('1' as int)
go

select nome, 
cast(day(nascimento) as varchar) + '/'  +
cast(month(nascimento) as varchar) +  '/'  +
cast(year(nascimento) as varchar) as 'nascimento'
from aluno
go
------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
**CHARINDEX**

select nome, charindex('a',nome) as 'indice'
from aluno
go

select nome, charindex('a',nome,2) as 'indice'
from aluno
go
---------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
**BULK IMPORTAÇÃO DE ARQUIVOS**

create table lancamento_contabil(
conta int,
valor int,
deb_cred char(1)
)
go


bulk insert into lancamento_contabil
from 'C:\Users\Marlon\Documents\BANCO DE DADOS\original.txt'
go



select conta,deb_cred,valor,
charindex('d',deb_cred) as 'debito',
charindex('c',deb_cred) as 'credito',
charindex('c',deb_cred) * 2 - 1 as 'multiplicador'
from lancamento_contabil
go

select conta,sum(valor * (charindex('c',deb_cred) * 2 - 1))
from lancamento_contabil
group by conta
go
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
**TRIGGERS**

create table produtos(
idproduto int primary key identity,
nome varchar(50) not null,
categoria varchar(30) not null,
preco numeric(10,2) not null
)
go

create table historico(
idoperacao int primary key identity,
nome varchar(50) not null,
categoria varchar(30) not null,
preco_antigo numeric(10,2) not null,
preco_novo numeric(10,2) not null,
data datetime,
usuario varchar(30),
mensagem varchar(100)
)
go

insert into produtos values('SQL Server','Livros',98.00)
insert into produtos values('Oracle','Livros',50.00)
insert into produtos values('Licença Powercenter','Softwares',45000.00)
insert into produtos values('Notebook I7','Computadores',3150.00)
insert into produtos values('Business Intelligence','Livros',90.00)
go


**VERIFICANDO USUARIO**

select suser_name()
go



create trigger TRIGGER_atualiza_preco
on dbo.produtos 
for update 
as

declare @idproduto int
declare @nome varchar(50)
declare @categoria varchar(30)
declare @preco_antigo numeric(10,2)
declare @preco_novo numeric(10,2)
declare @data datetime
declare @usuario varchar(30)
declare @mensagem varchar(100)


select @idproduto = idproduto from inserted
select @nome = nome from inserted
select @categoria = categoria from inserted
select @preco_antigo = preco from deleted
select @preco_novo = preco from inserted

set @data = getdate()
set @usuario = suser_name()
set @mensagem = 'VALOR INSERIDO PELA TRIGGER TRIGGER_atualiza_preco'

insert into historico(nome,categoria,preco_antigo,preco_novo,data,usuario,mensagem)
values(@nome,@categoria,@preco_antigo,@preco_novo,@data,@usuario,@mensagem)


print 'TRIGGER EXECUTADA COM SUCESSO'
go


update produtos set preco = 100.00 
where idproduto = 1
go

select * from produtos
select * from historico
go

update produtos set nome = 'C#'
where idproduto = 1
go

**PROGRAMANDO TRIGGER PARA UMA COLUNA**

create trigger TRIGGER_atualiza_preco
on dbo.produtos 
for update as
if update(preco)
begin

declare @idproduto int
declare @nome varchar(50)
declare @categoria varchar(30)
declare @preco_antigo numeric(10,2)
declare @preco_novo numeric(10,2)
declare @data datetime
declare @usuario varchar(30)
declare @mensagem varchar(100)


select @idproduto = idproduto from inserted
select @nome = nome from inserted
select @categoria = categoria from inserted
select @preco_antigo = preco from deleted
select @preco_novo = preco from inserted

set @data = getdate()
set @usuario = suser_name()
set @mensagem = 'VALOR INSERIDO PELA TRIGGER TRIGGER_atualiza_preco'

insert into historico(nome,categoria,preco_antigo,preco_novo,data,usuario,mensagem)
values(@nome,@categoria,@preco_antigo,@preco_novo,@data,@usuario,@mensagem)


print 'TRIGGER EXECUTADA COM SUCESSO'
end
go

update produtos set preco = 300.00 
where idproduto = 2
go

update produtos set nome = 'Java'
where idproduto = 2
go
----------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
**SIMPLIFICANDO**

create table empregado(
idempregado int primary key,
nome varchar(30),
salario money,
idgerente int
)
go

alter table empregado
add constraint FK_gerente
foreign key(idgerente) references empregado(idempregado)
go


insert into empregado values(1,'Clara',5000.00,null)
insert into empregado values(2,'Celia',4000.00,1)
insert into empregado values(3,'Joao',4000.00,1)
go


create table hist_salario(
idempregado int,
antigosal money,
novosal money,
data datetime
)
go


create trigger TRIGGER_salario
on dbo.empregado
for update
as 
if update(salario)
begin
insert into hist_salario(idempregado,antigosal,novosal,data)
	select d.idempregado,d.salario,i.salario,getdate()
	from deleted d, inserted i
	where d.idempregado = i.idempregado
end
go



create table salario_range(
minsal money,
maxsal money
)
go

insert into salario_range values(3000.00,6000.00)


create trigger TRIGGER_rangesalario
on dbo.empregado
for insert,update
as

declare
@minsal money,
@maxsal money,
@atualsal money


select @minsal = minsal, @maxsal = maxsal from salario_range

select @atualsal = i.salario
from inserted i 

if(@atualsal < @minsal)
begin
raiserror ('Salario menor que o Piso',16,1)
rollback transaction
end

if(@atualsal > @maxsal)
begin
raiserror ('Salario maior que o Teto',16,1)
rollback transaction
end
go


sp_helptext TGR_rangesalario
go

