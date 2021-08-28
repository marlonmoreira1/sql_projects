select  departamento,count(*)
from funcionarios
group by departamento
order by 2 desc;


select departamento,sum(salario) salario
from funcionarios
group by departamento
order by 2 desc;


select departamento,round(avg(salario),2)
from funcionarios f
where salario = (select sum(salario) from funcionarios fu
where f.salario = fu.salario 
group by salario)
group by departamento
order by 2 desc;



update funcionarios 
set salario =  
case 
when  departamento = 'Computadores' or departamento = 'eletronicos' or departamento = 'bebês'  then 300000
when departamento = 'Roupas' or departamento = 'beleza' or departamento = 'filmes' then  200000
else 100000
end ;


