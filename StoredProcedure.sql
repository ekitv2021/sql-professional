
use salesdata;

show tables;

delimiter $
create procedure getallcustomers()
begin
select * from customers;
end $

call getallcustomers();

delimiter $
create procedure getallproductnorder()
begin
select * from products;
select * from orders;
end $

call getallproductnorder();

delimiter $
create procedure getemployee(empid decimal(10))
begin
select * from employees
where employeenumber = empid;
end;

call getemployee(1088);

/*Create a stored procedure that displays 
the employee names if we provide the city
in which the office of the employee is located*/

select * from employees;
select * from offices;

delimiter $
create procedure getempbycity(empcity varchar(20))
begin 
select firstname, lastname
from employees join offices
using(officecode)
where city = empcity;
end;

call getempbycity('london');

/*Create a procedure that displays the average of 
buyprice based on the productline provided by us*/

select * from products;

delimiter $
create procedure getavgbuyprice(prodline varchar(50))
begin
select avg(buyprice)
from products
where productline = prodline
group by productline;
end;

call getavgbuyprice('planes');

/*Declare a variable*/
delimiter $
create procedure sample()
begin
declare a int;
select a;
end;

call sample();

drop procedure sample;

delimiter $
create procedure sample()
begin
declare a int default 1;
select a;
end;

call sample();

drop procedure sample;

delimiter $
create procedure sample()
begin
declare a int default 1;
select a;
set a = 10;
select a;
end;

call sample();

select customernumber, creditlimit
from customers;

delimiter $
create procedure getcredit(custid decimal(10))
begin
declare creditlim decimal(10,2) default 0.0;
select creditlimit
into creditlim
from customers
where customernumber = custid;
select creditlim;
end;

call getcredit(112);


/*Create a stored procedure to take two numbers
as the input and return the result of their sum*/

delimiter $
create procedure getsum
	(in a int, in b int, out sum int)
begin
	set sum = a + b;
end;

call getsum(12,78, @result);
select @result;

/*Create a stored procedure to take two numbers
as the input and return the result of their sum and
product*/

delimiter $
create procedure getsumproduct
	(in a int, in b int, out sum int, out product int)
begin
	set sum = a + b;
    set product = a * b;
end;

call getsumproduct(12,78, @result1, @result2);
select @result1, @result2;

delimiter $
create procedure ifelsedemo(num int)
begin
if num > 0 then
	select 'positive';
end if;
end;

call ifelsedemo(3);

drop procedure ifelsedemo;

delimiter $
create procedure ifelsedemo(num int)
begin
if num > 0 then
	select 'positive';
else
	select 'negative';
end if;
end;

call ifelsedemo(0);

drop procedure ifelsedemo;

delimiter $
create procedure ifelsedemo(num int)
begin
if num > 0 then
	select 'positive';
elseif num < 0 then
	select 'negative';
else
	select 'zero';
end if;
end;

call ifelsedemo(0);

/*Create a stored procedure to get the customer grade
based on the credit limit of the customer
Range of the credit limit		Grade
0-10000							Silver
10000-50000						Gold
50000-100000					Diamond
>100000							Platinum*/

delimiter $
create procedure getcustomergrade(custid decimal(10), 
								out grade varchar(20))
begin
declare creditlim decimal(10,2);
select creditlimit
into creditlim
from customers
where customernumber = custid;
if creditlim > 100000 then
	set grade = 'platinum';
elseif creditlim between 50000 and 100000 then
	set grade = 'diamond';
elseif creditlim between 10000 and 50000 then
	set grade = 'gold';
else
	set grade = 'silver';
end if;
end;

call getcustomergrade(173,@result);
select @result;