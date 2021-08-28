SELECT emp_first, emp_last 
FROM employees emp
WHERE emp.afl_id in (SELECT afl.afl_id FROM aircraft_fleet afl inner join airports a
on a.apt_id = afl.apt_id
where apt_name = 'Dallas/Fort Worth');


SELECT emp_first, emp_last 
FROM employees emp
WHERE emp.afl_id in (SELECT afl.afl_id FROM aircraft_fleet afl inner join aircraft_types a
on a.act_id = afl.act_id
where act_name = 'Boeing 767');

WITH 
dept_costs AS
(SELECT department_name, SUM(salary) dept_total
FROM hr.employees e 
INNER JOIN hr.departments d
ON e.department_id = d.department_id
GROUP BY department_name), 
avg_cost AS 
(SELECT SUM(dept_total)/COUNT(*) avrg FROM dept_costs) 
SELECT * FROM dept_costs
WHERE dept_total > (SELECT avrg FROM avg_cost) 
ORDER BY department_name;


select s.aviao,s.nome,s.idet
from
(select
(select act_name from aircraft_types a where a.act_id = afl.act_id and act_name = 'Boeing 767') aviao,
(select emp_first ||' '|| emp_last from employees e where e.afl_id = afl.afl_id) nome,
afl.act_id idet
from aircraft_fleet afl) s
where s.aviao is not null;


select e.emp_id,e.fname,e.lname,
(select emg.fname from employee emg where e.superior_emp_id = emg.emp_id) nome,
(select emg.lname from employee emg where e.superior_emp_id = emg.emp_id) sobrenome
from employee e;

select nivel.nome,e.salary,e.emp_first || ' ' || e.emp_last emp_name
from employees e
inner join
(select 'Iniciante' nome, 0 piso, 90000 teto from dual
union all
select 'Intermediario' nome, 90001 piso, 150000 teto from dual
union all
select 'Experiente' nome, 150001 piso, 600000 teto from dual) nivel
on salary between nivel.piso and nivel.teto;




select emp_id,fname,lname
from employee
where assigned_branch_id = (select assigned_branch_id from employee where fname = 'sarah' and lname = 'parker')
and not  (fname = 'sarah' and lname = 'parker');



select open_emp_id ,count(*)
from account 
group by open_emp_id;


select open_emp_id ,cust_id
from account a 
where exists (select count(*) from account ac where a.cust_id = ac.cust_id)
group by cust_id,open_emp_id
order by 1;

with 
conta_cliente as 
(select cust_id,count(*) conta
from  account 
group by cust_id),

nome_cliente as 
(select max(conta) ct from conta_cliente)

select cust_id from conta_cliente
where conta = (select ct from nome_cliente);



select ifnull(b.cust_id, 'Total'),sum(b.ca),a.cust_type_cd
from 
(select cust_id,cust_type_cd
from customer) a 
join
(select cust_id,count(*)ca
from account
group by cust_id) b
on a.cust_id = b.cust_id
group by a.cust_type_cd, b.cust_id with rollup
order by 3 desc;






