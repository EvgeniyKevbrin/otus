-- 10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ.

SELECT TOP(10) InvoiceID
			  ,InvoiceDate
			  ,CustomerName
			  ,FullName AS ContactName
FROM   [Sales].[Invoices] i
INNER JOIN [Sales].[Customers] c ON c.CustomerID = i.CustomerID
INNER JOIN [Application].[People] p ON p.PersonID = i.ContactPersonID
ORDER  BY i.InvoiceDate DESC
