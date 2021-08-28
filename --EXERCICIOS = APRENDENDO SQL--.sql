--EXERCICIOS = APRENDENDO SQL--
-----------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 3 

1°

select emp_id,fname,lname 
from employee
order by 3,2;

2°

select account_id,cust_id,status,avail_balance
from account 
where status = 'active' and avail_balance > 2500.00;

3°

select distinct open_emp_id
from account;

select account_id,product_cd,open_date,open_emp_id
from account
group by 4;

4°

select p.product_cd,a.cust_id,a.avail_balance
from product p
inner join account a
on p.product_cd = a.product_cd
where p.product_type_cd = 'account'
order by 1,2;
-------------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 4 

1°

1,2,3,5,6,7

2°

4,9

3°

select account_id,product_cd,open_date
from account
where open_date between '2002-01-01' and '2002-12-31';


4°

select fname,lname
from individual
where lname like '_a%e%';
-----------------------------------------------------------------------------------------------------
CAPITULO 5 


select b.name,e.fname,e.lname,a.account_id,e.title
from  branch b
inner join employee e
on b.branch_id = e.assigned_branch_id
inner join account a
on e.emp_id = a.open_emp_id;


1°

select e.emp_id,e.fname,e.lname,b.name
from employee e
inner join branch b 
on e.assigned_branch_id = b.branch_id;


2°
select c.cust_id,c.fed_id,p.name,a.product
_cd
from account a 
inner join customer c
on a.cust_id = c.cust_id 
inner join product p
on a.product_cd = p.product_cd
where cust_type_cd = 'I';


3°

select e.emp_id,e.fname,e.lname,emg.dept_id,e.dept_id,emg.fname,emg.lname
from employee e
inner join employee emg
on e.superior_emp_id = emg.emp_id
where emg.dept_id != e.dept_id;

OBS: **EMG** REFERE-SE A CHAVE DO EMPREGADO/// ENQUANTO QUE **E** A CHAVE DO SUPERIOR 

select e.emp_id,e.fname,e.lname,de.name employee_dept,dmg.name superior_dept,emg.fname,emg.lname
from employee e
inner join employee emg
on e.superior_emp_id = emg.emp_id
inner join department dmg
on dmg.dept_id = e.dept_id
inner join department de
on de.dept_id = emg.dept_id
where emg.dept_id != e.dept_id;
----------------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 6


 select 'ind' type_cd,cust_id,lname 
 from individual
 union all
 select 'bus' type_cd,cust_id,name
 from business;


1° 
l,m,n,o,p,q,r,s,t

l,m,n,o,p,p,q,r,s,t

p

l,m,n,o



2°

select fname,lname 
from individual
union all 
select fname,lname 
from employee;



3°

select 'cliente' nomeacao,fname,lname 
from individual
union all 
select 'empregado' nomeacao,fname,lname 
from employee
order by lname;
---------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 07


1°

select substring('please find the substring in this string',17,10);

2°

select abs(-25.76823),sign(-25.76823),round(-25.76823,2);


3°

select extract(month from current_date);




select (avail_balance-pending_balance) as saldo,
case 
when (avail_balance-pending_balance) = 0 then 'ok'
else 'negativo'
end as 'situacao'
from account;


select concat(' A CONTA ESTA ', status,' E COM O SALDO DE ', avail_balance) report from account;


select fname from employee
where fname regexp '^[m]';

select round(72.4999,2),round(72.5),round(72.50001,1);


select account_id,sign(avail_balance),avail_balance
from account;

select str_to_date('july 08,2020', '%M %d,%y');


select extract(year from current_date);
-------------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 08


1°

select count(*) quantidade_contas
from account;

2°

select cust_id,count(*) quantidade_contas
from account
group by cust_id;

3°


select cust_id,count(*) quantidade_contas
from account
group by cust_id
having count(*) > 1;

4°

select sum(a.avail_balance),p.product_cd,b.name,count(*)
from account a 
inner join product p 
on p.product_cd = a.product_cd
inner join branch b 
on b.branch_id = a.open_branch_id
group by 2,3 
having count(*) > 1
order by 1 desc;







select p.name,b.name,sum(a.avail_balance)
from account a
inner join branch b
on a.open_branch_id = b.branch_id
inner join product p
on a.product_cd = p.product_cd
group by p.name, b.name with cube;

select p.name,b.name,sum(a.avail_balance)
from account a
inner join branch b
on a.open_branch_id = b.branch_id
inner join product p
on a.product_cd = p.product_cd
group by p.name, b.name with rollup;



select extract(year from start_date) ano,
count(*) Quantidade
from employee
group by 1
order by 2 desc;


select extract(month from start_date) mes,
count(*) Quantidade
from employee
group by 1
order by 2 desc
limit 6;
-----------------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 09



1°

select account_id,product_cd,cust_id,avail_balance
from account
where product_cd in (select product_cd from product
where product_type_cd = 'loan');


2°

select a.account_id,a.product_cd,a.cust_id,a.avail_balance
from account a
where exists (select 1 from product p
where p.product_cd = a.product_cd 
and p.product_type_cd = 'loan');

3°

select e.emp_id,e.fname,e.lname,levels.name
from employee e inner join 
(select 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt
union all
select 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt
union all
select 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt) levels
on e.start_date between levels.start_dt and levels.end_dt;




4°
select e.emp_id,e.fname,e.lname,
(select d.name from department d where d.dept_id = e.dept_id) dnome, 
(select b.name from branch b where b.branch_id = e.assigned_branch_id) bnome
from employee e;







select c.cust_id,c.cust_type_cd,c.city
from customer c 
where 3 <= (select count(*) from account a
where a.cust_id = c.cust_id);


select account_id,cust_id,product_cd,avail_balance
from account
where avail_balance < all(select a.avail_balance
from account a inner join individual i 
on a.cust_id = i.cust_id
where i.fname = 'frank' and i.lname = 'tucker');
------------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 10


1°

select a.account_id,p.product_cd
from account a right outer join product p
on a.product_cd = p.product_cd;



select account_id,product_cd
from account a
where a.product_cd = all (select p.product_cd from product p 
where p.product_cd = a.account_id);

select a.account_id,a.product_cd
from account a
where exists (select 1 from product p
where p.product_cd = a.product_cd);


select account_id,product_cd
from account
where product_cd in (select product_cd from product);




select a.account_id,a.product_cd,
(select concat(i.fname,' ',i.lname) from individual i where i.cust_id = a.cust_id) nome,
(select b.name from business b where b.cust_id = a.cust_id) empresa
from account a;

2°

select a.account_id,p.product_cd
from product p left outer join account a 
on a.product_cd = p.product_cd;



3°

select a.account_id,a.product_cd,i.fname,concat(i.fname,' ',i.lname)nome,b.name
from account a
left outer join individual i 
on i.cust_id = a.cust_id
left outer join business b 
on b.cust_id = a.cust_id;



4°

select contr.dia,count(e.emp_id)
from employee e right outer join
(select date_add('2000-02-09', interval (menores.num + entas.num + cem.num + mil.num) day)dia 
from
(select 0 num union all
select 1 num union all
select 2 num union all
select 3 num union all
select 4 num union all
select 5 num union all
select 6 num union all
select 7 num union all
select 8 num union all
select 9 num) menores
cross join
(select 0 num union all
select 10 num union all
select 20 num union all
select 30 num union all
select 40 num union all
select 50 num union all
select 60 num union all
select 70 num union all
select 80 num union all
select 90 num) entas
cross join
(select 0 num union all
select 100 num union all
select 200 num union all
select 300 num union all
select 400 num union all
select 500 num union all
select 600 num union all
select 700 num union all
select 800 num union all
select 900 num) cem
cross join
(select 0 num union all
select 1000 num union all
select 2000 num) mil
where date_add('2000-02-09', interval (menores.num + entas.num + cem.num + mil.num) day) < '2004-09-15') contr
on contr.dia = e.start_date
group by contr.dia;
---------------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 11


1°

select emp_id,
case
when title like '%president' or title = 'treasurer' or title = 'loan manager'
then 'management'
when title = 'operations manager' or title like '%teller'
then 'operations'
else 'unknown'
end cargo
from employee;




2°

select 
sum(case 
when open_branch_id = 1 then 1
else 0 end) branch_1,
sum(case 
when open_branch_id = 2 then 1
else 0 end) branch_2,
sum(case 
when open_branch_id = 3 then 1
else 0 end) branch_3,
sum(case 
when open_branch_id = 4 then 1
else 0 end) branch_4
from account;




select a.cust_id,a.product_cd,a.avail_balance /
case
when prod_tots.tot_balance = 0 then 1
else prod_tots.tot_balance
end percent_of_total
from account a inner join (select a.product_cd,sum(a.avail_balance) tot_balance
from account a 
group by a.product_cd) prod_tots
on prod_tots.product_cd = a.product_cd;


 
select concat(' Alerta! : Conta # ', a.account_id,' Tem um saldo incorreto! ')
from account a 
where (a.avail_balance,a.pending_balance) <>
(select sum(case
when t.funds_avail_date > current_timestamp()
then 0
when t.txn_type_cd = 'DBT'
then t.amount * -1
else t.amount
end),
sum(case
when t.txn_type_cd = 'DBT'
then t.amount * -1
else t.amount
end)
from transaction t 
where t.account_id = a.account_id);
-----------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 12


start transaction;

select i.cust_id,
(select a.account_id from account a 
where a.cust_id = i.cust_id and a.product_cd = 'mm') mm_id,
(select a.account_id from account a 
where a.cust_id = i.cust_id
and product_cd = 'chk') chk_id
into @cst_id, @mm_id, @chk_id
from individual i 
where i.fname = 'frank' and i.lname = 'tucker';


insert into transaction (txn_id,txn_date,account_id,txn_type_cd,amount) values (null,now(),@chk_id,'dbt',50.00); 
insert into transaction (txn_id,txn_date,account_id,txn_type_cd,amount) values (null,now(),@mm_id,'cdt',50.00); 


update account set last_activity_date = now(), 
avail_balance = avail_balance - 50.00
where account_id = @mm_id;

update account set last_activity_date = now(), 
avail_balance = avail_balance - 50.00
where account_id = @chk_id;

commit;




select cust_id,avail_balance,product_cd
from account
where cust_id = 3;
-----------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 13

1°

alter table account 
add constraint account_cust_idx unique (cust_id,product_cd);

2°

create index txn_idx01
on transaction (txn_date,amount);
------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 14


select b.name,b.city,b.state,
(select count(*) from account a where a.status = 'active' and a.open_branch_id = b.branch_id) quantidade_contas,
(select count(*) from employee e where e.assigned_branch_id = b.branch_id)Quantidade_fun,
(select count(*) from transaction t where t.execution_branch_id = b.branch_id)Quantidade_tran
from branch b;





1°
create view V_nome_todos_empregados
as
select concat(m.fname,' ',m.lname)Nome_superior,concat(e.fname,' ',e.lname)Nome_empregado
from employee m right outer join employee e 
on m.emp_id = e.superior_emp_id;




2°
create view V_saldo_contas
as
select b.name,b.city,sum(a.avail_balance)
from branch b
inner join account a 
on a.open_branch_id = b.branch_id
group by 1,2;
---------------------------------------------------------------------------------------------------------------------------------------------------
CAPITULO 15


1°

select table_name,index_name
from information_schema.statistics
where table_schema = 'bank';
























































































































































