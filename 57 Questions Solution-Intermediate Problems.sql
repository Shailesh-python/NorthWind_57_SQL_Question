------Intermediate Problems---------------------------------

--20. Categories, and the total products in each category
select 
	c.categoryname,
	count(p.productname) as TotalProducts
from Products p
inner join Categories c
on p.CategoryID=c.CategoryID
group by c.CategoryName
order by TotalProducts desc

--21. Total customers per country/city
select 
	country,
	city,
	count(city) as TotalCustomer
from dbo.Customers
group by country,city

--22 Products that need reordering
select
	productid,
	productname,
	UnitsInStock,
	ReorderLevel
from dbo.Products
where ReorderLevel>UnitsInStock

--23. Products that need reordering, continued
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

--24. Customer list by region
;with cte as
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

--25. High freight charges
select 
	top 3
	ShipCountry,
	avg(Freight) as averagefreight
from dbo.Orders
group by ShipCountry
order by AverageFreight desc

--26. High freight charges - 2015
select 
	top 3
	ShipCountry,
	avg(Freight) as averagefreight
from dbo.Orders
where year(OrderDate)=2015
group by ShipCountry
order by AverageFreight desc


--28. High freight charges - last year
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

--29. Inventory list 
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


--30. Customers with no orders
 
select 
	c.CustomerID as Customers_CustomerID,
	o.CustomerID as Orders_CustomerID
from dbo.Customers c
left join dbo.Orders o
	on c.CustomerID = o.CustomerID
where o.CustomerID is null


--31. Customers with no orders for EmployeeID 4
select 
	c.CustomerID as Customers_CustomerID,
	o.CustomerID as Orders_CustomerID
from dbo.Customers c
left join dbo.Orders o
	on c.CustomerID = o.CustomerID
where o.CustomerID is null
	and o.EmployeeID<>4
