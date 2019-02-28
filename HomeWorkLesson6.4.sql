--По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
--В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки

SELECT FullName AS SalesPerson
      ,PersonID
      ,TransactionAmount
      ,c.CustomerName
	  ,i.InvoiceDate
	  ,LAST_VALUE(CustomerName) OVER (ORDER BY FullName) AS LastClientByCustomer
FROM   [Application].[People] p
	   INNER JOIN [Sales].[Invoices] i ON i.SalespersonPersonID = p.PersonID
	   INNER JOIN [Sales].[CustomerTransactions] t ON i.InvoiceID = t.InvoiceID
	   INNER JOIN [Sales].[Customers] c ON c.CustomerID = t.CustomerID
