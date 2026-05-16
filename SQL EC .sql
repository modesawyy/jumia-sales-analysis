USE ecommercedb;
-- ________________________________





-- 1-
select * from products
where price between 50 and 200
order by price desc;

-- 2-
select concat(c.FirstName, " " ,c.LastName) as fullname , c.CustomerID , a.Country 
from customers c 
inner join address a on c.addressID=a.addressID
inner join calendar ca on c.RegistrationDateID = ca.DateID
where ca.year = 2024 and country = "USA" ; 

-- 3-
select * from products;

UPDATE products p 
inner join categories c 
on p.categoryID = c.categoryID
set p.price = p.price * 1.10
where c.CategoryName= "Electronics";


-- 4- 
Delete from orders
where TotalAmount = 0;

-- 5-
create view Top_Customers_2024 as
select c.customerID , concat(c.FirstName, " " ,c.LastName) as fullname , count(o.OrderID) as Transactions , sum(o.TotalAmount) as sales 
from customers c
inner join orders o on c.customerID = o.customerID
inner join calendar ca on o.orderDateID = ca.DateID
where year = 2024 
group by c.customerID,fullname
having sales > 5000 
order by sales desc;


SELECT * FROM Top_Customers_2024;



-- 6-
select productname,price from products
where price > (
select avg(price) from products );



-- 7-
select c.customerID ,concat(c.FirstName, " " ,c.LastName) as fullname , p.productname , p.price
from customers c
inner join orders o on c.customerID=o.customerID
inner join orderdetails od on o.orderID=od.orderID
inner join products p on od.productID=p.productID
where price = (select max(price) from products );

-- 8- 
DELIMITER // 

create procedure GetOrdersByCustomer (IN cust_id int )
begin 
select * from orders
where CustomerID = cust_id;
End // 

DELIMITER ;

call GetOrdersByCustomer(10);



-- 9-
with productcategory as (
select p.productID , p.ProductName , ca.categoryName ,ca.categoryID, sum(o.Totalamount) as sales,
Row_number() over ( partition by ca.categoryID order by sum(o.Totalamount) desc ) as ranks
from categories ca 
inner join products p on ca.categoryID=p.categoryID
inner join orderdetails od on p.productID=od.productID
inner join orders o on od.orderID=o.orderID
group by p.productID , p.ProductName , ca.categoryName ,ca.categoryID
)
select * from productcategory 
where ranks<=3
order by ProductName , ranks;
 
 
-- 10- 
select ca.month , sum(o.totalamount) as Totalsales 
from orders o 
inner join calendar ca on o.OrderDateID=ca.DateID
where ca.year = 2024
group by ca.month 
order by ca.month ;

-- 11- 
select * from calendar;


select o.* , ca.DAYOFWEEK
from orders o
inner join calendar ca on o.orderdateID=ca.DateID
where ca.DAYOFWEEK IN ('Saturday','Sunday');



-- 12- 
select 
avg (datediff(ca2.date,ca1.date)) as dilverytime 
from orders o 
inner join calendar ca1 on o.orderdateID=ca1.DateID
inner join calendar ca2 on o.deliveryDateID=ca2.DateID;


-- 13- 
select ca.categoryName , sum(od.quantity) as TotalQuantitySold 
from categories ca 
inner join products p on ca.categoryID=p.categoryID
inner join orderdetails od on p.productID=od.productID
group by ca.categoryName
order by TotalQuantitySold desc
limit 3 ;


-- 14- 
select o.CustomerID , count(o.OrderID) as Transactions 
from orders o 
inner join calendar ca on o.OrderdateID=ca.DateID
where ca.date between 
date_sub( 
          (select max(ca.date)
from orders o 
inner join calendar ca on o.orderdateid=ca.dateid) , interval 90 day
) and
(select max(ca.Date)
from orders o 
inner join calendar ca on o.orderDateID=ca.DateID)
group by o.CustomerID
order by Transactions desc
limit 5;


-- 15- 
select c.customerID , concat(c.FirstName, " " ,c.LastName) as fullname , sum(o.TotalAmount) as sales ,
rank() over( order by sum(o.TotalAmount)desc ) as ranks 
from customers c 
inner join orders o on c.customerID=o.customerID
inner join calendar ca on o.orderdateID=ca.DateID
where ca.year = 2024 
group by c.customerID , fullname
order by ranks;














