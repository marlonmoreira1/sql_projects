select departamento,count(*)
from funcionarios
group by departamento;

select departamento,count(*)
from funcionarios
group by departamento
order by 2 desc;

select sexo,count(*)
from funcionarios
group by sexo;

select sexo,max(salario),min(salario)
from funcionarios
group by sexo;

select departamento,max(salario),min(salario)
from funcionarios
group by departamento
order by 2 desc;


select departamento,sum(salario),round(avg(salario),2)
from funcionarios
group by departamento
order by 2 desc;

select sexo,sum(salario),round(avg(salario),2)
from funcionarios
group by sexo;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
*DATA SCIENCE**

create table maquinas(
maquina varchar(20),
dia int,
quantidade numeric(10,2)
);

copy maquinas 
from 'C:\data science\LogMaquinas.csv'
delimiter ','
csv header;


select * from maquinas;


select maquina,max(quantidade) as maximo
from maquinas
where maquina = 'Maquina 01'
group by maquina;


select maquina,max(quantidade) as maximo
from maquinas
where maquina = 'Maquina 02'
group by maquina;


select maquina,max(quantidade) as maximo
from maquinas
where maquina = 'Maquina 03'
group by maquina;


select maquina,min(quantidade) as minimo
from maquinas
where maquina = 'Maquina 01'
group by maquina;


select maquina,min(quantidade) as minimo
from maquinas
where maquina = 'Maquina 02'
group by maquina;


select maquina,min(quantidade) as minimo
from maquinas
where maquina = 'Maquina 03'
group by maquina;


select maquina,round(avg(quantidade),2) as media
from maquinas
group by maquina
order by 2 desc;


select maquina,quantidade,count(*) as moda
from maquinas
where maquina = 'Maquina 01'
group by 1,2
order by 3 desc;


select maquina,quantidade,count(*) as moda
from maquinas
where maquina = 'Maquina 02'
group by 1,2
order by 3 desc;


select maquina,quantidade,count(*) as moda
from maquinas
where maquina = 'Maquina 03'
group by 1,2
order by 3 desc;


select quantidade,count(*) as moda
from maquinas
group by 1
order by 2 desc;



select maquina,
round(median(quantidade),2) as Mediana,
round(avg(quantidade),2) as Media,
max(quantidade) as Maximo,
min(quantidade) as Minimo,
max(quantidade) - min(quantidade) as Amplitude,
round(stddev_pop(quantidade),2) as Desvio_padrao,
round(var_pop(quantidade),2) as Variancia
from maquinas
group by maquina
order by 7;


select maquina,
count(quantidade) as Quantidade,
sum(quantidade) as total,
round(avg(quantidade),2) as Media,
mode() within group(order by quantidade) as Moda,
round(max(quantidade),2) as Maximo,
round(min(quantidade),2) as Minimo,
max(quantidade) - min(quantidade) as Amplitude,
round(var_pop(quantidade),2) as Variancia,
round(stddev_pop(quantidade),2) as Desvio_Padrao,
round(median(quantidade),2) as Mediana,
round((stddev_pop(quantidade)/avg(quantidade)) * 100,2) as Coef_variacao
from maquinas
group by maquina
order by 1;
_________________________________________________________________________________________________________________________________________________________
-----------------------------------------------------------------------------------------------------------------------------------------------------
select g.nome,f.nome,l.data,l.dias,l.midia 
from filme f
inner join genero g
on g.idgenero = f.id_genero
inner join locacao l
on f.idfilme = l.id_filme;



create table REL_Locadora as
select g.nome as Genero,f.nome as Filme,l.data as Data,l.dias as Dias,l.midia as Midia
from filme f
inner join genero g
on g.idgenero = f.id_genero
inner join locacao l
on f.idfilme = l.id_filme;


select * from REL_Locadora;



copy REL_Locadora to
'C:\Data_Science\REL_Locadora.csv'
delimiter ';'
csv header;



DROP TABLE LOCACAO;



CREATE TABLE LOCACAO(
	IDLOCACAO INT PRIMARY KEY,
	DATA TIMESTAMP,
	MIDIA INT,
	DIAS INT,
	ID_FILME INT,
	FOREIGN KEY(ID_FILME)
	REFERENCES FILME(IDFILME)

);


CREATE SEQUENCE SEQ_LOCACAO;


select l.idlocacao,g.nome as Genero,f.nome as Filme,l.data as Data,l.dias as Dias,l.midia as Midia
from filme f
inner join genero g
on f.id_genero = g.idgenero
inner join locacao l
on l.id_filme = f.idfilme;




create table RELATORIO_LOCADORA as
select l.idlocacao,g.nome as Genero,f.nome as Filme,l.data as Data,l.dias as Dias,l.midia as Midia
from filme f
inner join genero g
on f.id_genero = g.idgenero
inner join locacao l
on l.id_filme = f.idfilme;



select * from RELATORIO_LOCADORA;
select * from locacao;
select * from filme;




select max(idlocacao) as Relatorio,
(select max(idlocacao) from locacao) as locacao
from RELATORIO_LOCADORA;





select l.idlocacao,g.nome as Genero,f.nome as Filme,l.data as Data,l.dias as Dias,l.midia as Midia
from filme f
inner join genero g
on f.id_genero = g.idgenero
inner join locacao l
on l.id_filme = f.idfilme
where idlocacao not in (select idlocacao from RELATORIO_LOCADORA);




insert into RELATORIO_LOCADORA
select l.idlocacao,g.nome as Genero,f.nome as Filme,l.data as Data,l.dias as Dias,l.midia as Midia
from filme f
inner join genero g
on f.id_genero = g.idgenero
inner join locacao l
on l.id_filme = f.idfilme
where idlocacao not in (select idlocacao from RELATORIO_LOCADORA);




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

delete from locacao 
where idlocacao = 1;
________________________________________________________________________________________________________________________________________________________________________
-----------------------------------------------------------------------------------------------------------------------------------------------
**EXERCICIO DE FIXAÇÃO DE Data_Science***


select mode() within group(order by salario) from funcionarios;


select salario,count(*) as moda 
from funcionarios
group by salario
order by 2 desc;


select departamento,
round(stddev_pop(salario),2),
from funcionarios
group by departamento
order by 2;


select round(median(salario),2) from funcionarios;


select count(*), mode() within group(order by departamento)
from funcionarios
group by departamento
order by 1 desc;


select departamento,
count(salario) as Quantidade,
sum(salario) as total,
max(salario) as Maior,
min(salario) as Menor,
round(avg(salario),2) as Media,
mode() within group(order by salario) as Moda,
round(median(salario),2) as Mediana,
max(salario) - min(salario) as Amplitude,
round(stddev_pop(salario),2)as Desvio_Pad,
round(var_pop(salario),2) as Variancia,
round((stddev_pop(salario)/avg(salario)) * 100,2) as Coef_variacao
from funcionarios
group by departamento
order by 12;
__________________________________________________________________________________________________________________________________________________
------------------F-------------------------------------------------------------------------------------------------------------------------
**INSTRUÇAO CASE E FUNÇÃO DUMMY**

select cargo,
case 
when cargo = 'Structural Engineer' then 'Condição 1'
when cargo = 'Financial Advisor' then 'Condição 2'
when cargo = 'Recruiting Manager' then 'Condição 3'
else 'Outras condições'
end as Condição
from funcionarios
group by cargo;

select cargo from funcionarios;


select nome,cargo,(sexo = 'Masculino') as Masculino,(sexo = 'Feminino') as Feminino
from funcionarios;


select nome,cargo,
case
when (sexo = 'Masculino') = true then 1
else 0
end as Masculino,
case
when (sexo = 'Feminino') = true then 1 
else 0
end as Feminino
from funcionarios;
_________________________________________________________________________________________________________________________________________________--
----------------------------------------------------------------------------------------------------------------------------------------
**AGRUPAMENTO, AGREGAÇAÕ E OUTRAS FUNÇÕES****

select nome,departamento,salario
from funcionarios
where salario > 100000
order by 3;


select nome,departamento,salario
from funcionarios
where departamento = 'Ferramentas';



select nome,departamento,salario
from funcionarios
where departamento = 'Ferramentas'
and salario > 100000;


select departamento,sum(salario) as Total_Departamento
from funcionarios
where departamento like 'B%'
group by 1;



select departamento,sum(salario) as Total_Departamento
from funcionarios
where departamento like 'B%s'
group by 1;


select departamento,sum(salario) as Total_Departamento
from funcionarios
where departamento like 'B%'
group by 1
having sum(salario) > 4000000;



select count(*) as Quantidade,sexo
from funcionarios
where sexo = 'Masculino'
group by sexo;



select count(*) as Quantidade,
count(*) filter(where sexo = 'Masculino') as Masculino,
count(*) filter(where departamento = 'Books') as Books,
count(*) filter(where salario > 140000) as "Salario > 140k"
from funcionarios;



select distinct departamento 
from funcionarios; 


select distinct upper(departamento) 
from funcionarios; 


select distinct lower(departamento) 
from funcionarios; 


select cargo ||' - '|| departamento
from funcionarios;



select distinct upper(cargo ||' - '|| departamento)
from funcionarios;


select length('       Unidados           ');


select length(trim('       Unidados           '));



select nome,sexo,cargo,(cargo like '%Assistant%') as Assistente
from funcionarios
where (cargo like '%Assistant%') = true;


select nome,sexo,cargo,
case
when (cargo like '%Assistant%') = true then 1
else 0
end as Assistente
from funcionarios;





