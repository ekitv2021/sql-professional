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

/*while loop*/
 
use salesdata;
 
drop procedure loopexample1;
 
delimiter $
create procedure loopexample1(lastvalue int)
begin
declare i int default 1;
declare str varchar(100);
set str = ''; /*string is empty initially*/
while i <= lastvalue do /*pre-test*/
	set str = concat(str, i, ' ');
    set i = i + 1;
end while;
select str;
end $

call loopexample1(30);

delimiter //
create procedure loopexample2(lastvalue int)
begin 
declare i int default 1;
declare str varchar(100);
set str = ''; /*string is empty initially*/
repeat
	set str = concat(str, i, ' ');
    set i = i + 1;
until i > lastvalue /*post-test*/
end repeat;
select str;
end//

call loopexample2(25);

/*Cursors*/

/*Write a stored procedure to fill the employees_name table
with the data from the employees table. The name should be 
concatenated and then saved in the employees_name table*/

create table employees_name(
	empid int,
    empname varchar(50));
    
desc employees_name;

delimiter $
create procedure employee_name_cursor()
begin
/*declare the variable as the column values
will be fetched in them by the fetch command*/
declare done boolean default false;
declare empid int;
declare fname varchar(20);
declare lname varchar(20);

/*declare the cursor, make sure that the select
query only contain the columns which we need*/
declare cur cursor for
select employeenumber, firstname, lastname
from employees;

/*declare the exception that is raised when there
are no more rows to be fetched*/
declare continue handler for not found set done=true;

/*open the cursor, get the table from the database 
into cursor memory*/
open cur;

/*fetch the rows and put the values of each row
in the variable*/
/*read_loop is the label for the loop so that we 
can exit using it*/
while not done do
fetch cur into empid, fname, lname;
insert into employees_name values(empid, concat(fname,' ',lname));
end while;

/*close the cursor once the task is completed*/
close cur;
end;

call employee_name_cursor();

drop procedure employee_name_cursor;

use salesdata;

select * from employees_name;