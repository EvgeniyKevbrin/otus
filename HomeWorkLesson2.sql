--Все товары, в которых в название есть пометка urgent или название начинается с Animal
SELECT [InvoiceLineID]
      ,[InvoiceID]
      ,[StockItemID]
      ,[Description]
      ,[PackageTypeID]
      ,[Quantity]
      ,[UnitPrice]
      ,[TaxRate]
      ,[TaxAmount]
      ,[LineProfit]
      ,[ExtendedPrice]
      ,[LastEditedBy]
      ,[LastEditedWhen]
  FROM [WideWorldImporters].[Sales].[InvoiceLines]
  WHERE    (Description LIKE 'Animal%') 
        OR (Description LIKE '%urgent%')