-- 2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса. 


-- 1-й способ
SELECT *
FROM   [Warehouse].[StockItems]
WHERE  UnitPrice = (SELECT MIN(UnitPrice) FROM  [Warehouse].[StockItems])


--2-й способ
SELECT *
FROM   [Warehouse].[StockItems]
WHERE  UnitPrice  <= ALL (SELECT UnitPrice FROM  [Warehouse].[StockItems])


/* 3. Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей 
   из [Sales].[CustomerTransactions] представьте 3 способа (в том числе с CTE) */

-- 1-й способ
SELECT TOP(5) c.CustomerName, t.TransactionAmount
FROM   [Sales].[CustomerTransactions] t
       INNER JOIN [Sales].[Customers] c ON c.CustomerID = t.CustomerID
ORDER BY TransactionAmount DESC

--2-й способ
;WITH Transactions AS
(
	SELECT t.CustomerID
	      ,t.TransactionAmount
		  ,ROW_NUMBER() OVER (ORDER BY t.TransactionAmount DESC) AS row_num
	FROM   [Sales].[CustomerTransactions] t
)
SELECT c.CustomerName, t.TransactionAmount
FROM   [Sales].[Customers] c
	   INNER JOIN Transactions t ON c.CustomerID = t.CustomerID
WHERE  row_num <= 5

-- 3-й способ
SELECT c.CustomerName, t.TransactionAmount
FROM   [Sales].[CustomerTransactions] t
       INNER JOIN [Sales].[Customers] c ON c.CustomerID = t.CustomerID
WHERE  t.TransactionAmount >= ANY (	SELECT TOP(5) t.TransactionAmount
									FROM   [Sales].[CustomerTransactions] t
									ORDER  BY t.TransactionAmount DESC)

/*4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также Имя сотрудника, который осуществлял упаковку заказов*/

;WITH UnitPrice AS
(
	SELECT TOP(3) OrderId
	FROM   [Sales].[OrderLines] 
	ORDER  BY UnitPrice DESC
)
SELECT city.CityID
	  ,CityName
	  ,p.FullName
FROM   [Sales].[Orders] o
		INNER JOIN [Sales].[Customers] c ON c.CustomerID = o.CustomerID
		INNER JOIN [Application].[People] p ON p.PersonID = o.SalespersonPersonID
		INNER JOIN [Application].[Cities] city ON city.CityID = c.DeliveryCityID
		INNER JOIN UnitPrice up                   ON up.OrderID = o.OrderID

