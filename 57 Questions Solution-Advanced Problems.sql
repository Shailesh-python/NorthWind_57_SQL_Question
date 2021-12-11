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

