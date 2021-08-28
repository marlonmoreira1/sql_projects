SELECT xid, logon_user 
FROM flashback_transaction_query
WHERE xid IN 
(SELECT versions_xid FROM employees VERSIONS BETWEEN TIMESTAMP
TO_TIMESTAMP('01-AUG-20 09.28.00PM','DD-MON-YY HH:MI:SSAM') 
AND TO_TIMESTAMP('01-AUG-20 09.36.00PM','DD-MON-YY HH:MI:SSAM'));

 

SELECT versions_starttime, versions_endtime, versions_xid, versions_operation AS OP, salary 
FROM employees 
VERSIONS BETWEEN TIMESTAMP
TO_TIMESTAMP('01-AUG-20 09.28.00PM','DD-MON-YY HH:MI:SSAM') 
AND TO_TIMESTAMP('01-AUG-20 09.36.00PM','DD-MON-YY HH:MI:SSAM')
WHERE emp_last='McCoy';






 



