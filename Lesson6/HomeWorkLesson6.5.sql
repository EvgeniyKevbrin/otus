-- Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
-- В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки
;WITH cte AS 
(
	SELECT i.CustomerId
		  ,i.InvoiceID
		  ,TransactionAmount
		  ,i.InvoiceDate
		  ,ROW_NUMBER() OVER (PARTITION BY i.CustomerId ORDER BY TransactionAmount DESC) R_N
	FROM   [Sales].[Invoices] i
		   INNER JOIN [Sales].[CustomerTransactions] t ON i.InvoiceID = t.InvoiceID
)
SELECT cte.CustomerId
	  ,cte.InvoiceID
	  ,cte.TransactionAmount
	  ,cte.InvoiceDate
	  ,c.CustomerName
FROM   cte
	   INNER JOIN [Sales].[Customers] c ON c.CustomerID = cte.CustomerID
WHERE  R_N <= 2