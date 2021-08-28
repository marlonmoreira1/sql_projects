MYSQL = INFORMATION_SCHEMA

ORACLE 

DICTIONARY
ALL_CATALOG
ALL_OBJECT
ALL_CONSTRAINTS
ALL_VIEWS
ALL_INDEXES
ALL_TABLES
ALL_TAB_COLUMNS
USER_TAB_PRIVS
USER_SYS_PRIVS
DBA_TAB_PRIVS
DBA_SYS_PRIVS
ROLE_SYS_PRIVS
ROLE_TAB_PRIVS
SESSION_ROLES
ROLE_ROLE_PRIVS




select * from dictionary
where table_name like '%CONSTRAINT%' ;


select * from dictionary
where table_name like '%VIEW%';


select * from dictionary
where table_name like '%INDEX%';

select * from dictionary
where table_name like'%SEQUENCE%';


select * from all_catalog
where table_name like 'PRODUCT%';


select object_name,object_type,status from all_objects
where object_type in ('TABLE','INDEX','VIEW','CONSTRAINT')
and status = 'INVALID';



desc all_constraints;

desc all_views;

desc all_indexes;


select constraint_name,constraint_type,table_name,search_condition,r_constraint_name,status,validated,last_change 
from all_constraints
where table_name like 'PRODUCT%';


select index_name,index_type,table_name,uniqueness,parameters,domidx_status,visibility,dropped
from all_indexes
where table_name like 'PRODUCT%';