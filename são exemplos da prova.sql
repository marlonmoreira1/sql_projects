select m.lname,e.superior_emp_id 
from employee e 
left join employee m 
on e.superior_emp_id = m.superior_emp_id
where e.emp_id = 5;

select e.fname,e.lname,m.fname,m.lname
from employee e 
left join employee m
on e.superior_emp_id = m.emp_id;


select faculty_name,count(student_id) 
from student
join faculty using (location_id,faculty_id)
group by faculty_name;

select faculty_name,count(student_id) 
from student
natural join faculty 
group by faculty_name;


select product_cd,avail_balance 
from account
where avail_balance < all (select a.avail_balance from account a inner join individual i 
on a.cust_id = i.cust_id 
where i.fname = 'Frank' and i.lname = 'Tucker');

select product_cd,avail_balance 
from account
where avail_balance < any (select a.avail_balance from account a inner join individual i 
on a.cust_id = i.cust_id 
where i.fname = 'Frank' and i.lname = 'Tucker');




create table department_details(
department_id number primary key,
department_name varchar(50),
hod varchar(50)
);

create table course_details(
course_id number primary key,
course_name varchar(50),
department_id number references department_details(department_id)
);

insert into course_details values (1,'data science',1);
insert into course_details values (2,'business intelligence',1);
insert into course_details values (3,'direito do consumidor',2);
insert into course_details values (4,'direito tributario',2);
insert into course_details values (5,'historia da arte',3);


insert into department_details values (1,'ti',null);
insert into department_details values (2,'direito',null);
insert into department_details values (3,'historia',null);
insert into department_details values (4,'economia',null);


 SELECT course_id, department_id 
 FROM department_details d 
 RIGHT OUTER JOIN course_details c
 USING (department_id);
 
 SELECT course_id, department_id
 FROM  course_details 
FULL OUTER JOIN department_details 
ON department_id = department_id;





select cust_id,avail_balance
from account
where avail_balance = (select max(soma)
from 
(select cust_id,sum(avail_balance) soma from account group by cust_id) a);



select cust_id,avail_balance from account 
where avail_balance = (select max(avail_balance) from account)
union 
select cust_id,avail_balance from account 
where avail_balance = (select min(avail_balance) from account) ;



CREATE TABLE CUSTOMERS(
CUSTNO NUMBER PRIMARY KEY,
CUSTNAME VARCHAR2(20),
CITY VARCHAR2(20));

INSERT INTO CUSTOMERS(CUSTNO, CUSTNAME, CITY) VALUES(1,'KING','SEATTLE');
INSERT INTO CUSTOMERS(CUSTNO, CUSTNAME, CITY) VALUES(2,'GREEN','BOSTON');
INSERT INTO CUSTOMERS(CUSTNO, CUSTNAME, CITY) VALUES(3,'KOCHAR','SEATTLE');
INSERT INTO CUSTOMERS(CUSTNO, CUSTNAME, CITY) VALUES(4,'SMITH','NEW YORK');

SELECT c1.custname, c1.city
FROM CUSTOMERS c1 FULL OUTER JOIN CUSTOMERS C2
ON (c1.city = c2.city AND c1.custname<>c2.custname);
