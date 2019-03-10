﻿--По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
--В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки

SELECT DISTINCT PersonID
	,RIGHT(FullName, CHARINDEX(' ',REVERSE (FullName))) AS LastName
	,LAST_VALUE(c.CustomerID) OVER (PARTITION BY FullName ORDER BY i.InvoiceDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS CustomerId
	,LAST_VALUE(CustomerName) OVER (PARTITION BY FullName ORDER BY i.InvoiceDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS CustomerName
	,LAST_VALUE(i.InvoiceDate) OVER (PARTITION BY FullName ORDER BY i.InvoiceDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS CustomerName
	,LAST_VALUE(TransactionAmount) OVER (PARTITION BY FullName ORDER BY i.InvoiceDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS TransactionAmount
FROM [Application].[People] p
	INNER JOIN [Sales].[Invoices] i ON i.SalespersonPersonID = p.PersonID
	INNER JOIN [Sales].[CustomerTransactions] t ON i.InvoiceID = t.InvoiceID
	INNER JOIN [Sales].[Customers] c ON c.CustomerID = t.CustomerID
ORDER BY PersonID