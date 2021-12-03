
--------------Introductory Problems--------------------------------------------

--1. Which shippers do we have?
select * 
from dbo.Shippers

--2. Certain fields from Categories
select * 
from dbo.Categories

--3. Sales Representatives
select 
	firstname,
	LastName,
	HireDate 
from dbo.Employees 
where Title='sales representative'

--4. Sales Representatives in the United States
select 
	firstname,
	LastName,HireDate 
from dbo.Employees 
where Title='sales representative' and country ='USA'

--5. Orders placed by specific EmployeeID
select 
	EmployeeID,
	orderid,
	orderdate 
from dbo.Orders 
where EmployeeID=5

--6. Suppliers and ContactTitles
select 
	SupplierID, 
	ContactName,
	ContactTitle 
from dbo.Suppliers 
where ContactTitle <> 'marketing manager'

--7. Products with “queso” in ProductName
select 
	productid,
	productname
from dbo.Products
where productname like '%queso%'

--8. Orders shipping to France or Belgium
select 
	orderid,
	customerid,
	ShipCountry
from dbo.orders
where ShipCountry in ('france','belgium')

--9. Orders shipping to any country in Latin America
select 
	orderid,
	customerid,
	ShipCountry
from dbo.orders
where ShipCountry in ('brazil','mexico','venezuela','argentina')

--10. Employees, in order of age
select FirstName, LastName, Title,BirthDate
from Employees order by BirthDate asc

--11. Showing only the Date with a DateTime field in above query
select 
	FirstName, 
	LastName, 
	Title,
	cast(BirthDate as date) as DateOnlyBirthDate
from Employees order by BirthDate asc

--12. Employees full name
select firstname + ' ' + lastname as fullname from Employees
select CONCAT_WS(' ',firstname,lastname) as fullname from employees

--13. OrderDetails amount per line item
select 
	OrderID,
	ProductID, 
	UnitPrice, 
	Quantity,
	UnitPrice*Quantity as TotalPrice
from OrderDetails
Order by OrderID,ProductID

--14. How many customers?
select count(distinct customerid) as TotalCustomers from Customers

--15. When was the first order?
select top 1 OrderDate as FirstOrder from orders order by OrderDate
select min(OrderDate) as FirstOrder from orders

--16. Countries where there are customers
select distinct country from customers

--17. Contact titles for customers
select 
	ContactTitle,
	count(contacttitle) as TotalContactTitle
from Customers
group by ContactTitle
order by TotalContactTitle desc

--18. Products with associated supplier names
select 
	p.ProductID,
	p.productname,
	s.CompanyName
from dbo.Products p
left join dbo.Suppliers s
	on p.SupplierID=s.SupplierID

--19. Orders and the Shipper that was used
select 
	o.OrderID,
	cast(o.orderdate as date) as OrderDate,
	s.CompanyName
from dbo.Orders o
left join dbo.Shippers s
	on o.ShipVia=s.ShipperId
where o.orderid<10300

