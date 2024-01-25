create database salesdata;

use salesdata;

desc customers;

show create table customers;

desc employees;

show create table employees;

desc offices;

show create table offices;

desc products;

show create table products;

show create table productlines;

select * from products;

select * from productlines ;

show create table orders;

show create table orderdetails;

select * from orderdetails order by productcode;

show create table payments;

use salesdata;
show tables;

select * from customers;

select customernumber, creditlimit 
from customers;

select * from payments;

select customernumber,sum(amount)
from payments
group by customernumber;

update customers
set creditlimit = (select sum(amount)
					from payments
					where customernumber = 103
					group by customernumber) - creditlimit
where customernumber = 103;

select count(distinct country)
from customers;

select * from offices;

insert into offices values
(8, 'Mumbai', '+91 22 78384787','andheri','',
'maharashtra','india',400012,'');

/*The territories assigned to each office need to be 
updated based on the country of the office location. 
Design an SQL query or procedure to automatically assign 
the correct territory code to each office based on its country. 
Use the offices table for this operation.*/

select case 
	when country in ('USA') then 'NA'
    when country in ('france','uk','germany','italy') then 'EMEA'
    when country in ('australia','new zealand') then 'APAC'
    when country in ('india','sri lanka') then 'SAARC'
    else country
end 'territory'
from offices;

update offices
set territory = (select case 
	when country in ('USA') then 'NA'
    when country in ('france','uk','germany','italy') then 'EMEA'
    when country in ('australia','new zealand') then 'APAC'
    when country in ('india','sri lanka') then 'SAARC'
    else country
	end 'territory'
	from offices
    where country = 'india')
where country = 'india';

select * from productlines;

select avg(length(textdescription))
from productlines;

/*The marketing team at ARISOFT Corporation is interested in analyzing 
the effectiveness of product line descriptions. 
Develop an SQL query to retrieve the average length of 
product line descriptions (textDescription column in the 
productlines table) and identify which product lines have 
descriptions above or below the average length.*/
/*above 400 characters*/
select productline, textdescription, length(textdescription)
from productlines
where length(textdescription) > 
		(select avg(length(textdescription))
		from productlines);

/*below 400 characters*/
select productline, textdescription, length(textdescription)
from productlines
where length(textdescription) < 
		(select avg(length(textdescription))
		from productlines);

select * from orders;

select * from customers;

/*The logistics department needs a way to identify orders 
with late shipments. Develop an SQL query or procedure to 
list orders that have a status of 'Shipped' but where the 
shipped date is later than the required date.*/
select customername, country 
from orders, customers
where orders.customernumber = customers.customernumber
		and status = 'shipped'
		and shippeddate > requireddate;

select customername, country 
from orders join customers
on(orders.customernumber = customers.customernumber)
where status = 'shipped'
		and shippeddate > requireddate;
        
select customername, country 
from orders o join customers c
on(c.customernumber = o.customernumber)
where status = 'shipped'
		and shippeddate > requireddate;
        
select customername, country 
from orders o join customers c
using(customernumber)
where status = 'shipped'
		and shippeddate > requireddate;
        
select customername, country 
from orders o natural join customers c
where status = 'shipped'
		and shippeddate > requireddate;
        
/*ARISOFT Corporation wants to implement a system 
where the credit limit of a customer is automatically 
updated based on the total amount of payments received 
for that customer. Design an SQL query or procedure to 
calculate the total payments received for each customer and 
update their credit limit accordingly.*/

delimiter $
create procedure Customer_Credit_Limit_Update()
begin
#declare variables
declare done boolean default false;
declare custid int;
declare totalpayment decimal(10,2);

#declare cursor
declare mycursor cursor for
select customernumber,sum(amount)
from payments
group by customernumber;

#declare error handler
declare continue handler for not found set done = true;

#open cursor
open mycursor;

#fetch the rows and update the customers table
while not done do
fetch mycursor into custid, totalpayment;
update customers 
set creditlimit = creditlimit + totalpayment
where customernumber = custid;
end while;

#close cursor
close mycursor;
end $

select * from customers;

call Customer_Credit_Limit_Update();

/*ARISOFT Corporation wants to identify employees who are 
eligible for promotion based on their job performance. 
Create an SQL query or procedure to check if an employee 
has achieved a specified sales target (consider the orders 
and orderdetails tables) and, if so, update their job title 
to indicate a promotion.*/

select * from employees;

select * from customers order by salesrepemployeenumber;

select * from orderdetails;

select * from orders;

select e.employeenumber
from customers c join employees e
on(c.salesrepemployeenumber = e.employeenumber)
join orders o
on(c.customernumber = o.customernumber)
join orderdetails od
on(o.ordernumber = od.ordernumber)
group by e.employeenumber
having sum(od.priceeach * od.quantityordered) > 700000;

delimiter $
create procedure Employee_Promotion_Check()
begin
declare done boolean default false;
declare empid int;

declare cur cursor for
select e.employeenumber
from customers c join employees e
on(c.salesrepemployeenumber = e.employeenumber)
join orders o
on(c.customernumber = o.customernumber)
join orderdetails od
on(o.ordernumber = od.ordernumber)
group by e.employeenumber
having sum(od.priceeach * od.quantityordered) > 700000;

declare continue handler for not found set done = true;

open cur;

while not done do
fetch cur into empid;
update employees 
set jobtitle = 'Senior Sales Rep'
where employeenumber = empid;
end while;

close cur;
end;

call Employee_Promotion_Check();

select * from employees;
