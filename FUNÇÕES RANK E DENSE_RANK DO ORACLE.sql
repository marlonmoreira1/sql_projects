select act_name,act_body_style,act_seats, 
sum(act_seats) over (order by act_body_style) running_soma,
rank() over (order by act_body_style) ranking,
sum(act_seats) over (partition by act_body_style order by act_body_style) soma_partida
from aircraft_types
order by 5;

select rank('Wide') within group (order by act_body_style) wide,
rank('Narrow') within group (order by act_body_style) Narrow,
dense_rank('Wide') within group (order by act_body_style) wide,
dense_rank('Narrow') within group (order by act_body_style) Narrow
from aircraft_types;


create table hotel(
hospedes number,
quarto number,
);


insert into hotel values(1,100);
insert into hotel values(3,200);
insert into hotel values(5,300);
insert into hotel values(2,400);
insert into hotel values(1,300);
insert into hotel values(1,200);
insert into hotel values(2,100);




(ESSE SELECT BUSCA O MAIOR QUARTO NO MENOR NUMERO DE HOSPEDES)
select max(quarto) keep (dense_rank first order by hospedes) from hotel;


select max(quarto) keep (dense_rank last order by hospedes) from hotel;

select min(quarto) keep (dense_rank first order by hospedes) from hotel;

select min(quarto) keep (dense_rank last order by hospedes) from hotel;


select avg(act_seats), act_body_style,act_decks
from aircraft_types
group by act_body_style, act_decks;

select sum(act_seats), act_body_style,act_decks
from aircraft_types
group by rollup(act_body_style, act_decks);

select sum(act_seats), act_body_style,act_decks
from aircraft_types
group by cube(act_body_style, act_decks);

select act_id,act_name,act_body_style,apt_name,afl_id
from aircraft_fleet
natural join aircraft_types
natural join airports;


select act_id,act_name,act_body_style,apt_name,afl_id
from aircraft_fleet
natural left join aircraft_types
natural left join airports;

select act_id,act_name,act_body_style,apt_name,afl_id
from aircraft_fleet
natural right join aircraft_types
natural right join airports;


select act_id,act_name,act_body_style,apt_name,afl_id
from aircraft_fleet
natural full outer join aircraft_types
natural full outer join airports;


select act_id,act_name,act_body_style,apt_name,afl_id
from aircraft_fleet
left join aircraft_types
using (act_id)
left join airports
using(apt_id);



