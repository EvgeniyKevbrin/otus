--2. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)

;WITH SUM_cte AS (
	SELECT DISTINCT StockItemName
	,YEAR(TransactionOccurredWhen)  AS TransactionYear
	,MONTH(TransactionOccurredWhen) AS TransactionMonth
	,SUM(Quantity) OVER (PARTITION BY StockItemName, YEAR(TransactionOccurredWhen), MONTH(TransactionOccurredWhen) ) AS SumByStockItemName
	FROM   [Warehouse].[StockItems] s
		   INNER JOIN [Warehouse].[StockItemTransactions] t ON t.StockItemID = s.StockItemID
	WHERE t.TransactionOccurredWhen BETWEEN '2016-01-01' AND '2017-01-01' 
), ROW_NUMBER_cte AS
(
	SELECT *
	      ,ROW_NUMBER() OVER (PARTITION BY TransactionYear, TransactionMonth ORDER BY SumByStockItemName DESC)  AS R_N
	FROM SUM_cte
)
SELECT *
FROM   ROW_NUMBER_cte
WHERE  R_N <=2


