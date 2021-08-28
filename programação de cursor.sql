create database programar;

use programar;

create table produto(
idproduto int primary key auto_increment,
produto varchar(30) not null,
preco float(10,2) not null
);

create table cliente(
idcliente int primary key auto_increment,
nome varchar(30) not null,
sexo char(1) not null
);

create table pedido(
idpedido int primary key auto_increment,
id_cliente int,
id_produto int,
quantidade int not null
);

create table relatorio(
produto varchar(30),
nome varchar(30),
preco float(10,2),
quantidade int,
total int
);


alter table pedido
add constraint FK_pedido_produto
foreign key (id_produto) references produto(idproduto);

alter table pedido
add constraint FK_pedido_cliente
foreign key (id_cliente) references cliente(idcliente);


insert into produto values(null,'livro',100.00);
insert into produto values(null,'lampada',150.00);
insert into produto values(null,'mesa',55.00);
insert into produto values(null,'fone',60.00);
insert into produto values(null,'gibi',30.00);
insert into produto values(null,'brinquedo',40.00);
insert into produto values(null,'caneta',10.00);
insert into produto values(null,'computador',200.00);


insert into cliente values(null,'joao','M');
insert into cliente values(null,'andre','M');
insert into cliente values(null,'maria','F');
insert into cliente values(null,'alice','F');
insert into cliente values(null,'joana','F');
insert into cliente values(null,'ana','F');
insert into cliente values(null,'adelio','M');
insert into cliente values(null,'daniel','M');



insert into pedido values(null,1,1,3);
insert into pedido values(null,2,8,6);
insert into pedido values(null,3,7,1);
insert into pedido values(null,5,2,8);
insert into pedido values(null,4,3,3);
insert into pedido values(null,6,4,9);
insert into pedido values(null,7,5,2);
insert into pedido values(null,8,6,4);
insert into pedido values(null,1,8,7);
insert into pedido values(null,2,1,3);
insert into pedido values(null,3,3,5);
insert into pedido values(null,4,6,3);
insert into pedido values(null,5,7,5);
insert into pedido values(null,6,2,3);
insert into pedido values(null,7,4,7);
insert into pedido values(null,8,7,3);
insert into pedido values(null,1,5,3);
insert into pedido values(null,2,3,1);
insert into pedido values(null,3,1,1);
insert into pedido values(null,4,2,1);
insert into pedido values(null,8,3,1);
insert into pedido values(null,7,7,1);
insert into pedido values(null,6,8,1);
insert into pedido values(null,5,3,1);
insert into pedido values(null,4,1,1);
insert into pedido values(null,3,4,1);
insert into pedido values(null,2,2,1);
insert into pedido values(null,1,2,1);


delimiter @

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

delimiter ;

call inserirdados();



select nome,sum(total) from relatorio
group by nome;


select nome,total
from relatorio
where total = (select max(total) from relatorio);


select produto,nome,sum(total) from relatorio
group by nome;

