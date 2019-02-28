-- Расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца) через windows function
-- set statistics time on показывает, что первый запрос выполняется быстрее
/*SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 63 ms, elapsed time = 138 ms.

(31347 rows affected)

(1 row affected)

 SQL Server Execution Times:
   CPU time = 672 ms,  elapsed time = 1783 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms. */
SELECT i.InvoiceID
	  ,c.CustomerName
	  ,i.InvoiceDate
	  ,t.TransactionAmount
	  ,SUM(t.TransactionAmount) OVER (ORDER BY DATEADD(mm, DATEDIFF(month, 0, i.InvoiceDate), 0)) AS CumulativeTotal
FROM   [Sales].[Invoices] i
	   INNER JOIN [Sales].[CustomerTransactions] t ON i.InvoiceID = t.InvoiceID
	   INNER JOIN [Sales].[Customers] c ON c.CustomerID = i.CustomerID
WHERE  i.InvoiceDate > '2015-01-01'
ORDER BY i.InvoiceDate

-- Расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца) без windows function
/*SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 171 ms, elapsed time = 192 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(31347 rows affected)

(1 row affected)

 SQL Server Execution Times:
   CPU time = 719 ms,  elapsed time = 1827 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.*/
DECLARE @CutOfDate DATE = '2015-01-01'

;WITH  cte AS
(
	SELECT 
	       DATEADD(mm, DATEDIFF(month, 0, i.InvoiceDate), 0)   AS InvoiceDateByMonth
		  ,SUM(t.TransactionAmount)                          AS TransactionAmountSumByMonth
	FROM   [Sales].[Invoices] i
		   INNER JOIN [Sales].[CustomerTransactions] t ON i.InvoiceID = t.InvoiceID
	WHERE  i.InvoiceDate > @CutOfDate
	GROUP BY DATEADD(mm, DATEDIFF(month, 0, i.InvoiceDate), 0)
), CumSum AS
(
	SELECT c1.InvoiceDateByMonth
		  ,SUM(c2.TransactionAmountSumByMonth)              AS CumTotalSum
	 FROM  cte c1
		   INNER JOIN cte c2 ON c1.InvoiceDateByMonth >= c2.InvoiceDateByMonth 
		   GROUP BY c1.InvoiceDateByMonth, c1.TransactionAmountSumByMonth
)
SELECT i.InvoiceID
	  ,c.CustomerName
	  ,i.InvoiceDate
	  ,t.TransactionAmount
	  ,cs.CumTotalSum
FROM   CumSum cs
       INNER JOIN [Sales].[Invoices] i  ON DATEADD(dd, - DATEPART(dd,InvoiceDate) + 1,InvoiceDate ) = InvoiceDateByMonth
	   INNER JOIN [Sales].[Customers] c ON c.CustomerID = i.CustomerID
       INNER JOIN [Sales].[CustomerTransactions] t ON i.InvoiceID = t.InvoiceID
	WHERE  i.InvoiceDate > @CutOfDate
ORDER BY i.InvoiceID

CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO