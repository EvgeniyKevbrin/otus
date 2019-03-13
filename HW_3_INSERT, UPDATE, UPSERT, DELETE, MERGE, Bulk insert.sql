-- Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers
INSERT INTO [WideWorldImporters].[Sales].[Customers](  CustomerID
													  ,[CustomerName]
													  ,[BillToCustomerID]
													  ,[CustomerCategoryID]
													  ,[BuyingGroupID]
													  ,[PrimaryContactPersonID]
													  ,[AlternateContactPersonID]
													  ,[DeliveryMethodID]
													  ,[DeliveryCityID]
													  ,[PostalCityID]
													  ,[CreditLimit]
													  ,[AccountOpenedDate]
													  ,[StandardDiscountPercentage]
													  ,[IsStatementSent]
													  ,[IsOnCreditHold]
													  ,[PaymentDays]
													  ,[PhoneNumber]
													  ,[FaxNumber]
													  ,[DeliveryRun]
													  ,[RunPosition]
													  ,[WebsiteURL]
													  ,[DeliveryAddressLine1]
													  ,[DeliveryAddressLine2]
													  ,[DeliveryPostalCode]
													  ,[DeliveryLocation]
													  ,[PostalAddressLine1]
													  ,[PostalAddressLine2]
													  ,[PostalPostalCode]
													  ,[LastEditedBy])
SELECT TOP (5) CustomerID + 10
      ,CONCAT([CustomerName], '_duplicate') AS [CustomerName]
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy]
  FROM [WideWorldImporters].[Sales].[Customers]
  ORDER BY CustomerID DESC

  SELECT *
    FROM [WideWorldImporters].[Sales].[Customers]
  ORDER BY CustomerID DESC
--  удалите 1 запись из Customers, которая была вами добавлена

  DELETE
  FROM  [WideWorldImporters].[Sales].[Customers]
  WHERE CustomerID = (SELECT MAX(CustomerID) FROM [WideWorldImporters].[Sales].[Customers])

-- изменить одну запись, из добавленных через UPDATE
UPDATE [WideWorldImporters].[Sales].[Customers]
SET CustomerName = CONCAT([CustomerName], '_UPDATED') 
WHERE CustomerID = (SELECT CustomerID
					FROM   [WideWorldImporters].[Sales].[Customers]
					ORDER BY CustomerID DESC OFFSET 3 ROWS FETCH NEXT 1  ROWS ONLY	 
					)

--Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть

; WITH NewCustomers AS
(
	SELECT (CustomerID + 10) AS CustomerID
		  ,CONCAT([CustomerName], '_MERGED_INSERTED') AS [CustomerName]
		  ,[BillToCustomerID]
		  ,[CustomerCategoryID]
		  ,[BuyingGroupID]
		  ,[PrimaryContactPersonID]
		  ,[AlternateContactPersonID]
		  ,[DeliveryMethodID]
		  ,[DeliveryCityID]
		  ,[PostalCityID]
		  ,[CreditLimit]
		  ,[AccountOpenedDate]
		  ,[StandardDiscountPercentage]
		  ,[IsStatementSent]
		  ,[IsOnCreditHold]
		  ,[PaymentDays]
		  ,[PhoneNumber]
		  ,[FaxNumber]
		  ,[DeliveryRun]
		  ,[RunPosition]
		  ,[WebsiteURL]
		  ,[DeliveryAddressLine1]
		  ,[DeliveryAddressLine2]
		  ,[DeliveryPostalCode]
		  ,[DeliveryLocation]
		  ,[PostalAddressLine1]
		  ,[PostalAddressLine2]
		  ,[PostalPostalCode]
		  ,[LastEditedBy]
  FROM [WideWorldImporters].[Sales].[Customers]
  ORDER BY CustomerID DESC OFFSET 4 ROWS FETCH NEXT 5 ROWS ONLY
)
MERGE [WideWorldImporters].[Sales].[Customers] AS [target]
USING NewCustomers  AS [source]
ON ([source].CustomerId = [target].CustomerId)
WHEN NOT MATCHED BY TARGET THEN 
INSERT ( CustomerID
		,[CustomerName]
		,[BillToCustomerID]
		,[CustomerCategoryID]
		,[BuyingGroupID]
		,[PrimaryContactPersonID]
		,[AlternateContactPersonID]
		,[DeliveryMethodID]
		,[DeliveryCityID]
		,[PostalCityID]
		,[CreditLimit]
		,[AccountOpenedDate]
		,[StandardDiscountPercentage]
		,[IsStatementSent]
		,[IsOnCreditHold]
		,[PaymentDays]
		,[PhoneNumber]
		,[FaxNumber]
		,[DeliveryRun]
		,[RunPosition]
		,[WebsiteURL]
		,[DeliveryAddressLine1]
		,[DeliveryAddressLine2]
		,[DeliveryPostalCode]
		,[DeliveryLocation]
		,[PostalAddressLine1]
		,[PostalAddressLine2]
		,[PostalPostalCode]
		,[LastEditedBy])
VALUES ( [source].CustomerID
		,[source].[CustomerName]
		,[source].[BillToCustomerID]
		,[source].[CustomerCategoryID]
		,[source].[BuyingGroupID]
		,[source].[PrimaryContactPersonID]
		,[source].[AlternateContactPersonID]
		,[source].[DeliveryMethodID]
		,[source].[DeliveryCityID]
		,[source].[PostalCityID]
		,[source].[CreditLimit]
		,[source].[AccountOpenedDate]
		,[source].[StandardDiscountPercentage]
		,[source].[IsStatementSent]
		,[source].[IsOnCreditHold]
		,[source].[PaymentDays]
		,[source].[PhoneNumber]
		,[source].[FaxNumber]
		,[source].[DeliveryRun]
		,[source].[RunPosition]
		,[source].[WebsiteURL]
		,[source].[DeliveryAddressLine1]
		,[source].[DeliveryAddressLine2]
		,[source].[DeliveryPostalCode]
		,[source].[DeliveryLocation]
		,[source].[PostalAddressLine1]
		,[source].[PostalAddressLine2]
		,[source].[PostalPostalCode]
		,[source].[LastEditedBy])
WHEN MATCHED THEN
UPDATE SET [target].[CustomerName] = REPLACE([source].[CustomerName], '_MERGED_INSERTED','_MERGED_UPDATED') ;


-- Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert

EXEC sp_configure 'show advanced options', 1;
GO

RECONFIGURE
GO

EXEC sp_configure 'xp_cmdshell', 1;
GO

RECONFIGURE
GO

exec master..xp_cmdshell 'bcp "[WideWorldImporters].[Sales].[Customers]" out "c:\Customers.txt" -T -w -t'

