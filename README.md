# NorthWind_57_SQL_Question

## A. Introductory Problems

> **1. Which shippers do we have?**
```sql
select * 
from dbo.Shippers
```
> **2. Certain fields from Categories.**
```sql
select * 
from dbo.Categories
```

> **3. Sales Representatives**
```sql
select 
	firstname,
	LastName,
	HireDate 
from dbo.Employees 
where Title='sales representative'
```

> **4. Sales Representatives in the United States**
```sql
select 
	firstname,
	LastName,HireDate 
from dbo.Employees 
where Title='sales representative' and country ='USA'
```

> **5. Orders placed by specific EmployeeID**
```sql
select 
	EmployeeID,
	orderid,
	orderdate 
from dbo.Orders 
where EmployeeID=5
```

> **6. Suppliers and ContactTitles**
```sql
select 
	SupplierID, 
	ContactName,
	ContactTitle 
from dbo.Suppliers 
where ContactTitle <> 'marketing manager'
```

> **7. Products with “queso” in ProductName**
```sql
select 
	productid,
	productname
from dbo.Products
where productname like '%queso%'
```

> **8. Orders shipping to France or Belgium**
```sql
select 
	orderid,
	customerid,
	ShipCountry
from dbo.orders
where ShipCountry in ('france','belgium')
```

> **9. Orders shipping to any country in Latin America**
```sql
select 
	orderid,
	customerid,
	ShipCountry
from dbo.orders
where ShipCountry in ('brazil','mexico','venezuela','argentina')
```

> **10. Employees, in order of age**
```sql
select FirstName, LastName, Title,BirthDate
from Employees order by BirthDate asc
```

> **11. Showing only the Date with a DateTime field in above query**
```sql
select 
	FirstName, 
	LastName, 
	Title,
	cast(BirthDate as date) as DateOnlyBirthDate
from Employees order by BirthDate asc
```

> **12. Employees full name**
```sql
select firstname + ' ' + lastname as fullname from Employees
select CONCAT_WS(' ',firstname,lastname) as fullname from employees
```

> **13. OrderDetails amount per line item**
```sql
select 
	OrderID,
	ProductID, 
	UnitPrice, 
	Quantity,
	UnitPrice*Quantity as TotalPrice
from OrderDetails
Order by OrderID,ProductID
```

> **14. How many customers?**
```sql
select count(distinct customerid) as TotalCustomers from Customers
```

> **15. When was the first order?**
```sql
select top 1 OrderDate as FirstOrder from orders order by OrderDate
select min(OrderDate) as FirstOrder from orders
```

> **16. Countries where there are customers**
```sql
select distinct country from customers
```

> **17. Contact titles for customers**
```sql
select 
	ContactTitle,
	count(contacttitle) as TotalContactTitle
from Customers
group by ContactTitle
order by TotalContactTitle desc
```

> **18. Products with associated supplier names**
```sql
select 
	p.ProductID,
	p.productname,
	s.CompanyName
from dbo.Products p
left join dbo.Suppliers s
	on p.SupplierID=s.SupplierID
```

> **19. Orders and the Shipper that was used**
```sql
select 
	o.OrderID,
	cast(o.orderdate as date) as OrderDate,
	s.CompanyName
from dbo.Orders o
left join dbo.Shippers s
	on o.ShipVia=s.ShipperId
where o.orderid<10300
```

## B. Intermediate Problems

> **20. Categories, and the total products in each category.**
```sql
select 
	c.categoryname,
	count(p.productname) as TotalProducts
from Products p
inner join Categories c
on p.CategoryID=c.CategoryID
group by c.CategoryName
order by TotalProducts desc
```
> **21. Total customers per country/city**
```sql
select 
	country,
	city,
	count(city) as TotalCustomer
from dbo.Customers
group by country,city
```

> **22. Products that need reordering
```sql
select
	productid,
	productname,
	UnitsInStock,
	ReorderLevel
from dbo.Products
where ReorderLevel>UnitsInStock
```

> **23. Products that need reordering, continued
```sql
select
	productid,
	productname,
	UnitsInStock,
	UnitsOnOrder,
	ReorderLevel,
	Discontinued
from dbo.Products
where UnitsInStock + UnitsOnOrder <= ReorderLevel
	and Discontinued=0
```

> **24. Customer list by region
```sql
with cte as
(
	select
		CustomerID,
		CompanyName,
		Region,
		case when region is null then 1 else 0 end as forsort
	from Customers
)
	select 
		CustomerID,
		CompanyName,
		Region from cte order by forsort,region,customerid
```

> **25. High freight charges
```sql
select 
	top 3
	ShipCountry,
	avg(Freight) as averagefreight
from dbo.Orders
group by ShipCountry
order by AverageFreight desc
```

> **26. High freight charges - 2015
```sql
select 
	top 3
	ShipCountry,
	avg(Freight) as averagefreight
from dbo.Orders
where year(OrderDate)=2015
group by ShipCountry
order by AverageFreight desc
```

> **28. High freight charges - last year
```sql
declare @max_date as date
set @max_date = (select cast(max(orderdate) as date) from orders)
select 
	top 3
	ShipCountry,
	avg(Freight) as averagefreight
from dbo.Orders
where cast(orderdate as date) between DATEADD(year,-1,@max_date) and @max_date
group by ShipCountry
order by AverageFreight desc
```

> **29. Inventory list 
```sql
select 
	o.EmployeeID,
	e.lastname,
	o.orderid,
	p.ProductName,
	od.quantity
from dbo.Orders o
inner join dbo.OrderDetails od
	on o.orderid = od.orderid
inner join dbo.customers c
	on o.CustomerID=c.CustomerID
inner join dbo.Employees e
	on o.EmployeeID=e.EmployeeID
inner join dbo.Products p
	on od.ProductID = p.ProductID
```

> **30. Customers with no orders
```sql
select 
	c.CustomerID as Customers_CustomerID,
	o.CustomerID as Orders_CustomerID
from dbo.Customers c
left join dbo.Orders o
	on c.CustomerID = o.CustomerID
where o.CustomerID is null
```

> **31. Customers with no orders for EmployeeID 4
```sql
select 
	Customerid
from dbo.customers 
where customerid not in (
			select 
			customerid 
			from dbo.orders 
			where EmployeeID = 4)
```
