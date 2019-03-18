-- 1. Посчитать среднюю цену товара, общую сумму продажи по месяцам
SELECT YEAR(t.TransactionDate)             AS [Year]
      ,MONTH(t.TransactionDate)            AS [Month]
	  ,AVG(il.UnitPrice)                   AS AvarageUnitPrice
      ,SUM(t.TransactionAmount)            AS TotalTransactionAmount
FROM  [Sales].[CustomerTransactions] t
	  INNER JOIN [Sales].[InvoiceLines] il ON il.InvoiceID = t.InvoiceID
GROUP BY YEAR(t.TransactionDate), MONTH(t.TransactionDate)
ORDER BY [Year], [Month]


-- 2.Отобразить все месяцы, где общая сумма продаж превысила 10 000 
SELECT YEAR(t.TransactionDate)             AS [Year]
      ,MONTH(t.TransactionDate)            AS [Month]
	  ,AVG(il.UnitPrice)                   AS AvarageUnitPrice
      ,SUM(t.TransactionAmount)            AS TotalTransactionAmount
FROM  [Sales].[CustomerTransactions] t
	  INNER JOIN [Sales].[InvoiceLines] il ON il.InvoiceID = t.InvoiceID
GROUP BY YEAR(t.TransactionDate), MONTH(t.TransactionDate)
HAVING SUM(t.TransactionAmount) > 10000 
ORDER BY [Year], [Month]

/* 3.Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, 
по товарам, продажи которых менее 50 ед в месяц. */
SELECT YEAR(t.TransactionDate)             AS [Year]
      ,MONTH(t.TransactionDate)            AS [Month]
	  ,AVG(il.UnitPrice)                   AS AvarageUnitPrice
      ,SUM(t.TransactionAmount)            AS TotalTransactionAmount
	  ,SUM(il.Quantity)                    AS Quantity
	  ,MIN(t.TransactionDate)              AS FirstSaleDate
	  ,StockItemID
FROM  [Sales].[CustomerTransactions] t
	  INNER JOIN [Sales].[InvoiceLines] il ON il.InvoiceID = t.InvoiceID
GROUP BY YEAR(t.TransactionDate), MONTH(t.TransactionDate), StockItemID
HAVING SUM(il.Quantity)  < 50
ORDER BY [Year], [Month]
