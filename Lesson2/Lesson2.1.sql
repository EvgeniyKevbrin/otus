--1. Все товары, в которых в название есть пометка urgent или название начинается с Animal
SELECT [StockItemName]
FROM   [WideWorldImporters].[Warehouse].[StockItems]
WHERE  ([StockItemName] LIKE 'Animal%') 
    OR ([StockItemName] LIKE '%urgent%')