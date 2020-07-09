/*
1. ¬се товары, в названии которых есть "urgent" или название начинаетс€ с "Animal"
*/
select *
  from Warehouse.StockItems
 where StockItemName like '%urgent%' 
    or StockItemName like 'Animal%' 


/*
2. ѕоставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders). —делать через JOIN, с подзапросом задание прин€то не будет.
*/
select s.* 
  from Purchasing.Suppliers s
  left join Purchasing.PurchaseOrders po
    on po.SupplierID = s.SupplierID
 where po.SupplierID is null


/*
3. «аказы (Orders) с ценой товара более 100$ либо количеством единиц товара более 20 штук и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
*/
select o.OrderId,
       convert(varchar(10), o.OrderDate, 104) as OrderDate,
	   datename(month, o.OrderDate) as [MonthName],
	   datepart(q, o.OrderDate) as QNumber,
	   case 
	     when datepart(m, o.OrderDate) <= 4
	     then 1
		 when datepart(m, o.OrderDate) <= 8
		 then 2
		 when datepart(m, o.OrderDate) <= 12
		 then 3 
		 else 0
		end as YearPart, 
	   c.CustomerName
  from Sales.Orders o
  join Sales.OrderLines ol
    on ol.OrderID = o.OrderID
   and (ol.UnitPrice > 100 or ol.Quantity > 20)
   and ol.PickingCompletedWhen is not null
  join Sales.Customers c
    on c.CustomerID = o.CustomerID
 order by QNumber, YearPart, OrderDate

 --ƒобавьте вариант этого запроса с постраничной выборкой, пропустив первую 1000 и отобразив следующие 100 записей.
 select o.OrderId,
        convert(varchar(10), o.OrderDate, 104) as OrderDate,
	    datename(month, o.OrderDate) as [MonthName],
	    datepart(q, o.OrderDate) as QNumber,
	    case 
	      when datepart(m, o.OrderDate) <= 4
	      then 1
	 	  when datepart(m, o.OrderDate) <= 8
 		  then 2
		  when datepart(m, o.OrderDate) <= 12
		  then 3 
		  else 0
		 end as YearPart, 
	    c.CustomerName
  from Sales.Orders o
  join Sales.OrderLines ol
    on ol.OrderID = o.OrderID
   and (ol.UnitPrice > 100 or ol.Quantity > 20)
   and ol.PickingCompletedWhen is not null
  join Sales.Customers c
    on c.CustomerID = o.CustomerID
 order by QNumber, YearPart, OrderDate
 offset 1000 rows
 fetch next 100 rows only


/*
4. «аказы поставщикам (Purchasing.Suppliers), которые были исполнены в €нваре 2014 года с доставкой Air Freight или Refrigerated Air Freight (DeliveryMethodName).
*/
select d.DeliveryMethodName,
       o.OrderDate,
	   s.SupplierName,
	   p.FullName
  from Purchasing.Suppliers s
  join Purchasing.PurchaseOrders o
    on o.SupplierID = s.SupplierID
   and o.OrderDate between '20140101' and '20140201'
  join [Application].DeliveryMethods d
    on d.DeliveryMethodID = o.DeliveryMethodID
   and d.DeliveryMethodName in ('Air Freight', 'Refrigerated Air Freight')
  join [Application].People p
    on p.PersonID = o.ContactPersonID


/*
5. ƒес€ть последних продаж (по дате) с именем клиента и именем сотрудника, который оформил заказ (SalespersonPersonID).
*/
select top 10 o.OrderDate,
              c.CustomerName,
	          p.FullName
  from Sales.Orders o
  join Sales.Customers c
    on c.CustomerID = o.CustomerID
  join [Application].People p
    on p.PersonID = o.SalespersonPersonID
 order by o.OrderDate desc


/*
6. ¬се ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g. »м€ товара смотреть в Warehouse.StockItems.
*/
 select distinct c.CustomerID,
                 c.CustomerName,
		         c.PhoneNumber
   from Warehouse.StockItems si
   join Sales.OrderLines ol
     on ol.StockItemID = si.StockItemID
   join Sales.Orders o
     on o.OrderID = ol.OrderID
   join Sales.Customers c
     on c.CustomerID = o.CustomerID
  where si.StockItemName = 'Chocolate frogs 250g'