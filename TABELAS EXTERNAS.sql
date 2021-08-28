create or replace directory Data_science as 'c:/Data_science';


GRANT READ, WRITE ON DIRECTORY Data_science TO hr;   



(ARQUIVOS TXT)
create table locadora
(
idlocacao char(3),
genero char(9),
filme char(22),
"data" char(27),
dias char(3),
midia char(4)
)
organization external 
(
type oracle_loader
default directory Data_science
access parameters
(
records delimited by newline
skip 2
fields 
(idlocacao char(3),
genero char(9),
filme char(22),
"data" char(27),
dias char(3),
midia char(4))
)

LOCATION ('RELATORIO_LOCADORA.csv')
)
reject limit unlimited;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



(ARQUIVOS CSV)

create table locadora
(
idlocacao char(3),
genero char(9),
filme char(22),
"data" char(27),
dias char(3),
midia char(4)
)
organization external 
(
type oracle_loader
default directory Data_science
access parameters
(
records delimited by newline
skip 1
fields terminated by ';'
)

LOCATION ('RELATORIO_LOCADORA.csv')
)
reject limit unlimited
noparallel
nomonitoring;




