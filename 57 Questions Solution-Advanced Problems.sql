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
