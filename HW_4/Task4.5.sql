set statistics time on
/*Запрос выводит  InvoiceID, InvoiceDate, сотрудников которые являются продавцами,
  сумму продаж по InvoiceID, сумму продаж для тех OrderID которые равны в Sales.OrderLines
  и Sales.Orders */
SELECT Invoices.InvoiceID
      ,Invoices.InvoiceDate
	  ,(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID) AS SalesPersonName
	  ,SalesTotals.TotalSumm AS TotalSummByInvoice
	  ,(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines 
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
									FROM Sales.Orders
									WHERE Orders.PickingCompletedWhen IS NOT NULL	
										  AND Orders.OrderId = Invoices.OrderId)) AS TotalSummForPickedItems
FROM Sales.Invoices 
     INNER JOIN (SELECT InvoiceId
					   ,SUM(Quantity*UnitPrice) AS TotalSumm
				 FROM   Sales.InvoiceLines
				 GROUP BY InvoiceId
				 HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC



-- ver. 1
;WITH InvoiceLines AS
(
	SELECT InvoiceId
		  ,SUM(Quantity*UnitPrice) AS TotalSumm
	FROM   Sales.InvoiceLines
	GROUP BY InvoiceId
)
,OrderLines AS
(
	SELECT ol.OrderID
		  ,SUM(ol.PickedQuantity * ol.UnitPrice)    AS TotalSummForPickedItems
	FROM   Sales.OrderLines ol
		   INNER JOIN Sales.Orders o  ON o.OrderId   = ol.OrderId
	WHERE  o.PickingCompletedWhen IS NOT NULL
	GROUP BY ol.OrderID		   
)
SELECT  i.InvoiceID
	   ,i.InvoiceDate
	   ,p.FullName                        AS   SalesPersonName
	   ,il.TotalSumm                      AS   TotalSummByInvoice
	   ,ol.TotalSummForPickedItems
FROM Sales.Invoices i
	 INNER JOIN Application.People p ON p.PersonID   = i.SalespersonPersonID
     INNER JOIN InvoiceLines il      ON il.InvoiceID = i.InvoiceID 
	 INNER JOIN OrderLines ol        ON ol.OrderID   = i.OrderID
WHERE il.TotalSumm > 27000 
ORDER BY TotalSumm DESC


-- ver. 2 (faster)
;WITH InvoiceLines AS
(
	SELECT InvoiceId
		  ,SUM(Quantity*UnitPrice) AS TotalSumm
	FROM   Sales.InvoiceLines
	GROUP BY InvoiceId
)
SELECT  i.InvoiceID
	   ,i.InvoiceDate
	   ,p.FullName                                                     AS   SalesPersonName
	   ,il.TotalSumm                                                   AS   TotalSummByInvoice
	   ,(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		 FROM   Sales.OrderLines 
		 WHERE  OrderLines.OrderId = o.OrderID)                        AS TotalSummForPickedItems
FROM Sales.Invoices i
	 INNER JOIN Application.People p ON p.PersonID   = i.SalespersonPersonID
     INNER JOIN InvoiceLines il      ON il.InvoiceID = i.InvoiceID 
	 INNER JOIN Sales.Orders o       ON o.OrderID   = i.OrderID
WHERE o.PickingCompletedWhen IS NOT NULL 
	  AND TotalSumm > 27000
ORDER BY TotalSumm DESC
