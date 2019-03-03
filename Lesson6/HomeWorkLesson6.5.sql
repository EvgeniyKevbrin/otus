-- Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
-- В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки
;WITH cte AS 
(
	SELECT c.CustomerId
		  ,c.CustomerName
		  ,i.InvoiceID
		  ,TransactionAmount
		  ,i.InvoiceDate
		  ,ROW_NUMBER() OVER (PARTITION BY c.CustomerName ORDER BY TransactionAmount DESC) R_N
	FROM   [Sales].[Invoices] i
		   INNER JOIN [Sales].[CustomerTransactions] t ON i.InvoiceID = t.InvoiceID
		   INNER JOIN [Sales].[Customers] c ON c.CustomerID = t.CustomerID
)
SELECT *
FROM   cte
WHERE  R_N <= 2