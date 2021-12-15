------- Advance Problems-------------------------

--32. High-value customers
;with cte as 
(
select 
	od.orderid,
	sum(od.unitprice*od.quantity) as totalvalue,
	count(od.orderid) ordercount
from dbo.OrderDetails od
group by od.orderid
)

select 
	o.OrderID,
	o.CustomerID,
	cte.totalvalue
from dbo.Orders o
inner join cte 
	on o.OrderID=cte.OrderID 
		and totalvalue >= 10000
		and ordercount>=1
where year(o.OrderDate) = 2016

--33. High-value customers - total orders
select 
	o.CustomerID,
	c.CompanyName,
	sum(od.Quantity*od.UnitPrice) as totalvalue,
	count(*) as totalorders
from dbo.orderdetails od
left join dbo.orders o
	on od.orderid=o.OrderID
left join dbo.customers c
	on o.CustomerID=c.CustomerID
where year(o.OrderDate)=2016
group by o.CustomerID,c.CompanyName
having sum(od.Quantity*od.UnitPrice)>=15000

--34. High-value customers - with discount
select 
	o.CustomerID,
	c.CompanyName,
	sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as totalvalue
from dbo.orderdetails od
left join dbo.orders o
	on od.orderid=o.OrderID
left join dbo.customers c
	on o.CustomerID=c.CustomerID
where year(o.OrderDate)=2016
group by o.CustomerID,c.CompanyName
having sum(od.Quantity*od.UnitPrice*(1-od.Discount))>=10000


--35. Month-end orders

select
	EmployeeID,
	orderid,
	OrderDate
from orders
where orderdate=EOMONTH(orderdate)
order by EmployeeID,OrderID

--36. Orders with many line items
select 
	top 10
	orderid,
	count(distinct productid) TotalOrderDetails
from OrderDetails
group by orderid
order by TotalOrderDetails desc

--37. Orders - random assortment

select 
	top 2 percent
	orderid
from Orders
order by newid()

--38. Orders - accidental double-entry

select 
	orderid
from OrderDetails
where Quantity>=60
group by orderid,Quantity
having count(*)>1

--39 Orders - accidental double-entry details

select * from dbo.OrderDetails
where orderid in 
(select 
	orderid
from OrderDetails
where Quantity>=60
group by orderid,Quantity
having count(*)>1)

--40. Orders - accidental double-entry details, derived table

Select
 distinct
 OrderDetails.OrderID
 ,ProductID
 ,UnitPrice
 ,Quantity
 ,Discount
From OrderDetails 
 Join (
 Select
 OrderID 
 From OrderDetails
 Where Quantity >= 60
 Group By OrderID, Quantity
 Having Count(*) > 1
 ) PotentialProblemOrders
 on PotentialProblemOrders.OrderID = OrderDetails.OrderID
Order by OrderID, ProductID

--41. Late orders

select 
	Orderid,
	OrderDate,
	RequiredDate,
	ShippedDate
from Orders
where ShippedDate>RequiredDate
order by orderid

--42. Late orders - which employees?

select 
	o.EmployeeID,
	e.LastName,
	TotalLateOrders=count(o.employeeid)
from dbo.Orders o
left join dbo.Employees e
	on o.EmployeeID=e.EmployeeID
where o.ShippedDate>o.RequiredDate
group by o.EmployeeID,e.LastName

--43. Late orders vs. total orders
;with lateorders as 
(
select 
	o.EmployeeID,
	TotalLateOrders=count(o.employeeid)
from dbo.Orders o
where o.ShippedDate>o.RequiredDate
group by o.EmployeeID
),totalorders as 
(
select 
	o.EmployeeID,
	e.LastName,
	TotalOrders=count(o.employeeid)
from dbo.Orders o
left join dbo.Employees e
	on o.EmployeeID=e.EmployeeID
group by o.EmployeeID,e.LastName
)
	select 
	t.EmployeeID,
	t.LastName,
	t.TotalOrders,
	TotalLateOrders=l.TotalLateOrders
	from totalorders t
	inner join lateorders l
	on t.EmployeeID=l.EmployeeID

--44. Late orders vs. total orders - missing employee

;with lateorders as 
(
select 
	o.EmployeeID,
	TotalLateOrders=count(o.employeeid)
from dbo.Orders o
where o.ShippedDate>o.RequiredDate
group by o.EmployeeID
),totalorders as 
(
select 
	o.EmployeeID,
	e.LastName,
	TotalOrders=count(o.employeeid)
from dbo.Orders o
left join dbo.Employees e
	on o.EmployeeID=e.EmployeeID
group by o.EmployeeID,e.LastName
)
	select 
	t.EmployeeID,
	t.LastName,
	t.TotalOrders,
	TotalLateOrders=l.TotalLateOrders
	from totalorders t
	left join lateorders l
	on t.EmployeeID=l.EmployeeID

--45. Late orders vs. total orders - fix null

;with lateorders as 
(
select 
	o.EmployeeID,
	TotalLateOrders=count(o.employeeid)
from dbo.Orders o
where o.ShippedDate>o.RequiredDate
group by o.EmployeeID
),totalorders as 
(
select 
	o.EmployeeID,
	e.LastName,
	TotalOrders=count(o.employeeid)
from dbo.Orders o
left join dbo.Employees e
	on o.EmployeeID=e.EmployeeID
group by o.EmployeeID,e.LastName
)
	select 
	t.EmployeeID,
	t.LastName,
	t.TotalOrders,
	TotalLateOrders=isnull(l.TotalLateOrders,0)
	from totalorders t
	left join lateorders l
	on t.EmployeeID=l.EmployeeID

--46. Late orders vs. total orders - percentage

;with lateorders as 
(
select 
	o.EmployeeID,
	TotalLateOrders=count(o.employeeid)
from dbo.Orders o
where o.ShippedDate>o.RequiredDate
group by o.EmployeeID
),totalorders as 
(
select 
	o.EmployeeID,
	e.LastName,
	TotalOrders=count(o.employeeid)
from dbo.Orders o
left join dbo.Employees e
	on o.EmployeeID=e.EmployeeID
group by o.EmployeeID,e.LastName
)
	select 
	t.EmployeeID,
	t.LastName,
	t.TotalOrders,
	TotalLateOrders=isnull(l.TotalLateOrders,0),
	PercentLateOrders=isnull(l.TotalLateOrders,0)*1.0000/t.TotalOrders
	from totalorders t
	left join lateorders l
	on t.EmployeeID=l.EmployeeID

--47. Late orders vs. total orders - fix decimal

;with lateorders as 
(
select 
	o.EmployeeID,
	TotalLateOrders=count(o.employeeid)
from dbo.Orders o
where o.ShippedDate>o.RequiredDate
group by o.EmployeeID
),totalorders as 
(
select 
	o.EmployeeID,
	e.LastName,
	TotalOrders=count(o.employeeid)
from dbo.Orders o
left join dbo.Employees e
	on o.EmployeeID=e.EmployeeID
group by o.EmployeeID,e.LastName
)
	select 
	t.EmployeeID,
	t.LastName,
	t.TotalOrders,
	TotalLateOrders=isnull(l.TotalLateOrders,0),
	PercentLateOrders=convert(decimal(10,2),isnull(l.TotalLateOrders,0)*1.0000/t.TotalOrders,2)
	from totalorders t
	left join lateorders l
	on t.EmployeeID=l.EmployeeID

--48. Customer grouping
;with totalvalue as
(
select 
	od.OrderID,
	sum(od.Quantity*od.UnitPrice) as TotalOrderValue
from dbo.orderdetails od
group by od.OrderID
),cte_final as
(
select 
	o.CustomerID,
	c.CompanyName,
	sum(tv.totalordervalue) as totalvalue
from Orders o
left join dbo.Customers c on o.CustomerID = c.CustomerID
left join totalvalue tv on o.orderid=tv.OrderID
where year(o.OrderDate) <> 2016
group by o.CustomerID,c.CompanyName
)
	select 
		*,
		customergroup=
			case when totalvalue <=1000 then 'Low'
				when totalvalue between 1001 and 5000 then 'Medium'
				else 'High' end 

	from cte_final

--49. Customer grouping - fix null
