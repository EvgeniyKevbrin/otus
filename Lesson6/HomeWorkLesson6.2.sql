--2. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)

;WITH cte AS (
	SELECT s.StockItemName
		  ,t.TransactionOccurredWhen
		  ,ROW_NUMBER() OVER (PARTITION BY DATEADD(mm, DATEDIFF(month, 0, TransactionOccurredWhen),0), StockItemName ORDER BY TransactionOccurredWhen) R_N
	FROM   [Warehouse].[StockItems] s
		   INNER JOIN [Warehouse].[StockItemTransactions] t ON t.StockItemID = s.StockItemID
	WHERE t.TransactionOccurredWhen BETWEEN '2016-01-01' AND '2017-01-01' 
),  item_count_by_month  AS
(
	SELECT *
	      ,MAX(R_N) OVER (PARTITION BY DATEADD(mm, DATEDIFF(month, 0, TransactionOccurredWhen),0), StockItemName) AS MaxItemMonthValue
	      ,DATEADD(mm, DATEDIFF(month, 0, TransactionOccurredWhen),0) AS [Month]
	FROM cte
 ), count_items_without_duplicates AS
 (
	SELECT DISTINCT StockItemName,MaxItemMonthValue, [Month]
	FROM   item_count_by_month
 ), item_ordering AS
 (
	SELECT DISTINCT StockItemName,MaxItemMonthValue, [Month]
		  ,ROW_NUMBER() OVER (PARTITION BY [Month] ORDER BY MaxItemMonthValue DESC) AS R_N
	FROM count_items_without_duplicates

 )
 SELECT StockItemName, MaxItemMonthValue, [Month], R_N
 FROM   item_ordering
 WHERE  R_N <=2
 ORDER BY [Month]