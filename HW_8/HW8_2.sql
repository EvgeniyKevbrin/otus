/*
	2. Для всех клиентов с именем, в котором есть Tailspin Toys
	вывести все адреса, которые есть в таблице, в одной колонке

	Пример результатов
	CustomerName	AddressLine
	Tailspin Toys (Head Office)	Shop 38
	Tailspin Toys (Head Office)	1877 Mittal Road
	Tailspin Toys (Head Office)	PO Box 8975
	Tailspin Toys (Head Office)	Ribeiroville
*/



SELECT CustomerName
	  ,CustomerAddress
	  ,AddressInfo
FROM  (
	   SELECT CustomerName
			 ,DeliveryAddressLine1
			 ,DeliveryAddressLine2
			 ,PostalAddressLine1
			 ,PostalAddressLine2
	   FROM   [Sales].[Customers] c
	   	      INNER JOIN [Sales].[Invoices] i ON  i.CustomerID = c.CustomerID
	   WHERE  CustomerName LIKE 'Tailspin Toys%') a
UNPIVOT(
		CustomerAddress FOR AddressInfo IN ( DeliveryAddressLine1
											,DeliveryAddressLine2
										    ,PostalAddressLine1
											,PostalAddressLine2)
		)upv


