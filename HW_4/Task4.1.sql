-- 1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.

-- лучший план выполнения показывает этот вариант
;WITH SalesPersons AS
(
	SELECT p.PersonID, p.FullName
	FROM   [Application].[People] p
	WHERE  IsSalesperson = 1
)
SELECT * 
FROM   [Sales].[Invoices] i 
	   LEFT JOIN [Sales].[Orders] o ON o.OrderID = i.OrderID
WHERE  i.OrderID IS NULL

-- NOT IN

SELECT *
FROM   [Sales].[Orders]
WHERE  SalespersonPersonID NOT IN (	SELECT p.PersonID
									FROM   [Application].[People] p
									WHERE  IsSalesperson = 1)

-- NOT EXISTS 

SELECT *
FROM   [Sales].[Orders] o
WHERE  NOT EXISTS  (	SELECT p.PersonID
						FROM   [Application].[People] p
						WHERE  IsSalesperson = 1 
							   AND p.PersonID = o.SalespersonPersonID  )


