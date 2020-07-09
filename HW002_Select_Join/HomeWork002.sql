/*
1. ��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal"
*/
select *
  from Warehouse.StockItems
 where StockItemName like '%urgent%' 
    or StockItemName like 'Animal%' 


/*
2. ����������� (Suppliers), � ������� �� ���� ������� �� ������ ������ (PurchaseOrders). ������� ����� JOIN, � ����������� ������� ������� �� �����.
*/
select s.* 
  from Purchasing.Suppliers s
  left join Purchasing.PurchaseOrders po
    on po.SupplierID = s.SupplierID
 where po.SupplierID is null


/*
3. ������ (Orders) � ����� ������ ����� 100$ ���� ����������� ������ ������ ����� 20 ���� � �������������� ����� ������������ ����� ������ (PickingCompletedWhen).
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

 --�������� ������� ����� ������� � ������������ ��������, ��������� ������ 1000 � ��������� ��������� 100 �������.
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
4. ������ ����������� (Purchasing.Suppliers), ������� ���� ��������� � ������ 2014 ���� � ��������� Air Freight ��� Refrigerated Air Freight (DeliveryMethodName).
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
5. ������ ��������� ������ (�� ����) � ������ ������� � ������ ����������, ������� ������� ����� (SalespersonPersonID).
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
6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g. ��� ������ �������� � Warehouse.StockItems.
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