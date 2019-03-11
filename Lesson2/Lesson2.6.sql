-- Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g

SELECT il.InvoiceID
	  ,CustomerName
	  ,PhoneNumber
FROM   [Warehouse].[StockItems] si
INNER JOIN [Sales].[InvoiceLines] il ON il.StockItemID = si.StockItemID
INNER JOIN [Sales].[Invoices] i ON i.InvoiceID = il.InvoiceID
INNER JOIN [Sales].[Customers] c ON c.CustomerID = i.CustomerID
WHERE  StockItemName = 'Chocolate frogs 250g'

