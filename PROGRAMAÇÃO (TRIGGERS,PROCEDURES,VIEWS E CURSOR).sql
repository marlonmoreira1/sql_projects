***PROGRAMAÇÕES****


***PROCEEDURES***

create procedure cad_curso(P_nome varchar(30),P_horas int(3),P_valor float(10,2))
begin 
insert into cursos (curso,horas,valor) values(P_nome,P_horas,P_valor);
end
/


create procedure sel_curso()
begin
select idcurso,curso,horas,valor from cursos;
end
/


create proc telefones @tipo char(3)
as
select nome,sexo,tipo,numero
from pessoa
inner join telephone
on idpessoa = id_pessoa
where tipo = @tipo
go



create proc cadastro @nome varchar(30), @sexo char(1), @nascimento date,
@tipo char(3), @numero varchar(10)
as

declare @fk int

insert into pessoa values(@nome,@sexo,@nascimento)

set @fk = (select idpessoa from pessoa where idpessoa = @@IDENTITY)

insert into telephone values(@tipo,@numero,@fk)
go

cadastro 'Jorge','M','1981-01-01','cel','97273822'
go


__________________________________________________________________________________________________________________________________________

create procedure inserir_dados()
begin
declare fim int default 0;
declare var1,var2,var3,vtotal,vmedia int;
declare vnome varchar(50);

declare reg cursor for(
select nome,jan,fev,mar from vendedores
);

declare continue handler for not found set fim = 1;

open reg;

repeat 

fetch reg into vnome,var1,var2,var3;
if not fim then 

set vtotal = var1+var2+var3;
set vmedia = vtotal/3;

insert into total_vendas values(vnome,var1,var2,var3,vtotal,vmedia);

end if;

until fim end repeat;

close reg;
end
@





create procedure inserirdado()
begin

declare fim int default 0;
declare vnome,vproduto varchar(30);
declare vquantidade,vtotal int;
declare vpreco float;

declare registro cursor for(

	select c.nome,p.produto,p.preco,pe.quantidade
	from pedido pe
	inner join cliente c on c.idcliente = pe.id_cliente
	inner join produto p on p.idproduto = pe.id_produto

);

declare continue handler for not found set fim = 1;

open registro;

repeat

fetch registro into vnome,vproduto,vpreco,vquantidade;
if not fim then

set vtotal = vpreco * vquantidade;

insert into relatorio values(vproduto,vnome,vpreco,vquantidade,vtotal);

end if;

until fim end repeat;

close registro;

end
@

----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
***VIEW****



create view VIEW_bericht as 
select c.nome,c.sexo,c.email,t.tipo,t.numero,e.bairro,e.cidade,e.estado
from cliente c 
inner join endereco e on c.idcliente = e.id_cliente
inner join telefone t on c.idcliente = t.id_cliente;
----------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------

***TRIGGERS***


create trigger BACKUP_USER                                                                                                                                                                                                                   
before delete on usuario                           
for each row                                    
begin                                       
insert into backup_usuario values                                                          
(null,old.idusuario,old.nome,old.login);
end                                                         
/ 


create trigger backup_prod
before insert on produto
for each row
begin
insert into backup.backup_produto values (null,new.idproduto,new.nome,new.valor);
end
/



create trigger backup_prod_delete
before delete on produto
for each row
begin
insert into backup.backup_produto values (null,old.idproduto,old.nome,old.valor);
end
/


create trigger backup_produ
after insert on produto
for each row
begin
insert into backup.backup_produto values (null,new.idproduto,new.nome,new.valor);
end
/


create trigger backup_produ
after insert on produto
for each row
begin
insert into backup.backup_produto values (null,new.idproduto,new.nome,new.valor,'I');
end
/



create trigger backup_prod_delete
before delete on produto
for each row
begin
insert into backup.backup_produto values (null,old.idproduto,old.nome,old.valor,'D');
end
/

create trigger auditoria_produto
after update on produto
for each row
begin
insert into backup.backup_produto values (null,old.idproduto,old.nome,old.valor,new.valor,now(),current_user(),'U');
end
/

__________________________________________________________________________________________________________________________________________________________________
create trigger TGR_rangesalario
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
____________________________________________________________________________________________________________________________________________
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
_________________________________________________________________________________________________________________________________________________________
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
___________________________________________________________________________________________________________________________________________________
**TRIGGERS POSTGREE***


create or replace function ATUALIZA_REL()
returns trigger as $$
begin

insert into RELATORIO_LOCADORA
select l.idlocacao,g.nome as Genero,f.nome as Filme,l.data as Data,l.dias as Dias,l.midia as Midia
from filme f
inner join genero g
on f.id_genero = g.idgenero
inner join locacao l
on l.id_filme = f.idfilme
where idlocacao not in (select idlocacao from RELATORIO_LOCADORA);

copy RELATORIO_LOCADORA to
'C:\Data_Science\RELATORIO_LOCADORA.csv'
delimiter ';'
csv header;

return new;
end;
$$
language plpgsql;



create trigger TG_RELATORIO
after insert on locacao
for each row
execute procedure ATUALIZA_REL();




create or replace function DELETE_LOCACAO()
returns trigger as
$$
begin

delete from RELATORIO_LOCADORA
where idlocacao = old.idlocacao;

copy RELATORIO_LOCADORA to
'C:\Data_Science\RELATORIO_LOCADORA.csv'
delimiter ';'
csv header;

return old;
end;
$$
language plpgsql;



create trigger DELETE_REG
before delete on locacao
for each row
execute procedure DELETE_LOCACAO();