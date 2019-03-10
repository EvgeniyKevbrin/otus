--Поставщиков, у которых не было сделано ни одного заказа (потом покажем как это делать через подзапрос, сейчас сделайте через JOIN)

SELECT s.SupplierName
FROM   [Purchasing].[Suppliers] s
LEFT JOIN [Purchasing].[SupplierTransactions] t ON t.SupplierID = s.SupplierID
WHERE  t.SupplierID IS NULL

