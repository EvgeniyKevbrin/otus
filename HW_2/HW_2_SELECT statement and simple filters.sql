--1. Все товары, в которых в название есть пометка urgent или название начинается с Animal
SELECT [StockItemName]
FROM   [WideWorldImporters].[Warehouse].[StockItems]
WHERE  ([StockItemName] LIKE 'Animal%') 
    OR ([StockItemName] LIKE '%urgent%')


--2. Поставщиков, у которых не было сделано ни одного заказа (потом покажем как это делать через подзапрос, сейчас сделайте через JOIN)

SELECT s.SupplierName
FROM   [Purchasing].[Suppliers] s
LEFT JOIN [Purchasing].[SupplierTransactions] t ON t.SupplierID = s.SupplierID
WHERE  t.SupplierID IS NULL


/*
3. Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа,
включите также к какой трети года относится дата - каждая треть по 4 месяца, дата забора заказа должна быть задана,
с ценой товара более 100$ либо количество единиц товара более 20.
Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей.
Соритровка должна быть по номеру квартала, трети года, дате продажи. 
*/

SELECT i.InvoiceId, InvoiceDate
	  ,DATENAME(month, InvoiceDate)                                  AS    MonthOfName
	  ,DATEPART(qq, InvoiceDate)                                     AS    Quater
	  ,CASE
	  		WHEN DATEPART(mm, InvoiceDate) IN (1,2,3,4) THEN 1     
	  		WHEN DATEPART(mm, InvoiceDate) IN (5,6,7,8) THEN 2
	  		ELSE 3 
	   END                                                           AS    Third
FROM   [Sales].[Invoices] i
	   INNER JOIN [Sales].[InvoiceLines] l ON l.InvoiceId = i.InvoiceId
WHERE  l.UnitPrice  > 100 OR l.Quantity > 20
ORDER  BY Quater, Third, i.InvoiceDate
OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY;

/* 4.  Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post
,добавьте название поставщика, имя контактного лица принимавшего заказ*/

SELECT o.PurchaseOrderID
	  ,s.SupplierName
	  ,p.FullName    AS ContactName
FROM   [Purchasing].[PurchaseOrders] o
INNER JOIN  [Application].[DeliveryMethods] m ON m.DeliveryMethodID = o.DeliveryMethodID
INNER JOIN  [Purchasing].[Suppliers] s        ON s.SupplierID = o.SupplierID
INNER JOIN  [Application].[People] p          ON p.PersonID = o.ContactPersonID
WHERE  YEAR(OrderDate) = 2014
	   AND (m.DeliveryMethodName = 'Road Freight' OR m.DeliveryMethodName = 'Post')


-- 5. 10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ.

SELECT TOP(10) InvoiceID
			  ,InvoiceDate
			  ,CustomerName
			  ,FullName AS ContactName
FROM   [Sales].[Invoices] i
INNER JOIN [Sales].[Customers] c ON c.CustomerID = i.CustomerID
INNER JOIN [Application].[People] p ON p.PersonID = i.ContactPersonID
ORDER  BY i.InvoiceDate DESC

-- 6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g

SELECT i.CustomerID
	  ,CustomerName
	  ,PhoneNumber
FROM   [Warehouse].[StockItems] si
INNER JOIN [Sales].[InvoiceLines] il ON il.StockItemID = si.StockItemID
INNER JOIN [Sales].[Invoices] i ON i.InvoiceID = il.InvoiceID
INNER JOIN [Sales].[Customers] c ON c.CustomerID = i.CustomerID
WHERE  StockItemName = 'Chocolate frogs 250g'