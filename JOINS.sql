**JOIN;***

select order_id,
order_date,
ship_date,
order_qty,
customer.customer_id,
name,
street_address,
city,
state,
zip,
product_id
from customer 
inner join customer_order
on customer.CUSTOMER_ID = customer_order.CUSTOMER_ID;



select order_id,
order_date,
ship_date,
order_qty,
customer.customer_id,
name,
street_address,
city,
state,
zip,
product_id
from customer 
left join customer_order
on customer.CUSTOMER_ID = customer_order.CUSTOMER_ID;



select order_id,
order_date,
ship_date,
order_qty,
customer.customer_id,
name,
street_address,
city,
state,
zip,
product_id
from customer 
inner join customer_order
on customer.CUSTOMER_ID = customer_order.CUSTOMER_ID
where order_id is null;



select order_id,
order_date,
ship_date,
order_qty,
customer.customer_id,
name,
street_address,
city,
state,
zip,
product_id,
price
from customer 
inner join customer_order
on customer.CUSTOMER_ID = customer_order.CUSTOMER_ID
inner join product
on product.PRODUCT_ID = customer_order.PRODUCT_ID;



select order_id,
order_date,
ship_date,
order_qty,
customer.customer_id,
name,
street_address,
city,
state,
zip,
product_id,
price,
order_qty * price as revenue
from customer 
inner join customer_order
on customer.CUSTOMER_ID = customer_order.CUSTOMER_ID
inner join product
on product.PRODUCT_ID = customer_order.PRODUCT_ID;



select order_id,
order_date,
ship_date,
order_qty,
customer.customer_id,
name,
street_address,
city,
state,
zip,
product_id,
price,
sum(order_qty * price) as revenue
from customer 
inner join customer_order
on customer.CUSTOMER_ID = customer_order.CUSTOMER_ID
inner join product
on product.PRODUCT_ID = customer_order.PRODUCT_ID
group by name,customer.CUSTOMER_ID;



select order_id,
order_date,
ship_date,
order_qty,
customer.customer_id,
name,
street_address,
city,
state,
zip,
product_id,
price,
sum(order_qty * price) as revenue
from customer 
left join customer_order
on customer.CUSTOMER_ID = customer_order.CUSTOMER_ID
left join product
on product.PRODUCT_ID = customer_order.PRODUCT_ID
group by name,customer.CUSTOMER_ID;

