/*
	4. Перепишите ДЗ из оконных функций через CROSS APPLY 
	Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
	В результатах должно быть ид клиета, его название, ид товара, цена, дата покупк
*/

SELECT a.CustomerID
	  ,a.CustomerName
      ,b.InvoiceID
	  ,b.TransactionAmount
	  ,b.InvoiceDate
FROM  [Sales].[Customers] a
	  CROSS APPLY
				 (
				 	SELECT TOP (2) i.CustomerId
								  ,i.InvoiceID
								  ,TransactionAmount
								  ,i.InvoiceDate
					FROM   [Sales].[Invoices] i
						   INNER JOIN [Sales].[CustomerTransactions] t ON i.InvoiceID = t.InvoiceID
			        WHERE  i.CustomerID  = a.CustomerID	
					ORDER BY TransactionAmount DESC			    	 
				 ) b

