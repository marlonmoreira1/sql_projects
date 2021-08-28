select c.name,p.price,p.description,o.order_date,o.order_qty 
from customer_order o 
join customer c on c.CUSTOMER_ID = o.customer_id 
join product p on o.product_id = p.product_id;


select name, city ||' , '|| state ||' , '|| zip as location from customer;

select name,street_address ||' '|| city ||' , '|| state ||' '|| zip as location
from customer; ]




select name,street_address || ' ' || city || ' ' || state || ' ' || zip as location
from customer; 